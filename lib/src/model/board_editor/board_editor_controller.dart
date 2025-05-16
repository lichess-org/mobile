import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'board_editor_controller.freezed.dart';
part 'board_editor_controller.g.dart';

@riverpod
class BoardEditorController extends _$BoardEditorController {
  @override
  BoardEditorState build(String? initialFen) {
    final setup = Setup.parseFen(initialFen ?? kInitialFEN);
    return BoardEditorState(
      orientation: Side.white,
      sideToPlay: Side.white,
      pieces: readFen(initialFen ?? kInitialFEN).lock,
      castlingRights: IMap(const {
        CastlingRight.whiteKing: true,
        CastlingRight.whiteQueen: true,
        CastlingRight.blackKing: true,
        CastlingRight.blackQueen: true,
      }),
      editorPointerMode: EditorPointerMode.drag,
      enPassantOptions: SquareSet.empty,
      enPassantSquare: null,
      pieceToAddOnEdit: null,
      halfmoves: setup.halfmoves,
      fullmoves: setup.fullmoves,
    );
  }

  void updateMode(EditorPointerMode mode, [Piece? pieceToAddOnEdit]) {
    state = state.copyWith(editorPointerMode: mode, pieceToAddOnEdit: pieceToAddOnEdit);
  }

  void discardPiece(Square square) {
    _updatePosition(state.pieces.remove(square));
  }

  void movePiece(Square? origin, Square destination, Piece piece) {
    if (origin != destination) {
      _updatePosition(state.pieces.remove(origin ?? destination).add(destination, piece));
    }
  }

  void editSquare(Square square) {
    final piece = state.pieceToAddOnEdit;
    if (piece != null) {
      _updatePosition(state.pieces.add(square, piece));
    } else {
      discardPiece(square);
    }
  }

  void flipBoard() {
    state = state.copyWith(orientation: state.orientation.opposite);
  }

  void setSideToPlay(Side side) {
    state = state.copyWith(
      sideToPlay: side,
      enPassantOptions: _calculateEnPassantOptions(state.pieces, side),
    );
  }

  void loadFen(String fen) {
    _updatePosition(readFen(fen).lock);
  }

  /// Calculates the squares where an en passant capture could be possible.
  SquareSet _calculateEnPassantOptions(IMap<Square, Piece> pieces, Side side) {
    SquareSet enPassantOptions = SquareSet.empty;
    final boardFen = writeFen(pieces.unlock);
    final board = Board.parseFen(boardFen);

    /// For en passant to be possible, there needs to be an adjacent pawn which has moved two squares forward.
    /// So the two squares behind must be empty
    void checkEnPassant(Square square, int fileOffset) {
      final adjacentSquare = Square.fromCoords(square.file.offset(fileOffset)!, square.rank);
      final targetSquare = Square.fromCoords(
        square.file.offset(fileOffset)!,
        square.rank.offset(side == Side.white ? 1 : -1)!,
      );
      final originSquare = Square.fromCoords(
        square.file.offset(fileOffset)!,
        square.rank.offset(side == Side.white ? 2 : -2)!,
      );

      if (board.sideAt(adjacentSquare) == side.opposite &&
          board.roleAt(adjacentSquare) == Role.pawn &&
          board.sideAt(targetSquare) == null &&
          board.sideAt(originSquare) == null) {
        enPassantOptions = enPassantOptions.union(SquareSet.fromSquare(targetSquare));
      }
    }

    pieces.forEach((square, piece) {
      if (piece.color == side && piece.role == Role.pawn) {
        if ((side == Side.white && square.rank == Rank.fifth) ||
            (side == Side.black && square.rank == Rank.fourth)) {
          if (square.file != File.a) checkEnPassant(square, -1);
          if (square.file != File.h) checkEnPassant(square, 1);
        }
      }
    });

    return enPassantOptions;
  }

  void toggleEnPassantSquare(Square square) {
    state = state.copyWith(enPassantSquare: state.enPassantSquare == square ? null : square);
  }

  void _updatePosition(IMap<Square, Piece> pieces) {
    state = state.copyWith(
      pieces: pieces,
      enPassantOptions: _calculateEnPassantOptions(pieces, state.sideToPlay),
    );
  }

  void setCastling(Side side, CastlingSide castlingSide, bool allowed) {
    switch (side) {
      case Side.white:
        switch (castlingSide) {
          case CastlingSide.king:
            state = state.copyWith(
              castlingRights: state.castlingRights.add(CastlingRight.whiteKing, allowed),
            );
          case CastlingSide.queen:
            state = state.copyWith(
              castlingRights: state.castlingRights.add(CastlingRight.whiteQueen, allowed),
            );
        }
      case Side.black:
        switch (castlingSide) {
          case CastlingSide.king:
            state = state.copyWith(
              castlingRights: state.castlingRights.add(CastlingRight.blackKing, allowed),
            );
          case CastlingSide.queen:
            state = state.copyWith(
              castlingRights: state.castlingRights.add(CastlingRight.blackQueen, allowed),
            );
        }
    }
  }
}

enum CastlingRight { whiteKing, whiteQueen, blackKing, blackQueen }

@freezed
sealed class BoardEditorState with _$BoardEditorState {
  const BoardEditorState._();

  const factory BoardEditorState({
    required Side orientation,
    required Side sideToPlay,
    required IMap<Square, Piece> pieces,
    required IMap<CastlingRight, bool> castlingRights,
    required EditorPointerMode editorPointerMode,
    required SquareSet enPassantOptions,
    required Square? enPassantSquare,
    required int halfmoves,
    required int fullmoves,

    /// When null, clears squares when in edit mode. Has no effect in drag mode.
    required Piece? pieceToAddOnEdit,
  }) = _BoardEditorState;

  bool isCastlingAllowed(Side side, CastlingSide castlingSide) => switch (side) {
    Side.white => switch (castlingSide) {
      CastlingSide.king => castlingRights[CastlingRight.whiteKing]!,
      CastlingSide.queen => castlingRights[CastlingRight.whiteQueen]!,
    },
    Side.black => switch (castlingSide) {
      CastlingSide.king => castlingRights[CastlingRight.blackKing]!,
      CastlingSide.queen => castlingRights[CastlingRight.blackQueen]!,
    },
  };

  /// Returns the castling rights part of the FEN string.
  ///
  /// If the rook is missing on one side of the king, or the king is missing on the
  /// backrank, the castling right is removed.
  String get _castlingRightsPart {
    final parts = <String>[];
    final Map<CastlingRight, bool> hasRook = {};
    final Board board = Board.parseFen(writeFen(pieces.unlock));
    for (final side in Side.values) {
      final backrankKing = SquareSet.backrankOf(side) & board.kings;
      final rooksAndKings =
          (board.bySide(side) & SquareSet.backrankOf(side)) & (board.rooks | board.kings);
      for (final castlingSide in CastlingSide.values) {
        final candidate =
            castlingSide == CastlingSide.king
                ? rooksAndKings.squares.lastOrNull
                : rooksAndKings.squares.firstOrNull;
        final isCastlingPossible =
            candidate != null && board.rooks.has(candidate) && backrankKing.singleSquare != null;
        switch ((side, castlingSide)) {
          case (Side.white, CastlingSide.king):
            hasRook[CastlingRight.whiteKing] = isCastlingPossible;
          case (Side.white, CastlingSide.queen):
            hasRook[CastlingRight.whiteQueen] = isCastlingPossible;
          case (Side.black, CastlingSide.king):
            hasRook[CastlingRight.blackKing] = isCastlingPossible;
          case (Side.black, CastlingSide.queen):
            hasRook[CastlingRight.blackQueen] = isCastlingPossible;
        }
      }
    }
    for (final right in CastlingRight.values) {
      if (hasRook[right]! && castlingRights[right]!) {
        switch (right) {
          case CastlingRight.whiteKing:
            parts.add('K');
          case CastlingRight.whiteQueen:
            parts.add('Q');
          case CastlingRight.blackKing:
            parts.add('k');
          case CastlingRight.blackQueen:
            parts.add('q');
        }
      }
    }
    return parts.isEmpty ? '-' : parts.join('');
  }

  Piece? get activePieceOnEdit =>
      editorPointerMode == EditorPointerMode.edit ? pieceToAddOnEdit : null;

  bool get deletePiecesActive =>
      editorPointerMode == EditorPointerMode.edit && pieceToAddOnEdit == null;

  String get fen {
    final boardFen = writeFen(pieces.unlock);
    return '$boardFen ${sideToPlay == Side.white ? 'w' : 'b'} $_castlingRightsPart ${enPassantSquare?.name ?? '-'} $halfmoves $fullmoves';
  }

  /// Returns the PGN representation of the current position if it is valid.
  ///
  /// Returns `null` if the position is invalid.
  String? get pgn {
    try {
      final position = Chess.fromSetup(Setup.parseFen(fen));
      return PgnGame(
        headers: {'FEN': position.fen},
        moves: PgnNode<PgnNodeData>(),
        comments: [],
      ).makePgn();
    } catch (_) {
      return null;
    }
  }
}
