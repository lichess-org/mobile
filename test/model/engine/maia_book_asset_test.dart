import 'package:dartchess/dartchess.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/engine/maia_book.dart';
import 'package:lichess_mobile/src/model/engine/opening_book.dart';

/// The books that ship with the app, as `scripts/gen_maia_book.dart` crawled them.
///
/// Assertions here are deliberately structural rather than exact: the books are regenerated from
/// the Lichess explorer, whose numbers move, and a test that pinned them would fail every time
/// they were refreshed.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<PolyglotBook> load(MaiaBookTier tier) async =>
      PolyglotBook(await rootBundle.load(tier.asset));

  group('the bundled Maia books', () {
    for (final tier in MaiaBookTier.values) {
      test('$tier opens the game with several moves to choose from', () async {
        final book = await load(tier);

        expect(book.length, greaterThan(500));

        final first = book.movesFor(Chess.initial);
        expect(first.length, greaterThanOrEqualTo(4));
        expect(first.first.uci, 'e2e4', reason: 'humans of every rating open 1.e4 most often');

        // Weights are a distribution over the moves kept for the position.
        final total = first.fold(0, (sum, move) => sum + move.weight);
        expect(total, closeTo(1000, 10));
      });

      test('$tier answers the openings it was crawled through', () async {
        final book = await load(tier);

        var position = Chess.initial as Position;
        for (final uci in ['e2e4', 'e7e5', 'g1f3', 'b8c6']) {
          final moves = book.movesFor(position);
          expect(moves, isNotEmpty, reason: 'out of book at ${position.fen}');
          expect(
            moves.map((move) => move.uci),
            contains(uci),
            reason: 'the book does not know $uci at ${position.fen}',
          );
          position = position.play(NormalMove.fromUci(uci));
        }
      });

      test('$tier runs out rather than playing on into the middlegame', () async {
        final book = await load(tier);

        // maxPly is 10: the book is an opening book, and past that the network should be deciding.
        var position = Chess.initial as Position;
        var ply = 0;
        while (ply < 40) {
          final moves = book.movesFor(position);
          if (moves.isEmpty) break;
          position = position.play(NormalMove.fromUci(moves.first.uci));
          ply++;
        }

        expect(ply, lessThanOrEqualTo(10));
        expect(ply, greaterThanOrEqualTo(6), reason: 'the main line should be covered');
      });
    }

    test('the two tiers disagree, which is why there are two of them', () async {
      final low = await load(MaiaBookTier.low);
      final high = await load(MaiaBookTier.high);

      final afterE4 = Chess.initial.play(NormalMove.fromUci('e2e4'));
      int weightOf(PolyglotBook book, String uci) =>
          book.movesFor(afterE4).firstWhere((move) => move.uci == uci).weight;

      // 1...e5 is the lower band's move and 1...c5 the upper band's, by some distance.
      expect(weightOf(low, 'e7e5'), greaterThan(weightOf(high, 'e7e5')));
      expect(weightOf(low, 'c7c5'), lessThan(weightOf(high, 'c7c5')));
    });
  });
}
