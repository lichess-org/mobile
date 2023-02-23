import 'package:flutter_test/flutter_test.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

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

    test('nodesOn, simple', () {
      final node = Node.fromPgn('e4 e5');
      final path = UciPath.fromId(UciCharPair.fromUci('e2e4'));
      final nodeList = node.nodesOn(path);
      expect(nodeList.length, equals(1));
      expect(nodeList.first, equals(node.nodeAt(path)));
    });

    test('nodesOn, with variation', () {
      final node = Node.fromPgn('e4 e5 Nf3');
      final move = Move.fromUci('b1c3')!;
      final tuple = node.addMoveAt(
        UciPath.fromIds(
          [UciCharPair.fromUci('e2e4'), UciCharPair.fromUci('e7e5')].lock,
        ),
        move,
      );

      // mainline has not changed
      expect(node.mainline.length, equals(3));
      expect(node.mainline.last, equals(node.nodeAt(node.mainlinePath)));

      final path = tuple.item1!;
      final nodeList = node.nodesOn(path);
      expect(nodeList.length, equals(3));
      expect(nodeList.last, equals(tuple.item2));
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
          node.branchAtOrNull(UciPath.fromId(UciCharPair.fromUci('b1c3')));
      expect(branch2, isNull);
    });

    test('addNodeAt', () {
      final node = Node.fromPgn('e4 e5');
      final branch = Branch(
        id: UciCharPair.fromMove(Move.fromUci('b8c6')!),
        ply: 2,
        sanMove: SanMove('Nc6', Move.fromUci('b8c6')!),
        fen: 'fen2',
        position: Chess.initial,
      );
      node.addNodeAt(UciPath.fromId(UciCharPair.fromUci('e2e4')), branch);

      final testNode =
          node.branchAt(UciPath.fromId(UciCharPair.fromUci('e2e4')));
      expect(testNode.children.length, equals(2));
      expect(testNode.children[1], equals(branch));
    });

    test('addNodeAt, with an existing node at path', () {
      final node = Node.fromPgn('e4 e5');
      final branch = Branch(
        id: UciCharPair.fromMove(Move.fromUci('e7e5')!),
        ply: 2,
        sanMove: SanMove('e5', Move.fromUci('e7e5')!),
        fen: 'fen2',
        position: Chess.initial,
      );
      node.addNodeAt(UciPath.fromId(UciCharPair.fromUci('e2e4')), branch);

      final testNode =
          node.branchAt(UciPath.fromId(UciCharPair.fromUci('e2e4')));

      // node is not replaced
      expect(testNode.children.length, equals(1));
      expect(testNode.children[0], isNot(branch));
    });

    test('addMoveAt', () {
      final node = Node.fromPgn('e4 e5');
      final move = Move.fromUci('b1c3')!;
      final path = UciPath.fromIds(
        [UciCharPair.fromUci('e2e4'), UciCharPair.fromUci('e7e5')].lock,
      );
      final currentPath = node.mainlinePath;
      final tuple = node.addMoveAt(path, move);
      expect(
        tuple.item1,
        equals(currentPath + UciCharPair.fromMove(move)),
      );
      expect(tuple.item2?.ply, equals(3));
      expect(tuple.item2?.sanMove, equals(SanMove('Nc3', move)));
      expect(
        tuple.item2?.fen,
        equals(
          'rnbqkbnr/pppp1ppp/8/4p3/4P3/2N5/PPPP1PPP/R1BQKBNR b KQkq - 1 2',
        ),
      );

      final testNode = node.branchAt(path);
      expect(testNode.children.length, equals(1));
      expect(testNode.children.first.sanMove, equals(SanMove('Nc3', move)));
      expect(
        testNode.children.first.fen,
        equals(
          'rnbqkbnr/pppp1ppp/8/4p3/4P3/2N5/PPPP1PPP/R1BQKBNR b KQkq - 1 2',
        ),
      );
    });
  });
}
