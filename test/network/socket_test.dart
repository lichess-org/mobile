import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/misc.dart' show Override, ProviderOrFamily;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../binding.dart';
import '../test_container.dart';
import '../utils/fake_connectivity.dart';
import 'fake_http_client_factory.dart';
import 'fake_websocket_channel.dart';

final defaultSocketUri = Uri(path: kDefaultSocketRoute);

SocketClient makeTestSocketClient({
  WebSocketChannelFactory fakeChannelFactory = defaultFakeWebSocketChannelFactory,
  int? version,
  VoidCallback? onEventGapFailure,
}) {
  final client = SocketClient(
    defaultSocketUri,
    version: version,
    channelFactory: fakeChannelFactory,
    onEventGapFailure: onEventGapFailure,
    getSession: () => null,
    sri: 'testSri',
    packageInfo: PackageInfo(
      appName: 'lichess_mobile_test',
      version: 'test',
      buildNumber: '0.0.0',
      packageName: 'lichess_mobile_test',
    ),
    deviceInfo: BaseDeviceInfo({
      'name': 'test',
      'model': 'test',
      'manufacturer': 'test',
      'systemName': 'test',
      'systemVersion': 'test',
      'identifierForVendor': 'test',
      'isPhysicalDevice': true,
    }),
    pingDelay: const Duration(milliseconds: 50),
    pingMaxLag: const Duration(milliseconds: 200),
    autoReconnectDelay: const Duration(milliseconds: 100),
    reconnectGracePeriod: const Duration(seconds: 1),
    resendAckDelay: const Duration(milliseconds: 100),
  );

  return client;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  TestLichessBinding.ensureInitialized();

  group('SocketClient', () {
    test('handles ping/pong', () async {
      final fakeChannel = FakeWebSocketChannel(defaultSocketUri);

      final socketClient = makeTestSocketClient(
        fakeChannelFactory: FakeWebSocketChannelFactory((_) => fakeChannel),
      );
      socketClient.connect();

      int sentPingCount = 0;
      fakeChannel.sentMessages.forEach((message) {
        if (FakeWebSocketChannel.isPing(message)) {
          sentPingCount++;
          // close after 3 pings
          if (sentPingCount == 3) {
            socketClient.close();
          }
        }
      });

      // 1 ready event is expected
      expectLater(socketClient.connectedStream, emitsInOrder([null]));

      // 2 pong messages are expected since we're closing just after 3 pings
      await expectLater(fakeChannel.stream, emitsInOrder(['0', '0']));
    });

    test('reconnects when connection attempt fails', () async {
      int numConnectionAttempts = 0;

      final fakeChannelFactory = FakeWebSocketChannelFactory((_) {
        numConnectionAttempts++;
        if (numConnectionAttempts == 1) {
          throw const SocketException('Connection failed');
        }
        return FakeWebSocketChannel(defaultSocketUri);
      });

      final socketClient = makeTestSocketClient(fakeChannelFactory: fakeChannelFactory);
      socketClient.connect();

      // The first connection attempt will fail, but the second one will succeed
      await socketClient.firstConnection;

      expect(numConnectionAttempts, 2);
      expect(socketClient.nbConnectionAttempts, 2);
      expect(socketClient.nbConnectionSuccess, 1);

      socketClient.close();
    });

    test('an unexpected connection failure is logged in full, a network one is not', () async {
      var attempts = 0;
      final fakeChannelFactory = FakeWebSocketChannelFactory((_) {
        attempts++;
        return switch (attempts) {
          // What a device with no network looks like: routine, and not worth a log the user's
          // crash reports would have to carry.
          1 => throw const SocketException('Connection failed'),
          // A bug in the connection setup, which no amount of retrying will fix: the logs are the
          // only place it can be seen from production.
          2 => throw StateError('boom'),
          _ => FakeWebSocketChannel(defaultSocketUri),
        };
      });

      final records = <LogRecord>[];
      final subscription = Logger.root.onRecord
          .where((record) => record.level >= Level.WARNING)
          .listen(records.add);
      addTearDown(subscription.cancel);

      final socketClient = makeTestSocketClient(fakeChannelFactory: fakeChannelFactory);
      socketClient.connect();

      await socketClient.firstConnection;
      expect(attempts, 3);

      expect(records, hasLength(1), reason: 'only the unexpected failure is reported');
      expect(records.single.level, Level.SEVERE);
      expect(records.single.error, isStateError);
      expect(records.single.stackTrace, isNotNull, reason: 'the stack trace is what points at it');

      socketClient.close();
    });

    test('does not reconnect when closed while a connection attempt is in flight', () async {
      int numConnectionAttempts = 0;

      // Simulates a server that never accepts the connection: each attempt fails after a delay,
      // like a connection timeout would.
      final fakeChannelFactory = DelayedFakeWebSocketChannelFactory(
        const Duration(milliseconds: 100),
        (_) {
          numConnectionAttempts++;
          throw const SocketException('Connection failed');
        },
      );

      final socketClient = makeTestSocketClient(fakeChannelFactory: fakeChannelFactory);
      socketClient.connect();

      // Close while the first attempt is still awaiting the channel creation.
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await socketClient.close();

      // Long enough for the in-flight attempt to fail and for a reconnect to have been scheduled
      // (autoReconnectDelay is 100ms) and fired.
      await Future<void>.delayed(const Duration(milliseconds: 400));

      expect(numConnectionAttempts, 1);
      expect(socketClient.isActive, false);
    });

    test('discards a connection that succeeds after the client was closed', () async {
      final Map<int, FakeWebSocketChannel> channels = {};
      int numConnectionAttempts = 0;

      final fakeChannelFactory = DelayedFakeWebSocketChannelFactory(
        const Duration(milliseconds: 100),
        (_) {
          numConnectionAttempts++;
          final channel = FakeWebSocketChannel(defaultSocketUri);
          channels[numConnectionAttempts] = channel;
          return channel;
        },
      );

      final socketClient = makeTestSocketClient(fakeChannelFactory: fakeChannelFactory);
      socketClient.connect();

      // Close while the connection attempt is still awaiting the channel creation.
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await socketClient.close();

      await Future<void>.delayed(const Duration(milliseconds: 200));

      // The channel created by the stale attempt must not be adopted, and must be closed.
      expect(channels[1]!.closeCode, isNotNull);
      expect(socketClient.isConnected, false);
      expect(socketClient.nbConnectionSuccess, 0);
    });

    test('retries at full speed during the grace period, then backs off', () {
      final attempts = <Duration>[];

      fakeAsync((async) {
        final start = async.elapsed;
        final socketClient = makeTestSocketClient(
          fakeChannelFactory: FakeWebSocketChannelFactory((_) {
            attempts.add(async.elapsed - start);
            throw const SocketException('Network is unreachable');
          }),
        );
        socketClient.connect();

        // The grace period is 1s in tests, the reconnect delay 100ms.
        async.elapse(const Duration(seconds: 5));

        final gaps = [for (var i = 1; i < attempts.length; i++) attempts[i] - attempts[i - 1]];

        expect(
          gaps.take(11),
          everyElement(const Duration(milliseconds: 100)),
          reason: 'a blip must not be made to wait',
        );
        expect(gaps[11], const Duration(milliseconds: 200), reason: 'then the delay doubles');
        expect(gaps.last, greaterThan(const Duration(milliseconds: 200)));

        socketClient.close();
        async.flushTimers();
      });
    });

    test('a successful connection resets the backoff', () {
      fakeAsync((async) {
        final attempts = <Duration>[];
        final start = async.elapsed;
        var failing = true;
        final socketClient = makeTestSocketClient(
          fakeChannelFactory: FakeWebSocketChannelFactory((route) {
            attempts.add(async.elapsed - start);
            if (failing) throw const SocketException('Network is unreachable');
            return FakeWebSocketChannel(route);
          }),
        );
        socketClient.connect();

        // Fail well past the grace period, so the delay has grown.
        async.elapse(const Duration(seconds: 5));
        final grownGap = attempts.last - attempts[attempts.length - 2];
        expect(grownGap, greaterThan(const Duration(milliseconds: 100)));

        // The network comes back, then drops again: the next retry is at full speed, since this is
        // a new failure and not the continuation of the old one.
        failing = false;
        async.elapse(const Duration(seconds: 5));
        expect(socketClient.nbConnectionSuccess, greaterThan(0));

        failing = true;
        attempts.clear();
        socketClient.connect();
        async.elapse(const Duration(milliseconds: 250));

        expect(attempts[1] - attempts[0], const Duration(milliseconds: 100));

        socketClient.close();
        async.flushTimers();
      });
    });

    test('reconnects automatically if pong is not received', () async {
      int numConnectionAttempts = 0;
      // channels per connection attempt
      final Map<int, FakeWebSocketChannel> channels = {};

      final fakeChannelFactory = FakeWebSocketChannelFactory((_) {
        numConnectionAttempts++;
        final channel = FakeWebSocketChannel(defaultSocketUri);
        int sentPingCount = 0;
        channel.sentMessages.forEach((message) {
          if (FakeWebSocketChannel.isPing(message)) {
            sentPingCount++;
            // on first connection, stop responding to pings after 3 pings
            if (numConnectionAttempts == 1 && sentPingCount == 3) {
              channel.shouldSendPong = false;
            }
          }
        });
        channels[numConnectionAttempts] = channel;

        return channel;
      });

      final socketClient = makeTestSocketClient(fakeChannelFactory: fakeChannelFactory);
      socketClient.connect();

      await socketClient.firstConnection;

      // will only receive 3 pings since the server stops responding to pings
      expectLater(channels[1]!.stream, emitsInOrder(['0', '0', '0']));

      // we expect another connection because it reconnects if not receiving pong
      await expectLater(socketClient.connectedStream, emits(null));

      // check the first connection was closed
      // no need to check the close code since it will alway be 1000 in our fake channel
      expect(channels[1]!.closeCode, isNotNull);
      expect(channels[2]!.closeCode, isNull);

      socketClient.close();
    });

    test('computes average lag', () async {
      final fakeChannel = FakeWebSocketChannel(
        defaultSocketUri,
        connectionLag: const Duration(milliseconds: 10),
      );

      final socketClient = makeTestSocketClient(
        fakeChannelFactory: FakeWebSocketChannelFactory((_) => fakeChannel),
      );
      socketClient.connect();

      // before the connection is ready the average lag is zero
      expect(socketClient.averageLag.value, Duration.zero);

      await socketClient.firstConnection;

      // after the connection is ready the average lag is still zero since
      // there was no ping/pong exchange yet
      expect(socketClient.averageLag.value, Duration.zero);

      // at this time the first ping is sent, wait for the pong
      await expectLater(fakeChannel.stream, emits('0'));

      // after the ping/pong exchange the average lag is computed
      expect(socketClient.averageLag.value.inMilliseconds, greaterThanOrEqualTo(10));

      // wait for more ping/pong exchanges
      await expectLater(fakeChannel.stream, emitsInOrder(['0', '0', '0', '0']));

      // average lag is still the same
      expect(socketClient.averageLag.value.inMilliseconds, greaterThanOrEqualTo(10));

      // increase the lag of the connection
      fakeChannel.connectionLag = const Duration(milliseconds: 100);

      // wait for more ping/pong exchanges
      await expectLater(fakeChannel.stream, emitsInOrder(['0', '0', '0', '0']));

      // average lag should be higher
      expect(socketClient.averageLag.value.inMilliseconds, greaterThanOrEqualTo(40));

      await socketClient.close();

      // after disconnecting the average lag is zero again
      expect(socketClient.averageLag.value, Duration.zero);
    });

    test('handles ackable messages', () async {
      final fakeChannel = FakeWebSocketChannel(defaultSocketUri);

      final socketClient = makeTestSocketClient(
        fakeChannelFactory: FakeWebSocketChannelFactory((_) => fakeChannel),
      );
      await socketClient.connect();

      // send a message that requires an ack
      socketClient.send('test', {'data': 'ackable'}, ackable: true);

      // several messages are expected, since the server didn't ack the message
      await expectLater(
        fakeChannel.sentMessagesExceptPing,
        emitsInOrder([
          '{"t":"test","d":{"data":"ackable","a":1}}',
          '{"t":"test","d":{"data":"ackable","a":1}}',
          '{"t":"test","d":{"data":"ackable","a":1}}',
        ]),
      );

      // server acks the message
      sendServerSocketMessages(defaultSocketUri, ['{"t":"ack","d":1}']);

      // no more messages are expected
      await expectLater(fakeChannel.sentMessagesExceptPing, emitsInOrder([]));

      socketClient.close();
    });

    test(
      'queues non-ackable messages sent while not connected and flushes them on connect',
      () async {
        final fakeChannel = FakeWebSocketChannel(defaultSocketUri);

        final socketClient = makeTestSocketClient(
          fakeChannelFactory: FakeWebSocketChannelFactory((_) => fakeChannel),
        );

        // Messages sent before the connection is open must be queued, not dropped.
        socketClient.send('test1', null);
        socketClient.send('test2', {'foo': 'bar'});

        // They are flushed, in order, once the connection opens. Subscribe before
        // connecting, since the flush happens as soon as the connection is ready
        // and [sentMessages] is a broadcast stream.
        final expectation = expectLater(
          fakeChannel.sentMessagesExceptPing,
          emitsInOrder(['{"t":"test1"}', '{"t":"test2","d":{"foo":"bar"}}']),
        );

        await socketClient.connect();
        await expectation;

        socketClient.close();
      },
    );

    test('queues a message sent while the socket is connecting and sends it once open', () async {
      final fakeChannel = FakeWebSocketChannel(defaultSocketUri);

      final socketClient = makeTestSocketClient(
        fakeChannelFactory: FakeWebSocketChannelFactory((_) => fakeChannel),
      );

      // Start connecting but don't await: the connection is in progress (the
      // attempt is counted but not yet successful).
      final connectFuture = socketClient.connect();
      expect(socketClient.nbConnectionAttempts, 1);
      expect(socketClient.nbConnectionSuccess, 0);

      // Sent while connecting: must be queued, not dropped.
      socketClient.send('test', null);

      // Subscribe before the connection opens, since the flush is immediate and
      // [sentMessages] is a broadcast stream.
      final expectation = expectLater(
        fakeChannel.sentMessagesExceptPing,
        emitsThrough('{"t":"test"}'),
      );

      await connectFuture;
      expect(socketClient.nbConnectionSuccess, 1);
      await expectation;

      socketClient.close();
    });

    test('queues an ackable message sent while not connected and sends it on connect', () async {
      final fakeChannel = FakeWebSocketChannel(defaultSocketUri);

      final socketClient = makeTestSocketClient(
        fakeChannelFactory: FakeWebSocketChannelFactory((_) => fakeChannel),
      );

      // An ackable message (e.g. a move) sent before the connection is open must
      // be sent as soon as it opens, not only after the ack-resend delay.
      socketClient.send('move', {'u': 'e2e4'}, ackable: true);

      final expectation = expectLater(
        fakeChannel.sentMessagesExceptPing,
        emitsThrough('{"t":"move","d":{"u":"e2e4","a":1}}'),
      );

      await socketClient.connect();
      await expectation;

      socketClient.close();
    });

    test('does not double-send a queued ackable message whose ack is past the resend cutoff', () {
      fakeAsync((async) {
        final fakeChannel = FakeWebSocketChannel(defaultSocketUri);

        final socketClient = makeTestSocketClient(
          fakeChannelFactory: FakeWebSocketChannelFactory((_) => fakeChannel),
        );

        final sent = <dynamic>[];
        fakeChannel.sentMessagesExceptPing.listen(sent.add);

        // Sent while disconnected: queued and also tracked in _acks.
        socketClient.send('move', {'u': 'e2e4'}, ackable: true);

        // Let enough time pass that the ack is older than the resend cutoff
        // (2500ms), so _resendAcks() would otherwise resend it on connect.
        async.elapse(const Duration(seconds: 3));

        socketClient.connect();
        async.elapse(kFakeWebSocketConnectionLag);
        async.flushMicrotasks();

        // It is sent exactly once on reconnect (by the flush), not twice (flush
        // + _resendAcks).
        expect(sent.where((m) => m == '{"t":"move","d":{"u":"e2e4","a":1}}').length, 1);

        socketClient.close();
      });
    });

    test('handles batch message', () async {
      final fakeChannel = FakeWebSocketChannel(defaultSocketUri);

      final socketClient = makeTestSocketClient(
        fakeChannelFactory: FakeWebSocketChannelFactory((_) => fakeChannel),
      );
      await socketClient.connect();

      const serverMessage = '''
      {
         "t":"batch",
         "d":[
            {"t":"test1","d":"data"},
            {"t":"test2","d":"data"},
            {"t":"test3","d":"data"}
         ]
      }
      ''';

      const eventsToMatch = [
        SocketEvent(topic: 'test1', data: 'data', json: {'t': 'test1', 'd': 'data'}),
        SocketEvent(topic: 'test2', data: 'data', json: {'t': 'test2', 'd': 'data'}),
        SocketEvent(topic: 'test3', data: 'data', json: {'t': 'test3', 'd': 'data'}),
      ];

      // check that the messages in the batch were distributed
      await testEventEmitted(socketClient, fakeChannel, serverMessage, eventsToMatch);

      await socketClient.close();
    });
  });

  test('emits events', () async {
    final fakeChannel = FakeWebSocketChannel(defaultSocketUri);

    final socketClient = makeTestSocketClient(
      fakeChannelFactory: FakeWebSocketChannelFactory((_) => fakeChannel),
    );
    await socketClient.connect();

    // should not emit if _pong
    await testEventEmitted(socketClient, fakeChannel, '0', []);

    // should emit if n
    const pongMessage = '{"t":"n","d":10,"r":3}';
    const pongEvent = SocketEvent(topic: 'n', data: {'nbPlayers': 10, 'nbGames': 3});
    await testEventEmitted(socketClient, fakeChannel, pongMessage, [pongEvent]);

    // should not emit if ack
    const ackMessage = '{"t":"n","d":10,"r":3}';
    await testEventEmitted(socketClient, fakeChannel, ackMessage, []);

    // should not emit if batch
    const batchMessage = '{"t":"batch","d":[]}';
    await testEventEmitted(socketClient, fakeChannel, batchMessage, []);

    // should emit if random topic
    const randomMessage = '{"t":"test","d":"data"}';
    const randomEvent = SocketEvent(topic: 'test', data: 'data', json: {'t': 'test', 'd': 'data'});
    await testEventEmitted(socketClient, fakeChannel, randomMessage, [randomEvent]);

    await socketClient.close();
  });

  test('handle event gap', () {
    fakeAsync((async) {
      final fakeChannel = FakeWebSocketChannel(defaultSocketUri);

      int onEventGapFailureCalled = 0;

      final socketClient = makeTestSocketClient(
        fakeChannelFactory: FakeWebSocketChannelFactory((_) => fakeChannel),
        version: 0,
        onEventGapFailure: () {
          onEventGapFailureCalled++;
        },
      );
      socketClient.connect();

      socketClient.stream.listen((event) {
        // ignore the events
      });
      expectLater(
        socketClient.stream,
        emitsInOrder([
          const SocketEvent(
            topic: 'test',
            version: 1,
            data: 'data',
            json: {'t': 'test', 'v': 1, 'd': 'data'},
          ),
          const SocketEvent(
            topic: 'test',
            version: 2,
            data: 'data',
            json: {'t': 'test', 'v': 2, 'd': 'data'},
          ),
          const SocketEvent(
            topic: 'test',
            version: 3,
            data: 'data',
            json: {'t': 'test', 'v': 3, 'd': 'data'},
          ),
          const SocketEvent(
            topic: 'test',
            version: 4,
            data: 'data',
            json: {'t': 'test', 'v': 4, 'd': 'data'},
          ),
        ]),
      );

      async.elapse(kFakeWebSocketConnectionLag);

      // server sends the message
      sendServerSocketMessages(defaultSocketUri, [
        '{"t":"test","v":1, "d":"data"}',
        '{"t":"test","v":2, "d":"data"}',
        '{"t":"test","v":4, "d":"data"}',
      ]);

      async.flushMicrotasks();

      async.elapse(const Duration(milliseconds: 200));

      sendServerSocketMessages(defaultSocketUri, ['{"t":"test","v":3, "d":"data"}']);

      async.elapse(const Duration(milliseconds: 2000));

      expect(onEventGapFailureCalled, 0);

      socketClient.close();
    });
  });

  test('handle event gap failure', () {
    fakeAsync((async) {
      final fakeChannel = FakeWebSocketChannel(defaultSocketUri);

      int onEventGapFailureCalled = 0;

      final socketClient = makeTestSocketClient(
        fakeChannelFactory: FakeWebSocketChannelFactory((_) => fakeChannel),
        version: 0,
        onEventGapFailure: () {
          onEventGapFailureCalled++;
        },
      );
      socketClient.connect();

      socketClient.stream.listen((event) {
        // ignore the events
      });
      expectLater(
        socketClient.stream,
        emitsInOrder([
          const SocketEvent(
            topic: 'test',
            version: 1,
            data: 'data',
            json: {'t': 'test', 'v': 1, 'd': 'data'},
          ),
          const SocketEvent(
            topic: 'test',
            version: 2,
            data: 'data',
            json: {'t': 'test', 'v': 2, 'd': 'data'},
          ),
        ]),
      );

      async.elapse(kFakeWebSocketConnectionLag);

      // server sends the message
      sendServerSocketMessages(defaultSocketUri, [
        '{"t":"test","v":1, "d":"data"}',
        '{"t":"test","v":2, "d":"data"}',
        '{"t":"test","v":4, "d":"data"}',
      ]);

      async.flushMicrotasks();

      expect(onEventGapFailureCalled, 0);

      // wait for possibly missing events to be received

      async.elapse(const Duration(milliseconds: 2000));

      // check that the event gap failure was called after 2 seconds
      expect(onEventGapFailureCalled, 1);

      socketClient.close();
    });
  });

  group('SocketPool', () {
    test('closes the socket once the app has been in the background for a while', () async {
      final container = await makeContainer();
      final pool = container.read(socketPoolProvider);

      // The pool made by the test container does not connect on its own.
      pool.currentClient.connect();
      await pool.currentClient.firstConnection;
      expect(pool.currentClient.isActive, isTrue);

      fakeAsync((async) {
        pool.onAppHidden();

        async.elapse(const Duration(seconds: 59));
        expect(
          pool.currentClient.isActive,
          isTrue,
          reason: 'the socket is kept for a while, as the user may well come right back',
        );

        async.elapse(const Duration(seconds: 2));
        expect(pool.currentClient.isActive, isFalse);

        // Coming back to the app brings it up again.
        pool.onAppShown();
        expect(pool.currentClient.isActive, isTrue);

        pool.currentClient.close();
        async.flushTimers();
      });
    });

    test('reconnects the socket as soon as the device is back online', () async {
      var offline = true;
      final container = await makeContainer(overrides: offlineNetworkOverrides(() => offline));

      await container.read(connectivityChangesProvider.future);
      expect(container.read(isDeviceOnlineProvider), isFalse);

      final pool = container.read(socketPoolProvider);
      pool.currentClient.connect();
      await pumpEventQueue();
      expect(pool.currentClient.isConnected, isFalse);

      offline = false;
      FakeConnectivity.controller.add([ConnectivityResult.wifi]);

      // The socket, left to its own backoff, would not try again for seconds: connectivity knows
      // the network is back first and brings it up at once.
      await pool.currentClient.firstConnection.timeout(
        const Duration(seconds: 1),
        onTimeout: () => fail('the socket did not reconnect when the device came back online'),
      );
      await Future<void>.delayed(kFakeWebSocketConnectionLag * 4);
      expect(pool.currentClient.isConnected, isTrue);

      pool.currentClient.close();
    });

    test('does not reconnect the socket while the app is in the background', () async {
      var offline = true;
      var socketAttempts = 0;
      final container = await makeContainer(
        overrides: offlineNetworkOverrides(() => offline, onSocketAttempt: (_) => socketAttempts++),
      );

      await container.read(connectivityChangesProvider.future);

      final pool = container.read(socketPoolProvider);
      pool.currentClient.connect();
      await pumpEventQueue();
      expect(socketAttempts, 1);

      pool.onAppHidden();

      offline = false;
      FakeConnectivity.controller.add([ConnectivityResult.wifi]);
      await pumpEventQueue();
      await Future<void>.delayed(kFakeWebSocketConnectionLag * 4);

      expect(container.read(isDeviceOnlineProvider), isTrue);
      expect(
        socketAttempts,
        1,
        reason: 'nothing needs the socket while the app is in the background',
      );
      expect(pool.currentClient.isConnected, isFalse);

      // Coming back to the app is what brings it up.
      pool.onAppShown();
      await pool.currentClient.firstConnection.timeout(
        const Duration(seconds: 1),
        onTimeout: () => fail('the socket did not reconnect when the app came back'),
      );

      pool.currentClient.close();
    });

    test('nothing reopens the socket once it has been closed in the background', () async {
      final attempts = <Uri>[];
      final container = await makeContainer(
        overrides: offlineNetworkOverrides(() => false, onSocketAttempt: attempts.add),
      );
      final pool = container.read(socketPoolProvider);

      fakeAsync((async) {
        pool.currentClient.connect();
        async.elapse(const Duration(seconds: 1));
        expect(pool.currentClient.isConnected, isTrue);
        expect(attempts.length, 1);

        pool.onAppHidden();
        async.elapse(const Duration(minutes: 2));
        expect(pool.currentClient.isActive, isFalse, reason: 'the socket is closed in background');

        // Everything that would bring the socket back in the foreground must leave it closed
        // here, and no timer left over from the connected socket may bring it back either.
        pool.onDeviceOnline();
        pool.onAuthChanged();
        async.elapse(const Duration(minutes: 10));

        expect(attempts.length, 1, reason: 'the socket must stay closed while in the background');
        expect(pool.currentClient.isActive, isFalse);

        // The user coming back is the one thing that reopens it.
        pool.onAppShown();
        async.elapse(const Duration(seconds: 1));
        expect(attempts.length, 2);
        expect(pool.currentClient.isConnected, isTrue);

        pool.currentClient.close();
        async.flushTimers();
      });
    });

    test('takes on the connection state of the client it switches to', () async {
      const flakyRoute = '/flaky/socket/v5';
      var defaultRouteFails = false;
      final container = await makeContainer(
        overrides: {
          webSocketChannelFactoryProvider: webSocketChannelFactoryProvider.overrideWithValue(
            FakeWebSocketChannelFactory((route) {
              if (route.path == flakyRoute || defaultRouteFails) {
                throw const SocketException('No internet');
              }
              return createDefaultFakeWebSocketChannel(route);
            }),
          ),
        },
      );
      final pool = container.read(socketPoolProvider);

      var failingEdges = 0;
      pool.isFailing.addListener(() {
        if (pool.isFailing.value) failingEdges++;
      });

      fakeAsync((async) {
        pool.open(Uri(path: flakyRoute));
        async.elapse(const Duration(seconds: 1));
        expect(pool.isFailing.value, isTrue);
        expect(failingEdges, 1);

        // Back to the default socket, which connects: the pool must not be left holding the
        // failing state of the client it just closed.
        pool.open(Uri(path: kDefaultSocketRoute));
        async.elapse(const Duration(seconds: 1));
        expect(pool.isFailing.value, isFalse);

        // A failure on the new current client is then heard as the change it is.
        defaultRouteFails = true;
        pool.currentClient.connect();
        async.elapse(const Duration(seconds: 1));
        expect(pool.isFailing.value, isTrue);
        expect(failingEdges, 2, reason: 'this failure must reach the listeners too');

        pool.currentClient.close();
        async.flushTimers();
      });
    });

    test('does not reopen the default socket in the background when a route goes idle', () async {
      const route = '/lobby/socket/v5';
      final attempts = <Uri>[];
      final container = await makeContainer(
        overrides: offlineNetworkOverrides(() => false, onSocketAttempt: attempts.add),
      );
      final pool = container.read(socketPoolProvider);

      fakeAsync((async) {
        final client = pool.open(Uri(path: route));
        final subscription = client.stream.listen((_) {});
        async.elapse(const Duration(seconds: 1));
        expect(attempts.map((uri) => uri.path), [route]);

        pool.onAppHidden();
        async.elapse(const Duration(minutes: 2));

        // The screen that was using this route is gone: the pool disposes its idle client, which
        // in the foreground would have it fall back to the default socket.
        subscription.cancel();
        async.elapse(const Duration(minutes: 1));

        expect(attempts.map((uri) => uri.path), [route]);
        expect(pool.currentClient.isActive, isFalse);

        async.flushTimers();
      });
    });
  });
}

/// Overrides for a container whose network is entirely down — the connectivity check and the
/// socket alike — for as long as [isOffline] returns true.
Map<ProviderOrFamily, Override> offlineNetworkOverrides(
  bool Function() isOffline, {
  void Function(Uri route)? onSocketAttempt,
}) => {
  httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
    (ref) => FakeHttpClientFactory(
      () => MockClient((request) async {
        if (isOffline()) throw const SocketException('No internet');
        return http.Response('', 200);
      }),
    ),
  ),
  webSocketChannelFactoryProvider: webSocketChannelFactoryProvider.overrideWithValue(
    FakeWebSocketChannelFactory((route) {
      onSocketAttempt?.call(route);
      if (isOffline()) throw const SocketException('No internet');
      return createDefaultFakeWebSocketChannel(route);
    }),
  ),
};

Future<void> testEventEmitted(
  SocketClient socketClient,
  FakeWebSocketChannel fakeChannel,
  String serverMessage,
  Iterable<SocketEvent> eventsToMatch,
) async {
  // start listening to the stream
  final futureExpect = expectLater(socketClient.stream, emitsInOrder(eventsToMatch));

  // server sends the message
  sendServerSocketMessages(defaultSocketUri, [serverMessage]);

  // check that the socket events were emitted in order
  await futureExpect;
}
