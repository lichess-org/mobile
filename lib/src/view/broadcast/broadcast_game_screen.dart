import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_analysis_controller.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_repository.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/model/game/game_share_service.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/duration.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_layout.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_game_screen_providers.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_game_settings_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_player_results_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_player_widget.dart';
import 'package:lichess_mobile/src/view/engine/engine_depth.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';
import 'package:lichess_mobile/src/view/engine/engine_lines.dart';
import 'package:lichess_mobile/src/view/opening_explorer/opening_explorer_view.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar_button.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/clock.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/pgn.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';

class BroadcastGameScreen extends ConsumerStatefulWidget {
  final BroadcastTournamentId? tournamentId;
  final BroadcastRoundId roundId;
  final BroadcastGameId gameId;
  final String? tournamentSlug;
  final String? roundSlug;
  final String? title;

  const BroadcastGameScreen({
    this.tournamentId,
    required this.roundId,
    required this.gameId,
    this.tournamentSlug,
    this.roundSlug,
    this.title,
  });

  static Route<dynamic> buildRoute(
    BuildContext context, {
    BroadcastTournamentId? tournamentId,
    required BroadcastRoundId roundId,
    required BroadcastGameId gameId,
    String? tournamentSlug,
    String? roundSlug,
    String? title,
  }) {
    return buildScreenRoute(
      context,
      screen: BroadcastGameScreen(
        tournamentId: tournamentId,
        roundId: roundId,
        gameId: gameId,
        tournamentSlug: tournamentSlug,
        roundSlug: roundSlug,
        title: title,
      ),
    );
  }

  @override
  ConsumerState<BroadcastGameScreen> createState() => _BroadcastGameScreenState();
}

class _BroadcastGameScreenState extends ConsumerState<BroadcastGameScreen>
    with SingleTickerProviderStateMixin {
  late final List<AnalysisTab> tabs;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();

    tabs = [AnalysisTab.opening, AnalysisTab.moves];

    _tabController = TabController(vsync: this, initialIndex: 1, length: tabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title =
        (widget.title != null)
            ? Text(widget.title!, overflow: TextOverflow.ellipsis, maxLines: 1)
            : switch (ref.watch(broadcastGameScreenTitleProvider(widget.roundId))) {
              AsyncData(value: final title) => Text(
                title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              _ => const SizedBox.shrink(),
            };
    final asyncEval = ref.watch(broadcastGameEvalProvider(widget.roundId, widget.gameId));
    final asyncIsEngineAvailable = ref.watch(
      isBroadcastEngineAvailableProvider(widget.roundId, widget.gameId),
    );

    return PlatformScaffold(
      appBarEnableBackgroundFilterBlur: false,
      appBarTitle: title,
      appBarActions: [
        if (asyncIsEngineAvailable.valueOrNull == true)
          EngineDepth(savedEval: asyncEval.valueOrNull),
        AppBarAnalysisTabIndicator(tabs: tabs, controller: _tabController),
        AppBarIconButton(
          onPressed: () {
            Navigator.of(context).push(
              BroadcastGameSettingsScreen.buildRoute(
                context,
                roundId: widget.roundId,
                gameId: widget.gameId,
              ),
            );
          },
          semanticsLabel: context.l10n.settingsSettings,
          icon: const Icon(Icons.settings),
        ),
      ],
      body: _Body(
        widget.tournamentId,
        widget.roundId,
        widget.gameId,
        widget.tournamentSlug,
        widget.roundSlug,
        tabController: _tabController,
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body(
    this.tournamentId,
    this.roundId,
    this.gameId,
    this.tournamentSlug,
    this.roundSlug, {
    required this.tabController,
  });

  final BroadcastTournamentId? tournamentId;
  final BroadcastRoundId roundId;
  final BroadcastGameId gameId;
  final String? tournamentSlug;
  final String? roundSlug;
  final TabController tabController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (ref.watch(broadcastAnalysisControllerProvider(roundId, gameId))) {
      case AsyncValue(value: final state?, hasValue: true):
        final analysisPrefs = ref.watch(analysisPreferencesProvider);
        final enginePrefs = ref.watch(engineEvaluationPreferencesProvider);
        final showEvaluationGauge = analysisPrefs.showEvaluationGauge;
        final numEvalLines = enginePrefs.numEvalLines;

        final engineGaugeParams = state.engineGaugeParams(enginePrefs);
        final isLocalEvaluationEnabled = state.isEngineAvailable(enginePrefs);
        final currentNode = state.currentNode;
        final pov = state.pov;

        return AnalysisLayout(
          smallBoard: analysisPrefs.smallBoard,
          pov: pov,
          tabController: tabController,
          boardBuilder:
              (context, boardSize, borderRadius) =>
                  _BroadcastBoard(roundId, gameId, boardSize, borderRadius),
          boardHeader: _PlayerWidget(
            tournamentId: tournamentId,
            roundId: roundId,
            gameId: gameId,
            widgetPosition: _PlayerWidgetPosition.top,
          ),
          boardFooter: _PlayerWidget(
            tournamentId: tournamentId,
            roundId: roundId,
            gameId: gameId,
            widgetPosition: _PlayerWidgetPosition.bottom,
          ),
          engineGaugeBuilder:
              state.hasAvailableEval(enginePrefs) && showEvaluationGauge
                  ? (context, orientation) {
                    return orientation == Orientation.portrait
                        ? EngineGauge(
                          displayMode: EngineGaugeDisplayMode.horizontal,
                          params: engineGaugeParams,
                        )
                        : Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.0)),
                          child: EngineGauge(
                            displayMode: EngineGaugeDisplayMode.vertical,
                            params: engineGaugeParams,
                          ),
                        );
                  }
                  : null,
          engineLines:
              isLocalEvaluationEnabled && numEvalLines > 0
                  ? EngineLines(
                    savedEval: currentNode.eval,
                    isGameOver: currentNode.position.isGameOver,
                    onTapMove:
                        ref
                            .read(broadcastAnalysisControllerProvider(roundId, gameId).notifier)
                            .onUserMove,
                  )
                  : null,
          bottomBar: _BroadcastGameBottomBar(
            roundId: roundId,
            gameId: gameId,
            tournamentSlug: tournamentSlug,
            roundSlug: roundSlug,
          ),
          children: [_OpeningExplorerTab(roundId, gameId), _BroadcastGameTreeView(roundId, gameId)],
        );
      case AsyncValue(:final error?):
        return Center(child: Text('Cannot load broadcast game: $error'));
      case _:
        return const Center(child: CircularProgressIndicator.adaptive());
    }
  }
}

class _BroadcastGameTreeView extends ConsumerWidget {
  const _BroadcastGameTreeView(this.roundId, this.gameId);

  final BroadcastRoundId roundId;
  final BroadcastGameId gameId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = broadcastAnalysisControllerProvider(roundId, gameId);
    final state = ref.watch(ctrlProvider).requireValue;

    final analysisPrefs = ref.watch(analysisPreferencesProvider);

    return SingleChildScrollView(
      child: DebouncedPgnTreeView(
        root: state.root,
        currentPath: state.currentPath,
        broadcastLivePath: state.broadcastLivePath,
        pgnRootComments: state.pgnRootComments,
        shouldShowComputerVariations: analysisPrefs.enableComputerAnalysis,
        shouldShowComments: analysisPrefs.enableComputerAnalysis && analysisPrefs.showPgnComments,
        shouldShowAnnotations: analysisPrefs.showAnnotations,
        notifier: ref.read(ctrlProvider.notifier),
        displayMode:
            analysisPrefs.inlineNotation
                ? PgnTreeDisplayMode.inlineNotation
                : PgnTreeDisplayMode.twoColumn,
      ),
    );
  }
}

class _OpeningExplorerTab extends ConsumerWidget {
  const _OpeningExplorerTab(this.roundId, this.gameId);

  final BroadcastRoundId roundId;
  final BroadcastGameId gameId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = broadcastAnalysisControllerProvider(roundId, gameId);
    final state = ref.watch(ctrlProvider).requireValue;

    return OpeningExplorerView(
      position: state.currentNode.position,
      onMoveSelected: ref.read(ctrlProvider.notifier).onUserMove,
    );
  }
}

class _BroadcastBoard extends ConsumerStatefulWidget {
  const _BroadcastBoard(this.roundId, this.gameId, this.boardSize, this.borderRadius);

  final BroadcastRoundId roundId;
  final BroadcastGameId gameId;
  final double boardSize;
  final BorderRadiusGeometry? borderRadius;

  @override
  ConsumerState<_BroadcastBoard> createState() => _BroadcastBoardState();
}

class _BroadcastBoardState extends ConsumerState<_BroadcastBoard> {
  ISet<Shape> userShapes = ISet();

  @override
  Widget build(BuildContext context) {
    final ctrlProvider = broadcastAnalysisControllerProvider(widget.roundId, widget.gameId);
    final broadcastAnalysisState = ref.watch(ctrlProvider).requireValue;
    final boardPrefs = ref.watch(boardPreferencesProvider);
    final analysisPrefs = ref.watch(analysisPreferencesProvider);
    final enginePrefs = ref.watch(engineEvaluationPreferencesProvider);

    final currentNode = broadcastAnalysisState.currentNode;
    final annotation = makeAnnotation(currentNode.nags);

    final localBestMoves = ref.watch(
      engineEvaluationProvider.select((value) => value.eval?.bestMoves),
    );
    final bestMoves = pickBestMoves(localBestMoves: localBestMoves, savedEval: currentNode.eval);

    final sanMove = currentNode.sanMove;

    final ISet<Shape> bestMoveShapes =
        analysisPrefs.showBestMoveArrow &&
                broadcastAnalysisState.isEngineAvailable(enginePrefs) &&
                bestMoves != null
            ? computeBestMoveShapes(
              bestMoves,
              currentNode.position.turn,
              boardPrefs.pieceSet.assets,
            )
            : ISet();

    return Chessboard(
      size: widget.boardSize,
      fen: broadcastAnalysisState.position.fen,
      lastMove: broadcastAnalysisState.lastMove as NormalMove?,
      orientation: broadcastAnalysisState.pov,
      game: GameData(
        playerSide:
            broadcastAnalysisState.position.isGameOver
                ? PlayerSide.none
                : broadcastAnalysisState.position.turn == Side.white
                ? PlayerSide.white
                : PlayerSide.black,
        isCheck: boardPrefs.boardHighlights && broadcastAnalysisState.position.isCheck,
        sideToMove: broadcastAnalysisState.position.turn,
        validMoves: broadcastAnalysisState.validMoves,
        promotionMove: broadcastAnalysisState.promotionMove,
        onMove: (move, {isDrop, captured}) => ref.read(ctrlProvider.notifier).onUserMove(move),
        onPromotionSelection: (role) => ref.read(ctrlProvider.notifier).onPromotionSelection(role),
      ),
      shapes: userShapes.union(bestMoveShapes),
      annotations:
          analysisPrefs.showAnnotations && sanMove != null && annotation != null
              ? altCastles.containsKey(sanMove.move.uci)
                  ? IMap({Move.parse(altCastles[sanMove.move.uci]!)!.to: annotation})
                  : IMap({sanMove.move.to: annotation})
              : null,
      settings: boardPrefs.toBoardSettings().copyWith(
        borderRadius: widget.borderRadius,
        boxShadow: widget.borderRadius != null ? boardShadows : const <BoxShadow>[],
        drawShape: DrawShapeOptions(
          enable: boardPrefs.enableShapeDrawings,
          onCompleteShape: _onCompleteShape,
          onClearShapes: _onClearShapes,
          newShapeColor: boardPrefs.shapeColor.color,
        ),
      ),
    );
  }

  void _onCompleteShape(Shape shape) {
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

enum _PlayerWidgetPosition { bottom, top }

class _PlayerWidget extends ConsumerWidget {
  const _PlayerWidget({
    this.tournamentId,
    required this.roundId,
    required this.gameId,
    required this.widgetPosition,
  });

  final BroadcastTournamentId? tournamentId;
  final BroadcastRoundId roundId;
  final BroadcastGameId gameId;
  final _PlayerWidgetPosition widgetPosition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (ref.watch(broadcastRoundGameProvider(roundId, gameId))) {
      case AsyncValue(value: final game?, hasValue: true):
        final broadcastAnalysisState =
            ref.watch(broadcastAnalysisControllerProvider(roundId, gameId)).requireValue;

        final isCursorOnLiveMove =
            broadcastAnalysisState.currentPath == broadcastAnalysisState.broadcastLivePath;
        final sideToMove = broadcastAnalysisState.position.turn;
        final side = switch (widgetPosition) {
          _PlayerWidgetPosition.bottom => broadcastAnalysisState.pov,
          _PlayerWidgetPosition.top => broadcastAnalysisState.pov.opposite,
        };

        final player = game.players[side]!;
        final liveClock = isCursorOnLiveMove ? player.clock : null;
        final isClockActive = isCursorOnLiveMove && game.isOngoing && side == sideToMove;

        final pastClocks = broadcastAnalysisState.clocks;
        final pastClock = (sideToMove == side) ? pastClocks?.parentClock : pastClocks?.clock;

        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              (tournamentId != null)
                  ? BroadcastPlayerResultsScreen.buildRoute(
                    context,
                    tournamentId!,
                    (player.fideId != null) ? player.fideId!.toString() : player.name,
                    playerTitle: player.title,
                    playerName: player.name,
                  )
                  : BroadcastPlayerResultsScreenLoading.buildRoute(
                    context,
                    roundId,
                    (player.fideId != null) ? player.fideId!.toString() : player.name,
                    playerTitle: player.title,
                    playerName: player.name,
                  ),
            );
          },
          child: Container(
            color: ColorScheme.of(context).surfaceContainer,
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                if (game.isOver) ...[
                  Text(
                    game.status.resultToString(side),
                    style: const TextStyle().copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 16.0),
                ],
                Expanded(
                  child: BroadcastPlayerWidget(
                    federation: player.federation,
                    title: player.title,
                    name: player.name,
                    rating: player.rating,
                    textStyle: const TextStyle().copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                if (liveClock != null || pastClock != null)
                  Container(
                    height: kAnalysisBoardHeaderOrFooterHeight,
                    color:
                        isClockActive
                            ? ColorScheme.of(context).tertiaryContainer
                            : (side == sideToMove)
                            ? ColorScheme.of(context).secondaryContainer
                            : Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: Center(
                        child:
                            liveClock != null
                                ? CountdownClockBuilder(
                                  timeLeft: liveClock,
                                  active: isClockActive,
                                  builder:
                                      (context, timeLeft) => _Clock(
                                        timeLeft: timeLeft,
                                        isSideToMove: side == sideToMove,
                                        isClockActive: isClockActive,
                                      ),
                                  tickInterval: const Duration(seconds: 1),
                                  clockUpdatedAt: game.updatedClockAt,
                                )
                                : _Clock(
                                  timeLeft: pastClock!,
                                  isSideToMove: side == sideToMove,
                                  isClockActive: false,
                                ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      case AsyncValue(:final error?):
        return Text('Cannot load player data: $error');
      case _:
        return const SizedBox.shrink();
    }
  }
}

class _Clock extends StatelessWidget {
  const _Clock({required this.timeLeft, required this.isSideToMove, required this.isClockActive});

  final Duration timeLeft;
  final bool isSideToMove;
  final bool isClockActive;

  @override
  Widget build(BuildContext context) {
    return Text(
      timeLeft.toHoursMinutesSeconds(),
      style: TextStyle(
        color:
            isClockActive
                ? ColorScheme.of(context).tertiaryContainer
                : isSideToMove
                ? ColorScheme.of(context).secondaryContainer
                : null,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}

class _BroadcastGameBottomBar extends ConsumerWidget {
  const _BroadcastGameBottomBar({
    required this.roundId,
    required this.gameId,
    this.tournamentSlug,
    this.roundSlug,
  });

  final BroadcastRoundId roundId;
  final BroadcastGameId gameId;
  final String? tournamentSlug;
  final String? roundSlug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisPrefs = ref.watch(analysisPreferencesProvider);
    final enginePrefs = ref.watch(engineEvaluationPreferencesProvider);
    final ctrlProvider = broadcastAnalysisControllerProvider(roundId, gameId);
    final broadcastAnalysisState = ref.watch(ctrlProvider).requireValue;

    return PlatformBottomBar(
      transparentBackground: false,
      children: [
        BottomBarButton(
          label: context.l10n.menu,
          onTap: () {
            showAdaptiveActionSheet<void>(
              context: context,
              actions: [
                if (tournamentSlug != null && roundSlug != null)
                  BottomSheetAction(
                    makeLabel: (context) => Text(context.l10n.mobileShareGameURL),
                    onPressed: () {
                      launchShareDialog(
                        context,
                        uri: lichessUri('/broadcast/$tournamentSlug/$roundSlug/$roundId/$gameId'),
                      );
                    },
                  ),
                BottomSheetAction(
                  makeLabel: (context) => Text(context.l10n.mobileShareGamePGN),
                  onPressed: () async {
                    try {
                      final pgn = await ref.withClient(
                        (client) => BroadcastRepository(client).getGamePgn(roundId, gameId),
                      );
                      if (context.mounted) {
                        launchShareDialog(context, text: pgn);
                      }
                    } catch (e) {
                      if (context.mounted) {
                        showPlatformSnackbar(
                          context,
                          'Failed to get PGN',
                          type: SnackBarType.error,
                        );
                      }
                    }
                  },
                ),
                BottomSheetAction(
                  makeLabel: (context) => Text(context.l10n.gameAsGIF),
                  onPressed: () async {
                    try {
                      final gif = await ref
                          .read(gameShareServiceProvider)
                          .chapterGif(roundId, gameId);
                      if (context.mounted) {
                        launchShareDialog(context, files: [gif]);
                      }
                    } catch (e) {
                      debugPrint(e.toString());
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
          },
          icon: Icons.menu,
        ),
        BottomBarButton(
          label: context.l10n.toggleLocalEvaluation,
          onTap:
              analysisPrefs.enableComputerAnalysis
                  ? () {
                    ref.read(ctrlProvider.notifier).toggleEngine();
                  }
                  : null,
          icon: CupertinoIcons.gauge,
          highlighted: broadcastAnalysisState.isEngineAvailable(enginePrefs),
        ),
        BottomBarButton(
          label: context.l10n.flipBoard,
          onTap: () {
            ref.read(ctrlProvider.notifier).toggleBoard();
          },
          icon: CupertinoIcons.arrow_2_squarepath,
        ),
        RepeatButton(
          onLongPress: broadcastAnalysisState.canGoBack ? () => _moveBackward(ref) : null,
          child: BottomBarButton(
            key: const ValueKey('goto-previous'),
            onTap: broadcastAnalysisState.canGoBack ? () => _moveBackward(ref) : null,
            label: 'Previous',
            icon: CupertinoIcons.chevron_back,
            showTooltip: false,
          ),
        ),
        RepeatButton(
          onLongPress: broadcastAnalysisState.canGoNext ? () => _moveForward(ref) : null,
          child: BottomBarButton(
            key: const ValueKey('goto-next'),
            icon: CupertinoIcons.chevron_forward,
            label: context.l10n.next,
            onTap: broadcastAnalysisState.canGoNext ? () => _moveForward(ref) : null,
            showTooltip: false,
          ),
        ),
      ],
    );
  }

  void _moveForward(WidgetRef ref) =>
      ref.read(broadcastAnalysisControllerProvider(roundId, gameId).notifier).userNext();
  void _moveBackward(WidgetRef ref) =>
      ref.read(broadcastAnalysisControllerProvider(roundId, gameId).notifier).userPrevious();
}
