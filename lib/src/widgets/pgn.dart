import 'dart:async';

import 'package:chessground/chessground.dart';
import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:dynamic_system_colors/dynamic_system_colors.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/duration.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/rate_limit.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';

const innacuracyColor = LichessColors.cyan;
const mistakeColor = Color(0xFFe69f00);
const blunderColor = Color(0xFFdf5353);
const kInlineMovePadding = EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0);
const kIndexOpacity = 0.6;

/// Padding of the Pgn view
const kViewVerticalPadding = 10.0;
const kViewHorizontalPadding = 10.0;

const kCommentVerticalPadding = 8.0;

Color? _nagColor(BuildContext context, int nag) {
  final colorScheme = ColorScheme.of(context);
  return switch (nag) {
    1 => Colors.lightGreen.harmonizeWith(colorScheme.primary),
    2 => context.lichessColors.brag,
    3 => Colors.teal.harmonizeWith(colorScheme.primary),
    4 => context.lichessColors.error,
    5 => context.lichessColors.purple,
    6 => context.lichessColors.cyan,
    int() => null,
  };
}

String moveAnnotationChar(Iterable<int> nags) {
  return nags
      .map(
        (nag) => switch (nag) {
          1 => '!',
          2 => '?',
          3 => '!!',
          4 => '??',
          5 => '!?',
          6 => '?!',
          int() => '',
        },
      )
      .join('');
}

Annotation? makeAnnotation(Iterable<int>? nags) {
  final nag = nags?.firstOrNull;
  if (nag == null) {
    return null;
  }
  return switch (nag) {
    1 => const Annotation(symbol: '!', color: Colors.lightGreen),
    3 => const Annotation(symbol: '!!', color: Colors.teal),
    5 => const Annotation(symbol: '!?', color: Colors.purple),
    6 => const Annotation(symbol: '?!', color: LichessColors.cyan),
    2 => const Annotation(symbol: '?', color: mistakeColor),
    4 => const Annotation(symbol: '??', color: blunderColor),
    int() => null,
  };
}

// fast replay debounce delay, same as piece animation duration, to avoid piece
// animation jank at the end of the replay
const kFastReplayDebounceDelay = Duration(milliseconds: 150);

/// Callbacks for interaction with [DebouncedPgnTreeView]
abstract class PgnTreeNotifier {
  void expandVariations(UciPath path);
  void collapseVariations(UciPath path);
  void promoteVariation(UciPath path, bool toMainLine);
  void deleteFromHere(UciPath path);
  void userJump(UciPath path);
}

enum PgnTreeDisplayMode {
  /// Mainline moves are displayed in a table with two columns, where the first column are moves by white and the second column are moves by black.
  /// Sidelines are always displayed on a new line and indented.
  twoColumn,

  /// Mainline moves are displayed on a single line.
  /// Sidelines may be displayed inline with their parent mainline move if they are short and have no branching.
  ///Longer sidelines are displayed on a new line and indented.
  inlineNotation,
}

/// Displays a tree-like view of a PGN game's moves. Path changes are debounced to avoid rebuilding the whole tree on every move.
///
/// For example, the PGN 1. e4 e5 (1... d5) (1... Nc6) 2. Nf3 Nc6 (2... a5) 3. Bc4 * will be displayed as:
/// 1. e4 e5                      // [_MainLinePart]
/// |- 1... d5                    // [_SideLinePart]
/// |- 1... Nc6                   // [_SideLinePart]
/// 2. Nf3 Nc6 (2... a5) 3. Bc4   // [_MainLinePart], with inline sideline
/// Short sidelines without any branching are displayed inline with their parent line.
/// Longer sidelines are displayed on a new line and indented.
/// For [PgnTreeDisplayMode.twoColumn], 1st level sidelines of the mainline are never displayed as inline (but nested sidelines may be).
/// The mainline is split into parts whenever a move has a non-inline sideline, this corresponds to the [_MainLinePart] widget.
/// Similarly, a [_SideLinePart] contains the moves sequence of a sideline where each node has only one child.
class DebouncedPgnTreeView extends ConsumerStatefulWidget {
  const DebouncedPgnTreeView({
    required this.root,
    required this.currentPath,
    this.broadcastLivePath,
    required this.pgnRootComments,
    required this.notifier,
    this.shouldShowComputerAnalysis = true,
    this.shouldShowAnnotations = true,
    this.shouldShowComments = true,
    this.displayMode = PgnTreeDisplayMode.twoColumn,
  });

  /// Root of the PGN tree to display
  final ViewRoot root;

  /// Path to the currently selected move in the tree
  final UciPath currentPath;

  /// Path to the last live move in the tree if it is a broadcast game
  final UciPath? broadcastLivePath;

  /// Comments associated with the root node
  final IList<PgnComment>? pgnRootComments;

  /// Callbacks for when the user interacts with the tree view, e.g. selecting a different move or collapsing variations
  final PgnTreeNotifier notifier;

  /// Whether to show computer analysis informations.
  ///
  /// If `true`, the tree view will show computer analysis variations and evaluations.
  /// Only applied to lichess game analysis.
  final bool shouldShowComputerAnalysis;

  /// Display mode of the tree view.
  ///
  /// Either [PgnTreeDisplayMode.twoColumn] or [PgnTreeDisplayMode.inlineNotation].
  final PgnTreeDisplayMode displayMode;

  /// Whether to show NAG annotations like '!' and '??'.
  final bool shouldShowAnnotations;

  /// Whether to show comments associated with the moves.
  final bool shouldShowComments;

  @override
  ConsumerState<DebouncedPgnTreeView> createState() => _DebouncedPgnTreeViewState();
}

class _DebouncedPgnTreeViewState extends ConsumerState<DebouncedPgnTreeView> {
  final currentMoveKey = GlobalKey();
  final _debounce = Debouncer(kFastReplayDebounceDelay);

  /// Path to the currently selected move in the tree. When widget.currentPath changes rapidly, we debounce the change to avoid rebuilding the whole tree on every played move.
  late UciPath pathToCurrentMove;

  /// Path to the last live move in the tree if it is a broadcast game. When widget.broadcastLivePath changes rapidly, we debounce the change to avoid rebuilding the whole tree on every received move.
  late UciPath? pathToBroadcastLiveMove;

  Timer? _scrollTimer;

  @override
  void initState() {
    super.initState();
    pathToCurrentMove = widget.currentPath;
    pathToBroadcastLiveMove = widget.broadcastLivePath;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollTimer?.cancel();
      _scrollTimer = Timer(const Duration(milliseconds: 500), () {
        if (currentMoveKey.currentContext != null) {
          Scrollable.ensureVisible(
            currentMoveKey.currentContext!,
            alignment: 0.5,
            alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _debounce.cancel();
    _scrollTimer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant DebouncedPgnTreeView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentPath != widget.currentPath ||
        oldWidget.broadcastLivePath != widget.broadcastLivePath) {
      // debouncing the current and broadcast live path changes to avoid rebuilding when using
      // the fast replay buttons or when receiving a lot of broadcast moves in a short time
      _debounce(() {
        setState(() {
          if (oldWidget.currentPath != widget.currentPath) {
            pathToCurrentMove = widget.currentPath;
          }
          if (oldWidget.broadcastLivePath != widget.broadcastLivePath) {
            pathToBroadcastLiveMove = widget.broadcastLivePath;
          }
        });
        if (oldWidget.currentPath != widget.currentPath) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (currentMoveKey.currentContext != null) {
              Scrollable.ensureVisible(
                currentMoveKey.currentContext!,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeIn,
                alignment: 0.5,
                alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
              );
            }
          });
        }
      });
    }
  }

  // This is the most expensive part of the pgn tree view because of the tree
  // that may be very large.
  // Great care must be taken to avoid unnecessary rebuilds.
  // This should actually rebuild only when the current path changes or a new node
  // is added.
  // Debouncing the current path change is necessary to avoid rebuilding when
  // using the fast replay buttons.
  @override
  Widget build(BuildContext context) {
    return _PgnTreeView(
      root: widget.root,
      rootComments: widget.pgnRootComments,
      params: (
        shouldShowComputerAnalysis: widget.shouldShowComputerAnalysis,
        shouldShowAnnotations: widget.shouldShowAnnotations,
        shouldShowComments: widget.shouldShowComments,
        currentMoveKey: currentMoveKey,
        pathToCurrentMove: pathToCurrentMove,
        pathToBroadcastLiveMove: pathToBroadcastLiveMove,
        displayMode: widget.displayMode,
        notifier: widget.notifier,
      ),
    );
  }
}

/// A group of parameters that are passed through various parts of the tree view
/// and ultimately evaluated in the [InlineMove] widget.
///
/// Grouped in this record to improve readability.
typedef _PgnTreeViewParams =
    ({
      /// Path to the currently selected move in the tree.
      UciPath pathToCurrentMove,

      /// Path to the last live move in the tree if it is a broadcast game
      UciPath? pathToBroadcastLiveMove,

      /// Whether to show analysis variations.
      bool shouldShowComputerAnalysis,

      /// Whether to show NAG annotations like '!' and '??'.
      bool shouldShowAnnotations,

      /// Whether to show comments associated with the moves.
      bool shouldShowComments,

      /// How the moves in the tree should be displayed.
      PgnTreeDisplayMode displayMode,

      /// Key that will we assigned to the widget corresponding to [pathToCurrentMove].
      /// Can be used e.g. to ensure that the current move is visible on the screen.
      GlobalKey currentMoveKey,

      /// Callbacks for when the user interacts with the tree view, e.g. selecting a different move.
      PgnTreeNotifier notifier,
    });

/// Filter node children when computer analysis is disabled
IList<ViewBranch> _filteredChildren(ViewNode node, bool shouldShowComputerAnalysis) {
  return node.children.where((c) => shouldShowComputerAnalysis || !c.isComputerVariation).toIList();
}

/// Whether to display the sideline inline.
///
/// Sidelines are usually rendered on a new line and indented.
/// However sidelines are rendered inline (in parantheses) if the side line has no branching and is less than 6 moves deep.
bool _displaySideLineAsInline(ViewBranch node, [int depth = 0]) {
  if (depth == 6) return false;
  if (node.children.isEmpty) return true;
  if (node.children.length > 1) return false;
  return _displaySideLineAsInline(node.children.first, depth + 1);
}

/// Returns whether this node has a sideline that should not be displayed inline.
bool _hasNonInlineSideLine(ViewNode node, _PgnTreeViewParams params, {required bool isMainline}) {
  final children = _filteredChildren(node, params.shouldShowComputerAnalysis);
  return isMainline && params.displayMode == PgnTreeDisplayMode.twoColumn
      ? children.length >= 2 || node.children.firstOrNull?.hasTextComment == true
      : children.length > 2 || (children.length == 2 && !_displaySideLineAsInline(children[1]));
}

/// Splits the mainline into parts, where each part is a sequence of moves that are displayed on the same line.
///
/// A part ends when a mainline node has a sideline that should not be displayed inline.
Iterable<List<ViewNode>> _mainlineParts(ViewRoot root, _PgnTreeViewParams params) =>
    [root, ...root.mainline]
        .splitAfter((n) => _hasNonInlineSideLine(n, params, isMainline: true))
        .takeWhile((nodes) => nodes.firstOrNull?.children.isNotEmpty == true);

class _PgnTreeView extends StatefulWidget {
  const _PgnTreeView({required this.root, required this.rootComments, required this.params});

  /// Root of the PGN tree
  final ViewRoot root;

  /// Comments associated with the root node
  final IList<PgnComment>? rootComments;

  final _PgnTreeViewParams params;

  @override
  State<_PgnTreeView> createState() => _PgnTreeViewState();
}

/// A record that holds the rendered parts of a subtree.
typedef _CachedRenderedSubtree =
    ({
      /// The mainline part of the subtree.
      _MainLinePart mainLinePart,

      /// The sidelines part of the subtree.
      ///
      /// This is nullable since the very last mainline part might not have any sidelines.
      _IndentedSideLines? sidelines,

      /// Whether the subtree contains the current move.
      bool containsCurrentMove,
    });

class _PgnTreeViewState extends State<_PgnTreeView> {
  /// Caches the result of [_mainlineParts], it only needs to be recalculated when the root changes,
  /// but not when `params.pathToCurrentMove` changes.
  Iterable<List<ViewNode>> mainlineParts = [];

  /// Cache of the top-level subtrees obtained from the last `build()` method.
  ///
  /// Building the whole tree is expensive, so we cache the subtrees that did not change when the current move changes.
  /// The framework will skip the `build()` of each subtree since the widget reference is the same.
  List<_CachedRenderedSubtree> subtrees = [];

  UciPath _mainlinePartOfCurrentPath() {
    var path = UciPath.empty;
    for (final node in widget.root.mainline) {
      if (!widget.params.pathToCurrentMove.contains(path + node.id)) {
        break;
      }
      path = path + node.id;
    }
    return path;
  }

  List<_CachedRenderedSubtree> _buildChangedSubtrees({required bool fullRebuild}) {
    var path = UciPath.empty;
    return mainlineParts
        .mapIndexed((i, mainlineNodes) {
          final mainlineInitialPath = path;

          final sidelineInitialPath = UciPath.join(
            path,
            UciPath.fromIds(
              mainlineNodes.take(mainlineNodes.length - 1).map((n) => n.children.first.id),
            ),
          );

          path = sidelineInitialPath;
          if (mainlineNodes.last.children.isNotEmpty) {
            path = path + mainlineNodes.last.children.first.id;
          }

          final mainlinePartOfCurrentPath = _mainlinePartOfCurrentPath();
          final currentMoveIsOnMainline =
              mainlinePartOfCurrentPath == widget.params.pathToCurrentMove;

          final containsCurrentMove =
              currentMoveIsOnMainline
                  ? mainlinePartOfCurrentPath.size > mainlineInitialPath.size &&
                      mainlinePartOfCurrentPath.size <= path.size
                  : mainlinePartOfCurrentPath.size >= mainlineInitialPath.size &&
                      mainlinePartOfCurrentPath.size < path.size;

          if (fullRebuild || subtrees[i].containsCurrentMove || containsCurrentMove) {
            // Skip the first node which is the continuation of the mainline
            final sidelineNodes = mainlineNodes.last.children.skip(1);
            return (
              mainLinePart: _MainLinePart(
                params: widget.params,
                initialPath: mainlineInitialPath,
                nodes: mainlineNodes,
              ),
              sidelines:
                  sidelineNodes.isNotEmpty
                      ? _IndentedSideLines(
                        sidelineNodes,
                        parent: mainlineNodes.last,
                        params: widget.params,
                        initialPath: sidelineInitialPath,
                        nesting: 1,
                      )
                      : null,
              containsCurrentMove: containsCurrentMove,
            );
          } else {
            // Avoid expensive rebuilds ([State.build]) of the entire PGN tree by caching parts of the tree that did not change across a path change
            return subtrees[i];
          }
        })
        .toList(growable: false);
  }

  void _updateLines({required bool fullRebuild}) {
    setState(() {
      if (fullRebuild) {
        mainlineParts = _mainlineParts(widget.root, widget.params);
      }

      subtrees = _buildChangedSubtrees(fullRebuild: fullRebuild);
    });
  }

  @override
  void initState() {
    super.initState();
    _updateLines(fullRebuild: true);
  }

  @override
  void didUpdateWidget(covariant _PgnTreeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateLines(
      fullRebuild:
          oldWidget.root != widget.root ||
          oldWidget.params.shouldShowComputerAnalysis != widget.params.shouldShowComputerAnalysis ||
          oldWidget.params.shouldShowComments != widget.params.shouldShowComments ||
          oldWidget.params.shouldShowAnnotations != widget.params.shouldShowAnnotations ||
          oldWidget.params.displayMode != widget.params.displayMode,
    );
  }

  @override
  Widget build(BuildContext context) {
    final rootComments = widget.rootComments?.map((c) => c.text).nonNulls ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // trick to make auto-scroll work when returning to the root position
        if (widget.params.pathToCurrentMove.isEmpty)
          SizedBox.shrink(key: widget.params.currentMoveKey),

        if (widget.params.shouldShowComments && rootComments.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: kCommentVerticalPadding,
              horizontal: kViewHorizontalPadding,
            ),
            child: Text.rich(
              TextSpan(children: _comments(rootComments, textStyle: _baseTextStyle)),
            ),
          ),
        ...subtrees
            .map((part) => [part.mainLinePart, if (part.sidelines != null) part.sidelines!])
            .flattened,
      ],
    );
  }
}

List<InlineSpan> _buildInlineSideLine({
  required ViewBranch firstNode,
  required ViewNode parent,
  required UciPath initialPath,
  required TextStyle textStyle,
  required bool followsComment,
  required _PgnTreeViewParams params,
}) {
  textStyle = textStyle.copyWith(
    fontSize: textStyle.fontSize != null ? textStyle.fontSize! - 2.0 : null,
  );

  final sidelineNodes = [firstNode, ...firstNode.mainline];

  var path = initialPath;
  return [
    if (followsComment) const WidgetSpan(child: SizedBox(width: 4.0)),
    ...sidelineNodes.mapIndexedAndLast((i, node, last) {
      final pathToNode = path;
      path = path + node.id;

      return [
        if (i == 0) ...[
          if (followsComment) const WidgetSpan(child: SizedBox(width: 4.0)),
          TextSpan(text: '(', style: textStyle),
        ],
        ..._moveWithComment(
          node,
          lineInfo: (
            type: _LineType.inlineSideline,
            startLine: i == 0 || (params.shouldShowComments && sidelineNodes[i - 1].hasTextComment),
            pathToLine: initialPath,
          ),
          pathToNode: pathToNode,
          textStyle: textStyle,
          params: params,
        ),
        if (last) TextSpan(text: ')', style: textStyle),
      ];
    }).flattened,
    const WidgetSpan(child: SizedBox(width: 4.0)),
  ];
}

const _baseTextStyle = TextStyle(fontSize: 16.0, height: 1.5);

/// The different types of lines (move sequences) that are displayed in the tree view.
enum _LineType {
  /// (A part of) the game's main line.
  mainline,

  /// A sideline branching off the main line or a parent sideline.
  ///
  /// Each sideline is rendered on a new line and indented.
  sideline,

  /// A short sideline without any branching, displayed in parantheses inline with it's parent line.
  inlineSideline,
}

/// Metadata about a move's role in the tree view.
typedef _LineInfo = ({_LineType type, bool startLine, UciPath pathToLine});

List<InlineSpan> _moveWithComment(
  ViewBranch branch, {
  required TextStyle textStyle,
  required _LineInfo lineInfo,
  required UciPath pathToNode,
  required _PgnTreeViewParams params,

  /// Optional [GlobalKey] that will be assigned to the [InlineMove] widget.
  ///
  /// It should only be set if it is the first move of a sideline.
  /// We use this to track the position of the first move widget. See [_SideLinePart.firstMoveKey].
  GlobalKey? firstMoveKey,
}) {
  return [
    WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: InlineMove(
        key: firstMoveKey,
        branch: branch,
        lineInfo: lineInfo,
        path: pathToNode + branch.id,
        textStyle: textStyle,
        params: params,
      ),
    ),
    if (params.shouldShowComments && branch.hasTextComment)
      ..._comments(branch.textComments, textStyle: textStyle),
  ];
}

/// A widget that renders part of a sideline, where each move is displayed on the same line without branching.
///
/// Each node in the sideline has only one child (or two children where the second child is rendered as an inline sideline).
class _SideLinePart extends ConsumerWidget {
  _SideLinePart(
    this.nodes, {
    required this.initialPath,
    required this.firstMoveKey,
    required this.params,
  }) : assert(nodes.isNotEmpty);

  final List<ViewBranch> nodes;

  final UciPath initialPath;

  /// The key that will be assigned to the first move in this sideline.
  ///
  /// This is needed so that the indent guidelines can be drawn correctly.
  final GlobalKey firstMoveKey;

  final _PgnTreeViewParams params;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = _baseTextStyle.copyWith(
      color: _textColor(context, 0.6),
      fontSize: _baseTextStyle.fontSize! - 1.0,
    );

    var path = initialPath + nodes.first.id;
    final moves = [
      ..._moveWithComment(
        nodes.first,
        lineInfo: (type: _LineType.sideline, startLine: true, pathToLine: initialPath),
        firstMoveKey: firstMoveKey,
        pathToNode: initialPath,
        textStyle: textStyle,
        params: params,
      ),
      ...nodes.take(nodes.length - 1).map((node) {
        final moves = [
          ..._moveWithComment(
            node.children.first,
            lineInfo: (
              type: _LineType.sideline,
              startLine: params.shouldShowComments && node.hasTextComment,
              pathToLine: initialPath,
            ),
            pathToNode: path,
            textStyle: textStyle,
            params: params,
          ),
          if (node.children.length == 2 && _displaySideLineAsInline(node.children[1]))
            ..._buildInlineSideLine(
              followsComment: node.children.first.hasTextComment,
              firstNode: node.children[1],
              parent: node,
              initialPath: path,
              textStyle: textStyle,
              params: params,
            ),
        ];
        path = path + node.children.first.id;
        return moves;
      }).flattened,
    ];

    return Padding(
      padding:
          params.displayMode == PgnTreeDisplayMode.twoColumn
              ? const EdgeInsets.symmetric(vertical: kCommentVerticalPadding)
              : EdgeInsets.zero,
      child: Text.rich(TextSpan(children: moves)),
    );
  }
}

/// A widget that renders part of the mainline if the display mode is [PgnTreeDisplayMode.twoColumn].
///
/// The mainline part is split into two columns, where the first column are moves by white and the second column are moves by black.
///
/// For example:
/// 1. e4 e5        -> mainline part
/// 2. Nf3 ...      -> mainline part (continuation)
/// |- 2. Nc3       -> sideline part
/// |- 2. d4        -> sideline part
/// 2. ... Nc6      -> mainline part
class _TwoColumnMainlinePart extends ConsumerWidget {
  const _TwoColumnMainlinePart({
    required this.initialPath,
    required this.params,
    required this.nodes,
  });

  final UciPath initialPath;

  final List<ViewNode> nodes;

  final _PgnTreeViewParams params;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dividerColor = theme.dividerColor;
    final brightness = theme.brightness;
    final textStyle = _baseTextStyle.copyWith(color: _textColor(context, 0.9));

    final threeDots = Container(padding: kInlineMovePadding, child: const Text('...'));

    final firstMoveIsBlack = nodes.first.position.turn == Side.black;

    final filteredNodes = nodes.takeWhile(
      (node) => _filteredChildren(node, params.shouldShowComputerAnalysis).isNotEmpty,
    );

    var path = initialPath;
    final moves = [
      if (firstMoveIsBlack) threeDots,
      ...filteredNodes.mapIndexed((i, node) {
        final mainlineNode = _filteredChildren(node, params.shouldShowComputerAnalysis).first;
        final move = InlineMove(
          branch: mainlineNode,
          textStyle: textStyle,
          lineInfo: (
            type: _LineType.mainline,
            startLine: i == 0 || (params.shouldShowComments && (node as ViewBranch).hasTextComment),
            pathToLine: initialPath,
          ),
          path: path + mainlineNode.id,
          params: params,
          showIndex: false,
          canShowEval: true,
        );
        path = path + mainlineNode.id;
        return move as Widget;
      }),
      if (firstMoveIsBlack == filteredNodes.length.isEven) threeDots,
    ];

    final lastBranch = _filteredChildren(nodes.last, params.shouldShowComputerAnalysis).firstOrNull;

    final initialFullmoves = nodes.first.position.fullmoves;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 4, right: kViewHorizontalPadding, bottom: 4),
          decoration: BoxDecoration(
            color:
                brightness == Brightness.dark ? const Color(0x0BFFFFFF) : const Color(0x05000000),
            border: Border(
              top: BorderSide(color: dividerColor),
              bottom: BorderSide(color: dividerColor),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...List.generate(
                    (moves.length / 2).ceil(),
                    (i) => Container(
                      width: 50,
                      padding: kInlineMovePadding.copyWith(left: 0, right: 0),
                      child: Text(
                        '${initialFullmoves + i}',
                        textAlign: TextAlign.center,
                        style: _baseTextStyle.copyWith(
                          color: _textColor(context, kIndexOpacity),
                          fontFeatures: [const FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: InlineMove.borderRadius,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...moves
                          .slices(2)
                          .mapIndexed(
                            (i, moves) =>
                                Row(children: [...moves.map((move) => Expanded(child: move))]),
                          ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (params.shouldShowComments && lastBranch?.hasTextComment == true)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: kViewHorizontalPadding),
            child: Text.rich(
              TextSpan(children: _comments(lastBranch!.textComments, textStyle: textStyle)),
            ),
          ),
      ],
    );
  }
}

/// A widget that renders part of the mainline if the display mode is [PgnTreeDisplayMode.inlineNotation].
///
/// A part of the mainline is rendered on a single line. See [_mainlineParts].
///
/// For example:
/// 1. e4 e5                      <-- mainline part
/// |- 1... d5                    <-- sideline part
/// |- 1... Nc6                   <-- sideline part
/// 2. Nf3 Nc6 (2... a5) 3. Bc4   <-- mainline part
class _InlineNotationMainlinePart extends ConsumerWidget {
  const _InlineNotationMainlinePart({
    required this.initialPath,
    required this.params,
    required this.nodes,
  });

  final UciPath initialPath;

  final List<ViewNode> nodes;

  final _PgnTreeViewParams params;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = _baseTextStyle.copyWith(color: _textColor(context, 0.9));

    var path = initialPath;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: kViewVerticalPadding,
        horizontal: kViewHorizontalPadding,
      ),
      child: Text.rich(
        TextSpan(
          children: nodes
              .takeWhile(
                (node) => _filteredChildren(node, params.shouldShowComputerAnalysis).isNotEmpty,
              )
              .mapIndexed((i, node) {
                final children = _filteredChildren(node, params.shouldShowComputerAnalysis);
                final mainlineNode = children.first;
                final moves = [
                  _moveWithComment(
                    mainlineNode,
                    lineInfo: (
                      type: _LineType.mainline,
                      startLine:
                          i == 0 ||
                          (params.shouldShowComments && (node as ViewBranch).hasTextComment),
                      pathToLine: initialPath,
                    ),
                    pathToNode: path,
                    textStyle: textStyle,
                    params: params,
                  ),
                  if (children.length == 2 && _displaySideLineAsInline(children[1])) ...[
                    _buildInlineSideLine(
                      followsComment: mainlineNode.hasTextComment,
                      firstNode: children[1],
                      parent: node,
                      initialPath: path,
                      textStyle: textStyle,
                      params: params,
                    ),
                  ],
                ];
                path = path + mainlineNode.id;
                return moves.flattened;
              })
              .flattened
              .toList(growable: false),
        ),
      ),
    );
  }
}

class _MainLinePart extends ConsumerWidget {
  const _MainLinePart({required this.initialPath, required this.params, required this.nodes});

  final UciPath initialPath;

  final List<ViewNode> nodes;

  final _PgnTreeViewParams params;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (params.displayMode) {
      PgnTreeDisplayMode.twoColumn => _TwoColumnMainlinePart(
        initialPath: initialPath,
        params: params,
        nodes: nodes,
      ),
      PgnTreeDisplayMode.inlineNotation => _InlineNotationMainlinePart(
        initialPath: initialPath,
        params: params,
        nodes: nodes,
      ),
    };
  }
}

/// A widget that renders a sideline.
///
/// The moves are rendered on the same line (see [_SideLinePart]) until further
/// branching is encountered, at which point the children sidelines are rendered
/// on new lines and indented (see [_IndentedSideLines]).
class _SideLine extends StatelessWidget {
  const _SideLine({
    required this.firstNode,
    required this.parent,
    required this.firstMoveKey,
    required this.initialPath,
    required this.params,
    required this.nesting,
  });

  final ViewBranch firstNode;
  final ViewNode parent;
  final GlobalKey firstMoveKey;
  final UciPath initialPath;
  final _PgnTreeViewParams params;
  final int nesting;

  List<ViewBranch> _getSidelinePartNodes() {
    final sidelineNodes = [firstNode];
    while (sidelineNodes.last.children.isNotEmpty &&
        !_hasNonInlineSideLine(sidelineNodes.last, params, isMainline: false)) {
      sidelineNodes.add(sidelineNodes.last.children.first);
    }
    return sidelineNodes.toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final sidelinePartNodes = _getSidelinePartNodes();

    final lastNodeChildren = sidelinePartNodes.last.children;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SideLinePart(
          sidelinePartNodes,
          firstMoveKey: firstMoveKey,
          initialPath: initialPath,
          params: params,
        ),
        if (lastNodeChildren.isNotEmpty)
          _IndentedSideLines(
            lastNodeChildren,
            parent: sidelinePartNodes.last,
            initialPath: UciPath.join(
              initialPath,
              UciPath.fromIds(sidelinePartNodes.map((node) => node.id)),
            ),
            params: params,
            nesting: nesting + 1,
          ),
      ],
    );
  }
}

class _IndentPainter extends CustomPainter {
  const _IndentPainter({
    required this.sideLineStartPositions,
    required this.color,
    required this.padding,
  });

  final List<Offset> sideLineStartPositions;

  final Color color;

  final double padding;

  @override
  void paint(Canvas canvas, Size size) {
    if (sideLineStartPositions.isNotEmpty) {
      final paint =
          Paint()
            ..strokeWidth = 1.5
            ..color = color
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke;

      final origin = Offset(-padding, 0);

      final path = Path()..moveTo(origin.dx, origin.dy);
      path.lineTo(origin.dx, sideLineStartPositions.last.dy);
      for (final position in sideLineStartPositions) {
        path.moveTo(origin.dx, position.dy);
        path.lineTo(origin.dx + padding / 2, position.dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_IndentPainter oldDelegate) {
    return oldDelegate.sideLineStartPositions != sideLineStartPositions ||
        oldDelegate.color != color;
  }
}

/// A widget that displays indented sidelines.
///
/// Will show one ore more sidelines indented on their own line and add indent
/// guides.
/// If there are hidden lines, a "+" button is displayed to expand them.
class _IndentedSideLines extends StatefulWidget {
  const _IndentedSideLines(
    this.sideLines, {
    required this.parent,
    required this.initialPath,
    required this.params,
    required this.nesting,
  });

  final Iterable<ViewBranch> sideLines;

  final ViewNode parent;

  final UciPath initialPath;

  final _PgnTreeViewParams params;

  final int nesting;

  @override
  State<_IndentedSideLines> createState() => _IndentedSideLinesState();
}

class _IndentedSideLinesState extends State<_IndentedSideLines> {
  /// Keys for the first move of each sideline.
  ///
  /// Used to calculate the position of the indent guidelines. The keys are
  /// assigned to the first move of each sideline. The position of the keys is
  /// used to calculate the position of the indent guidelines. A [GlobalKey] is
  /// necessary because the exact position of the first move is not known until the
  /// widget is rendered, as the vertical space can vary depending on the length of
  /// the line, and if the line is wrapped.
  late List<GlobalKey> _sideLinesStartKeys;

  /// The position of the first move of each sideline computed relative to the column and derived from the [GlobalKey] found in [_sideLinesStartKeys].
  List<Offset> _sideLineStartPositions = [];

  /// The [GlobalKey] for the column that contains the side lines.
  final GlobalKey _columnKey = GlobalKey();

  /// Redraws the indents on demand.
  ///
  /// Will re-generate the [GlobalKey]s for the first move of each sideline and
  /// calculate the position of the indents in a post-frame callback.
  void _redrawIndents() {
    _sideLinesStartKeys = List.generate(
      _expandedSidelines.length + (_hasCollapsedLines ? 1 : 0),
      (_) => GlobalKey(),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox? columnBox = _columnKey.currentContext?.findRenderObject() as RenderBox?;
      final Offset rowOffset = columnBox?.localToGlobal(Offset.zero) ?? Offset.zero;

      final positions = _sideLinesStartKeys
          .map((key) {
            final context = key.currentContext;
            final renderBox = context?.findRenderObject() as RenderBox?;
            final height = renderBox?.size.height ?? 0;
            final offset = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
            return Offset(offset.dx, offset.dy + height / 2) - rowOffset;
          })
          .toList(growable: false);

      if (mounted) {
        setState(() {
          _sideLineStartPositions = positions;
        });
      }
    });
  }

  bool get _hasCollapsedLines => widget.sideLines.any((node) => node.isCollapsed);

  Iterable<ViewBranch> get _expandedSidelines =>
      widget.sideLines.whereNot((node) => node.isCollapsed);

  @override
  void initState() {
    super.initState();
    _redrawIndents();
  }

  @override
  void didUpdateWidget(covariant _IndentedSideLines oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sideLines != widget.sideLines) {
      _redrawIndents();
    }
  }

  @override
  Widget build(BuildContext context) {
    final sideLineWidgets = _expandedSidelines
        .mapIndexed(
          (i, firstSidelineNode) => _SideLine(
            firstNode: firstSidelineNode,
            parent: widget.parent,
            firstMoveKey: _sideLinesStartKeys[i],
            initialPath: widget.initialPath,
            params: widget.params,
            nesting: widget.nesting,
          ),
        )
        .toList(growable: false);

    final padding = widget.nesting < 6 ? 12.0 : 0.0;

    return Padding(
      padding: EdgeInsets.only(
        left: padding + kViewHorizontalPadding,
        right: widget.nesting == 1 ? kViewHorizontalPadding : 0,
      ),
      child: CustomPaint(
        painter: _IndentPainter(
          sideLineStartPositions: _sideLineStartPositions,
          color: _textColor(context, 0.3)!,
          padding: padding,
        ),
        child: Column(
          key: _columnKey,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...sideLineWidgets,
            if (_hasCollapsedLines)
              GestureDetector(
                child: Icon(
                  Icons.add_box,
                  color: _textColor(context, 0.6),
                  key: _sideLinesStartKeys.last,
                  size: _baseTextStyle.fontSize! + 5,
                ),
                onTap: () {
                  widget.params.notifier.expandVariations(widget.initialPath);
                },
              ),
          ],
        ),
      ),
    );
  }
}

Color? _textColor(BuildContext context, double opacity, {int? nag}) {
  final defaultColor = TextTheme.of(context).bodyLarge?.color?.withValues(alpha: opacity);

  return nag != null && nag > 0 ? _nagColor(context, nag) : defaultColor;
}

/// A widget that displays a single move in the tree view.
///
/// The move can optionnally be preceded by an index, and followed by a nag annotation.
/// The move is displayed as a clickable button that will jump to the move when pressed.
/// The move is highlighted if it is the current move.
/// A long press on the move will display a context menu with options to promote the move to the main line, collapse variations, etc.
class InlineMove extends ConsumerWidget {
  const InlineMove({
    required this.branch,
    required this.path,
    required this.textStyle,
    required this.lineInfo,
    required this.params,
    this.showIndex = true,
    this.canShowEval = false,
    super.key,
  });

  final ViewBranch branch;
  final UciPath path;

  final TextStyle textStyle;

  final _LineInfo lineInfo;

  final _PgnTreeViewParams params;

  /// Whether to show the index of the move.
  final bool showIndex;

  /// Whether to show the computer evaluation of the move.
  ///
  /// Default is `false` because we don't want to show the eval in the sidelines and in the mainline
  /// if the [PgnTreeDisplayMode] is [PgnTreeDisplayMode.inlineNotation].
  /// It is set to `true` in the mainline part of [PgnTreeDisplayMode.twoColumn] view.
  final bool canShowEval;

  static const borderRadius = BorderRadius.all(Radius.circular(4.0));

  bool get isCurrentMove => params.pathToCurrentMove == path;

  bool get isBroadcastLiveMove => params.pathToBroadcastLiveMove == path;

  BoxDecoration? _boxDecoration(BuildContext context, bool isCurrentMove, bool isLiveMove) {
    return (isCurrentMove || isLiveMove)
        ? BoxDecoration(
          color: isCurrentMove ? Theme.of(context).focusColor : null,
          shape: BoxShape.rectangle,
          borderRadius: borderRadius,
          border: isLiveMove ? Border.all(width: 2, color: Colors.orange) : null,
        )
        : null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pieceNotation = ref
        .watch(pieceNotationProvider)
        .maybeWhen(data: (value) => value, orElse: () => defaultAccountPreferences.pieceNotation);
    final moveFontFamily = pieceNotation == PieceNotation.symbol ? 'ChessFont' : null;
    final moveTextStyle = textStyle.copyWith(
      fontFamily: moveFontFamily,
      fontWeight: lineInfo.type == _LineType.inlineSideline ? FontWeight.normal : FontWeight.w600,
    );

    final indexTextStyle = textStyle.copyWith(color: _textColor(context, kIndexOpacity));
    final indexText =
        showIndex
            ? branch.position.ply.isOdd
                ? TextSpan(text: '${(branch.position.ply / 2).ceil()}. ', style: indexTextStyle)
                : (lineInfo.startLine
                    ? TextSpan(text: '${(branch.position.ply / 2).ceil()}… ', style: indexTextStyle)
                    : null)
            : null;

    final moveWithNag =
        branch.sanMove.san +
        (branch.nags != null && params.shouldShowAnnotations
            ? moveAnnotationChar(branch.nags!)
            : '');

    final nag = params.shouldShowAnnotations ? branch.nags?.firstOrNull : null;
    final ply = branch.position.ply;

    final eval =
        params.shouldShowComputerAnalysis && canShowEval ? branch.eval ?? branch.serverEval : null;

    return AdaptiveInkWell(
      key: isCurrentMove ? params.currentMoveKey : null,
      borderRadius: borderRadius,
      onTap: () => params.notifier.userJump(path),
      onLongPress: () {
        showAdaptiveBottomSheet<void>(
          context: context,
          isDismissible: true,
          isScrollControlled: true,
          showDragHandle: true,
          builder:
              (context) => _MoveContextMenu(
                notifier: params.notifier,
                title:
                    ply.isOdd
                        ? '${(ply / 2).ceil()}. $moveWithNag'
                        : '${(ply / 2).ceil()}... $moveWithNag',
                path: path,
                branch: branch,
                lineInfo: lineInfo,
              ),
        );
      },
      child: Container(
        padding: kInlineMovePadding,
        decoration: _boxDecoration(context, isCurrentMove, isBroadcastLiveMove),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  if (indexText != null) indexText,
                  TextSpan(
                    text: moveWithNag,
                    style: moveTextStyle.copyWith(
                      color: _textColor(context, isCurrentMove ? 1 : 0.9, nag: nag),
                    ),
                  ),
                ],
              ),
            ),
            if (eval != null)
              Text(
                eval.evalString,
                style: moveTextStyle.copyWith(
                  fontSize: moveTextStyle.fontSize != null ? moveTextStyle.fontSize! - 3.0 : null,
                  color: _textColor(context, 0.4),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MoveContextMenu extends ConsumerWidget {
  const _MoveContextMenu({
    required this.title,
    required this.path,
    required this.branch,
    required this.lineInfo,
    required this.notifier,
  });

  final String title;
  final UciPath path;
  final ViewBranch branch;
  final _LineInfo lineInfo;
  final PgnTreeNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomSheetScrollableContainer(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextTheme.of(context).titleLarge),
              if (branch.clock != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.punch_clock),
                        const SizedBox(width: 4.0),
                        Text(
                          branch.clock!.toHoursMinutesSeconds(
                            showTenths: branch.clock! < const Duration(minutes: 1),
                          ),
                        ),
                      ],
                    ),
                    if (branch.elapsedMoveTime != null) ...[
                      const SizedBox(height: 4.0),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.hourglass_bottom),
                          const SizedBox(width: 4.0),
                          Text(branch.elapsedMoveTime!.toHoursMinutesSeconds(showTenths: true)),
                        ],
                      ),
                    ],
                  ],
                ),
            ],
          ),
        ),
        if (branch.hasTextComment)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: kCommentVerticalPadding,
            ),
            child: Text(branch.textComments.join(' ')),
          ),
        const PlatformDivider(indent: 0),
        if (lineInfo.type != _LineType.mainline) ...[
          BottomSheetContextMenuAction(
            icon: Icons.subtitles_off,
            child: Text(context.l10n.collapseVariations),
            onPressed: () => notifier.collapseVariations(lineInfo.pathToLine),
          ),
          BottomSheetContextMenuAction(
            icon: Icons.expand_less,
            child: Text(context.l10n.promoteVariation),
            onPressed: () => notifier.promoteVariation(path, false),
          ),
          BottomSheetContextMenuAction(
            icon: Icons.check,
            child: Text(context.l10n.makeMainLine),
            onPressed: () => notifier.promoteVariation(path, true),
          ),
        ],
        BottomSheetContextMenuAction(
          icon: Icons.delete,
          child: Text(context.l10n.deleteFromHere),
          onPressed: () => notifier.deleteFromHere(path),
        ),
      ],
    );
  }
}

List<TextSpan> _comments(Iterable<String> comments, {required TextStyle textStyle}) => comments
    .map(
      (comment) =>
          TextSpan(text: comment, style: textStyle.copyWith(fontSize: textStyle.fontSize! - 2.0)),
    )
    .toList(growable: false);
