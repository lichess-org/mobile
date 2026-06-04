import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/tv/tv_channel.dart';
import 'package:lichess_mobile/src/view/watch/tv_screen.dart';

import '../../model/game/game_socket_example_data.dart';
import '../../network/fake_websocket_channel.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

void main() {
  const gameId = GameId('qVChCOTc');
  // The TV controller opens this socket route for the initial game.
  final tvSocketUri = Uri(path: '/watch/$gameId/white/v6');

  Future<void> loadGame(WidgetTester tester, {String pgn = ''}) async {
    await tester.pump(kFakeWebSocketConnectionLag);
    sendServerSocketMessages(tvSocketUri, [
      makeFullEvent(gameId, pgn, whiteUserName: 'Peter', blackUserName: 'Steven'),
    ]);
    // wait for socket message handling
    await tester.pump();
  }

  group('TvScreen (readonly GameLayout board)', () {
    testWidgets('loads the game and displays a non-interactive board', (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const TvScreen(channel: TvChannel.best, initialGame: (gameId, Side.white)),
      );
      await tester.pumpWidget(app);

      // While loading, an empty board is shown.
      expect(find.byType(Chessboard), findsOneWidget);
      expect(getBoardPieces(tester), isEmpty);

      await loadGame(tester);

      // The full position is displayed once the game loads.
      expect(getBoardPieces(tester).length, 32);
      expect(find.text('Peter'), findsOneWidget);
      expect(find.text('Steven'), findsOneWidget);

      // The TV board is a spectator board: it must not be interactive.
      expect(tester.widget<Chessboard>(find.byType(Chessboard)).interactive, isFalse);
    });

    testWidgets('updates the board when a move event is received', (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const TvScreen(channel: TvChannel.best, initialGame: (gameId, Side.white)),
      );
      await tester.pumpWidget(app);
      await loadGame(tester);

      expect(boardHasPiece(tester, Square.e2, Piece.whitePawn), isTrue);

      // Server broadcasts the first move (e2-e4).
      sendServerSocketMessages(tvSocketUri, [
        '{"t": "move", "v": 1, "d": {"ply": 1, "uci": "e2e4", "san": "e4", "clock": {"white": 180, "black": 180}}}',
      ]);
      await tester.pump();

      // The board advances to the new position and stays non-interactive.
      expect(boardHasPiece(tester, Square.e4, Piece.whitePawn), isTrue);
      expect(getBoardPieces(tester).containsKey(Square.e2), isFalse);
      expect(getBoardLastMove(tester), const NormalMove(from: Square.e2, to: Square.e4));
      expect(tester.widget<Chessboard>(find.byType(Chessboard)).interactive, isFalse);
    });

    testWidgets('navigates to the previous move with the bottom bar', (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const TvScreen(channel: TvChannel.best, initialGame: (gameId, Side.white)),
      );
      await tester.pumpWidget(app);
      await loadGame(tester);

      sendServerSocketMessages(tvSocketUri, [
        '{"t": "move", "v": 1, "d": {"ply": 1, "uci": "e2e4", "san": "e4", "clock": {"white": 180, "black": 180}}}',
      ]);
      await tester.pump();
      expect(boardHasPiece(tester, Square.e4, Piece.whitePawn), isTrue);

      // Step back one move via the bottom bar.
      await tester.tap(find.byKey(const ValueKey('goto-previous')));
      await tester.pump();

      // The board shows the position before the move again.
      expect(boardHasPiece(tester, Square.e2, Piece.whitePawn), isTrue);
      expect(getBoardPieces(tester).containsKey(Square.e4), isFalse);
      expect(tester.widget<Chessboard>(find.byType(Chessboard)).interactive, isFalse);
    });
  });
}
