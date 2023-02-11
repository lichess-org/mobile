import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:dartchess/dartchess.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chessground/chessground.dart' as cg;

import 'package:lichess_mobile/src/common/lichess_icons.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/common/http.dart';
import 'package:lichess_mobile/src/common/sound.dart';
import 'package:lichess_mobile/src/common/shared_preferences.dart';
import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/model/auth/auth_repository.dart';
import 'package:lichess_mobile/src/ui/game/create_game_screen.dart';
import 'package:lichess_mobile/src/ui/game/playable_game_screen.dart';
import 'package:lichess_mobile/src/model/board/computer_opponent.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';
import '../../model/auth/fake_auth_repository.dart';
import '../../utils.dart';

class MockClient extends Mock implements http.Client {}

class MockLogger extends Mock implements Logger {}

class MockSoundService extends Mock implements SoundService {}

void main() {
  final mockLogger = MockLogger();
  final mockClient = MockClient();
  final mockSoundService = MockSoundService();

  setUpAll(() {
    when(() => mockClient.get(Uri.parse('$kLichessHost/api/user/maia1')))
        .thenAnswer((_) => mockResponse(maiaResponses['maia1']!, 200));

    when(() => mockClient.get(Uri.parse('$kLichessHost/api/user/maia5')))
        .thenAnswer((_) => mockResponse(maiaResponses['maia5']!, 200));

    when(() => mockClient.get(Uri.parse('$kLichessHost/api/user/maia9')))
        .thenAnswer((_) => mockResponse(maiaResponses['maia9']!, 200));
    when(
      () => mockClient.get(
        Uri.parse('$kLichessHost/api/users/status?ids=maia1,maia5,maia9'),
      ),
    ).thenAnswer((_) => mockResponse(maiaStatusResponses, 200));

    registerFallbackValue(http.Request('GET', Uri.parse('http://api.test')));
  });

  group('PlayScreen', () {
    testWidgets(
      'meets accessibility guidelines',
      (tester) async {
        SharedPreferences.setMockInitialValues({});
        final sharedPreferences = await SharedPreferences.getInstance();

        final SemanticsHandle handle = tester.ensureSemantics();

        final app = await buildTestApp(
          tester,
          home: Consumer(
            builder: (context, ref, _) {
              return const PlayScreen();
            },
          ),
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              ...defaultProviderOverrides,
              sharedPreferencesProvider.overrideWithValue(sharedPreferences),
              authRepositoryProvider
                  .overrideWithValue(FakeAuthRepository(fakeUser)),
              apiClientProvider
                  .overrideWithValue(ApiClient(mockLogger, mockClient)),
            ],
            child: app,
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        await tester.pump();

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
        SharedPreferences.setMockInitialValues({});
        final sharedPreferences = await SharedPreferences.getInstance();

        final app = await buildTestApp(
          tester,
          home: Consumer(
            builder: (context, ref, _) {
              return const PlayScreen();
            },
          ),
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              ...defaultProviderOverrides,
              authRepositoryProvider
                  .overrideWithValue(FakeAuthRepository(fakeUser)),
              sharedPreferencesProvider.overrideWithValue(sharedPreferences),
              apiClientProvider
                  .overrideWithValue(ApiClient(mockLogger, mockClient)),
            ],
            child: app,
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        await tester.pump();

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
          home: Consumer(
            builder: (context, ref, _) {
              return const PlayScreen();
            },
          ),
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              ...defaultProviderOverrides,
              authRepositoryProvider
                  .overrideWithValue(FakeAuthRepository(fakeUser)),
              sharedPreferencesProvider.overrideWithValue(sharedPreferences),
              apiClientProvider
                  .overrideWithValue(ApiClient(mockLogger, mockClient)),
            ],
            child: app,
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        await tester.pump();

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
        SharedPreferences.setMockInitialValues({});
        final sharedPreferences = await SharedPreferences.getInstance();

        const gameIdTest = 'rCRw1AuO';

        when(
          () => mockClient.post(
            Uri.parse('$kLichessHost/api/challenge/maia1'),
            body: {
              'clock.limit': '${5 * 60}',
              'clock.increment': '3',
              'color': 'random',
            },
          ),
        ).thenAnswer((_) => mockResponse('ok', 200));

        when(
          () => mockClient.send(
            any(
              that: sameRequest(
                http.Request(
                  'GET',
                  Uri.parse('$kLichessHost/api/stream/event'),
                ),
              ),
            ),
          ),
        ).thenAnswer(
          (_) => mockHttpStreamFromIterable([
            '''
{
  "type": "gameStart",
  "game": {
    "gameId": "$gameIdTest",
    "fullId": "${gameIdTest}vonq",
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
'''
          ]),
        );

        when(
          () => mockClient.send(
            any(
              that: sameRequest(
                http.Request(
                  'GET',
                  Uri.parse(
                    '$kLichessHost/api/board/game/stream/$gameIdTest',
                  ),
                ),
              ),
            ),
          ),
        ).thenAnswer(
          (_) => mockHttpStreamFromIterable([
            '{ "type": "gameFull", "id": "$gameIdTest", "speed": "blitz", "initialFen": "$kInitialFEN", "white": { "id": "white", "name": "White", "rating": 1405 }, "black": { "id": "black", "name": "Black", "rating": 1789 }, "state": { "type": "gameState", "moves": "", "wtime": 180000, "btime": 180000, "status": "started" }}'
          ]),
        );

        final app = await buildTestApp(
          tester,
          home: Consumer(
            builder: (context, ref, _) {
              return const PlayScreen();
            },
          ),
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              ...defaultProviderOverrides,
              authRepositoryProvider
                  .overrideWithValue(FakeAuthRepository(fakeUser)),
              sharedPreferencesProvider.overrideWithValue(sharedPreferences),
              apiClientProvider
                  .overrideWithValue(ApiClient(mockLogger, mockClient)),
              soundServiceProvider.overrideWithValue(mockSoundService),
            ],
            child: app,
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        await tester.pump();

        await tester.pump(
          const Duration(
            milliseconds: 100,
          ),
        ); // wait for maia bots request to return

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
