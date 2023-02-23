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
      promotion: (this as NormalMove).promotion?.cg,
    );
  }
}

extension ChessgroundRoleCompat on Role {
  chessground.Role get cg {
    switch (this) {
      case Role.pawn:
        return chessground.Role.pawn;
      case Role.knight:
        return chessground.Role.knight;
      case Role.bishop:
        return chessground.Role.bishop;
      case Role.rook:
        return chessground.Role.rook;
      case Role.king:
        return chessground.Role.king;
      case Role.queen:
        return chessground.Role.queen;
    }
  }
}
