import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/common/uci.dart';

abstract class Node {
  Node({
    required this.ply,
    required this.fen,
    required this.position,
  });

  final int ply;
  final String fen;
  final Position position;
  final List<Branch> children = [];

  /// Creates a game tree from a PGN string.
  ///
  /// Assumes that the PGN string is valid and that the moves are legal.
  factory Node.fromPgn(String pgn) {
    int ply = 0;
    Position position = Chess.initial;
    final root = Root(
      ply: ply,
      fen: kInitialFEN,
      position: position,
    );
    Node current = root;
    final moves = pgn.split(' ');
    for (final san in moves) {
      ply++;
      final move = position.parseSan(san);
      position = position.playUnchecked(move!);
      final nextNode = Branch(
        id: UciCharPair.fromMove(move),
        ply: ply,
        sanMove: SanMove(san, move),
        fen: position.fen,
        position: position,
      );
      current.addChild(nextNode);
      current = nextNode;
    }
    return root;
  }

  static UciPath pathFrom(Iterable<Node> nodeList) {
    final path = StringBuffer();
    for (final node in nodeList) {
      if (node is Branch) {
        path.write(node.id);
      }
    }
    return UciPath(path.toString());
  }

  Iterable<Branch> get mainline sync* {
    Node current = this;
    while (current.children.isNotEmpty) {
      final child = current.children.first;
      yield child;
      current = child;
    }
  }

  Iterable<Branch> nodeListAt(UciPath path) sync* {
    UciPath currentPath = path;

    Branch? pickChild(Node node) {
      final id = currentPath.head;
      if (id == null) {
        return null;
      }
      return node.byId(id);
    }

    Node current = this;
    Branch? child;

    while ((child = pickChild(current)) != null) {
      yield child!;
      current = child;
      currentPath = currentPath.tail;
    }
  }

  UciPath get mainlinePath => pathFrom(mainline);

  void addChild(Branch branch) => children.add(branch);

  UciPath? addBranchAt(UciPath path, Branch newBranch) {
    final newPath = path + newBranch.id;
    final branch = branchAtOrNull(path);
    if (branch != null) {
      branch.addChild(newBranch);
      return newPath;
    } else {
      return null;
    }
  }

  Tuple2<UciPath?, Branch?> addMoveAt(UciPath path, Move move) {
    final pos = nodeAt(path).position;
    final newPosSan = pos.playToSan(move);
    final newBranch = Branch(
      id: UciCharPair.fromMove(move),
      ply: 2 * (pos.fullmoves - 1) + (pos.turn == Side.white ? 0 : 1),
      sanMove: SanMove(newPosSan.item2, move),
      fen: newPosSan.item1.fen,
      position: newPosSan.item1,
    );
    final newPath = addBranchAt(path, newBranch);
    return Tuple2(newPath, newBranch);
  }

  Node nodeAt(UciPath path) {
    if (path.isEmpty) return this;
    final child = path.head != null ? byId(path.head!) : null;
    if (child != null) {
      return child.nodeAt(path.tail);
    } else {
      return this;
    }
  }

  Branch branchAt(UciPath path) {
    if (path.isEmpty) return this as Branch;
    final child = byId(path.head!);
    if (child != null) {
      return child.branchAt(path.tail);
    } else {
      throw ArgumentError('Invalid path: no branch found at $path');
    }
  }

  Branch? branchAtOrNull(UciPath path) {
    if (path.isEmpty) return this as Branch;
    final child = byId(path.head!);
    if (child != null) {
      return child.branchAtOrNull(path.tail);
    } else {
      return null;
    }
  }

  Branch? byId(UciCharPair id) {
    final me = this;
    if (me is Branch && me.id == id) return me;
    for (final child in children) {
      final node = child.byId(id);
      if (node != null) return node;
    }
    return null;
  }
}

class Branch extends Node {
  Branch({
    required this.id,
    required super.ply,
    required super.fen,
    required super.position,
    required this.sanMove,
  });

  final UciCharPair id;

  final SanMove sanMove;

  Branch copyWith({
    int? ply,
    String? fen,
    SanMove? sanMove,
    Position? position,
  }) {
    return Branch(
      id: id,
      ply: ply ?? this.ply,
      fen: fen ?? this.fen,
      sanMove: sanMove ?? this.sanMove,
      position: position ?? this.position,
    );
  }
}

class Root extends Node {
  Root({
    required super.ply,
    required super.fen,
    required super.position,
  });
}
