import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/analysis/opening_service.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/utils/duration.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/rate_limit.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';

import 'annotations.dart';

// fast replay debounce delay, same as piece animation duration, to avoid piece
// animation jank at the end of the replay
const kFastReplayDebounceDelay = Duration(milliseconds: 150);
const kOpeningHeaderHeight = 32.0;
const kInlineMoveSpacing = 3.0;

class AnalysisTreeView extends ConsumerStatefulWidget {
  const AnalysisTreeView(
    this.pgn,
    this.options,
    this.displayMode,
  );

  final String pgn;
  final AnalysisOptions options;
  final Orientation displayMode;

  @override
  ConsumerState<AnalysisTreeView> createState() => _InlineTreeViewState();
}

class _InlineTreeViewState extends ConsumerState<AnalysisTreeView> {
  final currentMoveKey = GlobalKey();
  final _debounce = Debouncer(kFastReplayDebounceDelay);
  late UciPath currentPath;

  @override
  void initState() {
    super.initState();
    currentPath = ref.read(
      analysisControllerProvider(widget.pgn, widget.options).select(
        (value) => value.currentPath,
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (currentMoveKey.currentContext != null) {
        Scrollable.ensureVisible(
          currentMoveKey.currentContext!,
          alignment: 0.5,
          alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
        );
      }
    });
  }

  @override
  void dispose() {
    _debounce.dispose();
    super.dispose();
  }

  // This is the most expensive part of the analysis view because of the tree
  // that may be very large.
  // Great care must be taken to avoid unnecessary rebuilds.
  // This should actually rebuild only when the current path changes or a new node
  // is added.
  // Debouncing the current path change is necessary to avoid rebuilding when
  // using the fast replay buttons.
  @override
  Widget build(BuildContext context) {
    ref.listen(
      analysisControllerProvider(widget.pgn, widget.options),
      (prev, state) {
        if (prev?.currentPath != state.currentPath) {
          // debouncing the current path change to avoid rebuilding when using
          // the fast replay buttons
          _debounce(() {
            setState(() {
              currentPath = state.currentPath;
            });
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
          });
        }
      },
    );

    final ctrlProvider = analysisControllerProvider(widget.pgn, widget.options);
    final root = ref.watch(ctrlProvider.select((value) => value.root));
    final rootComments = ref.watch(
      ctrlProvider.select((value) => value.pgnRootComments),
    );

    final shouldShowComments = ref.watch(
      analysisPreferencesProvider.select((value) => value.showPgnComments),
    );

    final shouldShowAnnotations = ref.watch(
      analysisPreferencesProvider.select((value) => value.showAnnotations),
    );

    return CustomScrollView(
      slivers: [
        if (kOpeningAllowedVariants.contains(widget.options.variant))
          SliverPersistentHeader(
            delegate: _OpeningHeaderDelegate(
              ctrlProvider,
              displayMode: widget.displayMode,
            ),
          ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: _PgnTreeView(
            root: root,
            rootComments: rootComments,
            params: (
              shouldShowAnnotations: shouldShowAnnotations,
              shouldShowComments: shouldShowComments,
              currentMoveKey: currentMoveKey,
              currentPath: currentPath,
              notifier: () => ref.read(ctrlProvider.notifier),
            ),
          ),
        ),
      ],
    );
  }
}

/// A group of parameters that are passed through various parts of the tree view
/// and ultimately evaluated in the InlineMove widget. Grouped in this record to improve readability.
typedef _PgnTreeViewParams = ({
  UciPath currentPath,
  bool shouldShowAnnotations,
  bool shouldShowComments,
  GlobalKey currentMoveKey,
  AnalysisController Function() notifier,
});

/// True if the side line has no branching and is less than 6 moves deep.
bool _displaySideLineAsInline(ViewBranch node, [int depth = 0]) {
  if (depth == 6) return false;
  if (node.children.isEmpty) return true;
  if (node.children.length > 1) return false;
  return _displaySideLineAsInline(node.children.first, depth + 1);
}

bool _hasNonInlineSideLine(ViewNode node) =>
    node.children.length > 2 ||
    (node.children.length == 2 && !_displaySideLineAsInline(node.children[1]));

Iterable<List<ViewNode>> _mainlineParts(ViewRoot root) =>
    [root, ...root.mainline].splitAfter(_hasNonInlineSideLine);

class _PgnTreeView extends StatelessWidget {
  const _PgnTreeView({
    required this.root,
    required this.rootComments,
    required this.params,
  });

  final ViewRoot root;

  final IList<PgnComment>? rootComments;

  final _PgnTreeViewParams params;

  @override
  Widget build(BuildContext context) {
    var path = UciPath.empty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // trick to make auto-scroll work when returning to the root position
          if (params.currentPath.isEmpty)
            SizedBox.shrink(key: params.currentMoveKey),

          if (params.shouldShowComments &&
              rootComments?.any((c) => c.text?.isNotEmpty == true) == true)
            Text.rich(
              TextSpan(
                children: _comments(rootComments!, textStyle: _baseTextStyle),
              ),
            ),
          ..._mainlineParts(root).map(
            (nodes) {
              final mainlineInitialPath = path;

              final sidelineInitialPath = UciPath.join(
                path,
                UciPath.fromIds(
                  nodes.take(nodes.length - 1).map((n) => n.children.first.id),
                ),
              );

              path = sidelineInitialPath;
              if (nodes.last.children.isNotEmpty) {
                path = path + nodes.last.children.first.id;
              }

              // Skip the first node which is the continuation of the mainline
              final sidelineNodes = nodes.last.children.skip(1);

              return [
                _MainLinePart(
                  params: params,
                  initialPath: mainlineInitialPath,
                  nodes: nodes,
                ),
                if (sidelineNodes.isNotEmpty)
                  _IndentedSideLines(
                    sidelineNodes,
                    parent: nodes.last,
                    params: params,
                    initialPath: sidelineInitialPath,
                    nesting: 1,
                  ),
              ];
            },
          ).flattened,
        ],
      ),
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
    ...sidelineNodes.mapIndexedAndLast(
      (i, node, last) {
        final pathToNode = path;
        path = path + node.id;

        return [
          if (i == 0) ...[
            if (followsComment) const WidgetSpan(child: SizedBox(width: 4.0)),
            TextSpan(
              text: '(',
              style: textStyle,
            ),
          ],
          ..._moveWithComment(
            node,
            parent: i == 0 ? parent : sidelineNodes[i - 1],
            lineInfo: (
              type: _LineType.inlineSideline,
              startLine: i == 0 || sidelineNodes[i - 1].hasTextComment
            ),
            pathToNode: pathToNode,
            textStyle: textStyle,
            params: params,
          ),
          if (last)
            TextSpan(
              text: ')',
              style: textStyle,
            ),
        ];
      },
    ).flattened,
    const WidgetSpan(child: SizedBox(width: 4.0)),
  ];
}

const _baseTextStyle = TextStyle(
  fontSize: 16.0,
  height: 1.5,
);

/// The different types of lines (move sequences) that are displayed in the tree view.
enum _LineType {
  /// (A part of) the game's main line.
  mainline,

  /// A sideline branching off the main line or a parent sideline.
  /// Each sideline is rendered on a new line and indented.
  sideline,

  /// A short sideline without any branching, displayed in parantheses inline with it's parent line.
  inlineSideline,
}

/// Metadata about a move's role in the tree view.
typedef _LineInfo = ({_LineType type, bool startLine});

List<InlineSpan> _moveWithComment(
  ViewBranch branch, {
  required ViewNode parent,
  required TextStyle textStyle,
  required _LineInfo lineInfo,
  required UciPath pathToNode,
  required _PgnTreeViewParams params,
  GlobalKey? moveKey,
}) {
  return [
    WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: InlineMove(
        branch: branch,
        parent: parent,
        lineInfo: lineInfo,
        path: pathToNode + branch.id,
        key: moveKey,
        textStyle: textStyle,
        params: params,
      ),
    ),
    if (params.shouldShowComments && branch.hasTextComment)
      ..._comments(branch.comments!, textStyle: textStyle),
  ];
}

class _SideLinePart extends ConsumerWidget {
  _SideLinePart(
    this.nodes, {
    required this.parent,
    required this.initialPath,
    required this.firstMoveKey,
    required this.params,
  }) : assert(nodes.isNotEmpty);

  final List<ViewBranch> nodes;

  final ViewNode parent;

  final UciPath initialPath;

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
        parent: parent,
        lineInfo: (
          type: _LineType.sideline,
          startLine: true,
        ),
        moveKey: firstMoveKey,
        pathToNode: initialPath,
        textStyle: textStyle,
        params: params,
      ),
      ...nodes.take(nodes.length - 1).map(
        (node) {
          final moves = [
            ..._moveWithComment(
              node.children.first,
              parent: node,
              lineInfo: (
                type: _LineType.sideline,
                startLine: node.hasTextComment,
              ),
              pathToNode: path,
              textStyle: textStyle,
              params: params,
            ),
            if (node.children.length == 2 &&
                _displaySideLineAsInline(node.children[1]))
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
        },
      ).flattened,
    ];

    return Text.rich(
      TextSpan(
        children: moves,
      ),
    );
  }
}

class _MainLinePart extends ConsumerWidget {
  const _MainLinePart({
    required this.initialPath,
    required this.params,
    required this.nodes,
  });

  final UciPath initialPath;

  final List<ViewNode> nodes;

  final _PgnTreeViewParams params;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = _baseTextStyle.copyWith(
      color: _textColor(context, 0.9),
    );

    var path = initialPath;
    return Text.rich(
      TextSpan(
        children: nodes
            .takeWhile((node) => node.children.isNotEmpty)
            .mapIndexed(
              (i, node) {
                final mainlineNode = node.children.first;
                final moves = [
                  _moveWithComment(
                    mainlineNode,
                    parent: node,
                    lineInfo: (
                      type: _LineType.mainline,
                      startLine: i == 0 || (node as ViewBranch).hasTextComment,
                    ),
                    pathToNode: path,
                    textStyle: textStyle,
                    params: params,
                  ),
                  if (node.children.length == 2 &&
                      _displaySideLineAsInline(node.children[1])) ...[
                    _buildInlineSideLine(
                      followsComment: mainlineNode.hasTextComment,
                      firstNode: node.children[1],
                      parent: node,
                      initialPath: path,
                      textStyle: textStyle,
                      params: params,
                    ),
                  ],
                ];
                path = path + mainlineNode.id;
                return moves.flattened;
              },
            )
            .flattened
            .toList(),
      ),
    );
  }
}

class _SideLines extends StatelessWidget {
  const _SideLines({
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

  @override
  Widget build(BuildContext context) {
    final sidelineNodes = [firstNode];
    while (sidelineNodes.last.children.isNotEmpty &&
        !_hasNonInlineSideLine(sidelineNodes.last)) {
      sidelineNodes.add(sidelineNodes.last.children.first);
    }

    final children = sidelineNodes.last.children;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SideLinePart(
          sidelineNodes.toList(),
          parent: parent,
          firstMoveKey: firstMoveKey,
          initialPath: initialPath,
          params: params,
        ),
        if (children.isNotEmpty)
          _IndentedSideLines(
            children,
            parent: sidelineNodes.last,
            initialPath: UciPath.join(
              initialPath,
              UciPath.fromIds(sidelineNodes.map((node) => node.id)),
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
      final paint = Paint()
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
  late List<GlobalKey> _keys;

  List<Offset> _sideLineStartPositions = [];

  final GlobalKey _columnKey = GlobalKey();

  void _redrawIndents() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox? columnBox =
          _columnKey.currentContext?.findRenderObject() as RenderBox?;
      final Offset rowOffset =
          columnBox?.localToGlobal(Offset.zero) ?? Offset.zero;

      final positions = _keys.map((key) {
        final context = key.currentContext;
        final renderBox = context?.findRenderObject() as RenderBox?;
        final height = renderBox?.size.height ?? 0;
        final offset = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
        return Offset(offset.dx, offset.dy + height / 2) - rowOffset;
      }).toList();

      setState(() {
        _sideLineStartPositions = positions;
      });
    });
  }

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
    final hasHiddenLines = widget.sideLines.any((node) => node.isHidden);

    final visibleSideLines = widget.sideLines.whereNot((node) => node.isHidden);

    _keys = List.generate(
      visibleSideLines.length + (hasHiddenLines ? 1 : 0),
      (_) => GlobalKey(),
    );

    final sideLineWidgets = visibleSideLines
        .mapIndexed(
          (i, firstSidelineNode) => _SideLines(
            firstNode: firstSidelineNode,
            parent: widget.parent,
            firstMoveKey: _keys[i],
            initialPath: widget.initialPath,
            params: widget.params,
            nesting: widget.nesting,
          ),
        )
        .toList();

    final padding = widget.nesting < 6 ? 12.0 : 0.0;
    return RepaintBoundary(
      child: Padding(
        padding: EdgeInsets.only(left: padding),
        child: CustomPaint(
          painter: _IndentPainter(
            sideLineStartPositions: _sideLineStartPositions,
            color: _textColor(context, 0.6)!,
            padding: padding,
          ),
          child: Column(
            key: _columnKey,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...sideLineWidgets,
              if (hasHiddenLines)
                GestureDetector(
                  child: Icon(
                    Icons.add_box,
                    color: _textColor(context, 0.6),
                    key: _keys.last,
                    size: _baseTextStyle.fontSize! + 5,
                  ),
                  onTap: () {
                    widget.params
                        .notifier()
                        .expandVariations(widget.initialPath);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

Color? _textColor(
  BuildContext context,
  double opacity, {
  int? nag,
}) {
  final defaultColor = Theme.of(context).platform == TargetPlatform.android
      ? Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: opacity)
      : CupertinoTheme.of(context)
          .textTheme
          .textStyle
          .color
          ?.withValues(alpha: opacity);

  return nag != null && nag > 0 ? nagColor(nag) : defaultColor;
}

class InlineMove extends ConsumerWidget {
  const InlineMove({
    required this.branch,
    required this.parent,
    required this.path,
    required this.textStyle,
    required this.lineInfo,
    super.key,
    required this.params,
  });

  final ViewNode parent;
  final ViewBranch branch;
  final UciPath path;

  final TextStyle textStyle;

  final _LineInfo lineInfo;

  final _PgnTreeViewParams params;

  static const borderRadius = BorderRadius.all(Radius.circular(4.0));

  bool get isCurrentMove => params.currentPath == path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pieceNotation = ref.watch(pieceNotationProvider).maybeWhen(
          data: (value) => value,
          orElse: () => defaultAccountPreferences.pieceNotation,
        );
    final moveFontFamily =
        pieceNotation == PieceNotation.symbol ? 'ChessFont' : null;

    final moveTextStyle = textStyle.copyWith(
      fontFamily: moveFontFamily,
      fontWeight: isCurrentMove
          ? FontWeight.bold
          : lineInfo.type == _LineType.inlineSideline
              ? FontWeight.normal
              : FontWeight.w600,
    );

    final indexTextStyle = textStyle.copyWith(
      color: _textColor(context, 0.6),
    );

    final indexText = branch.position.ply.isOdd
        ? TextSpan(
            text: '${(branch.position.ply / 2).ceil()}.',
            style: indexTextStyle,
          )
        : (lineInfo.startLine
            ? TextSpan(
                text: '${(branch.position.ply / 2).ceil()}…',
                style: indexTextStyle,
              )
            : null);

    final moveWithNag = branch.sanMove.san +
        (branch.nags != null && params.shouldShowAnnotations
            ? moveAnnotationChar(branch.nags!)
            : '');

    final nag = params.shouldShowAnnotations ? branch.nags?.firstOrNull : null;

    final ply = branch.position.ply;
    return AdaptiveInkWell(
      key: isCurrentMove ? params.currentMoveKey : null,
      borderRadius: borderRadius,
      onTap: () => params.notifier().userJump(path),
      onLongPress: () {
        showAdaptiveBottomSheet<void>(
          context: context,
          isDismissible: true,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (context) => _MoveContextMenu(
            notifier: params.notifier,
            title: ply.isOdd
                ? '${(ply / 2).ceil()}. $moveWithNag'
                : '${(ply / 2).ceil()}... $moveWithNag',
            path: path,
            parent: parent,
            branch: branch,
            isSideline: lineInfo.type != _LineType.mainline,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
        decoration: isCurrentMove
            ? BoxDecoration(
                color: Theme.of(context).platform == TargetPlatform.iOS
                    ? CupertinoColors.systemGrey3.resolveFrom(context)
                    : Theme.of(context).focusColor,
                shape: BoxShape.rectangle,
                borderRadius: borderRadius,
              )
            : null,
        child: Text.rich(
          TextSpan(
            children: [
              if (indexText != null) ...[
                indexText,
                const WidgetSpan(child: SizedBox(width: 3)),
              ],
              TextSpan(
                text: moveWithNag,
                style: moveTextStyle.copyWith(
                  color: _textColor(
                    context,
                    isCurrentMove ? 1 : 0.9,
                    nag: nag,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoveContextMenu extends ConsumerWidget {
  const _MoveContextMenu({
    required this.title,
    required this.path,
    required this.parent,
    required this.branch,
    required this.isSideline,
    required this.notifier,
  });

  final String title;
  final UciPath path;
  final ViewNode parent;
  final ViewBranch branch;
  final bool isSideline;
  final AnalysisController Function() notifier;

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
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (branch.clock != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.punch_clock,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          branch.clock!.toHoursMinutesSeconds(
                            showTenths:
                                branch.clock! < const Duration(minutes: 1),
                          ),
                        ),
                      ],
                    ),
                    if (branch.elapsedMoveTime != null) ...[
                      const SizedBox(height: 4.0),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.hourglass_bottom,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            branch.elapsedMoveTime!
                                .toHoursMinutesSeconds(showTenths: true),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
            ],
          ),
        ),
        if (branch.hasLichessAnalysisTextComment)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Text(
              branch.lichessAnalysisComments!
                  .map((c) => c.text ?? '')
                  .join(' '),
            ),
          ),
        if (branch.hasTextComment)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Text(
              branch.comments!.map((c) => c.text ?? '').join(' '),
            ),
          ),
        const PlatformDivider(indent: 0),
        if (isSideline) ...[
          BottomSheetContextMenuAction(
            icon: Icons.subtitles_off,
            child: Text(context.l10n.collapseVariations),
            onPressed: () => notifier().collapseVariations(path),
          ),
          BottomSheetContextMenuAction(
            icon: Icons.expand_less,
            child: Text(context.l10n.promoteVariation),
            onPressed: () => notifier().promoteVariation(path, false),
          ),
          BottomSheetContextMenuAction(
            icon: Icons.check,
            child: Text(context.l10n.makeMainLine),
            onPressed: () => notifier().promoteVariation(path, true),
          ),
        ],
        BottomSheetContextMenuAction(
          icon: Icons.delete,
          child: Text(context.l10n.deleteFromHere),
          onPressed: () => notifier().deleteFromHere(path),
        ),
      ],
    );
  }
}

List<TextSpan> _comments(
  IList<PgnComment> comments, {
  required TextStyle textStyle,
}) =>
    comments
        .map(
          (comment) => TextSpan(
            text: comment.text,
            style: textStyle.copyWith(
              fontSize: textStyle.fontSize! - 2.0,
              fontStyle: FontStyle.italic,
            ),
          ),
        )
        .toList();

class _OpeningHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _OpeningHeaderDelegate(
    this.ctrlProvider, {
    required this.displayMode,
  });

  final AnalysisControllerProvider ctrlProvider;
  final Orientation displayMode;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return _Opening(ctrlProvider, displayMode);
  }

  @override
  double get minExtent => kOpeningHeaderHeight;

  @override
  double get maxExtent => kOpeningHeaderHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

class _Opening extends ConsumerWidget {
  const _Opening(this.ctrlProvider, this.displayMode);

  final AnalysisControllerProvider ctrlProvider;
  final Orientation displayMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRootNode = ref.watch(
      ctrlProvider.select((s) => s.currentNode.isRoot),
    );
    final nodeOpening =
        ref.watch(ctrlProvider.select((s) => s.currentNode.opening));
    final branchOpening =
        ref.watch(ctrlProvider.select((s) => s.currentBranchOpening));
    final contextOpening =
        ref.watch(ctrlProvider.select((s) => s.contextOpening));
    final opening = isRootNode
        ? LightOpening(
            eco: '',
            name: context.l10n.startPosition,
          )
        : nodeOpening ?? branchOpening ?? contextOpening;

    return opening != null
        ? Container(
            height: kOpeningHeaderHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Center(
                child: Text(
                  opening.name,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
