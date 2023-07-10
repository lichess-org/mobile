import 'dart:async';
import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:logging/logging.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/http_client.dart';
import 'package:lichess_mobile/src/utils/string.dart';
import 'package:lichess_mobile/src/utils/package_info.dart';
import 'package:lichess_mobile/src/utils/device_info.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/auth/bearer.dart';

part 'auth_socket.g.dart';

/// The native ping interval. This is different from the ping protocol of lichess.
const kNativePingInterval = Duration(seconds: 30);
const kDefaultConnectTimeout = Duration(seconds: 5);

const kWebSocketPath = '/socket/v5';

@Riverpod(keepAlive: true)
AuthSocket authSocket(AuthSocketRef ref) {
  final authSocket = AuthSocket(ref, Logger('AuthSocket'));
  ref.onDispose(() {
    authSocket.close();
  });
  return authSocket;
}

@riverpod
class AverageLag extends _$AverageLag {
  @override
  Duration build() => Duration.zero;

  void reset() {
    state = Duration.zero;
  }

  void add(Duration currentLag, double mix) {
    state += (currentLag - state) * mix;
  }
}

/// Lichess websocket client.
///
/// This class can only create one single connection, because we never want to
/// have more than one connection open at a time.
/// Calling several times [connect] will return the same stream.
///
/// Handles authentication:
///  - automatically generate a new SRI for each connection.
///  - adds the following headers on connect:
///   - Authorization header when a token has been stored,
///   - User-Agent header
///
/// Handles low-level ping/pong protocol and message acks.
class AuthSocket {
  AuthSocket(this._ref, this._log);

  final Logger _log;
  final AuthSocketRef _ref;

  Timer? _pingTimer;
  Timer? _ackResendTimer;
  Timer? _closeTimer;
  int _pongCount = 0;
  DateTime? _lastPing;

  /// The list of acknowledgeable messages.
  List<(DateTime, int, Map<String, dynamic>)> _acks = [];

  /// The current ack id. Incremented for each ack.
  int _ackId = 1;

  /// The current connection.
  ({
    String sri,
    Stream<SocketEvent> stream,
    IOWebSocketChannel channel,
  })? _connection;

  /// Gets the current WebSocket sink
  WebSocketSink? get sink => _connection?.channel.sink;

  /// Gets the current SRI
  String? get sri => _connection?.sri;

  /// Creates a new WebSocket channel.
  ///
  /// Will not do anything if the channel is already connected.
  Stream<SocketEvent> connect({
    /// The delay between the next ping after receiving a pong.
    Duration pingDelay = const Duration(seconds: 3),
  }) {
    if (_connection != null && _connection!.channel.closeCode == null) {
      return _connection!.stream;
    }

    _closeTimer?.cancel();

    _pongCount = 0;
    _acks = [];
    _ackId = 1;
    _ackResendTimer?.cancel();
    _ackResendTimer = Timer.periodic(
      const Duration(milliseconds: 1500),
      (_) => _resendAcks(),
    );

    final session = _ref.read(authSessionProvider);
    final pInfo = _ref.read(packageInfoProvider);
    final deviceInfo = _ref.read(deviceInfoProvider);
    final sri = genRandomString(12);
    final uri = Uri.parse('$kLichessWSHost$kWebSocketPath?sri=$sri');
    final bearer = session != null ? signBearerToken(session.token) : '';
    final headers = session != null
        ? {
            'Authorization': 'Bearer $bearer',
            'User-Agent': userAgent(pInfo, deviceInfo, session.user),
          }
        : {
            'User-Agent': userAgent(pInfo, deviceInfo, null),
          };

    _log.info('Creating WebSocket connection to $uri');

    final channel = IOWebSocketChannel.connect(
      uri,
      pingInterval: kNativePingInterval,
      connectTimeout: kDefaultConnectTimeout,
      headers: headers,
    );

    channel.ready.then((_) {
      _log.info('WebSocket connection established.');
      _ref.read(averageLagProvider.notifier).reset();
      _sendPing();
    });

    final Stream<SocketEvent> stream = channel.stream
        .map((raw) {
          if (raw == '0') {
            _handlePong(pingDelay);
            return SocketEvent.pong;
          }
          final event = SocketEvent.fromJson(
            jsonDecode(raw as String) as Map<String, dynamic>,
          );
          switch (event.topic) {
            case 'n':
              _handlePong(pingDelay);
            case 'ack':
              _onServerAck(event);
          }
          return event;
        })
        .where((event) => event != SocketEvent.pong)
        .asBroadcastStream();

    _connection = (
      sri: sri,
      stream: stream,
      channel: channel,
    );

    return _connection!.stream;
  }

  /// Switches the current WebSocket connection to a new route.
  ///
  /// Will not do anything if the channel is not connected.
  void switchRoute(Uri route) {
    sink?.add(
      jsonEncode({
        't': 'switch',
        'd': {
          'uri': '${route.path}?sri=$sri',
        },
      }),
    );
  }

  /// Sends a message to the websocket.
  void send(String topic, Object? data, {bool? ackable}) {
    Map<String, Object> message;

    if (ackable == true) {
      final ackId = _ackId++;
      message = {
        't': topic,
        'd': {
          if (data != null && data is Map<String, Object>) ...data,
          'a': ackId,
        },
      };
      _acks.add((DateTime.now(), ackId, message));
    } else {
      message = {
        't': topic,
        if (data != null) 'd': data,
      };
    }

    sink?.add(jsonEncode(message));
  }

  void _schedulePing(Duration delay) {
    _pingTimer?.cancel();
    _pingTimer = Timer(delay, _sendPing);
  }

  /// Sends a ping to the server.
  void _sendPing() {
    _pingTimer?.cancel();
    sink?.add(
      _pongCount % 10 == 2
          ? jsonEncode({
              't': 'p',
              'l': _ref.read(averageLagProvider).inMilliseconds,
            })
          : 'p',
    );
    _lastPing = DateTime.now();
  }

  void _handlePong(Duration pingDelay) {
    if (_pongCount == 0) {
      _log.info('Ping/pong protocol established.');
    }
    _schedulePing(pingDelay);
    _pongCount++;
    final currentLag = DateTime.now().difference(_lastPing!);

    // Average first 4 pings, then switch to decaying average.
    final mix = _pongCount > 4 ? 0.1 : 1 / _pongCount;
    _ref.read(averageLagProvider.notifier).add(currentLag, mix);
  }

  void _onServerAck(SocketEvent event) {
    if (event.data is! int) {
      return;
    }
    _acks.removeWhere((rec) => rec.$2 == event.data);
  }

  void _resendAcks() {
    final resendCutoff =
        DateTime.now().subtract(const Duration(milliseconds: 2500));
    for (final (at, _, ack) in _acks) {
      if (at.isBefore(resendCutoff)) {
        sink?.add(jsonEncode(ack));
      }
    }
  }

  /// Closes the WebSocket connection, if open.
  void close({Duration? delay}) {
    if (_connection?.channel.closeCode != null) {
      return;
    }
    _log.info(
      'Closing WebSocket connection ${delay == null ? 'now' : 'in ${delay.inSeconds}s'}.',
    );
    _closeTimer?.cancel();
    _closeTimer = Timer(delay ?? Duration.zero, () {
      sink?.close();
      _pingTimer?.cancel();
      _ackResendTimer?.cancel();
      _connection = null;
    });
  }
}
