import 'dart:math';

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/chess960.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/local_game_clock.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/service/move_feedback.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/material_diff.dart';
import 'package:lichess_mobile/src/model/game/over_the_board_game.dart';
import 'package:lichess_mobile/src/model/over_the_board/over_the_board_clock.dart';

part 'over_the_board_game_controller.freezed.dart';

final _random = Random();

final overTheBoardGameControllerProvider =
    NotifierProvider.autoDispose<OverTheBoardGameController, OverTheBoardGameState>(
      OverTheBoardGameController.new,
      name: 'OverTheBoardGameControllerProvider',
    );

class OverTheBoardGameController extends Notifier<OverTheBoardGameState> {
  /// The clock of the game, which only runs when the game is played with a time control.
  LocalGameClock get _clock => ref.read(overTheBoardClockProvider.notifier);

  @override
  OverTheBoardGameState build() =>
      OverTheBoardGameState.fromVariant(Variant.standard, const TimeIncrement.infinite());

  void startNewGame(Variant variant, TimeIncrement timeIncrement, {String? initialFen}) {
    state = OverTheBoardGameState.fromVariant(variant, timeIncrement, initialFen: initialFen);
  }

  void loadOngoingGame(OverTheBoardGame game, TimeIncrement timeIncrement) {
    // A game saved before the time control was part of its metadata carries it alongside instead,
    // so the saved value is what fills the gap — a rematch reads the time control off the game.
    final meta = game.meta.clock == null && !timeIncrement.isInfinite
        ? game.meta.copyWith(clock: clockMetaOf(timeIncrement))
        : game.meta;
    state = OverTheBoardGameState(
      game: game.copyWith(meta: meta),
      stepCursor: game.steps.length - 1,
    );
  }

  void rematch() {
    state = OverTheBoardGameState.fromVariant(
      state.game.meta.variant,
      state.game.timeIncrement,
      initialFen: state.game.initialFen,
    );
  }

  void resign() {
    state = state.copyWith(
      game: state.game.copyWith(status: GameStatus.resign, winner: state.turn.opposite),
    );
  }

  void draw() {
    state = state.copyWith(game: state.game.copyWith(status: GameStatus.draw));
  }

  void makeMove(Move move) {
    final (newPos, newSan) = state.currentPosition.makeSan(Move.parse(move.uci)!);
    final sanMove = SanMove(newSan, move);
    final movedSide = state.currentPosition.turn;

    // The clock changes hands before the step is built, so that the step records the time the
    // mover is left with once their increment has been added — the same reading lichess stores.
    _clock.onMove(newSideToMove: newPos.turn);

    final newStep = GameStep(
      position: newPos,
      sanMove: sanMove,
      diff: MaterialDiff.fromPosition(newPos),
      clock: ref.read(overTheBoardClockProvider).timeLeft(movedSide),
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
    } else if (state.currentPosition.variantOutcome != null) {
      switch (state.currentPosition.variantOutcome!.winner) {
        case Side.white:
          state = state.copyWith(
            game: state.game.copyWith(status: GameStatus.variantEnd, winner: Side.white),
          );
        case Side.black:
          state = state.copyWith(
            game: state.game.copyWith(status: GameStatus.variantEnd, winner: Side.black),
          );
        case null:
          state = state.copyWith(game: state.game.copyWith(status: GameStatus.variantEnd));
      }
    } else if (state.currentPosition.isStalemate) {
      state = state.copyWith(game: state.game.copyWith(status: GameStatus.stalemate));
    } else if (state.currentPosition.isInsufficientMaterial) {
      state = state.copyWith(game: state.game.copyWith(status: GameStatus.draw));
    }

    // Don't let the clock keep running on a game-ending move.
    if (!state.game.playable) {
      _clock.pause();
    }

    _moveFeedback(sanMove);
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
      ref
          .read(moveFeedbackServiceProvider)
          .captureFeedback(state.game.meta.variant, check: isCheck);
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
  }) = _OverTheBoardGameState;

  factory OverTheBoardGameState.fromVariant(
    Variant variant,
    TimeIncrement timeIncrement, {
    String? initialFen,
  }) {
    final Position position;
    final Variant effectiveVariant;
    if (initialFen != null) {
      effectiveVariant = variant == Variant.standard ? Variant.fromPosition : variant;
      position = Position.setupPosition(effectiveVariant.rule, Setup.parseFen(initialFen));
    } else if (variant == Variant.chess960) {
      position = randomChess960Position();
      effectiveVariant = variant;
    } else {
      position = variant.initialPosition;
      effectiveVariant = variant;
    }
    final sessionId = StringId('otb_${_random.nextInt(1 << 32).toRadixString(16).padLeft(8, '0')}');
    final speed = Speed.fromTimeIncrement(timeIncrement);
    return OverTheBoardGameState(
      game: OverTheBoardGame(
        id: sessionId,
        steps: [GameStep(position: position)].lock,
        status: GameStatus.started,
        initialFen: initialFen,
        meta: GameMeta(
          createdAt: DateTime.now(),
          rated: false,
          variant: effectiveVariant,
          speed: speed,
          perf: Perf.fromVariantAndSpeed(effectiveVariant, speed),
          clock: clockMetaOf(timeIncrement),
        ),
      ),
    );
  }

  Position get currentPosition => game.stepAt(stepCursor).position;
  Side get turn => currentPosition.turn;
  bool get finished => game.finished;
  Move? get lastMove =>
      stepCursor > 0 ? Move.parse(game.steps[stepCursor].sanMove!.move.uci) : null;

  MaterialDiffSide? currentMaterialDiff(Side side) {
    return game.steps[stepCursor].diff?.bySide(side);
  }

  List<String> get moves => game.steps.skip(1).map((e) => e.sanMove!.san).toList(growable: false);

  bool get canGoForward => stepCursor < game.steps.length - 1;
  bool get canGoBack => stepCursor > 0;
}
