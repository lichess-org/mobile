import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartchess/dartchess.dart';

import './featured_player.dart';

part 'featured_game.freezed.dart';

@Freezed(toJson: false, fromJson: false)
class FeaturedGame with _$FeaturedGame {
  const factory FeaturedGame({
    required String id,
    required Side orientation,
    required String initialFen,
    required FeaturedPlayer white,
    required FeaturedPlayer black,
  }) = _FeaturedGame;

  factory FeaturedGame.fromJson(Map<String, dynamic> json) {
    return FeaturedGame(
      id: json['id'],
      initialFen: json['fen'],
      orientation: json['orientation'] == 'white' ? Side.white : Side.black,
      white: FeaturedPlayer.fromJson(
          json['players'].firstWhere((p) => p['color'] == 'white')),
      black: FeaturedPlayer.fromJson(
          json['players'].firstWhere((p) => p['color'] == 'black')),
    );
  }
}
