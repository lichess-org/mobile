import 'package:meta/meta.dart';
import 'package:dartchess/dartchess.dart';

@immutable
class FeaturedPosition {
  const FeaturedPosition({
    required this.fen,
    this.lastMove,
  });

  FeaturedPosition.fromJson(Map<String, dynamic> json)
      : fen = json['fen'],
        lastMove = json['lm'] != null ? Move.fromUci(json['lm']) : null;

  final String fen;
  final Move? lastMove;

  Side get turn =>
      fen.substring(fen.length - 1) == 'w' ? Side.white : Side.black;
  bool get isGameOngoing => !Chess.fromSetup(Setup.parseFen(fen)).isGameOver;

  FeaturedPosition copyWith({
    String? fen,
    Chess? position,
    Side? turn,
    Move? lastMove,
  }) {
    return FeaturedPosition(
      fen: fen ?? this.fen,
      lastMove: lastMove,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FeaturedPosition &&
        other.fen == fen &&
        other.lastMove == lastMove;
  }

  @override
  int get hashCode => Object.hash(fen, lastMove);
}
