import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/tournament/tournament_controller.dart';
import 'package:lichess_mobile/src/network/http.dart';

import '../../network/fake_http_client_factory.dart';
import '../../test_container.dart';

const _tournamentId = TournamentId('tourn001');
const _gameId = 'featured';
const _nextGameId = 'feature2';
const _fenBefore = '8/8/8/8/8/8/8/K6k w - - 0 1';
const _fenAfter = '8/8/8/8/8/8/8/K5pk w - - 0 1';

/// Exposes the socket handler so the race can be driven deterministically.
class _TestTournamentController(super.id) extends TournamentController {
  void dispatch(SocketEvent event) => handleSocketEvent(event);
}

final _controllerProvider = AsyncNotifierProvider.autoDispose
    .family<_TestTournamentController, TournamentState, TournamentId>(
      _TestTournamentController.new,
      name: 'TestTournamentControllerProvider',
    );

String _featuredGameJson(String fen, {String gameId = _gameId}) =>
    '''
  "featured": {
    "id": "$gameId",
    "fen": "$fen",
    "orientation": "white",
    "lastMove": "e2e4",
    "white": { "name": "White", "id": "white" },
    "black": { "name": "Black", "id": "black" },
    "c": { "white": 10, "black": 10 }
  }''';

String _tournamentJson(String fen) =>
    '''
{
  "id": "$_tournamentId",
  "socketVersion": 0,
  "nbPlayers": 10,
  "fullName": "Test Arena",
  "createdBy": "lichess",
  "clock": { "limit": 60, "increment": 0 },
  "minutes": 60,
  "rated": true,
  "perf": "blitz",
  "variant": "standard",
  ${_featuredGameJson(fen)},
  "verdicts": { "list": [], "accepted": true },
  "standing": { "page": 1, "players": [] }
}
''';

String _reloadJson(String fen, {String gameId = _gameId}) =>
    '''
{
  "nbPlayers": 10,
  "standing": { "page": 1, "players": [] },
  ${_featuredGameJson(fen, gameId: gameId)}
}
''';

void _keepAlive(ProviderContainer container) {
  final subscription = container.listen(_controllerProvider(_tournamentId), (_, _) {});
  addTearDown(subscription.close);
}

void main() {
  test('a FEN received during an in-flight reload is not clobbered by the stale '
      'snapshot the reload captured', () async {
    final reloadResponse = Completer<http.Response>();

    final client = MockClient((request) {
      if (request.url.queryParameters['partial'] == 'true') {
        return reloadResponse.future;
      }
      if (request.url.path == '/api/tournament/$_tournamentId') {
        return Future.value(http.Response(_tournamentJson(_fenBefore), 200));
      }
      return Future.value(http.Response('', 404));
    });

    final container = await makeContainer(
      overrides: {
        httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
          return FakeHttpClientFactory(() => client);
        }),
      },
    );

    _keepAlive(container);
    final notifier = container.read(_controllerProvider(_tournamentId).notifier);
    await container.read(_controllerProvider(_tournamentId).future);
    expect(notifier.state.requireValue.featuredGame!.fen, _fenBefore);

    // A reload event makes the controller capture the current snapshot and start
    // the HTTP request, which we hold open with a completer.
    notifier.dispatch(const SocketEvent(topic: 'reload'));
    await Future<void>.delayed(Duration.zero);

    // A newer move arrives over the socket while the reload request is in flight.
    notifier.dispatch(
      const SocketEvent(
        topic: 'fen',
        data: {'id': _gameId, 'fen': _fenAfter, 'lm': 'g7g8', 'wc': 9, 'bc': 9},
      ),
    );
    expect(notifier.state.requireValue.featuredGame!.fen, _fenAfter);

    // The reload response arrives, carrying the previous move's FEN.
    reloadResponse.complete(http.Response(_reloadJson(_fenBefore), 200));
    await Future<void>.delayed(Duration.zero);

    // The fresher websocket FEN must win over the stale reload snapshot.
    expect(notifier.state.requireValue.featuredGame!.fen, _fenAfter);
  });

  test('an older overlapping reload cannot revert a newer featured game', () async {
    final first = Completer<http.Response>();
    final second = Completer<http.Response>();
    final responses = [first, second];

    final client = MockClient((request) {
      if (request.url.queryParameters['partial'] == 'true') {
        return responses.removeAt(0).future;
      }
      if (request.url.path == '/api/tournament/$_tournamentId') {
        return Future.value(http.Response(_tournamentJson(_fenBefore), 200));
      }
      return Future.value(http.Response('', 404));
    });

    final container = await makeContainer(
      overrides: {
        httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
          return FakeHttpClientFactory(() => client);
        }),
      },
    );

    _keepAlive(container);
    final notifier = container.read(_controllerProvider(_tournamentId).notifier);
    await container.read(_controllerProvider(_tournamentId).future);

    // Two reload events fire before either request completes.
    notifier.dispatch(const SocketEvent(topic: 'reload'));
    await Future<void>.delayed(Duration.zero);
    notifier.dispatch(const SocketEvent(topic: 'reload'));
    await Future<void>.delayed(Duration.zero);

    // The newer response (second request) introduces a new featured game.
    second.complete(http.Response(_reloadJson(_fenAfter, gameId: _nextGameId), 200));
    await Future<void>.delayed(Duration.zero);
    expect(notifier.state.requireValue.featuredGame!.id.value, _nextGameId);

    // The older response (first request) arrives late, carrying the old game.
    first.complete(http.Response(_reloadJson(_fenBefore, gameId: _gameId), 200));
    await Future<void>.delayed(Duration.zero);

    // It must be ignored, so the socket keeps watching the current game.
    expect(notifier.state.requireValue.featuredGame!.id.value, _nextGameId);
  });
}
