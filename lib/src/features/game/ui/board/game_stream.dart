import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/common/models.dart';
import '../../model/game_state.dart';
import '../../data/game_repository.dart';
import './game_state_notifier.dart';

final gameStreamProvider =
    StreamProvider.autoDispose.family<GameClock, GameId>((ref, gameId) {
  final gameRepository = ref.watch(gameRepositoryProvider);
  final gameStateNotifier = ref.read(gameStateProvider.notifier);
  ref.onDispose(() {
    gameRepository.dispose();
  });
  return gameRepository.gameStateEvents(gameId).map((event) {
    return event.map(
      gameFull: (gameFull) {
        gameStateNotifier.onGameStateEvent(gameFull.state);
        return GameClock.fromEvent(gameFull.state);
      },
      gameState: (gameState) {
        gameStateNotifier.onGameStateEvent(gameState);
        return GameClock.fromEvent(gameState);
      },
    );
  });
});
