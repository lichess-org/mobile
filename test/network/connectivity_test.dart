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
      'a socket that connects while the first check is running keeps the device online',
      () async {
        // The check takes long enough for the socket to answer a pong before it comes back offline.
        final container = await makeContainer(
          overrides: {
            httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
              (ref) => FakeHttpClientFactory(
                () => MockClient((request) async {
                  await Future<void>.delayed(const Duration(milliseconds: 200));
                  throw const SocketException('No internet');
                }),
              ),
            ),
          },
        );

        final pendingCheck = container.read(connectivityChangesProvider.future);

        final client = container.read(socketPoolProvider).currentClient;
        client.connect();
        await client.firstConnection;
        await Future<void>.delayed(kFakeWebSocketConnectionLag * 4);
        await pumpEventQueue();

        await pendingCheck;

        expect(container.read(isDeviceOnlineProvider), isTrue);

        client.close();
      },
    );

    test('a socket that connects clears an offline status left by a failed check', () async {
      final container = await makeContainer(
        overrides: {
          connectivityPluginProvider: connectivityPluginProvider.overrideWith(
            (_) => FailingConnectivity(),
          ),
        },
      );

      await expectLater(container.read(connectivityChangesProvider.future), throwsStateError);
      expect(
        container.read(isDeviceOnlineProvider),
        isFalse,
        reason: 'a check that could not run reached nothing',
      );

      // The socket is proof of a working network whatever the failed check left behind, so the
      // status must not stay offline until something else happens to probe it.
      final client = container.read(socketPoolProvider).currentClient;
      client.connect();
      await client.firstConnection;
      await Future<void>.delayed(kFakeWebSocketConnectionLag * 4);
      await pumpEventQueue();

      expect(container.read(isDeviceOnlineProvider), isTrue);

      client.close();
    });

    test('the lag left by a socket that has been closed is not proof of a connection', () async {
      // Only the second route fails to connect, so that the pool keeps the lag measured on the
      // first one — which it deliberately does not blank on a route change.
      const failingRoute = '/failing/socket';
      final container = await makeContainer(
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
            (ref) => FakeHttpClientFactory(
              () => MockClient((request) async {
                // Slow enough for the sockets below to come and go while the check runs.
                await Future<void>.delayed(const Duration(milliseconds: 300));
                throw const SocketException('No internet');
              }),
            ),
          ),
          webSocketChannelFactoryProvider: webSocketChannelFactoryProvider.overrideWithValue(
            FakeWebSocketChannelFactory((route) {
              if (route.path == failingRoute) throw const SocketException('No internet');
              return FakeWebSocketChannel(route);
            }),
          ),
        },
      );

      final pool = container.read(socketPoolProvider);
      final connected = pool.open(Uri(path: kDefaultSocketRoute));
      await connected.firstConnection;
      await Future<void>.delayed(kFakeWebSocketConnectionLag * 4);
      expect(pool.averageLag.value, isNot(Duration.zero));

      pool.open(Uri(path: failingRoute));
      await pumpEventQueue();
      expect(pool.averageLag.value, isNot(Duration.zero), reason: 'the lag outlives its socket');
      expect(pool.currentClient.isConnected, isFalse);

      await container.read(connectivityChangesProvider.future);

      expect(container.read(isDeviceOnlineProvider), isFalse);

      pool.currentClient.close();
    });

    test('the socket clears an offline status once, not on every lag change', () async {
      // A server whose answers get slower and slower, so that every pong moves the average lag.
      FakeWebSocketChannel? channel;
      final container = await makeContainer(
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
            (ref) => FakeHttpClientFactory(() => _deviceOfflineClient),
          ),
          webSocketChannelFactoryProvider: webSocketChannelFactoryProvider.overrideWithValue(
            FakeWebSocketChannelFactory((route) => channel = FakeWebSocketChannel(route)),
          ),
        },
      );

      await container.read(connectivityChangesProvider.future);
      expect(container.read(isDeviceOnlineProvider), isFalse);

      var statusChanges = 0;
      container.listen(connectivityChangesProvider, (_, _) => statusChanges++);

      final pool = container.read(socketPoolProvider);
      var lagChanges = 0;
      void countLagChange() => lagChanges++;
      pool.averageLag.addListener(countLagChange);

      fakeAsync((async) {
        pool.currentClient.connect();
        async.elapse(const Duration(seconds: 1));

        expect(container.read(isDeviceOnlineProvider), isTrue);
        expect(statusChanges, 1);

        // The ping/pong protocol keeps moving the average lag for as long as the socket is up: an
        // online status that is already settled must not be rewritten on every pong.
        for (var i = 1; i <= 10; i++) {
          channel!.connectionLag = Duration(milliseconds: 10 * i);
          async.elapse(const Duration(seconds: 30));
        }

        expect(lagChanges, greaterThan(5), reason: 'the lag did keep changing');
        expect(statusChanges, 1, reason: 'but the status was only ever settled once');

        pool.averageLag.removeListener(countLagChange);
        pool.currentClient.close();
        async.flushTimers();
      });
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

    test('a socket that cannot connect makes the check run again', () async {
      // The network dies without the connectivity plugin ever saying so — a captive portal, or an
      // interface that is up but leads nowhere.
      var offline = false;
      final container = await makeContainer(
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
            (ref) => FakeHttpClientFactory(
              () => MockClient((request) async {
                if (offline) throw const SocketException('No internet');
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
      expect(container.read(isDeviceOnlineProvider), isTrue);

      offline = true;
      container.read(socketPoolProvider).currentClient.connect();
      await pumpEventQueue();

      expect(container.read(isDeviceOnlineProvider), isFalse);
    });

    test('a socket that starts failing during the throttle delay is checked right away', () async {
      var offline = false;
      final container = await makeContainer(
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
            (ref) => FakeHttpClientFactory(
              () => MockClient((request) async {
                if (offline) throw const SocketException('No internet');
                return http.Response('', 200);
              }),
            ),
          ),
          webSocketChannelFactoryProvider: webSocketChannelFactoryProvider.overrideWithValue(
            FakeWebSocketChannelFactory((_) => throw const SocketException('No internet')),
          ),
        },
      );

      // The notifier is built inside [fakeAsync] so that the timers it starts from the connectivity
      // subscription — the throttler's among them — belong to this zone and answer to [elapse].
      fakeAsync((async) {
        container.read(connectivityChangesProvider);
        async.elapse(const Duration(seconds: 1));
        expect(container.read(isDeviceOnlineProvider), isTrue);

        // A connectivity event opens the throttle window while the network is still fine.
        FakeConnectivity.controller.add([ConnectivityResult.wifi]);
        async.elapse(const Duration(milliseconds: 100));
        expect(container.read(isDeviceOnlineProvider), isTrue);

        // The network dies without the plugin ever saying so, and the socket is the only witness.
        // It reports a run of failures once, so the check it asks for must not be held back by a
        // window the connectivity plugin happens to have opened: the report would be lost, and
        // nothing left to correct the device being reported online.
        offline = true;
        container.read(socketPoolProvider).currentClient.connect();
        async.elapse(const Duration(milliseconds: 100));
        expect(container.read(isDeviceOnlineProvider), isFalse);

        container.read(socketPoolProvider).currentClient.close();
        async.flushTimers();
      });
    });

    test('a failing socket alone does not take the device offline', () async {
      // Only lichess is unreachable here: the device itself is online, and the app must go on
      // saying so, however long the socket goes on failing.
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
          1,
          reason: 'a run of failures is worth one check, however many attempts it is made of',
        );

        container.read(socketPoolProvider).currentClient.close();
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

    test('a pong keeps a check that started before it from taking the device offline', () async {
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

      fakeAsync((async) {
        container.read(connectivityChangesProvider);
        async.elapse(const Duration(seconds: 1));
        expect(container.read(isDeviceOnlineProvider), isTrue);

        // A check starts on a network that is momentarily down, and takes seconds to say so.
        offline = true;
        checkDelay = const Duration(seconds: 2);
        FakeConnectivity.controller.add([ConnectivityResult.none]);
        async.elapse(const Duration(milliseconds: 100));

        // The socket then answers a ping, which is proof of a working network. It changes nothing
        // to a status that already reads online, but it is newer than the check in flight.
        final pool = container.read(socketPoolProvider);
        pool.currentClient.connect();
        async.elapse(const Duration(seconds: 1));
        expect(pool.currentClient.isConnected, isTrue);

        // The check now answers with a network that is seconds out of date.
        async.elapse(const Duration(seconds: 5));
        expect(container.read(isDeviceOnlineProvider), isTrue);

        pool.currentClient.close();
        async.flushTimers();
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
