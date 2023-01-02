import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/common/sound.dart';
import '../../data/game_repository.dart';
import '../../data/game_event.dart';
import '../../model/game_state.dart';
import './game_controls.dart';

class GameStateNotifier extends AutoDisposeNotifier<GameState?> {
  @override
  GameState? build() {
    return null;
  }

  void onGameStateEvent(GameStateEvent event) {
    final soundService = ref.read(soundServiceProvider);

    final newState = GameState.fromEvent(event);
    final fen = newState.position.fen;

    if (fen != kInitialFEN && fen != state?.position.fen) {
      _updateCursor(newState);

      if (newState.isLastMoveCapture) {
        soundService.playCapture();
      } else {
        soundService.playMove();
      }
    }

    if (state?.gameOver == false && newState.gameOver) {
      soundService.playDong();
    }

    state = newState;
  }

  Future<void> onUserMove(GameId gameId, Move move) async {
    final gameRepository = ref.read(gameRepositoryProvider);
    final savedState = state;
    if (state != null) {
      final newPos = state!.position.playToSan(move);
      final newState = state!.copyWith(
        positions: List.unmodifiable([...state!.positions, newPos.item1]),
        uciMoves: List.unmodifiable([...state!.uciMoves, move.uci]),
        sanMoves: List.unmodifiable([...state!.sanMoves, newPos.item2]),
      );

      _updateCursor(newState);

      final soundService = ref.read(soundServiceProvider);
      if (newState.isLastMoveCapture) {
        soundService.playCapture();
      } else {
        soundService.playMove();
      }

      state = newState;

      // TODO show error
      final resp = await gameRepository.playMoveTask(gameId, move).run();
      if (resp.isLeft()) {
        state = savedState;
      }
    }
  }

  void _updateCursor(GameState newState) {
    final cursor = ref.read(positionCursorProvider);
    final isReplaying = cursor < (state?.positionIndex ?? 0);
    if (!isReplaying && cursor < newState.positionIndex) {
      ref.read(positionCursorProvider.notifier).state++;
    }
  }
}

final gameStateProvider =
    AutoDisposeNotifierProvider<GameStateNotifier, GameState?>(
        GameStateNotifier.new);
