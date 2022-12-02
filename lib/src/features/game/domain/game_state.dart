import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartchess/dartchess.dart';

import './game_status.dart';

part 'game_state.freezed.dart';
part 'game_state.g.dart';

Duration _durationFromJson(int value) => Duration(milliseconds: value);

@Freezed(toJson: false)
class GameClock with _$GameClock {
  factory GameClock({
    @JsonKey(fromJson: _durationFromJson, name: 'wtime')
        required Duration whiteTime,
    @JsonKey(fromJson: _durationFromJson, name: 'btime')
        required Duration blackTime,
  }) = _GameClock;

  factory GameClock.fromJson(Map<String, dynamic> json) =>
      _$GameClockFromJson(json);
}

@immutable
class GameState extends Equatable {
  final GameStatus status;
  final List<String> uciMoves;
  final List<String> sanMoves;
  final Position<Chess> position;

  const GameState(
      {required this.status,
      required this.uciMoves,
      required this.sanMoves,
      required this.position});

  @override
  List<Object> get props => [status, uciMoves, sanMoves, position];

  factory GameState.fromJson(Map<String, dynamic> json) {
    final String moves = json['moves'];
    final uciMoves = moves.split(' ').where((m) => m.isNotEmpty).toList();
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
  bool get abortable => status == GameStatus.started && position.fullmoves < 1;
  bool get resignable => status == GameStatus.started && position.fullmoves > 1;
  bool get playing => status == GameStatus.started;
  Map<String, Set<String>> get validMoves => algebraicLegalMoves(position);
  bool get isLastMoveCapture {
    final lm = sanMoves.isNotEmpty ? sanMoves[sanMoves.length - 1] : null;
    return lm != null ? lm.contains('x') : false;
  }

  GameState copyWith({
    GameStatus? status,
    List<String>? uciMoves,
    List<String>? sanMoves,
    Position<Chess>? position,
  }) {
    return GameState(
      status: status ?? this.status,
      uciMoves: uciMoves ?? this.uciMoves,
      sanMoves: sanMoves ?? this.sanMoves,
      position: position ?? this.position,
    );
  }
}
