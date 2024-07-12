import 'dart:math' as math;
import 'dart:ui';

import 'package:chessground/chessground.dart' as cg;
import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/analysis/server_analysis_service.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/engine/engine.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/model/game/game_repository_providers.dart';
import 'package:lichess_mobile/src/model/game/game_share_service.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/brightness.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
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

import '../../utils/share.dart';
import 'analysis_settings.dart';
import 'analysis_share_screen.dart';
import 'annotations.dart';
import 'tree_view.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({
    required this.options,
    required this.pgnOrId,
    this.title,
  });

  /// The analysis options.
  final AnalysisOptions options;

  /// The PGN or game ID to load.
  final String pgnOrId;

  final String? title;

  @override
  Widget build(BuildContext context) {
    return pgnOrId.length == 8 && GameId(pgnOrId).isValid
        ? _LoadGame(GameId(pgnOrId), options, title)
        : _LoadedAnalysisScreen(
            options: options,
            pgn: pgnOrId,
            title: title,
          );
  }
}

class _LoadGame extends ConsumerWidget {
  const _LoadGame(this.gameId, this.options, this.title);

  final AnalysisOptions options;
  final GameId gameId;
  final String? title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameAsync = ref.watch(archivedGameProvider(id: gameId));

    return gameAsync.when(
      data: (game) {
        final serverAnalysis =
            game.white.analysis != null && game.black.analysis != null
                ? (white: game.white.analysis!, black: game.black.analysis!)
                : null;
        return _LoadedAnalysisScreen(
          options: options.copyWith(
            id: game.id,
            opening: game.meta.opening,
            division: game.meta.division,
            serverAnalysis: serverAnalysis,
          ),
          pgn: game.makePgn(),
          title: title,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (error, _) {
        return Center(
          child: Text('Cannot load game analysis: $error'),
        );
      },
    );
  }
}

class _LoadedAnalysisScreen extends ConsumerWidget {
  const _LoadedAnalysisScreen({
    required this.options,
    required this.pgn,
    this.title,
  });

  final AnalysisOptions options;
  final String pgn;

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
    final ctrlProvider = analysisControllerProvider(pgn, options);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: _Title(options: options, title: title),
        actions: [
          _EngineDepth(ctrlProvider),
          AppBarIconButton(
            onPressed: () => showAdaptiveBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              showDragHandle: true,
              isDismissible: true,
              builder: (_) => AnalysisSettings(pgn, options),
            ),
            semanticsLabel: context.l10n.settingsSettings,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: _Body(pgn: pgn, options: options),
    );
  }

  Widget _iosBuilder(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisControllerProvider(pgn, options);

    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Styles.cupertinoScaffoldColor.resolveFrom(context),
        border: null,
        padding: Styles.cupertinoAppBarTrailingWidgetPadding,
        middle: _Title(options: options, title: title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _EngineDepth(ctrlProvider),
            AppBarIconButton(
              onPressed: () => showAdaptiveBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                showDragHandle: true,
                isDismissible: true,
                builder: (_) => AnalysisSettings(pgn, options),
              ),
              semanticsLabel: context.l10n.settingsSettings,
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
      ),
      child: _Body(pgn: pgn, options: options),
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
  const _Body({required this.pgn, required this.options});

  final String pgn;
  final AnalysisOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisControllerProvider(pgn, options);
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
                final isTablet = isTabletOrLarger(context);
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
                                _Board(
                                  pgn,
                                  options,
                                  boardSize,
                                  isTablet: isTablet,
                                ),
                                if (hasEval && showEvaluationGauge) ...[
                                  const SizedBox(width: 4.0),
                                  _EngineGaugeVertical(ctrlProvider),
                                ],
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
                                        ? ServerAnalysisSummary(pgn, options)
                                        : AnalysisTreeView(
                                            pgn,
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
                              child: _Board(
                                pgn,
                                options,
                                boardSize,
                                isTablet: isTablet,
                              ),
                            )
                          else
                            _Board(pgn, options, boardSize, isTablet: isTablet),
                          if (showAnalysisSummary)
                            Expanded(child: ServerAnalysisSummary(pgn, options))
                          else
                            Expanded(
                              child: AnalysisTreeView(
                                pgn,
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
        _BottomBar(pgn: pgn, options: options),
      ],
    );
  }
}

class _Board extends ConsumerStatefulWidget {
  const _Board(
    this.pgn,
    this.options,
    this.boardSize, {
    required this.isTablet,
  });

  final String pgn;
  final AnalysisOptions options;
  final double boardSize;
  final bool isTablet;

  @override
  ConsumerState<_Board> createState() => _BoardState();
}

class _BoardState extends ConsumerState<_Board> {
  ISet<cg.Shape> userShapes = ISet();

  ISet<cg.Shape> _computeBestMoveShapes(IList<MoveWithWinningChances> moves) {
    // Scale down all moves with index > 0 based on how much worse their winning chances are compared to the best move
    // (assume moves are ordered by their winning chances, so index==0 is the best move)
    double scaleArrowAgainstBestMove(int index) {
      const minScale = 0.15;
      const maxScale = 1.0;
      const winningDiffScaleFactor = 2.5;

      final bestMove = moves[0];
      final winningDiffComparedToBestMove =
          bestMove.winningChances - moves[index].winningChances;
      // Force minimum scale if the best move is significantly better than this move
      if (winningDiffComparedToBestMove > 0.3) {
        return minScale;
      }
      return clampDouble(
        math.max(
          minScale,
          maxScale - winningDiffScaleFactor * winningDiffComparedToBestMove,
        ),
        0,
        1,
      );
    }

    return ISet(
      moves.mapIndexed(
        (i, m) {
          final move = m.move;
          // Same colors as in the Web UI with a slightly different opacity
          // The best move has a different color than the other moves
          final color = Color((i == 0) ? 0x66003088 : 0x664A4A4A);
          switch (move) {
            case NormalMove(from: _, to: _, promotion: final promRole):
              return [
                cg.Arrow(
                  color: color,
                  orig: move.cg.from,
                  dest: move.cg.to,
                  scale: scaleArrowAgainstBestMove(i),
                ),
                if (promRole != null)
                  cg.PieceShape(
                    color: color,
                    orig: move.cg.to,
                    role: promRole.cg,
                  ),
              ];
            case DropMove(role: final role, to: _):
              return [
                cg.PieceShape(
                  color: color,
                  orig: move.cg.to,
                  role: role.cg,
                ),
              ];
          }
        },
      ).expand((e) => e),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrlProvider = analysisControllerProvider(widget.pgn, widget.options);
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

    final ISet<cg.Shape> bestMoveShapes = showBestMoveArrow &&
            analysisState.isEngineAvailable &&
            bestMoves != null
        ? _computeBestMoveShapes(bestMoves)
        : ISet();

    return cg.Board(
      size: widget.boardSize,
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
        isCheck: boardPrefs.boardHighlights && analysisState.position.isCheck,
        lastMove: analysisState.lastMove?.cg,
        sideToMove: analysisState.position.turn.cg,
        validMoves: analysisState.validMoves,
        shapes: userShapes.union(bestMoveShapes),
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
        borderRadius: widget.isTablet
            ? const BorderRadius.all(Radius.circular(4.0))
            : BorderRadius.zero,
        boxShadow: widget.isTablet ? boardShadows : const <BoxShadow>[],
        drawShape: cg.DrawShapeOptions(
          enable: true,
          onCompleteShape: _onCompleteShape,
          onClearShapes: _onClearShapes,
        ),
      ),
    );
  }

  void _onCompleteShape(cg.Shape shape) {
    if (userShapes.any((element) => element == shape)) {
      setState(() {
        userShapes = userShapes.remove(shape);
      });
      return;
    } else {
      setState(() {
        userShapes = userShapes.add(shape);
      });
    }
  }

  void _onClearShapes() {
    setState(() {
      userShapes = ISet();
    });
  }
}

class _EngineGaugeVertical extends ConsumerWidget {
  const _EngineGaugeVertical(this.ctrlProvider);

  final AnalysisControllerProvider ctrlProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisState = ref.watch(ctrlProvider);

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: EngineGauge(
        displayMode: EngineGaugeDisplayMode.vertical,
        params: analysisState.engineGaugeParams,
      ),
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

    final pieceNotation = ref.watch(pieceNotationProvider).maybeWhen(
          data: (value) => value,
          orElse: () => defaultAccountPreferences.pieceNotation,
        );

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
                  style: TextStyle(
                    fontFamily: pieceNotation == PieceNotation.symbol
                        ? 'ChessFont'
                        : null,
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
    required this.pgn,
    required this.options,
  });

  final String pgn;
  final AnalysisOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisControllerProvider(pgn, options);
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
      ref.read(analysisControllerProvider(pgn, options).notifier).userNext();
  void _moveBackward(WidgetRef ref) => ref
      .read(analysisControllerProvider(pgn, options).notifier)
      .userPrevious();

  Future<void> _showAnalysisMenu(BuildContext context, WidgetRef ref) {
    return showAdaptiveActionSheet(
      context: context,
      actions: [
        BottomSheetAction(
          makeLabel: (context) => Text(context.l10n.flipBoard),
          onPressed: (context) {
            ref
                .read(analysisControllerProvider(pgn, options).notifier)
                .toggleBoard();
          },
        ),
        BottomSheetAction(
          makeLabel: (context) => Text(context.l10n.mobileShareGamePGN),
          onPressed: (_) {
            pushPlatformRoute(
              context,
              title: context.l10n.studyShareAndExport,
              builder: (_) => AnalysisShareScreen(pgn: pgn, options: options),
            );
          },
        ),
        BottomSheetAction(
          makeLabel: (context) => Text(context.l10n.mobileSharePositionAsFEN),
          onPressed: (_) {
            launchShareDialog(
              context,
              text: ref
                  .read(analysisControllerProvider(pgn, options))
                  .position
                  .fen,
            );
          },
        ),
        if (options.gameAnyId != null)
          BottomSheetAction(
            makeLabel: (context) =>
                Text(context.l10n.screenshotCurrentPosition),
            onPressed: (_) async {
              final gameId = options.gameAnyId!.gameId;
              final state = ref.read(analysisControllerProvider(pgn, options));
              try {
                final image =
                    await ref.read(gameShareServiceProvider).screenshotPosition(
                          gameId,
                          options.orientation,
                          state.position.fen,
                          state.lastMove,
                        );
                if (context.mounted) {
                  launchShareDialog(
                    context,
                    files: [image],
                    subject: context.l10n.puzzleFromGameLink(
                      lichessUri('/$gameId').toString(),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  showPlatformSnackbar(
                    context,
                    'Failed to get GIF',
                    type: SnackBarType.error,
                  );
                }
              }
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
    final (engineName: engineName, eval: eval, state: engineState) =
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
          title: Text(engineName),
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
  const ServerAnalysisSummary(this.pgn, this.options);

  final String pgn;
  final AnalysisOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisControllerProvider(pgn, options);
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
              AcplChart(pgn, options),
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
                            Center(
                              child: Text(
                                pgnHeaders.get('Result') ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
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
                                                  if (context.mounted) {
                                                    showPlatformSnackbar(
                                                      context,
                                                      e.toString(),
                                                      type: SnackBarType.error,
                                                    );
                                                  }
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
      verticalAlignment: TableCellVerticalAlignment.top,
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
  const AcplChart(this.pgn, this.options);

  final String pgn;
  final AnalysisOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainLineColor = Theme.of(context).colorScheme.secondary;
    // yes it looks like below/above are inverted in fl_chart
    final brightness = Theme.of(context).brightness;
    final white = Theme.of(context).colorScheme.surfaceContainerHighest;
    final black = Theme.of(context).colorScheme.outline;
    // yes it looks like below/above are inverted in fl_chart
    final belowLineColor = brightness == Brightness.light ? white : black;
    final aboveLineColor = brightness == Brightness.light ? black : white;

    VerticalLine phaseVerticalBar(double x, String label) => VerticalLine(
          x: x,
          color: const Color(0xFF707070),
          strokeWidth: 0.5,
          label: VerticalLineLabel(
            style: TextStyle(
              fontSize: 10,
              color: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.color
                  ?.withOpacity(0.3),
            ),
            labelResolver: (line) => label,
            padding: const EdgeInsets.only(right: 1),
            alignment: Alignment.topRight,
            direction: LabelDirection.vertical,
            show: true,
          ),
        );

    final data = ref.watch(
      analysisControllerProvider(pgn, options)
          .select((value) => value.acplChartData),
    );

    final rootPly = ref.watch(
      analysisControllerProvider(pgn, options)
          .select((value) => value.root.position.ply),
    );

    final currentNode = ref.watch(
      analysisControllerProvider(pgn, options)
          .select((value) => value.currentNode),
    );

    final isOnMainline = ref.watch(
      analysisControllerProvider(pgn, options)
          .select((value) => value.isOnMainline),
    );

    if (data == null) {
      return const SizedBox.shrink();
    }

    final spots = data
        .mapIndexed(
          (i, e) => FlSpot(i.toDouble(), e.winningChances(Side.white)),
        )
        .toList(growable: false);

    final divisionLines = <VerticalLine>[];

    if (options.division?.middlegame != null) {
      if (options.division!.middlegame! > 0) {
        divisionLines.add(phaseVerticalBar(0.0, context.l10n.opening));
        divisionLines.add(
          phaseVerticalBar(
            options.division!.middlegame! - 1,
            context.l10n.middlegame,
          ),
        );
      } else {
        divisionLines.add(phaseVerticalBar(0.0, context.l10n.middlegame));
      }
    }

    if (options.division?.endgame != null) {
      if (options.division!.endgame! > 0) {
        divisionLines.add(
          phaseVerticalBar(
            options.division!.endgame! - 1,
            context.l10n.endgame,
          ),
        );
      } else {
        divisionLines.add(
          phaseVerticalBar(
            0.0,
            context.l10n.endgame,
          ),
        );
      }
    }
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
                  if (event is FlTapDownEvent ||
                      event is FlPanUpdateEvent ||
                      event is FlLongPressMoveUpdate) {
                    final touchX = event.localPosition!.dx;
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
                        .read(analysisControllerProvider(pgn, options).notifier)
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
                  color: mainLineColor.withOpacity(0.7),
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
                      x: (currentNode.position.ply - 1 - rootPly).toDouble(),
                      color: mainLineColor,
                      strokeWidth: 1.0,
                    ),
                  ...divisionLines,
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
