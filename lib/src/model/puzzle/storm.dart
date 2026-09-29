import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';

part 'storm.freezed.dart';

@freezed
sealed class PuzzleStormHighScore with _$PuzzleStormHighScore {
  const factory({required int allTime, required int day, required int month, required int week}) =
      _PuzzleStormHighScore;
}

@freezed
sealed class const StormRunStats._() with _$StormRunStats {
  const factory({
    required int moves,
    required int errors,
    required int score,
    required int comboBest,
    required Duration time,
    required double timePerMove,
    required int highest,
    required IList<PuzzleHistoryEntry> history,
    required IList<PuzzleId> slowPuzzleIds,
    StormNewHigh? newHigh,
  }) = _StormRunStats;

  IList<PuzzleHistoryEntry> historyFilter(StormFilter filter) {
    return history
        .where(
          (e) => (filter.slow && filter.failed)
              ? (!e.win && slowPuzzleIds.any((id) => id == e.id))
              : (filter.slow ? slowPuzzleIds.any((id) => id == e.id) : (!filter.failed || !e.win)),
        )
        .toIList();
  }
}

@immutable
class const StormFilter({required final bool slow, required final bool failed}) {
  StormFilter copyWith({bool? slow, bool? failed}) =>
      StormFilter(slow: slow ?? this.slow, failed: failed ?? this.failed);
}

enum StormNewHighType() {
  day,
  week,
  month,
  allTime,
}

@freezed
sealed class StormDashboard with _$StormDashboard {
  const factory({
    required PuzzleStormHighScore highScore,
    required IList<StormDayScore> dayHighscores,
  }) = _StormDashboard;
}

@freezed
sealed class StormDayScore with _$StormDayScore {
  const factory({
    required DateTime day,
    required int runs,
    required int score,
    required int highest,
    required int time,
  }) = _StormDayScore;
}

@freezed
sealed class StormNewHigh with _$StormNewHigh {
  const factory({required StormNewHighType key, required int prev}) = _StormNewHigh;
}

final IMap<String, StormNewHighType> stormNewHighTypeMap = IMap(
  StormNewHighType.values.asNameMap(),
);

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
    throw PickException("value $value at $debugParsingExit can't be casted to StormNewHighType");
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
