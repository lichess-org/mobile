import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game_controller.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/game/game_screen_providers.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';

import '../../network/fake_websocket_channel.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

/// A finished, clockless (correspondence) game viewed as white, with a
/// configurable opponent `onGame` flag.
String finishedCorrespondenceFullEvent({required bool opponentOnGame}) =>
    '''
{
  "t": "full",
  "d": {
    "game": {
      "id": "qVChCOTc",
      "variant": {"key": "standard", "name": "Standard", "short": "Std"},
      "speed": "correspondence",
      "perf": "correspondence",
      "rated": false,
      "source": "lobby",
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
      "onGame": $opponentOnGame
    },
    "youAre": "white",
    "socket": 0
  }
}
''';

void main() {
  const testGameFullId = GameFullId('qVChCOTcHSeW');
  final testGameSocketUri = GameController.socketUri(testGameFullId);
  const rematchPath = '/challenge/rematch-of/qVChCOTc';

  /// Builds a [MockClient] that records every request path and returns
  /// [rematchStatus] for the rematch-of endpoint.
  ({MockClient client, List<String> requestedPaths}) makeRecordingClient({
    int rematchStatus = 200,
  }) {
    final requestedPaths = <String>[];
    final client = MockClient((request) async {
      requestedPaths.add('${request.method} ${request.url.path}');
      if (request.url.path == rematchPath) {
        return rematchStatus == 200
            ? http.Response('{"ok":true}', 200)
            : http.Response('{"error":"Sorry, couldn\'t create the rematch."}', rematchStatus);
      }
      return mockResponse('', 404);
    });
    return (client: client, requestedPaths: requestedPaths);
  }

  /// Loads the finished correspondence game into a [GameScreen] and returns the
  /// recorded request paths list.
  Future<List<String>> pumpFinishedGame(
    WidgetTester tester, {
    required MockClient client,
    required List<String> requestedPaths,
    required bool opponentOnGame,
  }) async {
    final app = await makeTestProviderScopeApp(
      tester,
      home: const GameScreen(source: ExistingGameSource(testGameFullId)),
      overrides: {
        lichessClientProvider: lichessClientProvider.overrideWith(
          (ref) => LichessClient(client, ref),
        ),
      },
    );
    await tester.pumpWidget(app);
    await tester.pump(kFakeWebSocketConnectionLag);

    sendServerSocketMessages(testGameSocketUri, [
      finishedCorrespondenceFullEvent(opponentOnGame: opponentOnGame),
    ]);
    await tester.pump();
    return requestedPaths;
  }

  group('Correspondence rematch (offline opponent)', () {
    testWidgets('result dialog enables the rematch button and posts a challenge', (tester) async {
      final (:client, :requestedPaths) = makeRecordingClient();
      await pumpFinishedGame(
        tester,
        client: client,
        requestedPaths: requestedPaths,
        opponentOnGame: false,
      );

      // The result dialog is shown 500ms after the game finishes, then its
      // buttons activate after a further second.
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump(const Duration(seconds: 1));

      final rematchButton = find.widgetWithText(FilledButton, 'Rematch');
      expect(rematchButton, findsOneWidget);
      expect(
        tester.widget<FilledButton>(rematchButton).onPressed,
        isNotNull,
        reason: 'rematch must be enabled for a finished correspondence game vs an offline opponent',
      );

      await tester.tap(rematchButton);
      await tester.pump();

      expect(requestedPaths, contains('POST $rematchPath'));
    });

    testWidgets('result dialog shows an error snackbar when the challenge fails', (tester) async {
      final (:client, :requestedPaths) = makeRecordingClient(rematchStatus: 400);
      await pumpFinishedGame(
        tester,
        client: client,
        requestedPaths: requestedPaths,
        opponentOnGame: false,
      );

      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.widgetWithText(FilledButton, 'Rematch'));
      await tester.pump();
      await tester.pump();

      expect(find.text('Could not send the rematch challenge'), findsOneWidget);
    });

    testWidgets('game menu posts a challenge and shows an error snackbar on failure', (
      tester,
    ) async {
      final (:client, :requestedPaths) = makeRecordingClient(rematchStatus: 400);
      await pumpFinishedGame(
        tester,
        client: client,
        requestedPaths: requestedPaths,
        opponentOnGame: false,
      );

      // Let the auto result dialog appear, then dismiss it via its barrier to
      // reach the bottom bar menu underneath.
      await tester.pump(const Duration(milliseconds: 600));
      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();

      // Open the game menu (bottom sheet) and tap the rematch action.
      await tester.tap(find.widgetWithIcon(BottomBarButton, Icons.menu));
      await tester.pumpAndSettle();

      final rematchAction = find.text('Rematch');
      expect(rematchAction, findsOneWidget);

      await tester.tap(rematchAction);
      // The sheet is dismissed on tap; the snackbar must still render afterwards.
      await tester.pumpAndSettle();

      expect(requestedPaths, contains('POST $rematchPath'));
      expect(find.text('Could not send the rematch challenge'), findsOneWidget);
    });
  });

  group('Correspondence rematch (online opponent)', () {
    testWidgets('rematch uses the socket path and does not post a challenge', (tester) async {
      final (:client, :requestedPaths) = makeRecordingClient();
      await pumpFinishedGame(
        tester,
        client: client,
        requestedPaths: requestedPaths,
        opponentOnGame: true,
      );

      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump(const Duration(seconds: 1));

      final rematchButton = find.widgetWithText(FilledButton, 'Rematch');
      expect(tester.widget<FilledButton>(rematchButton).onPressed, isNotNull);

      await tester.tap(rematchButton);
      await tester.pump();

      // The online-opponent path goes over the websocket, never the HTTP endpoint.
      expect(requestedPaths, isNot(contains('POST $rematchPath')));
    });
  });
}
