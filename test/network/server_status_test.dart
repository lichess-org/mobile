import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/network/server_status.dart';

import '../test_container.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ServerStatusNotifier', () {
    test('server is marked down on HTTP 503 from lichess', () async {
      final container = await makeContainer();

      expect(container.read(serverStatusProvider), isTrue);

      container
          .read(serverStatusProvider.notifier)
          .handleHttpResponse(503, Uri.parse('https://lichess.dev/api/user/foo'));

      expect(container.read(serverStatusProvider), isFalse);
    });

    test('server is marked down on HTTP 502 from lichess', () async {
      final container = await makeContainer();

      expect(container.read(serverStatusProvider), isTrue);

      container
          .read(serverStatusProvider.notifier)
          .handleHttpResponse(502, Uri.parse('https://lichess.dev/api/user/foo'));

      expect(container.read(serverStatusProvider), isFalse);
    });

    test('server is marked up again after successful response following outage', () async {
      final container = await makeContainer();

      container
          .read(serverStatusProvider.notifier)
          .handleHttpResponse(503, Uri.parse('https://lichess.dev/api/user/foo'));
      expect(container.read(serverStatusProvider), isFalse);

      container
          .read(serverStatusProvider.notifier)
          .handleHttpResponse(200, Uri.parse('https://lichess.dev/api/user/foo'));
      expect(container.read(serverStatusProvider), isTrue);
    });

    test('non-lichess 502 does not affect server status', () async {
      final container = await makeContainer();

      expect(container.read(serverStatusProvider), isTrue);

      container
          .read(serverStatusProvider.notifier)
          .handleHttpResponse(502, Uri.parse('https://www.gstatic.com/generate_204'));

      expect(container.read(serverStatusProvider), isTrue);
    });
  });
}
