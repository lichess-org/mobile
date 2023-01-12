import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/common/model/player.dart';
import 'package:lichess_mobile/src/features/game/model/time_control.dart';

part 'puzzle.freezed.dart';

@freezed
class Puzzle with _$Puzzle {
  const factory Puzzle({
    required PuzzleData puzzle,
    required PuzzleGame game,
  }) = _Puzzle;
}

@freezed
class PuzzleData with _$PuzzleData {
  const factory PuzzleData({
    required PuzzleId id,
    required int rating,
    required int plays,
    required int initialPly,
    required List<UCIMove> solution,
    required Set<String> themes,
  }) = _PuzzleData;
}

@freezed
class PuzzleGame with _$PuzzleGame {
  const factory PuzzleGame({
    required GameId id,
    required Perf perf,
    required bool rated,
    required LightPlayer white,
    required LightPlayer black,
    required String pgn,
    TimeInc? clock,
  }) = _PuzzleGame;
}
