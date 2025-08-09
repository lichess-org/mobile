import 'package:deep_pick/deep_pick.dart';
import 'package:fake_async/fake_async.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/account/ongoing_game.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_repository.dart';
import 'package:lichess_mobile/src/model/game/exported_game.dart';
import 'package:lichess_mobile/src/model/message/message.dart';
import 'package:lichess_mobile/src/model/tournament/tournament.dart';
import 'package:lichess_mobile/src/model/tv/tv_repository.dart';
import 'package:lichess_mobile/src/model/user/streamer.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/aggregator.dart';
import 'package:lichess_mobile/src/network/http.dart';

import '../test_container.dart';
import '../test_helpers.dart';
import 'fake_http_client_factory.dart';
import 'http_test.dart';

void main() {
  setUp(() {
    FakeClient.reset();
  });

  Future<Aggregator> fakeClientAggregator() async {
    final container = await makeContainer(
      overrides: [
        httpClientFactoryProvider.overrideWith((ref) {
          return FakeHttpClientFactory(() => FakeClient());
        }),
      ],
    );
    return container.read(aggregatorProvider);
  }

  Future<Aggregator> mockClientAggregator(MockClient client) async {
    final container = await lichessClientContainer(client);
    return container.read(aggregatorProvider);
  }

  group('Aggregator', () {
    test('if only one request is made within 50ms, it will make an atomic request', () async {
      final aggregator = await fakeClientAggregator();
      final uri = Uri(path: '/api/test');

      final response = await aggregator.readJson(uri, mapper: (data) => data);

      final requests = FakeClient.verifyRequests();
      expect(requests.length, 1);
      expect(requests.first.url.path, uri.path);
      expect(response, isNotNull);
    });

    test('non supported uris will not aggregate and make atomic request after 50ms', () async {
      final aggregator = await fakeClientAggregator();

      final uri1 = Uri(path: '/api/test1');
      final uri2 = Uri(path: '/api/test2');

      fakeAsync((async) {
        aggregator.readJson(uri1, mapper: (data) => data);
        aggregator.readJson(uri2, mapper: (data) => data);

        async.elapse(const Duration(milliseconds: 50));

        // Check that the requests were made separately
        final requests = FakeClient.verifyRequests();
        expect(requests.length, 2);
      });
    });

    test('supported uris will still aggregate if the group is not complete', () async {
      int requestsCount = 0;

      final mockClient = MockClient((request) {
        requestsCount++;
        if (request.url.path == '/api/mobile/watch') {
          return mockResponse(watchEndpointResponse, 200);
        }
        return mockResponse('', 404);
      });

      final aggregator = await mockClientAggregator(mockClient);

      final broadcastUri = Uri(path: '/api/broadcast/top', queryParameters: {'page': '1'});
      final tvUri = Uri(path: '/api/tv/channels');

      final [broadcasts, channels] = await Future.wait([
        aggregator.readJson(broadcastUri, mapper: broadcastListFromServerJson),
        aggregator.readJson(tvUri, mapper: tvChannelsFromServerJson),
      ]);

      expect(requestsCount, 1);
      expect(broadcasts, isA<BroadcastList>());
      expect(channels, isA<TvChannels>());
    });

    test('aggregates watch endpoint', () async {
      int requestsCount = 0;

      final mockClient = MockClient((request) {
        requestsCount++;
        if (request.url.path == '/api/mobile/watch') {
          return mockResponse(watchEndpointResponse, 200);
        }
        return mockResponse('', 404);
      });

      final aggregator = await mockClientAggregator(mockClient);

      final broadcastUri = Uri(path: '/api/broadcast/top', queryParameters: {'page': '1'});
      final tvUri = Uri(path: '/api/tv/channels');
      final streamerUri = Uri(path: '/api/streamer/live');

      final [broadcasts, channels, streamers] = await Future.wait([
        aggregator.readJson(broadcastUri, mapper: broadcastListFromServerJson),
        aggregator.readJson(tvUri, mapper: tvChannelsFromServerJson),
        aggregator.readJsonList(streamerUri, mapper: Streamer.fromServerJson),
      ]);

      expect(requestsCount, 1);
      expect(broadcasts, isA<BroadcastList>());
      expect(channels, isA<TvChannels>());
      expect(streamers, isA<IList<Streamer>>());
    });

    test('aggregates home endpoint', () async {
      int requestsCount = 0;

      final mockClient = MockClient((request) {
        requestsCount++;
        if (request.url.path == '/api/mobile/home') {
          return mockResponse(homeEndpointResponse, 200);
        }
        return mockResponse('', 404);
      });

      final aggregator = await mockClientAggregator(mockClient);

      final accountUri = Uri(path: '/api/account', queryParameters: {'playban': '1'});
      final ongoingGamesUri = Uri(path: '/api/account/playing');
      final recentGamesUri = Uri(path: '/api/games/user/testuser');
      final tournamentsUri = Uri(path: '/tournament/featured');
      final inboxUri = Uri(path: '/inbox/unread-count');

      final [account, ongoingGames, recentGames, tournaments, inbox] = await Future.wait([
        aggregator.readJson(accountUri, mapper: User.fromServerJson),
        aggregator.readJson(ongoingGamesUri, mapper: ongoingGamesFromServerJson),
        aggregator.readNdJsonList(recentGamesUri, mapper: LightExportedGame.fromServerJson),
        aggregator.readJson(
          tournamentsUri,
          mapper: (Map<String, dynamic> json) => pick(json, 'featured').asTournamentListOrThrow(),
        ),
        aggregator.readJson(
          inboxUri,
          mapper: (Map<String, dynamic> json) {
            return (unread: json['unread'] as int, lichess: json['lichess'] as bool? ?? false);
          },
        ),
      ]);

      expect(requestsCount, 1);
      expect(account, isA<User>());
      expect(ongoingGames, isA<IList<OngoingGame>>());
      expect(recentGames, isA<IList<LightExportedGame>>());
      expect(tournaments, isA<IList<LightTournament>>());
      expect(inbox, isA<UnreadMessages>());
    });
  });
}

const watchEndpointResponse = '''
{
  "broadcast": {
    "active": [
      {
          "group": "Chennai Grandmasters Chess 2025",
          "round": {
              "createdAt": 1754493403483,
              "id": "lQ2hM0zG",
              "name": "Round 2",
              "ongoing": true,
              "rated": true,
              "slug": "round-2",
              "startsAt": 1754645400000,
              "url": "https://lichess.org/broadcast/chennai-grandmasters-chess-2025--masters/round-2/lQ2hM0zG"
          },
          "tour": {
              "createdAt": 1754493069659,
              "dates": [
                  1754559000000,
                  1755239400000
              ],
              "id": "AT6gq5Uq",
              "image": "https://image.lichess1.org/display?fmt=webp&h=400&op=thumbnail&path=relay:AT6gq5Uq:fKNqk30j.webp&w=800&sig=a1771f12984ee59439dd6edd4c15ed3c980e34c5",
              "info": {
                  "fideTc": "standard",
                  "format": "10-player round-robin",
                  "location": "Chennai, India",
                  "players": "Arjun, Giri, Keymer, Vidit, Van Foreest, Liang",
                  "standings": "https://s3.chess-results.com/tnrWZ.aspx?art=1&turdet=YES&SNode=S0&tno=1230063",
                  "tc": "90 min + 30 sec / move",
                  "timeZone": "Asia/Kolkata",
                  "website": "https://chennaigrandmasters.com/"
              },
              "name": "Chennai Grandmasters Chess 2025 | Masters",
              "slug": "chennai-grandmasters-chess-2025--masters",
              "tier": 5,
              "url": "https://lichess.org/broadcast/chennai-grandmasters-chess-2025--masters/AT6gq5Uq"
          }
      }
    ],
    "past": {
      "currentPage": 1,
      "currentPageResults": []
    }
  },
  "tv": {
    "best": {
        "color": "white",
        "gameId": "H4DPx15L",
        "rating": 2954,
        "user": {
            "id": "chessisnotfair",
            "name": "Chessisnotfair",
            "title": "GM"
        }
    },
    "blitz": {
        "color": "white",
        "gameId": "v3pIFdTz",
        "rating": 2615,
        "user": {
            "id": "gemivuk",
            "name": "gemivuk",
            "title": "GM"
        }
    },
    "bullet": {
        "color": "white",
        "gameId": "H4DPx15L",
        "rating": 2954,
        "user": {
            "id": "chessisnotfair",
            "name": "Chessisnotfair",
            "title": "GM"
        }
    }
  },
  "streamers": [
    {
        "flair": "activity.lichess",
        "id": "lichess",
        "name": "Lichess",
        "patron": true,
        "stream": {
            "lang": "en",
            "service": "twitch",
            "status": "ALMATY REGION OPEN 2025 ROUND 5"
        },
        "streamer": {
            "headline": "The home of official Lichess content",
            "image": "https://image.lichess1.org/display?fmt=webp&h=350&op=thumbnail&path=lichess:streamer:lichess:1IVq6jmE.jpg&w=350&sig=3466a874f301d17d6216e4b1d677e6c3ec9fe07e",
            "name": "Lichess",
            "twitch": "https://www.twitch.tv/lichessdotorg"
        }
    }
  ]
}
''';

const homeEndpointResponse = '''
{
  "account": {
    "id": "testUser",
    "username": "testUser",
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
  },
  "ongoingGames": [
    {
      "gameId": "rCRw1AuO",
      "fullId": "rCRw1AuOvonq",
      "color": "black",
      "fen": "r1bqkbnr/pppp2pp/2n1pp2/8/8/3PP3/PPPB1PPP/RN1QKBNR w KQkq - 2 4",
      "hasMoved": true,
      "isMyTurn": false,
      "lastMove": "b8c6",
      "opponent": {
        "id": "philippe",
        "rating": 1790,
        "username": "Philippe"
      },
      "perf": "correspondence",
      "rated": false,
      "secondsLeft": 1209600,
      "source": "friend",
      "speed": "correspondence",
      "variant": {
        "key": "standard",
        "name": "Standard"
      }
    }
  ],
  "recentGames": [
    {"id":"Huk88k3D","rated":false,"variant":"fromPosition","speed":"blitz","perf":"blitz","createdAt":1673716450321,"lastMoveAt":1673716450321,"status":"noStart","players":{"white":{"user":{"name":"MightyNanook","id":"mightynanook"},"rating":1116,"provisional":true},"black":{"user":{"name":"Thibault","patron":true,"id":"thibault"},"rating":1772}},"initialFen":"rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w - - 0 1","winner":"black","tournament":"ZZQ9tunK","clock":{"initial":300,"increment":0,"totalTime":300},"lastFen":"rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w - - 0 1"},
    {"id":"g2bzFol8","rated":true,"variant":"standard","speed":"blitz","perf":"blitz","createdAt":1673553626465,"lastMoveAt":1673553936657,"status":"resign","players":{"white":{"user":{"name":"SchallUndRausch","id":"schallundrausch"},"rating":1751,"ratingDiff":-5},"black":{"user":{"name":"Thibault","patron":true,"id":"thibault"},"rating":1767,"ratingDiff":5}},"winner":"black","clock":{"initial":180,"increment":2,"totalTime":260},"lastFen":"r7/pppk4/4p1B1/3pP3/6Pp/q1P1P1nP/P1QK1r2/R5R1 w - - 1 1"},
    {"id":"9WLmxmiB","rated":true,"variant":"standard","speed":"blitz","perf":"blitz","createdAt":1673553299064,"lastMoveAt":1673553615438,"status":"resign","players":{"white":{"user":{"name":"Dr-Alaakour","id":"dr-alaakour"},"rating":1806,"ratingDiff":5},"black":{"user":{"name":"Thibault","patron":true,"id":"thibault"},"rating":1772,"ratingDiff":-5}},"winner":"white","clock":{"initial":180,"increment":0,"totalTime":180},"lastFen":"2b1Q1k1/p1r4p/1p2p1p1/3pN3/2qP4/P4R2/1P3PPP/4R1K1 b - - 0 1"}
  ],
  "tournaments": [],
  "inbox": {
    "unread": 5
  }
}
''';
