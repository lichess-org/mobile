import 'dart:math';

import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/engine/maia_book.dart';
import 'package:lichess_mobile/src/model/engine/opponent_level.dart';

import 'polyglot_fixture.dart';

void main() {
  group('MaiaBookTier', () {
    test('splits the networks at the explorer bucket the books were crawled from', () {
      expect(MaiaBookTier.forRating(MaiaRating.maia1100), MaiaBookTier.low);
      expect(MaiaBookTier.forRating(MaiaRating.maia1500), MaiaBookTier.low);
      expect(MaiaBookTier.forRating(MaiaRating.maia1600), MaiaBookTier.high);
      expect(MaiaBookTier.forRating(MaiaRating.maia2200), MaiaBookTier.high);
    });

    test('names the asset it ships as', () {
      expect(MaiaBookTier.low.asset, 'assets/maia/book-low.bin');
      expect(MaiaBookTier.high.asset, 'assets/maia/book-high.bin');
    });
  });

  group('MaiaBook', () {
    test('is silent about a position it does not know', () {
      final book = MaiaBook(bookFor(Chess.initial, {'e2e4': 100}));

      expect(book.chooseMove(Chess.initial.play(NormalMove.fromUci('e2e4')), Random(0)), isNull);
    });

    test('chooses moves in proportion to their weight', () {
      // The point of the book: not the most played move every game, but the human distribution.
      final book = MaiaBook(bookFor(Chess.initial, {'e2e4': 600, 'd2d4': 300, 'g1f3': 100}));
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
      final book = MaiaBook(bookFor(Chess.initial, {'e2e4': 600, 'd2d4': 300, 'g1f3': 100}));

      final first = [for (var i = 0; i < 20; i++) book.chooseMove(Chess.initial, Random(7))];
      final second = [for (var i = 0; i < 20; i++) book.chooseMove(Chess.initial, Random(7))];

      expect(first, second);
    });

    test('can still play a move whose weight rounds to nothing', () {
      final book = MaiaBook(bookFor(Chess.initial, {'e2e4': 999, 'b2b3': 1}));
      final random = Random(20260901);

      final moves = {for (var i = 0; i < 20000; i++) book.chooseMove(Chess.initial, random)};

      expect(moves, {'e2e4', 'b2b3'});
    });
  });
}
