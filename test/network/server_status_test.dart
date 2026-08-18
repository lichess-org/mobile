import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/server_status.dart';

import '../test_container.dart';
import 'server_down_client.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ServerStatusNotifier', () {
    test('the server is assumed to be up until a response says otherwise', () async {
      final container = await makeContainer();

      expect(container.read(serverStatusProvider), ServerStatus.up);
    });

    for (final (statusCode, expected) in [
      (502, ServerStatus.down),
      (503, ServerStatus.maintenance),
    ]) {
      test('HTTP $statusCode from lichess yields ${expected.name}', () async {
        final container = await lichessClientContainer(
          MockClient((request) async => http.Response('', statusCode)),
        );

        await container.read(lichessClientProvider).get(Uri(path: '/api/account'));

        expect(container.read(serverStatusProvider), expected);
      });
    }

    test('server is marked up again after a successful response following an outage', () async {
      var statusCode = 503;
      final container = await lichessClientContainer(
        MockClient((request) async => http.Response('', statusCode)),
      );
      final client = container.read(lichessClientProvider);

      await client.get(Uri(path: '/api/account'));
      expect(container.read(serverStatusProvider), ServerStatus.maintenance);

      statusCode = 200;
      await client.get(Uri(path: '/api/account'));
      expect(container.read(serverStatusProvider), ServerStatus.up);
    });

    test('a 502 from the opening explorer does not affect the server status', () async {
      final container = await lichessClientContainer(
        MockClient((request) async => http.Response('', 502)),
      );

      await container
          .read(lichessClientProvider)
          .get(Uri.https(kLichessOpeningExplorerHost, '/lichess'));

      expect(container.read(serverStatusProvider), ServerStatus.up);
    });

    test('a 502 from the tablebase does not affect the server status', () async {
      final container = await lichessClientContainer(
        MockClient((request) async => http.Response('', 502)),
      );

      await container
          .read(lichessClientProvider)
          .get(Uri.https(kLichessTablebaseHost, '/standard'));

      expect(container.read(serverStatusProvider), ServerStatus.up);
    });

    test('a client error does not restore the server status', () async {
      var statusCode = 502;
      final container = await lichessClientContainer(
        MockClient((request) async => http.Response('', statusCode)),
      );
      final client = container.read(lichessClientProvider);

      await client.get(Uri(path: '/api/account'));
      expect(container.read(serverStatusProvider), ServerStatus.down);

      statusCode = 404;
      await client.get(Uri(path: '/api/account'));
      expect(container.read(serverStatusProvider), ServerStatus.down);
    });

    test('a client error does not trigger an outage', () async {
      final container = await lichessClientContainer(
        MockClient((request) async => http.Response('', 404)),
      );

      await container.read(lichessClientProvider).get(Uri(path: '/api/account'));

      expect(container.read(serverStatusProvider), ServerStatus.up);
    });

    test('onAppResumed assumes the server is reachable again', () async {
      final container = await lichessClientContainer(serverDownClient(statusCode: 502));

      await container.read(lichessClientProvider).get(Uri(path: '/api/account'));
      expect(container.read(serverStatusProvider), ServerStatus.down);

      container.read(serverStatusProvider.notifier).onAppResumed();

      expect(container.read(serverStatusProvider), ServerStatus.up);
    });

    test('the server status switches directly from maintenance to down', () async {
      var statusCode = 503;
      final container = await lichessClientContainer(
        MockClient((request) async => http.Response('', statusCode)),
      );
      final client = container.read(lichessClientProvider);

      await client.get(Uri(path: '/api/account'));
      expect(container.read(serverStatusProvider), ServerStatus.maintenance);

      statusCode = 502;
      await client.get(Uri(path: '/api/account'));
      expect(container.read(serverStatusProvider), ServerStatus.down);
    });
  });
}
