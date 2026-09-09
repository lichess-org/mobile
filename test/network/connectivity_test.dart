import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
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

    test('a connected socket has no say in the status', () async {
      // The socket is up and answering, and the check can reach nothing. That the socket works is
      // only ever a suspicion — it may be holding a connection to a network that is already gone,
      // which it would not notice for tens of seconds — so the check has the last word.
      final container = await makeContainer(
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
            (ref) => FakeHttpClientFactory(() => _deviceOfflineClient),
          ),
        },
      );

      final client = container.read(socketPoolProvider).currentClient;
      client.connect();
      await client.firstConnection;
      await Future<void>.delayed(kFakeWebSocketConnectionLag * 4);
      await pumpEventQueue();
      expect(client.isConnected, isTrue);

      await container.read(connectivityChangesProvider.future);
      expect(container.read(isDeviceOnlineProvider), isFalse);

      // And it stays that way, however many pings the socket goes on answering.
      await Future<void>.delayed(kFakeWebSocketConnectionLag * 10);
      await pumpEventQueue();
      expect(container.read(isDeviceOnlineProvider), isFalse);

      client.close();
    });

    test('a failing socket has no say in the status', () async {
      // A socket that cannot connect is only ever a suspicion: it may be lichess that is down, and
      // a check asked for on its word would report offline wherever the probed hosts are blocked
      // but the network is fine. So it neither takes the device offline nor asks anything.
      var checks = 0;
      final container = await makeContainer(
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
            (ref) => FakeHttpClientFactory(
              () => MockClient((request) async {
                if (request.url == internetCheckUris.first) checks++;
                return http.Response('', 200);
              }),
            ),
          ),
          webSocketChannelFactoryProvider: webSocketChannelFactoryProvider.overrideWithValue(
            FakeWebSocketChannelFactory((_) => throw const SocketException('No internet')),
          ),
        },
      );

      await container.read(connectivityChangesProvider.future);
      checks = 0;

      fakeAsync((async) {
        container.read(socketPoolProvider).currentClient.connect();

        // Minutes of failed attempts, each one backing off a little further.
        async.elapse(const Duration(minutes: 5));

        expect(container.read(isDeviceOnlineProvider), isTrue);
        expect(
          checks,
          0,
          reason: 'the check runs on connectivity events and app resume, not on it',
        );

        container.read(socketPoolProvider).currentClient.close();
        async.flushTimers();
      });
    });

    test('a plugin failure is retried, and the status recovers on a later attempt', () async {
      // The real plugin fails with a [PlatformException], which riverpod retries — unlike the
      // [Error] the other fakes throw, which it deliberately does not. So the provider goes
      // through several builds here, and what the last one leaves behind is what the app uses.
      final connectivity = PluginFailingConnectivity();
      var probes = 0;
      final container = await makeContainer(
        overrides: {
          connectivityPluginProvider: connectivityPluginProvider.overrideWith((_) => connectivity),
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
            (ref) => FakeHttpClientFactory(
              () => MockClient((request) async {
                if (request.url == internetCheckUris.first) probes++;
                return http.Response('', 200);
              }),
            ),
          ),
        },
      );

      fakeAsync((async) {
        // Listened to, not merely read: a provider nobody listens to is not retried.
        container.listen(connectivityChangesProvider, (_, _) {});
        async.elapse(const Duration(milliseconds: 100));
        expect(connectivity.checks, 1);
        expect(
          container.read(isDeviceOnlineProvider),
          isFalse,
          reason: 'a check that could not run reached nothing',
        );

        // The first retry, half a second later.
        async.elapse(const Duration(milliseconds: 500));
        expect(connectivity.checks, 2);

        // The plugin comes back before the six attempts are spent.
        connectivity.shouldFail = false;
        async.elapse(const Duration(seconds: 2));
        expect(connectivity.checks, 3);
        expect(container.read(isDeviceOnlineProvider), isTrue);

        // The builds that failed left nothing behind: their subscriptions are gone, so a
        // connectivity event runs one check, not one per attempt.
        probes = 0;
        FakeConnectivity.controller.add([ConnectivityResult.wifi]);
        async.elapse(const Duration(milliseconds: 100));
        expect(probes, 1);

        // Not even once the throttle window a duplicate would have been coalesced into expires.
        async.elapse(kConnectivityThrottleDelay * 2);
        expect(probes, 1);

        async.flushTimers();
      });
    });

    test('a check that goes wrong on resume leaves the status as it is', () async {
      final connectivity = SwitchableConnectivity();
      final container = await makeContainer(
        overrides: {
          connectivityPluginProvider: connectivityPluginProvider.overrideWith((_) => connectivity),
        },
      );
      final binding = TestWidgetsFlutterBinding.instance;

      fakeAsync((async) {
        container.read(connectivityChangesProvider);
        async.elapse(const Duration(seconds: 1));
        expect(container.read(isDeviceOnlineProvider), isTrue);

        // The plugin goes wrong on the check the user coming back to the app asks for. That says
        // nothing about the network, and there is a settled status here to leave alone — turning
        // it into an error would take the app offline for no reason at all.
        connectivity.shouldFail = true;
        // The binding may still be resumed from an earlier test, and only a change is notified.
        binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
        binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
        async.elapse(const Duration(milliseconds: 100));

        expect(container.read(isDeviceOnlineProvider), isTrue);

        async.flushTimers();
      });
    });

    test('a resume whose plugin call fails does not swallow a check already running', () async {
      final connectivity = PluginFailingConnectivity()..shouldFail = false;
      var offline = false;
      var checkDelay = Duration.zero;
      final container = await makeContainer(
        overrides: {
          connectivityPluginProvider: connectivityPluginProvider.overrideWith((_) => connectivity),
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
            (ref) => FakeHttpClientFactory(
              () => MockClient((request) async {
                final (wasOffline, delay) = (offline, checkDelay);
                await Future<void>.delayed(delay);
                if (wasOffline) throw const SocketException('No internet');
                return http.Response('', 200);
              }),
            ),
          ),
        },
      );
      final binding = TestWidgetsFlutterBinding.instance;

      fakeAsync((async) {
        container.read(connectivityChangesProvider);
        async.elapse(const Duration(seconds: 1));
        expect(container.read(isDeviceOnlineProvider), isTrue);

        // A connectivity event starts a check that takes seconds to report the network is gone.
        offline = true;
        checkDelay = const Duration(seconds: 3);
        FakeConnectivity.controller.add([ConnectivityResult.none]);
        async.elapse(const Duration(milliseconds: 100));

        // The user comes back to the app meanwhile, and the plugin call that makes goes wrong. It
        // has nothing to write, so it must not outdate the check that is still running either —
        // that answer is all the app is going to get.
        connectivity.shouldFail = true;
        // The binding may still be resumed from an earlier test, and only a change is notified.
        binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
        binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
        async.elapse(const Duration(milliseconds: 100));

        async.elapse(const Duration(seconds: 5));
        expect(container.read(isDeviceOnlineProvider), isFalse);

        async.flushTimers();
      });
    });

    test('a slow check does not overwrite what happened while it ran', () async {
      // A network that comes and goes, and a check that takes as long as it is told to.
      var offline = false;
      var checkDelay = Duration.zero;
      final container = await makeContainer(
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
            (ref) => FakeHttpClientFactory(
              () => MockClient((request) async {
                final (wasOffline, delay) = (offline, checkDelay);
                await Future<void>.delayed(delay);
                if (wasOffline) throw const SocketException('No internet');
                return http.Response('', 200);
              }),
            ),
          ),
        },
      );

      final binding = TestWidgetsFlutterBinding.instance;

      fakeAsync((async) {
        container.read(connectivityChangesProvider);
        async.elapse(const Duration(seconds: 1));
        expect(container.read(isDeviceOnlineProvider), isTrue);

        // A check starts while the network is down, and takes seconds to say so.
        offline = true;
        checkDelay = const Duration(seconds: 3);
        FakeConnectivity.controller.add([ConnectivityResult.none]);
        async.elapse(const Duration(milliseconds: 100));

        // The network is back before that check answers, and the user coming back to the app
        // settles the question with a probe of its own.
        offline = false;
        checkDelay = Duration.zero;
        // The binding may still be resumed from an earlier test, and only a change is notified.
        binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
        binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
        async.elapse(const Duration(milliseconds: 100));
        expect(container.read(isDeviceOnlineProvider), isTrue);

        // The slow check now answers with what the network looked like seconds ago: it must not
        // overwrite the fresher answer.
        async.elapse(const Duration(seconds: 5));
        expect(container.read(isDeviceOnlineProvider), isTrue);

        async.flushTimers();
      });
    });

    test('a check that confirms the status still outdates the slower ones', () async {
      var offline = false;
      var checkDelay = Duration.zero;
      final container = await makeContainer(
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
            (ref) => FakeHttpClientFactory(
              () => MockClient((request) async {
                final (wasOffline, delay) = (offline, checkDelay);
                await Future<void>.delayed(delay);
                if (wasOffline) throw const SocketException('No internet');
                return http.Response('', 200);
              }),
            ),
          ),
        },
      );

      final binding = TestWidgetsFlutterBinding.instance;

      fakeAsync((async) {
        container.read(connectivityChangesProvider);
        async.elapse(const Duration(seconds: 1));
        expect(container.read(isDeviceOnlineProvider), isTrue);

        // Coming back to the app starts a check while the network is down, and it takes its time.
        offline = true;
        checkDelay = const Duration(seconds: 4);
        // The binding may still be resumed from an earlier test, and only a change is notified.
        binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
        binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
        async.elapse(const Duration(milliseconds: 100));

        // The network is back, and a second check overtakes the first to say so. It confirms the
        // status rather than changing it, so it writes nothing — but it is the fresher answer.
        offline = false;
        checkDelay = Duration.zero;
        FakeConnectivity.controller.add([ConnectivityResult.wifi]);
        async.elapse(const Duration(milliseconds: 100));
        expect(container.read(isDeviceOnlineProvider), isTrue);

        // The first check finally answers, with a network that is seconds out of date.
        async.elapse(const Duration(seconds: 5));
        expect(container.read(isDeviceOnlineProvider), isTrue);
      });
    });

    test('an older check finishing first does not outdate a newer one', () async {
      var offline = false;
      var checkDelay = Duration.zero;
      final container = await makeContainer(
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
            (ref) => FakeHttpClientFactory(
              () => MockClient((request) async {
                final (wasOffline, delay) = (offline, checkDelay);
                await Future<void>.delayed(delay);
                if (wasOffline) throw const SocketException('No internet');
                return http.Response('', 200);
              }),
            ),
          ),
        },
      );

      final binding = TestWidgetsFlutterBinding.instance;

      fakeAsync((async) {
        container.read(connectivityChangesProvider);
        async.elapse(const Duration(seconds: 1));
        expect(container.read(isDeviceOnlineProvider), isTrue);

        // A check starts while the network is up, and will take a moment to confirm as much.
        offline = false;
        checkDelay = const Duration(milliseconds: 200);
        FakeConnectivity.controller.add([ConnectivityResult.wifi]);
        async.elapse(const Duration(milliseconds: 50));

        // The network then dies, and the user coming back to the app starts a second check. It is
        // the newer of the two, and its answer must win however long it takes to arrive — the
        // older one finishing first must not disqualify it.
        offline = true;
        checkDelay = const Duration(seconds: 2);
        // The binding may still be resumed from an earlier test, and only a change is notified.
        binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
        binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);

        async.elapse(const Duration(seconds: 5));
        expect(container.read(isDeviceOnlineProvider), isFalse);
      });
    });

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
