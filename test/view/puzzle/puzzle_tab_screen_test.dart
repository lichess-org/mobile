import 'dart:convert';

import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
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
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_tab_screen.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

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
      overrides: [puzzleBatchStorageProvider.overrideWith((ref) => mockBatchStorage)],
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
      overrides: [
        puzzleBatchStorageProvider.overrideWith((ref) => mockBatchStorage),
        httpClientFactoryProvider.overrideWith((ref) {
          return FakeHttpClientFactory(() => mockClient);
        }),
      ],
    );

    await tester.pumpWidget(app);

    // wait for connectivity and storage
    await tester.pumpAndSettle(const Duration(milliseconds: 100));

    expect(find.text('Puzzle Themes'), findsOneWidget);
    expect(find.text('Puzzle Streak'), findsOneWidget);
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
      overrides: [
        puzzleBatchStorageProvider.overrideWith((ref) => mockBatchStorage),
        httpClientFactoryProvider.overrideWith((ref) {
          return FakeHttpClientFactory(() => mockClient);
        }),
      ],
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
        overrides: [
          puzzleBatchStorageProvider.overrideWith((ref) => mockBatchStorage),
          httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => mockClient);
          }),
        ],
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
        overrides: [
          puzzleBatchStorageProvider.overrideWith((ref) => mockBatchStorage),
          httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => mockClient);
          }),
        ],
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
        overrides: [
          httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => mockClient);
          }),
          databaseProvider.overrideWith((ref) {
            ref.onDispose(testDb.close);
            return testDb;
          }),
        ],
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
}

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
