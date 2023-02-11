import 'dart:async';
import 'package:dartchess/dartchess.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'create_game_service.dart';

class PlayActionNotifier
    extends AutoDisposeNotifier<AsyncValue<PlayableGame?>> {
  @override
  AsyncValue<PlayableGame?> build() {
    return const AsyncData(null);
  }

  Future<void> createGame({
    required User account,
    Side? side,
  }) async {
    final createGameService = ref.read(createGameServiceProvider);
    state = const AsyncLoading();
    state = (await createGameService.aiGame(account, side: side)).asAsyncValue;
  }
}

final playActionProvider =
    AutoDisposeNotifierProvider<PlayActionNotifier, AsyncValue<PlayableGame?>>(
  PlayActionNotifier.new,
);
