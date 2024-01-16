import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:logging/logging.dart';

import '../../test_container.dart';
import 'fake_websocket_channel.dart';

SocketClient _makeSocketClient(ProviderRef<SocketClient> ref) {
  final client = SocketClient(
    ref,
    Logger('TestSocketClient'),
    pingDelay: const Duration(milliseconds: 50),
    pingMaxLag: const Duration(milliseconds: 200),
    autoReconnectDelay: const Duration(milliseconds: 100),
  );

  ref.onDispose(client.dispose);

  return client;
}

void main() {
  final testUri = Uri.parse(kDefaultSocketRoute);

  group('Socket', () {
    test('emits a ready event', () async {
      final container = await makeContainer(
        overrides: [
          webSocketChannelFactoryProvider.overrideWith(
            (_) => FakeWebSocketChannelFactory(() => FakeWebSocketChannel()),
          ),
          socketClientProvider.overrideWith(_makeSocketClient),
        ],
      );

      final socketClient = container.read(socketClientProvider);
      final (_, readyStream) = socketClient.connect(testUri);

      await expectLater(readyStream, emitsInOrder([testUri]));

      socketClient.disconnect();
    });

    test('handles ping/pong', () async {
      final fakeChannel = FakeWebSocketChannel();

      final container = await makeContainer(
        overrides: [
          webSocketChannelFactoryProvider.overrideWith(
            (_) => FakeWebSocketChannelFactory(() => fakeChannel),
          ),
          socketClientProvider.overrideWith(_makeSocketClient),
        ],
      );

      final socketClient = container.read(socketClientProvider);
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
          socketClientProvider.overrideWith(_makeSocketClient),
        ],
      );

      final socketClient = container.read(socketClientProvider);
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
          socketClientProvider.overrideWith(_makeSocketClient),
        ],
      );

      final socketClient = container.read(socketClientProvider);
      final (_, readyStream) = socketClient.connect(testUri);

      expectLater(channels[1]!.stream, emitsInOrder(['0', '0', '0']));

      // we expect 2 working connections because it reconnects if not receiving pong
      await expectLater(readyStream, emitsInOrder([testUri, testUri]));

      // check the the first connection was closed, no need to check the close
      // code since it will alway be 1000 in our fake channel
      expect(channels[1]!.closeCode, isNotNull);
      expect(channels[2]!.closeCode, isNull);

      socketClient.disconnect();
    });
  });
}
