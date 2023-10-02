import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/utils/rate_limit.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';

const kChessNotationFontSize = 13.0;
const kFastReplayDebounceDelay = Duration(milliseconds: 100);
const kOpeningHeaderHeight = 32.0;
const kInlineMoveSpacing = 5.0;

class AnalysisTreeView extends ConsumerWidget {
  const AnalysisTreeView(this.ctrlProvider, this.displayMode);

  final AnalysisControllerProvider ctrlProvider;
  final Orientation displayMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final root = ref.watch(ctrlProvider.select((value) => value.root));
    final currentPath =
        ref.watch(ctrlProvider.select((value) => value.currentPath));

    return _InlineTreeView(
      ctrlProvider,
      root,
      currentPath,
      displayMode,
    );
  }
}

class _InlineTreeView extends ConsumerStatefulWidget {
  const _InlineTreeView(
    this.ctrlProvider,
    this.root,
    this.currentPath,
    this.displayMode,
  );

  final AnalysisControllerProvider ctrlProvider;
  final ViewRoot root;
  final UciPath currentPath;
  final Orientation displayMode;

  @override
  ConsumerState<_InlineTreeView> createState() => _InlineTreeViewState();
}

class _InlineTreeViewState extends ConsumerState<_InlineTreeView> {
  final currentMoveKey = GlobalKey();
  final _debounce = Debouncer(kFastReplayDebounceDelay);

  @override
  void initState() {
    super.initState();
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

  @override
  void didUpdateWidget(covariant _InlineTreeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _debounce(() {
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

  @override
  Widget build(BuildContext context) {
    final content = CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          delegate: _OpeningHeaderDelegate(
            widget.ctrlProvider,
            displayMode: widget.displayMode,
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Wrap(
              spacing: kInlineMoveSpacing,
              children: _buildTreeWidget(
                widget.ctrlProvider,
                nodes: widget.root.children,
                inMainline: true,
                startSideline: false,
                initialPath: UciPath.empty,
                currentPath: widget.currentPath,
              ),
            ),
          ),
        ),
      ],
    );

    return switch (widget.displayMode) {
      Orientation.landscape => content,
      Orientation.portrait => Expanded(child: content)
    };
  }

  List<Widget> _buildTreeWidget(
    AnalysisControllerProvider ctrlProvider, {
    required IList<ViewBranch> nodes,
    required bool inMainline,
    required bool startSideline,
    required UciPath initialPath,
    required UciPath currentPath,
  }) {
    if (nodes.isEmpty) return [];
    final List<Widget> widgets = [];

    // add the node[0]
    final newPath = initialPath + nodes[0].id;
    final currentMove = newPath == currentPath;
    widgets.add(
      InlineMove(
        ctrlProvider,
        path: newPath,
        move: nodes[0].sanMove,
        ply: nodes[0].ply,
        isCurrentMove: currentMove,
        key: currentMove ? currentMoveKey : null,
        isSideline: !inMainline,
        startSideline: startSideline,
        endSideline: !inMainline && nodes[0].children.isEmpty,
      ),
    );

    // add the sidelines if present
    for (var i = 1; i < nodes.length; i++) {
      // start new sideline from mainline on a new line
      if (inMainline) {
        widgets.add(
          SizedBox(
            width: double.infinity,
            child: Wrap(
              spacing: kInlineMoveSpacing,
              children: _buildTreeWidget(
                ctrlProvider,
                nodes: IList([nodes[i]]),
                inMainline: false,
                startSideline: true,
                initialPath: initialPath,
                currentPath: currentPath,
              ),
            ),
          ),
        );
      } else {
        widgets.addAll(
          _buildTreeWidget(
            ctrlProvider,
            nodes: IList([nodes[i]]),
            inMainline: false,
            startSideline: true,
            initialPath: initialPath,
            currentPath: currentPath,
          ),
        );
      }
    }

    // add the children of the first child
    widgets.addAll(
      _buildTreeWidget(
        ctrlProvider,
        nodes: nodes[0].children,
        inMainline: inMainline,
        startSideline: false,
        initialPath: newPath,
        currentPath: currentPath,
      ),
    );

    return widgets;
  }
}

class InlineMove extends ConsumerWidget {
  const InlineMove(
    this.ctrlProvider, {
    required this.path,
    required this.move,
    required this.ply,
    required this.isCurrentMove,
    required this.isSideline,
    super.key,
    this.startSideline = false,
    this.endSideline = false,
  });

  final AnalysisControllerProvider ctrlProvider;
  final UciPath path;
  final SanMove move;
  final int ply;
  final bool isCurrentMove;
  final bool isSideline;
  final bool startSideline;
  final bool endSideline;

  static const borderRadius = BorderRadius.all(Radius.circular(4.0));
  static const baseTextStyle = TextStyle(
    fontFamily: 'ChessFont',
    fontSize: kChessNotationFontSize,
    height: 1.5,
  );

  Color? _textColor(BuildContext context, double opacity) {
    return defaultTargetPlatform == TargetPlatform.android
        ? Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(opacity)
        : CupertinoTheme.of(context)
            .textTheme
            .textStyle
            .color
            ?.withOpacity(opacity);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = isSideline
        ? TextStyle(
            fontFamily: 'ChessFont',
            fontSize: kChessNotationFontSize,
            color: _textColor(context, 0.6),
          )
        : baseTextStyle;

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

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (startSideline) Text('(', style: textStyle),
        if (indexWidget != null) indexWidget,
        if (indexWidget != null) const SizedBox(width: 1),
        AdaptiveInkWell(
          borderRadius: borderRadius,
          onTap: () => ref.read(ctrlProvider.notifier).userJump(path),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 2),
            decoration: isCurrentMove
                ? BoxDecoration(
                    color: Theme.of(context).focusColor,
                    shape: BoxShape.rectangle,
                    borderRadius: borderRadius,
                  )
                : null,
            child: Text(
              move.san,
              style: isCurrentMove
                  ? textStyle.copyWith(
                      color: _textColor(context, 1),
                      fontWeight: FontWeight.w600,
                    )
                  : textStyle,
            ),
          ),
        ),
        if (endSideline) Text(')', style: textStyle),
      ],
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
    final nodeOpening =
        ref.watch(ctrlProvider.select((s) => s.currentNode.opening));
    final branchOpening =
        ref.watch(ctrlProvider.select((s) => s.currentBranchOpening));
    final contextOpening =
        ref.watch(ctrlProvider.select((s) => s.contextOpening));
    final opening = nodeOpening ?? branchOpening ?? contextOpening;

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
                  style: const TextStyle(fontSize: kChessNotationFontSize),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
