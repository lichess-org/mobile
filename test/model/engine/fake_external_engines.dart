import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/engine/external_engine.dart';

import '../../network/fake_http_client_factory.dart';
import '../../test_helpers.dart';

const testExternalEngine = ExternalEngine(
  id: 'eei_aTKImBJOnv6j',
  name: 'External Stockfish',
  maxThreads: 8,
  maxHash: 2048,
  variants: IListConst(['chess']),
  clientSecret: 'ees_mdF2hK0hlKGSPeC6',
);

/// Lichess, answering the engine list with [engines], or with [status] and no engine.
FakeHttpClientFactory externalEnginesClientFactory(
  Iterable<ExternalEngine> engines, {
  int status = 200,
}) => FakeHttpClientFactory(
  () => MockClient((request) {
    if (request.url.path != '/api/external-engine') return mockResponse('', 404);
    if (status != 200) return mockResponse('', status);
    return mockResponse(
      jsonEncode([
        for (final engine in engines)
          {
            'id': engine.id,
            'name': engine.name,
            'maxThreads': engine.maxThreads,
            'maxHash': engine.maxHash,
            'variants': engine.variants.unlock,
            'clientSecret': engine.clientSecret,
          },
      ]),
      200,
    );
  }),
);
