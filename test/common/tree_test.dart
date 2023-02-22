import 'package:flutter_test/flutter_test.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/common/uci.dart';
import 'package:lichess_mobile/src/common/tree.dart';

void main() {
  group('Node', () {
    test('overrides equal', () {
      // same
      final root = Root(
        ply: 1,
        fen: 'fen',
        position: Chess.initial,
        children: [],
      );
      expect(
        root,
        equals(
          Root(
            ply: 1,
            fen: 'fen',
            position: Chess.initial,
            children: [],
          ),
        ),
      );

      // branch vs root
      final move = SanMove('e4', Move.fromUci('e2e4')!);
      final branch = Branch(
        id: UciCharPair.fromMove(move.move),
        ply: 2,
        fen: 'fen',
        sanMove: move,
        position: Chess.initial,
        children: [],
      );

      expect(branch == root, isFalse);

      // different children
      final node = Root(
        ply: 1,
        fen: 'fen',
        position: Chess.initial,
        children: [branch],
      );
      expect(node == root, isFalse);

      // different ply
      expect(
        Branch(
              id: UciCharPair.fromMove(move.move),
              ply: 3,
              fen: 'fen',
              sanMove: move,
              position: Chess.initial,
              children: [],
            ) ==
            Branch(
              id: UciCharPair.fromMove(move.move),
              ply: 2,
              fen: 'fen',
              sanMove: move,
              position: Chess.initial,
              children: [],
            ),
        isFalse,
      );

      // different fen
      expect(
        Branch(
              id: UciCharPair.fromMove(move.move),
              ply: 2,
              fen: 'otherfen',
              sanMove: move,
              position: Chess.initial,
              children: [],
            ) ==
            Branch(
              id: UciCharPair.fromMove(move.move),
              ply: 2,
              fen: 'fen',
              sanMove: move,
              position: Chess.initial,
              children: [],
            ),
        isFalse,
      );

      // different position
      expect(
        Branch(
              id: UciCharPair.fromMove(move.move),
              ply: 2,
              fen: 'fen',
              sanMove: move,
              position: Chess.initial,
              children: [],
            ) ==
            Branch(
              id: UciCharPair.fromMove(move.move),
              ply: 2,
              fen: 'fen',
              sanMove: move,
              position: Chess.initial.playUnchecked(Move.fromUci('e2e4')!),
              children: [],
            ),
        isFalse,
      );
    });

    test('mainline', () {
      final node = Node.fromPgn('e4 e5');
      final mainline = node.mainline;

      expect(mainline.length, equals(2));
      final list = mainline.toList();
      expect(list[0].sanMove, equals(SanMove('e4', Move.fromUci('e2e4')!)));
      expect(list[1].sanMove, equals(SanMove('e5', Move.fromUci('e7e5')!)));
    });
  });
}
