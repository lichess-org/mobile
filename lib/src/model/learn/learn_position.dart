import 'package:dartchess/dartchess.dart';
import 'package:meta/meta.dart';

/// A chess position with the rules the learn stages need.
///
/// It is not a [Position] because learn positions are routinely not valid chess: most of the piece
/// stages are a lone piece and some stars, so one or both kings are missing. A missing king is not
/// a special case here: [Board.kingOf] returns null, nothing can attack it, and the legality filter
/// lets every pseudo-legal move through.
///
/// There is no move counter, repetition, fifty-move rule or insufficient material: learn levels are
/// a handful of moves long and none of them end in a draw by rule.
@immutable
class const LearnPosition({
  required final Board board,
  required final Side turn,
  final Castles castles = Castles.empty,
  final Square? epSquare,
}) {
  /// Parses a FEN, of which only the board is required.
  ///
  /// Castling rights are only kept for a side whose king and rooks are on their back rank, as in
  /// [Castles.fromSetup].
  factory fromFen(String fen) {
    final setup = Setup.parseFen(fen);
    return LearnPosition(
      board: setup.board,
      turn: setup.turn,
      castles: Castles.fromSetup(setup),
      epSquare: setup.epSquare,
    );
  }

  /// The board part of the FEN.
  String get boardFen => board.fen;

  /// Whether the king of the side to move is attacked.
  ///
  /// Always false when that side has no king.
  bool get isCheck => isKingAttacked(turn);

  /// Whether the side to move is checkmated.
  bool get isCheckmate => isCheck && !hasLegalMoves;

  /// Whether the side to move has at least one legal move.
  bool get hasLegalMoves => board.bySide(turn).squares.any((sq) => destsOf(sq).isNotEmpty);

  /// Whether the king of [side] is attacked.
  bool isKingAttacked(Side side) => kingAttackers(side).isNotEmpty;

  /// The pieces attacking the king of [side], or an empty set if [side] has no king.
  SquareSet kingAttackers(Side side) {
    final king = board.kingOf(side);
    if (king == null) return SquareSet.empty;
    return board.attacksTo(king, side.opposite);
  }

  /// Returns a copy with [turn] set to [side].
  ///
  /// Handing the turn back to the side that just moved drops the en passant square, which is only
  /// valid for the opponent's reply.
  LearnPosition withTurn(Side side) => side == turn
      ? this
      : LearnPosition(board: board, turn: side, castles: castles, epSquare: null);

  /// Returns a copy with [piece] placed on [square].
  LearnPosition withPieceAt(Square square, Piece piece) => LearnPosition(
    board: board.setPieceAt(square, piece),
    turn: turn,
    castles: castles,
    epSquare: epSquare,
  );

  /// Destination squares of the piece of the side to move on [square].
  ///
  /// Castling is expressed as the king moving onto its own rook, as in [Position.legalMoves].
  ///
  /// With [illegal], moves that leave the mover's own king attacked are kept, and castling only
  /// requires an empty path: some levels teach by letting the player blunder.
  SquareSet destsOf(Square square, {bool illegal = false}) {
    final piece = board.pieceAt(square);
    if (piece == null || piece.color != turn) return SquareSet.empty;

    SquareSet pseudo = attacks(piece, square, board.occupied);
    if (piece.role == Role.pawn) {
      final captureTargets = epSquare != null
          ? board.bySide(turn.opposite).withSquare(epSquare!)
          : board.bySide(turn.opposite);
      pseudo = pseudo & captureTargets;
      final delta = turn == Side.white ? 8 : -8;
      final step = square + delta;
      if (0 <= step && step < 64 && !board.occupied.has(Square(step))) {
        pseudo = pseudo.withSquare(Square(step));
        final canDoubleStep = turn == Side.white ? square < Square.a3 : square >= Square.a7;
        final doubleStep = step + delta;
        if (canDoubleStep && !board.occupied.has(Square(doubleStep))) {
          pseudo = pseudo.withSquare(Square(doubleStep));
        }
      }
    } else {
      pseudo = pseudo.diff(board.bySide(turn));
    }

    final king = board.kingOf(turn);
    if (illegal || king == null) {
      if (piece.role == Role.king) {
        pseudo = pseudo
            .union(_castlingDest(CastlingSide.queen, checkAttacks: false))
            .union(_castlingDest(CastlingSide.king, checkAttacks: false));
      }
      return pseudo;
    }

    SquareSet legal = SquareSet.empty;
    for (final to in pseudo.squares) {
      final after = playUnchecked(NormalMove(from: square, to: to));
      if (!after.isKingAttacked(turn)) legal = legal.withSquare(to);
    }
    if (piece.role == Role.king) {
      legal = legal
          .union(_castlingDest(CastlingSide.queen, checkAttacks: true))
          .union(_castlingDest(CastlingSide.king, checkAttacks: true));
    }
    return legal;
  }

  /// All the moves of the side to move, with castling expressed as the king moving onto its rook.
  ///
  /// Promotions are not expanded: a pawn reaching the last rank yields a single move without a
  /// promotion role.
  Iterable<NormalMove> moves({bool illegal = false}) sync* {
    for (final from in board.bySide(turn).squares) {
      for (final to in destsOf(from, illegal: illegal).squares) {
        yield NormalMove(from: from, to: to);
      }
    }
  }

  /// The castling side of [move], if it is a castling move.
  ///
  /// Both the king moving onto its rook and the king moving two squares are recognized, as the board
  /// can send either depending on the castling method preference.
  CastlingSide? castlingSideOf(NormalMove move) {
    final piece = board.pieceAt(move.from);
    if (piece == null || piece.role != Role.king) return null;
    final delta = move.to - move.from;
    if (delta.abs() != 2 && !board.bySide(piece.color).has(move.to)) return null;
    final side = delta > 0 ? CastlingSide.king : CastlingSide.queen;
    return castles.rookOf(piece.color, side) != null ? side : null;
  }

  /// The enemy piece that [move] captures, including en passant.
  Piece? capturedPieceOf(NormalMove move) {
    final piece = board.pieceAt(move.from);
    if (piece == null || castlingSideOf(move) != null) return null;
    if (piece.role == Role.pawn && move.to == epSquare) {
      return board.pieceAt(_epCaptureSquare(move.to, piece.color));
    }
    final captured = board.pieceAt(move.to);
    return captured?.color != piece.color ? captured : null;
  }

  /// Plays [move] without checking its legality, and hands the turn to the other side.
  LearnPosition playUnchecked(NormalMove move) {
    final piece = board.pieceAt(move.from);
    if (piece == null) return this;

    final castlingSide = castlingSideOf(move);
    Board newBoard = board.removePieceAt(move.from);
    Castles newCastles = castles;
    Square? newEpSquare;

    if (castlingSide != null) {
      final rookFrom = castles.rookOf(piece.color, castlingSide)!;
      final rook = board.pieceAt(rookFrom);
      newBoard = newBoard
          .removePieceAt(rookFrom)
          .setPieceAt(kingCastlesTo(piece.color, castlingSide), piece);
      if (rook != null) {
        newBoard = newBoard.setPieceAt(rookCastlesTo(piece.color, castlingSide), rook);
      }
      newCastles = newCastles.discardSide(piece.color);
    } else {
      if (piece.role == Role.pawn) {
        if (move.to == epSquare) {
          newBoard = newBoard.removePieceAt(_epCaptureSquare(move.to, piece.color));
        }
        if ((move.from - move.to).abs() == 16) {
          newEpSquare = Square((move.from + move.to) >>> 1);
        }
      } else if (piece.role == Role.rook) {
        newCastles = newCastles.discardRookAt(move.from);
      } else if (piece.role == Role.king) {
        newCastles = newCastles.discardSide(piece.color);
      }
      if (board.rooks.has(move.to)) {
        newCastles = newCastles.discardRookAt(move.to);
      }
      final promotion = move.promotion;
      newBoard = newBoard.setPieceAt(
        move.to,
        promotion != null ? piece.copyWith(role: promotion) : piece,
      );
    }

    return LearnPosition(
      board: newBoard,
      turn: piece.color.opposite,
      castles: newCastles,
      epSquare: newEpSquare,
    );
  }

  Square _epCaptureSquare(Square epSquare, Side mover) =>
      Square(epSquare + (mover == Side.white ? -8 : 8));

  SquareSet _castlingDest(CastlingSide side, {required bool checkAttacks}) {
    final king = board.kingOf(turn);
    final rook = castles.rookOf(turn, side);
    if (king == null || rook == null) return SquareSet.empty;
    if (castles.pathOf(turn, side).isIntersected(board.occupied)) return SquareSet.empty;
    if (!checkAttacks) return SquareSet.fromSquare(rook);

    if (isCheck) return SquareSet.empty;
    final kingTo = kingCastlesTo(turn, side);
    final occupied = board.occupied.withoutSquare(king);
    for (final sq in between(king, kingTo).squares) {
      if (board.attacksTo(sq, turn.opposite, occupied: occupied).isNotEmpty) {
        return SquareSet.empty;
      }
    }
    final after = board.occupied
        .toggleSquare(king)
        .toggleSquare(rook)
        .toggleSquare(rookCastlesTo(turn, side));
    if (board.attacksTo(kingTo, turn.opposite, occupied: after).isNotEmpty) {
      return SquareSet.empty;
    }
    return SquareSet.fromSquare(rook);
  }
}
