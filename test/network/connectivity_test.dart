import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/server_status.dart';

import '../test_container.dart';
import 'fake_http_client_factory.dart';
import 'server_down_client.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('lichessConnectionStatusProvider', () {
    test('returns online when network is available and server is reachable', () async {
      final container = await makeContainer();

      // Wait for onlineStatusProvider to resolve (FakeConnectivity returns wifi).
      await container.read(onlineStatusProvider.future);

      expect(container.read(lichessConnectionStatusProvider), LichessConnectionStatus.online);
    });

    test('assumes online while the connectivity check is still running', () async {
      final container = await makeContainer(
        overrides: {
          onlineStatusProvider: onlineStatusProvider.overrideWith(
            (ref) => Completer<bool>().future,
          ),
        },
      );

      // No await: the check never completes, so the provider stays loading.
      expect(container.read(lichessConnectionStatusProvider), LichessConnectionStatus.online);
    });

    test('returns networkDown when network is unavailable', () async {
      final container = await makeContainer(
        overrides: {
          onlineStatusProvider: onlineStatusProvider.overrideWith((ref) => Future.value(false)),
        },
      );

      await container.read(onlineStatusProvider.future);

      expect(container.read(lichessConnectionStatusProvider), LichessConnectionStatus.networkDown);
    });

    test('returns serverDown when network is available but server is unreachable', () async {
      final container = await lichessClientContainer(serverDownClient(statusCode: 502));

      await container.read(onlineStatusProvider.future);
      await container.read(lichessClientProvider).get(Uri(path: '/api/account'));

      expect(container.read(lichessConnectionStatusProvider), LichessConnectionStatus.serverDown);
      expect(container.read(lichessConnectionStatusProvider).isServerUnavailable, isTrue);
    });

    test('returns serverMaintenance when the server is in planned maintenance', () async {
      final container = await lichessClientContainer(serverDownClient(statusCode: 503));

      await container.read(onlineStatusProvider.future);
      await container.read(lichessClientProvider).get(Uri(path: '/api/account'));

      expect(
        container.read(lichessConnectionStatusProvider),
        LichessConnectionStatus.serverMaintenance,
      );
      expect(container.read(lichessConnectionStatusProvider).isServerUnavailable, isTrue);
    });

    test('networkDown takes precedence over an unreachable server', () async {
      final container = await makeContainer(
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
            (ref) => FakeHttpClientFactory(() => serverDownClient(statusCode: 502)),
          ),
          onlineStatusProvider: onlineStatusProvider.overrideWith((ref) => Future.value(false)),
        },
      );

      await container.read(onlineStatusProvider.future);
      await container.read(lichessClientProvider).get(Uri(path: '/api/account'));

      expect(container.read(serverStatusProvider), ServerStatus.down);
      expect(container.read(lichessConnectionStatusProvider), LichessConnectionStatus.networkDown);
    });
  });
}
