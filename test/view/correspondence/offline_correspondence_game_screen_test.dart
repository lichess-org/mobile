import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/view/correspondence/offline_correspondence_game_screen.dart';

import '../../example_data.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

void main() {
  group('Offline correspondence game', () {
    testWidgets('Last move is highlighted when loading a game', (tester) async {
      // Regression test: interactive boards read the last move from
      // InteractiveBoardParams.lastMove, not GameLayout.lastMove (readonly only).
      // The last move of a loaded game must be highlighted on the board.
      final app = await makeTestProviderScopeApp(
        tester,
        home: OfflineCorrespondenceGameScreen(
          initialGame: (DateTime(2021, 1, 1), offlineCorrespondenceGame),
        ),
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // The fixture's last move is Qd2 (d1d2); it must be highlighted on the board.
      expect(getBoardLastMove(tester), Move.parse('d1d2'));
    });

    testWidgets('Last move is highlighted after playing a move', (tester) async {
      // A game where it's the user's (white's) turn from the initial position.
      final game = offlineCorrespondenceGame.copyWith(
        steps: [const GameStep(position: Chess.initial)].lock,
      );

      final app = await makeTestProviderScopeApp(
        tester,
        home: OfflineCorrespondenceGameScreen(initialGame: (DateTime(2021, 1, 1), game)),
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // No last move highlight before any move is played.
      expect(getBoardLastMove(tester), isNull);

      await playMove(tester, 'e2', 'e4');
      await tester.pumpAndSettle();

      expect(getBoardLastMove(tester), Move.parse('e2e4'));
    });
  });
}
