import 'dart:io';

import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/over_the_board_game.dart';
import 'package:lichess_mobile/src/model/over_the_board/over_the_board_clock.dart';
import 'package:lichess_mobile/src/model/over_the_board/over_the_board_game_controller.dart';
import 'package:lichess_mobile/src/model/over_the_board/over_the_board_game_storage.dart';
import 'package:lichess_mobile/src/view/over_the_board/over_the_board_screen.dart';
import 'package:lichess_mobile/src/widgets/clock.dart';
import 'package:mocktail/mocktail.dart';

import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

class MockOverTheBoardGameStorage extends Mock implements OverTheBoardGameStorage {}

void main() {
  registerFallbackValue(
    OverTheBoardGame(
      steps: [const GameStep(position: Chess.initial)].lock,
      meta: GameMeta(
        createdAt: DateTime.now(),
        rated: false,
        variant: Variant.standard,
        speed: Speed.rapid,
        perf: Perf.rapid,
      ),
      initialFen: null,
      status: GameStatus.unknown,
    ),
  );
  registerFallbackValue(const TimeIncrement(0, 0));

  group('Playing over the board (offline)', () {
    testWidgets('Checkmate and Rematch', (tester) async {
      final boardRect = await initOverTheBoardGame(tester, const TimeIncrement(60, 5));

      // Default orientation is white at the bottom
      expect(
        tester.getBottomLeft(find.byKey(const ValueKey('a1-whiterook'))),
        boardRect.bottomLeft,
      );

      await playMove(tester, 'e2', 'e4');
      await playMove(tester, 'f7', 'f6');
      await playMove(tester, 'd2', 'd4');
      await playMove(tester, 'g7', 'g5');
      await playMove(tester, 'd1', 'h5');

      await tester.pumpAndSettle(const Duration(milliseconds: 600));
      expect(find.text('Checkmate • White is victorious'), findsOneWidget);

      await tester.tap(find.text('Rematch'));
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(tester.element(find.byType(Chessboard)));
      final gameState = container.read(overTheBoardGameControllerProvider);
      expect(gameState.game.steps.length, 1);
      expect(gameState.game.steps.first.position, Chess.initial);

      // Rematch should flip orientation
      expect(tester.getTopRight(find.byKey(const ValueKey('a1-whiterook'))), boardRect.topRight);

      expect(activeClock(tester), null);
    });

    testWidgets('Game ends when out of time', (tester) async {
      const time = Duration(seconds: 1);
      await initOverTheBoardGame(tester, TimeIncrement(time.inSeconds, 0));

      await playMove(tester, 'e2', 'e4');
      await playMove(tester, 'e7', 'e5');

      // The clock measures system time internally, so we need to actually sleep in order
      // for the clock to reach 0, instead of using tester.pump()
      sleep(time + const Duration(milliseconds: 100));

      // Now for game result dialog to show up
      await tester.pumpAndSettle(const Duration(milliseconds: 600));
      expect(find.text('White time out • Black is victorious'), findsOneWidget);

      await tester.tap(find.text('Rematch'));
      expect(activeClock(tester), null);
    });

    testWidgets('Pausing the clock', (tester) async {
      const time = Duration(seconds: 10);

      await initOverTheBoardGame(tester, TimeIncrement(time.inSeconds, 0));

      await playMove(tester, 'e2', 'e4');
      await playMove(tester, 'e7', 'e5');

      await tester.tap(find.byTooltip('Pause'));
      await tester.pump();

      expect(activeClock(tester), null);

      await tester.tap(find.byTooltip('Resume'));
      await tester.pump();

      expect(activeClock(tester), Side.white);

      // Going back a move should not unpause...
      await tester.tap(find.byTooltip('Pause'));
      await tester.pump();
      await tester.tap(find.byTooltip('Previous'));
      await tester.pump();

      expect(activeClock(tester), null);

      // ... but playing a move resumes the clock
      await playMove(tester, 'd7', 'd5');

      expect(activeClock(tester), Side.white);
    });

    testWidgets('Go back and Forward', (tester) async {
      const time = Duration(seconds: 10);

      await initOverTheBoardGame(tester, TimeIncrement(time.inSeconds, 0));

      await playMove(tester, 'e2', 'e4');
      await playMove(tester, 'e7', 'e5');

      await tester.tap(find.byTooltip('Previous'));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('e7-blackpawn')), findsOneWidget);

      expect(activeClock(tester), Side.black);

      await tester.tap(find.byTooltip('Next'));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('e5-blackpawn')), findsOneWidget);

      expect(activeClock(tester), Side.white);

      // Go back all the way to the initial position
      await tester.tap(find.byTooltip('Previous'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Previous'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Previous'));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('e2-whitepawn')), findsOneWidget);
      expect(find.byKey(const ValueKey('e7-blackpawn')), findsOneWidget);

      expect(activeClock(tester), Side.white);

      await playMove(tester, 'e2', 'e4');
      expect(find.byKey(const ValueKey('e4-whitepawn')), findsOneWidget);

      expect(activeClock(tester), Side.black);
    });

    testWidgets('No clock if time is infinite', (tester) async {
      await initOverTheBoardGame(tester, const TimeIncrement(0, 0));

      expect(find.byType(Clock), findsNothing);
    });

    testWidgets('Clock logic', (tester) async {
      const time = Duration(minutes: 5);

      await initOverTheBoardGame(tester, TimeIncrement(time.inSeconds, 3));

      expect(activeClock(tester), null);

      expect(findWhiteClock(tester).timeLeft, time);
      expect(findBlackClock(tester).timeLeft, time);

      await playMove(tester, 'e2', 'e4');

      const moveTime = Duration(milliseconds: 500);
      await tester.pumpAndSettle(moveTime);

      expect(activeClock(tester), Side.black);

      expect(findWhiteClock(tester).timeLeft, time);
      expect(findBlackClock(tester).timeLeft, lessThan(time));

      await playMove(tester, 'e7', 'e5');
      await tester.pumpAndSettle();

      expect(activeClock(tester), Side.white);

      // Expect increment to be added
      expect(findBlackClock(tester).timeLeft, greaterThan(time));

      expect(findWhiteClock(tester).timeLeft, lessThan(time));
    });

    testWidgets('Loading saved game', (tester) async {
      final gameStorage = MockOverTheBoardGameStorage();

      when(() => gameStorage.fetchOngoingGame()).thenAnswer(
        (_) async => SavedOtbGame(
          game: OverTheBoardGame(
            steps: [
              const GameStep(position: Chess.initial),
              GameStep(
                position: Position.setupPosition(
                  Rule.chess,
                  Setup.parseFen('rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq - 0 1'),
                ),
                sanMove: SanMove('e4', Move.parse('e2e4')!),
              ),
            ].lock,
            meta: GameMeta(
              createdAt: DateTime.now(),
              rated: false,
              variant: Variant.standard,
              speed: Speed.rapid,
              perf: Perf.rapid,
            ),
            initialFen: null,
            status: GameStatus.started,
          ),
          whiteTimeLeft: const Duration(minutes: 2),
          blackTimeLeft: const Duration(minutes: 1),
          timeIncrement: const TimeIncrement(5, 3),
        ),
      );
      when(
        () => gameStorage.save(
          any(),
          timeIncrement: any(named: 'timeIncrement'),
          whiteTimeLeft: any(named: 'whiteTimeLeft'),
          blackTimeLeft: any(named: 'blackTimeLeft'),
        ),
      ).thenAnswer((_) async {});

      final app = await makeTestProviderScopeApp(
        tester,
        home: const OverTheBoardScreen(),
        overrides: {
          overTheBoardGameStorageProvider: overTheBoardGameStorageProvider.overrideWith(
            (_) => gameStorage,
          ),
        },
      );
      await tester.pumpWidget(app);

      // Wait for previous game to be loaded
      await tester.pumpAndSettle();

      verify(() => gameStorage.fetchOngoingGame()).called(1);

      // Should not show bottom sheet if we loaded a previous game
      expect(find.text('Play'), findsNothing);

      // Should load the game's current position, i.e. e4 was played
      expect(find.byKey(const ValueKey('e2-whitepawn')), findsNothing);
      expect(find.byKey(const ValueKey('e4-whitepawn')), findsOneWidget);

      expect(activeClock(tester), null);
      expect(findWhiteClock(tester).timeLeft, const Duration(minutes: 2));
      expect(findBlackClock(tester).timeLeft, const Duration(minutes: 1));

      // Start black's clock
      await tester.tap(find.byTooltip('Resume'));
      await tester.pump();
      expect(activeClock(tester), Side.black);

      // Hide OTB screen to trigger save
      await tester.pumpWidget(const SizedBox.shrink());

      verify(
        () => gameStorage.save(
          any(),
          timeIncrement: const TimeIncrement(5, 3),
          whiteTimeLeft: const Duration(minutes: 2),
          blackTimeLeft: const Duration(minutes: 1),
        ),
      ).called(1);
    });
  });
}

Future<Rect> initOverTheBoardGame(WidgetTester tester, TimeIncrement timeIncrement) async {
  final gameStorage = MockOverTheBoardGameStorage();

  when(() => gameStorage.fetchOngoingGame()).thenAnswer((_) async => null);
  when(
    () => gameStorage.save(
      any(),
      timeIncrement: any(named: 'timeIncrement'),
      whiteTimeLeft: any(named: 'whiteTimeLeft'),
      blackTimeLeft: any(named: 'blackTimeLeft'),
    ),
  ).thenAnswer((_) async {});

  final app = await makeTestProviderScopeApp(
    tester,
    home: const OverTheBoardScreen(),
    overrides: {
      overTheBoardGameStorageProvider: overTheBoardGameStorageProvider.overrideWith(
        (_) => gameStorage,
      ),
    },
  );
  await tester.pumpWidget(app);

  // Wait for bottom sheet to show up
  await tester.pumpAndSettle();

  // User taps Play to start game now
  await tester.tap(find.text('Play'));

  // Wait for bottom sheet to disappear
  await tester.pumpAndSettle();

  await tester.tap(find.byIcon(CupertinoIcons.play));

  final container = ProviderScope.containerOf(tester.element(find.byType(Chessboard)));
  container.read(overTheBoardClockProvider.notifier).setupClock(timeIncrement);
  await tester.pumpAndSettle();

  return tester.getRect(find.byType(Chessboard));
}

Side? activeClock(WidgetTester tester, {Side orientation = Side.white}) {
  final whiteClock = findWhiteClock(tester, orientation: orientation);
  final blackClock = findBlackClock(tester, orientation: orientation);

  if (whiteClock.active) {
    expect(blackClock.active, false);
    return Side.white;
  }

  if (blackClock.active) {
    expect(whiteClock.active, false);
    return Side.black;
  }

  return null;
}

Clock findWhiteClock(WidgetTester tester, {Side orientation = Side.white}) {
  return tester.widget<Clock>(
    find.byKey(ValueKey(orientation == Side.white ? 'bottomClock' : 'topClock')),
  );
}

Clock findBlackClock(WidgetTester tester, {Side orientation = Side.white}) {
  return tester.widget<Clock>(
    find.byKey(ValueKey(orientation == Side.white ? 'topClock' : 'bottomClock')),
  );
}
