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
    return BoardEditorState(
      orientation: Side.white,
      sideToPlay: Side.white,
      pieces: readFen(initialFen ?? kInitialFEN).lock,
      unmovedRooks: SquareSet.corners,
      editorPointerMode: EditorPointerMode.drag,
      enPassantOptions: SquareSet.empty,
      enPassantSquare: null,
      pieceToAddOnEdit: null,
    );
  }

  void updateMode(EditorPointerMode mode, [Piece? pieceToAddOnEdit]) {
    state = state.copyWith(
      editorPointerMode: mode,
      pieceToAddOnEdit: pieceToAddOnEdit,
    );
  }

  void discardPiece(Square square) {
    _updatePosition(state.pieces.remove(square));
  }

  void movePiece(Square? origin, Square destination, Piece piece) {
    if (origin != destination) {
      _updatePosition(
        state.pieces.remove(origin ?? destination).add(destination, piece),
      );
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
    state = state.copyWith(
      orientation: state.orientation.opposite,
    );
  }

  void setSideToPlay(Side side) {
    state = state.copyWith(
      sideToPlay: side,
      enPassantOptions: _calculateEnPassantOptions(state.pieces, side),
    );
  }

  void loadFen(
    String fen, {
    bool loadSideToPlay = false,
    bool loadCastling = false,
  }) {
    final splits = fen.split(' ');
    _updatePosition(readFen(splits[0]).lock);

    if (loadSideToPlay && splits.length >= 2) {
      setSideToPlay(splits[1].toLowerCase() == 'w' ? Side.white : Side.black);
    }

    if (loadCastling && splits.length >= 3) {
      final castling = splits[2];
      setCastling(Side.white, CastlingSide.king, castling.contains('K'));
      setCastling(Side.white, CastlingSide.queen, castling.contains('Q'));
      setCastling(Side.black, CastlingSide.king, castling.contains('k'));
      setCastling(Side.black, CastlingSide.queen, castling.contains('q'));
    }
  }

  /// Calculates the squares where an en passant capture could be possible.
  SquareSet _calculateEnPassantOptions(IMap<Square, Piece> pieces, Side side) {
    SquareSet enPassantOptions = SquareSet.empty;
    final boardFen = writeFen(pieces.unlock);
    final board = Board.parseFen(boardFen);

    /// For en passant to be possible, there needs to be an adjacent pawn which has moved two squares forward.
    /// So the two squares behind must be empty
    void checkEnPassant(Square square, int fileOffset) {
      final adjacentSquare =
          Square.fromCoords(square.file.offset(fileOffset)!, square.rank);
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
        enPassantOptions =
            enPassantOptions.union(SquareSet.fromSquare(targetSquare));
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
    state = state.copyWith(
      enPassantSquare: state.enPassantSquare == square ? null : square,
    );
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
        if (castlingSide == CastlingSide.king) {
          _setRookUnmoved(Square.h1, allowed);
        } else {
          _setRookUnmoved(Square.a1, allowed);
        }
      case Side.black:
        if (castlingSide == CastlingSide.king) {
          _setRookUnmoved(Square.h8, allowed);
        } else {
          _setRookUnmoved(Square.a8, allowed);
        }
    }
  }

  void _setRookUnmoved(Square square, bool unmoved) {
    state = state.copyWith(
      unmovedRooks: unmoved
          ? state.unmovedRooks.withSquare(square)
          : state.unmovedRooks.withoutSquare(square),
    );
  }
}

@freezed
class BoardEditorState with _$BoardEditorState {
  const BoardEditorState._();

  const factory BoardEditorState({
    required Side orientation,
    required Side sideToPlay,
    required IMap<Square, Piece> pieces,
    required SquareSet unmovedRooks,
    required EditorPointerMode editorPointerMode,
    required SquareSet enPassantOptions,
    required Square? enPassantSquare,

    /// When null, clears squares when in edit mode. Has no effect in drag mode.
    required Piece? pieceToAddOnEdit,
  }) = _BoardEditorState;

  bool isCastlingAllowed(Side side, CastlingSide castlingSide) =>
      switch (side) {
        Side.white => switch (castlingSide) {
            CastlingSide.king => unmovedRooks.has(Square.h1),
            CastlingSide.queen => unmovedRooks.has(Square.a1),
          },
        Side.black => switch (castlingSide) {
            CastlingSide.king => unmovedRooks.has(Square.h8),
            CastlingSide.queen => unmovedRooks.has(Square.a8),
          },
      };

  Setup get _setup {
    final boardFen = writeFen(pieces.unlock);
    final board = Board.parseFen(boardFen);
    return Setup(
      board: board,
      unmovedRooks: unmovedRooks,
      turn: sideToPlay == Side.white ? Side.white : Side.black,
      epSquare: enPassantSquare,
      halfmoves: 0,
      fullmoves: 1,
    );
  }

  Piece? get activePieceOnEdit =>
      editorPointerMode == EditorPointerMode.edit ? pieceToAddOnEdit : null;

  bool get deletePiecesActive =>
      editorPointerMode == EditorPointerMode.edit && pieceToAddOnEdit == null;

  String get fen => _setup.fen;

  /// Returns the PGN representation of the current position if it is valid.
  ///
  /// Returns `null` if the position is invalid.
  String? get pgn {
    try {
      final position = Chess.fromSetup(_setup);
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
