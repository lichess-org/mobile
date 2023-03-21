import 'package:flutter/material.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:chessground/chessground.dart' as cg;
import 'package:mocktail/mocktail.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_batch_storage.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/ui/puzzle/puzzle_screen.dart';
import '../../test_app.dart';
import '../../test_utils.dart';

class MockPuzzleBatchStorage extends Mock implements PuzzleBatchStorage {}

void main() {
  final mockBatchStorage = MockPuzzleBatchStorage();

  group('PuzzleScreen', () {
    testWidgets(
      'meets accessibility guidelines',
      (WidgetTester tester) async {
        final SemanticsHandle handle = tester.ensureSemantics();

        final app = await buildTestApp(
          tester,
          home: PuzzleScreen(
            theme: PuzzleTheme.mix,
            initialPuzzleContext: PuzzleContext(
              puzzle: puzzle,
              theme: PuzzleTheme.mix,
              userId: null,
            ),
          ),
        );

        await tester.pumpWidget(app);

        await meetsTapTargetGuideline(tester);

        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        handle.dispose();
      },
      variant: kPlatformVariant,
    );

    testWidgets(
      'Loads puzzle directly by passing PuzzleContext',
      (tester) async {
        final app = await buildTestApp(
          tester,
          home: PuzzleScreen(
            theme: PuzzleTheme.mix,
            initialPuzzleContext: PuzzleContext(
              puzzle: puzzle,
              theme: PuzzleTheme.mix,
              userId: null,
            ),
          ),
        );

        await tester.pumpWidget(app);

        expect(find.byType(cg.Board), findsOneWidget);
        expect(find.widgetWithText(ListTile, 'Your turn'), findsOneWidget);
      },
      variant: kPlatformVariant,
    );

    testWidgets('Loads next puzzle when no initialPuzzleContext is passed',
        (tester) async {
      final app = await buildTestApp(
        tester,
        home: const PuzzleScreen(
          theme: PuzzleTheme.mix,
        ),
        overrides: [
          puzzleBatchStorageProvider.overrideWith((ref) {
            return mockBatchStorage;
          }),
        ],
      );

      when(() => mockBatchStorage.fetch(userId: null, angle: PuzzleTheme.mix))
          .thenAnswer((_) async => batch);

      await tester.pumpWidget(app);

      expect(find.byType(cg.Board), findsNothing);
      expect(find.widgetWithText(ListTile, 'Your turn'), findsNothing);

      // wait for the puzzle to load
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(cg.Board), findsOneWidget);
      expect(find.widgetWithText(ListTile, 'Your turn'), findsOneWidget);
    });
  });
}

final puzzle = Puzzle(
  puzzle: PuzzleData(
    id: const PuzzleId('6Sz3s'),
    initialPly: 40,
    plays: 68176,
    rating: 1984,
    solution: IList(const [
      'h4h2',
      'h1h2',
      'e5f3',
      'h2h3',
      'b4h4',
    ]),
    themes: ISet(const [
      'middlegame',
      'attraction',
      'long',
      'mateIn3',
      'sacrifice',
      'doubleCheck',
    ]),
  ),
  game: const PuzzleGame(
    rated: true,
    id: GameId('zgBwsXLr'),
    perf: Perf.blitz,
    pgn:
        'e4 c5 Nf3 e6 c4 Nc6 d4 cxd4 Nxd4 Bc5 Nxc6 bxc6 Be2 Ne7 O-O Ng6 Nc3 Rb8 Kh1 Bb7 f4 d5 f5 Ne5 fxe6 fxe6 cxd5 cxd5 exd5 Bxd5 Qa4+ Bc6 Qf4 Bd6 Ne4 Bxe4 Qxe4 Rb4 Qe3 Qh4 Qxa7',
    black: PuzzleGamePlayer(
      side: Side.black,
      name: 'CAMBIADOR (2148)',
      userId: UserId('cambiador'),
    ),
    white: PuzzleGamePlayer(
      side: Side.white,
      name: 'arroyoM10 (2017)',
      userId: UserId('arroyom10'),
    ),
  ),
);

final batch = PuzzleBatch(
  solved: IList(const []),
  unsolved: IList([
    puzzle,
  ]),
);
