import 'dart:typed_data';

import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/engine/opening_book.dart';

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
}
