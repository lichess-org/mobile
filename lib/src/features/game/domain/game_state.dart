import 'package:meta/meta.dart';
import 'package:dartchess/dartchess.dart';

import './game_status.dart';

@immutable
class GameState {
  final int whiteTime;
  final int blackTime;
  final GameStatus status;
  final List<String> uciMoves;
  final List<String> sanMoves;
  final Position<Chess> position;

  const GameState(
      {required this.whiteTime,
      required this.blackTime,
      required this.status,
      required this.uciMoves,
      required this.sanMoves,
      required this.position});

  factory GameState.fromJson(Map<String, dynamic> json) {
    final uciMoves =
        json['moves'].split(' ').where((m) => m.isNotEmpty).toList();
    Position<Chess> pos = Chess.initial;
    List<String> sanMoves = [];
    for (final m in uciMoves) {
      final move = Move.fromUci(m);
      final newPos = pos.playToSan(move);
      pos = newPos.item1;
      sanMoves.add(newPos.item2);
    }
    return GameState(
      whiteTime: json['wtime'],
      blackTime: json['btime'],
      status: GameStatus.values.firstWhere((e) => e.name == json['status'],
          orElse: () => GameStatus.unknown),
      uciMoves: uciMoves,
      sanMoves: sanMoves,
      position: pos,
    );
  }

  Move? get lastMove =>
      uciMoves.isNotEmpty ? Move.fromUci(uciMoves[uciMoves.length - 1]) : null;

  @override
  bool operator ==(Object other) {
    return other is GameState &&
        other.whiteTime == whiteTime &&
        other.blackTime == blackTime &&
        other.status == status &&
        other.uciMoves == uciMoves &&
        other.sanMoves == sanMoves &&
        other.position == position;
  }

  @override
  int get hashCode =>
      Object.hash(whiteTime, blackTime, status, uciMoves, sanMoves, position);
}
