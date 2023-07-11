import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chessground/chessground.dart' as cg;
import 'package:http/testing.dart';

import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_repository.dart';
import 'package:lichess_mobile/src/view/puzzle/storm_screen.dart';
import 'package:lichess_mobile/src/http_client.dart';

import '../../test_utils.dart';
import '../../test_app.dart';

void main() {
  final mockClient = MockClient((request) {
    if (request.url.path == '/storm') {
      return mockResponse('', 200);
    }
    return mockResponse('', 404);
  });

  group('StormScreen', () {
    testWidgets(
      'meets accessibility guidelines',
      (tester) async {
        final SemanticsHandle handle = tester.ensureSemantics();

        final app = await buildTestApp(
          tester,
          home: const StormScreen(),
          overrides: [
            stormProvider.overrideWith((ref) => mockStromRun),
            httpClientProvider.overrideWithValue(mockClient),
          ],
        );

        await tester.pumpWidget(app);

        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        handle.dispose();
      },
      variant: kPlatformVariant,
    );

    testWidgets(
      'Load puzzle and play white pieces',
      (tester) async {
        final app = await buildTestApp(
          tester,
          home: const StormScreen(),
          overrides: [
            stormProvider.overrideWith((ref) => mockStromRun),
            httpClientProvider.overrideWithValue(mockClient),
          ],
        );

        await tester.pumpWidget(app);

        expect(find.byType(cg.Board), findsOneWidget);
        expect(
          find.text('You play the white pieces in all puzzles'),
          findsWidgets,
        );
      },
      variant: kPlatformVariant,
    );

    testWidgets(
      'Play one puzzle',
      (tester) async {
        final app = await buildTestApp(
          tester,
          home: const StormScreen(),
          overrides: [
            stormProvider.overrideWith((ref) => mockStromRun),
            httpClientProvider.overrideWithValue(mockClient),
          ],
        );

        await tester.pumpWidget(app);

        // wait for first move to be played
        await tester.pump(const Duration(seconds: 1));

        expect(find.byKey(const Key('g8-blackKing')), findsOneWidget);

        final boardRect = tester.getRect(find.byType(cg.Board));

        await playMove(
          tester,
          boardRect,
          'h5',
          'h7',
          orientation: cg.Side.white,
        );

        await tester.pump(const Duration(milliseconds: 500));
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('h7-whiteRook')), findsOneWidget);
        expect(find.byKey(const Key('d1-blackQueen')), findsOneWidget);

        await playMove(
          tester,
          boardRect,
          'e3',
          'g1',
          orientation: cg.Side.white,
        );

        await tester.pump(const Duration(milliseconds: 500));
        // should have loaded next puzzle
        expect(find.byKey(const Key('h6-blackKing')), findsOneWidget);
      },
      variant: kPlatformVariant,
    );

    testWidgets('shows end run result', (tester) async {
      final app = await buildTestApp(
        tester,
        home: const StormScreen(),
        overrides: [
          stormProvider.overrideWith((ref) => mockStromRun),
          httpClientProvider.overrideWithValue(mockClient),
        ],
      );

      await tester.pumpWidget(app);

      // wait for first move to be played
      await tester.pump(const Duration(seconds: 1));

      final boardRect = tester.getRect(find.byType(cg.Board));

      await playMove(
        tester,
        boardRect,
        'h5',
        'h7',
        orientation: cg.Side.white,
      );

      await tester.pump(const Duration(milliseconds: 500));
      await playMove(
        tester,
        boardRect,
        'e3',
        'g1',
        orientation: cg.Side.white,
      );

      await tester.pump(const Duration(milliseconds: 500));
      // should have loaded next puzzle
      expect(find.byKey(const Key('h6-blackKing')), findsOneWidget);

      await tester.tap(find.text('End run'));
      await tester.pumpAndSettle();

      expect(find.text('1 puzzles solved'), findsOneWidget);
    });

    testWidgets('play wrong move', (tester) async {
      final app = await buildTestApp(
        tester,
        home: const StormScreen(),
        overrides: [
          stormProvider.overrideWith((ref) => mockStromRun),
          httpClientProvider.overrideWithValue(mockClient),
        ],
      );

      await tester.pumpWidget(app);

      await tester.pump(const Duration(seconds: 1));
      final boardRect = tester.getRect(find.byType(cg.Board));

      await playMove(tester, boardRect, 'h5', 'h6');

      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byKey(const Key('h6-blackKing')), findsOneWidget);
    });
  });
}

final mockStromRun = PuzzleStormResponse(
  puzzles: IList([
    LitePuzzle(
      id: const PuzzleId('5ech9'),
      fen: 'r6k/ppp2p1p/3q1pr1/4p2R/7Q/4B3/PPP3PP/7K b - - 2 28',
      solution: IList(const ['h8g8', 'h5h7', 'd6d1', 'e3g1']),
      rating: 900,
    ),
    LitePuzzle(
      id: const PuzzleId('H73YL'),
      fen: '8/1R4pp/7k/2rppB2/b5PP/8/5P2/6K1 b - - 0 34',
      solution: IList(const ['g7g6', 'g4g5', 'h6h5', 'b7h7']),
      rating: 920,
    ),
    LitePuzzle(
      id: const PuzzleId('qADto'),
      fen: 'r1b3k1/ppq2pp1/1n1p1n1p/3p4/3P4/2PBR3/PP1Q1PPP/4R1K1 b - - 5 15',
      solution: IList(const ['b6c4', 'e3e8', 'f6e8', 'e1e8']),
      rating: 920,
    ),
  ]),
  key: null,
  highscore: null,
);
