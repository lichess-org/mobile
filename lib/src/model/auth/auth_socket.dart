import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:logging/logging.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/utils/string.dart';
import 'package:lichess_mobile/src/utils/package_info.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_client.dart';

part 'auth_socket.g.dart';

const kDefaultPingInterval = Duration(seconds: 10);
const kDefaultConnectTimeout = Duration(seconds: 5);

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
/// It adds the following headers on connect:
///   - Authorization header when a token has been stored,
///   - User-Agent header
class AuthSocket {
  AuthSocket(this._ref, this._log);

  final Logger _log;
  final AuthSocketRef _ref;

  IOWebSocketChannel? _channel;

  /// Creates a new WebSocket channel.
  ///
  /// Will close the previous channel if it exists.
  IOWebSocketChannel connect(
    String path, {
    Duration pingInterval = kDefaultPingInterval,
    Duration connectTimeout = kDefaultConnectTimeout,
  }) {
    _channel?.sink.close();

    final session = _ref.read(authSessionProvider);
    final info = _ref.read(packageInfoProvider);
    final uri = Uri.parse('$kLichessWSHost$path?sri=${genRandomString(12)}');
    final headers = session != null
        ? {
            'Authorization': 'Bearer ${session.token}',
            'User-Agent': AuthClient.userAgent(info, session.user),
          }
        : {
            'User-Agent': AuthClient.userAgent(info, null),
          };
    _log.info('Connecting to $uri');
    _channel = IOWebSocketChannel.connect(
      uri,
      pingInterval: pingInterval,
      connectTimeout: connectTimeout,
      headers: headers,
    );
    return _channel!;
  }

  /// Gets the current WebSocket channel.
  IOWebSocketChannel? get channel => _channel;

  /// Closes the WebSocket connection.
  void close() {
    if (_channel?.closeCode == null) {
      _log.info('Closing WebSocket connection');
    }
    _channel?.sink.close();
  }
}
