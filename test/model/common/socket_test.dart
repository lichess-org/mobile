import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';

import '../../test_container.dart';
import 'fake_websocket_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Socket', () {
    test('emits a ready event', () async {
      final fakeChannel = FakeWebSocketChannel();

      final container = await makeContainer(
        overrides: [
          webSocketChannelFactoryProvider.overrideWith(
            (_) => FakeWebSocketChannelFactory(() => fakeChannel),
          ),
        ],
      );

      final socketClient = container.read(socketClientProvider);
      final (_, readyStream) =
          socketClient.connect(Uri.parse(kDefaultSocketRoute));

      expectLater(readyStream, emitsInOrder([Uri.parse(kDefaultSocketRoute)]));
    });

    test('handles ping/pong', () async {
      final fakeChannel = FakeWebSocketChannel();

      final container = await makeContainer(
        overrides: [
          webSocketChannelFactoryProvider.overrideWith(
            (_) => FakeWebSocketChannelFactory(() => fakeChannel),
          ),
        ],
      );

      final socketClient = container.read(socketClientProvider);
      final (_, _) = socketClient.connect(Uri.parse(kDefaultSocketRoute));

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

      // 2 pong messages are expected since we're closing just after 3 pings
      expectLater(fakeChannel.stream, emitsInOrder(['0', '0']));
    });
  });
}
