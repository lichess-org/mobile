import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/common/uci.dart';

abstract class Node {
  Node({
    required this.ply,
    required this.fen,
    required this.position,
    required this.children,
  });

  final int ply;
  final String fen;
  final Position position;
  final List<Branch> children;

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
      children: [],
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
        move: SanMove(san, move),
        fen: position.fen,
        position: position,
        children: [],
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

  Node? nodeAtPath(UciPath path) {
    if (path.isEmpty) return this;
    final child = path.head != null ? byId(path.head!) : null;
    if (child != null) {
      return child.nodeAtPath(path.tail);
    } else {
      return null;
    }
  }

  Iterable<Branch> get mainline sync* {
    Node current = this;
    while (current.children.isNotEmpty) {
      final child = current.children.first;
      yield child;
      current = child;
    }
  }

  UciPath get mainlinePath => pathFrom(mainline);

  void addChild(Branch branch) => children.add(branch);

  Node? byId(UciCharPair id) {
    if (this is Branch && (this as Branch).id == id) return this;
    for (final child in children) {
      final node = child.byId(id);
      if (node != null) return node;
    }
    return null;
  }

  Node copyWith({
    int? ply,
    String? fen,
    List<Branch>? children,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Node &&
            other.ply == ply &&
            other.fen == fen &&
            other.position == position &&
            const ListEquality<Branch>().equals(other.children, children);
  }

  @override
  int get hashCode =>
      ply.hashCode ^
      fen.hashCode ^
      position.hashCode ^
      const ListEquality<Branch>().hash(children);
}

class Root extends Node {
  Root({
    required super.ply,
    required super.fen,
    required super.position,
    required super.children,
  });

  @override
  Root copyWith({
    int? ply,
    String? fen,
    Position? position,
    List<Branch>? children,
  }) {
    return Root(
      ply: ply ?? this.ply,
      position: position ?? this.position,
      fen: fen ?? this.fen,
      children: children ?? this.children,
    );
  }
}

class Branch extends Node {
  Branch({
    required this.id,
    required super.ply,
    required super.fen,
    required super.position,
    required this.move,
    required super.children,
  });

  final UciCharPair id;
  final SanMove move;

  @override
  Branch copyWith({
    int? ply,
    String? fen,
    SanMove? move,
    Position? position,
    List<Branch>? children,
  }) {
    return Branch(
      id: id,
      ply: ply ?? this.ply,
      fen: fen ?? this.fen,
      move: move ?? this.move,
      position: position ?? this.position,
      children: children ?? this.children,
    );
  }
}
