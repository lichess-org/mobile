import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:lichess_mobile/src/network/aggregator.dart';
import 'package:lichess_mobile/src/network/http.dart';

import '../test_container.dart';
import 'fake_http_client_factory.dart';
import 'http_test.dart';

void main() {
  setUp(() {
    FakeClient.reset();
  });

  group('Aggregator', () {
    test('if only one request is made within 50ms, it will make an atomic request', () async {
      final container = await makeContainer(
        overrides: [
          httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => FakeClient());
          }),
        ],
      );
      final aggregator = container.read(aggregatorProvider);

      final uri = Uri(path: '/api/test');

      final response = await aggregator(uri, mapper: (data) => data);

      // Check that the request was made
      final requests = FakeClient.verifyRequests();
      expect(requests.length, 1);
      expect(
        requests.first,
        isA<http.BaseRequest>().having((r) => r.url.path, 'url path', uri.path),
      );
      expect(response, isNotNull);
    });

    test('non supported uris will not aggregate and make atomic request after 50ms', () async {
      final container = await makeContainer(
        overrides: [
          httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => FakeClient());
          }),
        ],
      );
      final aggregator = container.read(aggregatorProvider);

      final uri1 = Uri(path: '/api/test1');
      final uri2 = Uri(path: '/api/test2');

      fakeAsync((async) {
        aggregator(uri1, mapper: (data) => data);
        aggregator(uri2, mapper: (data) => data);

        async.elapse(const Duration(milliseconds: 50));

        // Check that the requests were made separately
        final requests = FakeClient.verifyRequests();
        expect(requests.length, 2);
      });
    });
  });
}
