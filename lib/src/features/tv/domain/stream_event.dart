import 'package:chessground/chessground.dart';

import './featured_player.dart';

class FeaturedEvent {
  const FeaturedEvent({
    required this.id,
    required this.orientation,
    required this.fen,
    required this.players,
  });

  final String id;
  final Side orientation;
  final String fen;
  final Map<Side, FeaturedPlayer> players;

  FeaturedEvent.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        fen = json['fen'],
        orientation = json['orientation'] == 'white' ? Side.white : Side.black,
        players = {
          Side.white: FeaturedPlayer.fromJson(
              json['players'].firstWhere((p) => p['color'] == 'white')),
          Side.black: FeaturedPlayer.fromJson(
              json['players'].firstWhere((p) => p['color'] == 'black')),
        };
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
}
