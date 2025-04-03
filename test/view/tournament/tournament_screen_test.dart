import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/tournament/tournament.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
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
        (player) => '''
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
  "reloadEndpoint": "https://http.lichess.org/tournament/82QbxlJb"
}
''';
}

String makeReloadedTournamentJson({
  required List<StandingPlayer> standings,
  required int page,
  required int nbPlayers,
  TournamentMe? me,
  String featuredGameJson = '',
}) => '''
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
    testWidgets('Displays tournament data and standings', (WidgetTester tester) async {
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/tournament/82QbxlJb') {
          return mockResponse(
            makeTournamentJson(standings: makeTestPlayers(10), nbPlayers: 11),
            200,
          );
        }
        // Should use the reloadEndpoint field to reload the tournament
        if (request.url.path == '/https%253A//http.lichess.org/tournament/82QbxlJb' &&
            request.url.queryParameters['partial'] == 'true') {
          if (request.url.queryParameters['page'] == '1') {
            return mockResponse(
              makeReloadedTournamentJson(standings: makeTestPlayers(10), page: 1, nbPlayers: 11),
              200,
            );
          } else if (request.url.queryParameters['page'] == '2') {
            return mockResponse(
              makeReloadedTournamentJson(standings: makeTestPlayers(3), page: 2, nbPlayers: 13),
              200,
            );
          }
        }
        return mockResponse('', 404);
      });

      final app = await makeTestProviderScopeApp(
        tester,
        home: const TournamentScreen(id: TournamentId('82QbxlJb')),
        overrides: [
          lichessClientProvider.overrideWith((ref) {
            return LichessClient(mockClient, ref);
          }),
        ],
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

      expect(find.text('1-10 / 11'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.skip_next));
      // Wait for next page of standings to load
      await tester.pump();

      expect(find.text('player0'), findsOneWidget);
      expect(find.text('player1'), findsOneWidget);
      expect(find.text('player2'), findsOneWidget);
      expect(find.text('player3'), findsNothing);

      expect(find.text('11-13 / 13'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.first_page));
      // Wait for first page of standings to load
      await tester.pump();

      for (var i = 0; i < 10; i++) {
        expect(find.text('player$i'), findsOneWidget);
      }

      expect(find.text('1-10 / 11'), findsOneWidget);
    });

    testWidgets('Displays featured game', (WidgetTester tester) async {
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/tournament/82QbxlJb') {
          return mockResponse(
            makeTournamentJson(standings: makeTestPlayers(10), nbPlayers: 11),
            200,
          );
        }
        return mockResponse('', 404);
      });

      final fakeSocket = FakeWebSocketChannel();
      final app = await makeTestProviderScopeApp(
        tester,
        home: const TournamentScreen(id: TournamentId('82QbxlJb')),
        overrides: [
          lichessClientProvider.overrideWith((ref) {
            return LichessClient(mockClient, ref);
          }),
          webSocketChannelFactoryProvider.overrideWith(
            (ref) => FakeWebSocketChannelFactory((_) => fakeSocket),
          ),
        ],
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
      fakeSocket.addIncomingMessages([
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
        if (request.url.path == '/https%253A//http.lichess.org/tournament/82QbxlJb' &&
            request.url.queryParameters['partial'] == 'true') {
          if (request.url.queryParameters['page'] == '1') {
            return mockResponse(
              makeReloadedTournamentJson(
                me: (gameId: null, pauseDelay: null, rank: 11, withdraw: null),
                standings: makeTestPlayers(10),
                page: 1,
                nbPlayers: 12,
              ),
              200,
            );
          } else if (request.url.queryParameters['page'] == '2') {
            return mockResponse(
              makeReloadedTournamentJson(
                me: (gameId: null, pauseDelay: null, rank: 11, withdraw: null),
                standings: makeTestPlayers(2),
                page: 2,
                nbPlayers: 12,
              ),
              200,
            );
          }
        }
        return mockResponse('', 404);
      });

      const name = 'tom-anders';
      final user = LightUser(id: UserId.fromUserName(name), name: name);
      final session = AuthSessionState(user: user, token: 'test-token');

      final fakeSocket = FakeWebSocketChannel();
      final app = await makeTestProviderScopeApp(
        tester,
        home: const TournamentScreen(id: TournamentId('82QbxlJb')),
        userSession: session,
        overrides: [
          lichessClientProvider.overrideWith((ref) {
            return LichessClient(mockClient, ref);
          }),
          webSocketChannelFactoryProvider.overrideWith((ref) {
            return FakeWebSocketChannelFactory((_) => fakeSocket);
          }),
        ],
      );
      await tester.pumpWidget(app);

      // Wait for tournament data to load
      await tester.pump();

      expect(find.text('Join'), findsOneWidget);

      await tester.tap(find.text('Join'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Join'), findsNothing);

      fakeSocket.addIncomingMessages(['{"t": "reload"}']);
      // Wait for reload
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Join'), findsNothing);
      expect(find.text('Pause'), findsOneWidget);

      expect(find.byIcon(LichessIcons.target), findsOneWidget);
      // We're rank 11, so this should take us to the 2nd page
      await tester.tap(find.byIcon(LichessIcons.target));

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
        overrides: [
          lichessClientProvider.overrideWith((ref) {
            return LichessClient(mockClient, ref);
          }),
        ],
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
      final user = LightUser(id: UserId.fromUserName(name), name: name);
      final session = AuthSessionState(user: user, token: 'test-token');

      final fakeSocket = FakeWebSocketChannel();
      final app = await makeTestProviderScopeApp(
        tester,
        home: const TournamentScreen(id: TournamentId('82QbxlJb')),
        userSession: session,
        overrides: [
          lichessClientProvider.overrideWith((ref) {
            return LichessClient(mockClient, ref);
          }),
          webSocketChannelFactoryProvider.overrideWith((ref) {
            return FakeWebSocketChannelFactory((_) => fakeSocket);
          }),
        ],
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
      final user = LightUser(id: UserId.fromUserName(name), name: name);
      final session = AuthSessionState(user: user, token: 'test-token');

      final fakeTournamentSocket = FakeWebSocketChannel();
      final fakeGameSocket = FakeWebSocketChannel();
      final app = await makeTestProviderScopeApp(
        tester,
        home: const TournamentScreen(id: TournamentId('82QbxlJb')),
        userSession: session,
        overrides: [
          lichessClientProvider.overrideWith((ref) {
            return LichessClient(mockClient, ref);
          }),
          webSocketChannelFactoryProvider.overrideWith((ref) {
            return FakeWebSocketChannelFactory((String url) {
              final uri = Uri.parse(url);
              switch (uri.path) {
                case '/tournament/82QbxlJb/socket/v6':
                  return fakeTournamentSocket;
                case '/play/$gameId/v6':
                  return fakeGameSocket;
                default:
                  throw Exception('Unexpected URL: $url');
              }
            });
          }),
        ],
      );
      await tester.pumpWidget(app);

      // Wait for tournament data to load
      await tester.pump();

      fakeTournamentSocket.addIncomingMessages(['{"t": "reload"}']);
      // Wait for reload
      await tester.pump();

      // Wait for game screen to load
      await tester.pump();

      expect(find.byType(GameScreen), findsOneWidget);
      await fakeGameSocket.connectionEstablished;
      fakeGameSocket.addIncomingMessages([
        makeFullEvent(gameId.gameId, '', whiteUserName: session.user.name, blackUserName: 'Steven'),
      ]);
      // wait for socket message
      await tester.pump(const Duration(milliseconds: 10));
      expect(find.text('Steven'), findsOneWidget);
    });
  });
}
