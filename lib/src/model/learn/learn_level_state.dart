import 'dart:math';

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/learn/learn_assert.dart';
import 'package:lichess_mobile/src/model/learn/learn_level.dart';
import 'package:lichess_mobile/src/model/learn/learn_position.dart';
import 'package:lichess_mobile/src/model/learn/learn_score.dart';

part 'learn_level_state.freezed.dart';

/// What the controller must do after the player's move, once the new state is displayed.
enum LearnFollowUp() {
  none,

  /// Play the next scripted opponent move of the scenario.
  opponentScenarioMove,

  /// Play a random opponent move, to show why the player's move failed.
  randomOpponentMove,

  /// Play the opponent capture that failed the level, shown by [LearnLevelState.threatSquare].
  opponentCapture,
}

/// The result of a player's move.
typedef LearnMoveResult = ({LearnLevelState state, IList<Sound> sounds, LearnFollowUp followUp});

/// The state of a learn level being played.
///
/// This is the port of `ui/learn/src/levelCtrl.ts`, without the timers: transitions are pure and
/// report what should happen next, and the controller schedules it.
@freezed
sealed class const LearnLevelState._() with _$LearnLevelState {
  const factory({
    required LearnLevel level,
    required LearnPosition position,

    /// The apples still to collect.
    required ISet<Square> apples,
    @Default(0) int score,

    /// Number of moves the player has made.
    @Default(0) int nbMoves,

    /// Index of the next scenario step.
    @Default(0) int scenarioIndex,
    @Default(false) bool scenarioFailed,
    @Default(false) bool failed,
    @Default(false) bool completed,
    NormalMove? lastMove,
    CastlingSide? lastMoveCastling,
    required IList<LearnShape> shapes,

    /// The king square to highlight as being in check.
    Square? checkSquare,

    /// The square of an opponent piece about to capture, when the level failed because of it.
    Square? threatSquare,

    /// The opponent capture that failed the level.
    NormalMove? threatMove,
  }) = _LearnLevelState;

  /// The initial state of [level].
  ///
  /// Unless the level says otherwise, an enemy pawn is placed on each apple so that taking the apple
  /// is a capture.
  factory initial(LearnLevel level) {
    final start = level.position;
    final applePawn = Piece(color: start.turn.opposite, role: Role.pawn);
    final position = level.emptyApples
        ? start
        : level.apples.fold(start, (pos, square) => pos.withPieceAt(square, applePawn));
    return LearnLevelState(
      level: level,
      position: position,
      apples: level.apples,
      shapes: level.shapes,
      checkSquare: position.isCheck ? position.board.kingOf(position.turn) : null,
    );
  }

  bool get isAppleLevel => level.apples.isNotEmpty;

  /// The board to display, without the enemy pawns hidden under the apples.
  String get displayFen => level.emptyApples
      ? position.boardFen
      : apples.fold(position.board, (board, square) => board.removePieceAt(square)).fen;

  bool get scenarioComplete => scenarioIndex == level.scenario.length;

  bool get isOver => failed || completed;

  /// Whether the player can move.
  bool get isPlayerTurn => !isOver && position.turn == level.color;

  /// Whether the next move is a scripted opponent move.
  bool get isOpponentScenarioTurn =>
      !isOver && position.turn != level.color && scenarioIndex < level.scenario.length;

  /// The destinations of the player's pieces.
  Map<Square, Set<Square>> get playerDests {
    if (!isPlayerTurn) return const {};
    final result = <Square, Set<Square>>{};
    for (final from in position.board.bySide(position.turn).squares) {
      final dests = position.destsOf(from, illegal: level.offerIllegalMove);
      if (dests.isEmpty) continue;
      final destSet = dests.squares.toSet();
      if (from == position.board.kingOf(position.turn)) {
        for (final side in CastlingSide.values) {
          final rook = position.castles.rookOf(position.turn, side);
          if (rook != null && dests.has(rook)) destSet.add(kingCastlesTo(position.turn, side));
        }
      }
      result[from] = destSet;
    }
    return result;
  }

  /// Plays the player's [move], following the order of `makeSendMove` in `levelCtrl.ts`.
  LearnMoveResult playerMove(NormalMove move) {
    final player = level.color;
    final newNbMoves = nbMoves + 1;
    final captured = position.capturedPieceOf(move);
    final castling = position.castlingSideOf(move);
    final after = position.playUnchecked(move);
    final lastMove = castling != null ? _castlingDisplayMove(move, castling) : move;

    if (after.isKingAttacked(player)) {
      final king = after.board.kingOf(player)!;
      return (
        state: copyWith(
          position: after,
          nbMoves: newNbMoves,
          lastMove: lastMove,
          lastMoveCastling: castling,
          failed: true,
          checkSquare: king,
          threatSquare: null,
          shapes: after
              .moves()
              .where((m) => m.to == king)
              .map((m) => LearnShape(orig: m.from, dest: m.to, brush: .red))
              .toIList(),
        ),
        sounds: const IListConst([Sound.learnFailure]),
        followUp: LearnFollowUp.none,
      );
    }

    var newScore = score;
    var newApples = apples;
    var took = false;
    if (apples.contains(move.to)) {
      newScore += kLearnAppleScore;
      newApples = apples.remove(move.to);
      took = true;
    }
    if (!took && captured != null && level.pointsForCapture && captured.role != Role.king) {
      newScore += level.showPieceValues ? learnPieceValue(captured.role) : kLearnCaptureScore;
      took = true;
    }

    var newShapes = shapes;
    Square? newCheckSquare;
    if (after.isCheck) {
      newCheckSquare = after.board.kingOf(after.turn);
      newShapes = after
          .withTurn(player)
          .moves()
          .where((m) => m.to == newCheckSquare)
          .map((m) => LearnShape(orig: m.from, dest: m.to, brush: .yellow))
          .toIList();
    }

    final sounds = <Sound>[];
    var newScenarioIndex = scenarioIndex;
    var newScenarioFailed = scenarioFailed;
    var inScenario = false;
    var newFailed = false;
    NormalMove? capture;
    final step = scenarioIndex < level.scenario.length ? level.scenario[scenarioIndex] : null;
    if (step != null && step.move == move) {
      newScenarioIndex++;
      newShapes = step.shapes;
      newScore += kLearnScenarioScore;
      inScenario = true;
    } else {
      if (step != null) newScenarioFailed = true;
      capture = switch (level.detectCapture) {
        DetectCapture.none => null,
        DetectCapture.unprotected => _findUnprotectedCapture(after),
        DetectCapture.any => _findCapture(after),
      };
      if (capture != null) sounds.add(Sound.learnFailure);
      final failure = level.failure;
      final failedAssert =
          failure != null &&
          failure(
            LearnAssertData(
              position: after,
              nbMoves: newNbMoves,
              scenarioComplete: newScenarioIndex == level.scenario.length,
              scenarioFailed: newScenarioFailed,
              lastMoveCastling: castling,
            ),
          );
      if (capture == null && failedAssert) sounds.add(Sound.learnFailure);
      newFailed = capture != null || failedAssert;
    }

    if (isAppleLevel) newShapes = const IListConst([]);

    var next = copyWith(
      position: after,
      apples: newApples,
      score: newScore,
      nbMoves: newNbMoves,
      scenarioIndex: newScenarioIndex,
      scenarioFailed: newScenarioFailed,
      failed: newFailed,
      lastMove: lastMove,
      lastMoveCastling: castling,
      shapes: newShapes,
      checkSquare: newCheckSquare,
      threatSquare: capture?.from,
      threatMove: capture,
    );

    if (!newFailed) {
      final success = level.success;
      final data = LearnAssertData(
        position: after,
        nbMoves: newNbMoves,
        scenarioComplete: next.scenarioComplete,
        scenarioFailed: newScenarioFailed,
        lastMoveCastling: castling,
      );
      final succeeded = success != null ? success(data) : newApples.isEmpty;
      if (succeeded) {
        return (
          state: next.copyWith(
            completed: true,
            score: newScore + learnLevelBonus(level, newNbMoves),
          ),
          sounds: sounds.lock,
          followUp: LearnFollowUp.none,
        );
      }
    }

    sounds.add((!newFailed && took) || inScenario ? Sound.learnTake : Sound.move);

    if (newFailed) {
      return (
        state: next,
        sounds: sounds.lock,
        followUp: capture != null
            ? LearnFollowUp.opponentCapture
            : level.showFailureFollowUp
            ? LearnFollowUp.randomOpponentMove
            : LearnFollowUp.none,
      );
    }

    if (!inScenario) {
      next = next.copyWith(position: after.withTurn(player));
    }

    return (
      state: next,
      sounds: sounds.lock,
      followUp: inScenario && next.isOpponentScenarioTurn
          ? LearnFollowUp.opponentScenarioMove
          : LearnFollowUp.none,
    );
  }

  /// Plays the next scripted opponent move.
  LearnLevelState opponentScenarioMove() {
    if (!isOpponentScenarioTurn) return this;
    final step = level.scenario[scenarioIndex];
    final after = position.playUnchecked(step.move);
    if (after.isKingAttacked(position.turn)) {
      return copyWith(position: after, lastMove: step.move, scenarioFailed: true);
    }
    return copyWith(
      position: after,
      lastMove: step.move,
      lastMoveCastling: null,
      scenarioIndex: scenarioIndex + 1,
      shapes: step.shapes,
      checkSquare: after.isCheck ? after.board.kingOf(after.turn) : null,
    );
  }

  /// Plays a random move for the opponent, after the level failed.
  LearnLevelState randomOpponentMove(Random random) {
    final moves = position.moves().toList();
    if (moves.isEmpty) return this;
    final move = moves[random.nextInt(moves.length)];
    return copyWith(
      position: position.playUnchecked(move),
      lastMove: move,
      shapes: const IListConst([]),
    );
  }

  /// Plays the opponent capture that failed the level.
  LearnLevelState opponentCapture() {
    final move = threatMove;
    if (move == null) return this;
    return copyWith(
      position: position.playUnchecked(move),
      lastMove: move,
      threatSquare: null,
      threatMove: null,
      shapes: const IListConst([]),
    );
  }

  /// The king moving two squares, which is how the board shows castling.
  NormalMove _castlingDisplayMove(NormalMove move, CastlingSide side) =>
      NormalMove(from: move.from, to: kingCastlesTo(level.color, side));

  /// Captures available to the side to move of [pos].
  Iterable<NormalMove> _captures(LearnPosition pos) =>
      pos.moves().where((m) => pos.capturedPieceOf(m) != null);

  NormalMove? _findCapture(LearnPosition pos) => _captures(pos).firstOrNull;

  /// A capture after which the other side cannot take back on the same square.
  NormalMove? _findUnprotectedCapture(LearnPosition pos) {
    for (final capture in _captures(pos)) {
      final after = pos.playUnchecked(capture);
      if (!_captures(after).any((m) => m.to == capture.to)) return capture;
    }
    return null;
  }
}
