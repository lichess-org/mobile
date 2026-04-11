import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/offline_computer/practice_comment.dart';

part 'computer_analysis.freezed.dart';

/// Analysis data associated with a game step in offline computer mode.
///
/// For player-turn steps, contains the pre-move engine evaluation (from which
/// hints, best moves, winning chances, and eval string are derived).
/// For player-move steps, contains the practice comment for the move.
@freezed
sealed class ComputerAnalysis with _$ComputerAnalysis {
  const ComputerAnalysis._();

  const factory ComputerAnalysis({
    /// The engine evaluation for this position (pre-move, for player-turn steps).
    ClientEval? eval,

    /// Practice comment for the move that led to this step (post-move).
    PracticeComment? practiceComment,
  }) = _ComputerAnalysis;

  /// The best moves from the engine evaluation with their winning chances.
  IList<MoveWithWinningChances>? get bestMoves => eval?.bestMoves;

  /// The winning chances from the player's perspective (player is the side to move).
  double? get winningChances {
    final e = eval;
    if (e == null) return null;
    return e.winningChances(e.position.turn);
  }

  /// The evaluation string for the current position (e.g., "+0.5", "-1.2", "#3").
  String? get evalString => eval?.evalString;

  /// Hint moves for display on the board.
  ///
  /// Derived from [bestMoves] by filtering out moves that drop the evaluation
  /// by more than 10% winning chances, then deduplicating by origin square.
  IList<Move>? get hintMoves {
    final moves = bestMoves;
    if (moves == null || moves.isEmpty) return null;
    final topWinningChances = moves.first.winningChances;
    final seenOrigins = <Square>{};
    final goodMoves = <Move>[];
    for (final m in moves) {
      if (topWinningChances - m.winningChances > 0.1) continue;
      final origin = switch (m.move) {
        NormalMove(:final from) => from,
        DropMove() => null,
      };
      if (origin != null && !seenOrigins.contains(origin)) {
        seenOrigins.add(origin);
        goodMoves.add(m.move);
      }
    }
    return goodMoves.isEmpty ? null : goodMoves.toIList();
  }

  /// Creates a [ComputerAnalysis] from persisted step JSON fields.
  ///
  /// Only [practiceComment] is persisted; [eval] is recomputed at runtime.
  static ComputerAnalysis? fromStepJson(Map<String, dynamic> stepJson) {
    final practiceCommentJson = stepJson['practiceComment'];
    if (practiceCommentJson == null) return null;
    return ComputerAnalysis(
      practiceComment: PracticeComment.fromJson(practiceCommentJson as Map<String, dynamic>),
    );
  }

  /// Converts the persisted fields to a JSON map for step serialization.
  ///
  /// Only [practiceComment] is included; [eval] is not serialized.
  Map<String, dynamic> toStepJson() {
    if (practiceComment == null) return const {};
    return {'practiceComment': practiceComment!.toJson()};
  }
}
