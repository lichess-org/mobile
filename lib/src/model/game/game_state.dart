import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartchess/dartchess.dart';

import 'game_status.dart';
import 'game_event.dart';

part 'game_state.freezed.dart';

@freezed
class GameClock with _$GameClock {
  const factory GameClock({
    required Duration whiteTime,
    required Duration blackTime,
  }) = _GameClock;

  factory GameClock.fromEvent(GameStateEvent event) => GameClock(
        whiteTime: Duration(milliseconds: event.whiteTime),
        blackTime: Duration(milliseconds: event.blackTime),
      );
}

@freezed
class GameState with _$GameState {
  const GameState._();

  const factory GameState({
    required GameStatus status,
    required List<String> uciMoves,
    required List<String> sanMoves,
    required List<Position<Chess>> positions,
  }) = _GameState;

  factory GameState.fromEvent(GameStateEvent event) {
    final uciMoves = event.moves.split(' ').where((m) => m.isNotEmpty).toList();
    final List<Position<Chess>> positions = [Chess.initial];
    final List<String> sanMoves = [];
    for (final m in uciMoves) {
      final move = Move.fromUci(m)!;
      final newPos = positions.last.playToSan(move);
      positions.add(newPos.item1);
      sanMoves.add(newPos.item2);
    }
    return GameState(
      status: event.status,
      uciMoves: uciMoves,
      sanMoves: sanMoves,
      positions: positions,
    );
  }

  Move? moveAtPly(int ply) =>
      uciMoves.isNotEmpty ? Move.fromUci(uciMoves[ply]) : null;

  /// Gets the current position
  Position<Chess> get position => positions.last;
  int get positionIndex => positions.length - 1;
  Move? get lastMove =>
      uciMoves.isNotEmpty ? Move.fromUci(uciMoves.last) : null;
  bool get abortable => status == GameStatus.started && position.fullmoves <= 1;
  bool get resignable => status == GameStatus.started && position.fullmoves > 1;
  bool get playing => status == GameStatus.started;
  bool get gameOver => status.value > GameStatus.started.value;
  Map<String, Set<String>> get validMoves => algebraicLegalMoves(position);
  bool get isLastMoveCapture {
    final lm = sanMoves.isNotEmpty ? sanMoves.last : null;
    return lm != null && lm.contains('x');
  }
}
