import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:logging/logging.dart';

part 'node.freezed.dart';

final _logger = Logger('Node');

/// A node in a game tree.
///
/// The tree is implemented with a linked list of nodes, using mutable [List] of
/// children.
///
/// It should not be directly used in a riverpod state, because it is mutable.
/// It can be converted into an immutable [ViewNode], using the [view] getter.
abstract class Node {
  Node({required this.position, this.eval, this.opening});

  final Position position;

  /// The local evaluation of the position.
  ClientEval? eval;

  /// The opening associated with this node.
  Opening? opening;

  final List<Branch> children = [];

  /// Immutable view of this node.
  ///
  /// Use sparingly, it is relatively expensive to compute.
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
  Iterable<Branch> get mainline sync* {
    Node current = this;
    while (current.children.isNotEmpty) {
      final child = current.children.first;
      yield child;
      current = child;
    }
  }

  bool isOnMainline(UciPath path) {
    if (path.isEmpty) return true;
    final pathId = path.head;
    final child = children.firstOrNull;
    if (child != null && child.id == pathId) {
      return child.isOnMainline(path.tail);
    } else {
      return false;
    }
  }

  /// Selects all nodes on that path.
  Iterable<Node> nodesOn(UciPath path) sync* {
    UciPath currentPath = path;

    Branch? pickChild(Node node) {
      final id = currentPath.head;
      if (id == null) {
        return null;
      }
      return node.childById(id);
    }

    Node current = this;
    Node? child;

    yield current;

    while ((child = pickChild(current)) != null) {
      yield child!;
      current = child;
      currentPath = currentPath.tail;
    }
  }

  /// Selects all branches on that path.
  Iterable<Branch> branchesOn(UciPath path) sync* {
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
      yield child!;
      current = child;
      currentPath = currentPath.tail;
    }
  }

  /// Gets the path of the mainline.
  UciPath get mainlinePath => UciPath.fromNodeList(mainline);

  /// Updates the node at the given path.
  ///
  /// Returns the updated node, or null if the node was not found.
  Node? updateAt(UciPath path, void Function(Node node) update) {
    final node = nodeAtOrNull(path);
    if (node != null) {
      update(node);
      return node;
    }
    return null;
  }

  /// Recursively applies [update] to all nodes of the tree.
  void updateAll(void Function(Node node) update) {
    update(this);
    for (final child in children) {
      child.updateAll(update);
    }
  }

  void merge(Node other) {
    if (other.eval != null) {
      eval = other.eval;
    }
    if (other.opening != null) {
      opening = other.opening;
    }
    for (final otherChild in other.children) {
      final child = childById(otherChild.id);
      if (child != null) {
        child.merge(otherChild);
      } else {
        addChild(otherChild);
      }
    }
  }

  /// Adds a new node at the given path and returns the new path.
  ///
  /// Returns a tuple of the new path and whether the node was added.
  /// Returns null if the node at path does not exist.
  ///
  /// If the node already exists, it is not added again.
  ///
  /// If [prepend] is true, the new node is added at the beginning of the children.
  /// If [replace] is true, the children of the existing node are replaced.
  (UciPath?, bool) addNodeAt(
    UciPath path,
    Branch newNode, {
    bool prepend = false,
    bool replace = false,
  }) {
    final newPath = path + newNode.id;
    final node = nodeAtOrNull(path);
    if (node != null) {
      final existing = nodeAtOrNull(newPath) != null;
      if (!existing) {
        if (replace) {
          node.children.clear();
        }
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
  UciPath? addNodesAt(UciPath path, Iterable<Branch> newNodes, {bool prepend = false}) {
    final node = newNodes.elementAtOrNull(0);
    if (node == null) return path;
    final (newPath, _) = addNodeAt(path, node, prepend: prepend);
    return newPath != null ? addNodesAt(newPath, newNodes.skip(1), prepend: prepend) : null;
  }

  /// Adds a new node with that [Move] at the given path.
  ///
  /// Returns a tuple of the new path and whether the node was added.
  /// Returns null if the node at path does not exist.
  ///
  /// If the node already exists, it is not added again.
  ///
  /// If [prepend] is true, the new node is added at the beginning of the children.
  /// If [replace] is true, the children of the existing node are replaced.
  (UciPath?, bool) addMoveAt(
    UciPath path,
    Move move, {
    bool prepend = false,
    bool replace = false,
    Duration? clock,
  }) {
    final pos = nodeAt(path).position;

    final potentialAltCastlingMove =
        move is NormalMove &&
        pos.board.roleAt(move.from) == Role.king &&
        pos.board.roleAt(move.to) != Role.rook;

    final convertedMove = potentialAltCastlingMove ? convertAltCastlingMove(move) ?? move : move;

    final (newPos, newSan) = pos.makeSan(convertedMove);
    final newNode = Branch(
      sanMove: SanMove(newSan, convertedMove),
      position: newPos,
      comments: (clock != null) ? [PgnComment(clock: clock)] : null,
    );
    return addNodeAt(path, newNode, prepend: prepend, replace: replace);
  }

  /// The function `convertAltCastlingMove` checks if a move is an alternative
  /// castling move and converts it to the corresponding standard castling move if so.
  Move? convertAltCastlingMove(Move move) {
    return altCastles.containsValue(move.uci)
        ? Move.parse(altCastles.entries.firstWhere((e) => e.value == move.uci).key)
        : move;
  }

  /// Deletes the node at the given path.
  void deleteAt(UciPath path) {
    parentAt(path).children.removeWhere((child) => child.id == path.last);
  }

  /// Promotes the node at the given path.
  void promoteAt(UciPath path, {required bool toMainline}) {
    final nodes = nodesOn(path).toList();
    for (int i = nodes.length - 2; i >= 0; i--) {
      final node = nodes[i + 1];
      final parent = nodes[i];
      if (node is Branch && parent.children[0].id != node.id) {
        parent.children.remove(node);
        parent.children.insert(0, node);
        if (!toMainline) break;
      }
    }
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

  /// Gets the parent node at the given path
  Node parentAt(UciPath path) {
    return nodeAt(path.penultimate);
  }

  /// Export the tree to a PGN string.
  ///
  /// Optionally, headers and initial game comments can be provided.
  String makePgn([IMap<String, String>? headers, IList<PgnComment>? rootComments]) {
    final pgnNode = PgnNode<PgnNodeData>();
    final List<({Node from, PgnNode<PgnNodeData> to})> stack = [(from: this, to: pgnNode)];

    while (stack.isNotEmpty) {
      final frame = stack.removeLast();
      for (int childIdx = 0; childIdx < frame.from.children.length; childIdx++) {
        final childFrom = frame.from.children[childIdx];
        final childTo = PgnChildNode(
          PgnNodeData(
            san: childFrom.sanMove.san,
            startingComments: childFrom.startingComments?.map((c) => c.makeComment()).toList(),
            comments:
                (childFrom.lichessAnalysisComments ?? childFrom.comments)?.map((c) {
                  final eval = childFrom.eval;
                  final pgnEval =
                      eval?.cp != null
                          ? PgnEvaluation.pawns(pawns: cpToPawns(eval!.cp!), depth: eval.depth)
                          : eval?.mate != null
                          ? PgnEvaluation.mate(mate: eval!.mate, depth: eval.depth)
                          : c.eval;
                  return PgnComment(
                    text: c.text,
                    shapes: c.shapes,
                    clock: c.clock,
                    emt: c.emt,
                    eval: pgnEval,
                  ).makeComment();
                }).toList(),
            nags: childFrom.nags,
          ),
        );
        frame.to.children.add(childTo);
        stack.add((from: childFrom, to: childTo));
      }
    }

    final pgnGame = PgnGame(
      headers: headers?.unlock ?? {},
      moves: pgnNode,
      comments: rootComments?.map((c) => c.makeComment()).toList() ?? [],
    );

    return pgnGame.makePgn();
  }
}

/// A branch node of a game tree
///
/// It has an associated [SanMove] and an id to identify it using an [UciPath].
class Branch extends Node {
  Branch({
    required super.position,
    super.eval,
    super.opening,
    required this.sanMove,
    this.isComputerVariation = false,
    this.isCollapsed = false,
    this.lichessAnalysisComments,
    // below are fields from dartchess [PgnNodeData]
    this.startingComments,
    this.comments,
    this.nags,
  });

  /// Whether this branch is from a variation generated by lichess computer analysis.
  final bool isComputerVariation;

  /// Whether the branch should be hidden in the tree view.
  bool isCollapsed;

  /// The id of the branch, using a concise notation of associated move.
  UciCharPair get id => UciCharPair.fromMove(sanMove.move);

  /// The associated move.
  final SanMove sanMove;

  /// PGN comments before the move.
  List<PgnComment>? startingComments;

  /// PGN comments after the move.
  List<PgnComment>? comments;

  /// Numeric Annotation Glyphs for the move.
  List<int>? nags;

  /// Lichess analysis comments.
  ///
  /// These are standard PGN comments, but get a special treatment.
  List<PgnComment>? lichessAnalysisComments;

  @override
  ViewBranch get view => ViewBranch(
    position: position,
    sanMove: sanMove,
    eval: eval,
    opening: opening,
    children: IList(children.map((child) => child.view)),
    isComputerVariation: isComputerVariation,
    isCollapsed: isCollapsed,
    lichessAnalysisComments: lichessAnalysisComments?.lock,
    startingComments: startingComments?.lock,
    comments: comments?.lock,
    nags: nags?.lock,
  );

  /// Gets the branch at the given path
  @override
  Branch branchAt(UciPath path) => nodeAt(path) as Branch;

  @override
  void merge(Node other) {
    if (other is Branch) {
      other.lichessAnalysisComments?.forEach((c) {
        if (lichessAnalysisComments == null) {
          lichessAnalysisComments = [c];
        } else {
          final existing = lichessAnalysisComments?.firstWhereOrNull((e) => e.text == c.text);
          if (existing == null) {
            lichessAnalysisComments?.add(c);
          }
        }
      });
      other.startingComments?.forEach((c) {
        if (startingComments == null) {
          startingComments = [c];
        } else {
          final existing = startingComments?.firstWhereOrNull((e) => e.text == c.text);
          if (existing == null) {
            startingComments?.add(c);
          }
        }
      });
      other.comments?.forEach((c) {
        if (comments == null) {
          comments = [c];
        } else {
          final existing = comments?.firstWhereOrNull((e) => e.text == c.text);
          if (existing == null) {
            comments?.add(c);
          }
        }
      });
      if (other.nags != null) {
        nags = other.nags;
      }
    }
    super.merge(other);
  }

  /// Gets the first available clock from the comments.
  Duration? get clock {
    final clockComment = (lichessAnalysisComments ?? comments)?.firstWhereOrNull(
      (c) => c.clock != null,
    );
    return clockComment?.clock;
  }

  /// Gets the first available external eval from the comments.
  ExternalEval? get externalEval {
    final comment = (lichessAnalysisComments ?? comments)?.firstWhereOrNull((c) => c.eval != null);
    return comment?.eval != null ? ExternalEval.fromPgnEval(comment!.eval!) : null;
  }

  @override
  String toString() {
    return 'Branch(id: $id, fen: ${position.fen}, sanMove: $sanMove, eval: $eval, children: $children)';
  }
}

/// The root node of a game tree.
///
/// Represents the initial position, where no move has been played yet.
class Root extends Node {
  Root({required super.position, super.eval});

  @override
  ViewRoot get view => ViewRoot(
    position: position,
    eval: eval,
    children: IList(children.map((child) => child.view)),
  );

  /// Creates a flat game tree from a PGN string.
  ///
  /// Assumes that the PGN string is valid and that the moves are legal.
  factory Root.fromPgnMoves(String pgn) {
    Position position = Chess.initial;
    final root = Root(position: position);
    Node current = root;
    final moves = pgn.split(' ');
    for (final san in moves) {
      final move = position.parseSan(san);
      position = position.playUnchecked(move!);
      final nextNode = Branch(sanMove: SanMove(san, move), position: position);
      current.addChild(nextNode);
      current = nextNode;
    }
    return root;
  }

  /// Creates a game tree from a PGN game.
  ///
  /// Any non legal move will be ignored.
  /// An optional callback can be provided to be called on each visited node.
  factory Root.fromPgnGame(
    PgnGame game, {
    bool isLichessAnalysis = false,
    bool hideVariations = false,
    void Function(Root root, Branch branch, bool isMainline)? onVisitNode,
  }) {
    final root = Root(position: PgnGame.startingPosition(game.headers));

    final List<({PgnNode<PgnNodeData> from, Node to, int nesting})> stack = [
      (from: game.moves, to: root, nesting: 1),
    ];

    while (stack.isNotEmpty) {
      final frame = stack.removeLast();
      for (int childIdx = 0; childIdx < frame.from.children.length; childIdx++) {
        final childFrom = frame.from.children[childIdx];
        final move = frame.to.position.parseSan(childFrom.data.san);
        if (move != null) {
          final newPos = frame.to.position.play(move);
          final isMainline = stack.isEmpty;
          final comments = childFrom.data.comments?.map(PgnComment.fromPgn);

          final branch = Branch(
            sanMove: SanMove(childFrom.data.san, move),
            position: newPos,
            isCollapsed: frame.nesting > 2 || hideVariations && childIdx > 0,
            isComputerVariation: isLichessAnalysis && childIdx > 0,
            lichessAnalysisComments: isLichessAnalysis ? comments?.toList() : null,
            startingComments:
                isLichessAnalysis
                    ? null
                    : childFrom.data.startingComments?.map(PgnComment.fromPgn).toList(),
            comments: isLichessAnalysis ? null : comments?.toList(),
            nags: childFrom.data.nags,
          );

          frame.to.addChild(branch);
          stack.add((
            from: childFrom,
            to: branch,
            nesting:
                frame.from.children.length == 1 ||
                        // mainline continuation
                        (childIdx == 0 && frame.nesting == 1)
                    ? frame.nesting
                    : frame.nesting + 1,
          ));

          onVisitNode?.call(root, branch, isMainline);
        } else {
          _logger.warning('Invalid move: ${childFrom.data.san}, on position: ${frame.to.position}');
        }
      }
    }
    return root;
  }
}

/// An immutable view of a [Node].
abstract class ViewNode {
  const ViewNode();

  UciCharPair? get id;
  SanMove? get sanMove;
  Position get position;
  IList<ViewBranch> get children;
  ClientEval? get eval;
  Opening? get opening;
  IList<PgnComment>? get startingComments;
  IList<PgnComment>? get comments;
  IList<PgnComment>? get lichessAnalysisComments;
  IList<int>? get nags;

  Iterable<ViewBranch> get mainline sync* {
    ViewNode current = this;
    while (current.children.isNotEmpty) {
      final child = current.children.first;
      yield child;
      current = child;
    }
  }
}

/// An immutable view of a [Root] node.
@freezed
sealed class ViewRoot extends ViewNode with _$ViewRoot {
  const ViewRoot._();
  const factory ViewRoot({
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

  @override
  IList<PgnComment>? get startingComments => null;

  @override
  IList<PgnComment>? get comments => null;

  @override
  IList<PgnComment>? get lichessAnalysisComments => null;

  @override
  IList<int>? get nags => null;
}

/// An immutable view of a [Branch] node.
@freezed
sealed class ViewBranch extends ViewNode with _$ViewBranch {
  const ViewBranch._();

  const factory ViewBranch({
    required SanMove sanMove,
    required Position position,
    Opening? opening,
    required IList<ViewBranch> children,
    @Default(false) bool isCollapsed,
    required bool isComputerVariation,
    ClientEval? eval,
    IList<PgnComment>? lichessAnalysisComments,
    IList<PgnComment>? startingComments,
    IList<PgnComment>? comments,
    IList<int>? nags,
  }) = _ViewBranch;

  /// The text comments of this branch.
  Iterable<String> get textComments {
    return [
      ...lichessAnalysisComments ?? IList(const []),
      ...comments ?? IList(const []),
    ].where((t) => t.text?.isNotEmpty == true).map((c) => c.text!);
  }

  /// Has at least one non empty starting comment text.
  bool get hasStartingTextComment =>
      startingComments?.any((c) => c.text?.isNotEmpty == true) == true;

  /// Has at least one non empty comment text.
  bool get hasTextComment => textComments.isNotEmpty;

  Duration? get clock {
    final clockComment = (lichessAnalysisComments ?? comments)?.firstWhereOrNull(
      (c) => c.clock != null,
    );
    return clockComment?.clock;
  }

  Duration? get elapsedMoveTime {
    final clockComment = (lichessAnalysisComments ?? comments)?.firstWhereOrNull(
      (c) => c.emt != null,
    );
    return clockComment?.emt;
  }

  /// The evaluation from the PGN comments.
  ///
  /// For now we only trust the eval coming from lichess analysis.
  ExternalEval? get serverEval {
    final pgnEval = lichessAnalysisComments?.firstWhereOrNull((c) => c.eval != null)?.eval;
    return pgnEval != null
        ? ExternalEval(
          cp: pgnEval.pawns != null ? cpFromPawns(pgnEval.pawns!) : null,
          mate: pgnEval.mate,
          depth: pgnEval.depth,
        )
        : null;
  }

  @override
  UciCharPair get id => UciCharPair.fromMove(sanMove.move);
}
