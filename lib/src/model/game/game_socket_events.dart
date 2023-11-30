import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/playable_game.dart';
import 'package:lichess_mobile/src/utils/json.dart';

part 'game_socket_events.freezed.dart';

@freezed
class GameFullEvent with _$GameFullEvent {
  const factory GameFullEvent({
    required PlayableGame game,
    required int socketEventVersion,
  }) = _GameFullEvent;

  factory GameFullEvent.fromJson(Map<String, dynamic> json) {
    return GameFullEvent(
      game: PlayableGame.fromServerJson(json),
      socketEventVersion: json['socket'] as int,
    );
  }
}

@freezed
class MoveEvent with _$MoveEvent {
  const MoveEvent._();

  const factory MoveEvent({
    required int ply,
    required String uci,
    required String san,
    bool? threefold,
    bool? whiteOfferingDraw,
    bool? blackOfferingDraw,
    GameStatus? status,
    Side? winner,
    ({Duration white, Duration black, Duration? lag})? clock,
  }) = _MoveEvent;

  factory MoveEvent.fromJson(Map<String, dynamic> json) =>
      _socketMoveEventFromPick(pick(json).required());
}

MoveEvent _socketMoveEventFromPick(RequiredPick pick) {
  String uci = pick('uci').asStringOrThrow();

  final promotion = pick('promotion', 'pieceClass').asStringOrNull();
  switch (promotion) {
    case 'queen':
      uci += 'q';
    case 'rook':
      uci += 'r';
    case 'bishop':
      uci += 'b';
    case 'knight':
      uci += 'n';
    // variants support
    case 'pawn':
      uci += 'p';
    case 'king':
      uci += 'k';
  }

  return MoveEvent(
    ply: pick('ply').asIntOrThrow(),
    uci: uci,
    san: pick('san').asStringOrThrow(),
    status: pick('status').asGameStatusOrNull(),
    winner: pick('winner').asSideOrNull(),
    threefold: pick('threefold').asBoolOrNull(),
    whiteOfferingDraw: pick('wDraw').asBoolOrNull(),
    blackOfferingDraw: pick('bDraw').asBoolOrNull(),
    clock: pick('clock').letOrNull(
      (it) => (
        white: it('white').asDurationFromSecondsOrThrow(),
        black: it('black').asDurationFromSecondsOrThrow(),
        lag: it('lag')
            .letOrNull((it) => Duration(milliseconds: it.asIntOrThrow() * 10)),
      ),
    ),
  );
}

@freezed
class GameEndEvent with _$GameEndEvent {
  const GameEndEvent._();

  const factory GameEndEvent({
    required GameStatus status,
    Side? winner,
    ({int white, int black})? ratingDiff,
    bool? boosted,
    ({Duration white, Duration black})? clock,
  }) = _GameEndEvent;

  factory GameEndEvent.fromJson(Map<String, dynamic> json) =>
      _gameEndEventFromPick(pick(json).required());
}

GameEndEvent _gameEndEventFromPick(RequiredPick pick) {
  return GameEndEvent(
    status: pick('status').asGameStatusOrThrow(),
    winner: pick('winner').asSideOrNull(),
    ratingDiff: pick('ratingDiff').letOrNull(
      (it) => (
        white: it('white').asIntOrThrow(),
        black: it('black').asIntOrThrow(),
      ),
    ),
    boosted: pick('boosted').asBoolOrNull(),
    clock: pick('clock').letOrNull(
      (it) => (
        white: Duration(milliseconds: it('wc').asIntOrThrow() * 10),
        black: Duration(milliseconds: it('bc').asIntOrThrow() * 10),
      ),
    ),
  );
}
