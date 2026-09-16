import 'package:deep_pick/deep_pick.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'practice_goal.freezed.dart';

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
}
