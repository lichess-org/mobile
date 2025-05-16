import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/tv/tv_channel.dart';
import 'package:lichess_mobile/src/utils/json.dart';

part 'tv_socket_events.freezed.dart';

@freezed
sealed class FenSocketEvent with _$FenSocketEvent {
  const factory FenSocketEvent({
    required GameId id,
    required String fen,
    required Move lastMove,
    required Duration whiteClock,
    required Duration blackClock,
  }) = _FenSocketEvent;

  factory FenSocketEvent.fromJson(Map<String, dynamic> json) {
    return _tvFenEventFromPick(pick(json).required());
  }
}

FenSocketEvent _tvFenEventFromPick(RequiredPick pick) {
  return FenSocketEvent(
    id: pick('id').asGameIdOrThrow(),
    fen: pick('fen').asStringOrThrow(),
    lastMove: pick('lm').asUciMoveOrThrow(),
    whiteClock: pick('wc').asDurationFromSecondsOrThrow(),
    blackClock: pick('bc').asDurationFromSecondsOrThrow(),
  );
}

@freezed
sealed class FinishSocketEvent with _$FinishSocketEvent {
  const factory FinishSocketEvent({required GameId id, required Side? winner}) = _FinishSocketEvent;

  factory FinishSocketEvent.fromJson(Map<String, dynamic> json) {
    return _finishEventFromPick(pick(json).required());
  }
}

FinishSocketEvent _finishEventFromPick(RequiredPick pick) {
  final winner = pick('win').asStringOrNull();
  return FinishSocketEvent(
    id: pick('id').asGameIdOrThrow(),
    winner:
        winner == 'w'
            ? Side.white
            : winner == 'b'
            ? Side.black
            : null,
  );
}

@freezed
sealed class TvSelectEvent with _$TvSelectEvent {
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
