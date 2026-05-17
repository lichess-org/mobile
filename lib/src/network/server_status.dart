import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:logging/logging.dart';

final _logger = Logger('ServerStatus');

final serverStatusProvider = NotifierProvider<ServerStatusNotifier, bool>(ServerStatusNotifier.new);

class ServerStatusNotifier extends Notifier<bool> {
  Timer? _outageTimer;

  @override
  bool build() {
    final pool = ref.watch(socketPoolProvider);

    pool.averageLag.addListener(_onLagChange);
    ref.onDispose(() {
      pool.averageLag.removeListener(_onLagChange);
      _outageTimer?.cancel();
    });

    // Assume reachable on startup; the lag listener handles state changes.
    return true;
  }

  void _onLagChange() {
    final pool = ref.read(socketPoolProvider);
    if (pool.averageLag.value == Duration.zero) {
      // Lag dropped to zero — start the outage timer.
      // Only show outage after 30s of continuous disconnection to avoid
      // false positives during normal reconnects (~22.5s per failed cycle:
      // 9s ping timeout + 3.5s reconnect delay + 10s connect timeout).
      _outageTimer ??= Timer(const Duration(seconds: 30), () {
        _logger.warning('Server unreachable for 30s, marking as offline.');
        state = false;
      });
    } else {
      // Connection restored — cancel the outage timer and mark as online.
      if (_outageTimer != null) {
        _logger.info('Server reachable again.');
      }
      _outageTimer?.cancel();
      _outageTimer = null;
      state = true;
    }
  }
}
