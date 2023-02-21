import 'package:flutter_test/flutter_test.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/common/uci.dart';
import 'package:lichess_mobile/src/common/tree.dart';

void main() {
  group('Node', () {
    test('correctly overrides equal', () {
      final root = Root(
        ply: 1,
        fen: 'fen',
        position: Chess.initial,
        children: const [],
      );
      expect(root, equals(root));

      final move = SanMove('e4', Move.fromUci('e2e4')!);
      final branch = Branch(
        id: UciCharPair.fromMove(move.move),
        ply: 2,
        fen: 'fen',
        move: move,
        position: Chess.initial,
        children: const [],
      );

      expect(branch == root, isFalse);
    });

    // test('fromPgn', () {
    //   final node = Node.fromPgn('e4 e5');
    // });

    test('mainline', () {
      final node = Node.fromPgn('e4 e5');
      final mainline = node.mainline;

      expect(mainline.length, equals(2));
      expect(mainline[0].move, equals(SanMove('e4', Move.fromUci('e2e4')!)));
      expect(mainline[1].move, equals(SanMove('e5', Move.fromUci('e7e5')!)));
    });
  });
}
