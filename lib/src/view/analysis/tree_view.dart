import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    this.options,
    this.displayMode,
  );

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
      analysisControllerProvider(widget.options).select(
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
      analysisControllerProvider(widget.options),
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

    final ctrlProvider = analysisControllerProvider(widget.options);
    final root = ref.watch(ctrlProvider.select((value) => value.root));
    final rootComments = ref.watch(
      ctrlProvider.select((value) => value.pgnRootComments),
    );

    final shouldShowComments = ref.watch(
      analysisPreferencesProvider.select((value) => value.showPgnComments),
    );

    final List<Widget> moveWidgets = _buildTreeWidget(
      widget.options,
      parent: root,
      nodes: root.children,
      shouldShowComments: shouldShowComments,
      inMainline: true,
      startSideline: false,
      initialPath: UciPath.empty,
    );

    // trick to make auto-scroll work when returning to the root position
    moveWidgets.insert(
      0,
      currentPath.isEmpty
          ? SizedBox.shrink(key: currentMoveKey)
          : const SizedBox.shrink(),
    );

    if (shouldShowComments &&
        rootComments?.any((c) => c.text?.isNotEmpty == true) == true) {
      moveWidgets.insert(
        0,
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: _Comments(rootComments!),
        ),
      );
    }

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
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Wrap(
              spacing: kInlineMoveSpacing,
              children: moveWidgets,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildTreeWidget(
    AnalysisOptions options, {
    required ViewNode parent,
    required IList<ViewBranch> nodes,
    required bool inMainline,
    required bool startSideline,
    required bool shouldShowComments,
    required UciPath initialPath,
  }) {
    if (nodes.isEmpty) return [];
    final List<Widget> widgets = [];

    final firstChild = nodes.first;
    final newPath = initialPath + firstChild.id;
    final currentMove = newPath == currentPath;

    // add the first child
    widgets.add(
      InlineMove(
        options,
        path: newPath,
        parent: parent,
        branch: firstChild,
        isCurrentMove: currentMove,
        key: currentMove ? currentMoveKey : null,
        shouldShowComments: shouldShowComments,
        isSideline: !inMainline,
        startSideline: startSideline,
        endSideline: !inMainline && firstChild.children.isEmpty,
      ),
    );

    // add the sidelines if present
    for (var i = 1; i < nodes.length; i++) {
      final node = nodes[i];
      if (node.isHidden) continue;
      // start new sideline from mainline on a new line
      if (inMainline) {
        widgets.add(
          SizedBox(
            width: double.infinity,
            child: Wrap(
              spacing: kInlineMoveSpacing,
              children: _buildTreeWidget(
                options,
                parent: parent,
                nodes: [nodes[i]].lockUnsafe,
                shouldShowComments: shouldShowComments,
                inMainline: false,
                startSideline: true,
                initialPath: initialPath,
              ),
            ),
          ),
        );
      } else {
        widgets.addAll(
          _buildTreeWidget(
            options,
            parent: parent,
            nodes: [nodes[i]].lockUnsafe,
            shouldShowComments: shouldShowComments,
            inMainline: false,
            startSideline: true,
            initialPath: initialPath,
          ),
        );
      }
    }

    // add the children of the first child
    widgets.addAll(
      _buildTreeWidget(
        options,
        parent: firstChild,
        nodes: firstChild.children,
        shouldShowComments: shouldShowComments,
        inMainline: inMainline,
        startSideline: false,
        initialPath: newPath,
      ),
    );

    return widgets;
  }
}

Color? _textColor(BuildContext context, double opacity, [int? nag]) {
  final defaultColor = defaultTargetPlatform == TargetPlatform.android
      ? Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(opacity)
      : CupertinoTheme.of(context)
          .textTheme
          .textStyle
          .color
          ?.withOpacity(opacity);

  return nag != null && nag > 0 ? nagColorMap[nag] : defaultColor;
}

class InlineMove extends ConsumerWidget {
  const InlineMove(
    this.options, {
    required this.path,
    required this.parent,
    required this.branch,
    required this.shouldShowComments,
    required this.isCurrentMove,
    required this.isSideline,
    super.key,
    this.startSideline = false,
    this.endSideline = false,
  });

  final AnalysisOptions options;
  final UciPath path;
  final ViewNode parent;
  final ViewBranch branch;
  final bool shouldShowComments;
  final bool isCurrentMove;
  final bool isSideline;
  final bool startSideline;
  final bool endSideline;

  static const borderRadius = BorderRadius.all(Radius.circular(4.0));
  static const baseTextStyle = TextStyle(
    fontFamily: 'ChessFont',
    height: 1.5,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisControllerProvider(options);
    final move = branch.sanMove;
    final ply = branch.position.ply;
    final textStyle = isSideline
        ? TextStyle(
            fontFamily: 'ChessFont',
            color: _textColor(context, 0.6, branch.nags?.firstOrNull),
          )
        : baseTextStyle.copyWith(
            color: _textColor(context, 0.9, branch.nags?.firstOrNull),
            fontWeight: FontWeight.w600,
          );

    final indexTextStyle = baseTextStyle.copyWith(
      color: _textColor(context, 0.6),
    );

    final indexWidget = ply.isOdd
        ? Text(
            '${(ply / 2).ceil()}.',
            style: indexTextStyle,
          )
        : (startSideline
            ? Text(
                '${(ply / 2).ceil()}...',
                style: indexTextStyle,
              )
            : null);

    final moveWithNag =
        move.san + (branch.nags != null ? _displayNags(branch.nags!) : '');

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (startSideline)
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: Text('(', style: textStyle),
          ),
        if (shouldShowComments && branch.hasStartingTextComment)
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child:
                  _Comments(branch.startingComments!, isSideline: isSideline),
            ),
          ),
        if (indexWidget != null) indexWidget,
        if (indexWidget != null) const SizedBox(width: 1),
        AdaptiveInkWell(
          borderRadius: borderRadius,
          onTap: () => ref.read(ctrlProvider.notifier).userJump(path),
          onLongPress: () {
            showAdaptiveBottomSheet<void>(
              context: context,
              isDismissible: true,
              isScrollControlled: true,
              showDragHandle: true,
              builder: (context) => _MoveContextMenu(
                options,
                title: ply.isOdd
                    ? '${(ply / 2).ceil()}. $moveWithNag'
                    : '${(ply / 2).ceil()}... $moveWithNag',
                path: path,
                parent: parent,
                branch: branch,
                isSideline: isSideline,
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
            decoration: isCurrentMove
                ? BoxDecoration(
                    color: Theme.of(context).platform == TargetPlatform.iOS
                        ? CupertinoColors.systemGrey3.resolveFrom(context)
                        : Theme.of(context).focusColor,
                    shape: BoxShape.rectangle,
                    borderRadius: borderRadius,
                  )
                : null,
            child: Text(
              moveWithNag,
              style: isCurrentMove
                  ? textStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _textColor(context, 1, branch.nags?.firstOrNull),
                    )
                  : textStyle,
            ),
          ),
        ),
        if (shouldShowComments && branch.hasTextComment)
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: _Comments(branch.comments!, isSideline: isSideline),
            ),
          ),
        if (endSideline) Text(')', style: textStyle),
      ],
    );
  }
}

class _MoveContextMenu extends ConsumerWidget {
  const _MoveContextMenu(
    this.options, {
    required this.title,
    required this.path,
    required this.parent,
    required this.branch,
    required this.isSideline,
  });

  final String title;
  final AnalysisOptions options;
  final UciPath path;
  final ViewNode parent;
  final ViewBranch branch;
  final bool isSideline;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisControllerProvider(options);

    return DraggableScrollableSheet(
      initialChildSize: .4,
      expand: false,
      snap: true,
      snapSizes: const [.4, .7],
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                                branch.clock!.toHoursMinutesSeconds(),
                              ),
                            ],
                          ),
                          if (branch.moveTime != null) ...[
                            const SizedBox(height: 4.0),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.hourglass_bottom,
                                ),
                                const SizedBox(width: 4.0),
                                Text(
                                  branch.moveTime!.toMinutesSeconds(),
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
              if (parent.children.any((c) => c.isHidden))
                BottomSheetContextMenuAction(
                  icon: Icons.subtitles,
                  child: const Text('Show variations'),
                  onPressed: () {
                    ref.read(ctrlProvider.notifier).showAllVariations(path);
                  },
                ),
              if (isSideline)
                BottomSheetContextMenuAction(
                  icon: Icons.subtitles_off,
                  child: const Text('Hide variation'),
                  onPressed: () {
                    ref.read(ctrlProvider.notifier).hideVariation(path);
                  },
                ),
              if (isSideline)
                BottomSheetContextMenuAction(
                  icon: Icons.expand_less,
                  child: Text(context.l10n.promoteVariation),
                  onPressed: () {
                    ref
                        .read(ctrlProvider.notifier)
                        .promoteVariation(path, false);
                  },
                ),
              if (isSideline)
                BottomSheetContextMenuAction(
                  icon: Icons.check,
                  child: Text(context.l10n.makeMainLine),
                  onPressed: () {
                    ref
                        .read(ctrlProvider.notifier)
                        .promoteVariation(path, true);
                  },
                ),
              BottomSheetContextMenuAction(
                icon: Icons.delete,
                child: Text(context.l10n.deleteFromHere),
                onPressed: () {
                  ref.read(ctrlProvider.notifier).deleteFromHere(path);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _displayNags(Iterable<int> nags) {
  return nags
      .map(
        (nag) => switch (nag) {
          1 => '!',
          2 => '?',
          3 => '‼',
          4 => '⁇',
          5 => '⁉',
          6 => '⁈',
          int() => '',
        },
      )
      .join('');
}

class _Comments extends StatelessWidget {
  _Comments(this.comments, {this.isSideline = false})
      : assert(comments.any((c) => c.text?.isNotEmpty == true));

  final Iterable<PgnComment> comments;
  final bool isSideline;

  @override
  Widget build(BuildContext context) {
    return AdaptiveInkWell(
      onTap: () {
        showAdaptiveBottomSheet<void>(
          context: context,
          isDismissible: true,
          isScrollControlled: true,
          builder: (context) => DraggableScrollableSheet(
            initialChildSize: 0.3,
            expand: false,
            snap: true,
            snapSizes: const [.3, .7],
            builder: (context, scrollController) => SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: comments.map(
                    (comment) {
                      if (comment.text == null || comment.text!.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(comment.text!.replaceAll('\n', ' ')),
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
          ),
        );
      },
      child: Text(
        comments.map((c) => c.text ?? '').join(' ').replaceAll('\n', ' '),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontStyle: FontStyle.italic,
          color:
              isSideline ? _textColor(context, 0.6) : _textColor(context, 0.7),
        ),
      ),
    );
  }
}

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
              color: defaultTargetPlatform == TargetPlatform.iOS
                  ? CupertinoDynamicColor.resolve(
                      CupertinoColors.systemGrey5,
                      context,
                    )
                  : Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: displayMode == Orientation.landscape
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    )
                  : null,
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
