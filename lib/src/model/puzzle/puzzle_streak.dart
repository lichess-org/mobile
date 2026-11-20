import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';

part 'puzzle_streak.freezed.dart';
part 'puzzle_streak.g.dart';

typedef Streak = IList<PuzzleId>;

@Freezed(fromJson: true, toJson: true)
sealed class const PuzzleStreak._() with _$PuzzleStreak {
  const factory({
    required Streak streak,
    required int index,
    required bool hasSkipped,
    required bool finished,
    required DateTime timestamp,
  }) = _PuzzleStreak;

  PuzzleId? get nextId => streak.getOrNull(index + 1);

  factory fromJson(Map<String, dynamic> json) => _$PuzzleStreakFromJson(json);
}
