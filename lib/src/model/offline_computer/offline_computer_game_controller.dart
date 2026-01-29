import 'dart:math';

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
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

  void startNewGame({required StockfishLevel stockfishLevel, required Side playerSide}) {
    state = OfflineComputerGameState.initial(stockfishLevel: stockfishLevel, playerSide: playerSide);

    // If computer plays first (player is black), trigger engine move
    if (playerSide == Side.black) {
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
        initialPosition: state.game.initialPosition,
        steps: steps,
        elo: state.game.stockfishLevel.elo,
      );

      final uciMove = await evaluationService.findMove(work);
      final move = NormalMove.fromUci(uciMove);

      if (state.game.playable) {
        _applyMove(move);
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
    ref.read(evaluationServiceProvider).quit();
  }

  void takeback() {
    if (!state.canTakeback) return;

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
    if (state.turn != state.game.playerSide && state.game.playable) {
      _playEngineMove();
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
  }) = _OfflineComputerGameState;

  factory OfflineComputerGameState.initial({
    required StockfishLevel stockfishLevel,
    required Side playerSide,
  }) {
    const position = Chess.initial;
    final sessionId = StringId(
      'ocg_${_random.nextInt(1 << 32).toRadixString(16).padLeft(8, '0')}',
    );
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
}
