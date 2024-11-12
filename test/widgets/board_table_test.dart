import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
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
              topTable: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Top table'),
              ),
              bottomTable: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Bottom table'),
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
          reason: 'Board background size is square',
        );

        final boardSize = tester.getSize(find.byType(Chessboard));

        expect(
          boardSize.width,
          boardSize.height,
          reason: 'Board size is square',
        );

        expect(
          boardSize,
          backgroundSize,
          reason: 'Board size should match background size',
        );

        final isLandscape = surface.aspectRatio > 1.0;
        final isTablet = surface.shortestSide > 600;

        final expectedBoardSize = isLandscape
            ? isTablet
                ? surface.height - 32.0
                : surface.height
            : isTablet
                ? surface.width - 32.0
                : surface.width;

        expect(
          boardSize,
          Size(expectedBoardSize, expectedBoardSize),
        );
      }
    },
    variant: kPlatformVariant,
  );
}
