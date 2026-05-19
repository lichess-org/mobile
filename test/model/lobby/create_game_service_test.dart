import 'dart:async' show unawaited;

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/lobby/create_game_service.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/network/http.dart';

import '../../network/fake_http_client_factory.dart';
import '../../test_container.dart';
import '../auth/fake_auth_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const seek = GameSeek(clock: (Duration(minutes: 5), Duration.zero), rated: false);

  group('cancelSeek', () {
    test('is a no-op when there is no active lobby seek', () async {
      final deleteRequests = <http.Request>[];
      final mockClient = MockClient((request) async {
        if (request.method == 'DELETE') deleteRequests.add(request);
        return http.Response('', 200);
      });

      final container = await makeContainer(
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => mockClient);
          }),
        },
      );

      await container.read(createGameServiceProvider).cancelSeek();

      expect(deleteRequests, isEmpty);
    });

    test('cancels the active seek when one is in progress', () async {
      final deleteRequests = <http.Request>[];
      final mockClient = MockClient((request) async {
        if (request.method == 'DELETE') deleteRequests.add(request);
        return http.Response('', 200);
      });

      final container = await makeContainer(
        authUser: fakeAuthUser,
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
            return FakeHttpClientFactory(() => mockClient);
          }),
        },
      );

      final service = container.read(createGameServiceProvider);

      // newLobbyGame sets _lobbyConnection synchronously before its first await
      // (socketClient.firstConnection), so the seek is considered active immediately.
      unawaited(service.newLobbyGame(seek));

      await service.cancelSeek();

      expect(deleteRequests, hasLength(1));
      expect(deleteRequests.first.url.path, '/api/board/seek');
    });
  });
}
