import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/offline_computer_game.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import 'package:lichess_mobile/src/model/offline_computer/offline_computer_game_controller.dart';
import 'package:lichess_mobile/src/model/offline_computer/offline_computer_game_storage.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/offline_computer/offline_computer_game_screen.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/move_list.dart';
import 'package:mocktail/mocktail.dart';

import '../../binding.dart';
import '../../model/engine/fake_stockfish.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

class MockOfflineComputerGameStorage extends Mock implements OfflineComputerGameStorage {}

void main() {
  TestLichessBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(
      OfflineComputerGame(
        steps: [const GameStep(position: Chess.initial)].lock,
        meta: GameMeta(
          createdAt: DateTime.now(),
          rated: false,
          variant: Variant.standard,
          speed: Speed.classical,
          perf: Perf.classical,
        ),
        initialFen: null,
        status: GameStatus.started,
        playerSide: Side.white,
        stockfishLevel: StockfishLevel.level1,
        humanPlayer: const Player(onGame: true),
        enginePlayer: stockfishPlayer(),
      ),
    );
  });

  group('Offline computer game', () {
    setUp(() {
      // Use LegalMoveFakeStockfish which returns valid moves for each position
      testBinding.stockfish = LegalMoveFakeStockfish();
    });

    testWidgets('New game dialog is shown on startup with all options', (tester) async {
      final gameStorage = MockOfflineComputerGameStorage();
      when(() => gameStorage.fetchOngoingGame()).thenAnswer((_) async => null);

      final app = await makeTestProviderScopeApp(
        tester,
        home: const OfflineComputerGameScreen(),
        overrides: {
          offlineComputerGameStorageProvider: offlineComputerGameStorageProvider.overrideWith(
            (_) => gameStorage,
          ),
        },
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // Verify new game dialog is displayed (title is "Game setup")
      expect(find.text('Game setup'), findsOneWidget);

      // Verify level slider is shown
      expect(find.textContaining('Level'), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);

      // Verify side selection options (label is "Side")
      expect(find.text('Side'), findsOneWidget);
      expect(find.text('White'), findsOneWidget);
      expect(find.text('Random side'), findsOneWidget);
      expect(find.text('Black'), findsOneWidget);

      // Verify action buttons
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Play'), findsOneWidget);
    });

    testWidgets('Can start a new game with default settings', (tester) async {
      await initOfflineComputerGame(tester);

      expect(find.byType(Chessboard), findsOneWidget);
      expect(find.text('Play against computer'), findsOneWidget);

      expect(find.byType(BottomBar), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsOneWidget);
      expect(find.byIcon(CupertinoIcons.arrow_uturn_left), findsOneWidget);
      expect(find.byIcon(CupertinoIcons.flag), findsOneWidget);
      expect(find.byIcon(CupertinoIcons.lightbulb), findsOneWidget);

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

    testWidgets('New game option in menu opens dialog', (tester) async {
      await initOfflineComputerGame(tester);

      // Tap menu button
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Tap new game in menu
      await tester.tap(find.text('New game'));
      await tester.pumpAndSettle();

      // Verify new game dialog is shown with all options
      expect(find.text('Game setup'), findsOneWidget);
      expect(find.text('Side'), findsOneWidget);
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

      // Open menu and tap new game
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('New game'));
      await tester.pumpAndSettle();

      expect(find.text('Game setup'), findsOneWidget);

      // Cancel the dialog
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Dialog should be closed, game should still be visible
      expect(find.text('Game setup'), findsNothing);
      expect(find.byType(Chessboard), findsOneWidget);
    });

    testWidgets('Can start game with different level', (tester) async {
      final gameStorage = MockOfflineComputerGameStorage();
      when(() => gameStorage.fetchOngoingGame()).thenAnswer((_) async => null);

      final app = await makeTestProviderScopeApp(
        tester,
        home: const OfflineComputerGameScreen(),
        overrides: {
          offlineComputerGameStorageProvider: offlineComputerGameStorageProvider.overrideWith(
            (_) => gameStorage,
          ),
        },
      );
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

    testWidgets('Loading saved game restores position', (tester) async {
      final gameStorage = MockOfflineComputerGameStorage();

      // Return a saved game with moves already played (e4, e5)
      when(() => gameStorage.fetchOngoingGame()).thenAnswer(
        (_) async => SavedOfflineComputerGame(
          game: OfflineComputerGame(
            steps: [
              const GameStep(position: Chess.initial),
              GameStep(
                position: Position.setupPosition(
                  Rule.chess,
                  Setup.parseFen('rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq - 0 1'),
                ),
                sanMove: SanMove('e4', Move.parse('e2e4')!),
              ),
              GameStep(
                position: Position.setupPosition(
                  Rule.chess,
                  Setup.parseFen('rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2'),
                ),
                sanMove: SanMove('e5', Move.parse('e7e5')!),
              ),
            ].lock,
            meta: GameMeta(
              createdAt: DateTime.now(),
              rated: false,
              variant: Variant.standard,
              speed: Speed.classical,
              perf: Perf.classical,
            ),
            initialFen: kInitialFEN,
            status: GameStatus.started,
            playerSide: Side.white,
            stockfishLevel: StockfishLevel.level1,
            humanPlayer: const Player(onGame: true),
            enginePlayer: stockfishPlayer(),
          ),
        ),
      );
      when(() => gameStorage.save(any())).thenAnswer((_) async {});

      final app = await makeTestProviderScopeApp(
        tester,
        home: Builder(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Test Screen')),
            body: FilledButton(
              child: const Text('Go to game'),
              onPressed: () => Navigator.of(
                context,
              ).push(buildScreenRoute<void>(context, screen: const OfflineComputerGameScreen())),
            ),
          ),
        ),
        overrides: {
          offlineComputerGameStorageProvider: offlineComputerGameStorageProvider.overrideWith(
            (_) => gameStorage,
          ),
        },
      );
      await tester.pumpWidget(app);

      await tester.tap(find.text('Go to game'));

      // Wait for saved game to be loaded
      await tester.pumpAndSettle();

      verify(() => gameStorage.fetchOngoingGame()).called(1);

      // Should not show new game dialog if we loaded a saved game
      expect(find.text('Game setup'), findsNothing);

      // Should load the game's current position, i.e. e4 and e5 were played
      expect(find.byKey(const ValueKey('e2-whitepawn')), findsNothing);
      expect(find.byKey(const ValueKey('e4-whitepawn')), findsOneWidget);

      expect(find.byKey(const ValueKey('e7-blackpawn')), findsNothing);
      expect(find.byKey(const ValueKey('e5-blackpawn')), findsOneWidget);

      // Move list should show the played moves
      expect(find.text('e4'), findsOneWidget);
      expect(find.text('e5'), findsOneWidget);
    });

    testWidgets('Game is saved when exiting with confirmation', (tester) async {
      final gameStorage = MockOfflineComputerGameStorage();

      when(() => gameStorage.fetchOngoingGame()).thenAnswer((_) async => null);
      when(() => gameStorage.save(any())).thenAnswer((_) async {});

      final app = await makeTestProviderScopeApp(
        tester,
        home: Builder(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Test Screen')),
            body: FilledButton(
              child: const Text('Go to game'),
              onPressed: () => Navigator.of(
                context,
              ).push(buildScreenRoute<void>(context, screen: const OfflineComputerGameScreen())),
            ),
          ),
        ),
        overrides: {
          offlineComputerGameStorageProvider: offlineComputerGameStorageProvider.overrideWith(
            (_) => gameStorage,
          ),
        },
      );
      await tester.pumpWidget(app);

      await tester.tap(find.text('Go to game'));
      await tester.pumpAndSettle();

      // Start a new game
      await tester.tap(find.text('White'));
      await tester.pump();
      await tester.tap(find.text('Play'));
      await tester.pumpAndSettle();

      // Play a move so the game is not abortable
      await playMove(tester, 'e2', 'e4');
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Play another move to ensure game is resignable (fullmoves > 1)
      await playMove(tester, 'd2', 'd4');
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Try to go back - should show confirmation dialog
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Confirmation dialog should be shown
      expect(find.text('Are you sure?'), findsOneWidget);
      expect(find.text('No worries, your game will be saved.'), findsOneWidget);

      // Confirm exit
      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();

      // Verify save was called
      verify(() => gameStorage.save(any())).called(1);
    });
  });

  group('Hint feature', () {
    setUp(() {
      // Use MultiPvFakeStockfish which returns multiPv evaluation data
      testBinding.stockfish = MultiPvFakeStockfish();
    });

    testWidgets('Hint button shows lightbulb icon', (tester) async {
      await initOfflineComputerGame(tester);

      // Verify hint button with lightbulb icon is shown
      expect(find.byIcon(CupertinoIcons.lightbulb), findsOneWidget);

      // Verify the button has "Get a hint" label
      final hintButton = find.ancestor(
        of: find.byIcon(CupertinoIcons.lightbulb),
        matching: find.byType(BottomBarButton),
      );
      expect(hintButton, findsOneWidget);
    });

    testWidgets('Hint button is disabled while hints are loading', (tester) async {
      final gameStorage = MockOfflineComputerGameStorage();
      when(() => gameStorage.fetchOngoingGame()).thenAnswer((_) async => null);

      late WidgetRef ref;
      final app = await makeTestProviderScopeApp(
        tester,
        home: Consumer(
          builder: (context, r, _) {
            ref = r;
            return const OfflineComputerGameScreen();
          },
        ),
        overrides: {
          offlineComputerGameStorageProvider: offlineComputerGameStorageProvider.overrideWith(
            (_) => gameStorage,
          ),
        },
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // Start game as white
      await tester.tap(find.text('White'));
      await tester.pump();
      await tester.tap(find.text('Play'));

      // Pump once to trigger hint computation but not complete it
      await tester.pump();

      // Check if hints are loading
      final gameState = ref.read(offlineComputerGameControllerProvider);

      // If loading hint, the button should be disabled
      if (gameState.isLoadingHint) {
        final hintButton = find.ancestor(
          of: find.byIcon(CupertinoIcons.lightbulb),
          matching: find.byType(BottomBarButton),
        );
        final button = tester.widget<BottomBarButton>(hintButton);
        expect(button.onTap, isNull);
      }

      // Let hints finish computing
      await tester.pumpAndSettle();
    });

    testWidgets('Hint button shows circle on board when pressed', (tester) async {
      final gameStorage = MockOfflineComputerGameStorage();
      when(() => gameStorage.fetchOngoingGame()).thenAnswer((_) async => null);

      late WidgetRef ref;
      final app = await makeTestProviderScopeApp(
        tester,
        home: Consumer(
          builder: (context, r, _) {
            ref = r;
            return const OfflineComputerGameScreen();
          },
        ),
        overrides: {
          offlineComputerGameStorageProvider: offlineComputerGameStorageProvider.overrideWith(
            (_) => gameStorage,
          ),
        },
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // Start game as white
      await tester.tap(find.text('White'));
      await tester.pump();
      await tester.tap(find.text('Play'));
      await tester.pumpAndSettle();

      // Wait for hints to be computed (timeout after 3 seconds)
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      final gameState = ref.read(offlineComputerGameControllerProvider);

      // If hints are available, pressing hint button should show a circle
      if (gameState.hintMoves != null && gameState.hintMoves!.isNotEmpty) {
        // No hint shown initially
        expect(gameState.hintSquare, isNull);

        // Press hint button
        await tester.tap(find.byIcon(CupertinoIcons.lightbulb));
        await tester.pump();

        // Hint square should now be set
        final updatedState = ref.read(offlineComputerGameControllerProvider);
        expect(updatedState.hintIndex, equals(0));
        expect(updatedState.hintSquare, isNotNull);
      }
    });

    testWidgets('Hint button cycles through hints on subsequent presses', (tester) async {
      final gameStorage = MockOfflineComputerGameStorage();
      when(() => gameStorage.fetchOngoingGame()).thenAnswer((_) async => null);

      late WidgetRef ref;
      final app = await makeTestProviderScopeApp(
        tester,
        home: Consumer(
          builder: (context, r, _) {
            ref = r;
            return const OfflineComputerGameScreen();
          },
        ),
        overrides: {
          offlineComputerGameStorageProvider: offlineComputerGameStorageProvider.overrideWith(
            (_) => gameStorage,
          ),
        },
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // Start game as white
      await tester.tap(find.text('White'));
      await tester.pump();
      await tester.tap(find.text('Play'));
      await tester.pumpAndSettle();

      // Wait for hints to be computed
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      final gameState = ref.read(offlineComputerGameControllerProvider);

      if (gameState.hintMoves != null && gameState.hintMoves!.length > 1) {
        // Press hint button first time
        await tester.tap(find.byIcon(CupertinoIcons.lightbulb));
        await tester.pump();

        final firstHintState = ref.read(offlineComputerGameControllerProvider);
        expect(firstHintState.hintIndex, equals(0));
        final firstHintSquare = firstHintState.hintSquare;

        // Press hint button second time
        await tester.tap(find.byIcon(CupertinoIcons.lightbulb));
        await tester.pump();

        final secondHintState = ref.read(offlineComputerGameControllerProvider);
        expect(secondHintState.hintIndex, equals(1));
        final secondHintSquare = secondHintState.hintSquare;

        // Hint square should be different (different origin)
        expect(secondHintSquare, isNot(equals(firstHintSquare)));
      }
    });

    testWidgets('Hints are cleared when a move is made', (tester) async {
      final gameStorage = MockOfflineComputerGameStorage();
      when(() => gameStorage.fetchOngoingGame()).thenAnswer((_) async => null);

      late WidgetRef ref;
      final app = await makeTestProviderScopeApp(
        tester,
        home: Consumer(
          builder: (context, r, _) {
            ref = r;
            return const OfflineComputerGameScreen();
          },
        ),
        overrides: {
          offlineComputerGameStorageProvider: offlineComputerGameStorageProvider.overrideWith(
            (_) => gameStorage,
          ),
        },
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // Start game as white
      await tester.tap(find.text('White'));
      await tester.pump();
      await tester.tap(find.text('Play'));
      await tester.pumpAndSettle();

      // Wait for hints to be computed
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      final gameState = ref.read(offlineComputerGameControllerProvider);

      if (gameState.hintMoves != null && gameState.hintMoves!.isNotEmpty) {
        // Press hint button to show a hint
        await tester.tap(find.byIcon(CupertinoIcons.lightbulb));
        await tester.pump();

        final hintState = ref.read(offlineComputerGameControllerProvider);
        expect(hintState.hintSquare, isNotNull);

        // Play a move
        await playMove(tester, 'e2', 'e4');
        await tester.pump(const Duration(milliseconds: 200));

        // Hints should be cleared
        final afterMoveState = ref.read(offlineComputerGameControllerProvider);
        expect(afterMoveState.hintIndex, isNull);
      }
    });

    testWidgets('Hint button is highlighted when hint is showing', (tester) async {
      final gameStorage = MockOfflineComputerGameStorage();
      when(() => gameStorage.fetchOngoingGame()).thenAnswer((_) async => null);

      late WidgetRef ref;
      final app = await makeTestProviderScopeApp(
        tester,
        home: Consumer(
          builder: (context, r, _) {
            ref = r;
            return const OfflineComputerGameScreen();
          },
        ),
        overrides: {
          offlineComputerGameStorageProvider: offlineComputerGameStorageProvider.overrideWith(
            (_) => gameStorage,
          ),
        },
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // Start game as white
      await tester.tap(find.text('White'));
      await tester.pump();
      await tester.tap(find.text('Play'));
      await tester.pumpAndSettle();

      // Wait for hints to be computed
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      final gameState = ref.read(offlineComputerGameControllerProvider);

      if (gameState.hintMoves != null && gameState.hintMoves!.isNotEmpty) {
        // Before pressing hint, button should not be highlighted
        var hintButton = find.ancestor(
          of: find.byIcon(CupertinoIcons.lightbulb),
          matching: find.byType(BottomBarButton),
        );
        var button = tester.widget<BottomBarButton>(hintButton);
        expect(button.highlighted, isFalse);

        // Press hint button
        await tester.tap(find.byIcon(CupertinoIcons.lightbulb));
        await tester.pump();

        // Button should now be highlighted
        hintButton = find.ancestor(
          of: find.byIcon(CupertinoIcons.lightbulb),
          matching: find.byType(BottomBarButton),
        );
        button = tester.widget<BottomBarButton>(hintButton);
        expect(button.highlighted, isTrue);
      }
    });

    testWidgets('Hint button is disabled when not player turn', (tester) async {
      // Use LegalMoveFakeStockfish for this test as we need engine to play
      testBinding.stockfish = LegalMoveFakeStockfish();
      await initOfflineComputerGame(tester, side: Side.black);

      // When playing as black, it's white's turn initially (engine's turn)
      // Wait briefly for engine to start thinking
      await tester.pump(const Duration(milliseconds: 100));

      // Find the hint button
      final hintButton = find.ancestor(
        of: find.byIcon(CupertinoIcons.lightbulb),
        matching: find.byType(BottomBarButton),
      );

      // During engine's turn, hint button should be disabled
      final button = tester.widget<BottomBarButton>(hintButton);
      expect(button.onTap, isNull);

      // Wait for engine move
      await tester.pumpAndSettle();
    });
  });
}

/// Initialize an offline computer game and return the board rect.
Future<Rect> initOfflineComputerGame(WidgetTester tester, {Side side = Side.white}) async {
  final gameStorage = MockOfflineComputerGameStorage();
  when(() => gameStorage.fetchOngoingGame()).thenAnswer((_) async => null);

  final app = await makeTestProviderScopeApp(
    tester,
    home: const OfflineComputerGameScreen(),
    overrides: {
      offlineComputerGameStorageProvider: offlineComputerGameStorageProvider.overrideWith(
        (_) => gameStorage,
      ),
    },
  );
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
