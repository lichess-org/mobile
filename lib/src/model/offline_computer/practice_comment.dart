import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/widgets/pgn.dart';

part 'practice_comment.freezed.dart';
part 'practice_comment.g.dart';

/// Maximum winning chances shift for a move to be considered good.
const kGoodMoveThreshold = 0.04;

/// Maximum winning chances shift for a move to be considered an inaccuracy.
const kInaccuracyThreshold = 0.08;

/// Maximum winning chances shift for a move to be considered a mistake.
const kMistakeThreshold = 0.18;

/// Winning chances threshold above which a position is considered winning.
///
/// 0.5 corresponds to roughly +200cp (+2.0 pawns advantage).
const kWinningThreshold = 0.5;

/// The verdict for a player's move in practice mode.
///
/// Based on the winning chances difference between the position before and after the move.
/// Thresholds loosely adapted from lila practice mode.
enum MoveVerdict {
  /// The move is good (shift < [kGoodMoveThreshold] or no better move exists).
  goodMove,

  /// The move is not the best but keeps a winning position.
  notBest,

  /// The move is an inaccuracy ([kGoodMoveThreshold] <= shift < [kInaccuracyThreshold]).
  inaccuracy,

  /// The move is a mistake ([kInaccuracyThreshold] <= shift < [kMistakeThreshold]).
  mistake,

  /// The move is a blunder (shift >= [kMistakeThreshold]).
  blunder;

  /// Returns the verdict based on the winning chances shift.
  ///
  /// [shift] is the negative difference in winning chances between the played move
  /// and the best move evaluation. A larger shift indicates a greater deterioration.
  /// [hasBetterMove] indicates whether there was a better move available.
  /// [winningChancesBefore] and [winningChancesAfter] are the player's POV winning
  /// chances before and after the move, used to determine if the position stays winning.
  static MoveVerdict fromShift(
    double shift, {
    required bool hasBetterMove,
    required double winningChancesBefore,
    required double winningChancesAfter,
  }) {
    if (!hasBetterMove) return .goodMove;
    if (shift < kGoodMoveThreshold) return .goodMove;
    // If the position was winning and is still winning, the move is suboptimal but not a real mistake.
    if (winningChancesBefore >= kWinningThreshold && winningChancesAfter >= kWinningThreshold) {
      return .notBest;
    }
    if (shift < kInaccuracyThreshold) return .inaccuracy;
    if (shift < kMistakeThreshold) return .mistake;
    return .blunder;
  }

  /// The icon for this verdict.
  IconData get icon => switch (this) {
    .goodMove => Icons.check_circle,
    .notBest => Icons.info,
    .inaccuracy => Icons.help,
    .mistake => Icons.error,
    .blunder => Icons.cancel,
  };

  /// The color for this verdict.
  Color get color => switch (this) {
    .goodMove => Colors.lightGreen,
    .notBest => Colors.lightGreen,
    .inaccuracy => innacuracyColor,
    .mistake => mistakeColor,
    .blunder => blunderColor,
  };

  /// The symbol for this verdict.
  String get symbol => switch (this) {
    .goodMove => '!',
    .notBest => '!?',
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

    /// Whether the move is a book move (found in the master database).
    @Default(false) bool isBookMove,
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

  /// The icon to display for this comment.
  ///
  /// Shows a book icon for book moves, otherwise the verdict icon.
  IconData get icon => isBookMove ? Icons.menu_book : verdict.icon;

  /// The color to display for this comment.
  Color get color => verdict.color;
}
