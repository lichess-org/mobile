import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_game_controller.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_round_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/duration.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/lichess_assets.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_layout.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_game_bottom_bar.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_game_settings.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_game_tree_view.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';
import 'package:lichess_mobile/src/view/engine/engine_lines.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/clock.dart';
import 'package:lichess_mobile/src/widgets/pgn.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';

class BroadcastGameScreen extends ConsumerWidget {
  final BroadcastRoundId roundId;
  final BroadcastGameId gameId;
  final String title;

  const BroadcastGameScreen({
    required this.roundId,
    required this.gameId,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final broadcastGameState =
        ref.watch(broadcastGameControllerProvider(roundId, gameId));

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(title, overflow: TextOverflow.ellipsis, maxLines: 1),
        actions: [
          AppBarIconButton(
            onPressed: (broadcastGameState.hasValue)
                ? () {
                    pushPlatformRoute(
                      context,
                      screen: BroadcastGameSettings(
                        roundId,
                        gameId,
                      ),
                    );
                  }
                : null,
            semanticsLabel: context.l10n.settingsSettings,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: switch (broadcastGameState) {
        AsyncData() => _Body(roundId, gameId),
        AsyncError(:final error) => Center(
            child: Text('Cannot load broadcast game: $error'),
          ),
        _ => const Center(child: CircularProgressIndicator.adaptive()),
      },
    );
  }
}

class _Body extends ConsumerWidget {
  final BroadcastRoundId roundId;
  final BroadcastGameId gameId;

  const _Body(this.roundId, this.gameId);

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

    return DefaultTabController(
      length: 1,
      child: AnalysisLayout(
        boardBuilder: (context, boardSize, borderRadius, orientation) =>
            _BroadcastBoardWithHeaders(
          roundId,
          gameId,
          boardSize,
          borderRadius,
          orientation,
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
        bottomBar: BroadcastGameBottomBar(roundId: roundId, gameId: gameId),
        children: [BroadcastGameTreeView(roundId, gameId)],
      ),
    );
  }
}

class _BroadcastBoardWithHeaders extends ConsumerWidget {
  final BroadcastRoundId roundId;
  final BroadcastGameId gameId;
  final double size;
  final BorderRadius? borderRadius;
  final Orientation orientation;

  const _BroadcastBoardWithHeaders(
    this.roundId,
    this.gameId,
    this.size,
    this.borderRadius,
    this.orientation,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _PlayerWidget(
          roundId: roundId,
          gameId: gameId,
          width: size,
          widgetPosition: _PlayerWidgetPosition.top,
          borderRadius: borderRadius?.copyWith(
            bottomLeft: Radius.zero,
            bottomRight: Radius.zero,
          ),
        ),
        _BroadcastBoard(
            roundId, gameId, size, borderRadius != null, orientation),
        _PlayerWidget(
          roundId: roundId,
          gameId: gameId,
          width: size,
          widgetPosition: _PlayerWidgetPosition.bottom,
          borderRadius: borderRadius?.copyWith(
            topLeft: Radius.zero,
            topRight: Radius.zero,
          ),
        ),
      ],
    );
  }
}

class _BroadcastBoard extends ConsumerStatefulWidget {
  const _BroadcastBoard(
    this.roundId,
    this.gameId,
    this.boardSize,
    this.hasShadow,
    this.orientation,
  );

  final BroadcastRoundId roundId;
  final BroadcastGameId gameId;
  final double boardSize;
  final bool hasShadow;
  final Orientation orientation;

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
      size: switch (widget.orientation) {
        Orientation.portrait => widget.boardSize,
        Orientation.landscape => widget.boardSize - 2 * 30,
      },
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
            boxShadow: widget.hasShadow ? boardShadows : const <BoxShadow>[],
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
    required this.roundId,
    required this.gameId,
    required this.width,
    required this.widgetPosition,
    required this.borderRadius,
  });

  final BroadcastRoundId roundId;
  final BroadcastGameId gameId;
  final double width;
  final _PlayerWidgetPosition widgetPosition;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final broadcastGameState = ref
        .watch(broadcastGameControllerProvider(roundId, gameId))
        .requireValue;
    final clocks = broadcastGameState.clocks;
    final isCursorOnLiveMove =
        broadcastGameState.currentPath == broadcastGameState.broadcastLivePath;
    final sideToMove = broadcastGameState.position.turn;
    final side = switch (widgetPosition) {
      _PlayerWidgetPosition.bottom => broadcastGameState.pov,
      _PlayerWidgetPosition.top => broadcastGameState.pov.opposite,
    };
    final clock = (sideToMove == side) ? clocks?.parentClock : clocks?.clock;

    final game = ref.watch(
      broadcastRoundControllerProvider(roundId)
          .select((game) => game.requireValue[gameId]!),
    );
    final player = game.players[side]!;
    final gameStatus = game.status;

    return SizedBox(
      width: width,
      child: Row(
        children: [
          if (game.isOver)
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.zero,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                child: Text(
                  (gameStatus == BroadcastResult.draw)
                      ? '½'
                      : (gameStatus == BroadcastResult.whiteWins)
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
                borderRadius: borderRadius ?? BorderRadius.zero,
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
          if (clock != null)
            Card(
              color: (side == sideToMove)
                  ? isCursorOnLiveMove
                      ? Theme.of(context).colorScheme.tertiaryContainer
                      : Theme.of(context).colorScheme.secondaryContainer
                  : null,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.zero,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: isCursorOnLiveMove
                    ? CountdownClockBuilder(
                        timeLeft: clock,
                        active: side == sideToMove,
                        builder: (context, timeLeft) => _Clock(
                          timeLeft: timeLeft,
                          isSideToMove: side == sideToMove,
                          isLive: true,
                        ),
                        tickInterval: const Duration(seconds: 1),
                        clockUpdatedAt:
                            side == sideToMove ? game.updatedClockAt : null,
                      )
                    : _Clock(
                        timeLeft: clock,
                        isSideToMove: side == sideToMove,
                        isLive: false,
                      ),
              ),
            ),
        ],
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
