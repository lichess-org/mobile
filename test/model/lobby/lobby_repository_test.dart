import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/lobby/correspondence_seek.dart';
import 'package:lichess_mobile/src/model/lobby/lobby_repository.dart';
import 'package:lichess_mobile/src/network/http.dart';

import '../../test_container.dart';
import '../../test_helpers.dart';

void main() {
  final mockClient = MockClient((request) {
    if (request.url.path == '/lobby/seeks') {
      return mockResponse(seeksResponse, 200);
    }
    return mockResponse('', 404);
  });

  group('LobbyRepository.getCorrespondenceSeeks', () {
    test('read json', () async {
      final container = await lichessClientContainer(mockClient);
      final client = container.read(lichessClientProvider);
      final repo = LobbyRepository(client);

      final data = await repo.getCorrespondenceSeeks();

      expect(data, isA<IList<CorrespondenceSeek>>());
      expect(data.length, 2);
      expect(data[0].id, const GameId('OIBZi6bn'));
    });
  });
}

const seeksResponse = '''
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
