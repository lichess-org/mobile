import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/common/models.dart';
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
