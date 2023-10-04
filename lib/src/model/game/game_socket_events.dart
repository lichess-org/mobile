import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/material_diff.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
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
      game: _playableGameFromPick(pick(json).required()),
      socketEventVersion: json['socket'] as int,
    );
  }
}

PlayableGame _playableGameFromPick(RequiredPick pick) {
  final meta = _playableGameMetaFromPick(pick('game').required());

  // assume lichess always send initialFen with fromPosition and chess960
  Position position =
      (meta.variant == Variant.fromPosition || meta.variant == Variant.chess960)
          ? Chess.fromSetup(Setup.parseFen(meta.initialFen!))
          : meta.variant.initialPosition;

  int ply = 0;
  final steps = [GameStep(ply: ply, position: position)];
  final pgn = pick('game', 'pgn').asStringOrNull();
  final moves = pgn != null && pgn != '' ? pgn.split(' ') : null;
  if (moves != null && moves.isNotEmpty) {
    for (final san in moves) {
      ply++;
      final move = position.parseSan(san);
      // assume lichess only sends correct moves
      position = position.playUnchecked(move!);
      steps.add(
        GameStep(
          ply: ply,
          sanMove: SanMove(san, move),
          position: position,
          diff: MaterialDiff.fromBoard(position.board),
        ),
      );
    }
  }

  return PlayableGame(
    meta: meta,
    steps: steps.toIList(),
    white: pick('white').letOrThrow(_playerFromUserGamePick),
    black: pick('black').letOrThrow(_playerFromUserGamePick),
    clock: pick('clock').letOrNull(_playableClockDataFromPick),
    status: pick('game', 'status').asGameStatusOrThrow(),
    winner: pick('game', 'winner').asSideOrNull(),
    boosted: pick('game', 'boosted').asBoolOrNull(),
    isThreefoldRepetition: pick('game', 'threefold').asBoolOrNull(),
    moretimeable: pick('moretimeable').asBoolOrFalse(),
    takebackable: pick('takebackable').asBoolOrFalse(),
    youAre: pick('youAre').asSideOrNull(),
    prefs: pick('prefs').letOrNull(_gamePrefsFromPick),
    expiration: pick('expiration').letOrNull(
      (it) {
        final idle = it('idleMillis').asDurationFromMilliSecondsOrThrow();
        return (
          idle: idle,
          timeToMove: it('millisToMove').asDurationFromMilliSecondsOrThrow(),
          movedAt: DateTime.now().subtract(idle),
        );
      },
    ),
    rematch: pick('game', 'rematch').asGameIdOrNull(),
  );
}

PlayableGameMeta _playableGameMetaFromPick(RequiredPick pick) {
  return PlayableGameMeta(
    id: pick('id').asGameIdOrThrow(),
    rated: pick('rated').asBoolOrThrow(),
    speed: pick('speed').asSpeedOrThrow(),
    perf: pick('perf').asPerfOrThrow(),
    variant: pick('variant').asVariantOrThrow(),
    source: pick('source').letOrThrow(
      (pick) =>
          GameSource.nameMap[pick.asStringOrThrow()] ?? GameSource.unknown,
    ),
    initialFen: pick('initialFen').asStringOrNull(),
    startedAtTurn: pick('startedAtTurn').asIntOrNull(),
    rules: pick('rules').letOrNull(
      (it) => ISet(
        pick.asListOrThrow(
          (e) => GameRule.nameMap[e.asStringOrThrow()] ?? GameRule.unknown,
        ),
      ),
    ),
  );
}

GamePrefs _gamePrefsFromPick(RequiredPick pick) {
  return (
    showRatings: pick('showRatings').asBoolOrFalse(),
    enablePremove: pick('enablePremove').asBoolOrFalse(),
    autoQueen: AutoQueen.fromInt(pick('autoQueen').asIntOrThrow()),
    confirmResign: pick('confirmResign').asBoolOrFalse(),
    submitMove: pick('submitMove').asBoolOrFalse(),
    zenMode: Zen.fromInt(pick('zen').asIntOrThrow()),
  );
}

Player _playerFromUserGamePick(RequiredPick pick) {
  return Player(
    id: pick('user', 'id').asUserIdOrNull(),
    name: pick('user', 'name').asStringOrNull(),
    patron: pick('user', 'patron').asBoolOrNull(),
    title: pick('user', 'title').asStringOrNull(),
    rating: pick('rating').asIntOrNull(),
    provisional: pick('provisional').asBoolOrNull(),
    ratingDiff: pick('ratingDiff').asIntOrNull(),
    aiLevel: pick('aiLevel').asIntOrNull(),
    onGame: pick('onGame').asBoolOrNull(),
    isGone: pick('isGone').asBoolOrNull(),
    offeringDraw: pick('offeringDraw').asBoolOrNull(),
    offeringRematch: pick('offeringRematch').asBoolOrNull(),
    proposingTakeback: pick('proposingTakeback').asBoolOrNull(),
  );
}

PlayableClockData _playableClockDataFromPick(RequiredPick pick) {
  return PlayableClockData(
    initial: pick('initial').asDurationFromSecondsOrThrow(),
    increment: pick('increment').asDurationFromSecondsOrThrow(),
    running: pick('running').asBoolOrThrow(),
    white: pick('white').asDurationFromSecondsOrThrow(),
    black: pick('black').asDurationFromSecondsOrThrow(),
    emergency: pick('emerg').asDurationFromSecondsOrNull(),
    moreTime: pick('moretime').asDurationFromSecondsOrNull(),
  );
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
