import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartchess/dartchess.dart';
import 'package:result_extensions/result_extensions.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/common/sound_service.dart';
import 'package:lichess_mobile/src/model/board/board_repository.dart';
import 'package:lichess_mobile/src/model/board/board_event.dart';
import 'package:lichess_mobile/src/model/board/game_state.dart';

final positionCursorProvider = StateProvider.autoDispose<int>((ref) => 0);

final isBoardTurnedProvider = StateProvider.autoDispose<bool>((ref) => false);

final boardStateProvider =
    AutoDisposeNotifierProvider<GameStateNotifier, GameState?>(
  GameStateNotifier.new,
);

final boardActionProvider =
    AutoDisposeNotifierProvider<BoardActionNotifier, AsyncValue<void>>(
  BoardActionNotifier.new,
);

final boardStreamProvider =
    StreamProvider.autoDispose.family<GameClock, GameId>((ref, gameId) {
  final boardRepository = ref.watch(boardRepositoryProvider);
  final gameStateNotifier = ref.read(boardStateProvider.notifier);
  ref.onDispose(() {
    boardRepository.dispose();
  });
  return boardRepository.gameStateEvents(gameId).map((event) {
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

class BoardActionNotifier extends AutoDisposeNotifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() {
    return const AsyncData(null);
  }

  Future<void> abort(GameId id) async {
    state = const AsyncLoading();
    state = (await ref.read(boardRepositoryProvider).abort(id)).asAsyncValue;
  }

  Future<void> resign(GameId id) async {
    state = const AsyncLoading();
    state = (await ref.read(boardRepositoryProvider).resign(id)).asAsyncValue;
  }
}

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
    final boardRepository = ref.read(boardRepositoryProvider);
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
      final resp = await boardRepository.playMove(gameId, move);
      if (resp.isError) {
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
