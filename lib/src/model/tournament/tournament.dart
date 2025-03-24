import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/json.dart';

part 'tournament.freezed.dart';

enum TournamentFreq {
  hourly,
  daily,
  eastern,
  weekly,
  weekend,
  monthly,
  shield,
  marathon,
  yearly,
  unique;

  static final IMap<String, TournamentFreq> nameMap = IMap(TournamentFreq.values.asNameMap());
}

typedef TournamentLists =
    ({
      IList<TournamentListItem> started,
      IList<TournamentListItem> created,
      IList<TournamentListItem> finished,
    });

extension TournamentExtension on Pick {
  TimeIncrement asTimeIncrementOrThrow() {
    final requiredPick = this.required();
    return TimeIncrement(
      requiredPick('limit').asIntOrThrow(),
      requiredPick('increment').asIntOrThrow(),
    );
  }

  TournamentFreq asTournamentFreqOrThrow() {
    final value = this.required().value;
    if (value is TournamentFreq) {
      return value;
    }
    if (value is String) {
      final freq = TournamentFreq.nameMap[value];
      if (freq != null) return freq;
    }
    throw PickException("value $value at $debugParsingExit can't be casted to TournamentFreq");
  }

  IList<TournamentListItem> asTournamentListOrThrow() =>
      asListOrThrow((pick) => TournamentListItem.fromServerJson(pick.asMapOrThrow())).toIList();
}

@freezed
class TournamentListItem with _$TournamentListItem {
  const TournamentListItem._();

  const factory TournamentListItem({
    required TournamentId id,
    required String createdBy,
    required String fullName,
    required TimeIncrement timeIncrement,
    required bool rated,
    required Duration? timeToStart,
    required DateTime startsAt,
    required DateTime finishesAt,
    required int? maxRating,
    required int minutes,
    required int nbPlayers,
    required Perf perf,
    required int position,
    required TournamentFreq freq,
    required Variant variant,
    required LightUser? winner,
  }) = _TournamentListItem;

  factory TournamentListItem.fromServerJson(Map<String, Object?> json) =>
      _tournamentListItemFromPick(pick(json).required());
}

TournamentListItem _tournamentListItemFromPick(RequiredPick pick) {
  return TournamentListItem(
    id: pick('id').asTournamentIdOrThrow(),
    fullName: pick('fullName').asStringOrThrow(),
    timeIncrement: pick('clock').asTimeIncrementOrThrow(),
    rated: pick('rated').asBoolOrThrow(),
    createdBy: pick('createdBy').asStringOrThrow(),
    finishesAt: pick('finishesAt').asDateTimeFromMillisecondsOrThrow(),
    maxRating: pick('maxRating', 'rating').asIntOrNull(),
    minutes: pick('minutes').asIntOrThrow(),
    nbPlayers: pick('nbPlayers').asIntOrThrow(),
    perf: pick('perf').asPerfOrThrow(),
    position: pick('perf', 'position').asIntOrThrow(),
    freq: pick('schedule', 'freq').asTournamentFreqOrThrow(),
    timeToStart: pick('secondsToStart').asDurationFromSecondsOrNull(),
    startsAt: pick('startsAt').asDateTimeFromMillisecondsOrThrow(),
    variant: pick('variant').asVariantOrThrow(),
    winner: pick('winner').asLightUserOrNull(),
  );
}
