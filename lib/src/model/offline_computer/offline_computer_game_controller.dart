import 'dart:async';
import 'dart:math';

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/service/move_feedback.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/material_diff.dart';
import 'package:lichess_mobile/src/model/game/offline_computer_game.dart';
import 'package:lichess_mobile/src/model/game/player.dart';

part 'offline_computer_game_controller.freezed.dart';

final _random = Random();

final offlineComputerGameControllerProvider =
    NotifierProvider.autoDispose<OfflineComputerGameController, OfflineComputerGameState>(
      OfflineComputerGameController.new,
      name: 'OfflineComputerGameControllerProvider',
    );

class OfflineComputerGameController extends Notifier<OfflineComputerGameState> {
  @override
  OfflineComputerGameState build() {
    final evaluationService = ref.watch(evaluationServiceProvider);
    ref.onDispose(() {
      evaluationService.quit();
    });
    return OfflineComputerGameState.initial(
      stockfishLevel: StockfishLevel.defaultLevel,
      playerSide: Side.white,
    );
  }

  void startNewGame({
    required StockfishLevel stockfishLevel,
    required Side playerSide,
    required bool casual,
  }) {
    state = OfflineComputerGameState.initial(
      stockfishLevel: stockfishLevel,
      playerSide: playerSide,
      casual: casual,
    );

    // If computer plays first (player is black), trigger engine move
    if (playerSide == Side.black) {
      _playEngineMove();
    } else if (casual) {
      // Player plays first, precompute hints (only in casual mode)
      _computeHints();
    }
  }

  /// Load an ongoing game from storage.
  void loadOngoingGame(OfflineComputerGame game) {
    state = OfflineComputerGameState(
      game: game,
      gameSessionId: StringId('ocg_${_random.nextInt(1 << 32).toRadixString(16).padLeft(8, '0')}'),
      stepCursor: game.steps.length - 1,
    );

    // If it's the player's turn and game is still playable, precompute hints (only in casual mode)
    if (game.playable && state.turn == game.playerSide && game.casual) {
      _computeHints();
    }
    // If it's the engine's turn and game is still playable, trigger engine move
    else if (game.playable && state.turn != game.playerSide) {
      _playEngineMove();
    }
  }

  void makeMove(NormalMove move) {
    if (state.isEngineThinking || !state.game.playable) return;

    if (isPromotionPawnMove(state.currentPosition, move)) {
      state = state.copyWith(promotionMove: move);
      return;
    }

    _applyMove(move);

    // If game is still playable, trigger engine response
    if (state.game.playable) {
      _playEngineMove();
    }
  }

  void onPromotionSelection(Role? role) {
    if (role == null) {
      state = state.copyWith(promotionMove: null);
      return;
    }
    final promotionMove = state.promotionMove;
    if (promotionMove != null) {
      final move = promotionMove.withPromotion(role);
      state = state.copyWith(promotionMove: null);
      _applyMove(move);

      // If game is still playable, trigger engine response
      if (state.game.playable) {
        _playEngineMove();
      }
    }
  }

  void _applyMove(NormalMove move) {
    final (newPos, newSan) = state.currentPosition.makeSan(Move.parse(move.uci)!);
    final sanMove = SanMove(newSan, move);
    final newStep = GameStep(
      position: newPos,
      sanMove: sanMove,
      diff: MaterialDiff.fromBoard(newPos.board),
    );

    _clearHints();

    state = state.copyWith(
      game: state.game.copyWith(steps: state.game.steps.add(newStep)),
      stepCursor: state.stepCursor + 1,
    );

    // Check for threefold repetition
    if (state.game.steps.count((p) => p.position.board == newStep.position.board) == 3) {
      state = state.copyWith(game: state.game.copyWith(isThreefoldRepetition: true));
    } else {
      state = state.copyWith(game: state.game.copyWith(isThreefoldRepetition: false));
    }

    // Check for game end conditions
    if (state.currentPosition.isCheckmate) {
      state = state.copyWith(
        game: state.game.copyWith(status: GameStatus.mate, winner: state.turn.opposite),
      );
    } else if (state.currentPosition.isStalemate) {
      state = state.copyWith(game: state.game.copyWith(status: GameStatus.stalemate));
    } else if (state.currentPosition.isInsufficientMaterial) {
      state = state.copyWith(game: state.game.copyWith(status: GameStatus.draw));
    }

    _moveFeedback(sanMove);
  }

  Future<void> _playEngineMove() async {
    if (!state.game.playable) return;

    state = state.copyWith(isEngineThinking: true);

    try {
      final evaluationService = ref.read(evaluationServiceProvider);
      final enginePrefs = ref.read(engineEvaluationPreferencesProvider);

      final steps = state.game.steps
          .skip(1)
          .map((s) => Step(position: s.position, sanMove: s.sanMove!))
          .toIList();

      final work = MoveWork(
        id: state.gameSessionId,
        enginePref: enginePrefs.enginePref,
        variant: Variant.standard,
        threads: enginePrefs.numEngineCores,
        hashSize: evaluationService.maxMemory,
        initialPosition: state.game.initialPosition,
        steps: steps,
        elo: state.game.stockfishLevel.elo,
      );

      final uciMove = await evaluationService.findMove(work);
      final move = NormalMove.fromUci(uciMove);

      if (state.game.playable) {
        _applyMove(move);
        // After engine move, precompute hints for player's turn
        if (state.game.playable) {
          _computeHints();
        }
      }
    } catch (e) {
      // Engine was stopped or error occurred, ignore
    } finally {
      if (state.game.playable || state.game.finished) {
        state = state.copyWith(isEngineThinking: false);
      }
    }
  }

  void resign() {
    if (!state.game.resignable) return;
    state = state.copyWith(
      game: state.game.copyWith(status: GameStatus.resign, winner: state.game.playerSide.opposite),
      isEngineThinking: false,
    );
  }

  void takeback() {
    if (!state.canTakeback || !state.game.casual) return;

    // Cancel any pending engine move
    ref.read(evaluationServiceProvider).stop();

    // Remove last two moves (player's move and engine's response if any)
    int stepsToRemove = 1;
    if (state.game.steps.length > 2 && state.turn == state.game.playerSide) {
      // If it's the player's turn, remove both moves
      stepsToRemove = 2;
    }

    final newSteps = state.game.steps.removeLast();
    final finalSteps = stepsToRemove == 2 && newSteps.length > 1 ? newSteps.removeLast() : newSteps;

    state = state.copyWith(
      game: state.game.copyWith(steps: finalSteps, isThreefoldRepetition: false),
      stepCursor: finalSteps.length - 1,
      isEngineThinking: false,
    );

    // If after takeback it's engine's turn, play engine move
    // Otherwise precompute hints for player's turn (only in casual mode)
    if (state.turn != state.game.playerSide && state.game.playable) {
      _playEngineMove();
    } else if (state.game.playable && state.game.casual) {
      _computeHints();
    }
  }

  void goForward() {
    if (state.canGoForward) {
      state = state.copyWith(stepCursor: state.stepCursor + 1, promotionMove: null);
    }
  }

  void goBack() {
    if (state.canGoBack) {
      state = state.copyWith(stepCursor: state.stepCursor - 1, promotionMove: null);
    }
  }

  /// Show or cycle through hints.
  ///
  /// Hints are precomputed when it's the player's turn (only in casual mode).
  /// This method just cycles through the available hints.
  void hint() {
    if (!state.game.casual) return;
    if (!state.game.playable || state.isEngineThinking || state.isLoadingHint) return;
    if (state.turn != state.game.playerSide) return;

    final existingHints = state.hintMoves;
    if (existingHints == null || existingHints.isEmpty) return;

    final currentIndex = state.hintIndex;
    // Show the first hint, or cycle to the next one
    if (currentIndex == null) {
      state = state.copyWith(hintIndex: 0);
    } else {
      state = state.copyWith(hintIndex: (currentIndex + 1) % existingHints.length);
    }
  }

  /// Precompute hints for the current position.
  ///
  /// Called automatically when it's the player's turn (only in casual mode).
  Future<void> _computeHints() async {
    if (!state.game.casual) return;
    if (!state.game.playable || state.turn != state.game.playerSide) return;

    state = state.copyWith(isLoadingHint: true, hintMoves: null, hintIndex: null);

    try {
      final evaluationService = ref.read(evaluationServiceProvider);
      final enginePrefs = ref.read(engineEvaluationPreferencesProvider);

      final steps = state.game.steps
          .skip(1)
          .map((s) => Step(position: s.position, sanMove: s.sanMove!))
          .toIList();

      const searchTime = Duration(seconds: 2);
      final work = EvalWork(
        id: state.gameSessionId,
        enginePref: enginePrefs.enginePref,
        variant: Variant.standard,
        threads: enginePrefs.numEngineCores,
        hashSize: evaluationService.maxMemory,
        searchTime: searchTime,
        multiPv: 5,
        threatMode: false,
        initialPosition: state.game.initialPosition,
        steps: steps,
      );

      final stream = evaluationService.evaluate(work, forceRestart: true);
      if (stream == null) {
        if (ref.mounted) {
          state = state.copyWith(isLoadingHint: false);
        }
        return;
      }

      // Listen to the stream and collect the latest eval
      // The stream doesn't complete on its own, so we use a timeout
      LocalEval? finalEval;
      try {
        await for (final (_, eval) in stream.timeout(
          searchTime + const Duration(milliseconds: 500),
        )) {
          finalEval = eval;
        }
      } on TimeoutException {
        // Expected - the stream times out after searchTime
        evaluationService.stop();
      }

      if (!ref.mounted) return;

      if (finalEval == null || !state.game.playable) {
        state = state.copyWith(isLoadingHint: false);
        return;
      }

      // Get best moves and filter out those that significantly drop the eval
      final bestMoves = finalEval.bestMoves;
      if (bestMoves.isEmpty) {
        state = state.copyWith(isLoadingHint: false);
        return;
      }

      final topWinningChances = bestMoves.first.winningChances;
      // Filter moves that don't drop eval by more than 0.1 (10% winning chances)
      // and keep only one move per origin square so hints cycle through different pieces
      final seenOrigins = <Square>{};
      final goodMoves = <Move>[];
      for (final m in bestMoves) {
        if (topWinningChances - m.winningChances > 0.1) continue;
        final origin = switch (m.move) {
          NormalMove(:final from) => from,
          DropMove() => null,
        };
        if (origin != null && !seenOrigins.contains(origin)) {
          seenOrigins.add(origin);
          goodMoves.add(m.move);
        }
      }

      // Shuffle to randomize the order, then convert to IList
      goodMoves.shuffle(_random);
      final hintMoves = goodMoves.toIList();

      state = state.copyWith(isLoadingHint: false, hintMoves: hintMoves);
    } catch (e) {
      if (ref.mounted) {
        state = state.copyWith(isLoadingHint: false);
      }
    }
  }

  /// Clear the current hints (called when a move is made).
  void _clearHints() {
    if (state.hintMoves != null || state.hintIndex != null) {
      state = state.copyWith(hintMoves: null, hintIndex: null);
    }
  }

  void _moveFeedback(SanMove sanMove) {
    final isCheck = sanMove.san.contains('+');
    if (sanMove.san.contains('x')) {
      ref.read(moveFeedbackServiceProvider).captureFeedback(check: isCheck);
    } else {
      ref.read(moveFeedbackServiceProvider).moveFeedback(check: isCheck);
    }
  }
}

@freezed
sealed class OfflineComputerGameState with _$OfflineComputerGameState {
  const OfflineComputerGameState._();

  const factory OfflineComputerGameState({
    required OfflineComputerGame game,
    required StringId gameSessionId,
    @Default(0) int stepCursor,
    @Default(null) NormalMove? promotionMove,
    @Default(false) bool isEngineThinking,
    @Default(false) bool isLoadingHint,

    /// The list of hint moves (up to 5), randomly ordered once computed.
    @Default(null) IList<Move>? hintMoves,

    /// Current hint index for cycling through hints. Null means no hint is shown yet.
    @Default(null) int? hintIndex,
  }) = _OfflineComputerGameState;

  factory OfflineComputerGameState.initial({
    required StockfishLevel stockfishLevel,
    required Side playerSide,
    bool casual = true,
  }) {
    const position = Chess.initial;
    final sessionId = StringId('ocg_${_random.nextInt(1 << 32).toRadixString(16).padLeft(8, '0')}');
    return OfflineComputerGameState(
      game: OfflineComputerGame(
        steps: [const GameStep(position: position)].lock,
        status: GameStatus.started,
        initialFen: kInitialFEN,
        meta: GameMeta(
          createdAt: DateTime.now(),
          rated: false,
          variant: Variant.standard,
          speed: Speed.classical,
          perf: Perf.classical,
        ),
        playerSide: playerSide,
        stockfishLevel: stockfishLevel,
        casual: casual,
        humanPlayer: const Player(onGame: true),
        enginePlayer: stockfishPlayer(),
      ),
      gameSessionId: sessionId,
    );
  }

  Position get currentPosition => game.stepAt(stepCursor).position;
  Side get turn => currentPosition.turn;
  bool get finished => game.finished;

  NormalMove? get lastMove =>
      stepCursor > 0 ? NormalMove.fromUci(game.steps[stepCursor].sanMove!.move.uci) : null;

  MaterialDiffSide? currentMaterialDiff(Side side) {
    return game.steps[stepCursor].diff?.bySide(side);
  }

  List<String> get moves => game.steps.skip(1).map((e) => e.sanMove!.san).toList(growable: false);

  bool get canGoForward => stepCursor < game.steps.length - 1;
  bool get canGoBack => stepCursor > 0;

  /// Player can take back if it's their turn and there are moves to take back.
  bool get canTakeback => game.playable && game.steps.length > 1 && !isEngineThinking;

  /// The square to highlight for the current hint.
  Square? get hintSquare {
    final moves = hintMoves;
    final index = hintIndex;
    if (moves == null || moves.isEmpty || index == null) return null;
    final move = moves[index];
    return switch (move) {
      NormalMove(:final from) => from,
      DropMove() => null,
    };
  }
}
