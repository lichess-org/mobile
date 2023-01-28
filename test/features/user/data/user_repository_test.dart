import 'package:flutter_test/flutter_test.dart';
import 'package:async/async.dart';
import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

import 'package:lichess_mobile/src/common/http.dart';
import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/features/user/data/user_repository.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockLogger extends Mock implements Logger {}

const testUserId = 'test';

void main() {
  final mockLogger = MockLogger();
  final mockApiClient = MockApiClient();
  final repo = UserRepository(apiClient: mockApiClient, logger: mockLogger);

  setUpAll(() {
    reset(mockApiClient);
  });

  group('UserRepository.getUserTask', () {
    test('json read, minimal example', () async {
      const testUserResponseMinimal = '''
{
  "id": "$testUserId",
  "username": "$testUserId",
  "createdAt": 1290415680000,
  "seenAt": 1290415680000,
  "perfs": {
  }
}
''';
      when(() => mockApiClient
              .get(Uri.parse('$kLichessHost/api/user/$testUserId')))
          .thenAnswer((_) async =>
              Result.value(http.Response(testUserResponseMinimal, 200)));

      final result = await repo.getUser(testUserId);

      expect(result.isValue, true);
    });

    test('json read, full example', () async {
      const testUserResponse = '''
{
  "id": "$testUserId",
  "username": "$testUserId",
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
      when(() => mockApiClient
              .get(Uri.parse('$kLichessHost/api/user/$testUserId')))
          .thenAnswer(
              (_) async => Result.value(http.Response(testUserResponse, 200)));

      final result = await repo.getUser(testUserId);

      expect(result.isValue, true);
    });
  });

  group('UserRepository.getUserPerfStatsTask', () {
    const testPerf = Perf.rapid;
    final uriString =
        '$kLichessHost/api/user/$testUserId/perf/${testPerf.name}';
    test('json read, minimal example', () async {
      const responseMinimal = '''
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
''';
      when(() => mockApiClient.get(Uri.parse(uriString))).thenAnswer(
          (_) async => Result.value(http.Response(responseMinimal, 200)));

      final result = await repo.getUserPerfStats(testUserId, testPerf);

      expect(result.isValue, true);
    });

    test('json read, full example', () async {
      const responseFull = '''
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
''';
      when(() => mockApiClient.get(Uri.parse(uriString))).thenAnswer(
          (_) async => Result.value(http.Response(responseFull, 200)));

      final result = await repo.getUserPerfStats(testUserId, testPerf);

      expect(result.isValue, true);
    });
  });

  group('UserRepository.getUsersStatusTask', () {
    test('json read, minimal example', () async {
      final ids = ['maia1', 'maia5', 'maia9'];
      when(() => mockApiClient.get(
              Uri.parse('$kLichessHost/api/users/status?ids=${ids.join(',')}')))
          .thenAnswer((_) async => Result.value(http.Response('[]', 200)));

      final result = await repo.getUsersStatus(ids);

      expect(result.isValue, true);
    });

    test('json read, full example', () async {
      const response = '''
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
''';
      final ids = ['maia1', 'maia5', 'maia9'];
      when(() => mockApiClient.get(
              Uri.parse('$kLichessHost/api/users/status?ids=${ids.join(',')}')))
          .thenAnswer((_) async => Result.value(http.Response(response, 200)));

      final result = await repo.getUsersStatus(['maia1', 'maia5', 'maia9']);

      expect(result.isValue, true);
    });
  });
}
