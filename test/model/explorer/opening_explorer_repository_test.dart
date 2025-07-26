import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/explorer/opening_explorer.dart';
import 'package:lichess_mobile/src/model/explorer/opening_explorer_repository.dart';
import 'package:lichess_mobile/src/network/http.dart';

import '../../test_container.dart';
import '../../test_helpers.dart';

void main() {
  group('OpeningExplorerRepository.getMasterDatabase', () {
    test('parse json', () async {
      const response = '''
{
  "white": 834333,
  "draws": 1085272,
  "black": 600303,
  "moves": [
    {
      "uci": "e2e4",
      "san": "e4",
      "averageRating": 2399,
      "white": 372266,
      "draws": 486092,
      "black": 280238,
      "game": null
    },
    {
      "uci": "d2d4",
      "san": "d4",
      "averageRating": 2414,
      "white": 302160,
      "draws": 397224,
      "black": 209077,
      "game": null
    }
  ],
  "topGames": [
    {
      "uci": "d2d4",
      "id": "QR5UbqUY",
      "winner": null,
      "black": {
        "name": "Caruana, F.",
        "rating": 2818
      },
      "white": {
        "name": "Carlsen, M.",
        "rating": 2882
      },
      "year": 2019,
      "month": "2019-08"
    },
    {
      "uci": "e2e4",
      "id": "Sxov6E94",
      "winner": "white",
      "black": {
        "name": "Carlsen, M.",
        "rating": 2882
      },
      "white": {
        "name": "Caruana, F.",
        "rating": 2818
      },
      "year": 2019,
      "month": "2019-08"
    }
  ],
  "opening": null
}
      ''';

      final mockClient = MockClient((request) {
        if (request.url.path == '/masters') {
          return mockResponse(response, 200);
        }
        return mockResponse('', 404);
      });

      final container = await lichessClientContainer(mockClient);
      final client = container.read(lichessClientProvider);

      final repo = OpeningExplorerRepository(client);

      final result = await repo.getMasterDatabase('fen');
      expect(result, isA<OpeningExplorerEntry>());
      expect(result.moves.length, 2);
      expect(result.topGames, isNotNull);
      expect(result.topGames!.length, 2);
    });
  });

  group('OpeningExplorerRepository.getLichessDatabase', () {
    test('parse json', () async {
      const response = '''
{
  "white": 2848672002,
  "draws": 225287646,
  "black": 2649860106,
  "moves": [
    {
      "uci": "e2e4",
      "san": "e4",
      "averageRating": 1604,
      "white": 1661457614,
      "draws": 129433754,
      "black": 1565161663,
      "game": null
    }
  ],
  "recentGames": [
    {
      "uci": "e2e4",
      "id": "RVb19S9O",
      "winner": "white",
      "speed": "rapid",
      "mode": "rated",
      "black": {
        "name": "Jcats1",
        "rating": 1548
      },
      "white": {
        "name": "carlosrivero32",
        "rating": 1690
      },
      "year": 2024,
      "month": "2024-06"
    }
  ],
  "topGames": [],
  "opening": null
}
      ''';

      final mockClient = MockClient((request) {
        if (request.url.path == '/lichess') {
          return mockResponse(response, 200);
        }
        return mockResponse('', 404);
      });

      final container = await lichessClientContainer(mockClient);
      final client = container.read(lichessClientProvider);

      final repo = OpeningExplorerRepository(client);

      final result = await repo.getLichessDatabase(
        'fen',
        speeds: const ISetConst({Speed.rapid}),
        ratings: const ISetConst({1000, 1200}),
      );
      expect(result, isA<OpeningExplorerEntry>());
      expect(result.moves.length, 1);
      expect(result.recentGames, isNotNull);
      expect(result.recentGames!.length, 1);
      expect(result.topGames, isNotNull);
      expect(result.topGames!.length, 0);
    });
  });

  group('OpeningExplorerRepository.getPlayerDatabase', () {
    test('parse json', () async {
      const response = '''
{
  "white": 1713,
  "draws": 119,
  "black": 1459,
  "moves": [
    {
      "uci": "e2e4",
      "san": "e4",
      "averageOpponentRating": 1767,
      "performance": 1796,
      "white": 1691,
      "draws": 116,
      "black": 1432,
      "game": null
    }
  ],
  "recentGames": [
    {
      "uci": "e2e4",
      "id": "RVb19S9O",
      "winner": "white",
      "speed": "bullet",
      "mode": "rated",
      "black": {
        "name": "foo",
        "rating": 1869
      },
      "white": {
        "name": "baz",
        "rating": 1912
      },
      "year": 2023,
      "month": "2023-08"
    }
  ],
  "opening": null,
  "queuePosition": 0
}
      ''';

      final mockClient = MockClient((request) {
        if (request.url.path == '/player') {
          return mockResponse(response, 200);
        }
        return mockResponse('', 404);
      });

      final container = await lichessClientContainer(mockClient);
      final client = container.read(lichessClientProvider);

      final repo = OpeningExplorerRepository(client);

      final results = await repo.getPlayerDatabase(
        'fen',
        usernameOrId: 'baz',
        color: Side.white,
        speeds: const ISetConst({Speed.bullet}),
        gameModes: const ISetConst({GameMode.rated}),
      );
      expect(results, isA<Stream<OpeningExplorerEntry>>());
      await for (final result in results) {
        expect(result, isA<OpeningExplorerEntry>());
        expect(result.moves.length, 1);
        expect(result.recentGames, isNotNull);
        expect(result.recentGames!.length, 1);
      }
    });
  });
}
