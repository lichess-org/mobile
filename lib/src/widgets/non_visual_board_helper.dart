import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// Helper class for non-visual board functionality
class NonVisualBoardHelper {
  /// Announces a move to the screen reader
  static void announceMove(Move move, Position position) {
    final moveDescription = _getMoveDescription(move, position);
    SemanticsService.announce(moveDescription, TextDirection.ltr);
  }

  /// Gets a description of a move for screen reader announcement
  static String _getMoveDescription(Move move, Position position) {
    if (move is NormalMove) {
      final from = move.from;
      final to = move.to;
      
      final fromCoord = _squareToAlgebraic(from);
      final toCoord = _squareToAlgebraic(to);
      
      final piece = position.board.pieceAt(from);
      if (piece == null) return 'Move from $fromCoord to $toCoord';
      
      final pieceName = _getPieceName(piece);
      final capturedPiece = position.board.pieceAt(to);
      
      if (capturedPiece != null) {
        final capturedPieceName = _getPieceName(capturedPiece);
        return '$pieceName from $fromCoord takes $capturedPieceName on $toCoord';
      } else {
        return '$pieceName from $fromCoord to $toCoord';
      }
    } else if (move is DropMove) {
      final toCoord = _squareToAlgebraic(move.to);
      return 'Drop ${move.role.name} on $toCoord';
    }
    
    return 'Move made';
  }

  /// Converts a square to algebraic notation (e.g., "e4")
  static String _squareToAlgebraic(Square square) {
    final file = 'abcdefgh'[square.file];
    final rank = square.rank + 1;
    return '$file$rank';
  }

  /// Gets a human-readable name for a chess piece
  static String _getPieceName(Piece piece) {
    final color = piece.color == chess.Color.white ? 'White' : 'Black';
    
    switch (piece.role) {
      case Role.pawn:
        return '$color pawn';
      case Role.knight:
        return '$color knight';
      case Role.bishop:
        return '$color bishop';
      case Role.rook:
        return '$color rook';
      case Role.queen:
        return '$color queen';
      case Role.king:
        return '$color king';
      default:
        return '$color piece';
    }
  }

  /// Gets a description of a square and its contents
  static String getSquareDescription(Square square, Position position) {
    final algebraic = _squareToAlgebraic(square);
    final piece = position.board.pieceAt(square);
    
    if (piece == null) {
      return '$algebraic, empty';
    } else {
      return '$algebraic, ${_getPieceName(piece)}';
    }
  }
}