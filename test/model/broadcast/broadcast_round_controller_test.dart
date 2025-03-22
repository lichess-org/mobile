import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_round_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../network/fake_http_client_factory.dart';
import '../../network/fake_websocket_channel.dart';
import '../../test_container.dart';
import '../../test_helpers.dart';

void main() {
  group('BroadcastRoundController', () {
    test('Test versionning', () async {
      final mockClient = MockClient((request) {
        if (request.url.path == '/api/broadcast/-/-/00000000') {
          return mockResponse(
            _liveRoundResponse,
            200,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        }
        return mockResponse('', 404);
      });

      final fakeChannelCompleter = Completer<WebSocketChannel>();

      final container = await makeContainer(
        overrides: [
          httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => mockClient);
          }),
          webSocketChannelFactoryProvider.overrideWith((ref) {
            return FakeWebSocketChannelFactory((_) => fakeChannelCompleter.future);
          }),
        ],
      );

      final subscription = container.listen(
        broadcastRoundControllerProvider(const BroadcastRoundId('00000000')),
        (_, _) {},
      );

      expect(subscription.read(), const AsyncLoading<BroadcastRoundState>());

      final fakeChannel = FakeWebSocketChannel();
      fakeChannelCompleter.complete(fakeChannel);
      await pumpEventQueue();

      expect(subscription.read(), isA<AsyncData<BroadcastRoundState>>());

      fakeChannel.addIncomingMessages([addNodeEvent]);
    });
  });
}

const _liveRoundResponse = '''
{
  "socketVersion": 10,
  "round": {
    "id": "00000000",
    "name": "Test round",
    "slug": "test-round",
    "ongoing": true
  },
  "tour": {
    "id": "AAAAAAAA",
    "name": "Test tournament",
    "slug": "test-tournament",
    "dates": [
      1735671720000
    ],
    "image": ""
  },
  "study": {
    "writeable": false
  },
  "games": [
    {
      "id": "11111111",
      "name": "Nepomniachtchi, Ian - Carlsen, Magnus",
      "fen": "rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq - 0 1",
      "players": [
        {
          "name": "Nepomniachtchi, Ian",
          "title": "GM",
          "rating": 2770,
          "fideId": 4168119,
          "fed": "RUS",
          "clock": 2000
        },
        {
          "name": "Carlsen, Magnus",
          "title": "GM",
          "rating": 2890,
          "fideId": 1503014,
          "fed": "NOR",
          "clock": 800
        }
      ],
      "lastMove": "e2e4",
      "status": "*"
    }
  ]
}
''';

const addNodeEvent = '''
{
	"v": 11,
	"t": "addNode",
	"d": {
		"n": {
			"ply": 2,
			"fen": "rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2",
			"id": "WG",
			"uci": "e7e5",
			"san": "e5",
			"clock": 400
		},
		"p": {
			"chapterId": "11111111",
			"path": "/?"
		},
		"s": false,
		"relayPath": "!"
	}
}
''';
