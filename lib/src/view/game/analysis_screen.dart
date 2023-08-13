import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:chessground/chessground.dart' as cg;
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/tree.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/engine_evaluation.dart';
import 'package:lichess_mobile/src/model/game/analysis_ctrl.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/immersive_mode.dart';
import 'package:lichess_mobile/src/utils/rate_limit.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_dialog.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/non_linear_slider.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

const baseTextStyle = TextStyle(fontFamily: 'ChessFont');
const sideLineStyle =
    TextStyle(fontFamily: 'ChessFont', fontStyle: FontStyle.italic);

class AnalysisScreen extends ConsumerWidget {
  const AnalysisScreen({
    required this.steps,
    required this.orientation,
    required this.gameData,
  });

  final IList<GameStep> steps;
  final Side orientation;
  final ArchivedGameData gameData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConsumerPlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
      ref: ref,
    );
  }

  Widget _androidBuilder(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisCtrlProvider(steps, orientation, gameData.id);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.gameAnalysis),
        actions: [
          _EngineDepth(
            ref.watch(ctrlProvider.select((value) => value.evaluationContext)),
          ),
          SettingsButton(
            onPressed: () => showAdaptiveDialog<void>(
              context: context,
              builder: (_) => _Prefrences(ctrlProvider),
            ),
          )
        ],
      ),
      body: _Body(ctrlProvider: ctrlProvider),
    );
  }

  Widget _iosBuilder(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisCtrlProvider(steps, orientation, gameData.id);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(context.l10n.analysis),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _EngineDepth(
              ref.watch(
                ctrlProvider.select((value) => value.evaluationContext),
              ),
            ),
            SettingsButton(
              onPressed: () => showAdaptiveDialog<void>(
                context: context,
                builder: (_) => _Prefrences(ctrlProvider),
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
                final boardSize =
                    isTablet ? defaultBoardSize - 16.0 * 2 : defaultBoardSize;

                return aspectRatio > 1
                    ? Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: kTabletPadding,
                              top: kTabletPadding,
                              bottom: kTabletPadding,
                            ),
                            child: Row(
                              children: [
                                _Board(widget.ctrlProvider, boardSize),
                                _EngineGaugeVertical(widget.ctrlProvider),
                              ],
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _CevalLines(widget.ctrlProvider),
                                _Moves(widget.ctrlProvider),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          _TopTable(widget.ctrlProvider),
                          _Board(widget.ctrlProvider, boardSize),
                          _Moves(widget.ctrlProvider),
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
        shapes: analysisState.showBestMoveArrow &&
                analysisState.isEngineEnabled &&
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

class _TopTable extends ConsumerWidget {
  const _TopTable(this.ctrlProvider);

  final AnalysisCtrlProvider ctrlProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisState = ref.watch(ctrlProvider);

    return analysisState.isEngineEnabled
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EngineGauge(
                displayMode: EngineGaugeDisplayMode.horizontal,
                params: EngineGaugeParams(
                  evaluationContext: analysisState.evaluationContext,
                  position: analysisState.position,
                  savedEval: analysisState.currentNode.eval,
                ),
              ),
              _CevalLines(ctrlProvider),
            ],
          )
        : const SizedBox.shrink();
  }
}

class _EngineGaugeVertical extends ConsumerWidget {
  const _EngineGaugeVertical(this.ctrlProvider);

  final AnalysisCtrlProvider ctrlProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisState = ref.watch(ctrlProvider);

    return analysisState.isEngineEnabled
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

class _CevalLines extends ConsumerWidget {
  const _CevalLines(this.ctrlProvider);
  final AnalysisCtrlProvider ctrlProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisState = ref.watch(ctrlProvider);
    final ceval =
        ref.watch(engineEvaluationProvider(analysisState.evaluationContext));

    final content = ceval != null
        ? ceval.pvs
            .map(
              (pv) => _CevalLine(
                ctrlProvider,
                pv.sanMoves(ceval.currentPosition),
                analysisState.currentNode.ply,
                pv,
              ),
            )
            .toList()
        : (analysisState.currentNode.eval != null
            ? analysisState.currentNode.eval!.pvs
                .take(analysisState.numCevalLines)
                .map(
                  (pv) => _CevalLine(
                    ctrlProvider,
                    pv.sanMoves(analysisState.currentNode.position),
                    analysisState.currentNode.ply,
                    pv,
                  ),
                )
                .toList()
            : null);

    return content != null
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: content,
            ),
          )
        : kEmptyWidget;
  }
}

class _CevalLine extends ConsumerWidget {
  const _CevalLine(
    this.ctrlProvider,
    this.moves,
    this.initialPly,
    this.pvData,
  );

  final AnalysisCtrlProvider ctrlProvider;
  final List<String> moves;
  final int initialPly;
  final PvData pvData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    final (evalString, whiteBetter) = pvData.evalStringAndWinningSide;
    return InkWell(
      onTap: () => ref
          .read(ctrlProvider.notifier)
          .onUserMove(Move.fromUci(pvData.moves[0])!),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                color: whiteBetter != null && !whiteBetter
                    ? kEvalGaugeBackgroundColor
                    : kEvalGaugeValueColorLightBg,
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              ),
              child: Text(
                evalString,
                style: TextStyle(
                  color: whiteBetter != null && !whiteBetter
                      ? Colors.white
                      : Colors.black,
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
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Moves extends ConsumerWidget {
  const _Moves(this.ctrlProvider);

  final AnalysisCtrlProvider ctrlProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisState = ref.watch(ctrlProvider);

    return _InlineTreeView(
      ctrlProvider,
      analysisState.root,
      analysisState.currentPath,
    );
  }
}

class _InlineTreeView extends ConsumerStatefulWidget {
  const _InlineTreeView(
    this.ctrlProvider,
    this.root,
    this.currentPath,
  );

  final AnalysisCtrlProvider ctrlProvider;
  final IList<ViewNode> root;
  final UciPath currentPath;

  @override
  ConsumerState<_InlineTreeView> createState() => _InlineTreeViewState();
}

class _InlineTreeViewState extends ConsumerState<_InlineTreeView> {
  final currentMoveKey = GlobalKey();
  final _debounce = Debouncer(const Duration(milliseconds: 100));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (currentMoveKey.currentContext != null) {
        Scrollable.ensureVisible(
          currentMoveKey.currentContext!,
          alignment: 10.0,
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
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
        child: Wrap(
          spacing: 1.0,
          children: _buildTreeWidget(
            widget.ctrlProvider,
            nodes: widget.root,
            inMainline: true,
            startSideline: false,
            initialPath: UciPath.empty,
            currentPath: widget.currentPath,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTreeWidget(
    AnalysisCtrlProvider ctrlProvider, {
    required IList<ViewNode> nodes,
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
      _InlineMove(
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
              spacing: 1.0,
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

class _InlineMove extends ConsumerWidget {
  const _InlineMove(
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
  static const borderRadius = BorderRadius.all(Radius.circular(8.0));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = InkWell(
      borderRadius: borderRadius,
      onTap: () => ref.read(ctrlProvider.notifier).userJump(path),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: isCurrentMove
            ? BoxDecoration(
                color: Theme.of(context).focusColor,
                shape: BoxShape.rectangle,
                borderRadius: borderRadius,
              )
            : null,
        child: Opacity(
          opacity: isSideline ? 0.8 : 1.0,
          child: Text(
            ply.isOdd
                ? '${(ply / 2).ceil()}. ${move.san}'
                : (startSideline
                    ? '${(ply / 2).ceil()}... ${move.san}'
                    : move.san),
            style: isSideline ? sideLineStyle : baseTextStyle,
          ),
        ),
      ),
    );
    return startSideline || endSideline
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (startSideline)
                const Opacity(
                  opacity: 0.8,
                  child: Text('(', style: sideLineStyle),
                ),
              content,
              if (endSideline)
                const Opacity(
                  opacity: 0.8,
                  child: Text(')', style: sideLineStyle),
                ),
            ],
          )
        : content;
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
            const SizedBox(
              width: 44.0,
            ),
            const SizedBox(
              width: 44.0,
            ),
            RepeatButton(
              onLongPress:
                  analysisState.canGoBack ? () => _moveBackward(ref) : null,
              child: BottomBarButton(
                onTap:
                    analysisState.canGoBack ? () => _moveBackward(ref) : null,
                label: 'Previous',
                shortLabel: 'Previous',
                icon: CupertinoIcons.chevron_back,
                showAndroidTooltip: false,
              ),
            ),
            RepeatButton(
              onLongPress:
                  analysisState.canGoNext ? () => _moveForward(ref) : null,
              child: BottomBarButton(
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
          leading: const Icon(Icons.swap_vert),
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
  const _EngineDepth(this.evalContext);

  final EvaluationContext evalContext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final depth = ref.watch(
      engineEvaluationProvider(evalContext).select((value) => value?.depth),
    );

    return depth != null
        ? Tooltip(
            message: 'Engine Depth',
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(CupertinoIcons.app_fill),
                Text(
                  '$depth',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ],
            ),
          )
        : kEmptyWidget;
  }
}

class _Prefrences extends ConsumerWidget {
  const _Prefrences(this.ctrlProvider);

  final AnalysisCtrlProvider ctrlProvider;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ctrlProvider);

    final content = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (defaultTargetPlatform == TargetPlatform.android)
            Padding(
              padding: Styles.bodyPadding,
              child: Text(
                context.l10n.settingsSettings,
                style: Styles.title,
              ),
            ),
          SwitchSettingTile(
            title: Text(context.l10n.bestMoveArrow),
            value: state.showBestMoveArrow,
            onChanged: (value) =>
                ref.read(ctrlProvider.notifier).toggleBestMoveArrow(),
          ),
          SwitchSettingTile(
            title: Text(context.l10n.evaluationGauge),
            value: state.isEngineEnabled,
            onChanged: (value) =>
                ref.read(ctrlProvider.notifier).toggleLocalEvaluation(),
          ),
          PlatformListTile(
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
                    text: state.numCevalLines.toString(),
                  ),
                ],
              ),
            ),
            subtitle: NonLinearSlider(
              value: state.numCevalLines,
              values: const [1, 2, 3],
              onChangeEnd: (value) =>
                  ref.read(ctrlProvider.notifier).setCevalLines(value.toInt()),
            ),
          ),
          PlatformListTile(
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
                    text: state.numCores.toString(),
                  ),
                ],
              ),
            ),
            subtitle: NonLinearSlider(
              value: state.numCores,
              values: List.generate(maxCores, (index) => index + 1),
              onChangeEnd: (value) =>
                  ref.read(ctrlProvider.notifier).setCores(value.toInt()),
            ),
          ),
        ],
      ),
    );

    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return CupertinoAlertDialog(
          title: Text(context.l10n.settingsSettings),
          content: content,
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      case TargetPlatform.android:
        return Dialog(child: content);

      default:
        throw UnimplementedError('Platform not supported');
    }
  }
}
