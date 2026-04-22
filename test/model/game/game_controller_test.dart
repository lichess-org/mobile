import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game_controller.dart';
import 'package:lichess_mobile/src/network/http.dart';

import '../../network/fake_http_client_factory.dart';
import '../../network/fake_websocket_channel.dart';
import '../../test_container.dart';
import '../../test_helpers.dart';
import '../auth/fake_auth_storage.dart';

const _ratedBlitzFullEvent = '''
{
  "t": "full",
  "d": {
    "game": {
      "id": "qVChCOTc",
      "variant": {"key": "standard", "name": "Standard", "short": "Std"},
      "speed": "blitz",
      "perf": "blitz",
      "rated": true,
      "source": "lobby",
      "status": {"id": 20, "name": "started"},
      "createdAt": 1685698678928,
      "pgn": ""
    },
    "white": {"user": {"name": "testUser", "id": "testuser"}, "rating": 1500, "onGame": true},
    "black": {"user": {"name": "opponent", "id": "opponent"}, "rating": 1500, "onGame": true},
    "clock": {
      "running": false,
      "initial": 180,
      "increment": 2,
      "white": 180,
      "black": 180,
      "emerg": 30,
      "moretime": 15
    },
    "youAre": "white",
    "socket": 0,
    "expiration": {"idleMillis": 245, "millisToMove": 30000},
    "chat": {"lines": []}
  }
}
''';

const _unratedBlitzFullEvent = '''
{
  "t": "full",
  "d": {
    "game": {
      "id": "qVChCOTc",
      "variant": {"key": "standard", "name": "Standard", "short": "Std"},
      "speed": "blitz",
      "perf": "blitz",
      "rated": false,
      "source": "lobby",
      "status": {"id": 20, "name": "started"},
      "createdAt": 1685698678928,
      "pgn": ""
    },
    "white": {"user": {"name": "testUser", "id": "testuser"}, "rating": 1500, "onGame": true},
    "black": {"user": {"name": "opponent", "id": "opponent"}, "rating": 1500, "onGame": true},
    "clock": {
      "running": false,
      "initial": 180,
      "increment": 2,
      "white": 180,
      "black": 180,
      "emerg": 30,
      "moretime": 15
    },
    "youAre": "white",
    "socket": 0,
    "expiration": {"idleMillis": 245, "millisToMove": 30000},
    "chat": {"lines": []}
  }
}
''';

String _accountResponse({required int blitzRating}) =>
    '''
{
  "id": "testuser",
  "username": "testUser",
  "createdAt": 1290415680000,
  "seenAt": 1290415680000,
  "perfs": {
    "blitz": {"games": 2340, "rating": $blitzRating, "rd": 30, "prog": 10}
  }
}
''';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GameController — account refresh on game end (issue #2387)', () {
    test('refreshes accountProvider when a rated game ends with a ratingDiff', () async {
      const gameFullId = GameFullId('ratedGameAAA');
      final gameSocketUri = GameController.socketUri(gameFullId);

      var accountRequestCount = 0;

      final mockClient = MockClient((request) {
        if (request.url.path == '/api/account') {
          accountRequestCount += 1;
          final rating = accountRequestCount == 1 ? 1500 : 1510;
          return mockResponse(_accountResponse(blitzRating: rating), 200);
        }
        return mockResponse('', 404);
      });

      final container = await makeContainer(
        authUser: fakeAuthUser,
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => mockClient);
          }),
        },
      );

      // Keep accountProvider alive across invalidation; otherwise autoDispose
      // would clear the cache between reads and mask the bug.
      container.listen(accountProvider, (_, _) {});

      // Prime the account cache — stale, pre-game rating.
      final before = await container.read(accountProvider.future);
      expect(accountRequestCount, 1);
      expect(before, isNotNull);

      // Start the game controller and initialize with a 'full' event. Keep
      // the controller alive (it's autoDispose) so its ref stays valid across
      // the async gap where the full event arrives.
      container.listen(gameControllerProvider(gameFullId), (_, _) {});
      final controllerFuture = container.read(gameControllerProvider(gameFullId).future);
      await Future<void>.delayed(kFakeWebSocketConnectionLag);
      sendServerSocketMessages(gameSocketUri, [_ratedBlitzFullEvent]);
      // wait for build() to resolve on the full event
      await controllerFuture;

      // Rated game ends with a rating change.
      const ratedEndData =
          '{"t":"endData","d":{"status":"resign","winner":"black","ratingDiff":{"white":-10,"black":10}}}';
      sendServerSocketMessages(gameSocketUri, [ratedEndData]);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      // Re-read accountProvider. With the fix in place, the prior endData
      // invalidated the cached account, so this read triggers a fresh HTTP
      // fetch and returns the updated rating. Without the fix, the cache is
      // still warm and no second request is made.
      final after = await container.read(accountProvider.future);
      expect(
        accountRequestCount,
        2,
        reason:
            'endData for a rated game should invalidate accountProvider so the '
            "next consumer (e.g. 'New Opponent') sees the updated rating",
      );
      expect(after, isNotNull);
    });

    test('does not refresh accountProvider for unrated games', () async {
      const gameFullId = GameFullId('unratedGmBBB');
      final gameSocketUri = GameController.socketUri(gameFullId);

      var accountRequestCount = 0;

      final mockClient = MockClient((request) {
        if (request.url.path == '/api/account') {
          accountRequestCount += 1;
          return mockResponse(_accountResponse(blitzRating: 1500), 200);
        }
        return mockResponse('', 404);
      });

      final container = await makeContainer(
        authUser: fakeAuthUser,
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => mockClient);
          }),
        },
      );

      container.listen(accountProvider, (_, _) {});
      await container.read(accountProvider.future);
      expect(accountRequestCount, 1);

      container.listen(gameControllerProvider(gameFullId), (_, _) {});
      final controllerFuture = container.read(gameControllerProvider(gameFullId).future);
      await Future<void>.delayed(kFakeWebSocketConnectionLag);
      sendServerSocketMessages(gameSocketUri, [_unratedBlitzFullEvent]);
      await controllerFuture;

      sendServerSocketMessages(gameSocketUri, [
        '{"t":"endData","d":{"status":"resign","winner":"black"}}',
      ]);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      await container.read(accountProvider.future);
      expect(
        accountRequestCount,
        1,
        reason: 'an unrated game does not change the rating, so no refresh is needed',
      );
    });
  });
}
