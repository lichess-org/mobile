import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartchess/dartchess.dart';

import './game_status.dart';

part 'game_state.freezed.dart';
part 'game_state.g.dart';

Duration _durationFromJson(int value) => Duration(milliseconds: value);

@freezed
class GameClock with _$GameClock {
  const factory GameClock({
    @JsonKey(fromJson: _durationFromJson, name: 'wtime')
        required Duration whiteTime,
    @JsonKey(fromJson: _durationFromJson, name: 'btime')
        required Duration blackTime,
  }) = _GameClock;

  factory GameClock.fromJson(Map<String, dynamic> json) =>
      _$GameClockFromJson(json);
}

@freezed
class GameState with _$GameState {
  const GameState._();

  const factory GameState(
      {required GameStatus status,
      required List<String> uciMoves,
      required List<String> sanMoves,
      required Position<Chess> position}) = _GameState;

  factory GameState.fromJson(Map<String, dynamic> json) {
    final uciMoves = (json['moves'] as String)
        .split(' ')
        .where((m) => m.isNotEmpty)
        .toList();
    Position<Chess> pos = Chess.initial;
    List<String> sanMoves = [];
    for (final m in uciMoves) {
      final move = Move.fromUci(m);
      final newPos = pos.playToSan(move);
      pos = newPos.item1;
      sanMoves.add(newPos.item2);
    }
    return GameState(
      status: GameStatus.values.firstWhere((e) => e.name == json['status'],
          orElse: () => GameStatus.unknown),
      uciMoves: List.unmodifiable(uciMoves),
      sanMoves: List.unmodifiable(sanMoves),
      position: pos,
    );
  }

  Move? get lastMove =>
      uciMoves.isNotEmpty ? Move.fromUci(uciMoves[uciMoves.length - 1]) : null;
  bool get abortable => status == GameStatus.started && position.fullmoves <= 1;
  bool get resignable => status == GameStatus.started && position.fullmoves > 1;
  bool get playing => status == GameStatus.started;
  bool get gameOver => status.value > GameStatus.started.value;
  Map<String, Set<String>> get validMoves => algebraicLegalMoves(position);
  bool get isLastMoveCapture {
    final lm = sanMoves.isNotEmpty ? sanMoves[sanMoves.length - 1] : null;
    return lm != null ? lm.contains('x') : false;
  }
}
