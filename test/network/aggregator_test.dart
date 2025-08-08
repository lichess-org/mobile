import 'package:deep_pick/deep_pick.dart';
import 'package:fake_async/fake_async.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/account/ongoing_game.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_repository.dart';
import 'package:lichess_mobile/src/model/game/exported_game.dart';
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

    // test('aggregates home endpoint', () async {
    //   int requestsCount = 0;

    //   final mockClient = MockClient((request) {
    //     requestsCount++;
    //     if (request.url.path == '/api/mobile/home') {
    //       return mockResponse(watchEndpointResponse, 200);
    //     }
    //     return mockResponse('', 404);
    //   });

    //   final aggregator = await mockClientAggregator(mockClient);

    //   final accountUri = Uri(path: '/api/account', queryParameters: {'playban': '1'});
    //   final ongoingGamesUri = Uri(path: '/api/account/playing');
    //   final recentGamesUri = Uri(path: '/api/games/user/testuser');
    //   final tournamentsUri = Uri(path: '/tournament/featured');
    //   // final inboxUri = Uri(path: '/inbox/unread-count');

    //   final [account, ongoingGames, recentGames, tournaments] = await Future.wait([
    //     aggregator.readJson(accountUri, mapper: User.fromServerJson),
    //     aggregator.readJson(ongoingGamesUri, mapper: ongoingGamesFromServerJson),
    //     aggregator.readNdJsonList(recentGamesUri, mapper: LightExportedGame.fromServerJson),
    //     aggregator.readJson(tournamentsUri, mapper: (Map<String, dynamic> json) => pick(json, 'featured').asTournamentListOrThrow(),
    //   ]);

    //   expect(requestsCount, 1);
    // });
  // });
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
