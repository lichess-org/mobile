import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_game_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/duration.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_layout.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_game_bottom_bar.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_game_screen_providers.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_game_settings.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_game_tree_view.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_player_results_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_player_widget.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';
import 'package:lichess_mobile/src/view/engine/engine_lines.dart';
import 'package:lichess_mobile/src/view/opening_explorer/opening_explorer_view.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/clock.dart';
import 'package:lichess_mobile/src/widgets/pgn.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';

class BroadcastGameScreen extends ConsumerStatefulWidget {
  final BroadcastTournamentId tournamentId;
  final BroadcastRoundId roundId;
  final BroadcastGameId gameId;
  final String? tournamentSlug;
  final String? roundSlug;
  final String? title;

  const BroadcastGameScreen({
    required this.tournamentId,
    required this.roundId,
    required this.gameId,
    this.tournamentSlug,
    this.roundSlug,
    this.title,
  });

  @override
  ConsumerState<BroadcastGameScreen> createState() =>
      _BroadcastGameScreenState();
}

class _BroadcastGameScreenState extends ConsumerState<BroadcastGameScreen>
    with SingleTickerProviderStateMixin {
  late final List<AnalysisTab> tabs;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();

    tabs = [
      AnalysisTab.opening,
      AnalysisTab.moves,
    ];

    _tabController = TabController(
      vsync: this,
      initialIndex: 1,
      length: tabs.length,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final broadcastGameState = ref.watch(
      broadcastGameProvider(widget.roundId, widget.gameId),
    );
    final broadcastGamePgn = ref
        .watch(broadcastGameControllerProvider(widget.roundId, widget.gameId));
    final title = (widget.title != null)
        ? Text(
            widget.title!,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          )
        : switch (ref.watch(broadcastGameScreenTitleProvider(widget.roundId))) {
            AsyncData(value: final title) => Text(
                title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            _ => const SizedBox.shrink(),
          };

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: title,
        actions: [
          AppBarAnalysisTabIndicator(
            tabs: tabs,
            controller: _tabController,
          ),
          AppBarIconButton(
            onPressed: (broadcastGamePgn.hasValue)
                ? () {
                    pushPlatformRoute(
                      context,
                      screen: BroadcastGameSettings(
                        widget.roundId,
                        widget.gameId,
                      ),
                    );
                  }
                : null,
            semanticsLabel: context.l10n.settingsSettings,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: switch ((broadcastGameState, broadcastGamePgn)) {
        (AsyncData(), AsyncData()) => _Body(
            widget.tournamentId,
            widget.roundId,
            widget.gameId,
            widget.tournamentSlug,
            widget.roundSlug,
            tabController: _tabController,
          ),
        (AsyncError(:final error), _) => Center(
            child: Text('Cannot load broadcast game: $error'),
          ),
        (_, AsyncError(:final error)) => Center(
            child: Text('Cannot load broadcast game: $error'),
          ),
        _ => const Center(child: CircularProgressIndicator.adaptive()),
      },
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

  final BroadcastTournamentId tournamentId;
  final BroadcastRoundId roundId;
  final BroadcastGameId gameId;
  final String? tournamentSlug;
  final String? roundSlug;
  final TabController tabController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final broadcastState = ref
        .watch(broadcastGameControllerProvider(roundId, gameId))
        .requireValue;
    final analysisPrefs = ref.watch(analysisPreferencesProvider);
    final showEvaluationGauge = analysisPrefs.showEvaluationGauge;
    final numEvalLines = analysisPrefs.numEvalLines;

    final engineGaugeParams = broadcastState.engineGaugeParams;
    final isLocalEvaluationEnabled = broadcastState.isLocalEvaluationEnabled;
    final currentNode = broadcastState.currentNode;

    return AnalysisLayout(
      tabController: tabController,
      boardBuilder: (context, boardSize, borderRadius) => _BroadcastBoard(
        roundId,
        gameId,
        boardSize,
        borderRadius,
      ),
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
      engineGaugeBuilder: isLocalEvaluationEnabled && showEvaluationGauge
          ? (context, orientation) {
              return orientation == Orientation.portrait
                  ? EngineGauge(
                      displayMode: EngineGaugeDisplayMode.horizontal,
                      params: engineGaugeParams,
                    )
                  : Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: EngineGauge(
                        displayMode: EngineGaugeDisplayMode.vertical,
                        params: engineGaugeParams,
                      ),
                    );
            }
          : null,
      engineLines: isLocalEvaluationEnabled && numEvalLines > 0
          ? EngineLines(
              clientEval: currentNode.eval,
              isGameOver: currentNode.position.isGameOver,
              onTapMove: ref
                  .read(
                    broadcastGameControllerProvider(roundId, gameId).notifier,
                  )
                  .onUserMove,
            )
          : null,
      bottomBar: BroadcastGameBottomBar(
        roundId: roundId,
        gameId: gameId,
        tournamentSlug: tournamentSlug,
        roundSlug: roundSlug,
      ),
      children: [
        _OpeningExplorerTab(roundId, gameId),
        BroadcastGameTreeView(roundId, gameId),
      ],
    );
  }
}

class _OpeningExplorerTab extends ConsumerWidget {
  const _OpeningExplorerTab(
    this.roundId,
    this.gameId,
  );

  final BroadcastRoundId roundId;
  final BroadcastGameId gameId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = broadcastGameControllerProvider(roundId, gameId);
    final state = ref.watch(ctrlProvider).requireValue;

    return OpeningExplorerView(
      position: state.currentNode.position,
      onMoveSelected: ref.read(ctrlProvider.notifier).onUserMove,
    );
  }
}

class _BroadcastBoard extends ConsumerStatefulWidget {
  const _BroadcastBoard(
    this.roundId,
    this.gameId,
    this.boardSize,
    this.borderRadius,
  );

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
    final ctrlProvider =
        broadcastGameControllerProvider(widget.roundId, widget.gameId);
    final broadcastAnalysisState = ref.watch(ctrlProvider).requireValue;
    final boardPrefs = ref.watch(boardPreferencesProvider);
    final analysisPrefs = ref.watch(analysisPreferencesProvider);

    final evalBestMoves = ref.watch(
      engineEvaluationProvider.select((s) => s.eval?.bestMoves),
    );

    final currentNode = broadcastAnalysisState.currentNode;
    final annotation = makeAnnotation(currentNode.nags);

    final bestMoves = evalBestMoves ?? currentNode.eval?.bestMoves;

    final sanMove = currentNode.sanMove;

    final ISet<Shape> bestMoveShapes = analysisPrefs.showBestMoveArrow &&
            broadcastAnalysisState.isLocalEvaluationEnabled &&
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
        playerSide: broadcastAnalysisState.position.isGameOver
            ? PlayerSide.none
            : broadcastAnalysisState.position.turn == Side.white
                ? PlayerSide.white
                : PlayerSide.black,
        isCheck: boardPrefs.boardHighlights &&
            broadcastAnalysisState.position.isCheck,
        sideToMove: broadcastAnalysisState.position.turn,
        validMoves: broadcastAnalysisState.validMoves,
        promotionMove: broadcastAnalysisState.promotionMove,
        onMove: (move, {isDrop, captured}) =>
            ref.read(ctrlProvider.notifier).onUserMove(move),
        onPromotionSelection: (role) =>
            ref.read(ctrlProvider.notifier).onPromotionSelection(role),
      ),
      shapes: userShapes.union(bestMoveShapes),
      annotations:
          analysisPrefs.showAnnotations && sanMove != null && annotation != null
              ? altCastles.containsKey(sanMove.move.uci)
                  ? IMap({
                      Move.parse(altCastles[sanMove.move.uci]!)!.to: annotation,
                    })
                  : IMap({sanMove.move.to: annotation})
              : null,
      settings: boardPrefs.toBoardSettings().copyWith(
            borderRadius: widget.borderRadius,
            boxShadow: widget.borderRadius != null
                ? boardShadows
                : const <BoxShadow>[],
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
    required this.tournamentId,
    required this.roundId,
    required this.gameId,
    required this.widgetPosition,
  });

  final BroadcastTournamentId tournamentId;
  final BroadcastRoundId roundId;
  final BroadcastGameId gameId;
  final _PlayerWidgetPosition widgetPosition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final broadcastGameState = ref
        .watch(broadcastGameControllerProvider(roundId, gameId))
        .requireValue;
    final game = ref.watch(broadcastGameProvider(roundId, gameId)).requireValue;

    final isCursorOnLiveMove =
        broadcastGameState.currentPath == broadcastGameState.broadcastLivePath;
    final sideToMove = broadcastGameState.position.turn;
    final side = switch (widgetPosition) {
      _PlayerWidgetPosition.bottom => broadcastGameState.pov,
      _PlayerWidgetPosition.top => broadcastGameState.pov.opposite,
    };

    final player = game.players[side]!;
    final liveClock = isCursorOnLiveMove ? player.clock : null;
    final gameStatus = game.status;

    final pastClocks = broadcastGameState.clocks;
    final pastClock =
        (sideToMove == side) ? pastClocks?.parentClock : pastClocks?.clock;

    return GestureDetector(
      onTap: () {
        pushPlatformRoute(
          context,
          builder: (context) => BroadcastPlayerResultsScreen(
            tournamentId,
            (player.fideId != null) ? player.fideId!.toString() : player.name,
            player.title,
            player.name,
          ),
        );
      },
      child: Container(
        color: Theme.of(context).platform == TargetPlatform.iOS
            ? Styles.cupertinoCardColor.resolveFrom(context)
            : Theme.of(context).colorScheme.surfaceContainer,
        padding: const EdgeInsets.only(left: 8.0),
        child: Row(
          children: [
            if (game.isOver) ...[
              Text(
                (gameStatus == BroadcastResult.draw)
                    ? '½'
                    : (gameStatus == BroadcastResult.whiteWins)
                        ? side == Side.white
                            ? '1'
                            : '0'
                        : side == Side.black
                            ? '1'
                            : '0',
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
                textStyle:
                    const TextStyle().copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            if (liveClock != null || pastClock != null)
              Container(
                height: kAnalysisBoardHeaderOrFooterHeight,
                color: (side == sideToMove)
                    ? isCursorOnLiveMove
                        ? Theme.of(context).colorScheme.tertiaryContainer
                        : Theme.of(context).colorScheme.secondaryContainer
                    : Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Center(
                    child: liveClock != null
                        ? CountdownClockBuilder(
                            timeLeft: liveClock,
                            active: side == sideToMove,
                            builder: (context, timeLeft) => _Clock(
                              timeLeft: timeLeft,
                              isSideToMove: side == sideToMove,
                              isLive: true,
                            ),
                            tickInterval: const Duration(seconds: 1),
                            clockUpdatedAt: game.updatedClockAt,
                          )
                        : _Clock(
                            timeLeft: pastClock!,
                            isSideToMove: side == sideToMove,
                            isLive: false,
                          ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Clock extends StatelessWidget {
  const _Clock({
    required this.timeLeft,
    required this.isSideToMove,
    required this.isLive,
  });

  final Duration timeLeft;
  final bool isSideToMove;
  final bool isLive;

  @override
  Widget build(BuildContext context) {
    return Text(
      timeLeft.toHoursMinutesSeconds(),
      style: TextStyle(
        color: isSideToMove
            ? isLive
                ? Theme.of(context).colorScheme.onTertiaryContainer
                : Theme.of(context).colorScheme.onSecondaryContainer
            : null,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}
