import 'package:chessground/chessground.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_batch_storage.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_tab_screen.dart';
import 'package:mocktail/mocktail.dart';

import '../../model/puzzle/mock_server_responses.dart';
import '../../network/fake_http_client_factory.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';
import 'example_data.dart';

final mockClient = MockClient((request) async {
  if (request.url.path == '/api/puzzle/daily') {
    return mockResponse(mockDailyPuzzleResponse, 200);
  }
  return mockResponse('', 404);
});

class MockPuzzleBatchStorage extends Mock implements PuzzleBatchStorage {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      PuzzleBatch(
        solved: IList(const []),
        unsolved: IList([puzzle]),
      ),
    );
  });

  final mockBatchStorage = MockPuzzleBatchStorage();

  testWidgets('meets accessibility guidelines', (WidgetTester tester) async {
    final SemanticsHandle handle = tester.ensureSemantics();

    when(
      () => mockBatchStorage.fetch(
        userId: null,
        angle: const PuzzleTheme(PuzzleThemeKey.mix),
      ),
    ).thenAnswer((_) async => batch);

    when(
      () => mockBatchStorage.fetchSavedThemes(
        userId: null,
      ),
    ).thenAnswer((_) async => const IMapConst<PuzzleThemeKey, int>({}));
    when(
      () => mockBatchStorage.fetchSavedOpenings(
        userId: null,
      ),
    ).thenAnswer((_) async => const IMapConst<String, int>({}));

    final app = await makeTestProviderScopeApp(
      tester,
      home: const PuzzleTabScreen(),
      overrides: [
        puzzleBatchStorageProvider.overrideWith((ref) => mockBatchStorage),
      ],
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
      () => mockBatchStorage.fetch(
        userId: null,
        angle: const PuzzleTheme(PuzzleThemeKey.mix),
      ),
    ).thenAnswer((_) async => batch);
    when(
      () => mockBatchStorage.fetchSavedThemes(
        userId: null,
      ),
    ).thenAnswer((_) async => const IMapConst<PuzzleThemeKey, int>({}));
    when(
      () => mockBatchStorage.fetchSavedOpenings(
        userId: null,
      ),
    ).thenAnswer((_) async => const IMapConst<String, int>({}));
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
      () => mockBatchStorage.fetch(
        userId: null,
        angle: const PuzzleTheme(PuzzleThemeKey.mix),
      ),
    ).thenAnswer((_) async => batch);
    when(
      () => mockBatchStorage.fetchSavedThemes(
        userId: null,
      ),
    ).thenAnswer((_) async => const IMapConst<PuzzleThemeKey, int>({}));
    when(
      () => mockBatchStorage.fetchSavedOpenings(
        userId: null,
      ),
    ).thenAnswer((_) async => const IMapConst<String, int>({}));

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
    expect(
      find.widgetWithText(DailyPuzzle, 'Puzzle of the day'),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(DailyPuzzle, 'Played 93,270 times'),
      findsOneWidget,
    );
    expect(find.widgetWithText(DailyPuzzle, 'Black to play'), findsOneWidget);
  });

  group('tactical training preview', () {
    testWidgets('shows first puzzle from unsolved batch',
        (WidgetTester tester) async {
      when(
        () => mockBatchStorage.fetch(
          userId: null,
          angle: const PuzzleTheme(PuzzleThemeKey.mix),
        ),
      ).thenAnswer((_) async => batch);
      when(
        () => mockBatchStorage.fetchSavedThemes(
          userId: null,
        ),
      ).thenAnswer((_) async => const IMapConst<PuzzleThemeKey, int>({}));
      when(
        () => mockBatchStorage.fetchSavedOpenings(
          userId: null,
        ),
      ).thenAnswer((_) async => const IMapConst<String, int>({}));

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
      expect(
        find.widgetWithText(PuzzleAnglePreview, 'Healthy mix'),
        findsOneWidget,
      );
      final chessboard = find
          .descendant(
            of: find.byType(PuzzleAnglePreview),
            matching: find.byType(Chessboard),
          )
          .evaluate()
          .first
          .widget as Chessboard;

      expect(
        chessboard.fen,
        equals('4k2r/Q5pp/3bp3/4n3/1r5q/8/PP2B1PP/R1B2R1K b k - 0 21'),
      );
    });

    testWidgets('shows saved puzzle theme batches',
        (WidgetTester tester) async {
      when(
        () => mockBatchStorage.fetch(
          userId: null,
          angle: const PuzzleTheme(PuzzleThemeKey.mix),
        ),
      ).thenAnswer((_) async => batch);
      when(
        () => mockBatchStorage.fetch(
          userId: null,
          angle: const PuzzleTheme(PuzzleThemeKey.advancedPawn),
        ),
      ).thenAnswer((_) async => batch);
      when(
        () => mockBatchStorage.fetchSavedThemes(
          userId: null,
        ),
      ).thenAnswer(
        (_) async => const IMapConst<PuzzleThemeKey, int>({
          PuzzleThemeKey.advancedPawn: 50,
        }),
      );
      when(
        () => mockBatchStorage.fetchSavedOpenings(
          userId: null,
        ),
      ).thenAnswer((_) async => const IMapConst<String, int>({}));

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

      expect(find.byType(PuzzleAnglePreview), findsNWidgets(2));
      expect(
        find.widgetWithText(PuzzleAnglePreview, 'Healthy mix'),
        findsOneWidget,
      );

      expect(
        find.widgetWithText(PuzzleAnglePreview, 'Advanced pawn'),
        findsOneWidget,
      );
    });

    testWidgets('shows saved puzzle openings batches',
        (WidgetTester tester) async {
      when(
        () => mockBatchStorage.fetch(
          userId: null,
          angle: const PuzzleTheme(PuzzleThemeKey.mix),
        ),
      ).thenAnswer((_) async => batch);
      when(
        () => mockBatchStorage.fetch(
          userId: null,
          angle: const PuzzleOpening('A00'),
        ),
      ).thenAnswer((_) async => batch);
      when(
        () => mockBatchStorage.fetchSavedThemes(
          userId: null,
        ),
      ).thenAnswer(
        (_) async => const IMapConst<PuzzleThemeKey, int>({}),
      );
      when(
        () => mockBatchStorage.fetchSavedOpenings(
          userId: null,
        ),
      ).thenAnswer(
        (_) async => const IMapConst<String, int>({
          'A00': 50,
        }),
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

      expect(find.byType(PuzzleAnglePreview), findsNWidgets(2));
      expect(
        find.widgetWithText(PuzzleAnglePreview, 'Healthy mix'),
        findsOneWidget,
      );

      expect(
        find.widgetWithText(PuzzleAnglePreview, 'A00'),
        findsOneWidget,
      );
    });
  });
}
