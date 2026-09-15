import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/learn/learn_position.dart';
import 'package:meta/meta.dart';

/// A translated string, resolved when displayed.
typedef LearnText = String Function(AppLocalizations l10n);

/// The color of a [LearnShape].
enum LearnBrush() {
  green,
  paleGreen,
  red,
  yellow,
  blue,
}

/// An arrow or a circle drawn on the board as a hint.
@immutable
class const LearnShape({
  required final Square orig,
  final Square? dest,
  required final LearnBrush brush,
}) {
  @override
  bool operator ==(Object other) =>
      other is LearnShape && other.orig == orig && other.dest == dest && other.brush == brush;

  @override
  int get hashCode => Object.hash(orig, dest, brush);
}

/// An arrow for a UCI string such as `'e2e4'`.
LearnShape arrow(String uci, [LearnBrush brush = .paleGreen]) => LearnShape(
  orig: Square.fromName(uci.substring(0, 2)),
  dest: Square.fromName(uci.substring(2, 4)),
  brush: brush,
);

/// A circle for a square name such as `'e4'`.
LearnShape circle(String square, [LearnBrush brush = .green]) =>
    LearnShape(orig: Square.fromName(square), brush: brush);

/// One scripted move of a [LearnLevel] scenario, with the hints shown once it is played.
@immutable
class const ScenarioStep(
  final String uci, {
  final IList<LearnShape> shapes = const IListConst([]),
}) {
  NormalMove get move => NormalMove.fromUci(uci);
}

/// Whether an opponent capture after the player's move fails the level.
enum DetectCapture() {
  /// Captures are allowed.
  none,

  /// A capture fails the level unless the player can take back on the same square.
  unprotected,

  /// Any capture fails the level.
  any,
}

/// What the success and failure predicates of a level can look at.
///
/// Predicates are evaluated right after the player's move, before the turn is handed back to the
/// player, so [position] has the opponent to move.
@immutable
class const LearnAssertData({
  required final LearnPosition position,

  /// Number of moves the player has made in the level, including the last one.
  required final int nbMoves,
  required final bool scenarioComplete,
  required final bool scenarioFailed,

  /// The castling side of the last move, if it was castling.
  required final CastlingSide? lastMoveCastling,
});

typedef LearnAssert = bool Function(LearnAssertData data);

/// A single exercise of a [LearnStage].
@immutable
class const LearnLevel({
  required final LearnText goal,

  /// The starting position, without the apples.
  required final LearnPosition position,

  /// The side the player plays.
  ///
  /// Usually the side to move, except in levels where the opponent's scripted move comes first.
  required final Side color,

  /// The par, used for scoring only.
  required final int nbMoves,

  /// The squares holding stars to collect.
  required final ISet<Square> apples,

  /// Whether the apple squares are left empty.
  ///
  /// By default an enemy pawn is placed under each apple, so that moving onto it is a capture. That
  /// also means apples block pawns and can be attacked, which the king levels do not want.
  required final bool emptyApples,
  required final IList<LearnShape> shapes,

  /// The scripted moves, alternating between the player and the opponent from the side to move.
  required final IList<ScenarioStep> scenario,

  /// Success predicate. Collecting every apple when null.
  required final LearnAssert? success,
  required final LearnAssert? failure,
  required final DetectCapture detectCapture,

  /// Number of captures needed to complete the level, used for the maximum score.
  required final int captures,
  required final bool explainPromotion,

  /// Whether the level waits for the player to go to the next one once complete.
  required final bool nextButton,

  /// Whether the player may make moves that leave their king in check, which fails the level.
  required final bool offerIllegalMove,

  /// Whether captures score points.
  required final bool pointsForCapture,

  /// Whether captures score the value of the piece taken instead of a fixed amount.
  required final bool showPieceValues,

  /// Whether the opponent makes a random move after the player fails.
  required final bool showFailureFollowUp,

  /// A rank, from 1 to 8, emphasized on the board.
  required final int? highlightedRank,
}) {
  /// Builds a level from the same shape as the lichess.org stage definitions.
  ///
  /// [apples] is a space-separated list of square names. [color] defaults to the side to move of
  /// [fen], and [detectCapture] to [DetectCapture.unprotected] unless the level has apples.
  factory parse({
    required LearnText goal,
    required String fen,
    required int nbMoves,
    String apples = '',
    Side? color,
    DetectCapture? detectCapture,
    bool emptyApples = false,
    List<LearnShape> shapes = const [],
    List<ScenarioStep> scenario = const [],
    LearnAssert? success,
    LearnAssert? failure,
    int captures = 0,
    bool explainPromotion = false,
    bool nextButton = false,
    bool offerIllegalMove = false,
    bool pointsForCapture = false,
    bool showPieceValues = false,
    bool showFailureFollowUp = false,
    int? highlightedRank,
  }) {
    final position = LearnPosition.fromFen(fen);
    return LearnLevel(
      goal: goal,
      position: position,
      color: color ?? position.turn,
      nbMoves: nbMoves,
      apples: apples.isEmpty
          ? const ISetConst({})
          : apples.split(' ').map(Square.fromName).toISet(),
      emptyApples: emptyApples,
      shapes: shapes.lock,
      scenario: scenario.lock,
      success: success,
      failure: failure,
      detectCapture: detectCapture ?? (apples.isEmpty ? .unprotected : .none),
      captures: captures,
      explainPromotion: explainPromotion,
      nextButton: nextButton,
      offerIllegalMove: offerIllegalMove,
      pointsForCapture: pointsForCapture,
      showPieceValues: showPieceValues,
      showFailureFollowUp: showFailureFollowUp,
      highlightedRank: highlightedRank,
    );
  }
}

/// A lesson of the learn feature, made of several levels.
@immutable
class const LearnStage({
  /// The key under which progress is stored, shared with lichess.org.
  required final String key,
  required final LearnText title,
  required final LearnText subtitle,

  /// The name of the stage illustration, from `assets/images/learn/`.
  required final String image,
  required final LearnText intro,
  required final LearnText complete,
  required final IList<LearnLevel> levels,
});

/// A group of stages.
@immutable
class const LearnCategory({
  required final String key,
  required final LearnText name,
  required final IList<LearnStage> stages,
});
