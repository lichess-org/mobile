import 'dart:math';

import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/widgets/board_table.dart';

import '../test_helpers.dart';
import '../test_provider_scope.dart';

const surfaces = [
  // https://www.browserstack.com/guide/common-screen-resolutions
  // phones
  Size(360, 800),
  Size(390, 844),
  Size(393, 873),
  Size(412, 915),
  Size(414, 896),
  Size(360, 780),
  // tablets
  Size(600, 1024),
  Size(810, 1080),
  Size(820, 1180),
  Size(1280, 800),
  Size(800, 1280),
  Size(601, 962),
  // folded motorola
  Size(564.7, 482.6),
  // pixel fold unfolded
  Size(701.0, 841.1),
  Size(841.1, 701.0),
];

void main() {
  testWidgets(
    'board background size should match board size on all surfaces',
    (WidgetTester tester) async {
      for (final surface in surfaces) {
        final app = await makeTestProviderScope(
          key: ValueKey(surface),
          tester,
          child: const MaterialApp(
            home: BoardTable(
              orientation: Side.white,
              fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR',
              topTable: Row(
                mainAxisSize: MainAxisSize.max,
                key: ValueKey('top_table'),
                children: [
                  Text('Top table'),
                ],
              ),
              bottomTable: Row(
                mainAxisSize: MainAxisSize.max,
                key: ValueKey('bottom_table'),
                children: [
                  Text('Bottom table'),
                ],
              ),
            ),
          ),
          surfaceSize: surface,
        );
        await tester.pumpWidget(app);

        final backgroundSize = tester.getSize(
          find.byType(SolidColorChessboardBackground),
        );

        expect(
          backgroundSize.width,
          backgroundSize.height,
          reason: 'Board background size is square on $surface',
        );

        final boardSize = tester.getSize(find.byType(Chessboard));

        expect(
          boardSize.width,
          boardSize.height,
          reason: 'Board size is square on $surface',
        );

        expect(
          boardSize,
          backgroundSize,
          reason: 'Board size should match background size on $surface',
        );
      }
    },
    variant: kPlatformVariant,
  );

  testWidgets(
    'board size and table side size should be harmonious on all surfaces',
    (WidgetTester tester) async {
      for (final surface in surfaces) {
        final app = await makeTestProviderScope(
          key: ValueKey(surface),
          tester,
          child: const MaterialApp(
            home: BoardTable(
              orientation: Side.white,
              fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR',
              topTable: Row(
                mainAxisSize: MainAxisSize.max,
                key: ValueKey('top_table'),
                children: [
                  Text('Top table'),
                ],
              ),
              bottomTable: Row(
                mainAxisSize: MainAxisSize.max,
                key: ValueKey('bottom_table'),
                children: [
                  Text('Bottom table'),
                ],
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
          final expectedBoardSize =
              isTablet ? surface.width - 32.0 : surface.width;
          expect(
            boardSize,
            Size(expectedBoardSize, expectedBoardSize),
            reason: 'Board size should match surface width on $surface',
          );
        } else {
          final topTableSize =
              tester.getSize(find.byKey(const ValueKey('top_table')));
          final bottomTableSize =
              tester.getSize(find.byKey(const ValueKey('bottom_table')));
          final minBoardSize = (surface.longestSide / kGoldenRatio) - 32.0;
          final maxBoardSize = surface.longestSide - 32.0;
          final minSideWidth =
              min(surface.longestSide - minBoardSize - 16.0 * 3, 250.0);
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
            reason:
                'Bottom table width should be at least $minSideWidth on $surface',
          );
          expect(
            topTableSize.width,
            greaterThanOrEqualTo(minSideWidth),
            reason:
                'Top table width should be at least $minSideWidth on $surface',
          );
        }
      }
    },
    variant: kPlatformVariant,
  );
}
