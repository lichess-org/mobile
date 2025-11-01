import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/chess960.dart';
import 'package:lichess_mobile/src/model/common/game.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/service/move_feedback.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/computer/computer_game.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/material_diff.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'computer_controller.freezed.dart';
part 'computer_controller.g.dart';

@riverpod
class ComputerGameController extends _$ComputerGameController {
  @override
  ComputerGameState build() {
    ref.onDispose(() {
      ref.read(evaluationServiceProvider).disposeEngine();
    });

    state = ComputerGameState.fromUserChoice(
      StockfishLevel.one,
      SideChoice.white,
      Variant.standard,
    );

    // start initializing the engine
    ref.read(evaluationServiceProvider).ensureEngineInitialized(state.evaluationContext);

    if (state.game.youAre == Side.black) {
      _playComputerMove();
    }

    return state;
  }

  void _onNewGame() {
    ref.read(evaluationServiceProvider).newGame();
    if (state.game.youAre == Side.black) {
      _playComputerMove();
    }
  }

  void _playMove(Move move, {bool isFromComputer = false}) {
    final (newPos, newSan) = state.currentPosition.makeSan(move);
    final sanMove = SanMove(newSan, move);
    final newStep = GameStep(
      position: newPos,
      sanMove: sanMove,
      diff: MaterialDiff.fromBoard(newPos.board),
    );

    // to fix: if user goes through move list while computer is thinking, state is updated which breaks computer move
    if (isFromComputer) {
      state = state.copyWith(
        game: state.game.copyWith(steps: state.game.steps.add(newStep)),
        stepCursor: state.stepCursor + 1,
      );
    } else {
      // In an offline computer game, we support "implicit takebacks":
      // When going back one or more steps (i.e. stepCursor < game.steps.length - 1),
      // a new move can be made, removing all steps after the current stepCursor.
      state = state.copyWith(
        game: state.game.copyWith(
          steps: state.game.steps
              .removeRange(state.stepCursor + 1, state.game.steps.length)
              .add(newStep),
        ),
        stepCursor: state.stepCursor + 1,
      );
    }

    _checkGameResults();
    _moveFeedback(sanMove);
  }

  Future<void> _playComputerMove() async {
    await ref.read(evaluationServiceProvider).ensureEngineInitialized(state.evaluationContext);

    final move = await ref
        .read(evaluationServiceProvider)
        .startMoveWork(
          MoveWork(fen: state.game.lastPosition.fen, level: state.game.level, clock: null),
        );

    // maybe should show that variant is not supported ?
    if (move == null) return;

    _playMove(move, isFromComputer: true);
  }

  void _checkGameResults() {
    // check for threefold repetition
    if (state.game.steps.count((p) => p.position.board == state.game.lastPosition.board) == 3) {
      state = state.copyWith(game: state.game.copyWith(isThreefoldRepetition: true));
    } else {
      state = state.copyWith(game: state.game.copyWith(isThreefoldRepetition: false));
    }

    if (state.currentPosition.isCheckmate) {
      state = state.copyWith(
        game: state.game.copyWith(status: GameStatus.mate, winner: state.turn.opposite),
      );
    } else if (state.currentPosition.isStalemate) {
      state = state.copyWith(game: state.game.copyWith(status: GameStatus.stalemate));
    }
  }

  void startNewGame(StockfishLevel level, SideChoice side, Variant variant) {
    state = ComputerGameState.fromUserChoice(level, side, variant);
    _onNewGame();
  }

  void rematch() {
    state = ComputerGameState.fromUserChoice(
      state.game.level,
      state.game.sideChoice,
      state.game.meta.variant,
    );
    _onNewGame();
  }

  void resign() {
    state = state.copyWith(
      game: state.game.copyWith(status: GameStatus.resign, winner: state.turn.opposite),
    );
  }

  void draw() {
    state = state.copyWith(game: state.game.copyWith(status: GameStatus.draw));
  }

  Future<void> onUserMove(NormalMove move) async {
    if (isPromotionPawnMove(state.currentPosition, move)) {
      state = state.copyWith(promotionMove: move);
      return;
    }

    _playMove(move);

    if (!state.finished) {
      return _playComputerMove();
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
      onUserMove(move);
      state = state.copyWith(promotionMove: null);
    }
  }

  void onFlag(Side side) {
    state = state.copyWith(
      game: state.game.copyWith(status: GameStatus.outoftime, winner: side.opposite),
    );
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
sealed class ComputerGameState with _$ComputerGameState {
  const ComputerGameState._();

  const factory ComputerGameState({
    required ComputerGame game,
    required EvaluationContext evaluationContext,
    @Default(0) int stepCursor,
    @Default(null) NormalMove? promotionMove,
  }) = _ComputerGameState;

  factory ComputerGameState.fromUserChoice(
    StockfishLevel level,
    SideChoice sideChoice,
    Variant variant,
  ) {
    // check if we can get rid of speed and perf
    // this is not an online game and time is unlimited
    const speed = Speed.correspondence;
    final position = variant == Variant.chess960
        ? randomChess960Position()
        : variant.initialPosition;
    return ComputerGameState(
      evaluationContext: EvaluationContext(variant: variant, initialPosition: position),
      game: ComputerGame(
        steps: [GameStep(position: position)].lock,
        status: GameStatus.started,
        initialFen: position.fen,
        level: level,
        sideChoice: sideChoice,
        youAre: sideChoice.generateSide,
        meta: GameMeta(
          createdAt: DateTime.now(),
          rated: false,
          variant: variant,
          speed: speed,
          perf: Perf.fromVariantAndSpeed(variant, speed),
        ),
      ),
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
}
