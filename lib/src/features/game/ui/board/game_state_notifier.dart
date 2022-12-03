import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/common/sound.dart';
import '../../data/game_repository.dart';
import '../../domain/game_state.dart';

class GameStateNotifier extends AutoDisposeNotifier<GameState?> {
  @override
  GameState? build() {
    return null;
  }

  onGameStateEvent(Map<String, dynamic> json) {
    final newState = GameState.fromJson(json);
    final fen = newState.position.fen;
    if (fen != kInitialFEN && fen != state?.position.fen) {
      final soundService = ref.read(soundServiceProvider);
      if (newState.isLastMoveCapture) {
        soundService.playCapture();
      } else {
        soundService.playMove();
      }
    }
    state = newState;
  }

  onUserMove(GameId gameId, Move move) async {
    final gameRepository = ref.read(gameRepositoryProvider);
    final savedState = state;
    if (state != null) {
      final newPos = state!.position.playToSan(move);
      state = state!.copyWith(
        position: newPos.item1,
        uciMoves: List.unmodifiable([...state!.uciMoves, move.uci]),
        sanMoves: List.unmodifiable([...state!.sanMoves, newPos.item2]),
      );
      final soundService = ref.read(soundServiceProvider);
      if (state!.isLastMoveCapture) {
        soundService.playCapture();
      } else {
        soundService.playMove();
      }
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
