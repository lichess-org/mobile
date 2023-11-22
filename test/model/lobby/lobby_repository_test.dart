import 'package:flutter_test/flutter_test.dart';
import 'package:async/async.dart';
import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

import 'package:lichess_mobile/src/model/auth/auth_client.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/lobby/lobby_repository.dart';

class MockAuthClient extends Mock implements AuthClient {}

class MockLogger extends Mock implements Logger {}

void main() {
  final mockLogger = MockLogger();
  final mockAuthClient = MockAuthClient();
  final repo = LobbyRepository(authClient: mockAuthClient, logger: mockLogger);

  setUpAll(() {
    reset(mockAuthClient);
  });

  group('LobbyRepository.getCorrespondenceSeeks', () {
    test('read json', () async {
      const response = '''
[
    {
        "color": "black",
        "id": "OIBZi6bn",
        "mode": 0,
        "perf": {
            "key": "chess960"
        },
        "provisional": true,
        "rating": 1500,
        "username": "veloce",
        "variant": {
            "key": "chess960"
        }
    },
    {
        "color": "",
        "days": 5,
        "id": "48DixX1Z",
        "mode": 0,
        "perf": {
            "key": "correspondence"
        },
        "provisional": true,
        "rating": 1500,
        "username": "chabrot",
        "variant": {
            "key": "standard"
        }
    }
]
''';
      when(
        () => mockAuthClient.get(
          Uri.parse('$kLichessHost/lobby/seeks'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer(
        (_) async => Result.value(http.Response(response, 200)),
      );

      final result = await repo.getCorrespondenceChallenges();

      expect(result.isValue, true);
    });
  });
}
