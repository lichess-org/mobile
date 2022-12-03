import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/common/models.dart';
import '../../domain/game_state.dart';
import '../../data/game_repository.dart';
import './game_state_notifier.dart';

final gameStreamProvider =
    StreamProvider.autoDispose.family<GameClock, GameId>((ref, gameId) {
  final gameRepository = ref.watch(gameRepositoryProvider);
  final gameStateNotifier = ref.read(gameStateProvider.notifier);
  ref.onDispose(() {
    gameRepository.dispose();
  });
  return gameRepository
      .gameStateEvents(gameId)
      .where((event) =>
          event['type'] == 'gameFull' || event['type'] == 'gameState')
      .map((raw) {
    if (raw['type'] == 'gameFull') {
      gameStateNotifier.onGameStateEvent(raw['state']);
      return GameClock.fromJson(raw['state']);
    } else {
      gameStateNotifier.onGameStateEvent(raw);
      return GameClock.fromJson(raw);
    }
  });
});
