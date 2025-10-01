import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/user/leaderboard.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/model/user/user_repository.dart';

import '../../test_container.dart';
import '../../test_helpers.dart';

const testUserId = UserId('test');

void main() {
  group('UserRepository.getUser', () {
    test('json read, minimal example', () async {
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/user/$testUserId') {
          return mockResponse('''
{
  "id": "$testUserId",
  "username": "$testUserId",
  "createdAt": 1290415680000,
  "seenAt": 1290415680000,
  "perfs": {
  }
}
''', 200);
        }
        return mockResponse('', 404);
      });
      final container = await lichessClientContainer(mockClient);

      final repo = container.read(userRepositoryProvider);

      final result = await repo.getUser(testUserId);

      expect(result, isA<User>());
      expect(result.id, testUserId);
    });

    test('json read, full example', () async {
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/user/$testUserId') {
          return mockResponse('''
{
  "id": "$testUserId",
  "username": "$testUserId",
  "createdAt": 1290415680000,
  "seenAt": 1290415680000,
  "title": "GM",
  "patron": true,
  "patronColor": 1,
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
''', 200);
        }
        return mockResponse('', 404);
      });
      final container = await lichessClientContainer(mockClient);
      final repo = container.read(userRepositoryProvider);

      final result = await repo.getUser(testUserId);

      expect(result, isA<User>());
      expect(result.id, testUserId);
      expect(result.title, 'GM');
      expect(result.profile?.country, 'France');
    });
  });

  group('UserRepository.getPerfStats', () {
    const testPerf = Perf.rapid;
    final path = '/api/user/$testUserId/perf/${testPerf.name}';

    test('json read, minimal example', () async {
      final mockClient = MockClient((request) {
        if (request.url.path == path) {
          return mockResponse('''
{
  "user": {
    "name": "$testUserId"
  },
  "perf": {
    "glicko": {
      "rating": 1500,
      "deviation": 50,
      "provisional": false
    },
    "nb": 5,
    "progress": 20
  },
  "stat": {
    "count": {
      "berserk": 0,
      "win": 2,
      "all": 5,
      "seconds": 10000,
      "opAvg": 1500,
      "draw": 1,
      "tour": 0,
      "disconnects": 1,
      "rated": 3,
      "loss": 2
    }
  }
}
''', 200);
        }
        return mockResponse('', 404);
      });

      final container = await lichessClientContainer(mockClient);
      final repo = container.read(userRepositoryProvider);

      final result = await repo.getPerfStats(testUserId, testPerf);

      expect(result, isA<UserPerfStats>());
      expect(result.rating, 1500);
    });

    test('json read, full example', () async {
      final mockClient = MockClient((request) {
        if (request.url.path == path) {
          return mockResponse('''
{
  "user": {
    "name": "testOpponentName"
  },
  "perf": {
    "glicko": {
      "rating": 1500.42,
      "deviation": 50.24,
      "provisional": false
    },
    "nb": 5,
    "progress": 20
  },
  "rank": 1000,
  "percentile": 50.0,
  "stat": {
    "count": {
      "berserk": 0,
      "win": 2,
      "all": 5,
      "seconds": 1000,
      "opAvg": 1400.63,
      "draw": 1,
      "tour": 0,
      "disconnects": 1,
      "rated": 3,
      "loss": 2
    },
    "resultStreak": {
      "win": {
        "cur": {
          "v": 9,
          "from": {
            "at": "2023-01-12T03:36:37.842Z",
            "gameId": "ABcDeFgH"
          },
          "to": {
            "at": "2023-01-20T16:25:56.430Z",
            "gameId": "ABcDeFgH"
          }
        },
        "max": {
          "v": 9,
          "from": {
            "at": "2023-01-12T03:36:37.842Z",
            "gameId": "ABcDeFgH"
          },
          "to": {
            "at": "2023-01-20T16:25:56.430Z",
            "gameId": "ABcDeFgH"
          }
        }
      },
      "loss": {
        "cur": {
          "v": 0
        },
        "max": {
          "v": 3,
          "from": {
            "at": "2023-01-11T05:57:14.547Z",
            "gameId": "ABcDeFgH"
          },
          "to": {
            "at": "2023-01-11T06:52:05.350Z",
            "gameId": "ABcDeFgH"
          }
        }
      }
    },
    "lowest": {
      "int": 1336,
      "at": "2022-11-26T20:09:57.711Z",
      "gameId": "ABcDeFgH"
    },
    "_id": "danteculaciati/6",
    "worstLosses": {
      "results": [
        {
          "opRating": 1300,
          "opId": {
            "id": "testOpponent",
            "name": "testOpponentName",
            "title": null
          },
          "at": "2022-12-22T06:08:21.870Z",
          "gameId": "ABcDeFgH"
        },
        {
          "opRating": 1303,
          "opId": {
            "id": "testOpponent",
            "name": "testOpponentName",
            "title": null
          },
          "at": "2022-11-09T13:54:12.015Z",
          "gameId": "ABcDeFgH"
        },
        {
          "opRating": 1309,
          "opId": {
            "id": "testOpponent",
            "name": "testOpponentName",
            "title": null
          },
          "at": "2022-11-18T03:12:53.063Z",
          "gameId": "ABcDeFgH"
        },
        {
          "opRating": 1310,
          "opId": {
            "id": "testOpponent",
            "name": "testOpponentName",
            "title": null
          },
          "at": "2022-11-26T20:09:57.711Z",
          "gameId": "ABcDeFgH"
        },
        {
          "opRating": 1321,
          "opId": {
            "id": "testOpponent",
            "name": "testOpponentName",
            "title": null
          },
          "at": "2023-01-04T22:14:53.251Z",
          "gameId": "ABcDeFgH"
        }
      ]
    },
    "perfType": {
      "key": "rapid",
      "name": "testOpponentName"
    },
    "bestWins": {
      "results": [
        {
          "opRating": 1553,
          "opId": {
            "id": "testOpponent",
            "name": "testOpponentName",
            "title": null
          },
          "at": "2023-01-12T04:40:28.644Z",
          "gameId": "ABcDeFgH"
        },
        {
          "opRating": 1532,
          "opId": {
            "id": "testOpponent",
            "name": "testOpponentName",
            "title": null
          },
          "at": "2023-01-10T07:24:30.636Z",
          "gameId": "ABcDeFgH"
        },
        {
          "opRating": 1509,
          "opId": {
            "id": "testOpponent",
            "name": "testOpponentName",
            "title": null
          },
          "at": "2023-01-12T05:10:05.648Z",
          "gameId": "ABcDeFgH"
        },
        {
          "opRating": 1496,
          "opId": {
            "id": "testOpponent",
            "name": "testOpponentName",
            "title": null
          },
          "at": "2023-01-08T20:48:46.087Z",
          "gameId": "ABcDeFgH"
        },
        {
          "opRating": 1496,
          "opId": {
            "id": "testOpponent",
            "name": "testOpponentName",
            "title": null
          },
          "at": "2023-01-12T03:51:59.617Z",
          "gameId": "ABcDeFgH"
        }
      ]
    },
    "userId": {
      "id": "$testUserId",
      "name": "$testUserId",
      "title": null
    },
    "playStreak": {
      "nb": {
        "cur": {
          "v": 0
        },
        "max": {
          "v": 7,
          "from": {
            "at": "2023-01-12T03:28:45.629Z",
            "gameId": "ABcDeFgH"
          },
          "to": {
            "at": "2023-01-12T05:10:05.648Z",
            "gameId": "ABcDeFgH"
          }
        }
      },
      "time": {
        "cur": {
          "v": 0
        },
        "max": {
          "v": 5237,
          "from": {
            "at": "2023-01-11T05:37:11.306Z",
            "gameId": "ABcDeFgH"
          },
          "to": {
            "at": "2023-01-11T07:23:22.095Z",
            "gameId": "ABcDeFgH"
          }
        }
      },
      "lastDate": "2023-01-20T16:25:56.430Z"
    },
    "highest": {
      "int": 1515,
      "at": "2023-01-20T16:25:56.430Z",
      "gameId": "ABcDeFgH"
    }
  }
}
''', 200);
        }
        return mockResponse('', 404);
      });

      final container = await lichessClientContainer(mockClient);
      final repo = container.read(userRepositoryProvider);

      final result = await repo.getPerfStats(testUserId, testPerf);

      expect(result, isA<UserPerfStats>());
      expect(result.rating, 1500.42);
      expect(result.bestWins?.length, 5);
      expect(result.worstLosses?.length, 5);
      expect(result.rank, 1000);
    });
  });

  group('UserRepository.getUsersStatuses', () {
    test('json read, minimal example', () async {
      final ids = ISet(const {UserId('maia1'), UserId('maia5'), UserId('maia9')});

      final mockClient = MockClient((request) {
        if (request.url.path == '/api/users/status') {
          return mockResponse('[]', 200);
        }
        return mockResponse('', 404);
      });

      final container = await lichessClientContainer(mockClient);
      final repo = container.read(userRepositoryProvider);
      final result = await repo.getUsersStatuses(ids);

      expect(result, isA<IList<UserStatus>>());
      expect(result.isEmpty, true);
    });

    test('json read, full example', () async {
      final ids = ISet(const {UserId('maia1'), UserId('maia5'), UserId('maia9')});
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/users/status') {
          return mockResponse('''
[
  {
    "id": "maia1",
    "name": "maia1",
    "online": true,
    "playing": true
  },
  {
    "id": "maia5",
    "name": "maia5",
    "online": false
  },
  {
    "id": "maia9",
    "name": "maia9",
    "online": true
  }
]
''', 200);
        }
        return mockResponse('', 404);
      });

      final container = await lichessClientContainer(mockClient);
      final repo = container.read(userRepositoryProvider);
      final result = await repo.getUsersStatuses(ids);

      expect(result, isA<IList<UserStatus>>());
      expect(result.length, 3);
    });
  });

  group('UserRepository.getTop1', () {
    const res = '''
{"bullet":{"id":"svetlana","username":"Svetlana","perfs":{"bullet":{"rating":2340,"progress":0}},"patron":true},"blitz":{"id":"marcel","username":"Marcel","perfs":{"blitz":{"rating":2520,"progress":0}}},"rapid":{"id":"anthony","username":"Anthony","perfs":{"rapid":{"rating":2413,"progress":0}}},"classical":{"id":"marcel","username":"Marcel","perfs":{"classical":{"rating":2521,"progress":0}}},"ultraBullet":{"id":"marcel","username":"Marcel","perfs":{"ultraBullet":{"rating":2648,"progress":0}}}}
      ''';

    test('json read, minimal example', () async {
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/player/top/1/standard') {
          return mockResponse(res, 200);
        }
        return mockResponse('', 404);
      });

      final container = await lichessClientContainer(mockClient);
      final repo = container.read(userRepositoryProvider);

      final result = await repo.getTop1();

      expect(result, isA<IMap<Perf, LeaderboardUser>>());
      expect(result.length, 5);
    });
  });

  group('UserRepository.getLeaderboard', () {
    const testRes = '''
{"bullet":[{"id":"penguingim1","username":"penguingim1","perfs":{"bullet":{"rating":3302,"progress":10}},"title":"GM","patron":true},{"id":"arm-777777","username":"ARM-777777","perfs":{"bullet":{"rating":3145,"progress":8}},"title":"GM"},{"id":"hooligan64","username":"Hooligan64","perfs":{"bullet":{"rating":3131,"progress":7}},"title":"GM"},{"id":"muisback","username":"muisback","perfs":{"bullet":{"rating":3123,"progress":28}},"title":"GM","patron":true},{"id":"night-king96","username":"Night-King96","perfs":{"bullet":{"rating":3122,"progress":-14}},"title":"GM","patron":true},{"id":"svodmevko","username":"SVODMEVKO","perfs":{"bullet":{"rating":3119,"progress":4}},"title":"GM"},{"id":"shant7777777","username":"Shant7777777","perfs":{"bullet":{"rating":3100,"progress":17}},"title":"GM"},{"id":"sparta299","username":"Sparta299","perfs":{"bullet":{"rating":3085,"progress":21}},"title":"GM"},{"id":"ohanyaneminchess","username":"OhanyanEminChess","perfs":{"bullet":{"rating":3082,"progress":-50}},"title":"IM"},{"id":"watneg","username":"Watneg","perfs":{"bullet":{"rating":3080,"progress":14}},"title":"GM"}],
"blitz":[{"id":"may6enexttime","username":"may6enexttime","perfs":{"blitz":{"rating":3015,"progress":26}},"title":"GM","patron":true},{"id":"konevlad","username":"Konevlad","perfs":{"blitz":{"rating":3002,"progress":-10}},"title":"GM"},{"id":"howardxue","username":"HowardXue","perfs":{"blitz":{"rating":2965,"progress":62}}},{"id":"a-liang","username":"A-Liang","perfs":{"blitz":{"rating":2960,"progress":32}}},{"id":"avs2000","username":"AVS2000","perfs":{"blitz":{"rating":2959,"progress":21}},"title":"GM","online":true},{"id":"powerfulstorm","username":"Powerfulstorm","perfs":{"blitz":{"rating":2959,"progress":-3}}},{"id":"kelevra317","username":"Kelevra317","perfs":{"blitz":{"rating":2954,"progress":9}},"title":"GM"},{"id":"arm-777777","username":"ARM-777777","perfs":{"blitz":{"rating":2952,"progress":20}},"title":"GM"},{"id":"shant7777777","username":"Shant7777777","perfs":{"blitz":{"rating":2951,"progress":23}},"title":"GM"},{"id":"arseniii_nesterov","username":"Arseniii_Nesterov","perfs":{"blitz":{"rating":2951,"progress":6}},"title":"GM"}],
"rapid":[{"id":"drvitman","username":"Drvitman","perfs":{"rapid":{"rating":3062,"progress":25}},"title":"GM","patron":true},{"id":"realdavidnavara","username":"RealDavidNavara","perfs":{"rapid":{"rating":2943,"progress":-13}},"title":"GM","patron":true},{"id":"drawdenied_twitch","username":"DrawDenied_Twitch","perfs":{"rapid":{"rating":2886,"progress":9}},"title":"GM"},{"id":"ragadingdong","username":"Ragadingdong","perfs":{"rapid":{"rating":2869,"progress":22}}},{"id":"rakhmanov_aleksandr","username":"Rakhmanov_Aleksandr","perfs":{"rapid":{"rating":2861,"progress":62}},"title":"GM","patron":true},{"id":"grxbullet","username":"GRXbullet","perfs":{"rapid":{"rating":2818,"progress":-30}},"patron":true},{"id":"think_fast_move_fast","username":"Think_Fast_Move_Fast","perfs":{"rapid":{"rating":2801,"progress":-15}},"title":"FM"},{"id":"vvchessli","username":"vvchessli","perfs":{"rapid":{"rating":2789,"progress":43}},"title":"IM"},{"id":"tusxkey","username":"tusxkey","perfs":{"rapid":{"rating":2773,"progress":6}}},{"id":"lance5500","username":"Lance5500","perfs":{"rapid":{"rating":2771,"progress":63}},"title":"LM","patron":true}],
"classical":[{"id":"mikolka1985","username":"mikolka1985","perfs":{"classical":{"rating":2599,"progress":36}},"title":"GM","patron":true},{"id":"unkreativ3","username":"Unkreativ3","perfs":{"classical":{"rating":2583,"progress":23}},"title":"FM","patron":true},{"id":"injooker","username":"InjooKer","perfs":{"classical":{"rating":2564,"progress":22}}},{"id":"lance5500","username":"Lance5500","perfs":{"classical":{"rating":2526,"progress":6}},"title":"LM","patron":true},{"id":"noplex","username":"Noplex","perfs":{"classical":{"rating":2486,"progress":32}}},{"id":"billiejoe","username":"BillieJoe","perfs":{"classical":{"rating":2477,"progress":-45}},"title":"FM"},{"id":"lewton","username":"Lewton","perfs":{"classical":{"rating":2462,"progress":15}}},{"id":"kc6","username":"kc6","perfs":{"classical":{"rating":2461,"progress":-25}},"title":"IM","online":true},{"id":"cheretand","username":"Cheretand","perfs":{"classical":{"rating":2459,"progress":20}}},{"id":"ragehunter","username":"Ragehunter","perfs":{"classical":{"rating":2453,"progress":9}},"title":"FM"}],
"ultraBullet":[{"id":"blazinq","username":"Blazinq","perfs":{"ultraBullet":{"rating":2590,"progress":8}},"title":"FM","patron":true},{"id":"aaryan_varshney","username":"aaryan_varshney","perfs":{"ultraBullet":{"rating":2582,"progress":15}},"title":"FM","patron":true},{"id":"ohanyaneminchess","username":"OhanyanEminChess","perfs":{"ultraBullet":{"rating":2511,"progress":-52}},"title":"IM"},{"id":"ragehunter","username":"Ragehunter","perfs":{"ultraBullet":{"rating":2507,"progress":12}},"title":"FM"},{"id":"think_fast_move_fast","username":"Think_Fast_Move_Fast","perfs":{"ultraBullet":{"rating":2501,"progress":24}},"title":"FM"},{"id":"dotaislife","username":"dotaislife","perfs":{"ultraBullet":{"rating":2496,"progress":-8}}},{"id":"iliketowin69","username":"iliketowin69","perfs":{"ultraBullet":{"rating":2495,"progress":-25}}},{"id":"volleybot","username":"Volleybot","perfs":{"ultraBullet":{"rating":2449,"progress":17}},"online":true},{"id":"tamojerry","username":"tamojerry","perfs":{"ultraBullet":{"rating":2443,"progress":14}},"title":"FM"},{"id":"roadtofm-l","username":"RoadToFM-L","perfs":{"ultraBullet":{"rating":2430,"progress":-7}}}],
"crazyhouse":[{"id":"variantsonly","username":"VariantsOnly","perfs":{"crazyhouse":{"rating":2706,"progress":23}},"patron":true},{"id":"crazy_eight","username":"Crazy_Eight","perfs":{"crazyhouse":{"rating":2680,"progress":-21}},"title":"FM"},{"id":"grxbullet","username":"GRXbullet","perfs":{"crazyhouse":{"rating":2655,"progress":27}},"patron":true},{"id":"legiondestroyer","username":"LegionDestroyer","perfs":{"crazyhouse":{"rating":2641,"progress":-24}}},{"id":"craze","username":"Craze","perfs":{"crazyhouse":{"rating":2617,"progress":-25}},"title":"GM","patron":true},{"id":"oldhas-been","username":"OldHas-Been","perfs":{"crazyhouse":{"rating":2607,"progress":16}},"patron":true},{"id":"sportsfanatic","username":"SportsFanatic","perfs":{"crazyhouse":{"rating":2583,"progress":12}}},{"id":"mulder00","username":"mulder00","perfs":{"crazyhouse":{"rating":2579,"progress":-18}}},{"id":"cammie_nator","username":"Cammie_Nator","perfs":{"crazyhouse":{"rating":2576,"progress":-30}}},{"id":"greeen_beast","username":"greeen_beast","perfs":{"crazyhouse":{"rating":2574,"progress":-13}}}],
"chess960":[{"id":"zhigalko_sergei","username":"Zhigalko_Sergei","perfs":{"chess960":{"rating":2735,"progress":8}},"title":"GM","patron":true,"online":true},{"id":"zubrrr","username":"Zubrrr","perfs":{"chess960":{"rating":2605,"progress":13}},"title":"IM"},{"id":"cheerychocolate","username":"CheeryChocolate","perfs":{"chess960":{"rating":2601,"progress":26}},"online":true},{"id":"realdavidnavara","username":"RealDavidNavara","perfs":{"chess960":{"rating":2576,"progress":0}},"title":"GM","patron":true},{"id":"ragehunter","username":"Ragehunter","perfs":{"chess960":{"rating":2570,"progress":14}},"title":"FM"},{"id":"ragadingdong","username":"Ragadingdong","perfs":{"chess960":{"rating":2565,"progress":1}}},{"id":"aqua_blazing","username":"Aqua_Blazing","perfs":{"chess960":{"rating":2531,"progress":7}}},{"id":"andrey11976","username":"Andrey11976","perfs":{"chess960":{"rating":2523,"progress":28}},"patron":true},{"id":"goldbart","username":"Goldbart","perfs":{"chess960":{"rating":2515,"progress":21}}},{"id":"uncatchable_j0e","username":"uncatchable_j0e","perfs":{"chess960":{"rating":2512,"progress":15}}}],
"kingOfTheHill":[{"id":"zhigalko_sergei","username":"Zhigalko_Sergei","perfs":{"kingOfTheHill":{"rating":2612,"progress":21}},"title":"GM","patron":true,"online":true},{"id":"zubrrr","username":"Zubrrr","perfs":{"kingOfTheHill":{"rating":2515,"progress":2}},"title":"IM"},{"id":"homayooont","username":"HomayooonT","perfs":{"kingOfTheHill":{"rating":2501,"progress":-2}},"title":"GM"},{"id":"ragadingdong","username":"Ragadingdong","perfs":{"kingOfTheHill":{"rating":2495,"progress":24}}},{"id":"ragehunter","username":"Ragehunter","perfs":{"kingOfTheHill":{"rating":2486,"progress":28}},"title":"FM"},{"id":"chess_is_life23","username":"Chess_Is_Life23","perfs":{"kingOfTheHill":{"rating":2483,"progress":12}}},{"id":"lion2006-45","username":"lion2006-45","perfs":{"kingOfTheHill":{"rating":2453,"progress":14}}},{"id":"aqua_blazing","username":"Aqua_Blazing","perfs":{"kingOfTheHill":{"rating":2435,"progress":21}}},{"id":"andrey11976","username":"Andrey11976","perfs":{"kingOfTheHill":{"rating":2432,"progress":20}},"patron":true},{"id":"zu_cho_chi","username":"Zu_Cho_Chi","perfs":{"kingOfTheHill":{"rating":2429,"progress":7}},"patron":true}],
"threeCheck":[{"id":"zhigalko_sergei","username":"Zhigalko_Sergei","perfs":{"threeCheck":{"rating":2603,"progress":2}},"title":"GM","patron":true,"online":true},{"id":"variantsonly","username":"VariantsOnly","perfs":{"threeCheck":{"rating":2513,"progress":5}},"patron":true},{"id":"zu_cho_chi","username":"Zu_Cho_Chi","perfs":{"threeCheck":{"rating":2444,"progress":25}},"patron":true},{"id":"lyxxj","username":"lyxxj","perfs":{"threeCheck":{"rating":2415,"progress":8}}},{"id":"troubadix_18","username":"Troubadix_18","perfs":{"threeCheck":{"rating":2411,"progress":26}}},{"id":"luukdegrote","username":"LuukDeGrote","perfs":{"threeCheck":{"rating":2397,"progress":-5}},"title":"FM","patron":true},{"id":"ragadingdong","username":"Ragadingdong","perfs":{"threeCheck":{"rating":2393,"progress":31}}},{"id":"champblair","username":"champblair","perfs":{"threeCheck":{"rating":2374,"progress":-9}},"title":"CM"},{"id":"rayholt","username":"RayHolt","perfs":{"threeCheck":{"rating":2364,"progress":-26}}},{"id":"magners","username":"Magners","perfs":{"threeCheck":{"rating":2359,"progress":3}},"title":"IM"}],
"antichess":[{"id":"abbysunterra","username":"AbbySunterra","perfs":{"antichess":{"rating":2389,"progress":29}},"online":true},{"id":"pepsingaming","username":"PepsiNGaming","perfs":{"antichess":{"rating":2361,"progress":-17}},"patron":true},{"id":"schizophrenic_energy","username":"Schizophrenic_Energy","perfs":{"antichess":{"rating":2353,"progress":16}}},{"id":"tetiksh1agrawal","username":"Tetiksh1Agrawal","perfs":{"antichess":{"rating":2338,"progress":13}}},{"id":"antichess_valentino","username":"Antichess_Valentino","perfs":{"antichess":{"rating":2331,"progress":4}}},{"id":"tolius","username":"tolius","perfs":{"antichess":{"rating":2331,"progress":10}},"patron":true},{"id":"bestman21","username":"BESTMAN21","perfs":{"antichess":{"rating":2324,"progress":14}}},{"id":"allegro_moon","username":"Allegro_Moon","perfs":{"antichess":{"rating":2317,"progress":14}}},{"id":"kotov_syndrome","username":"Kotov_Syndrome","perfs":{"antichess":{"rating":2317,"progress":40}},"patron":true},{"id":"donotchangeopening","username":"DoNotChangeOpening","perfs":{"antichess":{"rating":2317,"progress":-35}}}],
"atomic":[{"id":"sutcunuri","username":"sutcunuri","perfs":{"atomic":{"rating":2473,"progress":6}},"title":"CM"},{"id":"pashpash","username":"pashpash","perfs":{"atomic":{"rating":2391,"progress":20}},"title":"NM"},{"id":"chrisrapid","username":"chrisrapid","perfs":{"atomic":{"rating":2386,"progress":6}}},{"id":"ardavan74","username":"Ardavan74","perfs":{"atomic":{"rating":2331,"progress":1}}},{"id":"crepuscular","username":"Crepuscular","perfs":{"atomic":{"rating":2316,"progress":3}}},{"id":"dr-mad_atomic","username":"dR-mAd_aToMiC","perfs":{"atomic":{"rating":2313,"progress":6}}},{"id":"peradventure","username":"peradventure","perfs":{"atomic":{"rating":2305,"progress":8}}},{"id":"vannt-o","username":"Vannt-o","perfs":{"atomic":{"rating":2303,"progress":-8}}},{"id":"magners","username":"Magners","perfs":{"atomic":{"rating":2295,"progress":50}},"title":"IM"},{"id":"hysterix","username":"Hysterix","perfs":{"atomic":{"rating":2290,"progress":23}},"patron":true}],
"horde":[{"id":"rayholt","username":"RayHolt","perfs":{"horde":{"rating":2810,"progress":9}}},{"id":"stubenfisch","username":"Stubenfisch","perfs":{"horde":{"rating":2756,"progress":2}},"patron":true},{"id":"blazinq","username":"Blazinq","perfs":{"horde":{"rating":2602,"progress":33}},"title":"FM","patron":true},{"id":"sinamon73","username":"Sinamon73","perfs":{"horde":{"rating":2594,"progress":-3}},"patron":true},{"id":"hod-konem96","username":"hod-konem96","perfs":{"horde":{"rating":2571,"progress":0}}},{"id":"golden-horde","username":"Golden-Horde","perfs":{"horde":{"rating":2571,"progress":6}}},{"id":"shreyas_adimulam","username":"Shreyas_Adimulam","perfs":{"horde":{"rating":2564,"progress":-12}},"online":true},{"id":"aar_77on","username":"Aar_77on","perfs":{"horde":{"rating":2527,"progress":10}}},{"id":"roadtofm-l","username":"RoadToFM-L","perfs":{"horde":{"rating":2526,"progress":-13}}},{"id":"ragehunter","username":"Ragehunter","perfs":{"horde":{"rating":2522,"progress":-11}},"title":"FM"}],
"racingKings":[{"id":"royalmaniac","username":"RoyalManiac","perfs":{"racingKings":{"rating":2499,"progress":13}},"patron":true},{"id":"cybershredder","username":"CyberShredder","perfs":{"racingKings":{"rating":2408,"progress":20}}},{"id":"queeneatingdragon","username":"QueenEatingDragon","perfs":{"racingKings":{"rating":2388,"progress":-14}}},{"id":"seth_7777777","username":"seth_7777777","perfs":{"racingKings":{"rating":2387,"progress":7}}},{"id":"huangyudong","username":"huangyudong","perfs":{"racingKings":{"rating":2342,"progress":-8}}},{"id":"natso","username":"Natso","perfs":{"racingKings":{"rating":2339,"progress":13}},"patron":true},{"id":"imakemanymistakes","username":"IMakeManyMistakes","perfs":{"racingKings":{"rating":2333,"progress":-7}}},{"id":"peanutbutter12345","username":"Peanutbutter12345","perfs":{"racingKings":{"rating":2321,"progress":-3}},"patron":true},{"id":"walker_22","username":"Walker_22","perfs":{"racingKings":{"rating":2316,"progress":-1}}},{"id":"artem_medvedev-04","username":"Artem_Medvedev-04","perfs":{"racingKings":{"rating":2274,"progress":10}}}]}
''';
    test('get leaderboard', () async {
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/player') {
          return mockResponse(testRes, 200);
        }
        return mockResponse('', 404);
      });

      final container = await lichessClientContainer(mockClient);
      final repo = container.read(userRepositoryProvider);

      final result = await repo.getLeaderboard();

      expect(result, isA<Leaderboard>());
      expect(result.bullet.length, 10);
    });
  });

  test('UserRepository.getUserActivity minimal example', () async {
    final mockClient = MockClient((request) {
      if (request.url.path == '/api/user/testUser/activity') {
        return mockResponse(userActivityResponse, 200);
      }
      return mockResponse('', 404);
    });

    final container = await lichessClientContainer(mockClient);
    final repo = container.read(userRepositoryProvider);
    final result = await repo.getActivity(const UserId('testUser'));

    expect(result, isA<IList<UserActivity>>());
    expect(result.length, 7);
  });
}

const userActivityResponse = '''
[{"interval":{"start":1681948800000,"end":1682035200000},"follows":{"in":{"ids":["jc-peru","supercarro"]}}},{"interval":{"start":1681862400000,"end":1681948800000},"puzzles":{"score":{"win":6,"loss":0,"draw":0,"rp":{"before":2677,"after":2736}}},"follows":{"in":{"ids":["hayden1461","ilyas-basit","senjukuwaragi","deinchayamagmeinetns","chesswgm","wojciechstark","albertlem","zokirov9292","marcosmm11","merinovegor_13-7","umitaliacar","jamespro0221","jacky09","daniel1028","adison98"],"nb":23}}},{"interval":{"start":1681776000000,"end":1681862400000},"follows":{"in":{"ids":["drceltic","dominikk33king","sir-gianortega-13","epergalth57w","hojjat1368","thebarin1","geoff123","betul38","benjaminh12675","sivtsovvanya","darkpattern","osmaneren47","drgregoryhouseee","kayratitiz","nonvincoseperdo"],"nb":18}}},{"interval":{"start":1681689600000,"end":1681776000000},"games":{"ultraBullet":{"win":10,"loss":0,"draw":0,"rp":{"before":2745,"after":2769}},"bullet":{"win":5,"loss":3,"draw":0,"rp":{"before":3081,"after":3074}},"rapid":{"win":1,"loss":0,"draw":0,"rp":{"before":2611,"after":2625}}},"follows":{"in":{"ids":["thefateofall","mario6ajedrez","rajveergrover1232","ykylas2014","se7vthe","muhamed12143","kdmfan","trantuankhachess","admsamohamad","sakurablossoms","freeeeeeeze1","ata201200x","mbmohnish","alex_dchig","alikhan-7"],"nb":18}}},{"interval":{"start":1681603200000,"end":1681689600000},"puzzles":{"score":{"win":24,"loss":10,"draw":0,"rp":{"before":2628,"after":2677}}},"follows":{"in":{"ids":["dalibord","musfik050390","xqliotvgm","momdsamu","radiantranger64","aarohdeshmukhihsdl","baggirou","grandmasterflash95","wo0do","leon_pogosian2009","anandhu_sadurangam","ane_mnda_bng","nek-ngatiem","haider123","j03l5065igu3z"],"nb":19}}},{"interval":{"start":1681516800000,"end":1681603200000},"games":{"bullet":{"win":40,"loss":30,"draw":5,"rp":{"before":3097,"after":3081}},"ultraBullet":{"win":14,"loss":5,"draw":2,"rp":{"before":2717,"after":2745}},"threeCheck":{"win":2,"loss":0,"draw":0,"rp":{"before":2575,"after":2588}}},"tournaments":{"nb":1,"best":[{"tournament":{"id":"apr23lta","name":"Titled Arena April '23"},"nbGames":73,"score":124,"rank":3,"rankPercent":1}]},"follows":{"in":{"ids":["ikoroduboy","noahlz","behnamjafarii","tutam","nikmakval","x73marda","torretalkantar","jurassicpark00","zubera1","lionel2schmidt","abhi73","sakumi_chess","dabolistic2","like2readbooks","ojaykings"],"nb":53}}},{"interval":{"start":1681430400000,"end":1681516800000},"follows":{"in":{"ids":["talabra","mooshroom42","granpandita","imraaaa_li","relaxplayer","qwwerty","ivanchu26","nyrav_chess_beast","newfloki","m0xvtwio","jumanak","rakeshmajumder10","jeanlucpicard7","sparrowtang","iamsickmind"],"nb":27}}}]
''';
