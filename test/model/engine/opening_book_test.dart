import 'dart:math';
import 'dart:typed_data';

import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/engine/opening_book.dart';
import 'package:lichess_mobile/src/model/engine/opponent_level.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/network/http.dart';

import '../../network/fake_http_client_factory.dart';
import '../../test_container.dart';
import '../../test_helpers.dart';
import 'polyglot_fixture.dart';

void main() {
  group('PolyglotBook', () {
    test('decodes a hand-encoded entry', () {
      // e2e4: to = e4 (file 4, rank 3), from = e2 (file 4, rank 1).
      const e2e4 = 4 | 3 << 3 | 4 << 6 | 1 << 9;
      expect(packMove(Square.e2, Square.e4), e2e4);

      final book = polyglotBook([(key: Chess.initial.zobristHash(), move: e2e4, weight: 100)]);

      expect(book.length, 1);
      expect(book.movesFor(Chess.initial), [(uci: 'e2e4', weight: 100)]);
    });

    test('returns nothing for a position it does not hold', () {
      final book = bookFor(Chess.initial, {'e2e4': 100});

      expect(book.movesFor(Chess.initial.play(NormalMove.fromUci('e2e4'))), isEmpty);
      expect(polyglotBook([]).movesFor(Chess.initial), isEmpty);
    });

    test('orders the moves of a position by weight', () {
      final book = bookFor(Chess.initial, {'g1f3': 9, 'e2e4': 50, 'd2d4': 25});

      expect(book.movesFor(Chess.initial), [
        (uci: 'e2e4', weight: 50),
        (uci: 'd2d4', weight: 25),
        (uci: 'g1f3', weight: 9),
      ]);
    });

    test('finds a position among many', () {
      // Enough positions that a linear scan and a binary search would disagree if the search were
      // wrong, and spread over both signs of the key.
      var position = Chess.initial as Position;
      final entries = <PolyglotEntry>[];
      final expected = <Position, String>{};
      for (final uci in ['e2e4', 'e7e5', 'g1f3', 'b8c6', 'f1b5', 'a7a6', 'b5a4', 'g8f6']) {
        entries.add((
          key: position.zobristHash(),
          move: packMove(NormalMove.fromUci(uci).from, NormalMove.fromUci(uci).to),
          weight: 10,
        ));
        expected[position] = uci;
        position = position.play(NormalMove.fromUci(uci));
      }
      final book = polyglotBook(entries);

      for (final entry in expected.entries) {
        expect(book.movesFor(entry.key).single.uci, entry.value, reason: entry.key.fen);
      }
      expect(book.movesFor(position), isEmpty);
    });

    test('decodes castling, which Polyglot stores king-to-rook', () {
      final position = Chess.fromSetup(
        Setup.parseFen('r3k2r/pppppppp/8/8/8/8/PPPPPPPP/R3K2R w KQkq - 0 1'),
      );
      final book = bookFor(position, {'e1h1': 60, 'e1a1': 40});

      // The rest of the app speaks the king's true destination, not the rook's square.
      expect(book.movesFor(position), [(uci: 'e1g1', weight: 60), (uci: 'e1c1', weight: 40)]);
    });

    test('decodes promotions', () {
      final position = Chess.fromSetup(Setup.parseFen('7k/P7/8/8/8/8/8/K7 w - - 0 1'));
      final book = bookFor(position, {'a7a8q': 70, 'a7a8n': 30});

      expect(book.movesFor(position), [(uci: 'a7a8q', weight: 70), (uci: 'a7a8n', weight: 30)]);
    });

    test('drops a move that is not legal in the position', () {
      // The key is the initial position's, but the move is nonsense there: a book built for other
      // rules, or a key collision, must not hand back a move that cannot be played.
      final book = polyglotBook([
        (key: Chess.initial.zobristHash(), move: packMove(Square.e2, Square.e4), weight: 50),
        (key: Chess.initial.zobristHash(), move: packMove(Square.a1, Square.a8), weight: 50),
      ]);

      expect(book.movesFor(Chess.initial), [(uci: 'e2e4', weight: 50)]);
    });

    test('ignores trailing bytes that do not make up an entry', () {
      final bytes = polyglotBytes([
        (key: Chess.initial.zobristHash(), move: packMove(Square.e2, Square.e4), weight: 100),
      ]);
      final truncated = Uint8List.fromList([...bytes, 1, 2, 3]);

      final book = PolyglotBook(ByteData.sublistView(truncated));

      expect(book.length, 1);
      expect(book.movesFor(Chess.initial), [(uci: 'e2e4', weight: 100)]);
    });

    test('finds a position reached by transposition', () {
      // The key is the position, not the path to it: 1.d4 Nf6 2.c4 and 1.c4 Nf6 2.d4 are one
      // entry, which is the whole reason the book is keyed by hash.
      final direct = Chess.initial
          .play(NormalMove.fromUci('d2d4'))
          .play(NormalMove.fromUci('g8f6'))
          .play(NormalMove.fromUci('c2c4'));
      final transposed = Chess.initial
          .play(NormalMove.fromUci('c2c4'))
          .play(NormalMove.fromUci('g8f6'))
          .play(NormalMove.fromUci('d2d4'));

      final book = bookFor(direct, {'e7e6': 100});

      expect(book.movesFor(transposed), [(uci: 'e7e6', weight: 100)]);
    });
  });

  group('MaiaOfflineBookTier', () {
    test('splits the networks at the explorer bucket the books were crawled from', () {
      expect(MaiaOfflineBookTier.forRating(MaiaRating.maia1100), MaiaOfflineBookTier.low);
      expect(MaiaOfflineBookTier.forRating(MaiaRating.maia1500), MaiaOfflineBookTier.low);
      expect(MaiaOfflineBookTier.forRating(MaiaRating.maia1600), MaiaOfflineBookTier.high);
      expect(MaiaOfflineBookTier.forRating(MaiaRating.maia2200), MaiaOfflineBookTier.high);
    });

    test('names the asset it ships as', () {
      expect(MaiaOfflineBookTier.low.asset, 'assets/maia/book-low.bin');
      expect(MaiaOfflineBookTier.high.asset, 'assets/maia/book-high.bin');
    });
  });

  group('MaiaOfflineBook', () {
    test('is silent about a position it does not know', () {
      final book = MaiaOfflineBook(bookFor(Chess.initial, {'e2e4': 100}));

      expect(book.chooseMove(Chess.initial.play(NormalMove.fromUci('e2e4')), Random(0)), isNull);
    });

    test('chooses moves in proportion to their weight', () {
      // The point of the book: not the most played move every game, but the human distribution.
      final book = MaiaOfflineBook(bookFor(Chess.initial, {'e2e4': 600, 'd2d4': 300, 'g1f3': 100}));
      final random = Random(20260901);

      final counts = <String, int>{};
      for (var i = 0; i < 20000; i++) {
        final move = book.chooseMove(Chess.initial, random)!;
        counts[move] = (counts[move] ?? 0) + 1;
      }

      expect(counts['e2e4']! / 20000, closeTo(0.6, 0.02));
      expect(counts['d2d4']! / 20000, closeTo(0.3, 0.02));
      expect(counts['g1f3']! / 20000, closeTo(0.1, 0.02));
    });

    test('is reproducible for a given seed', () {
      final book = MaiaOfflineBook(bookFor(Chess.initial, {'e2e4': 600, 'd2d4': 300, 'g1f3': 100}));

      final first = [for (var i = 0; i < 20; i++) book.chooseMove(Chess.initial, Random(7))];
      final second = [for (var i = 0; i < 20; i++) book.chooseMove(Chess.initial, Random(7))];

      expect(first, second);
    });

    test('can still play a move whose weight rounds to nothing', () {
      final book = MaiaOfflineBook(bookFor(Chess.initial, {'e2e4': 999, 'b2b3': 1}));
      final random = Random(20260901);

      final moves = {for (var i = 0; i < 20000; i++) book.chooseMove(Chess.initial, random)};

      expect(moves, {'e2e4', 'b2b3'});
    });
  });

  group('MaiaOnlineBook', () {
    /// An explorer answer: 1.e4 60%, 1.d4 30%, 1.b3 8%, 1.a3 2% of 1000 games.
    ///
    /// [_tailResponse] adds a 1.5% move, which the bundled book's cutoff would drop.
    const response = '''
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

    const tailResponse = '''
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

    Future<({MaiaOnlineBook book, List<Uri> requests})> makeBook({
      bool isOnline = true,
      String response = response,
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
      final (:book, requests: _) = await makeBook(response: tailResponse);

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
