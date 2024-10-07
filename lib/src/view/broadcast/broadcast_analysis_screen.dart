import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/analysis/server_analysis_service.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_game_controller.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_round_controller.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/engine/engine.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/model/game/game_share_service.dart';
import 'package:lichess_mobile/src/model/settings/brightness.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/connectivity.dart';
import 'package:lichess_mobile/src/utils/duration.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/lichess_assets.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/utils/string.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_board.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_settings.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_share_screen.dart';
import 'package:lichess_mobile/src/view/analysis/tree_view.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';
import 'package:lichess_mobile/src/view/opening_explorer/opening_explorer_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar_button.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:popover/popover.dart';

class BroadcastAnalysisScreen extends ConsumerWidget {
  final BroadcastRoundId roundId;
  final BroadcastGameId gameId;
  final String title;

  const BroadcastAnalysisScreen({
    required this.roundId,
    required this.gameId,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConsumerPlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
      ref: ref,
    );
  }

  Widget _androidBuilder(BuildContext context, WidgetRef ref) {
    final pgn = ref.watch(
      broadcastGameControllerProvider(
        roundId,
        gameId,
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (pgn.hasValue)
            _EngineDepth(
              analysisControllerProvider(
                pgn.requireValue,
                AnalysisState.broadcastOptions,
              ),
            ),
          AppBarIconButton(
            onPressed: () => (pgn.hasValue)
                ? showAdaptiveBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    showDragHandle: true,
                    isDismissible: true,
                    builder: (_) => AnalysisSettings(
                      pgn.requireValue,
                      AnalysisState.broadcastOptions,
                    ),
                  )
                : null,
            semanticsLabel: context.l10n.settingsSettings,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: pgn.when(
        data: (pgn) => _Body(
          roundId: roundId,
          gameId: gameId,
          pgn: pgn,
        ),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, _) {
          return Center(
            child: Text('Cannot load game analysis: $error'),
          );
        },
      ),
    );
  }

  Widget _iosBuilder(BuildContext context, WidgetRef ref) {
    final pgn = ref.watch(
      broadcastGameControllerProvider(
        roundId,
        gameId,
      ),
    );

    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Styles.cupertinoScaffoldColor.resolveFrom(context),
        border: null,
        padding: Styles.cupertinoAppBarTrailingWidgetPadding,
        middle: Text(title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (pgn.hasValue)
              _EngineDepth(
                analysisControllerProvider(
                  pgn.requireValue,
                  AnalysisState.broadcastOptions,
                ),
              ),
            AppBarIconButton(
              onPressed: () => (pgn.hasValue)
                  ? showAdaptiveBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      showDragHandle: true,
                      isDismissible: true,
                      builder: (_) => AnalysisSettings(
                        pgn.requireValue,
                        AnalysisState.broadcastOptions,
                      ),
                    )
                  : null,
              semanticsLabel: context.l10n.settingsSettings,
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
      ),
      child: pgn.when(
        data: (pgn) => _Body(
          roundId: roundId,
          gameId: gameId,
          pgn: pgn,
        ),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, _) {
          return Center(
            child: Text('Cannot load game analysis: $error'),
          );
        },
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({
    required this.roundId,
    required this.gameId,
    required this.pgn,
  });

  final BroadcastRoundId roundId;
  final BroadcastGameId gameId;
  final String pgn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider =
        analysisControllerProvider(pgn, AnalysisState.broadcastOptions);
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

    final displayMode =
        ref.watch(ctrlProvider.select((value) => value.displayMode));

    final pov = ref.watch(ctrlProvider.select((value) => value.pov));

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

                const tabletBoardRadius =
                    BorderRadius.all(Radius.circular(4.0));

                final display = switch (displayMode) {
                  DisplayMode.summary =>
                    ServerAnalysisSummary(pgn, AnalysisState.broadcastOptions),
                  DisplayMode.moves => AnalysisTreeView(
                      pgn,
                      AnalysisState.broadcastOptions,
                      aspectRatio > 1
                          ? Orientation.landscape
                          : Orientation.portrait,
                    ),
                };

                // If the aspect ratio is greater than 1, we are in landscape mode.
                if (aspectRatio > 1) {
                  return Row(
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
                            _AnalysisBoardPlayersAndClocks(
                              ctrlProvider,
                              roundId,
                              gameId,
                              pgn,
                              pov,
                              boardSize,
                              borderRadius: isTablet ? tabletBoardRadius : null,
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
                                clipBehavior: Clip.hardEdge,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(4.0),
                                ),
                                margin: const EdgeInsets.all(
                                  kTabletBoardTableSidePadding,
                                ),
                                semanticContainer: false,
                                child: display,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                // If the aspect ratio is less than 1, we are in portrait mode.
                else {
                  return Column(
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
                          child: _AnalysisBoardPlayersAndClocks(
                            ctrlProvider,
                            roundId,
                            gameId,
                            pgn,
                            pov,
                            boardSize,
                            borderRadius: isTablet ? tabletBoardRadius : null,
                          ),
                        )
                      else
                        _AnalysisBoardPlayersAndClocks(
                          ctrlProvider,
                          roundId,
                          gameId,
                          pgn,
                          pov,
                          boardSize,
                          borderRadius: isTablet ? tabletBoardRadius : null,
                        ),
                      Expanded(
                        child: Padding(
                          padding: isTablet
                              ? const EdgeInsets.symmetric(
                                  horizontal: kTabletBoardTableSidePadding,
                                )
                              : EdgeInsets.zero,
                          child: display,
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
        _BottomBar(pgn: pgn, options: AnalysisState.broadcastOptions),
      ],
    );
  }
}

enum _PlayerWidgetSide { bottom, top }

class _AnalysisBoardPlayersAndClocks extends ConsumerWidget {
  final AnalysisControllerProvider ctrlProvider;
  final BroadcastRoundId roundId;
  final BroadcastGameId gameId;
  final String pgn;
  final Side pov;
  final double boardSize;
  final BorderRadius? borderRadius;

  const _AnalysisBoardPlayersAndClocks(
    this.ctrlProvider,
    this.roundId,
    this.gameId,
    this.pgn,
    this.pov,
    this.boardSize, {
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clocks = ref.watch(ctrlProvider.select((value) => value.clocks));
    final currentPath = ref.watch(
      ctrlProvider.select((value) => value.currentPath),
    );
    final livePath = ref.watch(
      ctrlProvider.select((value) => value.livePath),
    );
    final playingSide =
        ref.watch(ctrlProvider.select((value) => value.position.turn));
    final game = ref.watch(
      broadcastRoundControllerProvider(roundId)
          .select((game) => game.value?[gameId]),
    );

    return Column(
      children: [
        if (game != null)
          _PlayerWidget(
            clock: (playingSide == pov.opposite)
                ? clocks?.parentClock
                : clocks?.clock,
            width: boardSize,
            game: game,
            side: pov.opposite,
            boardSide: _PlayerWidgetSide.top,
            playingSide: playingSide,
            playClock: currentPath == livePath,
          ),
        AnalysisBoard(
          pgn,
          AnalysisState.broadcastOptions,
          boardSize,
          borderRadius: borderRadius,
        ),
        if (game != null)
          _PlayerWidget(
            clock: (playingSide == pov) ? clocks?.parentClock : clocks?.clock,
            width: boardSize,
            game: game,
            side: pov,
            boardSide: _PlayerWidgetSide.bottom,
            playingSide: playingSide,
            playClock: currentPath == livePath,
          ),
      ],
    );
  }
}

class _PlayerWidget extends StatelessWidget {
  const _PlayerWidget({
    required this.width,
    required this.clock,
    required this.game,
    required this.side,
    required this.boardSide,
    required this.playingSide,
    required this.playClock,
  });

  final BroadcastGame game;
  final Duration? clock;
  final Side side;
  final double width;
  final _PlayerWidgetSide boardSide;
  final Side playingSide;
  final bool playClock;

  @override
  Widget build(BuildContext context) {
    final player = game.players[side]!;
    final gameStatus = game.status;

    return SizedBox(
      width: width,
      child: Row(
        children: [
          if (gameStatus != null && gameStatus != '*')
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    boardSide == _PlayerWidgetSide.top ? 8 : 0,
                  ),
                  bottomLeft: Radius.circular(
                    boardSide == _PlayerWidgetSide.bottom ? 8 : 0,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                child: Text(
                  (gameStatus == '½-½')
                      ? '½'
                      : (gameStatus == '1-0')
                          ? side == Side.white
                              ? '1'
                              : '0'
                          : side == Side.black
                              ? '1'
                              : '0',
                  style:
                      const TextStyle().copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          Expanded(
            child: Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    boardSide == _PlayerWidgetSide.top &&
                            (gameStatus == null || gameStatus == '*')
                        ? 8
                        : 0,
                  ),
                  topRight: Radius.circular(
                    boardSide == _PlayerWidgetSide.top && clock == null ? 8 : 0,
                  ),
                  bottomLeft: Radius.circular(
                    boardSide == _PlayerWidgetSide.bottom &&
                            (gameStatus == null || gameStatus == '*')
                        ? 8
                        : 0,
                  ),
                  bottomRight: Radius.circular(
                    boardSide == _PlayerWidgetSide.bottom && clock == null
                        ? 8
                        : 0,
                  ),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          if (player.federation != null) ...[
                            Consumer(
                              builder: (context, widgetRef, _) {
                                return SvgPicture.network(
                                  lichessFideFedSrc(player.federation!),
                                  height: 12,
                                  httpClient:
                                      widgetRef.read(defaultClientProvider),
                                );
                              },
                            ),
                            const SizedBox(width: 5),
                          ],
                          if (player.title != null) ...[
                            Text(
                              player.title!,
                              style: const TextStyle().copyWith(
                                color: context.lichessColors.brag,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 5),
                          ],
                          Text(
                            player.name,
                            style: const TextStyle().copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (player.rating != null) ...[
                            const SizedBox(width: 5),
                            Text(
                              player.rating.toString(),
                              style: const TextStyle(),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (((side == playingSide && playClock) && game.timeLeft != null) ||
              (!(side == playingSide && playClock) && clock != null))
            Card(
              color: (side == playingSide)
                  ? playClock
                      ? Theme.of(context).colorScheme.tertiaryContainer
                      : Theme.of(context).colorScheme.secondaryContainer
                  : null,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(
                    boardSide == _PlayerWidgetSide.top ? 8 : 0,
                  ),
                  bottomRight: Radius.circular(
                    boardSide == _PlayerWidgetSide.bottom ? 8 : 0,
                  ),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: (side == playingSide && playClock)
                    ? Text(
                        game.timeLeft!.toHoursMinutesSeconds(),
                        style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onTertiaryContainer,
                          fontFeatures: const [
                            FontFeature.tabularFigures(),
                          ],
                        ),
                      )
                    : Text(
                        clock!.toHoursMinutesSeconds(),
                        style: TextStyle(
                          color: (side == playingSide)
                              ? Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer
                              : null,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
              ),
            ),
        ],
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
          .onUserMove(NormalMove.fromUci(pvData.moves[0])),
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
    final analysisState = ref.watch(ctrlProvider);
    final isOnline =
        ref.watch(connectivityChangesProvider).valueOrNull?.isOnline ?? false;

    return BottomBar(
      children: [
        BottomBarButton(
          label: context.l10n.menu,
          onTap: () {
            _showAnalysisMenu(context, ref);
          },
          icon: Icons.menu,
        ),
        if (analysisState.canShowGameSummary)
          BottomBarButton(
            // TODO: l10n
            label: analysisState.displayMode == DisplayMode.summary
                ? 'Moves'
                : 'Summary',
            onTap: () {
              final newMode = analysisState.displayMode == DisplayMode.summary
                  ? DisplayMode.moves
                  : DisplayMode.summary;
              ref.read(ctrlProvider.notifier).setDisplayMode(newMode);
            },
            icon: analysisState.displayMode == DisplayMode.summary
                ? LichessIcons.flow_cascade
                : Icons.area_chart,
          ),
        BottomBarButton(
          label: context.l10n.openingExplorer,
          onTap: isOnline
              ? () {
                  pushPlatformRoute(
                    context,
                    title: context.l10n.openingExplorer,
                    builder: (_) => OpeningExplorerScreen(
                      pgn: ref.read(ctrlProvider.notifier).makeCurrentNodePgn(),
                      options: analysisState.openingExplorerOptions,
                    ),
                  );
                }
              : null,
          icon: Icons.explore,
        ),
        RepeatButton(
          onLongPress:
              analysisState.canGoBack ? () => _moveBackward(ref) : null,
          child: BottomBarButton(
            key: const ValueKey('goto-previous'),
            onTap: analysisState.canGoBack ? () => _moveBackward(ref) : null,
            label: 'Previous',
            icon: CupertinoIcons.chevron_back,
            showTooltip: false,
          ),
        ),
        RepeatButton(
          onLongPress: analysisState.canGoNext ? () => _moveForward(ref) : null,
          child: BottomBarButton(
            key: const ValueKey('goto-next'),
            icon: CupertinoIcons.chevron_forward,
            label: context.l10n.next,
            onTap: analysisState.canGoNext ? () => _moveForward(ref) : null,
            showTooltip: false,
          ),
        ),
      ],
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
                  ?.withValues(alpha: 0.3),
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
                  color: mainLineColor.withValues(alpha: 0.7),
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
