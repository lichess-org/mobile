import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/engine/external_engine_repository.dart';
import 'package:lichess_mobile/src/network/http.dart';

import '../../network/fake_http_client_factory.dart';
import '../../test_container.dart';
import '../../test_helpers.dart';
import '../auth/fake_auth_storage.dart';

const testExternalEnginesResponse = '''
[{"id":"eei_aTKImBJOnv6j","name":"External Stockfish","userId":"thibault","maxThreads":8,"maxHash":2048,"variants":["chess"],"providerData":null,"clientSecret":"ees_mdF2hK0hlKGSPeC6"},{"id":"eei_bMLJnCKPow7k","name":"Fairy-Stockfish","userId":"thibault","maxThreads":4,"maxHash":512,"variants":["chess","crazyhouse","antichess","atomic","horde","kingofthehill","racingkings","3check"],"providerData":null,"clientSecret":"ees_neG3iL1imLHTQfD7"}]
''';

void main() {
  test('getExternalEngines reads the registrations of the current user', () async {
    final requests = <String>[];
    final mockClient = MockClient((request) {
      requests.add('${request.method} ${request.url.path}');
      if (request.url.path == '/api/external-engine') {
        return mockResponse(testExternalEnginesResponse, 200);
      }
      return mockResponse('', 404);
    });

    final container = await lichessClientContainer(mockClient);
    final engines = await container.read(externalEngineRepositoryProvider).getExternalEngines();

    expect(requests, ['GET /api/external-engine']);
    expect(engines.length, 2);
    expect(engines[0].name, 'External Stockfish');
    expect(engines[0].maxThreads, 8);
    expect(engines[1].name, 'Fairy-Stockfish');
    expect(
      engines[1].variants,
      [
        'chess',
        'crazyhouse',
        'antichess',
        'atomic',
        'horde',
        'kingofthehill',
        'racingkings',
        '3check',
      ].lock,
    );
  });

  group('externalEnginesProvider', () {
    test('returns no engines and sends no request when logged out', () async {
      final requestedPaths = <String>[];
      final mockClient = MockClient((request) {
        requestedPaths.add(request.url.path);
        return mockResponse('', 404);
      });

      final container = await lichessClientContainer(mockClient);
      final engines = await container.read(externalEnginesProvider.future);

      expect(engines, isEmpty);
      expect(requestedPaths, isEmpty);
    });

    test('returns the fetched engines when logged in', () async {
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/external-engine') {
          return mockResponse(testExternalEnginesResponse, 200);
        }
        return mockResponse('', 404);
      });

      final container = await makeContainer(
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => mockClient);
          }),
        },
        authUser: fakeAuthUser,
      );
      final engines = await container.read(externalEnginesProvider.future);

      expect(engines.map((engine) => engine.id), ['eei_aTKImBJOnv6j', 'eei_bMLJnCKPow7k']);
    });
  });
}
