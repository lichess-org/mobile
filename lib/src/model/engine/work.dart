import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/stockfish_level.dart';
import 'package:multistockfish/multistockfish.dart';

part 'work.freezed.dart';

typedef EvalResult = (EvalWork, LocalEval);
typedef MoveResult = (MoveWork, UCIMove);

/// Base sealed class for engine work items.
sealed class Work {
  const Work();

  /// Identifier to associate this work with a game, puzzle, etc.
  StringId get id;

  /// The engine to use (if variant is Standard or Chess960, otherwise [StockfishFlavor.variant] will be used).
  StockfishFlavor get stockfishFlavor;
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
    /// Identifier to associate this work with a game, puzzle, etc.
    required StringId id,

    required StockfishFlavor stockfishFlavor,
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
    /// Identifier to associate this work with a game, puzzle, etc.
    required StringId id,
    required Variant variant,
    int? hashSize,
    required Position initialPosition,
    required IList<Step> steps,

    /// The Stockfish strength level.
    required StockfishLevel level,
  }) = _MoveWork;

  /// The Stockfish flavor to use with MoveWork.
  ///
  /// It is always set to [StockfishFlavor.variant] since only Fairy-Stockfish supports negative skill levels.
  @override
  StockfishFlavor get stockfishFlavor => StockfishFlavor.variant;

  @override
  Position get position => steps.lastOrNull?.position ?? initialPosition;

  /// The skill level from -20 to 20. For Stockfish option "Skill Level".
  int get skill => level.skill;

  @override
  int get threads => level.threads;

  @override
  int get multiPv => level.multiPv;

  @override
  Duration get searchTime => level.searchTime;
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
