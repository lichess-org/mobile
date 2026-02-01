import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/widgets/pgn.dart';

part 'practice_comment.freezed.dart';
part 'practice_comment.g.dart';

/// The verdict for a player's move in practice mode.
///
/// Based on the winning chances difference between the position before and after the move.
/// Thresholds from lila: https://github.com/veloce/lila/blob/master/ui/analyse/src/practice/practiceCtrl.ts
enum MoveVerdict {
  /// The move is good (winning chances shift < 0.025 or no better move exists).
  goodMove,

  /// The move is an inaccuracy (0.025 <= shift < 0.06).
  inaccuracy,

  /// The move is a mistake (0.06 <= shift < 0.14).
  mistake,

  /// The move is a blunder (shift >= 0.14).
  blunder;

  /// Returns the verdict based on the winning chances shift.
  ///
  /// [shift] is the negative difference in winning chances between the played move
  /// and the best move evaluation. A larger shift indicates a greater deterioration.
  /// [hasBetterMove] indicates whether there was a better move available.
  static MoveVerdict fromShift(double shift, {required bool hasBetterMove}) {
    if (!hasBetterMove) return .goodMove;
    if (shift < 0.025) return .goodMove;
    if (shift < 0.06) return .inaccuracy;
    if (shift < 0.14) return .mistake;
    return .blunder;
  }

  /// The icon for this verdict.
  IconData get icon => switch (this) {
    .goodMove => Icons.check_circle,
    .inaccuracy => Icons.help,
    .mistake => Icons.error,
    .blunder => Icons.cancel,
  };

  /// The color for this verdict.
  Color get color => switch (this) {
    .goodMove => Colors.lightGreen,
    .inaccuracy => innacuracyColor,
    .mistake => mistakeColor,
    .blunder => blunderColor,
  };

  /// The symbol for this verdict.
  String get symbol => switch (this) {
    .goodMove => '!',
    .inaccuracy => '?!',
    .mistake => '?',
    .blunder => '??',
  };
}

/// A comment about a player's move in practice mode.
@Freezed(fromJson: true, toJson: true)
sealed class PracticeComment with _$PracticeComment {
  const PracticeComment._();

  factory PracticeComment.fromJson(Map<String, dynamic> json) => _$PracticeCommentFromJson(json);

  const factory PracticeComment({
    /// The verdict for the move.
    required MoveVerdict verdict,

    /// The best move that was available in SAN format (shown if verdict is not goodMove).
    SanMove? bestMove,

    /// An alternative good move in SAN format (shown if verdict is goodMove and there was another good option).
    SanMove? alternativeGoodMove,

    /// The winning chances before the move was made.
    required double winningChancesBefore,

    /// The winning chances after the move was made.
    required double winningChancesAfter,

    /// The evaluation string after the move (e.g., "+0.5", "-1.2", "#3").
    String? evalAfter,
  }) = _PracticeComment;

  /// The shift in winning chances (how much the position deteriorated).
  double get shift => winningChancesBefore - winningChancesAfter;

  /// Whether to show a suggested move.
  bool get hasSuggestedMove => bestMove != null || alternativeGoodMove != null;

  /// The move to show as suggestion.
  ///
  /// For good moves, prefer showing an alternative good move if available,
  /// otherwise fall back to the best move.
  SanMove? get suggestedMove => verdict == .goodMove ? (alternativeGoodMove ?? bestMove) : bestMove;

  /// Whether the suggested move is an alternative (vs the best move).
  ///
  /// Used to determine which label to show ("Another was" vs "Best was").
  bool get isShowingAlternative => verdict == .goodMove && alternativeGoodMove != null;
}
