import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';

part 'puzzle_streak.freezed.dart';
part 'puzzle_streak.g.dart';

typedef Streak = IList<PuzzleId>;

@Freezed(fromJson: true, toJson: true)
sealed class PuzzleStreak with _$PuzzleStreak {
  const PuzzleStreak._();

  const factory PuzzleStreak({
    required Streak streak,
    required int index,
    required bool hasSkipped,
    required bool finished,
    required DateTime timestamp,

    /// Set when the puzzle at [index] was solved but the next one was not available offline, so
    /// the next load or reconnect completes the advance instead of replaying the puzzle.
    @Default(false) bool advancePending,
  }) = _PuzzleStreak;

  PuzzleId? get nextId => streak.getOrNull(index + 1);

  /// Puzzles solved in this run, counting a solve that could not advance yet.
  int get score => advancePending ? index + 1 : index;

  factory PuzzleStreak.fromJson(Map<String, dynamic> json) => _$PuzzleStreakFromJson(json);
}
