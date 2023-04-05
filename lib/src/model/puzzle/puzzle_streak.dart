import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/common/models.dart';

part 'puzzle_streak.freezed.dart';

typedef Streak = IList<PuzzleId>;

@freezed
class PuzzleStreak with _$PuzzleStreak {
  const PuzzleStreak._();

  const factory PuzzleStreak({
    required Streak streak,
    required int index,
    required bool hasSkipped,
    required bool finished,
  }) = _PuzzleStreak;

  PuzzleId? get nextId => streak.getOrNull(index + 1);
}
