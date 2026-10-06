import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game_controller.dart';
import 'package:lichess_mobile/src/model/lobby/game_setup_preferences.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/game/game_body.dart' show kGameEndDialogDelay;
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/game/game_screen_providers.dart';

import '../../network/fake_websocket_channel.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

class _FakeGameSetupPreferences(final GameSetupPrefs prefs) extends GameSetupPreferences {
  @override
  GameSetupPrefs build() => prefs;
}

/// A finished rated lobby game where the user (white) gained rating (+9).
const _finishedRatedLobbyGameEvent = '''
{
  "t": "full",
  "d": {
    "game": {
      "id": "qVChCOTc",
      "variant": {"key": "standard", "name": "Standard", "short": "Std"},
      "speed": "bullet",
      "perf": "bullet",
      "rated": true,
      "source": "lobby",
      "status": {"id": 31, "name": "resign"},
      "winner": "white",
      "createdAt": 1685698678928,
      "pgn": "e4 e5"
    },
    "white": {
      "user": {"name": "Homer", "id": "homer"},
      "rating": 1789,
      "ratingDiff": 9,
      "onGame": true
    },
    "black": {
      "user": {"name": "Moe", "id": "moe"},
      "rating": 1810,
      "ratingDiff": -9,
      "onGame": false
    },
    "youAre": "white",
    "socket": 0,
    "clock": {
      "running": false,
      "initial": 120,
      "increment": 1,
      "white": 120,
      "black": 120,
      "emerg": 15,
      "moretime": 15
    }
  }
}
''';

void main() {
  const testGameFullId = GameFullId('qVChCOTcHSeW');
  final testGameSocketUri = GameController.socketUri(testGameFullId);

  testWidgets('tapping New Opponent creates a seek with the updated rating range', (
    WidgetTester tester,
  ) async {
    http.Request? seekRequest;
    final mockClient = MockClient((request) async {
      if (request.url.path == '/api/board/seek') {
        seekRequest = request;
        return await mockResponse('ok', 200);
      }
      return await mockResponse('', 404);
    });

    final app = await makeTestProviderScopeApp(
      tester,
      home: const GameScreen(source: ExistingGameSource(testGameFullId)),
      overrides: {
        lichessClientProvider: lichessClientProvider.overrideWith(
          (ref) => LichessClient(mockClient, ref),
        ),
        gameSetupPreferencesProvider: gameSetupPreferencesProvider.overrideWith(
          () => _FakeGameSetupPreferences(
            GameSetupPrefs.defaults.copyWith(customRatingDelta: (0, 500)),
          ),
        ),
      },
    );

    await tester.pumpWidget(app);
    await tester.pump(kFakeWebSocketConnectionLag);

    sendServerSocketMessages(testGameSocketUri, [_finishedRatedLobbyGameEvent]);
    await tester.pump();

    // Result dialog appears after delay
    await tester.pump(kGameEndDialogDelay);
    await tester.pump(const Duration(seconds: 1));

    final newOpponentButton = find.text('New opponent');
    expect(newOpponentButton, findsOneWidget);

    await tester.tap(newOpponentButton);
    await tester.pumpAndSettle();

    // The route should have been replaced with a new GameScreen with LobbySource
    final newGameScreen = tester.widget<GameScreen>(find.byType(GameScreen));
    expect(newGameScreen.source, isA<LobbySource>());

    final newSeek = (newGameScreen.source as LobbySource).seek;
    expect(newSeek.rated, isTrue);
    // Updated rating: 1789 + 9 = 1798, delta: (0, 500) -> range: [1798 - 2298]
    expect(newSeek.ratingRange, const (1798, 2298));
    expect(newSeek.ratingDelta, isNull);

    // Verify that the HTTP seek request also sent the updated rating range
    expect(seekRequest, isNotNull);
    expect(seekRequest!.bodyFields['ratingRange'], '1798-2298');
  });
}
