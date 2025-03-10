import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/game/archived_game.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/game/archived_game_screen.dart';
import 'package:lichess_mobile/src/view/game/game_player.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar_button.dart';
import 'package:lichess_mobile/src/widgets/move_list.dart';

import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

final client = MockClient((request) {
  if (request.url.path == '/game/export/qVChCOTc') {
    return mockResponse(gameResponse, 200);
  }
  return mockResponse('', 404);
});

void main() {
  group('ArchivedGameScreen', () {
    testWidgets('loads game data if only game id is provided', (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const ArchivedGameScreen(gameId: GameId('qVChCOTc'), orientation: Side.white),
        overrides: [lichessClientProvider.overrideWith((ref) => LichessClient(client, ref))],
      );

      await tester.pumpWidget(app);

      expect(find.byType(PieceWidget), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // wait for game data loading
      await tester.pumpAndSettle(const Duration(milliseconds: 100));

      expect(find.byType(PieceWidget), findsNWidgets(25));
      expect(find.widgetWithText(GamePlayer, 'veloce'), findsOneWidget);
      expect(find.widgetWithText(GamePlayer, 'Stockfish level 1'), findsOneWidget);
    }, variant: kPlatformVariant);

    testWidgets('displays game data and last fen immediately, then moves', (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: ArchivedGameScreen(gameData: gameData, orientation: Side.white),
        overrides: [lichessClientProvider.overrideWith((ref) => LichessClient(client, ref))],
      );

      await tester.pumpWidget(app);

      // data shown immediately
      expect(find.byType(Chessboard), findsOneWidget);
      expect(find.byType(PieceWidget), findsNWidgets(25));

      // cannot interact with board
      expect(tester.widget<Chessboard>(find.byType(Chessboard)).game, null);

      // moves are not loaded
      expect(
        tester.widget<BottomBarButton>(find.byKey(const ValueKey('cursor-back'))).onTap,
        isNull,
      );

      // wait for game steps loading
      await tester.pump(const Duration(milliseconds: 100));
      // wait for move list ensureVisible animation to finish
      await tester.pumpAndSettle();

      // same info still displayed
      expect(find.byType(Chessboard), findsOneWidget);
      expect(find.byType(PieceWidget), findsNWidgets(25));

      // now with the clocks
      expect(find.text('1:46', findRichText: true), findsNWidgets(1));
      expect(find.text('0:46', findRichText: true), findsNWidgets(1));

      // moves and players are loaded
      expect(
        tester.widget<BottomBarButton>(find.byKey(const ValueKey('cursor-back'))).onTap,
        isNotNull,
      );
      expect(find.widgetWithText(GamePlayer, 'veloce'), findsOneWidget);
      expect(find.widgetWithText(GamePlayer, 'Stockfish level 1'), findsOneWidget);
    }, variant: kPlatformVariant);

    testWidgets('navigate game positions', (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: ArchivedGameScreen(gameData: gameData, orientation: Side.white),
        overrides: [
          lichessClientProvider.overrideWith((ref) {
            return LichessClient(client, ref);
          }),
        ],
      );

      await tester.pumpWidget(app);

      // wait for game steps loading
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(MoveList), findsOneWidget);

      // wait for move list ensureVisible animation to finish
      await tester.pumpAndSettle();

      final movesAfterE4 =
          'e5 Qh5 Nf6 Qxe5+ Be7 b3 d6 Qb5+ Bd7 Qxb7 Nc6 Ba3 Rb8 Qa6 Nxe4 Bb2 O-O Nc3 Nb4 Nf3 Nxa6 Nd5 Nb4 Nxe7+ Qxe7 Nd4 Qf6 f4 Qe7 Ke2 Ng3+ Kd1 Nxh1 Bc4 Nf2+ Kc1 Qe1#'
              .split(' ')
              .reversed
              .toList();

      expect(
        tester.widget<InlineMoveItem>(find.widgetWithText(InlineMoveItem, 'Qe1#')).current,
        isTrue,
      );

      // cannot go forward
      expect(tester.widget<BottomBarButton>(find.byKey(const Key('cursor-forward'))).onTap, isNull);

      for (var i = 0; i <= movesAfterE4.length; i++) {
        // go back in history
        await tester.tap(find.byKey(const Key('cursor-back')));
        // wait for animation to finish
        await tester.pumpAndSettle();

        // move list is updated
        final prevMoveIndex = i + 1;
        if (prevMoveIndex < movesAfterE4.length) {
          final prevMove = find.widgetWithText(InlineMoveItem, movesAfterE4[prevMoveIndex]);
          expect(prevMove, findsAtLeastNWidgets(1));
          expect(
            tester.widgetList<InlineMoveItem>(prevMove).any((e) => e.current ?? false),
            isTrue,
          );
        }
      }

      // cannot go backward anymore
      expect(tester.widget<BottomBarButton>(find.byKey(const Key('cursor-back'))).onTap, isNull);
    });
  });
}

// --

const gameResponse = '''
{"id":"qVChCOTc","rated":false,"source":"lobby","variant":"standard","speed":"blitz","perf":"blitz","createdAt":1673443822389,"lastMoveAt":1673444036416,"status":"mate","players":{"white":{"aiLevel":1},"black":{"user":{"name":"veloce","patron":true,"id":"veloce"},"rating":1435,"provisional":true}},"winner":"black","opening":{"eco":"C20","name":"King's Pawn Game: Wayward Queen Attack, Kiddie Countergambit","ply":4},"moves":"e4 e5 Qh5 Nf6 Qxe5+ Be7 b3 d6 Qb5+ Bd7 Qxb7 Nc6 Ba3 Rb8 Qa6 Nxe4 Bb2 O-O Nc3 Nb4 Nf3 Nxa6 Nd5 Nb4 Nxe7+ Qxe7 Nd4 Qf6 f4 Qe7 Ke2 Ng3+ Kd1 Nxh1 Bc4 Nf2+ Kc1 Qe1#","clocks":[18003,18003,17915,17627,17771,16691,17667,16243,17475,15459,17355,14779,17155,13795,16915,13267,14771,11955,14451,10995,14339,10203,13899,9099,12427,8379,12003,7547,11787,6691,11355,6091,11147,5763,10851,5099,10635,4657],"clock":{"initial":180,"increment":0,"totalTime":180},"lastFen":"1r3rk1/p1pb1ppp/3p4/8/1nBN1P2/1P6/PBPP1nPP/R1K1q3 w - - 4 1"}
''';

final gameData = LightArchivedGame(
  id: const GameId('qVChCOTc'),
  rated: false,
  speed: Speed.blitz,
  perf: Perf.blitz,
  createdAt: DateTime.parse('2023-01-11 14:30:22.389'),
  lastMoveAt: DateTime.parse('2023-01-11 14:33:56.416'),
  status: GameStatus.mate,
  white: const Player(aiLevel: 1),
  black: const Player(
    user: LightUser(id: UserId('veloce'), name: 'veloce', isPatron: true),
    rating: 1435,
  ),
  variant: Variant.standard,
  lastFen: '1r3rk1/p1pb1ppp/3p4/8/1nBN1P2/1P6/PBPP1nPP/R1K1q3 w - - 4 1',
  winner: Side.black,
);
