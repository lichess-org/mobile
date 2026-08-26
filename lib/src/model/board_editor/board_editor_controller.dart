import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/chess960.dart';

part 'board_editor_controller.freezed.dart';

typedef BoardEditorControllerParams = ({
  Variant initialVariant,
  String? initialFen,
  Side? initialOrientation,
});

/// A provider for [BoardEditorController].
final boardEditorControllerProvider = NotifierProvider.autoDispose
    .family<BoardEditorController, BoardEditorState, BoardEditorControllerParams?>(
      BoardEditorController.new,
      name: 'BoardEditorControllerProvider',
    );

class BoardEditorController extends Notifier<BoardEditorState> {
  BoardEditorController(this.params);

  final BoardEditorControllerParams? params;

  @override
  BoardEditorState build() {
    final variant = params?.initialVariant ?? Variant.standard;
    final fen =
        params?.initialFen ??
        (variant == Variant.chess960 ? randomChess960Position() : variant.initialPosition).fen;
    final setup = Setup.parseFen(fen);
    final pieces = readFen(fen).lock;

    return BoardEditorState(
      orientation: params?.initialOrientation ?? Side.white,
      sideToPlay: setup.turn,
      variant: variant,
      pieces: pieces,
      castlingRights: _getCastlingRights(variant, setup),
      editorPointerMode: EditorPointerMode.drag,
      enPassantOptions: _calculateEnPassantOptions(pieces, setup.turn),
      enPassantSquare: setup.epSquare,
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
      final existingPiece = state.pieces[square];
      if (existingPiece == piece) {
        discardPiece(square);
      } else {
        _updatePosition(state.pieces.add(square, piece));
      }
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
    final fenParts = fen.trim().split(RegExp(r'\s+'));
    final setup = Setup.parseFen(fen);
    final pieces = readFen(fen).lock;

    if (fenParts.length == 1) {
      // Partial FEN (piece placement only): preserve existing state for side to play,
      // castling rights, etc. Castling is filtered by piece positions in _castlingRightsPart.
      _updatePosition(pieces);
    } else {
      // Full FEN: update all fields from the parsed FEN.
      state = state.copyWith(
        pieces: pieces,
        sideToPlay: setup.turn,
        castlingRights: _getCastlingRights(state.variant, setup),
        enPassantOptions: _calculateEnPassantOptions(pieces, setup.turn),
        enPassantSquare: setup.epSquare,
        halfmoves: setup.halfmoves,
        fullmoves: setup.fullmoves,
      );
    }
  }

  void clearBoard() {
    state = state.copyWith(
      pieces: IMap(const {}), // No pieces
      castlingRights: IMap(const {
        CastlingRight.whiteKing: false,
        CastlingRight.whiteQueen: false,
        CastlingRight.blackKing: false,
        CastlingRight.blackQueen: false,
      }),
      enPassantOptions: SquareSet.empty,
      enPassantSquare: null,
    );
  }

  IMap<CastlingRight, bool> _getCastlingRights(Variant variant, Setup setup) {
    final position = Position.setupPosition(variant.rule, setup, ignoreImpossibleCheck: true);
    return IMap({
      CastlingRight.whiteKing: position.castles.rookOf(Side.white, CastlingSide.king) != null,
      CastlingRight.whiteQueen: position.castles.rookOf(Side.white, CastlingSide.queen) != null,
      CastlingRight.blackKing: position.castles.rookOf(Side.black, CastlingSide.king) != null,
      CastlingRight.blackQueen: position.castles.rookOf(Side.black, CastlingSide.queen) != null,
    });
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

  void setVariant(Variant variant) {
    state = state.copyWith(variant: variant);
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
    required Variant variant,
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

  /// Checks if the pieces are in the correct positions so that castling is possible.
  bool isCastlingPossible(Side side, CastlingSide castlingSide) {
    if (variant == .chess960) {
      final board = Board.parseFen(writeFen(pieces.unlock));
      final backrankKing = SquareSet.backrankOf(side) & board.kings;
      final rooksAndKings =
          (board.bySide(side) & SquareSet.backrankOf(side)) & (board.rooks | board.kings);

      final candidate = castlingSide == .king
          ? rooksAndKings.squares.lastOrNull
          : rooksAndKings.squares.firstOrNull;

      return candidate != null && board.rooks.has(candidate) && backrankKing.singleSquare != null;
    } else {
      final Square kingSquare = side == .white ? .e1 : .e8;
      final Square rookSquare = castlingSide == .king
          ? (side == .white ? .h1 : .h8)
          : (side == .white ? .a1 : .a8);

      return pieces[kingSquare]?.role == .king &&
          pieces[kingSquare]?.color == side &&
          pieces[rookSquare]?.role == .rook &&
          pieces[rookSquare]?.color == side;
    }
  }

  /// Returns the castling rights part of the FEN string.
  ///
  /// For standard variants, checks if the kings and rooks are on their normal starting squares.
  /// For Chess960, dynamically checks the backrank for rooks relative to the king.
  /// Returns the castling rights part of the FEN string.
  ///
  /// For standard variants, checks if the kings and rooks are on their normal starting squares.
  /// For Chess960, dynamically checks the backrank for rooks relative to the king.
  String get _castlingRightsPart {
    final parts = <String>[];

    if (variant.sideCanCastle(.white) &&
        castlingRights[.whiteKing]! &&
        isCastlingPossible(.white, .king)) {
      parts.add('K');
    }
    if (variant.sideCanCastle(.white) &&
        castlingRights[.whiteQueen]! &&
        isCastlingPossible(.white, .queen)) {
      parts.add('Q');
    }
    if (variant.sideCanCastle(.black) &&
        castlingRights[.blackKing]! &&
        isCastlingPossible(.black, .king)) {
      parts.add('k');
    }
    if (variant.sideCanCastle(.black) &&
        castlingRights[.blackQueen]! &&
        isCastlingPossible(.black, .queen)) {
      parts.add('q');
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
      final position = Position.setupPosition(variant.rule, Setup.parseFen(fen));
      return PgnGame(
        headers: {'FEN': position.fen, 'Variant': variant.pgnName},
        moves: PgnNode<PgnNodeData>(),
        comments: [],
      ).makePgn();
    } catch (_) {
      return null;
    }
  }
}
