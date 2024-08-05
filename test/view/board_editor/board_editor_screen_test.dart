import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/board_editor/board_editor_controller.dart';
import 'package:lichess_mobile/src/view/board_editor/board_editor_screen.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar_button.dart';

import '../../test_app.dart';

void main() {
  group('Board Editor', () {
    testWidgets('Displays initial FEN on start', (tester) async {
      await setupBoardEditor(tester);

      final editor = tester.widget<ChessboardEditor>(
        find.byType(ChessboardEditor),
      );
      expect(editor.pieces, readFen(kInitialFEN));
      expect(editor.orientation, Side.white);
      expect(editor.pointerMode, EditorPointerMode.drag);

      // Legal position, so allowed top open analysis board
      expect(
        tester
            .widget<BottomBarButton>(
              find.byKey(const Key('analysis-board-button')),
            )
            .onTap,
        isNotNull,
      );
    });

    testWidgets('Flip board', (tester) async {
      await setupBoardEditor(tester);

      await tester.tap(find.byKey(const Key('flip-button')));
      await tester.pump();

      expect(
        tester
            .widget<ChessboardEditor>(
              find.byType(ChessboardEditor),
            )
            .orientation,
        Side.black,
      );
    });

    testWidgets('Side to play and castling rights', (tester) async {
      final boardEditorController = await setupBoardEditor(tester);

      await tester.tap(find.byKey(const Key('flip-button')));
      await tester.pump();

      boardEditorController.setSideToPlay(Side.black);
      expect(
        boardEditorController.state.fen,
        'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR b KQkq - 0 1',
      );

      boardEditorController.setCastling(Side.white, CastlingSide.king, false);
      expect(
        boardEditorController.state.fen,
        'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR b Qkq - 0 1',
      );

      boardEditorController.setCastling(Side.white, CastlingSide.queen, false);
      expect(
        boardEditorController.state.fen,
        'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR b kq - 0 1',
      );

      boardEditorController.setCastling(Side.black, CastlingSide.king, false);
      expect(
        boardEditorController.state.fen,
        'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR b q - 0 1',
      );

      boardEditorController.setCastling(Side.black, CastlingSide.queen, false);
      expect(
        boardEditorController.state.fen,
        'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR b - - 0 1',
      );

      boardEditorController.setCastling(Side.white, CastlingSide.king, true);
      expect(
        boardEditorController.state.fen,
        'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR b K - 0 1',
      );
    });

    testWidgets('Castling rights ignored when rook is missing', (tester) async {
      final boardEditorController = await setupBoardEditor(tester);

      // Starting position, but with all rooks removed
      boardEditorController
          .loadFen('1nbqkbn1/pppppppp/8/8/8/8/PPPPPPPP/1NBQKBN1');

      // By default, all castling rights are true, but since there are no rooks, the final FEN should have no castling rights
      expect(
        boardEditorController.state.fen,
        '1nbqkbn1/pppppppp/8/8/8/8/PPPPPPPP/1NBQKBN1 w - - 0 1',
      );
    });

    testWidgets('Can drag pieces to new squares', (tester) async {
      final boardEditorController = await setupBoardEditor(tester);

      // Two legal moves by white
      await dragFromTo(tester, 'e2', 'e4');
      await dragFromTo(tester, 'd2', 'd4');

      // Illegal move by black
      await dragFromTo(tester, 'a8', 'a6');

      // White queen captures white bishop
      await dragFromTo(tester, 'd1', 'c1');

      expect(
        boardEditorController.state.fen,
        // Obtained by playing the moves above on lichess.org/editor
        '1nbqkbnr/pppppppp/r7/8/3PP3/8/PPP2PPP/RNQ1KBNR w KQk - 0 1',
      );
    });

    testWidgets('illegal position cannot be analyzed', (tester) async {
      await setupBoardEditor(tester);

      // White queen "captures" white king => illegal position
      await dragFromTo(tester, 'd1', 'e1');

      expect(
        tester
            .widget<BottomBarButton>(
              find.byKey(const Key('analysis-board-button')),
            )
            .onTap,
        isNull,
      );
    });

    testWidgets('Delete pieces via bin button', (tester) async {
      final boardEditorController = await setupBoardEditor(tester);

      await tester.tap(find.byKey(const Key('delete-button-white')));
      await tester.pump();

      await tapSquare(tester, 'e2');
      expect(
        boardEditorController.state.fen,
        'rnbqkbnr/pppppppp/8/8/8/8/PPPP1PPP/RNBQKBNR w KQkq - 0 1',
      );

      // Change back to drag mode -> tapping has no effect anymore
      await tester.tap(find.byKey(const Key('drag-button-white')));
      await tester.pump();
      await tapSquare(tester, 'e3');
      expect(
        boardEditorController.state.fen,
        'rnbqkbnr/pppppppp/8/8/8/8/PPPP1PPP/RNBQKBNR w KQkq - 0 1',
      );

      // Now remove all of black's pawns
      await tester.tap(find.byKey(const Key('delete-button-black')));
      await tester.pump();
      await panFromTo(tester, 'a7', 'h7');

      expect(
        boardEditorController.state.fen,
        'rnbqkbnr/8/8/8/8/8/PPPP1PPP/RNBQKBNR w KQkq - 0 1',
      );
    });

    testWidgets('Add pieces via tap and pan', (tester) async {
      final boardEditorController = await setupBoardEditor(tester);

      await tester.tap(find.byKey(const Key('piece-button-white-queen')));
      await panFromTo(tester, 'a1', 'a8');
      await tester.tap(find.byKey(const Key('piece-button-black-rook')));
      await tapSquare(tester, 'h1');
      await tapSquare(tester, 'h3');

      expect(
        boardEditorController.state.fen,
        'Qnbqkbnr/Qppppppp/Q7/Q7/Q7/Q6r/QPPPPPPP/QNBQKBNr w k - 0 1',
      );
    });

    testWidgets('Drag pieces onto the board', (tester) async {
      final boardEditorController = await setupBoardEditor(tester);

      // Start by pressing bin button, dragging a piece should override this
      await tester.tap(find.byKey(const Key('delete-button-black')));
      await tester.pump();

      final pieceButtonOffset =
          tester.getCenter(find.byKey(const Key('piece-button-white-pawn')));
      await tester.dragFrom(
        pieceButtonOffset,
        tester.getCenter(find.byKey(const Key('d3-empty'))) - pieceButtonOffset,
      );
      await tester.dragFrom(
        pieceButtonOffset,
        tester.getCenter(find.byKey(const Key('d1-whitequeen'))) -
            pieceButtonOffset,
      );

      expect(
        boardEditorController.state.editorPointerMode,
        EditorPointerMode.drag,
      );

      expect(
        boardEditorController.state.fen,
        'rnbqkbnr/pppppppp/8/8/8/3P4/PPPPPPPP/RNBPKBNR w KQkq - 0 1',
      );
    });
  });
}

Future<BoardEditorController> setupBoardEditor(WidgetTester tester) async {
  final boardEditorController = BoardEditorController();
  final app = await buildTestApp(
    tester,
    home: const BoardEditorScreen(),
    overrides: [
      boardEditorControllerProvider.overrideWith(() => boardEditorController),
    ],
  );
  await tester.pumpWidget(app);
  return boardEditorController;
}

Future<void> dragFromTo(
  WidgetTester tester,
  String from,
  String to,
) async {
  final fromOffset = squareOffset(tester, Square.fromName(from));

  await tester.dragFrom(
    fromOffset,
    squareOffset(tester, Square.fromName(to)) - fromOffset,
  );
  await tester.pumpAndSettle();
}

Future<void> panFromTo(
  WidgetTester tester,
  String from,
  String to,
) async {
  final fromOffset = squareOffset(tester, Square.fromName(from));

  await tester.timedDragFrom(
    fromOffset,
    squareOffset(tester, Square.fromName(to)) - fromOffset,
    const Duration(seconds: 1),
  );
  await tester.pumpAndSettle();
}

Future<void> tapSquare(WidgetTester tester, String square) async {
  await tester.tapAt(squareOffset(tester, Square.fromName(square)));
  await tester.pumpAndSettle();
}

Offset squareOffset(WidgetTester tester, Square square) {
  final editor = find.byType(ChessboardEditor);
  final squareSize = tester.getSize(editor).width / 8;

  return tester.getTopLeft(editor) +
      Offset(
        square.file.value * squareSize + squareSize / 2,
        (7 - square.rank.value) * squareSize + squareSize / 2,
      );
}
