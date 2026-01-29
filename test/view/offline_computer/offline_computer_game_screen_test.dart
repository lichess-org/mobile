import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/view/offline_computer/offline_computer_game_screen.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/move_list.dart';

import '../../binding.dart';
import '../../model/engine/fake_stockfish.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

void main() {
  TestLichessBinding.ensureInitialized();

  group('Offline computer game', () {
    setUp(() {
      // Use LegalMoveFakeStockfish which returns valid moves for each position
      testBinding.stockfish = LegalMoveFakeStockfish();
    });

    testWidgets('New game dialog is shown on startup with all options', (tester) async {
      final app = await makeTestProviderScopeApp(tester, home: const OfflineComputerGameScreen());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // Verify new game dialog is displayed
      expect(find.text('New Game'), findsOneWidget);

      // Verify level slider is shown
      expect(find.textContaining('Level'), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);

      // Verify side selection options
      expect(find.text('Play as'), findsOneWidget);
      expect(find.text('White'), findsOneWidget);
      expect(find.text('Random'), findsOneWidget);
      expect(find.text('Black'), findsOneWidget);

      // Verify action buttons
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Play'), findsOneWidget);
    });

    testWidgets('Can start a new game with default settings', (tester) async {
      await initOfflineComputerGame(tester);

      expect(find.byType(Chessboard), findsOneWidget);
      expect(find.text('Play vs Computer'), findsOneWidget);

      expect(find.byType(BottomBar), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsOneWidget);
      expect(find.byIcon(CupertinoIcons.arrow_uturn_left), findsOneWidget);
      expect(find.byIcon(CupertinoIcons.flag), findsOneWidget);
      expect(find.byIcon(CupertinoIcons.plus), findsOneWidget);

      // Verify Stockfish player info with default level (level 1)
      expect(find.textContaining('Stockfish'), findsOneWidget);
      expect(find.textContaining('1'), findsWidgets);
    });

    testWidgets('Can play moves and move list updates', (tester) async {
      await initOfflineComputerGame(tester);

      // Initially no moves in the move list
      expect(find.byType(InlineMoveItem), findsNothing);

      await playMove(tester, 'e2', 'e4');
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      // Move list should now show moves
      expect(find.byType(InlineMoveItem), findsWidgets);
      expect(find.text('e4'), findsOneWidget);

      // Wait for engine response
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      // Engine should have responded - at least 2 moves now
      expect(find.byType(InlineMoveItem), findsAtLeast(2));
    });

    testWidgets('Engine responds after player move', (tester) async {
      await initOfflineComputerGame(tester);

      // Play a move to trigger engine thinking
      await playMove(tester, 'e2', 'e4');

      // Wait for engine to respond
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      // After engine finishes, thinking indicator should not be visible
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Engine should have responded - move list should have at least 2 moves
      expect(find.byType(InlineMoveItem), findsAtLeast(2));
    });

    testWidgets('Takeback button removes moves and updates UI', (tester) async {
      await initOfflineComputerGame(tester);

      await playMove(tester, 'e2', 'e4');
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      // Verify e4 is in move list
      expect(find.text('e4'), findsOneWidget);

      // Count moves before takeback
      final movesBefore = tester.widgetList(find.byType(InlineMoveItem)).length;
      expect(movesBefore, greaterThanOrEqualTo(1));

      // Tap takeback button
      await tester.tap(find.byIcon(CupertinoIcons.arrow_uturn_left));
      await tester.pumpAndSettle();

      // Move count should decrease
      final movesAfter = tester.widgetList(find.byType(InlineMoveItem)).length;
      expect(movesAfter, lessThan(movesBefore));
    });

    testWidgets('Resign button shows confirmation dialog', (tester) async {
      await initOfflineComputerGame(tester);

      // Play moves to make the game resignable (need fullmoves > 1)
      await playMove(tester, 'e2', 'e4');
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      await playMove(tester, 'd2', 'd4');
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Tap resign button
      await tester.tap(find.byIcon(CupertinoIcons.flag));
      await tester.pumpAndSettle();

      // Verify confirmation dialog is shown
      expect(find.text('Resign'), findsWidgets);
      expect(find.text('Are you sure?'), findsOneWidget);
      expect(find.text('Yes'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);
    });

    testWidgets('Resign ends game and shows result dialog', (tester) async {
      await initOfflineComputerGame(tester);

      // Play moves to make the game resignable
      await playMove(tester, 'e2', 'e4');
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      await playMove(tester, 'd2', 'd4');
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Tap resign button
      await tester.tap(find.byIcon(CupertinoIcons.flag));
      await tester.pumpAndSettle();

      // Confirm resignation
      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();

      // Wait for result dialog timer (500ms)
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();

      // Verify result dialog is shown
      expect(find.text('Game Over'), findsOneWidget);
      expect(find.text('Resign'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);
      expect(find.text('New game'), findsWidgets);
    });

    testWidgets('New game button in bottom bar opens dialog', (tester) async {
      await initOfflineComputerGame(tester);

      // Tap new game button in bottom bar
      await tester.tap(find.byIcon(CupertinoIcons.plus));
      await tester.pumpAndSettle();

      // Verify new game dialog is shown with all options
      expect(find.text('New Game'), findsOneWidget);
      expect(find.text('Play as'), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('Menu button opens action sheet', (tester) async {
      await initOfflineComputerGame(tester);

      // Tap menu button
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Verify action sheet with options
      expect(find.text('New game'), findsWidgets);
    });

    testWidgets('Playing as black shows board from black perspective', (tester) async {
      await initOfflineComputerGame(tester, side: Side.black);

      // Wait for engine to make first move
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      // Verify board is displayed
      expect(find.byType(Chessboard), findsOneWidget);

      // The Chessboard widget should have orientation set to black
      final chessboard = tester.widget<Chessboard>(find.byType(Chessboard));
      expect(chessboard.orientation, Side.black);

      // Engine should have made the first move - move list should show a move
      expect(find.byType(InlineMoveItem), findsWidgets);
    });

    testWidgets('Stockfish player info displays correctly', (tester) async {
      await initOfflineComputerGame(tester);

      // Verify Stockfish icon is displayed
      expect(find.byType(Image), findsWidgets);

      // Verify Stockfish name with level
      expect(find.textContaining('Stockfish'), findsOneWidget);
    });

    testWidgets('Takeback button is disabled at game start', (tester) async {
      await initOfflineComputerGame(tester);

      // Find the takeback button
      final takebackButton = find.ancestor(
        of: find.byIcon(CupertinoIcons.arrow_uturn_left),
        matching: find.byType(BottomBarButton),
      );
      expect(takebackButton, findsOneWidget);

      // At game start with no moves, takeback should be disabled
      final button = tester.widget<BottomBarButton>(takebackButton);
      expect(button.onTap, isNull);
    });

    testWidgets('Resign button is disabled at game start', (tester) async {
      await initOfflineComputerGame(tester);

      // Find the resign button
      final resignButton = find.ancestor(
        of: find.byIcon(CupertinoIcons.flag),
        matching: find.byType(BottomBarButton),
      );
      expect(resignButton, findsOneWidget);

      // At game start, resign should be disabled (need fullmoves > 1)
      final button = tester.widget<BottomBarButton>(resignButton);
      expect(button.onTap, isNull);
    });

    testWidgets('Can cancel new game dialog', (tester) async {
      await initOfflineComputerGame(tester);

      // Open new game dialog
      await tester.tap(find.byIcon(CupertinoIcons.plus));
      await tester.pumpAndSettle();

      expect(find.text('New Game'), findsOneWidget);

      // Cancel the dialog
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Dialog should be closed, game should still be visible
      expect(find.text('New Game'), findsNothing);
      expect(find.byType(Chessboard), findsOneWidget);
    });

    testWidgets('Can start game with different level', (tester) async {
      final app = await makeTestProviderScopeApp(tester, home: const OfflineComputerGameScreen());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // Find and drag the level slider
      final slider = find.byType(Slider);
      expect(slider, findsOneWidget);

      // Drag slider to change level (drag to the right for higher level)
      await tester.drag(slider, const Offset(100, 0));
      await tester.pumpAndSettle();

      // Select white and start game
      await tester.tap(find.text('White'));
      await tester.pump();
      await tester.tap(find.text('Play'));
      await tester.pumpAndSettle();

      // Verify game started
      expect(find.byType(Chessboard), findsOneWidget);
    });
  });
}

/// Initialize an offline computer game and return the board rect.
Future<Rect> initOfflineComputerGame(WidgetTester tester, {Side side = Side.white}) async {
  final app = await makeTestProviderScopeApp(tester, home: const OfflineComputerGameScreen());
  await tester.pumpWidget(app);

  // Wait for new game dialog to show up
  await tester.pumpAndSettle();

  switch (side) {
    case Side.white:
      await tester.tap(find.text('White'));
    case Side.black:
      await tester.tap(find.text('Black'));
  }
  await tester.pump();

  // Tap Play to start game
  await tester.tap(find.text('Play'));
  await tester.pumpAndSettle();

  return tester.getRect(find.byType(Chessboard));
}
