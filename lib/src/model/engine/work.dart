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
    required UciPath path,
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
    required int threads,
    int? hashSize,
    required Position initialPosition,
    required IList<Step> steps,

    /// The Elo rating to simulate for the engine using UCI_LimitStrength and UCI_Elo.
    required int elo,
  }) = _MoveWork;

  @override
  Position get position => steps.lastOrNull?.position ?? initialPosition;

  /// Number of principal variations to compute for move selection.
  @override
  int get multiPv => 4;

  /// Search time based on Elo rating.
  /// Higher Elo gets more search time for better move quality.
  @override
  Duration get searchTime {
    // Scale search time based on elo: 500ms at 1000 elo, up to 2000ms at 2500 elo
    final ms = ((elo - 1000) / 1500 * 1500 + 500).clamp(500, 2000).toInt();
    return Duration(milliseconds: ms);
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
