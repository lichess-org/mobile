import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game_controller.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/game/game_body.dart' show kGameEndDialogDelay;
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/game/game_screen_providers.dart';
import 'package:lichess_mobile/src/view/tournament/tournament_screen.dart';

import '../../network/fake_websocket_channel.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';
// Reuse the tournament JSON fixtures. Imported with a prefix so the two `main`
// declarations don't clash.
import '../tournament/tournament_screen_test.dart' as tournament_fixtures;

const _gameId = GameFullId('qVChCOTcHSeW');
const _shortGameId = 'qVChCOTc';
// The id baked into [tournament_fixtures.makeTournamentJson].
const _tournamentId = TournamentId('82QbxlJb');

/// A finished, rated blitz game that is part of an ongoing arena tournament,
/// viewed as white. A finished game makes [GameResultDialog] appear on load, and
/// the ongoing tournament (`secondsLeft > 0`) makes its "Back to tournament"
/// button show.
String finishedTournamentGameEvent() =>
    '''
{
  "t": "full",
  "d": {
    "game": {
      "id": "$_shortGameId",
      "variant": {"key": "standard", "name": "Standard", "short": "Std"},
      "speed": "blitz",
      "perf": "blitz",
      "rated": true,
      "source": "arena",
      "status": {"id": 31, "name": "resign"},
      "winner": "white",
      "createdAt": 1685698678928,
      "pgn": "e4 e5"
    },
    "white": {
      "user": {"name": "Homer", "id": "homer"},
      "rating": 1500,
      "onGame": true
    },
    "black": {
      "user": {"name": "Moe", "id": "moe"},
      "rating": 1500,
      "onGame": true
    },
    "clock": {
      "running": false,
      "initial": 180,
      "increment": 0,
      "white": 120.00,
      "black": 90.00,
      "emerg": 30,
      "moretime": 15
    },
    "youAre": "white",
    "tournament": {
      "id": "${_tournamentId.value}",
      "name": "Test Arena",
      "secondsLeft": 3600,
      "berserkable": true
    },
    "socket": 0
  }
}
''';

/// A [MockClient] that serves the tournament so the pushed/existing
/// [TournamentScreen] can load.
MockClient tournamentMockClient() => MockClient((request) {
  if (request.url.path == '/api/tournament/${_tournamentId.value}') {
    return mockResponse(
      tournament_fixtures.makeTournamentJson(
        standings: tournament_fixtures.makeTestPlayers(10),
        nbPlayers: 11,
      ),
      200,
    );
  }
  return mockResponse('', 404);
});

/// Sends the finished-game event and pumps until the result dialog is shown.
Future<void> showResultDialog(WidgetTester tester) async {
  await tester.pump(kFakeWebSocketConnectionLag);
  sendServerSocketMessages(GameController.socketUri(_gameId), [finishedTournamentGameEvent()]);
  await tester.pump(); // process the socket message
  await tester.pump(kGameEndDialogDelay); // show the result dialog
}

void main() {
  testWidgets('Back to tournament pushes a fresh tournament screen when opened from outside it', (
    tester,
  ) async {
    // The game is opened directly (e.g. from the home recent games list), so
    // there is no tournament screen below it in the navigation stack.
    final app = await makeTestProviderScopeApp(
      tester,
      home: const GameScreen(source: ExistingGameSource(_gameId)),
      overrides: {
        lichessClientProvider: lichessClientProvider.overrideWith(
          (ref) => LichessClient(tournamentMockClient(), ref),
        ),
      },
    );
    await tester.pumpWidget(app);

    await showResultDialog(tester);

    final backButton = find.widgetWithText(FilledButton, 'Back to tournament');
    expect(backButton, findsOneWidget);

    await tester.tap(backButton);
    await tester.pump(); // start the push transition
    await tester.pump(const Duration(milliseconds: 400)); // complete it

    // A tournament screen was pushed on top, and the game screen is retained
    // below it in the stack (it was not popped).
    expect(find.byType(TournamentScreen), findsOneWidget);
    expect(find.byType(GameScreen, skipOffstage: false), findsOneWidget);
  });

  testWidgets('Back to tournament pops back to the existing tournament screen', (tester) async {
    // Simulate the normal flow: we are on the tournament screen, then the game
    // is pushed on top of it and we play it.
    final app = await makeTestProviderScopeApp(
      tester,
      home: const Scaffold(body: SizedBox.shrink()),
      overrides: {
        lichessClientProvider: lichessClientProvider.overrideWith(
          (ref) => LichessClient(tournamentMockClient(), ref),
        ),
      },
    );
    await tester.pumpWidget(app);

    final navigator = tester.state<NavigatorState>(find.byType(Navigator));

    // Push the tournament screen the way the app does (named route + id in the
    // route arguments), then the game on top of it.
    navigator.push(TournamentScreen.buildRoute(_tournamentId));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(TournamentScreen), findsOneWidget);

    navigator.push(GameScreen.buildRoute(source: const ExistingGameSource(_gameId)));
    await tester.pump();

    await showResultDialog(tester);

    expect(find.byType(GameScreen), findsOneWidget);
    final backButton = find.widgetWithText(FilledButton, 'Back to tournament');
    expect(backButton, findsOneWidget);

    await tester.tap(backButton);
    await tester.pump(); // start the pop transition
    await tester.pump(const Duration(seconds: 1)); // let the popped route dispose

    // We popped back to the SAME tournament screen: the game is gone entirely
    // (not merely hidden), and no second tournament screen was pushed.
    expect(find.byType(GameScreen, skipOffstage: false), findsNothing);
    expect(find.byType(TournamentScreen), findsOneWidget);
  });
}
