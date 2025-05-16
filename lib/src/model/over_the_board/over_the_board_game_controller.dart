import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/chess960.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/service/move_feedback.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/material_diff.dart';
import 'package:lichess_mobile/src/model/game/over_the_board_game.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'over_the_board_game_controller.freezed.dart';
part 'over_the_board_game_controller.g.dart';

@riverpod
class OverTheBoardGameController extends _$OverTheBoardGameController {
  @override
  OverTheBoardGameState build() => OverTheBoardGameState.fromVariant(
    Variant.standard,
    Speed.fromTimeIncrement(const TimeIncrement(0, 0)),
  );

  void startNewGame(Variant variant, TimeIncrement timeIncrement) {
    state = OverTheBoardGameState.fromVariant(variant, Speed.fromTimeIncrement(timeIncrement));
  }

  void rematch() {
    state = OverTheBoardGameState.fromVariant(state.game.meta.variant, state.game.meta.speed);
  }

  void resign() {
    state = state.copyWith(
      game: state.game.copyWith(status: GameStatus.resign, winner: state.turn.opposite),
    );
  }

  void draw() {
    state = state.copyWith(game: state.game.copyWith(status: GameStatus.draw));
  }

  void makeMove(NormalMove move) {
    if (isPromotionPawnMove(state.currentPosition, move)) {
      state = state.copyWith(promotionMove: move);
      return;
    }

    final (newPos, newSan) = state.currentPosition.makeSan(Move.parse(move.uci)!);
    final sanMove = SanMove(newSan, move);
    final newStep = GameStep(
      position: newPos,
      sanMove: sanMove,
      diff: MaterialDiff.fromBoard(newPos.board),
    );

    // In an over-the-board game, we support "implicit takebacks":
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

    // check for threefold repetition
    if (state.game.steps.count((p) => p.position.board == newStep.position.board) == 3) {
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

    _moveFeedback(sanMove);
  }

  void onPromotionSelection(Role? role) {
    if (role == null) {
      state = state.copyWith(promotionMove: null);
      return;
    }
    final promotionMove = state.promotionMove;
    if (promotionMove != null) {
      final move = promotionMove.withPromotion(role);
      makeMove(move);
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
      state = state.copyWith(stepCursor: state.stepCursor + 1);
    }
  }

  void goBack() {
    if (state.canGoBack) {
      state = state.copyWith(stepCursor: state.stepCursor - 1);
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
sealed class OverTheBoardGameState with _$OverTheBoardGameState {
  const OverTheBoardGameState._();

  const factory OverTheBoardGameState({
    required OverTheBoardGame game,
    @Default(0) int stepCursor,
    @Default(null) NormalMove? promotionMove,
  }) = _OverTheBoardGameState;

  factory OverTheBoardGameState.fromVariant(Variant variant, Speed speed) {
    final position =
        variant == Variant.chess960 ? randomChess960Position() : variant.initialPosition;
    return OverTheBoardGameState(
      game: OverTheBoardGame(
        steps: [GameStep(position: position)].lock,
        status: GameStatus.started,
        initialFen: position.fen,
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
