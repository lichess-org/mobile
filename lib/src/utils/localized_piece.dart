import 'package:dartchess/dartchess.dart';
import 'package:flutter/widgets.dart';

extension LocalizedPiece on Piece {
  // TODO return localized piece name
  String? localizedName(BuildContext context) {
    switch ((color, role)) {
      case (Side.white, Role.pawn):
        return 'white pawn';
      case (Side.white, Role.knight):
        return 'white knight';
      case (Side.white, Role.bishop):
        return 'white bishop';
      case (Side.white, Role.rook):
        return 'white rook';
      case (Side.white, Role.queen):
        return 'white queen';
      case (Side.white, Role.king):
        return 'white king';
      case (Side.black, Role.pawn):
        return 'black pawn';
      case (Side.black, Role.knight):
        return 'black knight';
      case (Side.black, Role.bishop):
        return 'black bishop';
      case (Side.black, Role.rook):
        return 'black rook';
      case (Side.black, Role.queen):
        return 'black queen';
      case (Side.black, Role.king):
        return 'black king';
    }
  }
}
