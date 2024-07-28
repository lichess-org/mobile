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
  BoardEditorState build() {
    return BoardEditorState(
      orientation: Side.white,
      sideToPlay: Side.white,
      pieces: readFen(kInitialFEN).lock,
      unmovedRooks: SquareSet.corners,
      editorPointerMode: EditorPointerMode.drag,
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
    );
  }

  void loadFen(String fen) {
    _updatePosition(readFen(fen).lock);
  }

  void _updatePosition(IMap<Square, Piece> pieces) {
    state = state.copyWith(pieces: pieces);
  }

  void setWhiteKingsideCastlingAllowed(bool allowed) {
    _setRookUnmoved(Square.h1, allowed);
  }

  void setWhiteQueensideCastlingAllowed(bool allowed) {
    _setRookUnmoved(Square.a1, allowed);
  }

  void setBlackKingsideCastlingAllowed(bool allowed) {
    _setRookUnmoved(Square.h8, allowed);
  }

  void setBlackQueensideCastlingAllowed(bool allowed) {
    _setRookUnmoved(Square.a8, allowed);
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

    /// When null, clears squares when in edit mode. Has no effect in drag mode.
    required Piece? pieceToAddOnEdit,
  }) = _BoardEditorState;

  bool get canWhiteCastleKingside => unmovedRooks.has(Square.h1);
  bool get canWhiteCastleQueenside => unmovedRooks.has(Square.a1);
  bool get canBlackCastleKingside => unmovedRooks.has(Square.h8);
  bool get canBlackCastleQueenside => unmovedRooks.has(Square.a8);

  Setup get _setup {
    final boardFen = writeFen(pieces.unlock);
    final board = Board.parseFen(boardFen);
    return Setup(
      board: board,
      unmovedRooks: unmovedRooks,
      turn: sideToPlay == Side.white ? Side.white : Side.black,
      halfmoves: 0,
      fullmoves: 1,
    );
  }

  Piece? get activePieceOnEdit =>
      editorPointerMode == EditorPointerMode.edit ? pieceToAddOnEdit : null;

  bool get deletePiecesActive =>
      editorPointerMode == EditorPointerMode.edit && pieceToAddOnEdit == null;

  String get fen => _setup.fen;

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
