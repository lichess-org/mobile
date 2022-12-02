import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartchess/dartchess.dart';

import '../../data/game_repository.dart';
import '../../domain/game_state.dart';

class GameStateNotifier extends AutoDisposeNotifier<GameState?> {
  @override
  GameState? build() {
    return null;
  }

  onGameStateEvent(Map<String, dynamic> json) {
    state = GameState.fromJson(json);
  }

  onUserMove(String gameId, Move move) async {
    final gameRepository = ref.read(gameRepositoryProvider);
    final savedState = state;
    if (state != null) {
      final newPos = state!.position.playToSan(move);
      state = state!.copyWith(
        position: newPos.item1,
        uciMoves: List.unmodifiable([...state!.uciMoves, move.uci]),
        sanMoves: List.unmodifiable([...state!.sanMoves, newPos.item2]),
      );
      // TODO show error
      final resp = await gameRepository.playMove(gameId, move).run();
      if (resp.isLeft()) {
        state = savedState;
      }
    }
  }
}

final gameStateProvider =
    AutoDisposeNotifierProvider<GameStateNotifier, GameState?>(
        GameStateNotifier.new);
