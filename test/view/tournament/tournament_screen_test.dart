import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game_controller.dart';
import 'package:lichess_mobile/src/model/tournament/tournament.dart';
import 'package:lichess_mobile/src/model/tournament/tournament_controller.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/tournament/tournament_screen.dart';
import 'package:lichess_mobile/src/widgets/board_thumbnail.dart';

import '../../model/game/game_socket_example_data.dart';
import '../../network/fake_websocket_channel.dart';
import '../../test_helpers.dart';
import '../../test_provider_scope.dart';

String standingPlayersToJson(List<StandingPlayer> players) {
  return players
      .map(
        (player) =>
            '''
      {
        "name": "${player.user.name}",
        "rank": ${player.rank},
        "rating": ${player.rating},
        "score": ${player.score},
        "sheet": {
          "scores": "${player.sheet.scores.join()}",
          "fire": ${player.sheet.fire}
        }
      }
    ''',
      )
      .join(',');
}

String meToJson(TournamentMe? me) {
  return me != null
      ? '''
    "me": {
      "rank": ${me.rank},
      "fullId": "${me.gameId}",
      "withdraw": "${me.withdraw}",
      "pauseDelay": ${me.pauseDelay}
    },
  '''
      : '';
}

String kFeaturedGame = '''
"featured": {
    "id": "CW8jtJJO",
    "fen": "r4rk1/pp3p1p/3pq1p1/2p5/3pP3/P2P3P/1PP2PP1/R2Q1RK1 w",
    "orientation": "white",
    "color": "white",
    "lastMove": "e8h8",
    "white": {
      "name": "WhiteFeatured",
      "id": "whitefeatured",
      "rank": 2,
      "rating": 1278
    },
    "black": {
      "name": "BlackFeatured",
      "id": "blackfeatured",
      "rank": 4,
      "rating": 1261
    },
    "c": {
      "white": 148,
      "black": 151
    }
  }
''';

String makeTournamentJson({
  required List<StandingPlayer> standings,
  required int nbPlayers,
  String? verdictsJson,
  TournamentMe? me,
  String featuredGameJson = '',
}) {
  final verdicts =
      verdictsJson ??
      '''
    "verdicts": {
      "list": [
        {
          "condition": ">= 20 Blitz rated games",
          "verdict": "ok"
        },
        {
          "condition": "Rated <= 1300 in Blitz for the last week",
          "verdict": "ok"
        }
      ],
      "accepted": true
    },
  ''';

  return '''
          {
  "nbPlayers": $nbPlayers,
  ${meToJson(me)}
  "duels": [ ],
  "secondsToFinish": 2744,
  "isStarted": true,
  $featuredGameJson
  "standing": {
    "page": 1,
    "players": [ ${standingPlayersToJson(standings)} ]
  },
  $kFeaturedGame,
  "id": "82QbxlJb",
  "socketVersion": 0,
  "createdBy": "lichess",
  "startsAt": "2025-04-01T17:00:25Z",
  "system": "arena",
  "fullName": "<=1300 SuperBlitz Arena",
  "minutes": 57,
  "perf": {
    "key": "blitz",
    "name": "Blitz",
    "icon": ")"
  },
  "clock": {
    "limit": 180,
    "increment": 0
  },
  "variant": "standard",
  "rated": true,
  $verdicts
  "schedule": {
    "freq": "hourly",
    "speed": "superBlitz"
  },
  "maxRating": {
    "rating": 1300
  },
  "minRatedGames": {
    "nb": 20
  },
  "chat": {
    "lines": [],
    "writeable": true
  },
  "reloadEndpoint": "https://http.lichess.org/tournament/82QbxlJb"
}
''';
}

String makeStandingJson({required List<StandingPlayer> standings, required int page}) {
  return '''
{
  "page": $page,
  "players": [ ${standingPlayersToJson(standings)} ]
}
''';
}

String makeReloadedTournamentJson({
  required List<StandingPlayer> standings,
  required int page,
  required int nbPlayers,
  TournamentMe? me,
  String featuredGameJson = '',
}) =>
    '''
{
  "nbPlayers": $nbPlayers,
  "duels": [ ],
  "secondsToFinish": 1063,
  $kFeaturedGame,
  "isStarted": true,
  ${meToJson(me)}
  $featuredGameJson
  "standing": {
    "page": $page,
    "players": [ ${standingPlayersToJson(standings)} ]
  }
}
''';

StandingPlayer makeTestPlayer(int index) => StandingPlayer(
  user: LightUser(id: UserId.fromUserName('player$index'), name: 'player$index'),
  rating: 1500 + index,
  rank: index,
  score: index,
  provisional: false,
  withdraw: index.isOdd,
  sheet: (fire: index.isEven, scores: const IList.empty()),
);

List<StandingPlayer> makeTestPlayers(int count) => List.generate(count, makeTestPlayer);

void main() {
  group('Tournament screen', () {
    testWidgets('meets accessibility guidelines', variant: kPlatformVariant, (
      WidgetTester tester,
    ) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/tournament/82QbxlJb') {
          return mockResponse(
            makeTournamentJson(standings: makeTestPlayers(10), nbPlayers: 11),
            200,
          );
        }
        return mockResponse('', 404);
      });

      final app = await makeTestProviderScopeApp(
        tester,
        home: const TournamentScreen(id: TournamentId('82QbxlJb')),
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith((ref) {
            return LichessClient(mockClient, ref);
          }),
        },
      );
      await tester.pumpWidget(app);

      // Wait for tournament data to load
      await tester.pump();

      await meetsTapTargetGuideline(tester);
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      handle.dispose();
    });

    testWidgets('Displays tournament data and standings', (WidgetTester tester) async {
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/tournament/82QbxlJb') {
          return mockResponse(
            makeTournamentJson(standings: makeTestPlayers(10), nbPlayers: 13),
            200,
          );
        }
        if (request.url.path == '/tournament/82QbxlJb/standing/1') {
          return mockResponse(makeStandingJson(standings: makeTestPlayers(10), page: 1), 200);
        } else if (request.url.path == '/tournament/82QbxlJb/standing/2') {
          return mockResponse(makeStandingJson(standings: makeTestPlayers(3), page: 2), 200);
        }
        return mockResponse('', 404);
      });

      final app = await makeTestProviderScopeApp(
        tester,
        home: const TournamentScreen(id: TournamentId('82QbxlJb')),
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith((ref) {
            return LichessClient(mockClient, ref);
          }),
        },
      );
      await tester.pumpWidget(app);

      // Wait for tournament data to load
      await tester.pump();

      expect(find.text('<=1300 SuperBlitz Arena'), findsOneWidget);

      expect(find.text('>= 20 Blitz rated games'), findsOneWidget);
      expect(find.text('Rated <= 1300 in Blitz for the last week'), findsOneWidget);

      for (var i = 0; i < 10; i++) {
        expect(find.text('player$i'), findsOneWidget);
      }

      expect(find.text('1-10 / 13'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.chevron_right));
      // Wait for next page of standings to load
      await tester.pump();

      expect(find.text('player0'), findsOneWidget);
      expect(find.text('player1'), findsOneWidget);
      expect(find.text('player2'), findsOneWidget);
      expect(find.text('player3'), findsNothing);

      expect(find.text('11-13 / 13'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.chevron_left));
      // Wait for first page of standings to load
      await tester.pump();

      for (var i = 0; i < 10; i++) {
        expect(find.text('player$i'), findsOneWidget);
      }

      expect(find.text('1-10 / 13'), findsOneWidget);
    });

    testWidgets('Displays featured game', (WidgetTester tester) async {
      const tournamentId = TournamentId('82QbxlJb');

      final mockClient = MockClient((request) {
        if (request.url.path == '/api/tournament/82QbxlJb') {
          return mockResponse(
            makeTournamentJson(standings: makeTestPlayers(10), nbPlayers: 11),
            200,
          );
        }
        return mockResponse('', 404);
      });

      final app = await makeTestProviderScopeApp(
        tester,
        home: const TournamentScreen(id: tournamentId),
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith((ref) {
            return LichessClient(mockClient, ref);
          }),
        },
      );
      await tester.pumpWidget(app);

      // Wait for tournament data to load
      await tester.pump();

      await tester.dragUntilVisible(
        find.text('BlackFeatured'),
        find.byType(ListView),
        const Offset(0, -250),
      );

      expect(find.text('BlackFeatured'), findsOneWidget);
      expect(find.text('WhiteFeatured'), findsOneWidget);
      expect(find.byType(PieceWidget), findsAny);
      expect(find.byType(BoardThumbnail), findsOneWidget);

      // Pretend all the pieces are gone to check that the board is updated
      sendServerSocketMessages(TournamentController.socketUri(tournamentId), [
        '{"t": "fen", "d": {"id": "CW8jtJJO", "fen": "$kEmptyBoardFEN", "lm": "e2e4", "wc": 0, "bc": 0}  }',
      ]);

      // Wait for board to update
      await tester.pumpAndSettle();

      expect(find.byType(BoardThumbnail), findsOneWidget);
      expect(find.byType(PieceWidget), findsNothing);
    });

    testWidgets('Can join tournament', (WidgetTester tester) async {
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/tournament/82QbxlJb/join') {
          return mockResponse('', 200);
        }
        if (request.url.path == '/api/tournament/82QbxlJb') {
          return mockResponse(
            makeTournamentJson(standings: makeTestPlayers(10), nbPlayers: 12),
            200,
          );
        }
        if (request.url.path == '/tournament/82QbxlJb/standing/1') {
          return mockResponse(makeStandingJson(standings: makeTestPlayers(10), page: 1), 200);
        } else if (request.url.path == '/tournament/82QbxlJb/standing/2') {
          return mockResponse(makeStandingJson(standings: makeTestPlayers(2), page: 2), 200);
        }
        if (request.url.path == '/https%253A//http.lichess.org/tournament/82QbxlJb' &&
            request.url.queryParameters['partial'] == 'true') {
          return mockResponse(
            makeReloadedTournamentJson(
              me: (gameId: null, pauseDelay: null, rank: 11, withdraw: null),
              standings: makeTestPlayers(10),
              page: 1,
              nbPlayers: 12,
            ),
            200,
          );
        }
        return mockResponse('', 404);
      });

      const name = 'tom-anders';
      const tournamentId = TournamentId('82QbxlJb');
      final user = LightUser(id: UserId.fromUserName(name), name: name);
      final authUser = AuthUser(user: user, token: 'test-token');

      final app = await makeTestProviderScopeApp(
        tester,
        home: const TournamentScreen(id: tournamentId),
        authUser: authUser,
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith((ref) {
            return LichessClient(mockClient, ref);
          }),
        },
      );
      await tester.pumpWidget(app);

      // Wait for tournament data to load
      await tester.pump();

      expect(find.text('Join'), findsOneWidget);

      await tester.tap(find.text('Join'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Join'), findsNothing);

      sendServerSocketMessages(TournamentController.socketUri(tournamentId), ['{"t": "reload"}']);
      // Wait for reload
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Join'), findsNothing);
      expect(find.text('Pause'), findsOneWidget);

      // We're rank 11, so this should take us to the 2nd page
      await tester.tap(find.byIcon(Icons.person_pin_circle_outlined));

      // Wait for next page of standings to load
      await tester.pump();
      expect(find.text('11-12 / 12'), findsOneWidget);
    });

    testWidgets('Cannot join tournament if not logged in', (WidgetTester tester) async {
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/tournament/82QbxlJb') {
          return mockResponse(
            makeTournamentJson(standings: makeTestPlayers(10), nbPlayers: 12),
            200,
          );
        }
        return mockResponse('', 404);
      });

      final app = await makeTestProviderScopeApp(
        tester,
        home: const TournamentScreen(id: TournamentId('82QbxlJb')),
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith((ref) {
            return LichessClient(mockClient, ref);
          }),
        },
      );
      await tester.pumpWidget(app);

      // Wait for tournament data to load
      await tester.pump();

      expect(find.text('Sign in'), findsOneWidget);
      expect(find.text('Join'), findsNothing);
    });

    testWidgets('Cannot join tournament if not meeting entry conditions', (
      WidgetTester tester,
    ) async {
      final mockClient = MockClient((request) {
        expect(request.url.path, isNot('/api/tournament/82QbxlJb/join'));

        if (request.url.path == '/api/tournament/82QbxlJb') {
          return mockResponse(
            makeTournamentJson(
              verdictsJson: '"verdicts": {"list": [], "accepted": false},',
              standings: makeTestPlayers(10),
              nbPlayers: 12,
            ),
            200,
          );
        }
        return mockResponse('', 404);
      });

      const name = 'tom-anders';
      const tournamentId = TournamentId('82QbxlJb');
      final user = LightUser(id: UserId.fromUserName(name), name: name);
      final authUser = AuthUser(user: user, token: 'test-token');

      final app = await makeTestProviderScopeApp(
        tester,
        home: const TournamentScreen(id: tournamentId),
        authUser: authUser,
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith((ref) {
            return LichessClient(mockClient, ref);
          }),
        },
      );
      await tester.pumpWidget(app);

      // Wait for tournament data to load
      await tester.pump();

      expect(find.text('Join'), findsOneWidget);

      // Button should be disabled. If it's not, the expectation in the mock client above will fail
      await tester.tap(find.text('Join'));
      await tester.pump();
    });

    testWidgets('Opens game screen when there is a new pairing', (WidgetTester tester) async {
      const gameId = GameFullId('1234567890ab');

      final mockClient = MockClient((request) {
        if (request.url.path == '/api/tournament/82QbxlJb/join') {
          return mockResponse('', 200);
        }
        if (request.url.path == '/api/tournament/82QbxlJb') {
          return mockResponse(
            makeTournamentJson(
              me: (gameId: null, pauseDelay: null, rank: 11, withdraw: null),
              standings: makeTestPlayers(10),
              nbPlayers: 12,
            ),
            200,
          );
        }
        if (request.url.path == '/https%253A//http.lichess.org/tournament/82QbxlJb' &&
            request.url.queryParameters['partial'] == 'true') {
          if (request.url.queryParameters['page'] == '1') {
            return mockResponse(
              makeReloadedTournamentJson(
                me: (gameId: gameId, pauseDelay: null, rank: 11, withdraw: null),
                standings: makeTestPlayers(10),
                page: 1,
                nbPlayers: 12,
              ),
              200,
            );
          }
        }
        return mockResponse('', 404);
      });

      const name = 'tom-anders';
      const tournamenId = TournamentId('82QbxlJb');
      final user = LightUser(id: UserId.fromUserName(name), name: name);
      final authUser = AuthUser(user: user, token: 'test-token');

      final app = await makeTestProviderScopeApp(
        tester,
        home: const TournamentScreen(id: tournamenId),
        authUser: authUser,
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith((ref) {
            return LichessClient(mockClient, ref);
          }),
        },
      );
      await tester.pumpWidget(app);

      // Wait for tournament data to load
      await tester.pump();

      sendServerSocketMessages(TournamentController.socketUri(tournamenId), ['{"t": "reload"}']);
      // Wait for reload
      await tester.pump();

      // Wait for game screen to load
      await tester.pump();

      expect(find.byType(GameScreen), findsOneWidget);
      // wait for socket connection
      await tester.pump(kFakeWebSocketConnectionLag);
      sendServerSocketMessages(GameController.socketUri(gameId), [
        makeFullEvent(
          gameId.gameId,
          '',
          whiteUserName: authUser.user.name,
          blackUserName: 'Steven',
        ),
      ]);
      await tester.pump();
      expect(find.text('Steven'), findsOneWidget);
    });
  });
  testWidgets('Shows player details when tapping on a player', (WidgetTester tester) async {
    final mockClient = MockClient((request) {
      if (request.url.path == '/api/tournament/82QbxlJb') {
        return mockResponse(makeTournamentJson(standings: makeTestPlayers(10), nbPlayers: 11), 200);
      }
      if (request.url.path == '/tournament/82QbxlJb/player/player0') {
        return mockResponse(testTournamentPlayerResponse, 200);
      }
      return mockResponse('', 404);
    });

    final app = await makeTestProviderScopeApp(
      tester,
      home: const TournamentScreen(id: TournamentId('82QbxlJb')),
      overrides: {
        lichessClientProvider: lichessClientProvider.overrideWith((ref) {
          return LichessClient(mockClient, ref);
        }),
      },
    );
    await tester.pumpWidget(app);

    // Wait for tournament data to load
    await tester.pump();

    // Find a player in the standings and tap on them
    expect(find.text('player0'), findsOneWidget);
    await tester.tap(find.text('player0'));
    await tester.pump();

    // Wait for the modal bottom sheet to appear
    await tester.pumpAndSettle();

    // Verify player details are shown
    expect(find.text('#10'), findsOneWidget);
    expect(find.text('TestPlayer'), findsOneWidget);
    expect(find.text('2000'), findsOneWidget);

    // Verify stats are shown
    expect(find.text('Score'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('Performance'), findsOneWidget);
    expect(find.text('2150'), findsOneWidget);
    expect(find.text('Games played'), findsOneWidget);
    expect(find.text('3'), findsAtLeast(1));
    expect(find.text('Win rate'), findsOneWidget);
    expect(find.text('67%'), findsOneWidget); // 2 wins out of 3 games
    expect(find.text('Berserk rate'), findsOneWidget);
    expect(find.text('33%'), findsOneWidget); // 1 berserk out of 3 games

    // Verify pairings section
    expect(find.text('Games'), findsOneWidget);
    expect(find.text('Opponent1'), findsOneWidget);
    expect(find.text('Opponent2'), findsOneWidget);
    expect(find.text('Opponent3'), findsOneWidget);

    // Verify average opponent rating
    expect(find.text('Average opponent'), findsOneWidget);
    expect(find.text('2200'), findsOneWidget); // (1800 + 2100 + 2700) / 3

    // Test close button
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    // Verify modal is closed
    expect(find.text('TestPlayer'), findsNothing);
  });
}

const testTournamentPlayerResponse = '''
{
  "player": {
    "name": "TestPlayer",
    "id": "testplayer",
    "rating": 2000,
    "score": 5,
    "fire": true,
    "nb": {
      "game": 3,
      "berserk": 1,
      "win": 2
    },
    "performance": 2150,
    "rank": 10
  },
  "pairings": [
    {
      "id": "3CRj4xh2",
      "color": "white",
      "op": {
        "name": "Opponent1",
        "rating": 1800
      },
      "win": true,
      "status": 30,
      "score": 3,
      "berserk": true
    },
    {
      "id": "ibw09iwJ",
      "color": "black",
      "op": {
        "name": "Opponent2",
        "rating": 2100
      },
      "win": true,
      "status": 35,
      "score": 2
    },
    {
      "id": "ItAtgOBU",
      "color": "black",
      "op": {
        "name": "Opponent3",
        "rating": 2700
      },
      "win": false,
      "status": 30,
      "score": 0
    }
  ]
}
''';
