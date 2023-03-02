import 'package:flutter/material.dart';
import 'package:dartchess/dartchess.dart';
import 'package:http/testing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chessground/chessground.dart' as cg;

import 'package:lichess_mobile/src/common/lichess_icons.dart';
import 'package:lichess_mobile/src/common/api_client.dart';
import 'package:lichess_mobile/src/common/shared_preferences.dart';
import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/ui/game/create_game_screen.dart';
import 'package:lichess_mobile/src/ui/game/playable_game_screen.dart';
import 'package:lichess_mobile/src/model/board/computer_opponent.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';
import '../../test_utils.dart';
import '../../test_app.dart';
import '../../model/auth/fake_session_storage.dart';

void main() {
  final mockClient = MockClient.streaming((request, bodyStream) {
    if (request.url.path == '/api/user/maia1') {
      return mockStreamedResponse(maiaResponses['maia1']!, 200);
    } else if (request.url.path == '/api/user/maia5') {
      return mockStreamedResponse(maiaResponses['maia5']!, 200);
    } else if (request.url.path == '/api/user/maia9') {
      return mockStreamedResponse(maiaResponses['maia9']!, 200);
    } else if (request.url.path == '/api/users/status') {
      return mockStreamedResponse(maiaStatusResponses, 200);
    } else if (request.url.path == '/api/account') {
      return mockStreamedResponse(testAccountResponse, 200);
    } else if (request.method == 'POST' &&
        request.url.path == '/api/challenge/maia1') {
      return mockStreamedResponse('ok', 200);
    } else if (request.method == 'POST' &&
        request.url.path == '/api/challenge/maia1') {
      return mockStreamedResponse('ok', 200);
    } else if (request.url.path == '/api/stream/event') {
      return mockHttpStreamFromIterable([gameStartEvent]);
    } else if (request.url.path == '/api/board/game/stream/rCRw1AuO') {
      return mockHttpStreamFromIterable([boardEvent]);
    }

    return mockStreamedResponse('', 404);
  });

  group('CreateGameScreen', () {
    testWidgets(
      'meets accessibility guidelines',
      (tester) async {
        final SemanticsHandle handle = tester.ensureSemantics();

        final app = await buildTestApp(
          tester,
          home: const PlayScreen(),
          overrides: [
            httpClientProvider.overrideWithValue(mockClient),
          ],
        );

        await tester.pumpWidget(app);

        // auth controller state
        await tester.pump(const Duration(milliseconds: 10));

        // wait for maia bots request to return
        await tester.pump(const Duration(milliseconds: 100));

        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        handle.dispose();
      },
      variant: kPlatformVariant,
    );

    testWidgets(
      'loads maia bots info',
      (tester) async {
        final app = await buildTestApp(
          tester,
          home: const PlayScreen(),
          overrides: [
            httpClientProvider.overrideWithValue(mockClient),
          ],
        );

        await tester.pumpWidget(app);

        // auth controller state
        await tester.pump(const Duration(milliseconds: 10));

        // maia bots loading state
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        await tester.pump(
          const Duration(
            milliseconds: 100,
          ),
        ); // wait for maia bots request to return

        // loaded maia ratings
        expect(
          find.widgetWithIcon(
            ChoicePicker<MaiaStrength>,
            LichessIcons.blitz,
          ),
          findsNWidgets(3),
        );
        expect(
          find.widgetWithText(ChoicePicker<MaiaStrength>, '1541'),
          findsOneWidget,
        );
        expect(
          find.widgetWithIcon(
            ChoicePicker<MaiaStrength>,
            LichessIcons.rapid,
          ),
          findsNWidgets(3),
        );
        expect(
          find.widgetWithText(ChoicePicker<MaiaStrength>, '1477'),
          findsOneWidget,
        );
        expect(
          find.widgetWithIcon(
            ChoicePicker<MaiaStrength>,
            LichessIcons.classical,
          ),
          findsNWidgets(3),
        );
        expect(
          find.widgetWithText(ChoicePicker<MaiaStrength>, '1421'),
          findsOneWidget,
        );

        // change maia opponent
        await tester.tap(find.text('maia5'));
        await tester.pump();

        expect(
          tester
              .widget<ChoicePicker>(
                find.byType(ChoicePicker<MaiaStrength>),
              )
              .selectedItem,
          equals(MaiaStrength.maia5),
        );

        // choose stockfish opponent
        await tester.tap(find.text('Stockfish 14'));
        await tester.pump();
        expect(find.text('Strength'), findsOneWidget);
      },
      variant: kPlatformVariant,
    );

    testWidgets(
      'changes time control',
      (tester) async {
        SharedPreferences.setMockInitialValues({
          'play.timeControl': '3 + 2',
        });
        final sharedPreferences = await SharedPreferences.getInstance();

        final app = await buildTestApp(
          tester,
          home: const PlayScreen(),
          overrides: [
            sharedPreferencesProvider.overrideWithValue(sharedPreferences),
            httpClientProvider.overrideWithValue(mockClient),
          ],
        );

        await tester.pumpWidget(app);

        // auth controller state
        await tester.pump(const Duration(milliseconds: 10));

        await tester.tap(find.text('3 + 2'));
        await tester.pumpAndSettle(); // wait for the animation to finish

        await tester
            .tap(find.byKey(const ValueKey(DefaultGameClock.rapid10_0)));
        await tester.pumpAndSettle(); // wait for the animation to finish

        expect(find.widgetWithText(OutlinedButton, '10 + 0'), findsOneWidget);
        expect(
          find.widgetWithIcon(OutlinedButton, LichessIcons.rapid),
          findsOneWidget,
        );
      },
      variant: kPlatformVariant,
    );

    testWidgets(
      'creates a game',
      (tester) async {
        final app = await buildTestApp(
          tester,
          home: const PlayScreen(),
          overrides: [
            httpClientProvider.overrideWithValue(mockClient),
          ],
          userSession: fakeSession,
        );

        await tester.pumpWidget(app);

        // auth controller state
        await tester.pump(const Duration(milliseconds: 10));

        // wait for maia bots request to return
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.byType(CircularProgressIndicator), findsNothing);
        await tester.tap(find.widgetWithText(FatButton, 'Play'));
        await tester.pump(); // play action tapped
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        await tester
            .pump(const Duration(seconds: 3)); // wait for create game service
        await tester.pumpAndSettle(); // wait for page change animation

        expect(find.byType(PlayableGameScreen), findsOneWidget);
        expect(find.byType(cg.PieceWidget), findsNWidgets(32));
      },
      variant: kPlatformVariant,
    );
  });
}

final maiaResponses = {
  'maia1': '''
{
  "id": "maia1",
  "username": "maia1",
  "createdAt": 1290415680000,
  "seenAt": 1290415680000,
  "perfs": {
    "blitz": {
      "games": 2340,
      "rating": 1541,
      "rd": 30,
      "prog": 10
    },
    "rapid": {
      "games": 2340,
      "rating": 1477,
      "rd": 30,
      "prog": 10
    },
    "classical": {
      "games": 2340,
      "rating": 1421,
      "rd": 30,
      "prog": 10
    }
  }
}
''',
  'maia5': '''
{
  "id": "maia5",
  "username": "maia5",
  "createdAt": 1290415680000,
  "seenAt": 1290415680000,
  "perfs": {
    "blitz": {
      "games": 2340,
      "rating": 1643,
      "rd": 30,
      "prog": 10,
      "prov": false
    },
    "rapid": {
      "games": 2340,
      "rating": 1577,
      "rd": 30,
      "prog": 10
    },
    "classical": {
      "games": 2340,
      "rating": 1591,
      "rd": 30,
      "prog": 10
    }
  }
  }
''',
  'maia9': '''
{
  "id": "maia9",
  "username": "maia9",
  "createdAt": 1290415680000,
  "seenAt": 1290415680000,
  "perfs": {
    "blitz": {
      "games": 2340,
      "rating": 1681,
      "rd": 30,
      "prog": 10
    },
    "rapid": {
      "games": 2340,
      "rating": 1677,
      "rd": 30,
      "prog": 10
    },
    "classical": {
      "games": 2340,
      "rating": 1618,
      "rd": 30,
      "prog": 10
    }
  }
  }
''',
};

const maiaStatusResponses = '''
  [
    {
      "id": "maia1",
      "name": "maia1",
      "online": true
    },
    {
      "id": "maia5",
      "name": "maia5",
      "online": true
    },
    {
      "id": "maia9",
      "name": "maia9",
      "online": true
    }
  ]
''';

const testAccountResponse = '''
{
  "id": "test",
  "username": "test",
  "createdAt": 1290415680000,
  "seenAt": 1290415680000,
  "title": "GM",
  "patron": true,
  "perfs": {
    "blitz": {
      "games": 2340,
      "rating": 1681,
      "rd": 30,
      "prog": 10
    },
    "rapid": {
      "games": 2340,
      "rating": 1677,
      "rd": 30,
      "prog": 10
    },
    "classical": {
      "games": 2340,
      "rating": 1618,
      "rd": 30,
      "prog": 10
    }
  },
  "profile": {
    "country": "France",
    "location": "Lille",
    "bio": "test bio",
    "firstName": "John",
    "lastName": "Doe",
    "fideRating": 1800,
    "links": "http://test.com"
  }
}
''';

const gameStartEvent = '''
{
  "type": "gameStart",
  "game": {
    "gameId": "rCRw1AuO",
    "fullId": "rCRw1AuOvonq",
    "color": "black",
    "fen": "$kInitialFEN",
    "hasMoved": true,
    "isMyTurn": false,
    "opponent": {
      "id": "maia1",
      "rating": 1541,
      "username": "maia1"
    },
    "perf": "blitz",
    "rated": false,
    "secondsLeft": 180,
    "source": "friend",
    "speed": "blitz",
    "variant": {
      "key": "standard",
      "name": "Standard"
    },
    "compat": {
      "bot": false,
      "board": true
    }
  }
}
''';

const boardEvent =
    '{ "type": "gameFull", "id": "rCRw1AuO", "speed": "blitz", "initialFen": "$kInitialFEN", "white": { "id": "white", "name": "White", "rating": 1405 }, "black": { "id": "black", "name": "Black", "rating": 1789 }, "state": { "type": "gameState", "moves": "", "wtime": 180000, "btime": 180000, "status": "started" }}';
