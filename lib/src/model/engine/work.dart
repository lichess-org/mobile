import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/computer/computer_game.dart';

part 'work.freezed.dart';

typedef EvalResult = (AnalysisWork, LocalEval);

/// A work item for the engine.
sealed class Work {
  const Work({required this.threads, this.hashSize, required this.multiPv});

  final int threads;
  final int? hashSize;
  final int multiPv;
}

@freezed
sealed class AnalysisWork extends Work with _$AnalysisWork {
  const AnalysisWork._({required super.threads, super.hashSize, required super.multiPv});

  const factory AnalysisWork({
    required Variant variant,
    required int threads,
    int? hashSize,
    required UciPath path,
    required Duration searchTime,
    int? depth,
    required int multiPv,
    required bool threatMode,
    bool? isDeeper,
    required Position initialPosition,
    required IList<Step> steps,
  }) = _AnalysisWork;

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

@freezed
sealed class MoveWork with _$MoveWork implements Work {
  const MoveWork._();

  const factory MoveWork({
    required String fen,
    required StockfishLevel level,
    // do we want to allow clock in offline Stockfish ?
    required ClockData? clock,
  }) = _MoveWork;

  @override
  // maybe use engine setting for the number of threads ?
  // should it be a different setting of analysis ?
  int get threads => 1;

  @override
  int? get hashSize => null;

  @override
  int get multiPv => 1;
}

@freezed
sealed class ClockData with _$ClockData {
  const factory ClockData({
    required Duration whiteTime,
    required Duration blackTime,
    required Duration whiteIncrement,
    required Duration blackIncrement,
  }) = _ClockData;
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
