import 'dart:math';

import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/widgets/game_layout.dart';

import '../test_helpers.dart';
import '../test_provider_scope.dart';

void main() {
  testWidgets('board background size should match board size on all surfaces', (
    WidgetTester tester,
  ) async {
    for (final surface in kTestSurfaces) {
      final app = await makeTestProviderScope(
        key: ValueKey(surface),
        tester,
        child: const MaterialApp(
          home: GameLayout(
            orientation: Side.white,
            fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR',
            topTable: Row(
              mainAxisSize: MainAxisSize.max,
              key: ValueKey('top_table'),
              children: [Text('Top table')],
            ),
            bottomTable: Row(
              mainAxisSize: MainAxisSize.max,
              key: ValueKey('bottom_table'),
              children: [Text('Bottom table')],
            ),
          ),
        ),
        surfaceSize: surface,
      );
      await tester.pumpWidget(app);

      final backgroundSize = tester.getSize(find.byType(SolidColorChessboardBackground));

      expect(
        backgroundSize.width,
        backgroundSize.height,
        reason: 'Board background size is square on $surface',
      );

      final boardSize = tester.getSize(find.byType(Chessboard));

      expect(boardSize.width, boardSize.height, reason: 'Board size is square on $surface');

      expect(
        boardSize,
        backgroundSize,
        reason: 'Board size should match background size on $surface',
      );
    }
  }, variant: kPlatformVariant);

  testWidgets('board size and table side size should be harmonious on all surfaces', (
    WidgetTester tester,
  ) async {
    for (final surface in kTestSurfaces) {
      final app = await makeTestProviderScope(
        key: ValueKey(surface),
        tester,
        child: const MaterialApp(
          home: GameLayout(
            orientation: Side.white,
            fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR',
            topTable: Row(
              mainAxisSize: MainAxisSize.max,
              key: ValueKey('top_table'),
              children: [Text('Top table')],
            ),
            bottomTable: Row(
              mainAxisSize: MainAxisSize.max,
              key: ValueKey('bottom_table'),
              children: [Text('Bottom table')],
            ),
          ),
        ),
        surfaceSize: surface,
      );
      await tester.pumpWidget(app);

      final isPortrait = surface.aspectRatio < 1.0;
      final isTablet = surface.shortestSide > 600;
      final boardSize = tester.getSize(find.byType(Chessboard));

      if (isPortrait) {
        final expectedBoardSize = isTablet ? surface.width - 32.0 : surface.width;
        expect(
          boardSize,
          Size(expectedBoardSize, expectedBoardSize),
          reason: 'Board size should match surface width on $surface',
        );
      } else {
        final topTableSize = tester.getSize(find.byKey(const ValueKey('top_table')));
        final bottomTableSize = tester.getSize(find.byKey(const ValueKey('bottom_table')));
        final goldenBoardSize = (surface.longestSide / kGoldenRatio) - 32.0;
        final defaultBoardSize = surface.shortestSide - 32.0;
        final minBoardSize = min(goldenBoardSize, defaultBoardSize);
        final maxBoardSize = max(goldenBoardSize, defaultBoardSize);
        final minSideWidth = min(surface.longestSide - goldenBoardSize - 16.0 * 3, 250.0);
        expect(
          boardSize.width,
          greaterThanOrEqualTo(minBoardSize),
          reason: 'Board size should be at least $minBoardSize on $surface',
        );
        expect(
          boardSize.width,
          lessThanOrEqualTo(maxBoardSize),
          reason: 'Board size should be at most $maxBoardSize on $surface',
        );
        expect(
          bottomTableSize.width,
          greaterThanOrEqualTo(minSideWidth),
          reason: 'Bottom table width should be at least $minSideWidth on $surface',
        );
        expect(
          topTableSize.width,
          greaterThanOrEqualTo(minSideWidth),
          reason: 'Top table width should be at least $minSideWidth on $surface',
        );
      }
    }
  }, variant: kPlatformVariant);
}
