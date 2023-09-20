import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/tv/tv_channel.dart';

part 'tv_socket_events.freezed.dart';

@freezed
class TvSelectEvent with _$TvSelectEvent {
  const factory TvSelectEvent({
    required TvChannel channel,
    required GameId id,
    required Side orientation,
    required ({String name, String? title, int? rating}) player,
  }) = _TvSelectEvent;

  factory TvSelectEvent.fromJson(Map<String, dynamic> json) {
    return _tvSelectEventFromPick(pick(json).required());
  }
}

TvSelectEvent _tvSelectEventFromPick(RequiredPick pick) {
  final side = pick('color').asSideOrThrow();
  return TvSelectEvent(
    channel: pick('channel').asTvChannelOrThrow(),
    id: pick('id').asGameIdOrThrow(),
    orientation: side,
    player: (
      // don't know why server returns null sometimes
      name: pick('player', 'name').asStringOrNull() ?? '',
      title: pick('player', 'title').asStringOrNull(),
      rating: pick('player', 'rating').asIntOrNull(),
    ),
  );
}
