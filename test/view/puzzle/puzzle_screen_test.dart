import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_batch_storage.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_difficulty.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_preferences.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_storage.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/string.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_screen.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';
import 'package:mocktail/mocktail.dart';

import '../../model/auth/fake_auth_storage.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';
import 'example_data.dart';

class MockPuzzleBatchStorage extends Mock implements PuzzleBatchStorage {}

class MockPuzzleStorage extends Mock implements PuzzleStorage {}

class MockPuzzlePreferences extends PuzzlePreferences with Mock {
  MockPuzzlePreferences(this._rated);

  final bool _rated;

  @override
  PuzzlePrefs build() {
    return PuzzlePrefs(
      id: fakeAuthUser.user.id,
      difficulty: PuzzleDifficulty.normal,
      autoNext: false,
      rated: _rated,
    );
  }
}

void main() {
  setUpAll(() {
    registerFallbackValue(PuzzleBatch(solved: IList(const []), unsolved: IList([puzzle])));
    registerFallbackValue(puzzle);
  });

  final mockBatchStorage = MockPuzzleBatchStorage();
  final mockHistoryStorage = MockPuzzleStorage();

  group('PuzzleScreen', () {
    testWidgets('meets accessibility guidelines', variant: kPlatformVariant, (
      WidgetTester tester,
    ) async {
      final SemanticsHandle handle = tester.ensureSemantics();

      final app = await makeTestProviderScopeApp(
        tester,
        home: PuzzleScreen(
          angle: const PuzzleTheme(PuzzleThemeKey.mix),
          puzzleId: puzzle.puzzle.id,
        ),
        overrides: {
          puzzleBatchStorageProvider: puzzleBatchStorageProvider.overrideWith(
            (ref) => mockBatchStorage,
          ),
          puzzleStorageProvider: puzzleStorageProvider.overrideWith((ref) => mockHistoryStorage),
        },
      );

      when(
        () => mockHistoryStorage.fetch(puzzleId: puzzle.puzzle.id),
      ).thenAnswer((_) async => puzzle);

      await tester.pumpWidget(app);

      // wait for the puzzle to load
      await tester.pump(const Duration(milliseconds: 200));

      await meetsTapTargetGuideline(tester);

      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      handle.dispose();
    });

    testWidgets('Loads puzzle directly by passing a puzzleId', variant: kPlatformVariant, (
      tester,
    ) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: PuzzleScreen(
          angle: const PuzzleTheme(PuzzleThemeKey.mix),
          puzzleId: puzzle.puzzle.id,
        ),
        overrides: {
          puzzleBatchStorageProvider: puzzleBatchStorageProvider.overrideWith(
            (ref) => mockBatchStorage,
          ),
          puzzleStorageProvider: puzzleStorageProvider.overrideWith((ref) => mockHistoryStorage),
        },
      );

      when(
        () => mockHistoryStorage.fetch(puzzleId: puzzle.puzzle.id),
      ).thenAnswer((_) async => puzzle);

      await tester.pumpWidget(app);

      // wait for the puzzle to load
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(Chessboard), findsOneWidget);
      expect(find.text('Your turn'), findsOneWidget);
    });

    testWidgets('Loads next puzzle when no puzzleId is passed', (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const PuzzleScreen(angle: PuzzleTheme(PuzzleThemeKey.mix)),
        overrides: {
          puzzleBatchStorageProvider: puzzleBatchStorageProvider.overrideWith(
            (ref) => mockBatchStorage,
          ),
          puzzleStorageProvider: puzzleStorageProvider.overrideWith((ref) => mockHistoryStorage),
        },
      );

      when(
        () => mockBatchStorage.fetch(userId: null, angle: const PuzzleTheme(PuzzleThemeKey.mix)),
      ).thenAnswer((_) async => batch);

      when(() => mockHistoryStorage.save(puzzle: any(named: 'puzzle'))).thenAnswer((_) async {});

      await tester.pumpWidget(app);

      expect(find.byType(Chessboard), findsNothing);
      expect(find.text('Your turn'), findsNothing);

      // wait for the puzzle to load
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(Chessboard), findsOneWidget);
      expect(find.text('Your turn'), findsOneWidget);
    });

    testWidgets('solves a puzzle and loads the next one', variant: kPlatformVariant, (
      tester,
    ) async {
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/puzzle/batch/mix') {
          return mockResponse(batchOf1, 200);
        }
        return mockResponse('', 404);
      });

      when(
        () => mockHistoryStorage.fetch(puzzleId: puzzle2.puzzle.id),
      ).thenAnswer((_) async => puzzle2);

      final app = await makeTestProviderScopeApp(
        tester,
        home: PuzzleScreen(
          angle: const PuzzleTheme(PuzzleThemeKey.mix),
          puzzleId: puzzle2.puzzle.id,
        ),
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith((ref) {
            return LichessClient(mockClient, ref);
          }),
          puzzleBatchStorageProvider: puzzleBatchStorageProvider.overrideWith((ref) {
            return mockBatchStorage;
          }),
          puzzleStorageProvider: puzzleStorageProvider.overrideWith((ref) => mockHistoryStorage),
        },
      );

      Future<void> saveDBReq() => mockBatchStorage.save(
        userId: null,
        angle: const PuzzleTheme(PuzzleThemeKey.mix),
        data: any(named: 'data'),
      );
      when(saveDBReq).thenAnswer((_) async {});
      when(
        () => mockBatchStorage.fetch(userId: null, angle: const PuzzleTheme(PuzzleThemeKey.mix)),
      ).thenAnswer((_) async => batch);

      when(() => mockHistoryStorage.save(puzzle: any(named: 'puzzle'))).thenAnswer((_) async {});

      await tester.pumpWidget(app);

      // wait for the puzzle to load
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(Chessboard), findsOneWidget);
      expect(find.text('Your turn'), findsOneWidget);

      // before the first move is played, puzzle is not interactable
      expect(find.byKey(const Key('g4-blackrook')), findsOneWidget);
      await tester.tap(find.byKey(const Key('g4-blackrook')));
      await tester.pump();
      expect(find.byKey(const Key('g4-selected')), findsNothing);

      const orientation = Side.black;

      // wait for first move to be played
      await tester.pump(const Duration(milliseconds: 1500));

      // in play mode we don't see the continue button
      expect(find.byIcon(CupertinoIcons.play_arrow_solid), findsNothing);
      // in play mode we see the solution button
      expect(find.byIcon(Icons.help), findsOneWidget);

      expect(find.byKey(const Key('g4-blackrook')), findsOneWidget);
      expect(find.byKey(const Key('h8-whitequeen')), findsOneWidget);

      await playMove(tester, 'g4', 'h4', orientation: orientation);

      expect(find.byKey(const Key('h4-blackrook')), findsOneWidget);
      expect(find.text('Best move!'), findsOneWidget);

      // wait for line reply and move animation
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('h4-whitequeen')), findsOneWidget);

      await playMove(tester, 'b4', 'h4', orientation: orientation);

      expect(find.byKey(const Key('h4-blackrook')), findsOneWidget);
      expect(find.text('Success!'), findsOneWidget);

      // wait for move animation
      await tester.pumpAndSettle();

      // called once to save solution and once after fetching a new puzzle
      verify(saveDBReq).called(2);

      expect(find.byIcon(CupertinoIcons.play_arrow_solid), findsOneWidget);
      expect(find.byIcon(Icons.help), findsNothing);

      await tester.tap(find.byIcon(CupertinoIcons.play_arrow_solid));

      // await for new puzzle load
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Success!'), findsNothing);
      expect(find.text('Your turn'), findsOneWidget);
    });

    for (final showRatings in ShowRatings.values) {
      testWidgets('fails a puzzle, (showRatings: $showRatings)', variant: kPlatformVariant, (
        tester,
      ) async {
        final mockClient = MockClient((request) {
          if (request.url.path == '/api/puzzle/batch/mix') {
            return mockResponse(batchOf1, 200);
          }
          return mockResponse('', 404);
        });

        when(
          () => mockHistoryStorage.fetch(puzzleId: puzzle2.puzzle.id),
        ).thenAnswer((_) async => puzzle2);

        final app = await makeTestProviderScopeApp(
          tester,
          home: PuzzleScreen(
            angle: const PuzzleTheme(PuzzleThemeKey.mix),
            puzzleId: puzzle2.puzzle.id,
          ),
          overrides: {
            lichessClientProvider: lichessClientProvider.overrideWith((ref) {
              return LichessClient(mockClient, ref);
            }),
            puzzleBatchStorageProvider: puzzleBatchStorageProvider.overrideWith((ref) {
              return mockBatchStorage;
            }),
            puzzleStorageProvider: puzzleStorageProvider.overrideWith((ref) => mockHistoryStorage),
            showRatingsPrefProvider: showRatingsPrefProvider.overrideWith((ref) {
              return showRatings;
            }),
          },
        );

        when(() => mockHistoryStorage.save(puzzle: any(named: 'puzzle'))).thenAnswer((_) async {});

        Future<void> saveDBReq() => mockBatchStorage.save(
          userId: null,
          angle: const PuzzleTheme(PuzzleThemeKey.mix),
          data: any(named: 'data'),
        );
        when(saveDBReq).thenAnswer((_) async {});
        when(
          () => mockBatchStorage.fetch(userId: null, angle: const PuzzleTheme(PuzzleThemeKey.mix)),
        ).thenAnswer((_) async => batch);

        await tester.pumpWidget(app);

        // wait for the puzzle to load
        await tester.pump(const Duration(milliseconds: 200));

        expect(find.byType(Chessboard), findsOneWidget);
        expect(find.text('Your turn'), findsOneWidget);

        const orientation = Side.black;

        // await for first move to be played
        await tester.pump(const Duration(milliseconds: 1500));

        expect(find.byKey(const Key('g4-blackrook')), findsOneWidget);

        await playMove(tester, 'g4', 'f4', orientation: orientation);

        expect(find.text("That's not the move!"), findsOneWidget);

        // wait for move cancel and animation
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pumpAndSettle();

        // can still play the puzzle
        expect(find.byKey(const Key('g4-blackrook')), findsOneWidget);

        await playMove(tester, 'g4', 'h4', orientation: orientation);

        expect(find.byKey(const Key('h4-blackrook')), findsOneWidget);
        expect(find.text('Best move!'), findsOneWidget);

        // wait for line reply and move animation
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pumpAndSettle();

        await playMove(tester, 'b4', 'h4', orientation: orientation);

        expect(find.byKey(const Key('h4-blackrook')), findsOneWidget);
        expect(find.text('Puzzle complete!'), findsOneWidget);
        final expectedPlayedXTimes =
            'Played ${puzzle2.puzzle.plays.toString().localizeNumbers()} times.';
        expect(
          find.text(
            showRatings == ShowRatings.no
                ? expectedPlayedXTimes
                : 'Rating: ${puzzle2.puzzle.rating}. $expectedPlayedXTimes',
          ),
          findsOneWidget,
        );

        // wait for move animation
        await tester.pumpAndSettle();

        // called once to save solution and once after fetching a new puzzle
        verify(saveDBReq).called(2);
      });
    }

    testWidgets('view solution', variant: kPlatformVariant, (tester) async {
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/puzzle/batch/mix') {
          return mockResponse(batchOf1, 200);
        }
        return mockResponse('', 404);
      });

      final app = await makeTestProviderScopeApp(
        tester,
        home: PuzzleScreen(
          angle: const PuzzleTheme(PuzzleThemeKey.mix),
          puzzleId: puzzle2.puzzle.id,
        ),
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith((ref) {
            return LichessClient(mockClient, ref);
          }),
          puzzleBatchStorageProvider: puzzleBatchStorageProvider.overrideWith((ref) {
            return mockBatchStorage;
          }),
          puzzleStorageProvider: puzzleStorageProvider.overrideWith((ref) => mockHistoryStorage),
        },
      );

      when(
        () => mockHistoryStorage.fetch(puzzleId: puzzle2.puzzle.id),
      ).thenAnswer((_) async => puzzle2);

      when(() => mockHistoryStorage.save(puzzle: any(named: 'puzzle'))).thenAnswer((_) async {});

      Future<void> saveDBReq() => mockBatchStorage.save(
        userId: null,
        angle: const PuzzleTheme(PuzzleThemeKey.mix),
        data: any(named: 'data'),
      );
      when(saveDBReq).thenAnswer((_) async {});
      when(
        () => mockBatchStorage.fetch(userId: null, angle: const PuzzleTheme(PuzzleThemeKey.mix)),
      ).thenAnswer((_) async => batch);

      await tester.pumpWidget(app);

      // wait for the puzzle to load
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(Chessboard), findsOneWidget);
      expect(find.text('Your turn'), findsOneWidget);

      // await for first move to be played
      await tester.pump(const Duration(milliseconds: 1500));

      expect(find.byKey(const Key('g4-blackrook')), findsOneWidget);

      // Help button should still be disabled
      expect(find.byIcon(Icons.help), findsOneWidget);
      expect(
        tester
            .firstWidget<BottomBarButton>(
              find.ancestor(of: find.byIcon(Icons.help), matching: find.byType(BottomBarButton)),
            )
            .enabled,
        isFalse,
      );

      // wait for the solution button to be enabled
      await tester.pump(const Duration(seconds: 4));

      await tester.tap(find.byIcon(Icons.help));

      // wait for solution replay animation to finish
      await tester.pump(const Duration(seconds: 1));

      expect(find.byKey(const Key('h4-blackrook')), findsOneWidget);
      expect(find.byKey(const Key('h8-whitequeen')), findsOneWidget);
      expect(find.text('Puzzle complete!'), findsOneWidget);

      final nextMoveBtnEnabled = find.byWidgetPredicate(
        (widget) =>
            widget is BottomBarButton &&
            widget.icon == CupertinoIcons.chevron_forward &&
            widget.enabled,
      );
      expect(nextMoveBtnEnabled, findsOneWidget);

      // advance to next move of solution
      await tester.tap(nextMoveBtnEnabled);

      expect(find.byIcon(CupertinoIcons.play_arrow_solid), findsOneWidget);

      // called once to save solution and once after fetching a new puzzle
      verify(saveDBReq).called(2);
    });

    for (final isRatedPreference in [true, false]) {
      testWidgets(
        'puzzle rating is saved correctly, (isRatedPreference: $isRatedPreference)',
        variant: kPlatformVariant,
        (WidgetTester tester) async {
          final mockClient = MockClient((request) {
            if (request.url.path == '/api/puzzle/batch/mix') {
              return mockResponse(batchOf1, 200);
            }
            return mockResponse('', 404);
          });

          final app = await makeTestProviderScopeApp(
            tester,
            home: PuzzleScreen(
              angle: const PuzzleTheme(PuzzleThemeKey.mix),
              puzzleId: puzzle2.puzzle.id,
            ),
            overrides: {
              lichessClientProvider: lichessClientProvider.overrideWith((ref) {
                return LichessClient(mockClient, ref);
              }),
              puzzleBatchStorageProvider: puzzleBatchStorageProvider.overrideWith(
                (ref) => mockBatchStorage,
              ),
              puzzleStorageProvider: puzzleStorageProvider.overrideWith(
                (ref) => mockHistoryStorage,
              ),
              puzzlePreferencesProvider: puzzlePreferencesProvider.overrideWith(
                () => MockPuzzlePreferences(isRatedPreference),
              ),
            },
            authUser: fakeAuthUser,
          );

          Future<void> saveDBReq() => mockBatchStorage.save(
            userId: fakeAuthUser.user.id,
            angle: const PuzzleTheme(PuzzleThemeKey.mix),
            data: captureAny(named: 'data'),
          );
          when(saveDBReq).thenAnswer((_) async {});
          when(
            () => mockBatchStorage.fetch(
              userId: fakeAuthUser.user.id,
              angle: const PuzzleTheme(PuzzleThemeKey.mix),
            ),
          ).thenAnswer((_) async => batch);

          when(
            () => mockHistoryStorage.save(puzzle: any(named: 'puzzle')),
          ).thenAnswer((_) async {});

          await tester.pumpWidget(app);

          // wait for the puzzle to load
          await tester.pump(const Duration(milliseconds: 200));

          // wait for first move to be played and view solution button to appear
          await tester.pump(const Duration(seconds: 5));

          // view solution
          expect(find.byIcon(Icons.help), findsOneWidget);
          await tester.tap(find.byIcon(Icons.help));

          // wait for solution replay animation to finish
          await tester.pump(const Duration(seconds: 1));

          // check puzzle was saved as isRatedPreference
          final captured = verify(saveDBReq).captured.map((e) => e as PuzzleBatch).toList();
          expect(captured.length, 2);
          expect(captured[0].solved, [
            PuzzleSolution(id: puzzle2.puzzle.id, win: false, rated: isRatedPreference),
          ]);
          expect(captured[1].solved.length, 0);
        },
      );
    }

    testWidgets('puzzle rating is saved correctly when hint is used', variant: kPlatformVariant, (
      WidgetTester tester,
    ) async {
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/puzzle/batch/mix') {
          return mockResponse(batchOf1, 200);
        }
        return mockResponse('', 404);
      });

      final app = await makeTestProviderScopeApp(
        tester,
        home: PuzzleScreen(
          angle: const PuzzleTheme(PuzzleThemeKey.mix),
          puzzleId: puzzle2.puzzle.id,
        ),
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith((ref) {
            return LichessClient(mockClient, ref);
          }),
          puzzleBatchStorageProvider: puzzleBatchStorageProvider.overrideWith(
            (ref) => mockBatchStorage,
          ),
          puzzleStorageProvider: puzzleStorageProvider.overrideWith((ref) => mockHistoryStorage),
          puzzlePreferencesProvider: puzzlePreferencesProvider.overrideWith(
            () => MockPuzzlePreferences(true),
          ),
        },
        authUser: fakeAuthUser,
      );

      Future<void> saveDBReq() => mockBatchStorage.save(
        userId: fakeAuthUser.user.id,
        angle: const PuzzleTheme(PuzzleThemeKey.mix),
        data: captureAny(named: 'data'),
      );
      when(saveDBReq).thenAnswer((_) async {});
      when(
        () => mockBatchStorage.fetch(
          userId: fakeAuthUser.user.id,
          angle: const PuzzleTheme(PuzzleThemeKey.mix),
        ),
      ).thenAnswer((_) async => batch);

      when(() => mockHistoryStorage.save(puzzle: any(named: 'puzzle'))).thenAnswer((_) async {});

      await tester.pumpWidget(app);

      // wait for the puzzle to load
      await tester.pump(const Duration(milliseconds: 200));

      // wait for first move to be played and hint/view solution buttons to appear
      await tester.pump(const Duration(seconds: 5));

      // check possible hint widgets before hint is set
      final customPaintWidgetsBefore = find.byType(CustomPaint).evaluate().toSet();

      // get hint and wait for it to show
      expect(find.byIcon(Icons.info), findsOneWidget);
      await tester.tap(find.byIcon(Icons.info));
      await tester.pump(const Duration(milliseconds: 100));

      // check hint is set
      final customPaintWidgetsAfter = find.byType(CustomPaint).evaluate();
      expect(customPaintWidgetsAfter.length, customPaintWidgetsBefore.length + 1);
      final diff = customPaintWidgetsAfter.toSet().difference(customPaintWidgetsBefore);
      expect(diff.length, 1);
      expect((diff.first.widget as CustomPaint).painter.runtimeType.toString(), '_CirclePainter');

      // view solution
      expect(find.byIcon(Icons.help), findsOneWidget);
      await tester.tap(find.byIcon(Icons.help));

      // wait for solution replay animation to finish
      await tester.pump(const Duration(seconds: 1));

      // go to next puzzle
      expect(find.byIcon(CupertinoIcons.play_arrow_solid), findsOneWidget);
      await tester.tap(find.byIcon(CupertinoIcons.play_arrow_solid));

      // wait for the puzzle to load
      await tester.pump(const Duration(milliseconds: 200));

      // wait for first move to be played and hint/view solution buttons to appear
      await tester.pump(const Duration(seconds: 5));

      // view solution
      expect(find.byIcon(Icons.help), findsOneWidget);
      await tester.tap(find.byIcon(Icons.help));

      // wait for solution replay animation to finish
      await tester.pump(const Duration(seconds: 1));

      // check first puzzle was unrated due to hint
      // and following puzzles are still rated when not using the hint
      final captured = verify(saveDBReq).captured.map((e) => e as PuzzleBatch).toList();
      expect(captured.length, 4);
      expect(captured[0].solved, [PuzzleSolution(id: puzzle2.puzzle.id, win: false, rated: false)]);
      expect(captured[1].solved.length, 0);
      expect(captured[2].solved, [PuzzleSolution(id: puzzle.puzzle.id, win: false, rated: true)]);
      expect(captured[3].solved.length, 0);
    });
  });

  testWidgets('Open as casual to not send the result', variant: kPlatformVariant, (
    WidgetTester tester,
  ) async {
    final mockClient = MockClient((request) {
      if (request.url.path == '/api/puzzle/batch/mix') {
        return mockResponse(emptyBatch, 200);
      }
      return mockResponse('', 404);
    });

    final app = await makeTestProviderScopeApp(
      tester,
      home: PuzzleScreen(
        angle: const PuzzleTheme(PuzzleThemeKey.mix),
        puzzleId: puzzle2.puzzle.id,
        openCasual: true,
      ),
      overrides: {
        lichessClientProvider: lichessClientProvider.overrideWith((ref) {
          return LichessClient(mockClient, ref);
        }),
        puzzleBatchStorageProvider: puzzleBatchStorageProvider.overrideWith(
          (ref) => mockBatchStorage,
        ),
        puzzleStorageProvider: puzzleStorageProvider.overrideWith((ref) => mockHistoryStorage),
      },
      authUser: fakeAuthUser,
    );

    Future<void> saveDBReq() => mockBatchStorage.save(
      userId: fakeAuthUser.user.id,
      angle: const PuzzleTheme(PuzzleThemeKey.mix),
      data: captureAny(named: 'data'),
    );
    when(saveDBReq).thenAnswer((_) async {});
    when(
      () => mockBatchStorage.fetch(
        userId: fakeAuthUser.user.id,
        angle: const PuzzleTheme(PuzzleThemeKey.mix),
      ),
    ).thenAnswer((_) async => batch);

    when(() => mockHistoryStorage.save(puzzle: any(named: 'puzzle'))).thenAnswer((_) async {});

    await tester.pumpWidget(app);

    // wait for the puzzle to load
    await tester.pump(const Duration(milliseconds: 200));

    // open settings
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    // see the disabled rating switch
    expect(find.widgetWithText(SwitchSettingTile, 'Rated'), findsOneWidget);
    expect(
      tester.widget<SwitchSettingTile>(find.widgetWithText(SwitchSettingTile, 'Rated')).value,
      isFalse,
    );
    // the switch is disabled
    expect(
      tester.widget<SwitchSettingTile>(find.widgetWithText(SwitchSettingTile, 'Rated')).onChanged,
      null,
    );

    // dismiss settings by tapping outside of the bottom sheet
    await tester.tapAt(const Offset(100, 100));

    // wait for first move to be played and view solution button to appear
    await tester.pump(const Duration(seconds: 5));

    // view solution
    expect(find.byIcon(Icons.help), findsOneWidget);
    await tester.tap(find.byIcon(Icons.help));

    // wait for solution replay animation to finish
    await tester.pump(const Duration(seconds: 1));

    // check puzzle was not added to the solved list
    final captured = verify(saveDBReq).captured.map((e) => e as PuzzleBatch).toList();
    expect(captured.length, 1);
    expect(captured[0].solved.length, 0);
  });

  testWidgets(
    'Regression test for false positive alternative castling notation (#2345)',
    variant: kPlatformVariant,
    (tester) async {
      final buggyPuzzle = Puzzle(
        puzzle: PuzzleData(
          id: const PuzzleId('G9zOq'),
          initialPly: 91,
          plays: 2380,
          rating: 1387,
          solution: IList(const [
            // There was a bug where e8a8 would be interpreted as alternative castling notation and thus normalized to e8c8,
            // fooling the logic into thinking it was the correct move.
            'e8c8', 'b6c7', 'c8c7', 'c6c7', 'b1b2',
          ]),
          themes: ISet(const ['advantage', 'long', 'middlegame']),
        ),
        game: const PuzzleGame(
          rated: true,
          id: GameId('5gVQo79W'),
          perf: Perf.rapid,
          pgn:
              'e4 c6 Nf3 d5 e5 Bg4 Be2 Nd7 d4 e6 Nc3 c5 b3 cxd4 Nxd4 Bxe2 Qxe2 Bb4 Bb2 Qc7 Nb5 Qc6 Nd6+ Bxd6 exd6 Qxd6 O-O-O Ngf6 g4 O-O-O Nb5 Qb6 Bd4 Qa5 Nxa7+ Kb8 a4 Ne4 Qe3 f6 f3 Nec5 g5 Qxa7 gxf6 gxf6 b4 b6 bxc5 bxc5 Ba1 Rhe8 Kd2 Qxa4 Rb1+ Kc7 Bb2 Qa5+ c3 Rb8 f4 Qa2 Kc2 Qa4+ Kd2 Qa2 Kc2 c4 Qc1 Qb3+ Kd2 Nc5 Ke2 Qb6 Ba3 Nb3 Qc2 Ra8 Qxh7+ Kc6 Bb2 Ra2 Qg6 Rd8 Qxf6 Rd6 Qf7 Nc5 Qe8+ Nd7 Kf3 Rxb2',
          black: PuzzleGamePlayer(side: Side.black, name: 'Kostas123451'),
          white: PuzzleGamePlayer(side: Side.white, name: 'ash44'),
        ),
      );

      final app = await makeTestProviderScopeApp(
        tester,
        home: PuzzleScreen(
          angle: const PuzzleTheme(PuzzleThemeKey.mix),
          puzzleId: buggyPuzzle.puzzle.id,
        ),
        overrides: {
          puzzleBatchStorageProvider: puzzleBatchStorageProvider.overrideWith(
            (ref) => mockBatchStorage,
          ),
          puzzleStorageProvider: puzzleStorageProvider.overrideWith((ref) => mockHistoryStorage),
        },
      );

      when(
        () => mockHistoryStorage.fetch(puzzleId: buggyPuzzle.puzzle.id),
      ).thenAnswer((_) async => buggyPuzzle);

      when(() => mockHistoryStorage.save(puzzle: any(named: 'puzzle'))).thenAnswer((_) async {});

      Future<void> saveDBReq() => mockBatchStorage.save(
        userId: null,
        angle: const PuzzleTheme(PuzzleThemeKey.mix),
        data: any(named: 'data'),
      );
      when(saveDBReq).thenAnswer((_) async {});
      when(
        () => mockBatchStorage.fetch(userId: null, angle: const PuzzleTheme(PuzzleThemeKey.mix)),
      ).thenAnswer((_) async => batch);

      await tester.pumpWidget(app);

      // wait for the puzzle to load
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(Chessboard), findsOneWidget);
      expect(find.text('Your turn'), findsOneWidget);

      // await for first move to be played
      await tester.pump(const Duration(milliseconds: 1500));

      expect(find.byKey(const Key('b2-blackrook')), findsOneWidget);

      await playMove(tester, 'e8', 'a8', orientation: Side.white);

      expect(find.text("That's not the move!"), findsOneWidget);

      // wait for move cancel and animation
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
    },
  );
}

const batchOf1 = '''
{"puzzles":[{"game":{"id":"PrlkCqOv","perf":{"key":"rapid","name":"Rapid"},"rated":true,"players":[{"name":"silverjo", "rating":1777,"color":"white"},{"name":"Robyarchitetto", "rating":1742,"color":"black"}],"pgn":"e4 Nc6 Bc4 e6 a3 g6 Nf3 Bg7 c3 Nge7 d3 O-O Be3 Na5 Ba2 b6 Qd2 Bb7 Bh6 d5 e5 d4 Bxg7 Kxg7 Qf4 Bxf3 Qxf3 dxc3 Nxc3 Nac6 Qf6+ Kg8 Rd1 Nd4 O-O c5 Ne4 Nef5 Rd2 Qxf6 Nxf6+ Kg7 Re1 h5 h3 Rad8 b4 Nh4 Re3 Nhf5 Re1 a5 bxc5 bxc5 Bc4 Ra8 Rb1 Nh4 Rdb2 Nc6 Rb7 Nxe5 Bxe6 Kxf6 Bd5 Nf5 R7b6+ Kg7 Bxa8 Rxa8 R6b3 Nd4 Rb7 Nxd3 Rd1 Ne2+ Kh2 Ndf4 Rdd7 Rf8 Ra7 c4 Rxa5 c3 Rc5 Ne6 Rc4 Ra8 a4 Rb8 a5 Rb2 a6 c2","clock":"5+8"},"puzzle":{"id":"20yWT","rating":1859,"plays":551,"initialPly":93,"solution":["a6a7","b2a2","c4c2","a2a7","d7a7"],"themes":["endgame","long","advantage","advancedPawn"]}}]}
''';

const emptyBatch = '''
{"puzzles":[]}
''';
