import 'package:meta/meta.dart';
import 'package:dartchess/dartchess.dart';

@immutable
class FeaturedPosition {
  FeaturedPosition.fromJson(Map<String, dynamic> json)
      : fen = json['fen'],
        _position = Chess.fromSetup(Setup.parseFen(json['fen'])),
        turn = json['fen'].substring(json['fen'].length - 1) == 'w'
            ? Side.white
            : Side.black,
        lastMove = json['lm'] != null ? Move.fromUci(json['lm']) : null;

  final String fen;
  final Move? lastMove;
  final Side turn;
  final Chess _position;

  bool get isGameOngoing => !_position.isGameOver;

  @override
  bool operator ==(Object other) {
    return other is FeaturedPosition &&
        other.fen == fen &&
        other.lastMove == lastMove;
  }

  @override
  int get hashCode => Object.hash(fen, lastMove);
}
