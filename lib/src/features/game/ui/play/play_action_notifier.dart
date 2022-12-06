import 'dart:async';
import 'package:dartchess/dartchess.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/features/user/domain/user.dart';
import '../../domain/game.dart';
import '../../service/create_game_service.dart';

class PlayActionNotifier extends AutoDisposeNotifier<AsyncValue<Game?>> {
  @override
  AsyncValue<Game?> build() {
    return const AsyncData(null);
  }

  Future<void> createGame({
    required User account,
    Side? side,
  }) async {
    final createGameService = ref.read(createGameServiceProvider);
    state = const AsyncLoading();
    state =
        (await (createGameService.aiGameTask(account, side: side).run())).match(
      (error) => AsyncValue.error(error.message, error.stackTrace),
      (game) => AsyncValue.data(game),
    );
  }
}

final playActionProvider =
    AutoDisposeNotifierProvider<PlayActionNotifier, AsyncValue<Game?>>(
        PlayActionNotifier.new);
