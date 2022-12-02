import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:dartchess/dartchess.dart';

import './featured_player.dart';

@immutable
class FeaturedGame extends Equatable {
  const FeaturedGame({
    required this.id,
    required this.orientation,
    required this.initialFen,
    required this.white,
    required this.black,
  });

  @override
  List<Object> get props => [id, orientation, initialFen, white, black];

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
}
