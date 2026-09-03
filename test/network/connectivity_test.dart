import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/server_status.dart';
import 'package:lichess_mobile/src/network/socket.dart';

import '../test_container.dart';
import '../utils/fake_connectivity.dart';
import 'fake_http_client_factory.dart';
import 'fake_websocket_channel.dart';
import 'server_down_client.dart';

/// A client that fails every request, as it would without any connectivity.
final _deviceOfflineClient = MockClient((request) => throw const SocketException('No internet'));

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('isDeviceOnlineProvider', () {
    test('is true once the check succeeds', () async {
      final container = await makeContainer();

      await container.read(connectivityChangesProvider.future);

      expect(container.read(isDeviceOnlineProvider), isTrue);
    });

    test('is false once the check fails to reach anything', () async {
      final container = await makeContainer(
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
            (ref) => FakeHttpClientFactory(() => _deviceOfflineClient),
          ),
        },
      );

      await container.read(connectivityChangesProvider.future);

      expect(container.read(isDeviceOnlineProvider), isFalse);
    });

    test('a socket that connects clears an offline status', () async {
      final container = await makeContainer(
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
            (ref) => FakeHttpClientFactory(() => _deviceOfflineClient),
          ),
        },
      );

      await container.read(connectivityChangesProvider.future);
      expect(container.read(isDeviceOnlineProvider), isFalse);

      // Nothing can reach the network in this container except the socket, whose connection is
      // proof enough on its own: the status must not wait for the next check to be corrected.
      final client = container.read(socketPoolProvider).currentClient;
      client.connect();
      await client.firstConnection;
      await Future<void>.delayed(kFakeWebSocketConnectionLag * 4);
      await pumpEventQueue();

      expect(container.read(isDeviceOnlineProvider), isTrue);

      client.close();
    });

    test(
      'a connected socket does not keep the device online once a check says otherwise',
      () async {
        final container = await makeContainer(
          overrides: {
            httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
              (ref) => FakeHttpClientFactory(() => _deviceOfflineClient),
            ),
          },
        );
        await container.read(connectivityChangesProvider.future);

        final client = container.read(socketPoolProvider).currentClient;
        client.connect();
        await client.firstConnection;
        await Future<void>.delayed(kFakeWebSocketConnectionLag * 4);
        await pumpEventQueue();
        expect(container.read(isDeviceOnlineProvider), isTrue);

        // The network goes away. The socket only notices once a ping goes unanswered, tens of
        // seconds later, so its stale state must not outweigh the check.
        FakeConnectivity.controller.add([ConnectivityResult.none]);
        await pumpEventQueue();

        expect(client.isConnected, isTrue, reason: 'the socket has not noticed yet');
        expect(container.read(isDeviceOnlineProvider), isFalse);

        client.close();
      },
    );

    test('assumes online while the check is still running', () async {
      final container = await makeContainer(
        overrides: {
          connectivityPluginProvider: connectivityPluginProvider.overrideWith(
            (_) => PendingConnectivity(),
          ),
        },
      );

      // No await: the check never completes, so the status stays unknown.
      expect(container.read(isDeviceOnlineProvider), isTrue);
    });
  });

  group('lichessConnectionStatusProvider', () {
    test('returns online when network is available and server is reachable', () async {
      final container = await makeContainer();

      await container.read(connectivityChangesProvider.future);

      expect(container.read(lichessConnectionStatusProvider), LichessConnectionStatus.online);
    });

    test('returns networkDown when network is unavailable', () async {
      final container = await makeContainer(
        overrides: {isDeviceOnlineProvider: isDeviceOnlineProvider.overrideWithValue(false)},
      );

      expect(container.read(lichessConnectionStatusProvider), LichessConnectionStatus.networkDown);
    });

    test('returns serverDown when network is available but server is unreachable', () async {
      final container = await lichessClientContainer(serverDownClient(statusCode: 502));

      await container.read(connectivityChangesProvider.future);
      await container.read(lichessClientProvider).get(Uri(path: '/api/account'));

      expect(container.read(lichessConnectionStatusProvider), LichessConnectionStatus.serverDown);
      expect(container.read(lichessConnectionStatusProvider).isServerUnavailable, isTrue);
    });

    test('returns serverMaintenance when the server is in planned maintenance', () async {
      final container = await lichessClientContainer(serverDownClient(statusCode: 503));

      await container.read(connectivityChangesProvider.future);
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
          isDeviceOnlineProvider: isDeviceOnlineProvider.overrideWithValue(false),
        },
      );

      await container.read(lichessClientProvider).get(Uri(path: '/api/account'));

      expect(container.read(serverStatusProvider), ServerStatus.down);
      expect(container.read(lichessConnectionStatusProvider), LichessConnectionStatus.networkDown);
    });
  });
}
