import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

final _logger = Logger('ServerStatus');

/// The availability of the lichess main server.
enum ServerStatus {
  /// The lichess server is up.
  up,

  /// The lichess server is undergoing planned maintenance (HTTP 503).
  maintenance,

  /// The lichess server is unreachable (HTTP 502).
  down,
}

/// The current [ServerStatus] of the lichess main server.
///
/// See [ServerStatusNotifier] for how this is determined.
final serverStatusProvider = NotifierProvider<ServerStatusNotifier, ServerStatus>(
  ServerStatusNotifier.new,
  name: 'ServerStatusProvider',
);

/// Tracks the availability of the lichess main server.
///
/// The state is derived exclusively from the HTTP status codes returned by the lichess main
/// server: its frontend servers answer with a 503 during planned maintenance and a 502 when the
/// backend is unreachable, so those two codes are the only reliable indication of an outage.
/// Responses from the opening explorer, the tablebase or the CDN are never taken into account, as
/// those run on their own servers.
class ServerStatusNotifier extends Notifier<ServerStatus> {
  /// The server is assumed to be up until a response says otherwise.
  @override
  ServerStatus build() => ServerStatus.up;

  /// Called by [ConnectivityChangesNotifier] when the app is resumed.
  ///
  /// Assumes the server is back up, so that the widgets needing it are rebuilt and make their
  /// requests again. If the server is still unavailable the next response puts us back in the
  /// outage state, which is how the website behaves too.
  void onAppResumed() {
    if (state != ServerStatus.up) {
      _logger.info('App resumed, assuming the lichess server is reachable again.');
      state = ServerStatus.up;
    }
  }

  /// Called by [LichessClient] for every response received from the lichess main server.
  ///
  /// Client errors are ignored: a 404 or a 401 says nothing about the health of the server, so
  /// they must neither trigger nor clear an outage.
  void handleHttpResponse(int statusCode) {
    final newStatus = switch (statusCode) {
      502 => ServerStatus.down,
      503 => ServerStatus.maintenance,
      >= 200 && < 400 => ServerStatus.up,
      _ => null,
    };

    if (newStatus == null || newStatus == state) return;

    if (newStatus == ServerStatus.up) {
      _logger.info('Lichess server reachable again (HTTP $statusCode).');
    } else {
      _logger.warning('Received HTTP $statusCode from lichess, server status: ${newStatus.name}.');
    }
    state = newStatus;
  }
}
