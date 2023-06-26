import 'dart:async';
import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:logging/logging.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/utils/string.dart';
import 'package:lichess_mobile/src/utils/package_info.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_client.dart';
import 'package:lichess_mobile/src/model/auth/bearer.dart';

part 'auth_socket.g.dart';

/// The native ping interval. This is different from the ping protocol of lichess.
const kNativePingInterval = Duration(seconds: 10);
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

/// WebSocket channel wrapper to authenticate with lichess
///
/// It automatically generate a new SRI for each connection.
/// It adds the following headers on connect:
///   - Authorization header when a token has been stored,
///   - User-Agent header
class AuthSocket {
  AuthSocket(this._ref, this._log);

  final Logger _log;
  final AuthSocketRef _ref;

  Timer? _pingTimer;
  int _pongCount = 0;
  DateTime? _lastPing;
  Duration _averageLag = Duration.zero;

  /// The current connection.
  ({
    String sri,
    Stream<SocketEvent> stream,
    IOWebSocketChannel channel,
  })? _connection;

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

    _pongCount = 0;
    _averageLag = Duration.zero;

    final session = _ref.read(authSessionProvider);
    final info = _ref.read(packageInfoProvider);
    final sri = genRandomString(12);
    final uri = Uri.parse('$kLichessWSHost$kWebSocketPath?sri=$sri');
    final bearer = session != null ? signBearerToken(session.token) : '';
    final headers = session != null
        ? {
            'Authorization': 'Bearer $bearer',
            'User-Agent': AuthClient.userAgent(info, session.user),
          }
        : {
            'User-Agent': AuthClient.userAgent(info, null),
          };

    _log.info('Creating WebSocket connection to $uri');

    final channel = IOWebSocketChannel.connect(
      uri,
      pingInterval: kNativePingInterval,
      connectTimeout: kDefaultConnectTimeout,
      headers: headers,
    );

    final Stream<SocketEvent> stream = channel.stream.map((raw) {
      if (raw == '0') {
        _handlePong(pingDelay);
        return SocketEvent.pong;
      }
      final event = SocketEvent.fromJson(
        jsonDecode(raw as String) as Map<String, dynamic>,
      );
      if (event.type == SocketEventType.pong) {
        _handlePong(pingDelay);
      }
      return event;
    }).asBroadcastStream();

    _schedulePing(pingDelay);

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

  void _schedulePing(Duration delay) {
    _pingTimer?.cancel();
    _pingTimer = Timer(delay, _sendPing);
  }

  /// Sends a ping to the server.
  void _sendPing() {
    _pingTimer?.cancel();
    sink?.add(
      _pongCount % 10 == 0
          ? jsonEncode({
              't': 'p',
              'l': _averageLag.inMilliseconds,
            })
          : 'p',
    );
    _lastPing = DateTime.now();
  }

  void _handlePong(Duration pingDelay) {
    if (_pongCount == 0) {
      _log.info('WebSocket connection established.');
    }
    _schedulePing(pingDelay);
    _pongCount++;
    final currentLag = DateTime.now().difference(_lastPing!);

    // Average first 4 pings, then switch to decaying average.
    final mix = _pongCount > 4 ? 0.1 : 1 / _pongCount;
    _averageLag += (currentLag - _averageLag) * mix;
  }

  /// Gets the current WebSocket sink
  WebSocketSink? get sink => _connection?.channel.sink;

  /// Gets the current SRI
  String? get sri => _connection?.sri;

  /// Closes the WebSocket connection, if open.
  void close() {
    if (_connection?.channel.closeCode == null) {
      _log.info('Closing WebSocket connection.');
    }
    sink?.close();
    _connection = null;
  }
}
