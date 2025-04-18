import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'fake_websocket_channel.dart';

final defaultSocketUri = Uri(path: kDefaultSocketRoute);

SocketClient makeTestSocketClient({
  FakeWebSocketChannelFactory fakeChannelFactory = defaultFakeWebSocketChannelFactory,
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
    resendAckDelay: const Duration(milliseconds: 100),
  );

  return client;
}

void main() {
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

      // check the the first connection was closed
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
        SocketEvent(topic: 'test1', data: 'data'),
        SocketEvent(topic: 'test2', data: 'data'),
        SocketEvent(topic: 'test3', data: 'data'),
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
    const randomEvent = SocketEvent(topic: 'test', data: 'data');
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
          const SocketEvent(topic: 'test', version: 1, data: 'data'),
          const SocketEvent(topic: 'test', version: 2, data: 'data'),
          const SocketEvent(topic: 'test', version: 3, data: 'data'),
          const SocketEvent(topic: 'test', version: 4, data: 'data'),
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
          const SocketEvent(topic: 'test', version: 1, data: 'data'),
          const SocketEvent(topic: 'test', version: 2, data: 'data'),
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
}

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
