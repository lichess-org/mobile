import 'package:flutter_test/flutter_test.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/common/uci.dart';
import 'package:lichess_mobile/src/common/tree.dart';

void main() {
  group('Node', () {
    test('Node.fromPgn', () {
      final node = Node.fromPgn('e4 e5');
      expect(node.ply, equals(0));
      expect(node.fen, equals(kInitialFEN));
      expect(node.position, equals(Chess.initial));
      expect(node.children.length, equals(1));
      final child = node.children.first;
      expect(child.id, equals(UciCharPair.fromMove(Move.fromUci('e2e4')!)));
      expect(child.ply, equals(1));
      expect(child.sanMove, equals(SanMove('e4', Move.fromUci('e2e4')!)));
      expect(
        child.fen,
        equals('rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq - 0 1'),
      );
      expect(
        child.position,
        equals(Chess.initial.playUnchecked(Move.fromUci('e2e4')!)),
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

    test('add child', () {
      final node = Root(
        ply: 0,
        fen: 'fen',
        position: Chess.initial,
      );
      final child = Branch(
        id: UciCharPair.fromMove(Move.fromUci('e2e4')!),
        ply: 1,
        sanMove: SanMove('e4', Move.fromUci('e2e4')!),
        fen: 'fen2',
        position: Chess.initial,
      );
      node.addChild(child);
      expect(node.children.length, equals(1));
      expect(node.children.first, equals(child));
    });

    test('branchAt', () {
      final node = Node.fromPgn('e4 e5');
      final branch = node.branchAt(UciPath.fromId(UciCharPair.fromUci('e2e4')));
      expect(branch, equals(node.children.first));
    });

    test('branchAtOrNull', () {
      final node = Node.fromPgn('e4 e5');
      final branch =
          node.branchAtOrNull(UciPath.fromId(UciCharPair.fromUci('e2e4')));
      expect(branch, equals(node.children.first));

      final branch2 =
          node.branchAtOrNull(UciPath.fromId(UciCharPair.fromUci('c1b3')));
      expect(branch2, isNull);
    });
  });
}
