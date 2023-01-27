import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartchess/dartchess.dart';
import 'package:result_extensions/result_extensions.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/common/sound.dart';
import '../../data/game_repository.dart';
import '../../data/game_event.dart';
import '../../model/game_state.dart';

final positionCursorProvider = StateProvider.autoDispose<int>((ref) => 0);

final isBoardTurnedProvider = StateProvider.autoDispose<bool>((ref) => false);

final gameStateProvider =
    AutoDisposeNotifierProvider<GameStateNotifier, GameState?>(
        GameStateNotifier.new);

final gameActionProvider =
    AutoDisposeNotifierProvider<GameActionNotifier, AsyncValue<void>>(
        GameActionNotifier.new);

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

class GameActionNotifier extends AutoDisposeNotifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() {
    return const AsyncData(null);
  }

  Future<void> abort(GameId id) async {
    state = const AsyncLoading();
    state = await ref.read(gameRepositoryProvider).abortTask(id).fold(
          AsyncValue.data,
          (error, trace) =>
              AsyncValue.error(error, trace ?? StackTrace.current),
        );
  }

  Future<void> resign(GameId id) async {
    state = const AsyncLoading();
    state = await ref.read(gameRepositoryProvider).resignTask(id).fold(
          AsyncValue.data,
          (error, trace) =>
              AsyncValue.error(error, trace ?? StackTrace.current),
        );
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
      final resp = await gameRepository.playMoveTask(gameId, move);
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
