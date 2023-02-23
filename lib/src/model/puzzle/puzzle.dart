import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/common/chess.dart';

part 'puzzle.freezed.dart';
part 'puzzle.g.dart';

@Freezed(fromJson: true, toJson: true)
class Puzzle with _$Puzzle {
  const factory Puzzle({
    required PuzzleData puzzle,
    required PuzzleGame game,
  }) = _Puzzle;

  factory Puzzle.fromJson(Map<String, dynamic> json) => _$PuzzleFromJson(json);
}

@Freezed(fromJson: true, toJson: true)
class PuzzleData with _$PuzzleData {
  const PuzzleData._();

  const factory PuzzleData({
    required PuzzleId id,
    required int rating,
    required int plays,
    required int initialPly,
    required IList<UCIMove> solution,
    required ISet<String> themes,
  }) = _PuzzleData;

  /// Test user moves against solution.
  bool testSolution(Iterable<SanMove> sanMoves) {
    for (var i = 0; i < sanMoves.length; i++) {
      final sanMove = sanMoves.elementAt(i);
      final uci = sanMove.move.uci;
      final isCheckmate = sanMove.san.endsWith('#');
      final solutionUci = solution.getOrNull(i);
      if (isCheckmate) {
        return true;
      }
      if (uci != solutionUci &&
          (!altCastles.containsKey(uci) || altCastles[uci] != solutionUci)) {
        return false;
      }
    }
    return true;
  }

  factory PuzzleData.fromJson(Map<String, dynamic> json) =>
      _$PuzzleDataFromJson(json);
}

@Freezed(fromJson: true, toJson: true)
class PuzzleGame with _$PuzzleGame {
  const factory PuzzleGame({
    required GameId id,
    required Perf perf,
    required bool rated,
    required PuzzlePlayer white,
    required PuzzlePlayer black,
    required String pgn,
    TimeIncrement? clock,
  }) = _PuzzleGame;

  factory PuzzleGame.fromJson(Map<String, dynamic> json) =>
      _$PuzzleGameFromJson(json);
}

@Freezed(fromJson: true, toJson: true)
class PuzzlePlayer with _$PuzzlePlayer {
  const factory PuzzlePlayer({
    required Side side,
    required String userId,
    required String name,
    String? title,
  }) = _PuzzlePlayer;

  factory PuzzlePlayer.fromJson(Map<String, dynamic> json) =>
      _$PuzzlePlayerFromJson(json);
}

@Freezed(fromJson: true, toJson: true)
class PuzzleSolution with _$PuzzleSolution {
  const factory PuzzleSolution({
    required PuzzleId id,
    required bool win,
    required bool rated,
  }) = _PuzzleSolution;

  factory PuzzleSolution.fromJson(Map<String, dynamic> json) =>
      _$PuzzleSolutionFromJson(json);
}
