import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:logging/logging.dart';

import '../../test_container.dart';
import 'fake_websocket_channel.dart';

SocketService _makeSocketClient(ProviderRef<SocketService> ref) {
  final client = SocketService(
    ref,
    Logger('TestSocketClient'),
    pingDelay: const Duration(milliseconds: 50),
    pingMaxLag: const Duration(milliseconds: 200),
    autoReconnectDelay: const Duration(milliseconds: 100),
    resendAckDelay: const Duration(milliseconds: 100),
  );

  ref.onDispose(client.dispose);

  return client;
}

void main() {
  final testUri = Uri.parse(kDefaultSocketRoute);

  group('Socket', () {
    test('computes average lag', () async {
      final fakeChannel = FakeWebSocketChannel();
      final container = await makeContainer(
        overrides: [
          webSocketChannelFactoryProvider.overrideWith(
            (_) => FakeWebSocketChannelFactory(() => fakeChannel),
          ),
          socketServiceProvider.overrideWith(_makeSocketClient),
        ],
      );

      final socketClient = container.read(socketServiceProvider);
      final (_, readyStream) = socketClient.connect(testUri);

      // before the connection is ready the average lag is zero
      expect(socketClient.averageLag.value, Duration.zero);

      await readyStream.first;

      // after the connection is ready the average lag is still zero since
      // there was no ping/pong exchange yet
      expect(socketClient.averageLag.value, Duration.zero);

      // at this time the first ping is sent, wait for the pong
      await expectLater(fakeChannel.stream, emits('0'));

      // after the ping/pong exchange the average lag is computed
      expect(
        socketClient.averageLag.value.inMilliseconds,
        greaterThanOrEqualTo(10),
      );

      // wait for more ping/pong exchanges
      await expectLater(fakeChannel.stream, emitsInOrder(['0', '0', '0', '0']));

      // average lag is still the same
      expect(
        socketClient.averageLag.value.inMilliseconds,
        greaterThanOrEqualTo(10),
      );

      // increase the lag of the connection
      fakeChannel.connectionLag = const Duration(milliseconds: 100);

      // wait for more ping/pong exchanges
      await expectLater(fakeChannel.stream, emitsInOrder(['0', '0', '0', '0']));

      // average lag should be higher
      expect(
        socketClient.averageLag.value.inMilliseconds,
        greaterThanOrEqualTo(40),
      );

      await socketClient.disconnect();

      // after disconnecting the average lag is zero again
      expect(socketClient.averageLag.value, Duration.zero);
    });

    test('handles ping/pong', () async {
      final fakeChannel = FakeWebSocketChannel();

      final container = await makeContainer(
        overrides: [
          webSocketChannelFactoryProvider.overrideWith(
            (_) => FakeWebSocketChannelFactory(() => fakeChannel),
          ),
          socketServiceProvider.overrideWith(_makeSocketClient),
        ],
      );

      final socketClient = container.read(socketServiceProvider);
      final (_, readyStream) = socketClient.connect(testUri);

      int sentPingCount = 0;
      fakeChannel.sentMessages.forEach((message) {
        if (FakeWebSocketChannel.isPing(message)) {
          sentPingCount++;
          // close after 3 pings
          if (sentPingCount == 3) {
            socketClient.disconnect();
          }
        }
      });

      // 1 ready event is expected
      expectLater(readyStream, emitsInOrder([testUri]));

      // 2 pong messages are expected since we're closing just after 3 pings
      await expectLater(fakeChannel.stream, emitsInOrder(['0', '0']));
    });

    test('reconnects when connection attempt fails', () async {
      int numConnectionAttempts = 0;

      final container = await makeContainer(
        overrides: [
          webSocketChannelFactoryProvider.overrideWith(
            (_) => FakeWebSocketChannelFactory(() {
              numConnectionAttempts++;
              if (numConnectionAttempts == 1) {
                throw const SocketException('Connection failed');
              }
              return FakeWebSocketChannel();
            }),
          ),
          socketServiceProvider.overrideWith(_makeSocketClient),
        ],
      );

      final socketClient = container.read(socketServiceProvider);
      final (_, readyStream) = socketClient.connect(testUri);

      // The first connection attempt will fail, but the second one will succeed
      await expectLater(readyStream, emitsInOrder([testUri]));

      expect(numConnectionAttempts, 2);

      socketClient.disconnect();
    });

    test('reconnects automatically if pong is not received', () async {
      int numConnectionAttempts = 0;
      // channels per connection attempt
      final Map<int, FakeWebSocketChannel> channels = {};

      final container = await makeContainer(
        overrides: [
          webSocketChannelFactoryProvider.overrideWith(
            (_) => FakeWebSocketChannelFactory(() {
              numConnectionAttempts++;
              final channel = FakeWebSocketChannel();
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
            }),
          ),
          socketServiceProvider.overrideWith(_makeSocketClient),
        ],
      );

      final socketClient = container.read(socketServiceProvider);
      final (_, readyStream) = socketClient.connect(testUri);

      await readyStream.first;

      // will only receive 3 pings since the server stops responding to pings
      expectLater(channels[1]!.stream, emitsInOrder(['0', '0', '0']));

      // we expect another connection because it reconnects if not receiving pong
      await expectLater(readyStream, emits(testUri));

      // check the the first connection was closed
      // no need to check the close code since it will alway be 1000 in our fake channel
      expect(channels[1]!.closeCode, isNotNull);
      expect(channels[2]!.closeCode, isNull);

      socketClient.disconnect();
    });

    test('handles ackable messages', () async {
      final fakeChannel = FakeWebSocketChannel();

      final container = await makeContainer(
        overrides: [
          webSocketChannelFactoryProvider.overrideWith(
            (_) => FakeWebSocketChannelFactory(() => fakeChannel),
          ),
          socketServiceProvider.overrideWith(_makeSocketClient),
        ],
      );

      final socketClient = container.read(socketServiceProvider);
      final (_, readyStream) = socketClient.connect(testUri);

      await readyStream.first;

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
      await fakeChannel.addIncomingMessages(['{"t":"ack","d":1}']);

      // no more messages are expected
      await expectLater(
        fakeChannel.sentMessagesExceptPing,
        emitsInOrder([]),
      );

      socketClient.disconnect();
    });
  });
}
