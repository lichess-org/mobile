import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/common/models.dart';

part 'game.freezed.dart';

@freezed
class Game with _$Game {
  const Game._();

  const factory Game({
    required GameId id,
    required bool rated,
    required Speed speed,
    required String initialFen,
    required Side orientation,
    required Player white,
    required Player black,
  }) = _Game;

  Player get player => orientation == Side.white ? white : black;
  Player get opponent => orientation == Side.white ? black : white;
}

@freezed
class Player with _$Player {
  const factory Player({
    String? id,
    required String name,
    int? rating,
    bool? provisional,
    String? title,
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
