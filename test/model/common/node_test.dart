import 'package:flutter_test/flutter_test.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/node.dart';

void main() {
  group('Node', () {
    test('Root.fromPgn', () {
      final root = Root.fromPgn('e4 e5');
      expect(root.ply, equals(0));
      expect(root.fen, equals(kInitialFEN));
      expect(root.position, equals(Chess.initial));
      expect(root.children.length, equals(1));
      final child = root.children.first;
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
      final root = Root.fromPgn('e4 e5');
      final path = UciPath.fromId(UciCharPair.fromUci('e2e4'));
      final nodeList = root.nodesOn(path);
      expect(nodeList.length, equals(1));
      expect(
        nodeList.first,
        equals((root.nodeAt(path) as Branch).view),
      );
    });

    test('nodesOn, with variation', () {
      final root = Root.fromPgn('e4 e5 Nf3');
      final move = Move.fromUci('b1c3')!;
      final (newPath, newNode) = root.addMoveAt(
        UciPath.fromIds(
          [UciCharPair.fromUci('e2e4'), UciCharPair.fromUci('e7e5')].lock,
        ),
        move,
      );

      // mainline has not changed
      expect(root.mainline.length, equals(3));
      expect(
        root.mainline.last,
        equals((root.nodeAt(root.mainlinePath) as Branch).view),
      );

      final nodeList = root.nodesOn(newPath!);
      expect(nodeList.length, equals(3));
      expect(nodeList.last, equals(newNode!.view));
    });

    test('mainline', () {
      final root = Root.fromPgn('e4 e5');
      final mainline = root.mainline;

      expect(mainline.length, equals(2));
      final list = mainline.toList();
      expect(list[0].sanMove, equals(SanMove('e4', Move.fromUci('e2e4')!)));
      expect(list[1].sanMove, equals(SanMove('e5', Move.fromUci('e7e5')!)));
    });

    test('add child', () {
      final root = Root(
        ply: 0,
        fen: 'fen',
        position: Chess.initial,
      );
      final child = Branch(
        ply: 1,
        sanMove: SanMove('e4', Move.fromUci('e2e4')!),
        fen: 'fen2',
        position: Chess.initial,
      );
      root.addChild(child);
      expect(root.children.length, equals(1));
      expect(root.children.first, equals(child));
    });

    test('prepend child', () {
      final root = Root.fromPgn('e4 e5');
      final child = Branch(
        ply: 1,
        sanMove: SanMove('d4', Move.fromUci('d2d4')!),
        fen: 'fen2',
        position: Chess.initial,
      );
      root.prependChild(child);
      expect(root.children.length, equals(2));
      expect(root.children.first, equals(child));
      expect(root.children.last.id, equals(UciCharPair.fromUci('e2e4')));
    });

    test('nodeAt', () {
      final root = Root.fromPgn('e4 e5');
      final branch = root.nodeAt(UciPath.fromId(UciCharPair.fromUci('e2e4')));
      expect(branch, equals(root.children.first));
    });

    test('nodeAtOrNull', () {
      final root = Root.fromPgn('e4 e5');
      final branch =
          root.nodeAtOrNull(UciPath.fromId(UciCharPair.fromUci('e2e4')));
      expect(branch, equals(root.children.first));

      final branch2 =
          root.nodeAtOrNull(UciPath.fromId(UciCharPair.fromUci('b1c3')));
      expect(branch2, isNull);
    });

    test('branchAt from root', () {
      final root = Root.fromPgn('e4 e5');
      final branch = root.branchAt(UciPath.fromId(UciCharPair.fromUci('e2e4')));
      expect(branch, equals(root.children.first));
    });

    test('branchAt from branch', () {
      final root = Root.fromPgn('e4 e5 Nf3');
      final branch = root.branchAt(UciPath.fromId(UciCharPair.fromUci('e2e4')));
      final branch2 =
          branch!.branchAt(UciPath.fromId(UciCharPair.fromUci('e7e5')));
      expect(branch2, equals(branch.children.first));
    });

    test('updateAt', () {
      final root = Root.fromPgn('e4 e5');
      final branch = Branch(
        ply: 2,
        sanMove: SanMove('Nc6', Move.fromUci('b8c6')!),
        fen: 'fen2',
        position: Chess.initial,
      );

      final fromPath = UciPath.fromId(UciCharPair.fromUci('e2e4'));
      final nodePath = root.addNodeAt(fromPath, branch);

      expect(
        root.nodesOn(nodePath!),
        equals([
          root.children.first.view,
          branch.view,
        ]),
      );

      final eval = ClientEval(
        fen: 'fen2',
        maxDepth: 20,
        cp: 100,
        depth: 10,
        nodes: 1000,
        millis: 1000,
        pvs: IList([
          PvData(moves: IList(const ['e2e4'])),
        ]),
        position: branch.position,
        isComputing: false,
      );

      final newNode = root.updateAt(nodePath, (node) {
        node.eval = eval;
      });

      expect(
        root.nodesOn(nodePath),
        equals([
          root.children.first.view,
          newNode!.view,
        ]),
      );
    });

    test('addNodeAt', () {
      final root = Root.fromPgn('e4 e5');
      final branch = Branch(
        ply: 2,
        sanMove: SanMove('Nc6', Move.fromUci('b8c6')!),
        fen: 'fen2',
        position: Chess.initial,
      );
      root.addNodeAt(UciPath.fromId(UciCharPair.fromUci('e2e4')), branch);

      final testNode = root.nodeAt(UciPath.fromId(UciCharPair.fromUci('e2e4')));
      expect(testNode.children.length, equals(2));
      expect(testNode.children[1], equals(branch));
    });

    test('addNodeAt, prepend', () {
      final root = Root.fromPgn('e4 e5');
      final branch = Branch(
        ply: 2,
        sanMove: SanMove('Nc6', Move.fromUci('b8c6')!),
        fen: 'fen2',
        position: Chess.initial,
      );
      root.addNodeAt(
        UciPath.fromId(UciCharPair.fromUci('e2e4')),
        branch,
        prepend: true,
      );

      final testNode = root.nodeAt(UciPath.fromId(UciCharPair.fromUci('e2e4')));
      expect(testNode.children.length, equals(2));
      expect(testNode.children[0], equals(branch));
    });

    test('addNodeAt, with an existing node at path', () {
      final root = Root.fromPgn('e4 e5');
      final branch = Branch(
        ply: 2,
        sanMove: SanMove('e5', Move.fromUci('e7e5')!),
        fen: 'fen2',
        position: Chess.initial,
      );
      root.addNodeAt(UciPath.fromId(UciCharPair.fromUci('e2e4')), branch);

      final testNode = root.nodeAt(UciPath.fromId(UciCharPair.fromUci('e2e4')));

      // node is not replaced
      expect(testNode.children.length, equals(1));
      expect(testNode.children[0], isNot(branch));
    });

    test('addNodesAt', () {
      final root = Root.fromPgn('e4 e5');
      final branch = Branch(
        ply: 2,
        sanMove: SanMove('Nc6', Move.fromUci('b8c6')!),
        fen: 'fen2',
        position: Chess.initial,
      );
      final branch2 = Branch(
        ply: 3,
        sanMove: SanMove('Na6', Move.fromUci('b8a6')!),
        fen: 'fen3',
        position: Chess.initial,
      );
      root.addNodesAt(
        UciPath.fromId(UciCharPair.fromUci('e2e4')),
        [branch, branch2],
      );

      final testNode = root.nodeAt(UciPath.fromId(UciCharPair.fromUci('e2e4')));
      expect(testNode.children.length, equals(2));
      expect(testNode.children[1], equals(branch));
      expect(testNode.children[1].children[0], equals(branch2));
    });

    test('addMoveAt', () {
      final root = Root.fromPgn('e4 e5');
      final move = Move.fromUci('b1c3')!;
      final path = UciPath.fromIds(
        [UciCharPair.fromUci('e2e4'), UciCharPair.fromUci('e7e5')].lock,
      );
      final currentPath = root.mainlinePath;
      final (newPath, newNode) = root.addMoveAt(path, move);
      expect(
        newPath,
        equals(currentPath + UciCharPair.fromMove(move)),
      );
      expect(newNode?.ply, equals(3));
      expect(newNode?.sanMove, equals(SanMove('Nc3', move)));
      expect(
        newNode?.fen,
        equals(
          'rnbqkbnr/pppp1ppp/8/4p3/4P3/2N5/PPPP1PPP/R1BQKBNR b KQkq - 1 2',
        ),
      );

      final testNode = root.nodeAt(path);
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
