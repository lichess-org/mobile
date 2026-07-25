import 'dart:convert';
import 'dart:math' show max;

import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_batch_storage.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/model/puzzle/streak_storage.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_screen.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_tab_screen.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../model/auth/fake_auth_storage.dart';
import '../../model/puzzle/mock_server_responses.dart';
import '../../network/fake_http_client_factory.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';
import 'example_data.dart';

final mockClient = MockClient((request) {
  if (request.url.path == '/api/puzzle/daily') {
    return mockResponse(mockDailyPuzzleResponse, 200);
  }
  return mockResponse('', 404);
});

class MockPuzzleBatchStorage extends Mock implements PuzzleBatchStorage {}

void main() {
  setUpAll(() {
    registerFallbackValue(PuzzleBatch(solved: IList(const []), unsolved: IList([puzzle])));
  });

  final mockBatchStorage = MockPuzzleBatchStorage();

  testWidgets('meets accessibility guidelines', (WidgetTester tester) async {
    final SemanticsHandle handle = tester.ensureSemantics();

    when(
      () => mockBatchStorage.fetch(userId: null, angle: const PuzzleTheme(PuzzleThemeKey.mix)),
    ).thenAnswer((_) async => batch);
    when(() => mockBatchStorage.fetchAll(userId: null)).thenAnswer((_) async => IList(const []));

    final app = await makeTestProviderScopeApp(
      tester,
      home: const PuzzleTabScreen(),
      overrides: {
        puzzleBatchStorageProvider: puzzleBatchStorageProvider.overrideWith(
          (ref) => mockBatchStorage,
        ),
      },
    );

    await tester.pumpWidget(app);

    // wait for connectivity and storage
    await tester.pump(const Duration(milliseconds: 100));

    // wait for the puzzles to load
    await tester.pump(const Duration(milliseconds: 100));

    await meetsTapTargetGuideline(tester);

    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

    await expectLater(tester, meetsGuideline(textContrastGuideline));

    handle.dispose();
  });

  testWidgets('shows puzzle menu', (WidgetTester tester) async {
    when(
      () => mockBatchStorage.fetch(userId: null, angle: const PuzzleTheme(PuzzleThemeKey.mix)),
    ).thenAnswer((_) async => batch);
    when(() => mockBatchStorage.fetchAll(userId: null)).thenAnswer((_) async => IList(const []));
    final app = await makeTestProviderScopeApp(
      tester,
      home: const PuzzleTabScreen(),
      overrides: {
        puzzleBatchStorageProvider: puzzleBatchStorageProvider.overrideWith(
          (ref) => mockBatchStorage,
        ),
        httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
          return FakeHttpClientFactory(() => mockClient);
        }),
        savedStreakScoreProvider: savedStreakScoreProvider.overrideWith((ref) => 123),
      },
    );

    await tester.pumpWidget(app);

    // wait for connectivity and storage
    await tester.pumpAndSettle(const Duration(milliseconds: 100));

    expect(find.text('Puzzle Themes'), findsOneWidget);
    expect(find.text('Puzzle Streak'), findsOneWidget);
    expect(find.text('123'), findsOneWidget); // saved streak score
    expect(find.text('Puzzle Storm'), findsOneWidget);
  });

  testWidgets('shows daily puzzle', (WidgetTester tester) async {
    when(
      () => mockBatchStorage.fetch(userId: null, angle: const PuzzleTheme(PuzzleThemeKey.mix)),
    ).thenAnswer((_) async => batch);
    when(() => mockBatchStorage.fetchAll(userId: null)).thenAnswer((_) async => IList(const []));
    final app = await makeTestProviderScopeApp(
      tester,
      home: const PuzzleTabScreen(),
      overrides: {
        puzzleBatchStorageProvider: puzzleBatchStorageProvider.overrideWith(
          (ref) => mockBatchStorage,
        ),
        httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
          return FakeHttpClientFactory(() => mockClient);
        }),
      },
    );

    await tester.pumpWidget(app);

    // wait for connectivity and storage
    await tester.pump(const Duration(milliseconds: 100));

    // wait for the puzzles to load
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(DailyPuzzle), findsOneWidget);
    expect(find.widgetWithText(DailyPuzzle, 'Puzzle of the day'), findsOneWidget);
    expect(find.widgetWithText(DailyPuzzle, 'Played 93,270 times'), findsOneWidget);
    expect(find.widgetWithText(DailyPuzzle, 'Black to play'), findsOneWidget);
  });

  group('tactical training preview', () {
    testWidgets('shows first puzzle from unsolved batch', (WidgetTester tester) async {
      when(
        () => mockBatchStorage.fetch(userId: null, angle: const PuzzleTheme(PuzzleThemeKey.mix)),
      ).thenAnswer((_) async => batch);
      when(() => mockBatchStorage.fetchAll(userId: null)).thenAnswer((_) async => IList(const []));

      final app = await makeTestProviderScopeApp(
        tester,
        home: const PuzzleTabScreen(),
        overrides: {
          puzzleBatchStorageProvider: puzzleBatchStorageProvider.overrideWith(
            (ref) => mockBatchStorage,
          ),
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => mockClient);
          }),
        },
      );

      await tester.pumpWidget(app);

      // wait for connectivity and storage
      await tester.pump(const Duration(milliseconds: 100));

      // wait for the puzzle to load
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(PuzzleAnglePreview), findsOneWidget);
      expect(find.widgetWithText(PuzzleAnglePreview, 'Healthy mix'), findsOneWidget);
      final chessboard =
          find
                  .descendant(
                    of: find.byType(PuzzleAnglePreview),
                    matching: find.byType(StaticChessboard),
                  )
                  .evaluate()
                  .first
                  .widget
              as StaticChessboard;

      expect(chessboard.fen, equals('4k2r/Q5pp/3bp3/4n3/1r5q/8/PP2B1PP/R1B2R1K b k - 0 21'));
    });

    testWidgets('shows saved puzzle batches', (WidgetTester tester) async {
      when(
        () => mockBatchStorage.fetch(userId: null, angle: const PuzzleTheme(PuzzleThemeKey.mix)),
      ).thenAnswer((_) async => batch);
      when(
        () => mockBatchStorage.fetch(
          userId: null,
          angle: const PuzzleTheme(PuzzleThemeKey.advancedPawn),
        ),
      ).thenAnswer((_) async => batch);
      when(
        () => mockBatchStorage.fetch(userId: null, angle: const PuzzleOpening('A00')),
      ).thenAnswer((_) async => batch);
      when(() => mockBatchStorage.fetchAll(userId: null)).thenAnswer(
        (_) async => IList(const [
          (PuzzleTheme(PuzzleThemeKey.advancedPawn), 50),
          (PuzzleOpening('A00'), 50),
        ]),
      );

      final app = await makeTestProviderScopeApp(
        tester,
        home: const PuzzleTabScreen(),
        overrides: {
          puzzleBatchStorageProvider: puzzleBatchStorageProvider.overrideWith(
            (ref) => mockBatchStorage,
          ),
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => mockClient);
          }),
        },
      );

      await tester.pumpWidget(app);

      // wait for connectivity and storage
      await tester.pump(const Duration(milliseconds: 100));

      // wait for the puzzles to load
      await tester.pump(const Duration(milliseconds: 100));

      await tester.scrollUntilVisible(find.widgetWithText(PuzzleAnglePreview, 'A00'), 200);
      expect(find.byType(PuzzleAnglePreview), findsNWidgets(3));
      expect(find.widgetWithText(PuzzleAnglePreview, 'Healthy mix'), findsOneWidget);
      expect(find.widgetWithText(PuzzleAnglePreview, 'Advanced pawn'), findsOneWidget);
      expect(find.widgetWithText(PuzzleAnglePreview, 'A00'), findsOneWidget);
    });

    testWidgets('delete a saved puzzle batch', (WidgetTester tester) async {
      final testDb = await openAppDatabase(databaseFactoryFfiNoIsolate, inMemoryDatabasePath);

      for (final (angle, timestamp) in [
        (const PuzzleTheme(PuzzleThemeKey.mix), '2021-01-01T00:00:00Z'),
        (const PuzzleTheme(PuzzleThemeKey.advancedPawn), '2021-01-01T00:00:00Z'),
        (const PuzzleOpening('A00'), '2021-01-02T00:00:00Z'),
      ]) {
        await testDb.insert('puzzle_batchs', {
          'userId': '**anon**',
          'angle': angle.key,
          'data': jsonEncode(onePuzzleBatch.toJson()),
          'lastModified': timestamp,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }

      final app = await makeTestProviderScopeApp(
        tester,
        home: const PuzzleTabScreen(),
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => mockClient);
          }),
          databaseProvider: databaseProvider.overrideWith((ref) {
            ref.onDispose(testDb.close);
            return testDb;
          }),
        },
      );

      await tester.pumpWidget(app);

      // wait for connectivity and storage
      await tester.pump(const Duration(milliseconds: 100));

      // wait for the puzzles to load
      await tester.pump(const Duration(milliseconds: 100));

      await tester.scrollUntilVisible(
        find.widgetWithText(PuzzleAnglePreview, 'Advanced pawn'),
        200,
      );

      expect(find.byType(PuzzleAnglePreview), findsNWidgets(3));

      await tester.drag(
        find.descendant(
          of: find.widgetWithText(PuzzleAnglePreview, 'A00'),
          matching: find.byType(Slidable),
        ),
        const Offset(-150, 0),
      );
      await tester.pumpAndSettle();

      expect(find.widgetWithText(SlidableAction, 'Delete'), findsOneWidget);

      await tester.tap(find.widgetWithText(SlidableAction, 'Delete'));

      await tester.pumpAndSettle();

      expect(find.widgetWithText(PuzzleAnglePreview, 'A00'), findsNothing);
    });
  });

  testWidgets('changing the offline puzzles setting does not start a concurrent queue sync', (
    WidgetTester tester,
  ) async {
    // Regression test: the puzzle tab stays mounted under the pushed
    // [PuzzleScreen] and keeps watching [nextPuzzleProvider]. If that provider
    // watched the offline queue length, changing the setting would rebuild it
    // and run a queue sync — a writer that saves a batch built from a snapshot
    // taken before its own request, without merging — at the very moment
    // [PuzzleQueueFiller] starts filling the queue up to the new length. The
    // two overwrite each other: puzzles are downloaded and thrown away, and
    // depending on the interleaving the fill stops early on its "the queue did
    // not grow" check, below the configured count. The fill must be the only
    // writer.
    int nbBatchReq = 0;
    int inFlight = 0;
    int maxInFlight = 0;
    int nextPuzzleNumber = 0;

    final client = MockClient((request) async {
      if (request.url.path == '/api/puzzle/daily') {
        return mockResponse(mockDailyPuzzleResponse, 200);
      }
      if (request.url.path == '/api/puzzle/batch/mix') {
        // the rating probe made on puzzle controller build asks for nb=0
        if (request.url.queryParameters['nb'] == '0') {
          return mockResponse('{"puzzles":[]}', 200);
        }
        nbBatchReq++;
        inFlight++;
        maxInFlight = max(maxInFlight, inFlight);
        // keep the request in flight long enough for an overlapping sync to
        // start before the response is stored
        await Future<void>.delayed(const Duration(milliseconds: 20));
        inFlight--;
        // the server caps each batch at 50 puzzles, whatever `nb` asks for
        return mockResponse(_batchResponse(50, () => nextPuzzleNumber++), 200);
      }
      return mockResponse('', 404);
    });

    final testDb = await openAppDatabase(databaseFactoryFfiNoIsolate, inMemoryDatabasePath);

    final app = await makeTestProviderScopeApp(
      tester,
      home: const PuzzleTabScreen(),
      overrides: {
        databaseProvider: databaseProvider.overrideWith((ref) {
          ref.onDispose(testDb.close);
          return testDb;
        }),
        httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
          return FakeHttpClientFactory(() => client);
        }),
      },
      // the offline puzzles setting is a logged-in-only feature
      authUser: fakeAuthUser,
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle(const Duration(milliseconds: 100));

    // the tab preview synced the queue once, up to the server cap
    expect(nbBatchReq, equals(1));

    final container = ProviderScope.containerOf(tester.element(find.byType(PuzzleTabScreen)));
    Future<int> queueLength() async {
      final storage = await container.read(puzzleBatchStorageProvider.future);
      final data = await storage.fetch(userId: fakeAuthUser.user.id);
      return data?.unsolved.length ?? 0;
    }

    expect(await queueLength(), equals(50));

    // open the puzzle screen from the tab: the tab screen stays mounted below it
    await tester.ensureVisible(find.widgetWithText(PuzzleAnglePreview, 'Healthy mix'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(PuzzleAnglePreview, 'Healthy mix'));
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    expect(find.byType(PuzzleScreen), findsOneWidget);

    // open the puzzle settings and raise the offline puzzles count
    await tester.tap(
      find.descendant(of: find.byType(PuzzleScreen), matching: find.byIcon(Icons.settings)),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(SettingsListTile, 'Offline puzzles'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('200').last);
    await tester.pumpAndSettle(const Duration(milliseconds: 100));

    expect(
      maxInFlight,
      equals(1),
      reason: 'the queue fill must be the only writer: no sync may run alongside it',
    );
    // the fill reached the newly configured count: 50 -> 200 in three batches,
    // and nothing overwrote what it stored on the way.
    expect(await queueLength(), equals(200));
    expect(nbBatchReq, equals(4), reason: 'the initial sync, then three fill batches');
  });
}

/// Builds a batch response of [count] puzzles with distinct ids.
String _batchResponse(int count, int Function() nextPuzzleNumber) => jsonEncode({
  'puzzles': [
    for (int i = 0; i < count; i++)
      {
        'game': {
          'id': 'PrlkCqOv',
          'perf': const {'key': 'rapid', 'name': 'Rapid'},
          'rated': true,
          'players': const [
            {'userId': 'silverjo', 'name': 'silverjo (1777)', 'color': 'white'},
            {'userId': 'robyarchitetto', 'name': 'Robyarchitetto (1742)', 'color': 'black'},
          ],
          'pgn': 'e4 Nc6 Bc4 e6 a3 g6 Nf3 Bg7 c3 Nge7 d3 O-O Be3 Na5 Ba2 b6 Qd2',
          'clock': '5+8',
        },
        'puzzle': {
          'id': 'p${nextPuzzleNumber()}',
          'rating': 1859,
          'plays': 551,
          'initialPly': 10,
          'solution': const ['a6a7', 'b2a2'],
          'themes': const ['endgame'],
        },
      },
  ],
});

final onePuzzleBatch = PuzzleBatch(
  solved: IList(const [
    PuzzleSolution(id: PuzzleId('pId'), win: true, rated: true),
    PuzzleSolution(id: PuzzleId('pId2'), win: false, rated: true),
  ]),
  unsolved: IList([
    Puzzle(
      puzzle: PuzzleData(
        id: const PuzzleId('pId3'),
        rating: 1988,
        plays: 5,
        initialPly: 23,
        solution: IList(const ['a6a7', 'b2a2', 'c4c2']),
        themes: ISet(const ['endgame', 'advantage']),
      ),
      game: const PuzzleGame(
        id: GameId('PrlkCqOv'),
        perf: Perf.blitz,
        rated: true,
        white: PuzzleGamePlayer(side: Side.white, name: 'user1'),
        black: PuzzleGamePlayer(side: Side.black, name: 'user2'),
        pgn: 'e4 Nc6 Bc4 e6 a3 g6 Nf3 Bg7 c3 Nge7 d3 O-O Be3 Na5 Ba2 b6 Qd2',
      ),
    ),
  ]),
);
