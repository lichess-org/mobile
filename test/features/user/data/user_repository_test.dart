import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:logging/logging.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/common/http.dart';
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
          .thenReturn(
              TaskEither.right(http.Response(testUserResponseMinimal, 200)));

      final result = await repo.getUserTask(testUserId).run();

      expect(result.isRight(), true);
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
          .thenReturn(TaskEither.right(http.Response(testUserResponse, 200)));

      final result = await repo.getUserTask(testUserId).run();

      expect(result.isRight(), true);
    });
  });

  group('UserRepository.getUsersStatusTask', () {
    test('json read, minimal example', () async {
      final ids = ['maia1', 'maia5', 'maia9'];
      when(() => mockApiClient.get(
              Uri.parse('$kLichessHost/api/users/status?ids=${ids.join(',')}')))
          .thenReturn(TaskEither.right(http.Response('[]', 200)));

      final result = await repo.getUsersStatusTask(ids).run();

      expect(result.isRight(), true);
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
          .thenReturn(TaskEither.right(http.Response(response, 200)));

      final result =
          await repo.getUsersStatusTask(['maia1', 'maia5', 'maia9']).run();

      expect(result.isRight(), true);
    });
  });

  group('UserRepository.getRecentGamesTask', () {
    test('json read, full example', () async {
      const response = '''
{"id":"rfBxF2P5","rated":false,"variant":"standard","speed":"blitz","perf":"blitz","createdAt":1672074461465,"lastMoveAt":1672074683485,"status":"mate","players":{"white":{"user":{"name":"testUser","patron":true,"id":"testUser"},"rating":1178},"black":{"user":{"name":"maia1","title":"BOT","id":"maia1"},"rating":1397}},"winner":"white","moves":"e4 e5 Nf3 d6 Bc4 Nf6 Nc3 Nc6 O-O Be7 d3 O-O Nh4 Bg4 Qd2 Nd4 Nf5 Bxf5 exf5 Nxf5 Nd5 Nxd5 Bxd5 c6 Be4 Nd4 c3 Ne6 d4 exd4 cxd4 d5 Bc2 Bg5 Qd3 Bxc1 Qxh7#","clock":{"initial":300,"increment":3,"totalTime":420}}
{"id":"msAKIkqp","rated":false,"variant":"standard","speed":"blitz","perf":"blitz","createdAt":1671791341158,"lastMoveAt":1671791589063,"status":"resign","players":{"white":{"user":{"name":"maia1","title":"BOT","id":"maia1"},"rating":1399},"black":{"user":{"name":"testUser","patron":true,"id":"testUser"},"rating":1178}},"winner":"white","moves":"e4 e5 Nf3 Nc6 Bb5 Nf6 Bxc6 dxc6 Nxe5 Qd4 Nf3 Qxe4+ Qe2 Bc5 Qxe4+ Nxe4 O-O O-O d3 Nf6 Bg5 Nh5 Nc3 Bg4 Ne5 f5 Nd7 Rf7 Nxc5 Raf8 Nxb7 f4 f3 Bc8 Nc5 Rf5 N5e4 Nf6 Bxf6 gxf6 Rae1","clock":{"initial":300,"increment":3,"totalTime":420}}
{"id":"7Jxi9mBF","rated":false,"variant":"standard","speed":"blitz","perf":"blitz","createdAt":1671100908073,"lastMoveAt":1671101322211,"status":"mate","players":{"white":{"user":{"name":"testUser","patron":true,"id":"testUser"},"rating":1178},"black":{"user":{"name":"maia1","title":"BOT","id":"maia1"},"rating":1410}},"winner":"white","moves":"e4 e5 Nf3 Nc6 Nc3 Nf6 Bb5 d6 O-O Bd7 Bxc6 Bxc6 d4 exd4 Nxd4 Bxe4 Nxe4 Nxe4 Re1 d5 f3 Bc5 fxe4 dxe4 Rxe4+ Be7 Bg5 f6 Bf4 O-O Ne6 Qxd1+ Rxd1 Rfe8 Bxc7 Rac8 c4 Bc5+ Kh1 b6 Bd6 Bxd6 Rxd6 f5 Rf4 g6 g3 Kf7 Ng5+ Kg7 Rd7+ Kh6 h4 Re1+ Kg2 Re2+ Kf3 Rxb2 Rxh7#","clock":{"initial":300,"increment":3,"totalTime":420}}
''';

      when(() => mockApiClient.get(
            Uri.parse('$kLichessHost/api/games/user/testUser?max=10'),
            headers: {'Accept': 'application/x-ndjson'},
          )).thenReturn(TaskEither.right(http.Response(response, 200)));

      final result = await repo.getRecentGamesTask('testUser').run();

      expect(result.isRight(), true);
    });
  });
}
