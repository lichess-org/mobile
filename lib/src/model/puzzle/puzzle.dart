import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';

part 'puzzle.freezed.dart';
part 'puzzle.g.dart';

@Freezed(fromJson: true, toJson: true)
sealed class const Puzzle._() with _$Puzzle {
  const factory({required PuzzleData puzzle, required PuzzleGame game, bool? isDailyPuzzle}) =
      _Puzzle;

  factory fromJson(Map<String, dynamic> json) => _$PuzzleFromJson(json);

  /// Test user moves against solution.
  bool testSolution(Iterable<SanMove> sanMoves) {
    for (var i = 0; i < sanMoves.length; i++) {
      final sanMove = sanMoves.elementAt(i);
      final uci = sanMove.move.uci;
      final solutionUci = puzzle.solution.getOrNull(i);
      if (sanMove.isCheckmate) {
        return true;
      }
      if (uci != solutionUci && (!sanMove.isCastles || altCastles[uci] != solutionUci)) {
        return false;
      }
    }
    return true;
  }
}

@Freezed(fromJson: true, toJson: true)
sealed class const PuzzleData._() with _$PuzzleData {
  const factory({
    required PuzzleId id,
    required int rating,
    required int plays,
    required int initialPly,
    required IList<UCIMove> solution,
    required ISet<String> themes,
  }) = _PuzzleData;

  Side get sideToMove => initialPly.isEven ? Side.black : Side.white;

  factory fromJson(Map<String, dynamic> json) => _$PuzzleDataFromJson(json);
}

@Freezed(fromJson: true, toJson: true)
sealed class const PuzzleGlicko._() with _$PuzzleGlicko {
  const factory({required double rating, required double deviation, bool? provisional}) =
      _PuzzleGlicko;

  factory fromJson(Map<String, dynamic> json) => _$PuzzleGlickoFromJson(json);
}

@freezed
sealed class PuzzleRound with _$PuzzleRound {
  const factory({required PuzzleId id, required int ratingDiff, required bool win}) = _PuzzleRound;
}

@Freezed(fromJson: true, toJson: true)
sealed class PuzzleGame with _$PuzzleGame {
  const factory({
    required GameId id,
    required Perf perf,
    required bool rated,
    required PuzzleGamePlayer white,
    required PuzzleGamePlayer black,
    required String pgn,
  }) = _PuzzleGame;

  factory fromJson(Map<String, dynamic> json) => _$PuzzleGameFromJson(json);
}

@Freezed(fromJson: true, toJson: true)
sealed class PuzzleGamePlayer with _$PuzzleGamePlayer {
  const factory({required Side side, required String name, String? title}) = _PuzzleGamePlayer;

  factory fromJson(Map<String, dynamic> json) => _$PuzzleGamePlayerFromJson(json);
}

@Freezed(fromJson: true, toJson: true)
sealed class PuzzleSolution with _$PuzzleSolution {
  const factory({required PuzzleId id, required bool win, required bool rated}) = _PuzzleSolution;

  factory fromJson(Map<String, dynamic> json) => _$PuzzleSolutionFromJson(json);
}

@freezed
sealed class PuzzlePreview with _$PuzzlePreview {
  const factory({
    required Side orientation,
    required String initialFen,
    required Move initialMove,
  }) = _PuzzlePreview;

  factory fromPuzzle(Puzzle puzzle) {
    final root = Root.fromPgnMoves(puzzle.game.pgn);
    final node = root.nodeAt(root.mainlinePath) as Branch;
    return PuzzlePreview(
      orientation: node.position.ply.isEven ? Side.white : Side.black,
      initialFen: node.position.fen,
      initialMove: node.sanMove.move,
    );
  }
}

@Freezed(fromJson: true)
sealed class const LitePuzzle._() with _$LitePuzzle {
  const factory({
    required PuzzleId id,
    required String fen,
    required IList<UCIMove> solution,
    required int rating,
  }) = _LitePuzzle;

  factory fromJson(Map<String, dynamic> json) => _$LitePuzzleFromJson(json);

  (Side, String, Move) get preview {
    final pos1 = Chess.fromSetup(Setup.parseFen(fen));
    final move = Move.parse(solution.first);
    final pos = pos1.play(move!);
    return (pos.turn, pos.fen, move);
  }
}

@freezed
sealed class PuzzleDashboard with _$PuzzleDashboard {
  const factory({required PuzzleDashboardData global, required IList<PuzzleDashboardData> themes}) =
      _PuzzleDashboard;
}

@freezed
sealed class PuzzleDashboardData with _$PuzzleDashboardData {
  const factory({
    required int nb,
    required int firstWins,
    required int replayWins,
    required int performance,
    required PuzzleThemeKey theme,
  }) = _PuzzleDashboardData;
}

@freezed
sealed class const PuzzleHistoryEntry._() with _$PuzzleHistoryEntry {
  const factory({
    required bool win,
    required DateTime date,
    required PuzzleId id,
    required int rating,
    required String fen,
    required Move lastMove,
    Duration? solvingTime,
  }) = _PuzzleHistoryEntry;

  factory fromLitePuzzle(LitePuzzle puzzle, bool win, Duration duration) {
    final (_, fen, move) = puzzle.preview;
    return PuzzleHistoryEntry(
      date: DateTime.now(),
      win: win,
      id: puzzle.id,
      rating: puzzle.rating,
      fen: fen,
      lastMove: move,
      solvingTime: duration,
    );
  }

  (String, Side, Move) get preview => (fen, Chess.fromSetup(Setup.parseFen(fen)).turn, lastMove);
}
