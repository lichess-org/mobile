import 'package:meta/meta.dart';
import 'package:dartchess/dartchess.dart';

import './featured_player.dart';

@immutable
class FeaturedGame {
  const FeaturedGame({
    required this.id,
    required this.orientation,
    required this.initialFen,
    required this.white,
    required this.black,
  });

  final String id;
  final Side orientation;
  final String initialFen;
  final FeaturedPlayer white;
  final FeaturedPlayer black;

  FeaturedGame.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        initialFen = json['fen'],
        orientation = json['orientation'] == 'white' ? Side.white : Side.black,
        white = FeaturedPlayer.fromJson(
            json['players'].firstWhere((p) => p['color'] == 'white')),
        black = FeaturedPlayer.fromJson(
            json['players'].firstWhere((p) => p['color'] == 'black'));

  FeaturedGame copyWith({
    Side? orientation,
    FeaturedPlayer? white,
    FeaturedPlayer? black,
  }) {
    return FeaturedGame(
      id: id,
      initialFen: initialFen,
      orientation: orientation ?? this.orientation,
      white: white ?? this.white,
      black: black ?? this.black,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FeaturedGame &&
        other.id == id &&
        other.orientation == orientation &&
        other.initialFen == initialFen &&
        other.white == white &&
        other.black == black;
  }

  @override
  int get hashCode => Object.hash(id, orientation, initialFen, white, black);
}
