import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/network/server_status.dart';
import 'package:lichess_mobile/src/network/socket.dart';

import '../test_container.dart';
import 'fake_websocket_channel.dart';

// The default SocketPool creates its default client with a pingDelay of 25s.
// After the initial pong, the next ping is sent after this delay.
// When the server stops responding, averageLag drops to zero after:
//   25s (pingDelay) + 9s (pingMaxLag) = 34s
// The outage timer then runs for 30s before marking the server offline.
const _poolDefaultPingDelay = Duration(seconds: 25);
const _pingMaxLag = Duration(seconds: 9);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ServerStatusNotifier', () {
    test('server is marked offline after 30s of continuous disconnection', () async {
      FakeWebSocketChannel? currentChannel;
      var serverIsDown = false;

      final container = await makeContainer(
        overrides: {
          webSocketChannelFactoryProvider: webSocketChannelFactoryProvider.overrideWith((_) {
            return FakeWebSocketChannelFactory((route) {
              final ch = FakeWebSocketChannel(route);
              if (serverIsDown) ch.shouldSendPong = false;
              currentChannel = ch;
              return ch;
            });
          }),
        },
      );

      fakeAsync((async) {
        expect(container.read(serverStatusProvider), isTrue);

        // Connect the socket pool's default client.
        container.read(socketPoolProvider).currentClient.connect();

        // Wait for connection + initial ping/pong cycle.
        async.elapse(kFakeWebSocketConnectionLag);
        async.flushMicrotasks();

        expect(container.read(socketPoolProvider).averageLag.value, isNot(Duration.zero));
        expect(container.read(serverStatusProvider), isTrue);

        // Server goes down: current channel stops responding to pings.
        serverIsDown = true;
        currentChannel!.shouldSendPong = false;

        // Wait for the next ping (25s) and its timeout (9s).
        // averageLag drops to zero and the 30s outage timer starts.
        async.elapse(_poolDefaultPingDelay + _pingMaxLag);
        async.flushMicrotasks();

        expect(container.read(socketPoolProvider).averageLag.value, Duration.zero);
        // Timer started but hasn't fired yet.
        expect(container.read(serverStatusProvider), isTrue);

        // Wait for the 30s outage timer to fire.
        async.elapse(const Duration(seconds: 30));
        async.flushMicrotasks();

        expect(container.read(serverStatusProvider), isFalse);

        container.dispose();
        async.flushTimers();
      });
    });

    test('outage timer is cancelled when connection is restored within 30s', () async {
      FakeWebSocketChannel? currentChannel;
      var serverIsDown = false;

      final container = await makeContainer(
        overrides: {
          webSocketChannelFactoryProvider: webSocketChannelFactoryProvider.overrideWith((_) {
            return FakeWebSocketChannelFactory((route) {
              final ch = FakeWebSocketChannel(route);
              if (serverIsDown) ch.shouldSendPong = false;
              currentChannel = ch;
              return ch;
            });
          }),
        },
      );

      fakeAsync((async) {
        expect(container.read(serverStatusProvider), isTrue);

        container.read(socketPoolProvider).currentClient.connect();

        async.elapse(kFakeWebSocketConnectionLag);
        async.flushMicrotasks();

        expect(container.read(socketPoolProvider).averageLag.value, isNot(Duration.zero));

        // Server goes down.
        serverIsDown = true;
        currentChannel!.shouldSendPong = false;

        // Wait for ping timeout → averageLag drops to zero → 30s outage timer starts.
        async.elapse(_poolDefaultPingDelay + _pingMaxLag);
        async.flushMicrotasks();

        expect(container.read(socketPoolProvider).averageLag.value, Duration.zero);
        expect(container.read(serverStatusProvider), isTrue);

        // Server comes back before the 30s timer fires.
        // The next reconnect channel will respond to pings.
        serverIsDown = false;

        // Wait for the reconnect ping timeout (9s) to trigger a new connect(),
        // then allow the new connection's pong to arrive (5ms lag).
        async.elapse(_pingMaxLag + kFakeWebSocketConnectionLag);
        async.flushMicrotasks();

        // Connection restored: averageLag > 0 and outage timer cancelled.
        expect(container.read(socketPoolProvider).averageLag.value, isNot(Duration.zero));
        expect(container.read(serverStatusProvider), isTrue);

        // Advance past where the original timer would have fired.
        async.elapse(const Duration(seconds: 30));
        async.flushMicrotasks();

        // State stays online because the timer was cancelled.
        expect(container.read(serverStatusProvider), isTrue);

        container.dispose();
        async.flushTimers();
      });
    });
  });
}
