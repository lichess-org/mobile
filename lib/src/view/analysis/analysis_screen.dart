import 'dart:ui';
import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:chessground/chessground.dart' as cg;
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:popover/popover.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/engine_evaluation.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_ctrl.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/model/settings/brightness.dart';
import 'package:lichess_mobile/src/model/settings/analysis_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/immersive_mode.dart';
import 'package:lichess_mobile/src/utils/rate_limit.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/non_linear_slider.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

const kChessNotationFontSize = 13.0;
const kFastReplayDebounceDelay = Duration(milliseconds: 100);

class AnalysisScreen extends ConsumerWidget {
  const AnalysisScreen({
    required this.variant,
    required this.steps,
    required this.orientation,
    required this.id,
    this.title,
  });

  final Variant variant;
  final IList<GameStep> steps;
  final Side orientation;
  final ID id;
  final String? title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConsumerPlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
      ref: ref,
    );
  }

  Widget _androidBuilder(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisCtrlProvider(variant, steps, orientation, id);

    final evalContext = ref.watch(
      ctrlProvider.select((value) => value.evaluationContext),
    );
    final currentNode = ref.watch(
      ctrlProvider.select((value) => value.currentNode),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? context.l10n.analysis),
        actions: [
          _EngineDepth(evalContext, currentNode),
          SettingsButton(
            onPressed: () => showAdaptiveBottomSheet<void>(
              context: context,
              showDragHandle: true,
              builder: (_) => _Preferences(ctrlProvider),
            ),
          ),
        ],
      ),
      body: _Body(ctrlProvider: ctrlProvider),
    );
  }

  Widget _iosBuilder(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisCtrlProvider(variant, steps, orientation, id);
    final evalContext = ref.watch(
      ctrlProvider.select((value) => value.evaluationContext),
    );
    final currentNode = ref.watch(
      ctrlProvider.select((value) => value.currentNode),
    );

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(title ?? context.l10n.analysis),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _EngineDepth(evalContext, currentNode),
            SettingsButton(
              onPressed: () => showAdaptiveBottomSheet<void>(
                context: context,
                showDragHandle: true,
                builder: (_) => _Preferences(ctrlProvider),
              ),
            ),
          ],
        ),
      ),
      child: _Body(ctrlProvider: ctrlProvider),
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body({
    required this.ctrlProvider,
  });

  final AnalysisCtrlProvider ctrlProvider;

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> with AndroidImmersiveMode {
  @override
  Widget build(BuildContext context) {
    final showEvaluationGauge = ref.watch(
      analysisPreferencesProvider.select((value) => value.showEvaluationGauge),
    );

    return Column(
      children: [
        Expanded(
          child: SafeArea(
            bottom: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final aspectRatio = constraints.biggest.aspectRatio;
                final defaultBoardSize = constraints.biggest.shortestSide;
                final isTablet = defaultBoardSize > kTabletThreshold;
                final isSmallScreen =
                    constraints.maxHeight < kSmallHeightScreenThreshold;
                final boardSize = isTablet || isSmallScreen
                    ? defaultBoardSize - 16.0 * 2
                    : defaultBoardSize;

                return aspectRatio > 1
                    ? Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: kTabletBoardTableSidePadding,
                              top: kTabletBoardTableSidePadding,
                              bottom: kTabletBoardTableSidePadding,
                            ),
                            child: Row(
                              children: [
                                _Board(widget.ctrlProvider, boardSize),
                                if (showEvaluationGauge)
                                  _EngineGaugeVertical(widget.ctrlProvider),
                              ],
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                _EngineLines(
                                  widget.ctrlProvider,
                                  isTablet: true,
                                ),
                                Expanded(
                                  child: PlatformCard(
                                    margin: const EdgeInsets.all(16.0),
                                    semanticContainer: false,
                                    child: _Moves(
                                      widget.ctrlProvider,
                                      _MovesDisplayMode.tablet,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        // don't use stretch here because board background size would be wrong
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _ColumnTopTable(widget.ctrlProvider),
                          _Board(widget.ctrlProvider, boardSize),
                          _Moves(widget.ctrlProvider, _MovesDisplayMode.normal),
                        ],
                      );
              },
            ),
          ),
        ),
        _BottomBar(ctrlProvider: widget.ctrlProvider),
      ],
    );
  }
}

class _Board extends ConsumerWidget {
  const _Board(this.ctrlProvider, this.boardSize);

  final AnalysisCtrlProvider ctrlProvider;
  final double boardSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisState = ref.watch(ctrlProvider);
    final boardPrefs = ref.watch(boardPreferencesProvider);
    final showBestMoveArrow = ref.watch(
      analysisPreferencesProvider.select(
        (value) => value.showBestMoveArrow,
      ),
    );

    final evalBestMoves = ref.watch(
      engineEvaluationProvider(analysisState.evaluationContext)
          .select((e) => e?.bestMoves),
    );

    final bestMoves =
        evalBestMoves ?? analysisState.currentNode.eval?.bestMoves;

    return cg.Board(
      size: boardSize,
      data: cg.BoardData(
        orientation: analysisState.pov.cg,
        interactableSide: analysisState.position.isGameOver
            ? cg.InteractableSide.none
            : analysisState.position.turn == Side.white
                ? cg.InteractableSide.white
                : cg.InteractableSide.black,
        fen: analysisState.fen,
        isCheck: analysisState.position.isCheck,
        lastMove: analysisState.lastMove?.cg,
        sideToMove: analysisState.position.turn.cg,
        validMoves: analysisState.validMoves,
        onMove: (move, {isDrop, isPremove}) =>
            ref.read(ctrlProvider.notifier).onUserMove(Move.fromUci(move.uci)!),
        shapes: showBestMoveArrow &&
                analysisState.isEngineAvailable &&
                bestMoves != null
            ? ISet(
                bestMoves.where((move) => move != null).mapIndexed(
                      (i, move) => cg.Arrow(
                        color:
                            const Color(0x40003088).withOpacity(0.4 - 0.15 * i),
                        orig: move!.cg.from,
                        dest: move.cg.to,
                      ),
                    ),
              )
            : null,
      ),
      settings: cg.BoardSettings(
        pieceAssets: boardPrefs.pieceSet.assets,
        colorScheme: boardPrefs.boardTheme.colors,
        showValidMoves: boardPrefs.showLegalMoves,
        showLastMove: boardPrefs.boardHighlights,
        enableCoordinates: boardPrefs.coordinates,
        animationDuration: boardPrefs.pieceAnimationDuration,
      ),
    );
  }
}

class _EngineGaugeVertical extends ConsumerWidget {
  const _EngineGaugeVertical(this.ctrlProvider);

  final AnalysisCtrlProvider ctrlProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisState = ref.watch(ctrlProvider);

    return analysisState.isEngineAvailable
        ? EngineGauge(
            displayMode: EngineGaugeDisplayMode.vertical,
            params: EngineGaugeParams(
              evaluationContext: analysisState.evaluationContext,
              position: analysisState.position,
              savedEval: analysisState.currentNode.eval,
            ),
          )
        : kEmptyWidget;
  }
}

class _ColumnTopTable extends ConsumerWidget {
  const _ColumnTopTable(this.ctrlProvider);

  final AnalysisCtrlProvider ctrlProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisState = ref.watch(ctrlProvider);
    final showEvaluationGauge = ref.watch(
      analysisPreferencesProvider.select((p) => p.showEvaluationGauge),
    );

    return analysisState.isEngineAvailable
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showEvaluationGauge)
                EngineGauge(
                  displayMode: EngineGaugeDisplayMode.horizontal,
                  params: EngineGaugeParams(
                    evaluationContext: analysisState.evaluationContext,
                    position: analysisState.position,
                    savedEval: analysisState.currentNode.eval,
                  ),
                ),
              _EngineLines(ctrlProvider, isTablet: false),
            ],
          )
        : kEmptyWidget;
  }
}

class _EngineLines extends ConsumerWidget {
  const _EngineLines(this.ctrlProvider, {required this.isTablet});
  final AnalysisCtrlProvider ctrlProvider;
  final bool isTablet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisState = ref.watch(ctrlProvider);
    final numEvalLines = ref.watch(
      analysisPreferencesProvider.select(
        (p) => p.numEvalLines,
      ),
    );
    final eval =
        ref.watch(engineEvaluationProvider(analysisState.evaluationContext)) ??
            analysisState.currentNode.eval;

    final emptyLines = List.filled(
      numEvalLines,
      _Engineline.empty(ctrlProvider),
    );

    final content = !analysisState.position.isGameOver
        ? (eval != null
            ? eval.pvs
                .take(numEvalLines)
                .map(
                  (pv) => _Engineline(
                    ctrlProvider,
                    pv.sanMoves(eval.position),
                    analysisState.currentNode.ply,
                    pv,
                  ),
                )
                .toList()
            : emptyLines)
        : emptyLines;

    if (content.length < numEvalLines) {
      final padding = List.filled(
        numEvalLines - content.length,
        _Engineline.empty(ctrlProvider),
      );
      content.addAll(padding);
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: isTablet ? 16.0 : 0.0,
        horizontal: isTablet ? 16.0 : 0.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: content,
      ),
    );
  }
}

class _Engineline extends ConsumerWidget {
  const _Engineline(
    this.ctrlProvider,
    this.moves,
    this.initialPly,
    this.pvData,
  );

  const _Engineline.empty(this.ctrlProvider)
      : moves = const [],
        pvData = const PvData(moves: IListConst([])),
        initialPly = 0;

  final AnalysisCtrlProvider ctrlProvider;
  final List<String> moves;
  final int initialPly;
  final PvData pvData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (moves.isEmpty) {
      return const SizedBox(
        height: kEvalGaugeSize,
        child: SizedBox.shrink(),
      );
    }

    final builder = StringBuffer();
    var ply = initialPly + 1;
    moves.forEachIndexed((i, s) {
      builder.write(
        ply.isOdd
            ? '${(ply / 2).ceil()}. $s '
            : i == 0
                ? '${(ply / 2).ceil()}... $s '
                : '$s ',
      );
      ply += 1;
    });

    final brightness = ref.watch(currentBrightnessProvider);

    final evalString = pvData.evalString;
    return AdaptiveInkWell(
      onTap: () => ref
          .read(ctrlProvider.notifier)
          .onUserMove(Move.fromUci(pvData.moves[0])!),
      child: SizedBox(
        height: kEvalGaugeSize,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: pvData.winningSide == Side.black
                      ? kEvalGaugeBackgroundColor
                      : brightness == Brightness.light
                          ? kEvalGaugeValueColorLightBg
                          : kEvalGaugeValueColorDarkBg,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                  vertical: 2.0,
                ),
                child: Text(
                  evalString,
                  style: TextStyle(
                    color: pvData.winningSide == Side.black
                        ? Colors.white
                        : Colors.black,
                    fontSize: kEvalGaugeFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  builder.toString(),
                  maxLines: 1,
                  softWrap: false,
                  style: const TextStyle(
                    fontFamily: 'ChessFont',
                    fontSize: kChessNotationFontSize,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _MovesDisplayMode {
  tablet,
  normal,
}

class _Moves extends ConsumerWidget {
  const _Moves(this.ctrlProvider, this.displayMode);

  final AnalysisCtrlProvider ctrlProvider;
  final _MovesDisplayMode displayMode;

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

const kInlineMoveSpacing = 5.0;

class _InlineTreeView extends ConsumerStatefulWidget {
  const _InlineTreeView(
    this.ctrlProvider,
    this.root,
    this.currentPath,
    this.displayMode,
  );

  final AnalysisCtrlProvider ctrlProvider;
  final ViewRoot root;
  final UciPath currentPath;
  final _MovesDisplayMode displayMode;

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
    final content = SingleChildScrollView(
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
    );

    return switch (widget.displayMode) {
      _MovesDisplayMode.tablet => content,
      _MovesDisplayMode.normal => Expanded(child: content)
    };
  }

  List<Widget> _buildTreeWidget(
    AnalysisCtrlProvider ctrlProvider, {
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

  final AnalysisCtrlProvider ctrlProvider;
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
            fontStyle: FontStyle.italic,
            color: _textColor(context, 0.7),
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

class _BottomBar extends ConsumerWidget {
  const _BottomBar({
    required this.ctrlProvider,
  });

  final AnalysisCtrlProvider ctrlProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisState = ref.watch(ctrlProvider);

    return Container(
      padding: Styles.horizontalBodyPadding,
      color: defaultTargetPlatform == TargetPlatform.iOS
          ? CupertinoTheme.of(context).barBackgroundColor
          : Theme.of(context).bottomAppBarTheme.color,
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BottomBarIconButton(
              semanticsLabel: context.l10n.menu,
              onPressed: () {
                _showGameMenu(context, ref);
              },
              icon: const Icon(Icons.menu),
            ),
            const Spacer(),
            RepeatButton(
              onLongPress:
                  analysisState.canGoBack ? () => _moveBackward(ref) : null,
              child: BottomBarButton(
                key: const ValueKey('goto-previous'),
                onTap:
                    analysisState.canGoBack ? () => _moveBackward(ref) : null,
                label: 'Previous',
                shortLabel: 'Previous',
                icon: CupertinoIcons.chevron_back,
                showAndroidTooltip: false,
              ),
            ),
            const SizedBox(width: 40),
            RepeatButton(
              onLongPress:
                  analysisState.canGoNext ? () => _moveForward(ref) : null,
              child: BottomBarButton(
                key: const ValueKey('goto-next'),
                icon: CupertinoIcons.chevron_forward,
                label: context.l10n.next,
                shortLabel: context.l10n.next,
                onTap: analysisState.canGoNext ? () => _moveForward(ref) : null,
                showAndroidTooltip: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _moveForward(WidgetRef ref) =>
      ref.read(ctrlProvider.notifier).userNext();
  void _moveBackward(WidgetRef ref) =>
      ref.read(ctrlProvider.notifier).userPrevious();

  Future<void> _showGameMenu(BuildContext context, WidgetRef ref) {
    return showAdaptiveActionSheet(
      context: context,
      actions: [
        BottomSheetAction(
          label: Text(context.l10n.flipBoard),
          onPressed: (context) {
            ref.read(ctrlProvider.notifier).toggleBoard();
          },
        ),
      ],
    );
  }
}

class _EngineDepth extends ConsumerWidget {
  const _EngineDepth(this.evalContext, this.currentNode);

  final EvaluationContext evalContext;
  final ViewNode currentNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final depth = ref.watch(
          engineEvaluationProvider(evalContext).select((value) => value?.depth),
        ) ??
        currentNode.eval?.depth;

    return depth != null
        ? AppBarTextButton(
            onPressed: () {
              showPopover(
                context: context,
                bodyBuilder: (context) {
                  return _StockfishInfo(evalContext, currentNode);
                },
                direction: PopoverDirection.top,
                width: 240,
                backgroundColor: defaultTargetPlatform == TargetPlatform.android
                    ? Theme.of(context).dialogBackgroundColor
                    : CupertinoDynamicColor.resolve(
                        CupertinoColors.tertiarySystemBackground,
                        context,
                      ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                color: defaultTargetPlatform == TargetPlatform.android
                    ? Theme.of(context).colorScheme.secondary
                    : CupertinoTheme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Text(
                '$depth',
                style: TextStyle(
                  fontSize: 12.0,
                  color: defaultTargetPlatform == TargetPlatform.android
                      ? Theme.of(context).colorScheme.onSecondary
                      : CupertinoTheme.of(context).primaryContrastingColor,
                  fontFeatures: const [
                    FontFeature.tabularFigures(),
                  ],
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}

class _StockfishInfo extends ConsumerWidget {
  const _StockfishInfo(this.evalContext, this.currentNode);

  final EvaluationContext evalContext;
  final ViewNode currentNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eval =
        ref.watch(engineEvaluationProvider(evalContext)) ?? currentNode.eval;

    final knps = eval?.isComputing == true ? ', ${eval?.knps.round()}kn/s' : '';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PlatformListTile(
          leading: Image.asset(
            'assets/images/stockfish/icon.png',
            width: 44,
            height: 44,
          ),
          title: const Text('Stockfish 16'),
          subtitle: Text(
            context.l10n.depthX(
              '${eval?.depth ?? 0}/$kMaxEngineDepth$knps',
            ),
          ),
        ),
      ],
    );
  }
}

class _Preferences extends ConsumerWidget {
  const _Preferences(this.ctrlProvider);

  final AnalysisCtrlProvider ctrlProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ctrlProvider);
    final prefs = ref.watch(analysisPreferencesProvider);
    final isSoundEnabled = ref.watch(
      generalPreferencesProvider.select((pref) => pref.isSoundEnabled),
    );

    return SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: Styles.bodyPadding,
            child: Text(
              context.l10n.analysisOptions,
              style: Styles.title,
            ),
          ),
          Opacity(
            opacity: state.isEngineAvailable ? 1.0 : 0.5,
            child: PlatformListTile(
              title: Text.rich(
                TextSpan(
                  text: '${context.l10n.multipleLines}: ',
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                  children: [
                    TextSpan(
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      text: prefs.numEvalLines.toString(),
                    ),
                  ],
                ),
              ),
              subtitle: NonLinearSlider(
                value: prefs.numEvalLines,
                values: const [1, 2, 3],
                onChangeEnd: state.isEngineAvailable
                    ? (value) => ref
                        .read(ctrlProvider.notifier)
                        .setNumEvalLines(value.toInt())
                    : null,
              ),
            ),
          ),
          if (maxEngineCores > 1)
            Opacity(
              opacity: state.isEngineAvailable ? 1.0 : 0.5,
              child: PlatformListTile(
                title: Text.rich(
                  TextSpan(
                    text: '${context.l10n.cpus}: ',
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                    children: [
                      TextSpan(
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        text: prefs.numEngineCores.toString(),
                      ),
                    ],
                  ),
                ),
                subtitle: NonLinearSlider(
                  value: prefs.numEngineCores,
                  values: List.generate(maxEngineCores, (index) => index + 1),
                  onChangeEnd: state.isEngineAvailable
                      ? (value) => ref
                          .read(ctrlProvider.notifier)
                          .setEngineCores(value.toInt())
                      : null,
                ),
              ),
            ),
          SwitchSettingTile(
            title: Text(context.l10n.bestMoveArrow),
            value: prefs.showBestMoveArrow,
            onChanged: state.isEngineAvailable
                ? (value) => ref
                    .read(analysisPreferencesProvider.notifier)
                    .toggleShowBestMoveArrow()
                : null,
          ),
          SwitchSettingTile(
            title: Text(context.l10n.evaluationGauge),
            value: prefs.showEvaluationGauge,
            onChanged: state.isEngineAvailable
                ? (value) => ref
                    .read(analysisPreferencesProvider.notifier)
                    .toggleShowEvaluationGauge()
                : null,
          ),
          SwitchSettingTile(
            title: Text(context.l10n.sound),
            value: isSoundEnabled,
            onChanged: (value) {
              ref
                  .read(generalPreferencesProvider.notifier)
                  .toggleSoundEnabled();
            },
          ),
        ],
      ),
    );
  }
}
