import 'package:meta/meta.dart';
import 'package:dartchess/dartchess.dart';

/// Event sent by lichess TV stream when the position of the game changes.
@immutable
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
