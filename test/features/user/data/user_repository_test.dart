import 'package:flutter_test/flutter_test.dart';
import 'package:async/async.dart';
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
