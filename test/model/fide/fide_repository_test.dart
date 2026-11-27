import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/fide/fide_player.dart';
import 'package:lichess_mobile/src/model/fide/fide_repository.dart';
import 'package:lichess_mobile/src/network/http.dart';

import '../../network/fake_http_client_factory.dart';
import '../../test_container.dart';

void main() {
  Future<ProviderContainer> makeTestContainer(MockClient mockClient) {
    return makeContainer(
      overrides: {
        httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
          (ref) => FakeHttpClientFactory(() => mockClient),
        ),
      },
    );
  }

  group('FideRepository.getPlayers', () {
    test('requests a sorted page as JSON and parses it', () async {
      const response = '''
{
  "currentPage": 2,
  "maxPerPage": 30,
  "currentPageResults": [
    {
      "id": 1503014,
      "name": "Carlsen, Magnus",
      "federation": "NOR",
      "year": 1990,
      "title": "GM",
      "standard": 2823,
      "rapid": 2801,
      "blitz": 2860,
      "gender": "M",
      "photo": {
        "small": "https://image.lichess1.org/display?h=100&w=100",
        "medium": "https://image.lichess1.org/display?h=250&w=250",
        "credit": "Lennart Ootes"
      },
      "following": true
    },
    {
      "id": 99,
      "name": "Doe, John",
      "federation": null,
      "year": null,
      "rapid": 1500
    }
  ],
  "previousPage": 1,
  "nextPage": 3
}
''';

      final mockClient = MockClient((request) async {
        if (request.url.path == '/fide') {
          expect(request.headers['Accept'], 'application/json');
          expect(request.url.queryParameters, {'page': '2', 'order': 'rapid'});
          return http.Response(response, 200);
        }
        return http.Response('', 404);
      });

      final container = await makeTestContainer(mockClient);
      final page = await container
          .read(fideRepositoryProvider)
          .getPlayers(page: 2, order: FidePlayerOrder.rapid);

      expect(page.nextPage, 3);
      expect(page.players.length, 2);

      final carlsen = page.players[0];
      expect(carlsen.id, const FideId(1503014));
      expect(carlsen.name, 'Carlsen, Magnus');
      expect(carlsen.federation, const FederationId('NOR'));
      expect(carlsen.birthYear, 1990);
      expect(carlsen.title, 'GM');
      expect(
        carlsen.ratings,
        const IMapConst({
          BroadcastFideTC.standard: 2823,
          BroadcastFideTC.rapid: 2801,
          BroadcastFideTC.blitz: 2860,
        }),
      );
      expect(carlsen.photo?.credit, 'Lennart Ootes');
      expect(carlsen.following, true);
      expect(carlsen.slug, 'Carlsen_Magnus');

      final doe = page.players[1];
      expect(doe.federation, null);
      expect(doe.birthYear, null);
      expect(doe.title, null);
      expect(doe.photo, null);
      expect(doe.following, false);
      expect(doe.ratings, const IMapConst({BroadcastFideTC.rapid: 1500}));
    });

    test('sends a search query instead of the order', () async {
      final mockClient = MockClient((request) async {
        if (request.url.path == '/fide') {
          expect(request.url.queryParameters, {'page': '1', 'q': 'carlsen'});
          return http.Response('{"currentPageResults": [], "nextPage": null}', 200);
        }
        return http.Response('', 404);
      });

      final container = await makeTestContainer(mockClient);
      final page = await container.read(fideRepositoryProvider).getPlayers(query: 'carlsen');

      expect(page.players, isEmpty);
      expect(page.nextPage, null);
    });
  });

  group('FideRepository.getPlayer', () {
    test('parses the player, linked user and rating history', () async {
      const response = '''
{
  "id": 1503014,
  "name": "Carlsen, Magnus",
  "federation": "NOR",
  "year": 1990,
  "title": "GM",
  "standard": 2823,
  "following": true,
  "user": {"id": "drnykterstein", "name": "DrNykterstein", "title": "GM"},
  "ratings": {
    "standard": [2025010000, 2025022831, 2025032823],
    "rapid": [],
    "blitz": [2024120000]
  }
}
''';

      final mockClient = MockClient((request) async {
        if (request.url.path == '/fide/1503014/-') {
          expect(request.headers['Accept'], 'application/json');
          return http.Response(response, 200);
        }
        return http.Response('', 404);
      });

      final container = await makeTestContainer(mockClient);
      final details = await container.read(fideRepositoryProvider).getPlayer(const FideId(1503014));

      expect(details.player.name, 'Carlsen, Magnus');
      expect(details.player.following, true);
      expect(details.user?.id, const UserId('drnykterstein'));
      expect(details.user?.title, 'GM');
      // A time control without points has no history.
      expect(details.ratingHistory.keys.toSet(), {BroadcastFideTC.standard, BroadcastFideTC.blitz});
      expect(details.ratingHistory[BroadcastFideTC.standard]!.map((p) => (p.date, p.elo)), [
        (DateTime.utc(2025, 1), 0),
        (DateTime.utc(2025, 2), 2831),
        (DateTime.utc(2025, 3), 2823),
      ]);
    });
  });
}
