import 'package:dartchess/dartchess.dart';
import 'package:lichess_mobile/src/model/learn/learn_position.dart';
import 'package:meta/meta.dart';

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

/// The success or failure condition of a learn level.
///
/// Build one with the factories below and combine them with [and], [or], [not], [every] and [any];
/// call it on a [LearnAssertData] to evaluate it. Mirrors the combinators of
/// `ui/learn/src/assert.ts` on lichess.org.
///
/// In a position where the type is known, the factories read as dot shorthands:
///
/// ```dart
/// LearnLevel.parse(success: .extinct(Side.black), failure: .check.not, ...)
/// ```
@immutable
class const LearnAssert(final bool Function(LearnAssertData data) _test) {
  /// Evaluates the condition.
  bool call(LearnAssertData data) => _test(data);

  /// True when [piece] stands on [square], a square name such as `'e4'`.
  factory pieceOn(Piece piece, String square) =>
      LearnAssert((data) => data.position.board.pieceAt(Square.fromName(square)) == piece);

  /// True when [piece] does not stand on [square].
  factory pieceNotOn(Piece piece, String square) => LearnAssert.pieceOn(piece, square).not;

  /// True when a piece stands outside of [squares], a space-separated list of square names.
  factory noPieceOn(String squares) {
    final allowed = _parseSquares(squares);
    return LearnAssert((data) => data.position.board.occupied.diff(allowed).isNotEmpty);
  }

  /// True when a white pawn stands on any of [squares], a space-separated list of square names.
  factory whitePawnOnAnyOf(String squares) {
    final set = _parseSquares(squares);
    return LearnAssert(
      (data) => data.position.board.piecesOf(Side.white, Role.pawn).isIntersected(set),
    );
  }

  /// True when [side] has no piece left.
  factory extinct(Side side) => LearnAssert((data) => data.position.board.bySide(side).isEmpty);

  /// True when the last move castled on [side].
  factory castled(CastlingSide side) => LearnAssert((data) => data.lastMoveCastling == side);

  /// True when the opponent is in check within [nbMoves] moves.
  factory checkIn(int nbMoves) =>
      LearnAssert((data) => data.nbMoves <= nbMoves && data.position.isCheck);

  /// True when the opponent is still not in check after [nbMoves] moves.
  factory noCheckIn(int nbMoves) =>
      LearnAssert((data) => data.nbMoves >= nbMoves && !data.position.isCheck);

  /// True when the opponent is in check.
  static const check = LearnAssert(_check);

  /// True when the opponent is checkmated.
  static const mate = LearnAssert(_mate);

  /// True when the player has played every scripted move of the scenario.
  static const scenarioComplete = LearnAssert(_scenarioComplete);

  /// True when the player has deviated from the scenario.
  static const scenarioFailed = LearnAssert(_scenarioFailed);

  /// True when every one of [assertions] is true.
  factory every(List<LearnAssert> assertions) =>
      LearnAssert((data) => assertions.every((a) => a(data)));

  /// True when any one of [assertions] is true.
  factory any(List<LearnAssert> assertions) =>
      LearnAssert((data) => assertions.any((a) => a(data)));

  /// True when this condition is false.
  LearnAssert get not => LearnAssert((data) => !this(data));

  /// True when both this condition and [other] are true.
  LearnAssert and(LearnAssert other) => LearnAssert((data) => this(data) && other(data));

  /// True when this condition or [other] is true.
  LearnAssert or(LearnAssert other) => LearnAssert((data) => this(data) || other(data));
}

bool _check(LearnAssertData data) => data.position.isCheck;

bool _mate(LearnAssertData data) => data.position.isCheckmate;

bool _scenarioComplete(LearnAssertData data) => data.scenarioComplete;

bool _scenarioFailed(LearnAssertData data) => data.scenarioFailed;

SquareSet _parseSquares(String squares) =>
    SquareSet.fromSquares(squares.split(' ').map(Square.fromName));
