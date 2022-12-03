import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/common/models.dart';
import './featured_player.dart';

part 'featured_game.freezed.dart';

@freezed
class FeaturedGame with _$FeaturedGame {
  const factory FeaturedGame({
    required GameId id,
    required Side orientation,
    required String initialFen,
    required FeaturedPlayer white,
    required FeaturedPlayer black,
  }) = _FeaturedGame;

  factory FeaturedGame.fromJson(Map<String, dynamic> json) {
    return FeaturedGame(
      id: GameId(value: json['id'] as String),
      initialFen: json['fen'] as String,
      orientation: json['orientation'] == 'white' ? Side.white : Side.black,
      white: FeaturedPlayer.fromJson(
          json['players'].firstWhere((p) => p['color'] == 'white')),
      black: FeaturedPlayer.fromJson(
          json['players'].firstWhere((p) => p['color'] == 'black')),
    );
  }
}
