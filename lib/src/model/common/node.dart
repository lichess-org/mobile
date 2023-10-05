import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';

part 'node.freezed.dart';

/// A node in a game tree.
///
/// The tree is implemented with a linked list of nodes, using mutable [List] of
/// children.
///
/// It has an optional [eval] field, which is the evaluation of the position. This
/// field is mutable so it can be updated efficiently when the evaluation changes.
///
/// It cannot be directly used in a riverpod state, because it is mutable, and
/// riverpod relies on object reference equality to detect changes and emit new
/// states. Therefore, it must be converted into a [ViewNode], which is immutable,
/// using the [view] getter.
abstract class Node {
  Node({
    required this.ply,
    required this.position,
    this.eval,
    this.opening,
  });

  final int ply;
  final Position position;

  /// The evaluation of the position.
  ClientEval? eval;

  /// The opening associated with this node.
  Opening? opening;

  final List<Branch> children = [];

  /// Immutable view of this node.
  ViewNode get view;

  /// Adds a child to this node.
  void addChild(Branch node) => children.add(node);

  /// Prepends a child to this node.
  void prependChild(Branch node) => children.insert(0, node);

  /// Finds the child node with that id.
  Branch? childById(UciCharPair id) {
    return children.firstWhereOrNull((node) => node.id == id);
  }

  /// An iterable of all nodes on the mainline.
  Iterable<ViewBranch> get mainline sync* {
    Node current = this;
    while (current.children.isNotEmpty) {
      final child = current.children.first;
      yield child.view;
      current = child;
    }
  }

  /// Selects all nodes on that path.
  Iterable<ViewBranch> nodesOn(UciPath path) sync* {
    UciPath currentPath = path;

    Branch? pickChild(Node node) {
      final id = currentPath.head;
      if (id == null) {
        return null;
      }
      return node.childById(id);
    }

    Node current = this;
    Branch? child;

    while ((child = pickChild(current)) != null) {
      yield child!.view;
      current = child;
      currentPath = currentPath.tail;
    }
  }

  /// Gets the path of the mainline.
  UciPath get mainlinePath => UciPath.fromNodeList(mainline);

  /// Updates the node at the given path.
  ///
  /// Returns the updated node, or null if the node was not found.
  Branch? updateAt(UciPath path, void Function(Branch node) update) {
    final node = nodeAtOrNull(path);
    if (node != null && node is Branch) {
      update(node);
      return node;
    }
    return null;
  }

  /// Updates all nodes.
  void updateAll(void Function(Branch node) update) {
    switch (this) {
      case final Branch branch:
        update(branch);
    }
    for (final child in children) {
      child.updateAll(update);
    }
  }

  /// Adds a new node at the given path and returns the new path.
  ///
  /// Returns a tuple of the new path and whether the node was added.
  /// Returns null if the node at path does not exist.
  ///
  /// If the node already exists, it is not added again.
  (UciPath?, bool) addNodeAt(
    UciPath path,
    Branch newNode, {
    bool prepend = false,
  }) {
    final newPath = path + newNode.id;
    final node = nodeAtOrNull(path);
    if (node != null) {
      final existing = nodeAtOrNull(newPath) != null;
      if (!existing) {
        if (prepend) {
          node.prependChild(newNode);
        } else {
          node.addChild(newNode);
        }
      }
      return (newPath, !existing);
    } else {
      return (null, false);
    }
  }

  /// Adds a list of nodes at the given path and returns the new path.
  UciPath? addNodesAt(
    UciPath path,
    Iterable<Branch> newNodes, {
    bool prepend = false,
  }) {
    final node = newNodes.elementAtOrNull(0);
    if (node == null) return path;
    final (newPath, _) = addNodeAt(path, node, prepend: prepend);
    return newPath != null
        ? addNodesAt(newPath, newNodes.skip(1), prepend: prepend)
        : null;
  }

  /// Adds a new node with that [Move] at the given path.
  ///
  /// Returns a tuple of the new path and whether the node was added.
  /// Returns null if the node at path does not exist.
  ///
  /// If the node already exists, it is not added again.
  (UciPath?, bool) addMoveAt(
    UciPath path,
    Move move, {
    bool prepend = false,
  }) {
    final pos = nodeAt(path).position;
    final (newPos, newSan) = pos.playToSan(move);
    final newNode = Branch(
      ply: 2 * (newPos.fullmoves - 1) + (newPos.turn == Side.white ? 0 : 1),
      sanMove: SanMove(newSan, move),
      position: newPos,
    );
    return addNodeAt(path, newNode, prepend: prepend);
  }

  /// Gets the node at the given path.
  Node nodeAt(UciPath path) {
    if (path.isEmpty) return this;
    final child = childById(path.head!);
    if (child != null) {
      return child.nodeAt(path.tail);
    } else {
      return this;
    }
  }

  /// Gets the node at the given path, or null if it does not exist.
  Node? nodeAtOrNull(UciPath path) {
    if (path.isEmpty) return this;
    final child = childById(path.head!);
    if (child != null) {
      return child.nodeAtOrNull(path.tail);
    } else {
      return null;
    }
  }

  /// Gets the branch at the given path, or null if it does not exist.
  Branch? branchAt(UciPath path) {
    final node = nodeAtOrNull(path);
    if (node != null && node is Branch) {
      return node;
    } else {
      return null;
    }
  }
}

/// A branch node of a game tree
///
/// It has an associated [SanMove] and an id to identify it using an [UciPath].
class Branch extends Node {
  Branch({
    required super.ply,
    required super.position,
    super.eval,
    super.opening,
    required this.sanMove,
  });

  /// The id of the branch, using a concise notation of associated move.
  UciCharPair get id => UciCharPair.fromMove(sanMove.move);

  /// The associated move.
  final SanMove sanMove;

  @override
  ViewBranch get view => ViewBranch(
        ply: ply,
        position: position,
        sanMove: sanMove,
        eval: eval,
        opening: opening,
        children: IList(children.map((child) => child.view)),
      );

  /// Gets the branch at the given path
  @override
  Branch branchAt(UciPath path) => nodeAt(path) as Branch;

  @override
  String toString() {
    return 'Branch(id: $id, ply: $ply, fen: ${position.fen}, sanMove: $sanMove, eval: $eval, children: $children)';
  }
}

/// The root node of a game tree.
///
/// Represents the initial position, where no move has been played yet.
class Root extends Node {
  Root({
    required super.ply,
    required super.position,
    super.eval,
  });

  @override
  ViewRoot get view => ViewRoot(
        ply: ply,
        position: position,
        eval: eval,
        children: IList(children.map((child) => child.view)),
      );

  /// Creates a game tree from a PGN string.
  ///
  /// Assumes that the PGN string is valid and that the moves are legal.
  factory Root.fromPgn(String pgn) {
    int ply = 0;
    Position position = Chess.initial;
    final root = Root(
      ply: ply,
      position: position,
    );
    Node current = root;
    final moves = pgn.split(' ');
    for (final san in moves) {
      ply++;
      final move = position.parseSan(san);
      position = position.playUnchecked(move!);
      final nextNode = Branch(
        ply: ply,
        sanMove: SanMove(san, move),
        position: position,
      );
      current.addChild(nextNode);
      current = nextNode;
    }
    return root;
  }
}

/// An immutable view of a [Node].
abstract class ViewNode {
  UciCharPair? get id;
  SanMove? get sanMove;
  int get ply;
  Position get position;
  IList<ViewBranch> get children;
  ClientEval? get eval;
  Opening? get opening;
}

/// An immutable view of a [Root] node.
@freezed
class ViewRoot with _$ViewRoot implements ViewNode {
  const ViewRoot._();
  const factory ViewRoot({
    required int ply,
    required Position position,
    required IList<ViewBranch> children,
    ClientEval? eval,
  }) = _ViewRoot;

  @override
  UciCharPair? get id => null;

  @override
  SanMove? get sanMove => null;

  @override
  Opening? get opening => null;
}

/// An immutable view of a [Branch] node.
@freezed
class ViewBranch with _$ViewBranch implements ViewNode {
  const ViewBranch._();

  const factory ViewBranch({
    required SanMove sanMove,
    required int ply,
    required Position position,
    Opening? opening,
    required IList<ViewBranch> children,
    ClientEval? eval,
  }) = _ViewBranch;

  @override
  UciCharPair get id => UciCharPair.fromMove(sanMove.move);
}
