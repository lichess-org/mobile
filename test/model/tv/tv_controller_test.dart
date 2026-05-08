import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/tv/tv_channel.dart';
import 'package:lichess_mobile/src/model/tv/tv_controller.dart';

import '../../network/fake_websocket_channel.dart';
import '../../test_container.dart';
import '../game/game_socket_example_data.dart';

void main() {
  group('TvController', () {
    test('continues watching the selected channel after a channel-only tvSelect event', () async {
      const firstGameId = GameId('firstTv1');
      const nextGameId = GameId('nextTv22');
      var channelRequests = 0;

      final client = MockClient((request) async {
        if (request.url.path == '/api/tv/channels') {
          channelRequests++;
          final gameId = channelRequests == 1 ? firstGameId : nextGameId;
          return http.Response(
            '''
            {
              "blitz": {
                "color": "white",
                "gameId": "$gameId",
                "rating": 2615,
                "user": {"id": "whitePlayer", "name": "whitePlayer"}
              }
            }
            ''',
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response('', 404);
      });

      final container = await lichessClientContainer(client);
      final provider = tvControllerProvider((
        channel: TvChannel.blitz,
        initialGame: null,
        userId: null,
      ));
      final subscription = container.listen(provider, (_, _) {});
      addTearDown(subscription.close);

      await Future<void>.delayed(kFakeWebSocketConnectionLag);
      sendServerSocketMessages(Uri(path: '/watch/$firstGameId/white/v6'), [
        makeFullEvent(firstGameId, '', whiteUserName: 'whitePlayer', blackUserName: 'blackPlayer'),
      ]);

      final firstState = await container.read(provider.future);
      expect(firstState.game.id, firstGameId);

      final nextGameCompleter = Completer<void>();
      final nextGameSubscription = container.listen(provider, (_, next) {
        if (next.value?.game.id == nextGameId && !nextGameCompleter.isCompleted) {
          nextGameCompleter.complete();
        }
      });
      addTearDown(nextGameSubscription.close);

      sendServerSocketMessages(Uri(path: '/watch/$firstGameId/white/v6'), [
        '{"t":"endData","d":{"status":"resign","winner":"white","clock":{"wc":0,"bc":1000}}}',
        '{"t":"tvSelect","d":{"channel":"blitz"}}',
      ]);

      await _waitUntil(() => channelRequests == 2);
      await Future<void>.delayed(kFakeWebSocketConnectionLag);
      sendServerSocketMessages(Uri(path: '/watch/$nextGameId/white/v6'), [
        makeFullEvent(nextGameId, '', whiteUserName: 'nextWhite', blackUserName: 'nextBlack'),
      ]);

      await nextGameCompleter.future.timeout(const Duration(seconds: 1));
      expect(container.read(provider).requireValue.game.id, nextGameId);
    });
  });
}

Future<void> _waitUntil(bool Function() condition) async {
  while (!condition()) {
    await Future<void>.delayed(Duration.zero);
  }
}
