import 'package:dartchess/dartchess.dart';
import 'package:chessground/chessground.dart' as chessground;

extension ChessgroundSideCompat on Side {
  chessground.Side get cg =>
      this == Side.white ? chessground.Side.white : chessground.Side.black;
}

extension ChessgroundMoveCompat on Move {
  chessground.Move get cg {
    // !! Chessground doesn't support drop moves yet
    if (this is DropMove) {
      return chessground.Move(from: toAlgebraic(to), to: toAlgebraic(to));
    }

    return chessground.Move(
        from: toAlgebraic((this as NormalMove).from),
        to: toAlgebraic(to),
        promotion: (this as NormalMove).promotion?.cg);
  }
}

extension ChessgroundRoleCompat on Role {
  chessground.PieceRole get cg {
    switch (this) {
      case Role.pawn:
        return chessground.PieceRole.pawn;
      case Role.knight:
        return chessground.PieceRole.knight;
      case Role.bishop:
        return chessground.PieceRole.bishop;
      case Role.rook:
        return chessground.PieceRole.rook;
      case Role.king:
        return chessground.PieceRole.king;
      case Role.queen:
        return chessground.PieceRole.queen;
    }
  }
}
