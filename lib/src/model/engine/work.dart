import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';

part 'work.freezed.dart';

typedef EvalResult = (EvalWork, LocalEval);
typedef MoveResult = (MoveWork, UCIMove);

/// Base sealed class for engine work items.
sealed class Work {
  const Work();

  /// Optional identifier to associate this work with a game, puzzle, etc.
  StringId? get id;

  /// The engine preference to use (only relevant for Standard and Chess960 variants).
  ChessEnginePref get enginePref;
  Variant get variant;
  int get threads;
  int? get hashSize;
  Position get initialPosition;
  IList<Step> get steps;

  /// The search time for this work.
  Duration get searchTime;

  /// The number of principal variations to compute.
  int get multiPv;

  Position get position => steps.lastOrNull?.position ?? initialPosition;
}

/// A work item for position evaluation.
@freezed
sealed class EvalWork extends Work with _$EvalWork {
  const EvalWork._() : super();

  const factory EvalWork({
    /// Optional identifier to associate this work with a game, puzzle, etc.
    StringId? id,

    /// The engine preference to use (only relevant for Standard and Chess960 variants).
    required ChessEnginePref enginePref,
    required Variant variant,
    required int threads,
    int? hashSize,

    /// The path in the position tree. Nullable for contexts without a tree (e.g., offline games).
    UciPath? path,
    required Duration searchTime,
    required int multiPv,
    required bool threatMode,
    bool? isDeeper,
    required Position initialPosition,
    required IList<Step> steps,
  }) = _EvalWork;

  @override
  Position get position => steps.lastOrNull?.position ?? initialPosition;

  /// The (fake) position to use in threat mode searches.
  Position get threatModePosition {
    return position.copyWith(
      turn: position.turn.opposite,
      halfmoves: position.halfmoves + 1,
      fullmoves: position.turn == Side.black ? position.fullmoves + 1 : position.fullmoves,
    );
  }

  /// Cached eval for the work position.
  ClientEval? get evalCache => steps.lastOrNull?.eval;
}

/// A work item for finding the best move at a given engine strength level.
@freezed
sealed class MoveWork extends Work with _$MoveWork {
  const MoveWork._() : super();

  const factory MoveWork({
    /// Optional identifier to associate this work with a game, puzzle, etc.
    StringId? id,

    /// The engine preference to use (only relevant for Standard and Chess960 variants).
    required ChessEnginePref enginePref,
    required Variant variant,
    int? hashSize,
    required Position initialPosition,
    required IList<Step> steps,

    /// The Elo rating to simulate for the engine using UCI_LimitStrength and UCI_Elo.
    required int elo,
  }) = _MoveWork;

  @override
  Position get position => steps.lastOrNull?.position ?? initialPosition;

  /// Number of threads to use for move computation.
  ///
  /// Lower levels use 1 thread, higher levels use 2 threads for better move quality.
  ///
  /// | Level | Elo  | Threads |
  /// |-------|------|---------|
  /// | 1-5   | ≤1750| 1       |
  /// | 6-12  | >1750| 2       |
  @override
  int get threads => elo > 1750 ? 2 : 1;

  /// Number of principal variations to compute for move selection.
  ///
  /// Stockfish's strength limiting works by applying a randomized bias to scores
  /// of slightly worse moves among at least 4 candidates. MultiPV increases
  /// this candidate pool, giving more suboptimal moves to choose from at lower Elos.
  ///
  /// | Level | Elo  | MultiPV |
  /// |-------|------|---------|
  /// | 1     | 1320 | 10      |
  /// | 2     | 1450 | 8       |
  /// | 3     | 1550 | 7       |
  /// | 4     | 1650 | 6       |
  /// | 5     | 1750 | 5       |
  /// | 6     | 1850 | 4       |
  /// | 7     | 1950 | 4       |
  /// | 8     | 2100 | 4       |
  /// | 9     | 2300 | 4       |
  /// | 10    | 2550 | 4       |
  /// | 11    | 2850 | 3       |
  /// | 12    | 3190 | 3       |
  @override
  int get multiPv {
    if (elo <= 1650) {
      // Levels 1-4: fast drop from 10 to 6
      return (10 - ((elo - 1320) / (1650 - 1320) * 4)).round().clamp(6, 10);
    } else if (elo >= 2850) {
      // Level 11-12: 3
      return 3;
    } else if (elo >= 1850) {
      // Levels 6-10: 4
      return 4;
    } else {
      // Level 5: 5
      return 5;
    }
  }

  /// Search time based on Elo rating.
  ///
  /// Lower Elos get shorter search times since the strength limiting mechanism
  /// (randomized bias on move scores) selects the move early in the search
  /// at depth = 1 + Skill Level.
  ///
  /// | Level | Elo  | Search Time |
  /// |-------|------|-------------|
  /// | 1     | 1320 | 150ms       |
  /// | 2     | 1450 | 300ms       |
  /// | 3     | 1550 | 410ms       |
  /// | 4     | 1650 | 525ms       |
  /// | 5     | 1750 | 640ms       |
  /// | 6     | 1850 | 800ms       |
  /// | 7     | 1950 | 1115ms      |
  /// | 8     | 2100 | 1585ms      |
  /// | 9     | 2300 | 2210ms      |
  /// | 10    | 2550 | 2995ms      |
  /// | 11    | 2850 | 3935ms      |
  /// | 12    | 3190 | 5000ms      |
  @override
  Duration get searchTime {
    final int ms;
    if (elo <= 1750) {
      // Levels 1-5: linear from 150ms to 640ms
      ms = (150 + ((elo - 1320) / (1750 - 1320) * 490)).toInt();
    } else {
      // Levels 6-12: linear from 800ms to 5000ms
      ms = (800 + ((elo - 1850) / (3190 - 1850) * 4200)).toInt();
    }
    return Duration(milliseconds: ms.clamp(150, 5000));
  }
}

@freezed
sealed class Step with _$Step {
  const Step._();

  const factory Step({required Position position, required SanMove sanMove, ClientEval? eval}) =
      _Step;

  factory Step.fromNode(Branch node) {
    return Step(position: node.position, sanMove: node.sanMove, eval: node.eval);
  }

  /// Stockfish in chess960 mode always needs a "king takes rook" UCI notation.
  ///
  /// Cannot be used in chess960 variant where this notation is already forced and
  /// where it would conflict with the actual move.
  UCIMove get castleSafeUCI {
    if (sanMove.isCastles) {
      return _castleMoves.containsKey(sanMove.move.uci)
          ? _castleMoves[sanMove.move.uci]!
          : sanMove.move.uci;
    } else {
      return sanMove.move.uci;
    }
  }
}

const _castleMoves = {'e1c1': 'e1a1', 'e1g1': 'e1h1', 'e8c8': 'e8a8', 'e8g8': 'e8h8'};
