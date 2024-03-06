import 'dart:math' as math;

import 'package:chessground/chessground.dart' as cg;
import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/analysis/server_analysis_service.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/engine/engine.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/brightness.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/layout.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/utils/string.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar_button.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:popover/popover.dart';

import 'analysis_pgn_tags.dart';
import 'analysis_settings.dart';
import 'annotations.dart';
import 'tree_view.dart';

class AnalysisScreen extends ConsumerWidget {
  const AnalysisScreen({
    required this.options,
    this.title,
  });

  final AnalysisOptions options;
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
    final ctrlProvider = analysisControllerProvider(options);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: _Title(options: options, title: title),
        actions: [
          _EngineDepth(ctrlProvider),
          SettingsButton(
            onPressed: () => showAdaptiveBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (_) => AnalysisSettings(options),
            ),
          ),
        ],
      ),
      body: _Body(options: options),
    );
  }

  Widget _iosBuilder(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisControllerProvider(options);

    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        padding: Styles.cupertinoAppBarTrailingWidgetPadding,
        middle: _Title(options: options, title: title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _EngineDepth(ctrlProvider),
            SettingsButton(
              onPressed: () => showAdaptiveBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (_) => AnalysisSettings(options),
              ),
            ),
          ],
        ),
      ),
      child: _Body(options: options),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({
    required this.options,
    this.title,
  });
  final AnalysisOptions options;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return title != null
        ? Text(title!)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (options.variant != Variant.standard) ...[
                Icon(options.variant.icon),
                const SizedBox(width: 5.0),
              ],
              Text(context.l10n.analysis),
            ],
          );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.options});

  final AnalysisOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisControllerProvider(options);
    final showEvaluationGauge = ref.watch(
      analysisPreferencesProvider.select((value) => value.showEvaluationGauge),
    );

    final isEngineAvailable = ref.watch(
      ctrlProvider.select(
        (value) => value.isEngineAvailable,
      ),
    );

    final hasEval =
        ref.watch(ctrlProvider.select((value) => value.hasAvailableEval));

    final showAnalysisSummary = ref.watch(
      ctrlProvider.select((value) => value.displayMode == DisplayMode.summary),
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
                final isTablet = defaultBoardSize > FormFactor.tablet;
                final remainingHeight =
                    constraints.maxHeight - defaultBoardSize;
                final isSmallScreen =
                    remainingHeight < kSmallRemainingHeightLeftBoardThreshold;
                final boardSize = isTablet || isSmallScreen
                    ? defaultBoardSize - kTabletBoardTableSidePadding * 2
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
                                _Board(options, boardSize),
                                if (hasEval && showEvaluationGauge)
                                  _EngineGaugeVertical(ctrlProvider),
                              ],
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if (isEngineAvailable)
                                  _EngineLines(
                                    ctrlProvider,
                                    isLandscape: true,
                                  ),
                                Expanded(
                                  child: PlatformCard(
                                    margin: const EdgeInsets.all(
                                      kTabletBoardTableSidePadding,
                                    ),
                                    semanticContainer: false,
                                    child: showAnalysisSummary
                                        ? ServerAnalysisSummary(options)
                                        : AnalysisTreeView(
                                            options,
                                            Orientation.landscape,
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _ColumnTopTable(ctrlProvider),
                          if (isTablet)
                            Padding(
                              padding: const EdgeInsets.all(
                                kTabletBoardTableSidePadding,
                              ),
                              child: _Board(options, boardSize),
                            )
                          else
                            _Board(options, boardSize),
                          if (showAnalysisSummary)
                            Expanded(child: ServerAnalysisSummary(options))
                          else
                            Expanded(
                              child: AnalysisTreeView(
                                options,
                                Orientation.portrait,
                              ),
                            ),
                        ],
                      );
              },
            ),
          ),
        ),
        _BottomBar(options: options),
      ],
    );
  }
}

class _Board extends ConsumerWidget {
  const _Board(this.options, this.boardSize);

  final AnalysisOptions options;
  final double boardSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisControllerProvider(options);
    final analysisState = ref.watch(ctrlProvider);
    final boardPrefs = ref.watch(boardPreferencesProvider);
    final showBestMoveArrow = ref.watch(
      analysisPreferencesProvider.select(
        (value) => value.showBestMoveArrow,
      ),
    );

    final evalBestMoves = ref.watch(
      engineEvaluationProvider.select((s) => s.eval?.bestMoves),
    );

    final currentNode = analysisState.currentNode;
    final annotation = makeAnnotation(currentNode.nags);

    final bestMoves = evalBestMoves ?? currentNode.eval?.bestMoves;

    final sanMove = currentNode.sanMove;

    return cg.Board(
      size: boardSize,
      onMove: (move, {isDrop, isPremove}) =>
          ref.read(ctrlProvider.notifier).onUserMove(Move.fromUci(move.uci)!),
      data: cg.BoardData(
        orientation: analysisState.pov.cg,
        interactableSide: analysisState.position.isGameOver
            ? cg.InteractableSide.none
            : analysisState.position.turn == Side.white
                ? cg.InteractableSide.white
                : cg.InteractableSide.black,
        fen: analysisState.position.fen,
        isCheck: analysisState.position.isCheck,
        lastMove: analysisState.lastMove?.cg,
        sideToMove: analysisState.position.turn.cg,
        validMoves: analysisState.validMoves,
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
        annotations: sanMove != null && annotation != null
            ? altCastles.containsKey(sanMove.move.uci)
                ? IMap({
                    Move.fromUci(altCastles[sanMove.move.uci]!)!.cg.to:
                        annotation,
                  })
                : IMap({sanMove.move.cg.to: annotation})
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

  final AnalysisControllerProvider ctrlProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisState = ref.watch(ctrlProvider);

    return EngineGauge(
      displayMode: EngineGaugeDisplayMode.vertical,
      params: analysisState.engineGaugeParams,
    );
  }
}

class _ColumnTopTable extends ConsumerWidget {
  const _ColumnTopTable(this.ctrlProvider);

  final AnalysisControllerProvider ctrlProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisState = ref.watch(ctrlProvider);
    final showEvaluationGauge = ref.watch(
      analysisPreferencesProvider.select((p) => p.showEvaluationGauge),
    );

    return analysisState.hasAvailableEval
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showEvaluationGauge)
                EngineGauge(
                  displayMode: EngineGaugeDisplayMode.horizontal,
                  params: analysisState.engineGaugeParams,
                ),
              if (analysisState.isEngineAvailable)
                _EngineLines(ctrlProvider, isLandscape: false),
            ],
          )
        : kEmptyWidget;
  }
}

class _EngineLines extends ConsumerWidget {
  const _EngineLines(this.ctrlProvider, {required this.isLandscape});
  final AnalysisControllerProvider ctrlProvider;
  final bool isLandscape;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisState = ref.watch(ctrlProvider);
    final numEvalLines = ref.watch(
      analysisPreferencesProvider.select(
        (p) => p.numEvalLines,
      ),
    );
    final engineEval = ref.watch(engineEvaluationProvider).eval;
    final eval = engineEval ?? analysisState.currentNode.eval;

    final emptyLines = List.filled(
      numEvalLines,
      _Engineline.empty(ctrlProvider),
    );

    final content = !analysisState.position.isGameOver
        ? (eval != null
            ? eval.pvs
                .take(numEvalLines)
                .map(
                  (pv) => _Engineline(ctrlProvider, eval.position, pv),
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
        vertical: isLandscape ? kTabletBoardTableSidePadding : 0.0,
        horizontal: isLandscape ? kTabletBoardTableSidePadding : 0.0,
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
    this.fromPosition,
    this.pvData,
  );

  const _Engineline.empty(this.ctrlProvider)
      : pvData = const PvData(moves: IListConst([])),
        fromPosition = Chess.initial;

  final AnalysisControllerProvider ctrlProvider;
  final Position fromPosition;
  final PvData pvData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (pvData.moves.isEmpty) {
      return const SizedBox(
        height: kEvalGaugeSize,
        child: SizedBox.shrink(),
      );
    }

    final lineBuffer = StringBuffer();
    int ply = fromPosition.ply + 1;
    pvData.sanMoves(fromPosition).forEachIndexed((i, s) {
      lineBuffer.write(
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
                      ? EngineGauge.backgroundColor(context, brightness)
                      : EngineGauge.valueColor(context, brightness),
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
                  lineBuffer.toString(),
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
      ),
    );
  }
}

class _BottomBar extends ConsumerWidget {
  const _BottomBar({
    required this.options,
  });

  final AnalysisOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisControllerProvider(options);
    final canGoBack =
        ref.watch(ctrlProvider.select((value) => value.canGoBack));
    final canGoNext =
        ref.watch(ctrlProvider.select((value) => value.canGoNext));
    final displayMode =
        ref.watch(ctrlProvider.select((value) => value.displayMode));
    final canShowGameSummary =
        ref.watch(ctrlProvider.select((value) => value.canShowGameSummary));

    return Container(
      color: Theme.of(context).platform == TargetPlatform.iOS
          ? CupertinoTheme.of(context).barBackgroundColor
          : Theme.of(context).bottomAppBarTheme.color,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: kBottomBarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: BottomBarButton(
                  label: context.l10n.menu,
                  onTap: () {
                    _showAnalysisMenu(context, ref);
                  },
                  icon: Icons.menu,
                ),
              ),
              if (canShowGameSummary)
                Expanded(
                  child: BottomBarButton(
                    label: displayMode == DisplayMode.summary
                        ? 'Moves'
                        : 'Summary',
                    onTap: () {
                      ref.read(ctrlProvider.notifier).toggleDisplayMode();
                    },
                    icon: displayMode == DisplayMode.summary
                        ? LichessIcons.flow_cascade
                        : Icons.area_chart,
                  ),
                ),
              Expanded(
                child: RepeatButton(
                  onLongPress: canGoBack ? () => _moveBackward(ref) : null,
                  child: BottomBarButton(
                    key: const ValueKey('goto-previous'),
                    onTap: canGoBack ? () => _moveBackward(ref) : null,
                    label: 'Previous',
                    icon: CupertinoIcons.chevron_back,
                    showTooltip: false,
                  ),
                ),
              ),
              Expanded(
                child: RepeatButton(
                  onLongPress: canGoNext ? () => _moveForward(ref) : null,
                  child: BottomBarButton(
                    key: const ValueKey('goto-next'),
                    icon: CupertinoIcons.chevron_forward,
                    label: context.l10n.next,
                    onTap: canGoNext ? () => _moveForward(ref) : null,
                    showTooltip: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _moveForward(WidgetRef ref) =>
      ref.read(analysisControllerProvider(options).notifier).userNext();
  void _moveBackward(WidgetRef ref) =>
      ref.read(analysisControllerProvider(options).notifier).userPrevious();

  Future<void> _showAnalysisMenu(BuildContext context, WidgetRef ref) {
    return showAdaptiveActionSheet(
      context: context,
      actions: [
        BottomSheetAction(
          label: Text(context.l10n.flipBoard),
          onPressed: (context) {
            ref
                .read(analysisControllerProvider(options).notifier)
                .toggleBoard();
          },
        ),
        BottomSheetAction(
          label: Text(context.l10n.studyShareAndExport),
          onPressed: (_) {
            showAdaptiveBottomSheet<void>(
              context: context,
              showDragHandle: true,
              isScrollControlled: true,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.9,
              ),
              builder: (_) => SafeArea(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    AnalysisPgnTags(
                      options: options,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: FatButton(
                        semanticsLabel: 'Share PGN',
                        onPressed: () {
                          Navigator.of(context).pop();
                          launchShareDialog(
                            context,
                            text: ref
                                .read(
                                  analysisControllerProvider(options).notifier,
                                )
                                .makeGamePgn(),
                          );
                        },
                        child: const Text('Share PGN'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _EngineDepth extends ConsumerWidget {
  const _EngineDepth(this.ctrlProvider);

  final AnalysisControllerProvider ctrlProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEngineAvailable = ref.watch(
      ctrlProvider.select(
        (value) => value.isEngineAvailable,
      ),
    );
    final currentNode = ref.watch(
      ctrlProvider.select((value) => value.currentNode),
    );
    final depth = ref.watch(
          engineEvaluationProvider.select((value) => value.eval?.depth),
        ) ??
        currentNode.eval?.depth;

    return isEngineAvailable && depth != null
        ? AppBarTextButton(
            onPressed: () {
              showPopover(
                context: context,
                bodyBuilder: (context) {
                  return _StockfishInfo(currentNode);
                },
                direction: PopoverDirection.top,
                width: 240,
                backgroundColor:
                    Theme.of(context).platform == TargetPlatform.android
                        ? Theme.of(context).dialogBackgroundColor
                        : CupertinoDynamicColor.resolve(
                            CupertinoColors.tertiarySystemBackground,
                            context,
                          ),
                transitionDuration: Duration.zero,
                popoverTransitionBuilder: (_, child) => child,
              );
            },
            child: RepaintBoundary(
              child: Container(
                width: 20.0,
                height: 20.0,
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).platform == TargetPlatform.android
                      ? Theme.of(context).colorScheme.secondary
                      : CupertinoTheme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    '${math.min(99, depth)}',
                    style: TextStyle(
                      color: Theme.of(context).platform ==
                              TargetPlatform.android
                          ? Theme.of(context).colorScheme.onSecondary
                          : CupertinoTheme.of(context).primaryContrastingColor,
                      fontFeatures: const [
                        FontFeature.tabularFigures(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}

class _StockfishInfo extends ConsumerWidget {
  const _StockfishInfo(this.currentNode);

  final AnalysisCurrentNode currentNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (eval: eval, state: engineState) =
        ref.watch(engineEvaluationProvider);

    final currentEval = eval ?? currentNode.eval;

    final knps = engineState == EngineState.computing
        ? ', ${eval?.knps.round()}kn/s'
        : '';
    final depth = currentEval?.depth ?? 0;
    final maxDepth = math.max(depth, kMaxEngineDepth);

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
              '$depth/$maxDepth$knps',
            ),
          ),
        ),
      ],
    );
  }
}

class ServerAnalysisSummary extends ConsumerWidget {
  const ServerAnalysisSummary(this.options);

  final AnalysisOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisControllerProvider(options);
    final playersAnalysis =
        ref.watch(ctrlProvider.select((value) => value.playersAnalysis));
    final pgnHeaders =
        ref.watch(ctrlProvider.select((value) => value.pgnHeaders));
    final currentGameAnalysis = ref.watch(currentAnalysisProvider);

    return playersAnalysis != null
        ? ListView(
            children: [
              if (currentGameAnalysis == options.gameAnyId?.gameId)
                const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: WaitingForServerAnalysis(),
                ),
              AcplChart(options),
              // may be removed if game phases text is displayed vertically instead of horizontally
              const SizedBox(height: 10.0),
              Center(
                child: SizedBox(
                  width: math.min(MediaQuery.sizeOf(context).width, 500),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      columnWidths: const {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(1),
                        2: FlexColumnWidth(1),
                      },
                      children: [
                        TableRow(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey),
                            ),
                          ),
                          children: [
                            _SummaryPlayerName(Side.white, pgnHeaders),
                            const SizedBox.shrink(),
                            _SummaryPlayerName(Side.black, pgnHeaders),
                          ],
                        ),
                        if (playersAnalysis.white.accuracy != null &&
                            playersAnalysis.black.accuracy != null)
                          TableRow(
                            children: [
                              _SummaryNumber(
                                '${playersAnalysis.white.accuracy}%',
                              ),
                              Center(
                                heightFactor: 1.8,
                                child: Text(
                                  context.l10n.accuracy,
                                  softWrap: true,
                                ),
                              ),
                              _SummaryNumber(
                                '${playersAnalysis.black.accuracy}%',
                              ),
                            ],
                          ),
                        for (final item in [
                          (
                            playersAnalysis.white.inaccuracies.toString(),
                            context.l10n
                                .nbInaccuracies(2)
                                .replaceAll('2', '')
                                .trim()
                                .capitalize(),
                            playersAnalysis.black.inaccuracies.toString()
                          ),
                          (
                            playersAnalysis.white.mistakes.toString(),
                            context.l10n
                                .nbMistakes(2)
                                .replaceAll('2', '')
                                .trim()
                                .capitalize(),
                            playersAnalysis.black.mistakes.toString()
                          ),
                          (
                            playersAnalysis.white.blunders.toString(),
                            context.l10n
                                .nbBlunders(2)
                                .replaceAll('2', '')
                                .trim()
                                .capitalize(),
                            playersAnalysis.black.blunders.toString()
                          ),
                        ])
                          TableRow(
                            children: [
                              _SummaryNumber(item.$1),
                              Center(
                                heightFactor: 1.2,
                                child: Text(
                                  item.$2,
                                  softWrap: true,
                                ),
                              ),
                              _SummaryNumber(item.$3),
                            ],
                          ),
                        if (playersAnalysis.white.acpl != null &&
                            playersAnalysis.black.acpl != null)
                          TableRow(
                            children: [
                              _SummaryNumber(
                                playersAnalysis.white.acpl.toString(),
                              ),
                              Center(
                                heightFactor: 1.5,
                                child: Text(
                                  context.l10n.averageCentipawnLoss,
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              _SummaryNumber(
                                playersAnalysis.black.acpl.toString(),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              if (currentGameAnalysis == options.gameAnyId?.gameId)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: WaitingForServerAnalysis(),
                  ),
                )
              else
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Builder(
                      builder: (context) {
                        Future<void>? pendingRequest;
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return FutureBuilder<void>(
                              future: pendingRequest,
                              builder: (context, snapshot) {
                                return SecondaryButton(
                                  semanticsLabel:
                                      context.l10n.requestAComputerAnalysis,
                                  onPressed: ref.watch(authSessionProvider) ==
                                          null
                                      ? () {
                                          showPlatformSnackbar(
                                            context,
                                            context
                                                .l10n.youNeedAnAccountToDoThat,
                                          );
                                        }
                                      : snapshot.connectionState ==
                                              ConnectionState.waiting
                                          ? null
                                          : () {
                                              setState(() {
                                                pendingRequest = ref
                                                    .read(ctrlProvider.notifier)
                                                    .requestServerAnalysis()
                                                    .catchError((Object e) {
                                                  showPlatformSnackbar(
                                                    context,
                                                    e.toString(),
                                                    type: SnackBarType.error,
                                                  );
                                                });
                                              });
                                            },
                                  child: Text(
                                    context.l10n.requestAComputerAnalysis,
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              const Spacer(),
            ],
          );
  }
}

class WaitingForServerAnalysis extends StatelessWidget {
  const WaitingForServerAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Image.asset(
          'assets/images/stockfish/icon.png',
          width: 30,
          height: 30,
        ),
        const SizedBox(width: 8.0),
        Text(context.l10n.waitingForAnalysis),
        const SizedBox(width: 8.0),
        const CircularProgressIndicator.adaptive(),
      ],
    );
  }
}

class _SummaryNumber extends StatelessWidget {
  const _SummaryNumber(this.data);
  final String data;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        data,
        softWrap: true,
      ),
    );
  }
}

class _SummaryPlayerName extends StatelessWidget {
  const _SummaryPlayerName(this.side, this.pgnHeaders);
  final Side side;
  final IMap<String, String> pgnHeaders;

  @override
  Widget build(BuildContext context) {
    final playerTitle = side == Side.white
        ? pgnHeaders.get('WhiteTitle')
        : pgnHeaders.get('BlackTitle');
    final playerName = side == Side.white
        ? pgnHeaders.get('White') ?? context.l10n.white
        : pgnHeaders.get('Black') ?? context.l10n.black;

    final brightness = Theme.of(context).brightness;

    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.bottom,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Column(
            children: [
              Icon(
                side == Side.white
                    ? brightness == Brightness.light
                        ? CupertinoIcons.circle
                        : CupertinoIcons.circle_filled
                    : brightness == Brightness.light
                        ? CupertinoIcons.circle_filled
                        : CupertinoIcons.circle,
                size: 14,
              ),
              Text(
                '${playerTitle != null ? '$playerTitle ' : ''}$playerName',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AcplChart extends ConsumerWidget {
  const AcplChart(this.options);

  final AnalysisOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainLineColor = Theme.of(context).platform == TargetPlatform.iOS
        ? Colors.orange
        : Theme.of(context).colorScheme.secondary;
    // yes it looks like below/above are inverted in fl_chart
    final belowLineColor = Colors.white.withOpacity(0.7);
    final aboveLineColor = Colors.grey.shade800.withOpacity(0.8);

    VerticalLine phaseVerticalBar(double x, String label) => VerticalLine(
          x: x,
          color: const Color(0xFF707070),
          strokeWidth: 0.5,
          label: VerticalLineLabel(
            style: const TextStyle(fontSize: 10),
            labelResolver: (line) => label,
            show: true,
          ),
        );

    final data = ref.watch(
      analysisControllerProvider(options)
          .select((value) => value.acplChartData),
    );

    final currentNode = ref.watch(
      analysisControllerProvider(options).select((value) => value.currentNode),
    );

    final isOnMainline = ref.watch(
      analysisControllerProvider(options).select((value) => value.isOnMainline),
    );

    if (data == null) {
      return const SizedBox.shrink();
    }

    final spots = data
        .mapIndexed(
          (i, e) => FlSpot(i.toDouble(), e.winningChances(Side.white)),
        )
        .toList(growable: false);

    return Center(
      child: AspectRatio(
        aspectRatio: 2.5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(
                enabled: false,
                touchCallback:
                    (FlTouchEvent event, LineTouchResponse? touchResponse) {
                  if (event is FlTapUpEvent) {
                    final touchX = event.localPosition.dx;
                    final chartWidth = context.size!.width -
                        32; // Insets on both sides of the chart of 16
                    final minX = spots.first.x;
                    final maxX = spots.last.x;
                    final touchXDataValue =
                        minX + (touchX / chartWidth) * (maxX - minX);
                    final closestSpot = spots.reduce(
                      (a, b) => (a.x - touchXDataValue).abs() <
                              (b.x - touchXDataValue).abs()
                          ? a
                          : b,
                    );
                    final closestNodeIndex = closestSpot.x.round();
                    ref
                        .read(analysisControllerProvider(options).notifier)
                        .jumpToNthNodeOnMainline(closestNodeIndex);
                  }
                },
              ),
              minY: -1.0,
              maxY: 1.0,
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: false,
                  barWidth: 1,
                  color: mainLineColor,
                  aboveBarData: BarAreaData(
                    show: true,
                    color: aboveLineColor,
                    applyCutOffY: true,
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: belowLineColor,
                    applyCutOffY: true,
                  ),
                  dotData: const FlDotData(
                    show: false,
                  ),
                ),
              ],
              extraLinesData: ExtraLinesData(
                verticalLines: [
                  if (isOnMainline)
                    VerticalLine(
                      x: (currentNode.position.ply - 1).toDouble(),
                      color: mainLineColor,
                      strokeWidth: 1.0,
                    ),
                  phaseVerticalBar(0.0, context.l10n.opening),
                  if (options.division?.endgame != null)
                    phaseVerticalBar(
                      options.division!.endgame!,
                      context.l10n.endgame,
                    ),
                  if (options.division?.middlegame != null)
                    phaseVerticalBar(
                      options.division!.middlegame!,
                      context.l10n.middlegame,
                    ),
                ],
              ),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: const FlTitlesData(show: false),
            ),
          ),
        ),
      ),
    );
  }
}
