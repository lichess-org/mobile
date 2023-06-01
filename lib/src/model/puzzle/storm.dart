import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:deep_pick/deep_pick.dart';

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
    StormNewHigh? newHigh,
  }) = _StormRunStats;
}

enum StormNewHighType {
  day,
  week,
  month,
  allTime,
}

@freezed
class StormNewHigh with _$StormNewHigh {
  const factory StormNewHigh({
    required StormNewHighType key,
    required int prev,
  }) = _StormNewHigh;
}

final IMap<String, StormNewHighType> stormNewHighTypeMap =
    IMap(StormNewHighType.values.asNameMap());

extension StormExtension on Pick {
  StormNewHighType asStormNewHighTypeOrThrow() {
    final value = this.required().value;
    if (value is StormNewHighType) {
      return value;
    }
    if (value is String) {
      if (stormNewHighTypeMap.containsKey(value)) {
        return stormNewHighTypeMap[value]!;
      }
    }
    throw PickException(
      "value $value at $debugParsingExit can't be casted to StormNewHighType",
    );
  }

  StormNewHighType? asStormNewHighTypeOrNull() {
    if (value == null) return null;
    try {
      return asStormNewHighTypeOrThrow();
    } catch (_) {
      return null;
    }
  }
}
