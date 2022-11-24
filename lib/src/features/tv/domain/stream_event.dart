import 'package:chessground/chessground.dart';

import './featured_player.dart';

class TvEvent {}

class FeaturedEvent {
  const FeaturedEvent({
    required this.id,
    required this.orientation,
    required this.fen,
    required this.white,
    required this.black,
  });

  final String id;
  final Side orientation;
  final String fen;
  final FeaturedPlayer white;
  final FeaturedPlayer black;

  FeaturedEvent.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        fen = json['fen'],
        orientation = json['orientation'] == 'white' ? Side.white : Side.black,
        white = FeaturedPlayer.fromJson(
            json['players'].firstWhere((p) => p['color'] == 'white')),
        black = FeaturedPlayer.fromJson(
            json['players'].firstWhere((p) => p['color'] == 'black'));

  @override
  bool operator ==(Object other) {
    return other is FeaturedEvent &&
        other.id == id &&
        other.orientation == orientation &&
        other.fen == fen &&
        other.white == white &&
        other.black == black;
  }

  @override
  int get hashCode => Object.hash(id, orientation, fen, white, black);
}

class FenEvent {
  const FenEvent({
    required this.fen,
    required this.lastMove,
    required this.whiteSeconds,
    required this.blackSeconds,
  });

  final String fen;
  final Move lastMove;
  final int whiteSeconds;
  final int blackSeconds;

  FenEvent.fromJson(Map<String, dynamic> json)
      : fen = json['fen'],
        lastMove = Move.fromUci(json['lm']),
        whiteSeconds = json['wc'],
        blackSeconds = json['bc'];

  @override
  bool operator ==(Object other) {
    return other is FenEvent &&
        other.fen == fen &&
        other.lastMove == lastMove &&
        other.whiteSeconds == whiteSeconds &&
        other.blackSeconds == blackSeconds;
  }

  @override
  int get hashCode => Object.hash(fen, lastMove, whiteSeconds, blackSeconds);
}
