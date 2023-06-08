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

  /// The current WebSocket channel and SRI.
  (String, IOWebSocketChannel)? _connection;

  /// Creates a new WebSocket channel.
  ///
  /// Will not do anything if the channel is already connected.
  IOWebSocketChannel connect({
    Duration pingInterval = kDefaultPingInterval,
    Duration connectTimeout = kDefaultConnectTimeout,
  }) {
    if (_connection != null && _connection!.$2.closeCode == null) {
      return _connection!.$2;
    }

    final session = _ref.read(authSessionProvider);
    final info = _ref.read(packageInfoProvider);
    final sri = genRandomString(12);
    final uri = Uri.parse('$kLichessWSHost$kWebSocketPath?sri=$sri');
    final headers = session != null
        ? {
            'Authorization': 'Bearer ${session.token}',
            'User-Agent': AuthClient.userAgent(info, session.user),
          }
        : {
            'User-Agent': AuthClient.userAgent(info, null),
          };
    _log.info('Creating WebSocket connection to $uri');
    _connection = (
      sri,
      IOWebSocketChannel.connect(
        uri,
        pingInterval: pingInterval,
        connectTimeout: connectTimeout,
        headers: headers,
      )
    );
    return _connection!.$2;
  }

  /// Gets the current WebSocket channel
  IOWebSocketChannel? get channel => _connection?.$2;

  /// Gets the current SRI
  String? get sri => _connection?.$1;

  /// Closes the WebSocket connection.
  void close() {
    if (_connection?.$2.closeCode == null) {
      _log.info('Closing WebSocket connection.');
    }
    _connection?.$2.sink.close();
  }
}
