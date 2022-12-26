import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'package:lichess_mobile/src/features/user/model/user.dart';
import './game_status.dart';

part 'game.freezed.dart';

@freezed
class PlayableGame with _$PlayableGame {
  const PlayableGame._();

  const factory PlayableGame({
    required GameId id,
    required bool rated,
    required Speed speed,
    required String initialFen,
    required Side orientation,
    required Player white,
    required Player black,
    Variant? variant,
  }) = _PlayableGame;

  Player get player => orientation == Side.white ? white : black;
  Player get opponent => orientation == Side.white ? black : white;
}

@freezed
class ArchivedGame with _$ArchivedGame {
  // const ArchivedGame._();
  const factory ArchivedGame({
    required GameId id,
    required bool rated,
    required Speed speed,
    required Perf perf,
    required DateTime createdAt,
    required DateTime lastMoveAt,
    required GameStatus status,
    required Player white,
    required Player black,
    Side? winner,
    Variant? variant,
  }) = _ArchivedGame;

  factory ArchivedGame.fromJson(Map<String, dynamic> json) =>
      ArchivedGame.fromPick(pick(json).required());

  factory ArchivedGame.fromPick(RequiredPick pick) {
    return ArchivedGame(
      id: pick('id').asGameIdOrThrow(),
      rated: pick('rated').asBoolOrThrow(),
      speed: pick('speed').asSpeedOrThrow(),
      perf: pick('perf').asPerfOrThrow(),
      createdAt: pick('createdAt').asDateTimeFromMillisecondsOrThrow(),
      lastMoveAt: pick('lastMoveAt').asDateTimeFromMillisecondsOrThrow(),
      status: pick('status').asGameStatusOrThrow(),
      white: pick('players', 'white').letOrThrow(Player.fromUserGamePick),
      black: pick('players', 'black').letOrThrow(Player.fromUserGamePick),
      winner: pick('winner').asSideOrNull(),
    );
  }
}

@freezed
class Player with _$Player {
  const factory Player({
    String? id,
    required String name,
    int? rating,
    int? ratingDiff,
    bool? provisional,
    String? title,
    bool? patron,
    int? aiLevel,
  }) = _Player;

  /// Parse a player return by https://lichess.org/api#tag/Games/operation/apiGamesUser
  factory Player.fromUserGamePick(RequiredPick pick) {
    return Player(
      id: pick('user', 'id').asStringOrNull(),
      name: pick('user', 'name').asStringOrNull() ?? 'Stockfish',
      patron: pick('user', 'patron').asBoolOrNull(),
      title: pick('user', 'title').asStringOrNull(),
      rating: pick('rating').asIntOrNull(),
      ratingDiff: pick('ratingDiff').asIntOrNull(),
      aiLevel: pick('aiLevel').asIntOrNull(),
    );
  }
}

enum Speed {
  ultraBullet,
  bullet,
  blitz,
  rapid,
  classical,
  correspondence,
  unlimited,
}

enum Variant {
  standard,
  chess960,
  antichess,
  kingOfTheHill,
  threeCheck,
  atomic,
  horde,
  racingKings,
  crazyhouse;
}
