import 'package:freezed_annotation/freezed_annotation.dart';

part 'game.freezed.dart';
part 'game.g.dart';

@Freezed(toJson: false)
class Game with _$Game {
  factory Game({
    required String id,
    required bool rated,
    required Speed speed,
    @JsonKey(fromJson: DateTime.fromMillisecondsSinceEpoch)
        required DateTime createdAt,
    required String initialFen,
    required Player white,
    required Player black,
  }) = _Game;

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);
}

@Freezed(toJson: false)
class Player with _$Player {
  factory Player({
    required String id,
    required String name,
    required int rating,
    bool? provisional,
    String? title,
  }) = _Player;

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);
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
