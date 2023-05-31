import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'puzzle.dart';

part 'storm.freezed.dart';

@freezed
class PuzzleStormHighScore with _$PuzzleStormHighScore {
  const factory PuzzleStormHighScore({
    required int allTime,
    required int day,
    required int month,
    required int week,
  }) = _PuzzleStormHighScore;
}

@freezed
class StormRunStats with _$StormRunStats {
  const factory StormRunStats({
    required int moves,
    required int errors,
    required int score,
    required int comboBest,
    required Duration time,
    required double timePerMove,
    required int highest,
    required IList<(LitePuzzle, bool, Duration)> history,
  }) = _StormRunStats;
}
