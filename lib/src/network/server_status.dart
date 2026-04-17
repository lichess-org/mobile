import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:logging/logging.dart';

final _logger = Logger('ServerStatus');

final serverStatusProvider = AsyncNotifierProvider<ServerStatusNotifier, bool>(
  ServerStatusNotifier.new,
);

class ServerStatusNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final timer = Timer.periodic(const Duration(seconds: 30), (_) => refresh());

    ref.onDispose(() => timer.cancel());
    return await _checkServerStatus();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(() => _checkServerStatus());
  }

  Future<bool> _checkServerStatus() async {
    try {
      final client = ref.read(defaultClientProvider);
      final response = await client.head(lichessUri('/'));
      final isReachable = response.statusCode == 200;
      _logger.info('Server reachable: $isReachable (status: ${response.statusCode})');
      return isReachable;
    } catch (e) {
      _logger.warning('Server unreachable: $e');
      return false;
    }
  }
}
