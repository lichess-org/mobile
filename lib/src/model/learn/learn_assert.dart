import 'package:dartchess/dartchess.dart';
import 'package:lichess_mobile/src/model/learn/learn_level.dart';

/// Combinators for the success and failure predicates of the learn levels.
///
/// Mirrors `ui/learn/src/assert.ts` on lichess.org.

LearnAssert pieceOn(Piece piece, String square) =>
    (data) => data.position.board.pieceAt(Square.fromName(square)) == piece;

LearnAssert pieceNotOn(Piece piece, String square) => not(pieceOn(piece, square));

/// True when a piece stands outside of [squares], a space-separated list of square names.
LearnAssert noPieceOn(String squares) {
  final allowed = _parseSquares(squares);
  return (data) => data.position.board.occupied.diff(allowed).isNotEmpty;
}

LearnAssert whitePawnOnAnyOf(String squares) {
  final set = _parseSquares(squares);
  return (data) => data.position.board.piecesOf(Side.white, Role.pawn).isIntersected(set);
}

/// True when [side] has no piece left.
LearnAssert extinct(Side side) =>
    (data) => data.position.board.bySide(side).isEmpty;

/// True when the opponent is in check.
bool check(LearnAssertData data) => data.position.isCheck;

/// True when the opponent is checkmated.
bool mate(LearnAssertData data) => data.position.isCheckmate;

/// True when the last move castled on [side].
LearnAssert castled(CastlingSide side) =>
    (data) => data.lastMoveCastling == side;

LearnAssert checkIn(int nbMoves) =>
    (data) => data.nbMoves <= nbMoves && data.position.isCheck;

LearnAssert noCheckIn(int nbMoves) =>
    (data) => data.nbMoves >= nbMoves && !data.position.isCheck;

LearnAssert not(LearnAssert assertion) =>
    (data) => !assertion(data);

LearnAssert and(List<LearnAssert> assertions) =>
    (data) => assertions.every((a) => a(data));

LearnAssert or(List<LearnAssert> assertions) =>
    (data) => assertions.any((a) => a(data));

bool scenarioComplete(LearnAssertData data) => data.scenarioComplete;

bool scenarioFailed(LearnAssertData data) => data.scenarioFailed;

SquareSet _parseSquares(String squares) =>
    SquareSet.fromSquares(squares.split(' ').map(Square.fromName));
