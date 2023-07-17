import 'dart:io';
import 'dart:math' as math;
import 'dart:async';
import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:logging/logging.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/http_client.dart';
import 'package:lichess_mobile/src/app_dependencies.dart';
import 'package:lichess_mobile/src/utils/package_info.dart';
import 'package:lichess_mobile/src/utils/device_info.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/auth/bearer.dart';

part 'auth_socket.g.dart';

const kDefaultConnectTimeout = Duration(seconds: 5);

const kDefaultWSRoute = '/socket/v5';

const kSRIStorageKey = 'socket_random_identifier';

/// The delay between the next ping after receiving a pong.
const _kPingDelay = Duration(milliseconds: 2500);

/// The maximum lag before considering the connection as lost.
const _kPingMaxLag = Duration(seconds: 9);
const _kAutoReconnectDelay = Duration(milliseconds: 3500);

/// Socket Random Identifier.
@Riverpod(keepAlive: true)
String sri(SriRef ref) {
  // requireValue is possible because appDependenciesProvider is loaded before
  // anything. See: lib/src/app.dart
  return ref.read(appDependenciesProvider).requireValue.sri;
}

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

typedef CurrentConnection = ({
  IOWebSocketChannel channel,
  Uri route,
  Completer<void> readyCompleter,
});

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
  Timer? _reconnectTimer;
  Timer? _switchReconnectTimer;
  Timer? _ackResendTimer;
  Timer? _closeTimer;
  int _pongCount = 0;
  DateTime _lastPing = DateTime.now();

  StreamSubscription<SocketEvent>? _streamSubscription;

  /// Socket event stream stream controller.
  late StreamController<SocketEvent> _streamController;

  /// The list of acknowledgeable messages.
  List<(DateTime, int, Map<String, dynamic>)> _acks = [];

  /// The current ack id. Incremented for each ack.
  int _ackId = 1;

  /// The current connection.
  CurrentConnection? _connection;

  /// Gets the current WebSocket sink
  WebSocketSink? get _sink => _connection?.channel.sink;

  /// The current socket route if connected.
  Uri? get route => _connection?.route;

  /// Returns the current socket stream if connected.
  Stream<SocketEvent>? get stream {
    if (_connection == null) {
      return null;
    }
    return _streamController.stream;
  }

  /// The Socket Random Identifier.
  String get sri => _ref.read(sriProvider);

  /// Creates a new WebSocket channel.
  ///
  /// If a connection already exists it will keep the current connection.
  ///
  /// Returns a tuple of:
  ///  - the socket event Stream
  ///  - a future that completes when the socket is ready on the route asked.
  ///    This future Will complete immediately if the socket is already connected on the same route.
  ///    The future might never complete if the socket fails to connect.
  (Stream<SocketEvent>, Future<void>) connect(Uri route) {
    // If a connection already exists, return the current stream and ensure
    // to switch to the new route if any.
    if (_connection != null && _connection!.channel.closeCode == null) {
      // If the route is different, switch to the new route while keeping the
      // current channel.
      if (route != _connection!.route) {
        _connection = (
          channel: _connection!.channel,
          route: route,
          readyCompleter: Completer<void>(),
        );
        _connection!.channel.ready.then((_) {
          _sink?.add(
            jsonEncode({
              't': 'switch',
              'd': {
                'uri': '${route.path}?sri=$sri',
              },
            }),
          );
          _scheduleReconnectForSwitch(route);
        });
      }

      return (_streamController.stream, _connection!.readyCompleter.future);
    }

    _closeTimer?.cancel();
    _acks = [];
    _ackId = 1;

    _streamController = StreamController<SocketEvent>.broadcast();

    final connection = _doConnect(route);

    return (_streamController.stream, connection.readyCompleter.future);
  }

  /// Connect or reconnect the WebSocket.
  CurrentConnection _doConnect(Uri route) {
    _doClose();
    _pongCount = 0;
    _switchReconnectTimer?.cancel();
    _reconnectTimer?.cancel();
    _ackResendTimer?.cancel();
    _ackResendTimer = Timer.periodic(
      const Duration(milliseconds: 1500),
      (_) => _resendAcks(),
    );

    final session = _ref.read(authSessionProvider);
    final pInfo = _ref.read(packageInfoProvider);
    final deviceInfo = _ref.read(deviceInfoProvider);
    final uri = Uri.parse('$kLichessWSHost$route?sri=$sri');
    final Map<String, String> headers = session != null
        ? {
            'Authorization': 'Bearer ${signBearerToken(session.token)}',
          }
        : {};
    WebSocket.userAgent = userAgent(pInfo, deviceInfo, sri, session?.user);

    _log.info('Creating WebSocket connection to $uri');

    final channel = IOWebSocketChannel.connect(
      uri,
      connectTimeout: kDefaultConnectTimeout,
      headers: headers,
    );

    _streamSubscription?.cancel();
    _streamSubscription = channel.stream.map((raw) {
      if (raw == '0') {
        return SocketEvent.pong;
      }
      return SocketEvent.fromJson(
        jsonDecode(raw as String) as Map<String, dynamic>,
      );
    }).listen(_handleEvent);

    _connection = (
      channel: channel,
      route: route,
      readyCompleter: Completer<void>(),
    );

    channel.ready.then(
      (_) {
        _log.info('WebSocket connection established.');
        _ref.read(averageLagProvider.notifier).reset();
        _sendPing();
        _resendAcks();
        _schedulePing(_kPingDelay);
        _connection?.readyCompleter.complete();
      },
      onError: (Object e) {
        _log.severe('WebSocket connection failed.', e);
        _ref.read(averageLagProvider.notifier).reset();
        if (_connection != null) {
          _scheduleReconnect(_kAutoReconnectDelay, _connection!.route);
        }
      },
    );

    return _connection!;
  }

  /// Sends a message to the websocket.
  void send(
    String topic,
    Object? data, {
    bool? ackable,
    bool? withLag,
  }) {
    Map<String, Object> message;

    if (ackable == true) {
      final ackId = _ackId++;
      message = {
        't': topic,
        'd': {
          if (data != null && data is Map<String, Object>) ...data,
          'a': ackId,
          if (withLag == true)
            'l': _ref.read(averageLagProvider).inMilliseconds,
        },
      };
      _acks.add((DateTime.now(), ackId, message));
    } else {
      message = {
        't': topic,
        if (data != null && data is Map<String, Object>)
          'd': {
            ...data,
            if (withLag == true)
              'l': _ref.read(averageLagProvider).inMilliseconds,
          }
        else if (data != null)
          'd': data,
      };
    }

    _sink?.add(jsonEncode(message));
  }

  void _handleEvent(SocketEvent event) {
    switch (event.topic) {
      case '_pong':
      case 'n':
        _handlePong(_kPingDelay);
      case 'ack':
        _onServerAck(event);
      case 'switch':
        _switchReconnectTimer?.cancel();
        final data = event.data as Map<String, dynamic>;
        final status = data['status'] as int;
        if (_connection?.readyCompleter.isCompleted == false) {
          if (status == 200) {
            _connection?.readyCompleter.complete();
            _log.info(
              'switch to new route ${data['uri']}',
            );
          } else {
            _connection?.readyCompleter
                .completeError('switch failed ($status)');
            _log.severe(
              'failed to switch to route ${data['uri']}, status: $status',
            );
          }
        } else {
          assert(
            false,
            'impossible state: switch event received after connection ready',
          );
        }
    }

    if (event != SocketEvent.pong) {
      _streamController.add(event);
    }
  }

  void _schedulePing(Duration delay) {
    _pingTimer?.cancel();
    _pingTimer = Timer(delay, _sendPing);
  }

  /// Sends a ping to the server.
  void _sendPing() {
    _sink?.add(
      _pongCount % 10 == 2
          ? jsonEncode({
              't': 'p',
              'l': (_ref.read(averageLagProvider).inMilliseconds * 0.1).round(),
            })
          : 'p',
    );
    _lastPing = DateTime.now();
    if (_connection != null) {
      _scheduleReconnect(_kPingMaxLag, _connection!.route);
    }
  }

  void _handlePong(Duration pingDelay) {
    _reconnectTimer?.cancel();
    if (_pongCount == 0) {
      _log.info('Ping/pong protocol established.');
    }
    _schedulePing(pingDelay);
    _pongCount++;
    final currentLag = Duration(
      milliseconds:
          math.min(DateTime.now().difference(_lastPing).inMilliseconds, 10000),
    );

    // Average first 4 pings, then switch to decaying average.
    final mix = _pongCount > 4 ? 0.1 : 1 / _pongCount;
    _ref.read(averageLagProvider.notifier).add(currentLag, mix);
  }

  void _scheduleReconnect(Duration delay, Uri route) {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, () {
      _doReconnect(route);
    });
  }

  void _scheduleReconnectForSwitch(Uri route) {
    _switchReconnectTimer?.cancel();
    _switchReconnectTimer = Timer(_kAutoReconnectDelay, () {
      _doReconnect(route);
    });
  }

  void _doReconnect(Uri route) {
    if (_connection != null) {
      _ref.read(averageLagProvider.notifier).reset();
      _log.info('Reconnecting WebSocket.');
      _doConnect(route);
    }
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
        _sink?.add(jsonEncode(ack));
      }
    }
  }

  /// Closes the WebSocket connection, if open.
  void close({Duration? delay}) {
    _log.info(
      'Closing WebSocket connection ${delay == null ? 'now' : 'in ${delay.inSeconds}s'}.',
    );
    _closeTimer?.cancel();
    _closeTimer = Timer(
      delay ?? Duration.zero,
      () => _doClose(() {
        _streamController.close();
      }),
    );
  }

  void _doClose([void Function()? callback]) {
    _sink?.close();
    _streamSubscription?.cancel();
    _pingTimer?.cancel();
    _switchReconnectTimer?.cancel();
    _reconnectTimer?.cancel();
    _ackResendTimer?.cancel();
    _connection = null;

    callback?.call();
  }
}
