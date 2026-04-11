import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';

part 'practice_comment.freezed.dart';
part 'practice_comment.g.dart';

/// Maximum winning chances shift for a move to be considered good.
const kGoodMoveThreshold = 0.05;

/// Maximum winning chances shift for a move to be considered an inaccuracy.
const kInaccuracyThreshold = 0.11;

/// Maximum winning chances shift for a move to be considered a mistake.
const kMistakeThreshold = 0.24;

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

    /// The move suggestion to display as an alternative to the move played.
    SanMove? moveSuggestion,

    /// The evaluation string after the move (e.g., "+0.5", "-1.2", "#3").
    String? evalAfter,

    /// Whether the move is a book move (found in the master database).
    @Default(false) bool isBookMove,
  }) = _PracticeComment;
}
