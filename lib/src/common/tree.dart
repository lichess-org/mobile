import 'package:meta/meta.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/common/uci.dart';

@immutable
abstract class Node {
  Node({
    required this.ply,
    required this.fen,
    required this.position,
    required Iterable<Branch> children,
  }) : children = IList(children);

  final int ply;
  final String fen;
  final Position position;
  final IList<Branch> children;

  /// Creates a game tree from a PGN string.
  ///
  /// Assumes that the PGN string is valid and that the moves are legal.
  factory Node.fromPgn(String pgn) {
    int ply = 0;
    Position position = Chess.initial;
    Node node = Root(
      ply: ply,
      fen: kInitialFEN,
      position: position,
      children: const [],
    );
    final moves = pgn.split(' ');
    for (final san in moves) {
      ply++;
      final move = position.parseSan(san);
      position = position.playUnchecked(move!);
      node = node.addChild(
        Branch(
          id: UciCharPair.fromMove(move),
          ply: ply,
          move: SanMove(san, move),
          fen: position.fen,
          position: position,
          children: const [],
        ),
      );
    }
    return node;
  }

  static UciPath pathFrom(IList<Node> nodeList) {
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

  IList<Branch> get mainline {
    final List<Branch> mainline = [];
    Node current = this;
    while (current.children.isNotEmpty) {
      current = current.children.first;
      mainline.add(current as Branch);
    }
    return IList(mainline);
  }

  UciPath get mainlinePath => pathFrom(mainline);

  Node addChild(Branch branch);

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
    Iterable<Branch>? children,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Node &&
            other.ply == ply &&
            other.fen == fen &&
            other.children == children;
  }

  @override
  int get hashCode => ply.hashCode ^ fen.hashCode ^ children.hashCode;
}

@immutable
class Root extends Node {
  Root({
    required super.ply,
    required super.fen,
    required super.position,
    required super.children,
  });

  @override
  Root addChild(Branch branch) => copyWith(children: children.add(branch));

  @override
  Root copyWith({
    int? ply,
    String? fen,
    Position? position,
    Iterable<Branch>? children,
  }) {
    return Root(
      ply: ply ?? this.ply,
      position: position ?? this.position,
      fen: fen ?? this.fen,
      children: children ?? this.children,
    );
  }
}

@immutable
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
  Branch addChild(Branch branch) => copyWith(children: children.add(branch));

  @override
  Branch copyWith({
    int? ply,
    String? fen,
    SanMove? move,
    Position? position,
    Iterable<Branch>? children,
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
