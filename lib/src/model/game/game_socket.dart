import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/utils/json.dart';

part 'game_socket.freezed.dart';

@freezed
class SocketMoveEvent with _$SocketMoveEvent {
  const SocketMoveEvent._();

  const factory SocketMoveEvent({
    required int ply,
    required String uci,
    required String san,
    bool? threefold,
    bool? whiteDrawOffer,
    bool? blackDrawOffer,
    GameStatus? status,
    Side? winner,
    Duration? whiteClock,
    Duration? blackClock,
    Duration? clockLag,
  }) = _SocketMoveEvent;

  factory SocketMoveEvent.fromJson(Map<String, dynamic> json) =>
      _socketMoveEventFromPick(pick(json).required());
}

SocketMoveEvent _socketMoveEventFromPick(RequiredPick pick) {
  return SocketMoveEvent(
    ply: pick('ply').asIntOrThrow(),
    uci: pick('uci').asStringOrThrow(),
    san: pick('san').asStringOrThrow(),
    status: pick('status').asGameStatusOrNull(),
    winner: pick('winner').asSideOrNull(),
    threefold: pick('threefold').asBoolOrNull(),
    whiteDrawOffer: pick('wDraw').asBoolOrNull(),
    blackDrawOffer: pick('bDraw').asBoolOrNull(),
    whiteClock: pick('clock', 'white').asDurationFromSecondsOrNull(),
    blackClock: pick('clock', 'black').asDurationFromSecondsOrNull(),
    clockLag: pick('clock', 'lag').letOrNull((it) {
      return Duration(milliseconds: it.asIntOrThrow() * 10);
    }),
  );
}
