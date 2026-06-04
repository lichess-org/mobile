import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:logging/logging.dart';

final _logger = Logger('ServerStatus');

final serverStatusProvider = NotifierProvider<ServerStatusNotifier, bool>(ServerStatusNotifier.new);

class ServerStatusNotifier extends Notifier<bool> {
  @override
  bool build() {
    final pool = ref.watch(socketPoolProvider);
    pool.averageLag.addListener(_onLagChange);
    ref.onDispose(() => pool.averageLag.removeListener(_onLagChange));
    return true;
  }

  void _onLagChange() {
    final lag = ref.read(socketPoolProvider).averageLag.value;
    if (lag != Duration.zero && !state) {
      _logger.info('WebSocket reconnected, marking server as reachable again.');
      state = true;
    }
  }

  /// Called by the HTTP client when a response is received from the lichess server.
  ///
  /// A 502 or 503 response indicates the server is down (maintenance or unreachable).
  /// Any successful response (2xx/3xx) restores the online state.
  void handleHttpResponse(int statusCode, Uri uri) {
    if (!_isLichessUri(uri)) return;

    if (statusCode == 502 || statusCode == 503) {
      if (state) {
        _logger.warning('Received HTTP $statusCode from lichess, marking server as down.');
        state = false;
      }
    } else if (statusCode >= 200 && statusCode < 400) {
      if (!state) {
        _logger.info('Lichess server reachable again (HTTP $statusCode).');
        state = true;
      }
    }
  }

  bool _isLichessUri(Uri uri) => uri.host == kLichessHost.split(':').first;
}
