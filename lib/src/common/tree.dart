import 'package:meta/meta.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/common/models.dart';

@immutable
abstract class Node {
  Node({
    required this.ply,
    required this.fen,
    required Iterable<Branch> children,
  }) : children = IList(children);

  final int ply;
  final String fen;
  final IList<Branch> children;

  IList<Node> get mainline {
    final mainline = IList<Node>([this]);
    Node current = this;
    while (current.children.isNotEmpty) {
      current = current.children.first;
      mainline.add(current);
    }
    return mainline;
  }

  Node addChild(Branch branch);

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
    required super.children,
  });

  @override
  Root addChild(Branch branch) => copyWith(children: children.add(branch));

  @override
  Root copyWith({
    int? ply,
    String? fen,
    Iterable<Branch>? children,
  }) {
    return Root(
      ply: ply ?? this.ply,
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
    required this.move,
    required this.position,
    required super.children,
  });

  final UciCharPair id;
  final SanMove move;
  final Position position;

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
