import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/offline_computer/practice_analyser.dart';
import 'package:lichess_mobile/src/model/offline_computer/practice_comment.dart';

part 'practice_goal.freezed.dart';

/// Where a practice chapter played against the engine stands.
enum PracticeStatus() {
  /// Not decided yet, including when the eval is not deep enough to tell.
  ongoing,

  /// The goal was reached.
  solved,

  /// The goal can no longer be reached, or the last move threw it away.
  failed,
}

/// What the player must achieve in a practice chapter played against the engine.
///
/// Ported from lila's `PracticeGoal`, which derives it from the chapter's `Termination` tag.
/// Move counts are the player's moves, not plies.
@freezed
sealed class const PracticeGoal._() with _$PracticeGoal {
  /// Checkmate the opponent, in any number of moves.
  const factory mate() = PracticeGoalMate;

  /// Checkmate the opponent within [moves] moves.
  const factory mateIn({required int moves}) = PracticeGoalMateIn;

  /// Hold the draw for [moves] moves.
  const factory drawIn({required int moves}) = PracticeGoalDrawIn;

  /// Reach an equal position within [moves] moves. Judged like [PracticeGoal.drawIn].
  const factory equalIn({required int moves}) = PracticeGoalEqualIn;

  /// Reach an evaluation past [cp] within [moves] moves.
  ///
  /// [cp] is from White's point of view: an exercise played as Black has a negative one.
  ///
  /// A few chapters carry a lower [cp] than lichess.org publishes: the app judges a local search
  /// of the small net, which scores a won position below the cloud eval the web judges on, and the
  /// published target would be out of reach however well the player plays. The asset is generated
  /// with those targets already lowered — see `_evalInOverrides` in `scripts/gen_practice.dart`.
  const factory evalIn({required int cp, required int moves}) = PracticeGoalEvalIn;

  /// Promote a pawn while keeping an evaluation past [cp], from White's point of view.
  const factory promotion({required int cp}) = PracticeGoalPromotion;

  /// Parses the `practiceGoal` JSON of `/practice/load`, as written in the practice asset.
  factory fromPick(RequiredPick pick) {
    final result = pick('result').asStringOrThrow();
    int moves() => pick('moves').asIntOrThrow();
    int cp() => pick('cp').asIntOrThrow();
    return switch (result) {
      'mate' => const PracticeGoal.mate(),
      'mateIn' => PracticeGoal.mateIn(moves: moves()),
      'drawIn' => PracticeGoal.drawIn(moves: moves()),
      'equalIn' => PracticeGoal.equalIn(moves: moves()),
      'evalIn' => PracticeGoal.evalIn(cp: cp(), moves: moves()),
      'promotion' => PracticeGoal.promotion(cp: cp()),
      _ => throw PickException('Unknown practice goal "$result" at ${pick.debugParsingExit}'),
    };
  }

  /// Judges the chapter after a move, against this goal.
  ///
  /// Ported from lila's `studyPracticeSuccess.ts`, with one change: an eval is solid enough to rely
  /// on from [kPracticeUsableDepth] rather than lila's depth 16.
  ///
  /// - [position] is the position after [lastMove], which is null before any move is played;
  /// - [eval] is the engine eval of [position], if any, with scores from White's point of view;
  /// - [verdict] judges [lastMove] if it was the player's move;
  /// - [nbMoves] is the number of moves the player has played;
  /// - [threefold] is whether [position] repeats for the third time.
  PracticeStatus judge({
    required Side playerSide,
    required Position position,
    required Move? lastMove,
    required ClientEval? eval,
    required MoveVerdict? verdict,
    required int nbMoves,
    required bool threefold,
  }) {
    if (lastMove == null) return .ongoing;

    final outcome = position.outcome;
    if (outcome?.winner case final winner?) return winner == playerSide ? .solved : .failed;
    if (verdict == .mistake || verdict == .blunder) return .failed;

    final solidEval = eval != null && eval.depth >= kPracticeUsableDepth ? eval : null;

    switch (this) {
      case PracticeGoalDrawIn(:final moves) || PracticeGoalEqualIn(:final moves):
        if (threefold) return .solved;
        if (_isDrawish(solidEval) == false) return .failed;
        if (nbMoves > moves) return .failed;
        if (outcome != null) return .solved;
        if (nbMoves >= moves) return _decided(_isDrawish(solidEval));
      case PracticeGoalEvalIn(:final cp, :final moves):
        if (nbMoves >= moves) return _decided(_isWinning(position, solidEval, cp, playerSide));
      case PracticeGoalMateIn(:final moves):
        if (nbMoves > moves) return .failed;
        if (solidEval == null) return .ongoing;
        final mateIn = _myMateIn(solidEval, playerSide);
        if (mateIn == null || mateIn + nbMoves > moves) return .failed;
      case PracticeGoalPromotion(:final cp):
        if (lastMove case NormalMove(promotion: null) || DropMove()) return .ongoing;
        return _decided(_isWinning(position, solidEval, cp, playerSide));
      case PracticeGoalMate():
        if (threefold) return .failed;
        if (_isDrawish(solidEval) == true) return .failed;
        if (position.isStalemate) return .failed;
    }
    return .ongoing;
  }
}

PracticeStatus _decided(bool? success) => switch (success) {
  true => .solved,
  false => .failed,
  null => .ongoing,
};

/// Whether the position is roughly equal, or null without a solid eval.
bool? _isDrawish(ClientEval? solidEval) {
  if (solidEval == null) return null;
  return solidEval.mate == null && (solidEval.cp ?? 0).abs() < 150;
}

/// Whether the eval is past [goalCp] for [side], or null without a solid eval.
///
/// A stalemate or a dead draw needs no eval to be known not winning.
bool? _isWinning(Position position, ClientEval? solidEval, int goalCp, Side side) {
  if (solidEval == null) {
    return position.isStalemate || position.isInsufficientMaterial ? false : null;
  }
  final mate = solidEval.mate;
  final cp = mate != null && mate > 0
      ? 99999
      : mate != null && mate < 0
      ? -99999
      : solidEval.cp ?? 0;
  return side == Side.white ? cp >= goalCp : cp <= goalCp;
}

/// The number of moves [side] mates in according to [solidEval], or null if it does not.
int? _myMateIn(ClientEval solidEval, Side side) {
  final mate = solidEval.mate;
  if (mate == null) return null;
  final mateIn = side == Side.white ? mate : -mate;
  return mateIn > 0 ? mateIn : null;
}
