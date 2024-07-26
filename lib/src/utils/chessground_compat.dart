import 'package:chessground/chessground.dart' as chessground;
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

IMap<chessground.SquareId, ISet<chessground.SquareId>>
    algebraicLegalMovesAsSquareIds(
  Position pos, {
  bool isChess960 = false,
}) {
  return algebraicLegalMoves(pos, isChess960: isChess960).map(
    (square, moves) => MapEntry(
      chessground.SquareId(square),
      moves.map((e) => chessground.SquareId(e)).toISet(),
    ),
  );
}

extension ChessgroundMoveCompat on Move {
  chessground.Move get cg {
    // !! Chessground doesn't support drop moves yet
    if (this is DropMove) {
      return chessground.Move(
        from: chessground.SquareId(toAlgebraic(to)),
        to: chessground.SquareId(toAlgebraic(to)),
      );
    }

    return chessground.Move(
      from: chessground.SquareId(toAlgebraic((this as NormalMove).from)),
      to: chessground.SquareId(toAlgebraic(to)),
      promotion: (this as NormalMove).promotion,
    );
  }
}
