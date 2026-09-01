import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/engine/maia_online_book.dart';
import 'package:lichess_mobile/src/model/engine/opponent_level.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/network/http.dart';

import '../../network/fake_http_client_factory.dart';
import '../../test_container.dart';
import '../../test_helpers.dart';

/// An explorer answer: 1.e4 60%, 1.d4 30%, 1.b3 8%, 1.a3 2% of 1000 games.
///
/// [_tailResponse] adds a 1.5% move, which the bundled book's cutoff would drop.
const _response = '''
{
  "white": 500, "draws": 100, "black": 400,
  "moves": [
    {"uci": "e2e4", "san": "e4", "white": 300, "draws": 60, "black": 240},
    {"uci": "d2d4", "san": "d4", "white": 150, "draws": 30, "black": 120},
    {"uci": "b2b3", "san": "b3", "white": 40, "draws": 8, "black": 32},
    {"uci": "a2a3", "san": "a3", "white": 10, "draws": 2, "black": 8}
  ]
}
''';

const _tailResponse = '''
{
  "white": 500, "draws": 100, "black": 400,
  "moves": [
    {"uci": "e2e4", "san": "e4", "white": 300, "draws": 60, "black": 225},
    {"uci": "d2d4", "san": "d4", "white": 150, "draws": 30, "black": 120},
    {"uci": "b2b3", "san": "b3", "white": 40, "draws": 8, "black": 32},
    {"uci": "a2a3", "san": "a3", "white": 10, "draws": 2, "black": 8},
    {"uci": "g1f3", "san": "Nf3", "white": 8, "draws": 2, "black": 5}
  ]
}
''';

void main() {
  group('MaiaOnlineBook', () {
    Future<({MaiaOnlineBook book, List<Uri> requests})> makeBook({
      bool isOnline = true,
      String response = _response,
      int status = 200,
      Duration delay = Duration.zero,
    }) async {
      final requests = <Uri>[];
      final client = MockClient((request) async {
        requests.add(request.url);
        if (delay > Duration.zero) await Future<void>.delayed(delay);
        return mockResponse(response, status);
      });
      final container = await makeContainer(
        overrides: {
          httpClientFactoryProvider: httpClientFactoryProvider.overrideWith(
            (ref) => FakeHttpClientFactory(() => client),
          ),
          isDeviceOnlineProvider: isDeviceOnlineProvider.overrideWithValue(isOnline),
          maiaOnlineBookProvider: maiaOnlineBookProvider.overrideWith(MaiaOnlineBook.new),
        },
      );
      return (book: container.read(maiaOnlineBookProvider), requests: requests);
    }

    test('reads the explorer for the band the network was trained on', () async {
      final (:book, :requests) = await makeBook();

      final moves = await book.movesFor(Chess.initial, MaiaRating.maia1500);

      expect(requests, hasLength(1));
      expect(requests.single.path, '/lichess');
      // maia1500 falls in the 1400 bucket, which runs to 1599.
      expect(requests.single.queryParameters['ratings'], '1400');
      expect(requests.single.queryParameters['speeds'], 'blitz,rapid');
      expect(moves.map((move) => move.uci), ['e2e4', 'd2d4', 'b2b3', 'a2a3']);
    });

    test('weights the moves by how often they were played', () async {
      final (:book, requests: _) = await makeBook();

      final moves = await book.movesFor(Chess.initial, MaiaRating.maia1500);

      expect(moves.map((move) => move.weight), [600, 300, 80, 20]);
    });

    test('keeps more of the tail than the bundled book, which pays for its bytes', () async {
      final (:book, requests: _) = await makeBook(response: _tailResponse);

      final moves = await book.movesFor(Chess.initial, MaiaRating.maia1500);

      // 1.5% of the games: under the bundled book's 2% cutoff, over the online book's 1%.
      expect(moves.map((move) => move.uci), contains('g1f3'));
      expect(moves.last.uci, 'g1f3');
    });

    test('asks nothing of the network when the device is offline', () async {
      final (:book, :requests) = await makeBook(isOnline: false);

      expect(await book.movesFor(Chess.initial, MaiaRating.maia1500), isEmpty);
      expect(requests, isEmpty);
    });

    test('gives up rather than failing the move when the request fails', () async {
      final (:book, :requests) = await makeBook(status: 500);

      // Empty is the signal to read the bundled book instead.
      expect(await book.movesFor(Chess.initial, MaiaRating.maia1500), isEmpty);
      expect(requests, hasLength(1));
    });

    test('gives up on a slow explorer rather than holding the move up', () async {
      final (:book, requests: _) = await makeBook(delay: const Duration(seconds: 3));

      final elapsed = Stopwatch()..start();
      expect(await book.movesFor(Chess.initial, MaiaRating.maia1500), isEmpty);

      expect(elapsed.elapsed, lessThan(const Duration(seconds: 3)));
    });

    test('asks once per position and band', () async {
      final (:book, :requests) = await makeBook();

      await book.movesFor(Chess.initial, MaiaRating.maia1500);
      await book.movesFor(Chess.initial, MaiaRating.maia1400);

      // maia1400 and maia1500 share the 1400 bucket, so the answer is already known.
      expect(requests, hasLength(1));
    });

    test('stops where the bundled book does', () async {
      final (:book, :requests) = await makeBook();

      var position = Chess.initial as Position;
      for (final uci in [
        'e2e4',
        'e7e5',
        'g1f3',
        'b8c6',
        'f1b5',
        'a7a6',
        'b5a4',
        'g8f6',
        'e1g1',
        'f8e7',
      ]) {
        position = position.play(NormalMove.fromUci(uci));
      }

      expect(position.ply, 10);
      expect(await book.movesFor(position, MaiaRating.maia1500), isEmpty);
      expect(requests, isEmpty);
    });

    test('maps every rating onto a band the explorer knows', () async {
      for (final rating in MaiaRating.values) {
        final (:book, :requests) = await makeBook();
        await book.movesFor(Chess.initial, rating);

        final band = int.parse(requests.single.queryParameters['ratings']!);
        expect(band, lessThanOrEqualTo(rating.rating));
        expect(rating.rating - band, lessThan(200));
      }
    });
  });
}
