import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/game/game_board_params.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/game_layout.dart';
import 'package:material_ui/material_ui.dart';

import '../test_provider_scope.dart';

void main() {
  group('iOS back swipe', () {
    Future<void> pushBoardScreen(WidgetTester tester, GameBoardParams boardParams) async {
      final app = await makeTestProviderScope(
        tester,
        child: MaterialApp(
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () => Navigator.of(context).push(
                buildScreenRoute<void>(
                  screen: Scaffold(
                    body: GameLayout(
                      orientation: Side.white,
                      boardParams: boardParams,
                      topTable: const SizedBox(height: 100, child: Text('Top table')),
                      bottomTable: const SizedBox(height: 100, child: Text('Bottom table')),
                    ),
                  ),
                ),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.pumpWidget(app);
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.byType(Chessboard), findsOneWidget);
    }

    final interactiveParams = GameBoardParams.interactive(
      variant: Variant.standard,
      position: Chess.initial,
      playerSide: PlayerSide.white,
      onMove: (_, {viaDragAndDrop}) {},
    );
    const readonlyParams = GameBoardParams.readonly(
      variant: Variant.standard,
      position: Chess.initial,
    );

    testWidgets('does not pop the screen when the drag starts on an interactive board', (
      tester,
    ) async {
      await pushBoardScreen(tester, interactiveParams);

      final boardRect = tester.getRect(find.byType(Chessboard));
      await tester.dragFrom(Offset(boardRect.left + 5, boardRect.center.dy), const Offset(300, 0));
      await tester.pumpAndSettle();

      expect(find.byType(Chessboard), findsOneWidget);
    }, variant: const TargetPlatformVariant({TargetPlatform.iOS}));

    testWidgets('pops the screen when the drag starts on a non-interactive board', (tester) async {
      await pushBoardScreen(tester, readonlyParams);

      final boardRect = tester.getRect(find.byType(Chessboard));
      await tester.dragFrom(Offset(boardRect.left + 5, boardRect.center.dy), const Offset(300, 0));
      await tester.pumpAndSettle();

      expect(find.byType(Chessboard), findsNothing);
    }, variant: const TargetPlatformVariant({TargetPlatform.iOS}));

    testWidgets('pops the screen when the drag starts outside of the board', (tester) async {
      await pushBoardScreen(tester, interactiveParams);

      final boardRect = tester.getRect(find.byType(Chessboard));
      await tester.dragFrom(Offset(5, boardRect.top - 20), const Offset(300, 0));
      await tester.pumpAndSettle();

      expect(find.byType(Chessboard), findsNothing);
    }, variant: const TargetPlatformVariant({TargetPlatform.iOS}));
  });
}
