import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_game_controller.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_round_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/duration.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/lichess_assets.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_board.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen_body.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_settings.dart';
import 'package:lichess_mobile/src/view/analysis/engine_depth.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

class BroadcastGameAnalysisScreen extends ConsumerWidget {
  final BroadcastRoundId roundId;
  final BroadcastGameId gameId;
  final String title;

  const BroadcastGameAnalysisScreen({
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

  Widget broadcastWrapBoardBuilder(
    WidgetRef ref,
    AnalysisBoard board,
    AnalysisControllerProvider ctrlProvider,
    double boardSize,
  ) {
    final clocks = ref.watch(ctrlProvider.select((value) => value.clocks));
    final currentPath = ref.watch(
      ctrlProvider.select((value) => value.currentPath),
    );
    final broadcastLivePath = ref.watch(
      ctrlProvider.select((value) => value.broadcastLivePath),
    );
    final playingSide =
        ref.watch(ctrlProvider.select((value) => value.position.turn));
    final game = ref.watch(
      broadcastRoundControllerProvider(roundId)
          .select((game) => game.value?[gameId]),
    );
    final pov = ref.watch(ctrlProvider.select((value) => value.pov));

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
            playClock: currentPath == broadcastLivePath,
          ),
        board,
        if (game != null)
          _PlayerWidget(
            clock: (playingSide == pov) ? clocks?.parentClock : clocks?.clock,
            width: boardSize,
            game: game,
            side: pov,
            boardSide: _PlayerWidgetSide.bottom,
            playingSide: playingSide,
            playClock: currentPath == broadcastLivePath,
          ),
      ],
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
            EngineDepth(
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
        data: (pgn) => AnalysisScreenBody(
          pgn: pgn,
          options: AnalysisState.broadcastOptions,
          enableDrawingShapes: true,
          broadcastWrapBoardBuilder: broadcastWrapBoardBuilder,
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
              EngineDepth(
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
        data: (pgn) => AnalysisScreenBody(
          pgn: pgn,
          options: AnalysisState.broadcastOptions,
          enableDrawingShapes: true,
          broadcastWrapBoardBuilder: broadcastWrapBoardBuilder,
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

enum _PlayerWidgetSide { bottom, top }

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
