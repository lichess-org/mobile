import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/board_editor/board_editor_controller.dart';
import 'package:lichess_mobile/src/view/board_editor/board_editor_screen.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';

import '../../test_provider_scope.dart';

void main() {
  group('Board Editor', () {
    testWidgets('Displays initial FEN on start', (tester) async {
      final app = await makeTestProviderScopeApp(tester, home: const BoardEditorScreen());
      await tester.pumpWidget(app);

      final editor = tester.widget<ChessboardEditor>(find.byType(ChessboardEditor));
      expect(editor.pieces, readFen(kInitialFEN));
      expect(editor.orientation, Side.white);
      expect(editor.pointerMode, EditorPointerMode.drag);

      // Legal position, so allowed top open analysis board
      expect(
        tester.widget<BottomBarButton>(find.byKey(const Key('analysis-board-button'))).onTap,
        isNotNull,
      );
    });

    testWidgets('Flip board', (tester) async {
      final app = await makeTestProviderScopeApp(tester, home: const BoardEditorScreen());
      await tester.pumpWidget(app);

      await tester.tap(find.byKey(const Key('flip-button')));
      await tester.pump();

      expect(
        tester.widget<ChessboardEditor>(find.byType(ChessboardEditor)).orientation,
        Side.black,
      );
    });

    testWidgets('Side to play and castling rights', (tester) async {
      final app = await makeTestProviderScopeApp(tester, home: const BoardEditorScreen());
      await tester.pumpWidget(app);

      await tester.tap(find.byKey(const Key('flip-button')));
      await tester.pump();

      final container = ProviderScope.containerOf(tester.element(find.byType(ChessboardEditor)));

      final controllerProvider = boardEditorControllerProvider(null);

      container.read(controllerProvider.notifier).setSideToPlay(Side.black);
      expect(
        container.read(controllerProvider).fen,
        'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR b KQkq - 0 1',
      );

      container.read(controllerProvider.notifier).setCastling(Side.white, CastlingSide.king, false);
      expect(
        container.read(controllerProvider).fen,
        'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR b Qkq - 0 1',
      );

      container
          .read(controllerProvider.notifier)
          .setCastling(Side.white, CastlingSide.queen, false);
      expect(
        container.read(controllerProvider).fen,
        'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR b kq - 0 1',
      );

      container.read(controllerProvider.notifier).setCastling(Side.black, CastlingSide.king, false);
      expect(
        container.read(controllerProvider).fen,
        'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR b q - 0 1',
      );

      container
          .read(controllerProvider.notifier)
          .setCastling(Side.black, CastlingSide.queen, false);
      expect(
        container.read(controllerProvider).fen,
        'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR b - - 0 1',
      );

      container.read(controllerProvider.notifier).setCastling(Side.white, CastlingSide.king, true);
      expect(
        container.read(controllerProvider).fen,
        'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR b K - 0 1',
      );
    });

    testWidgets('Castling rights ignored when rook is missing', (tester) async {
      final app = await makeTestProviderScopeApp(tester, home: const BoardEditorScreen());
      await tester.pumpWidget(app);

      final container = ProviderScope.containerOf(tester.element(find.byType(ChessboardEditor)));
      final controllerProvider = boardEditorControllerProvider(null);

      // Starting position, but with all rooks removed
      container
          .read(controllerProvider.notifier)
          .loadFen('1nbqkbn1/pppppppp/8/8/8/8/PPPPPPPP/1NBQKBN1');

      // By default, all castling rights are true, but since there are no rooks, the final FEN should have no castling rights
      expect(
        container.read(controllerProvider).fen,
        '1nbqkbn1/pppppppp/8/8/8/8/PPPPPPPP/1NBQKBN1 w - - 0 1',
      );
    });

    testWidgets('support chess960 castling rights', (tester) async {
      final app = await makeTestProviderScopeApp(tester, home: const BoardEditorScreen());
      await tester.pumpWidget(app);

      final container = ProviderScope.containerOf(tester.element(find.byType(ChessboardEditor)));
      final controllerProvider = boardEditorControllerProvider(null);

      container
          .read(controllerProvider.notifier)
          .loadFen('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/4RK1R');

      expect(
        container.read(controllerProvider).fen,
        'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/4RK1R w KQkq - 0 1',
      );
    });

    testWidgets('Castling rights ignored when king is not in backrank', (tester) async {
      final app = await makeTestProviderScopeApp(tester, home: const BoardEditorScreen());
      await tester.pumpWidget(app);

      final container = ProviderScope.containerOf(tester.element(find.byType(ChessboardEditor)));
      final controllerProvider = boardEditorControllerProvider(null);

      container
          .read(controllerProvider.notifier)
          .loadFen('rnbqkbnr/pppppppp/8/8/8/5K2/PPPPPPPP/4R2R');

      expect(
        container.read(controllerProvider).fen,
        'rnbqkbnr/pppppppp/8/8/8/5K2/PPPPPPPP/4R2R w kq - 0 1',
      );
    });

    testWidgets('Possible en passant squares are calculated correctly', (tester) async {
      final app = await makeTestProviderScopeApp(tester, home: const BoardEditorScreen());
      await tester.pumpWidget(app);

      final container = ProviderScope.containerOf(tester.element(find.byType(ChessboardEditor)));
      final controllerProvider = boardEditorControllerProvider(null);
      container
          .read(controllerProvider.notifier)
          .loadFen('1nbqkbn1/pppppppp/8/8/8/8/PPPPPPPP/1NBQKBN1');

      expect(container.read(controllerProvider).enPassantOptions, SquareSet.empty);

      container
          .read(controllerProvider.notifier)
          .loadFen('r1bqkbnr/4p1p1/3n4/pPppPppP/8/8/P1PP1P2/RNBQKBNR w KQkq - 0 1');
      expect(
        container.read(controllerProvider).enPassantOptions,
        SquareSet.fromSquares([Square.a6, Square.c6, Square.f6]),
      );
      container
          .read(controllerProvider.notifier)
          .loadFen('rnbqkbnr/pp1p1p1p/8/8/PpPpPQpP/8/NPRP1PP1/2B1KBNR b Kkq - 0 1');
      container.read(controllerProvider.notifier).setSideToPlay(Side.black);
      expect(
        container.read(controllerProvider).enPassantOptions,
        SquareSet.fromSquares([Square.e3, Square.h3]),
      );
    });

    testWidgets('Can drag pieces to new squares', (tester) async {
      final app = await makeTestProviderScopeApp(tester, home: const BoardEditorScreen());
      await tester.pumpWidget(app);

      final container = ProviderScope.containerOf(tester.element(find.byType(ChessboardEditor)));
      final controllerProvider = boardEditorControllerProvider(null);

      // Two legal moves by white
      await dragFromTo(tester, 'e2', 'e4');
      await dragFromTo(tester, 'd2', 'd4');

      // Illegal move by black
      await dragFromTo(tester, 'a8', 'a6');

      // White queen captures white bishop
      await dragFromTo(tester, 'd1', 'c1');

      expect(
        container.read(controllerProvider).fen,
        // Obtained by playing the moves above on lichess.org/editor
        '1nbqkbnr/pppppppp/r7/8/3PP3/8/PPP2PPP/RNQ1KBNR w KQk - 0 1',
      );
    });

    testWidgets('illegal position cannot be analyzed', (tester) async {
      final app = await makeTestProviderScopeApp(tester, home: const BoardEditorScreen());
      await tester.pumpWidget(app);

      // White queen "captures" white king => illegal position
      await dragFromTo(tester, 'd1', 'e1');

      expect(
        tester.widget<BottomBarButton>(find.byKey(const Key('analysis-board-button'))).onTap,
        isNull,
      );
    });

    testWidgets('Delete pieces via bin button', (tester) async {
      final app = await makeTestProviderScopeApp(tester, home: const BoardEditorScreen());
      await tester.pumpWidget(app);

      final container = ProviderScope.containerOf(tester.element(find.byType(ChessboardEditor)));
      final controllerProvider = boardEditorControllerProvider(null);

      await tester.tap(find.byKey(const Key('delete-button-white')));
      await tester.pump();

      await tapSquare(tester, 'e2');
      expect(
        container.read(controllerProvider).fen,
        'rnbqkbnr/pppppppp/8/8/8/8/PPPP1PPP/RNBQKBNR w KQkq - 0 1',
      );

      // Change back to drag mode -> tapping has no effect anymore
      await tester.tap(find.byKey(const Key('drag-button-white')));
      await tester.pump();
      await tapSquare(tester, 'e3');

      expect(
        container.read(controllerProvider).fen,
        'rnbqkbnr/pppppppp/8/8/8/8/PPPP1PPP/RNBQKBNR w KQkq - 0 1',
      );

      // Now remove all of black's pawns
      await tester.tap(find.byKey(const Key('delete-button-black')));
      await tester.pump();
      await panFromTo(tester, 'a7', 'h7');

      expect(
        container.read(controllerProvider).fen,
        'rnbqkbnr/8/8/8/8/8/PPPP1PPP/RNBQKBNR w KQkq - 0 1',
      );
    });

    testWidgets('Add pieces via tap and pan', (tester) async {
      final app = await makeTestProviderScopeApp(tester, home: const BoardEditorScreen());
      await tester.pumpWidget(app);

      await tester.tap(find.byKey(const Key('piece-button-white-queen')));
      await panFromTo(tester, 'a1', 'a8');
      await tester.tap(find.byKey(const Key('piece-button-black-rook')));
      await tapSquare(tester, 'h1');
      await tapSquare(tester, 'h3');

      final container = ProviderScope.containerOf(tester.element(find.byType(ChessboardEditor)));
      final controllerProvider = boardEditorControllerProvider(null);

      expect(
        container.read(controllerProvider).fen,
        'Qnbqkbnr/Qppppppp/Q7/Q7/Q7/Q6r/QPPPPPPP/QNBQKBNr w k - 0 1',
      );
    });

    testWidgets('Drag pieces onto the board', (tester) async {
      final app = await makeTestProviderScopeApp(tester, home: const BoardEditorScreen());
      await tester.pumpWidget(app);

      // Start by pressing bin button, dragging a piece should override this
      await tester.tap(find.byKey(const Key('delete-button-black')));
      await tester.pump();

      final pieceButtonOffset = tester.getCenter(find.byKey(const Key('piece-button-white-pawn')));
      await tester.dragFrom(
        pieceButtonOffset,
        tester.getCenter(find.byKey(const Key('d3-empty'))) - pieceButtonOffset,
      );
      await tester.dragFrom(
        pieceButtonOffset,
        tester.getCenter(find.byKey(const Key('d1-whitequeen'))) - pieceButtonOffset,
      );

      final container = ProviderScope.containerOf(tester.element(find.byType(ChessboardEditor)));
      final controllerProvider = boardEditorControllerProvider(null);

      expect(container.read(controllerProvider).editorPointerMode, EditorPointerMode.drag);

      expect(
        container.read(controllerProvider).fen,
        'rnbqkbnr/pppppppp/8/8/8/3P4/PPPPPPPP/RNBPKBNR w KQkq - 0 1',
      );
    });
  });
}

Future<void> dragFromTo(WidgetTester tester, String from, String to) async {
  final fromOffset = squareOffset(tester, Square.fromName(from));

  await tester.dragFrom(fromOffset, squareOffset(tester, Square.fromName(to)) - fromOffset);
  await tester.pumpAndSettle();
}

Future<void> panFromTo(WidgetTester tester, String from, String to) async {
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
