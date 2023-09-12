import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartchess/dartchess.dart';
import 'package:chessground/chessground.dart' as cg;

import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/board_table.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/player.dart';
import 'package:lichess_mobile/src/widgets/countdown_clock.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/view/settings/toggle_sound_button.dart';

import 'archived_game_screen_providers.dart';

class ArchivedGameScreen extends ConsumerWidget {
  const ArchivedGameScreen({
    required this.gameData,
    required this.orientation,
    super.key,
  });

  final ArchivedGameData gameData;
  final Side orientation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConsumerPlatformWidget(
      ref: ref,
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: _GameTitle(gameData: gameData),
        actions: [
          ToggleSoundButton(),
        ],
      ),
      body: _BoardBody(
        gameData: gameData,
        orientation: orientation,
      ),
      bottomNavigationBar:
          _BottomBar(gameData: gameData, orientation: orientation),
    );
  }

  Widget _iosBuilder(BuildContext context, WidgetRef ref) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: _GameTitle(gameData: gameData),
        padding: const EdgeInsetsDirectional.only(end: 16.0),
        trailing: ToggleSoundButton(),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _BoardBody(
                gameData: gameData,
                orientation: orientation,
              ),
            ),
            _BottomBar(gameData: gameData, orientation: orientation),
          ],
        ),
      ),
    );
  }
}

class _GameTitle extends StatelessWidget {
  const _GameTitle({
    required this.gameData,
  });

  final ArchivedGameData gameData;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          gameData.perf.icon,
          color: DefaultTextStyle.of(context).style.color,
        ),
        const SizedBox(width: 4.0),
        Text(
          '${gameData.clockDisplay} • ${gameData.rated ? context.l10n.rated : context.l10n.casual}',
        ),
      ],
    );
  }
}

class _BoardBody extends ConsumerWidget {
  const _BoardBody({
    required this.gameData,
    required this.orientation,
  });

  final ArchivedGameData gameData;
  final Side orientation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBoardTurned = ref.watch(isBoardTurnedProvider);
    final gameCursor = ref.watch(gameCursorProvider(gameData.id));
    final black = BoardPlayer(
      key: const ValueKey('black-player'),
      player: gameData.black,
    );
    final white = BoardPlayer(
      key: const ValueKey('white-player'),
      player: gameData.white,
    );
    final topPlayer = orientation == Side.white ? black : white;
    final bottomPlayer = orientation == Side.white ? white : black;
    final loadingBoard = BoardTable(
      boardData: cg.BoardData(
        interactableSide: cg.InteractableSide.none,
        orientation: (isBoardTurned ? orientation.opposite : orientation).cg,
        fen: gameData.lastFen ?? kInitialBoardFEN,
      ),
      topTable: topPlayer,
      bottomTable: bottomPlayer,
      showMoveListPlaceholder: true,
    );

    return gameCursor.when(
      data: (data) {
        final (game, cursor) = data;
        final whiteClock = game.whiteClockAt(cursor);
        final blackClock = game.blackClockAt(cursor);
        final black = BoardPlayer(
          key: const ValueKey('black-player'),
          player: gameData.black,
          clock: blackClock != null
              ? CountdownClock(
                  duration: blackClock,
                  active: false,
                )
              : null,
          materialDiff: game.materialDiffAt(cursor, Side.black),
        );
        final white = BoardPlayer(
          key: const ValueKey('white-player'),
          player: gameData.white,
          clock: whiteClock != null
              ? CountdownClock(
                  duration: whiteClock,
                  active: false,
                )
              : null,
          materialDiff: game.materialDiffAt(cursor, Side.white),
        );
        final topPlayer = orientation == Side.white ? black : white;
        final bottomPlayer = orientation == Side.white ? white : black;

        final position = game.positionAt(cursor);

        return BoardTable(
          boardData: cg.BoardData(
            interactableSide: cg.InteractableSide.none,
            orientation:
                (isBoardTurned ? orientation.opposite : orientation).cg,
            fen: position.fen,
            lastMove: game.moveAt(cursor)?.cg,
            sideToMove: position.turn.cg,
            isCheck: position.isCheck,
          ),
          topTable: topPlayer,
          bottomTable: bottomPlayer,
          moves: game.steps
              .skip(1)
              .map((e) => e.sanMove!.san)
              .toList(growable: false),
          currentMoveIndex: cursor,
          onSelectMove: (moveIndex) {
            ref
                .read(gameCursorProvider(gameData.id).notifier)
                .cursorAt(moveIndex);
          },
        );
      },
      loading: () => loadingBoard,
      error: (error, stackTrace) {
        debugPrint(
          'SEVERE: [ArchivedGameScreen] could not load game; $error\n$stackTrace',
        );
        return loadingBoard;
      },
    );
  }
}

class _BottomBar extends ConsumerWidget {
  const _BottomBar({required this.gameData, required this.orientation});

  final Side orientation;
  final ArchivedGameData gameData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canGoForward = ref.watch(canGoForwardProvider(gameData.id));
    final canGoBackward = ref.watch(canGoBackwardProvider(gameData.id));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BottomBarIconButton(
            semanticsLabel: context.l10n.menu,
            onPressed: () {
              _showGameMenu(context, ref);
            },
            icon: const Icon(Icons.menu),
          ),
          BottomBarIconButton(
            semanticsLabel: context.l10n.gameAnalysis,
            onPressed: ref.read(gameCursorProvider(gameData.id)).hasValue
                ? () => pushPlatformRoute(
                      context,
                      fullscreenDialog: true,
                      builder: (context) => AnalysisScreen(
                        variant: gameData.variant,
                        steps: ref
                            .read(gameCursorProvider(gameData.id))
                            .requireValue
                            .$1
                            .steps,
                        orientation: orientation,
                        id: gameData.id,
                        title: context.l10n.gameAnalysis,
                      ),
                    )
                : null,
            icon: const Icon(CupertinoIcons.gauge),
          ),
          const SizedBox(
            width: 44.0,
          ),
          const SizedBox(
            width: 44.0,
          ),
          RepeatButton(
            onLongPress: canGoBackward ? () => _cursorBackward(ref) : null,
            child: BottomBarIconButton(
              key: const ValueKey('cursor-back'),
              // TODO add translation
              semanticsLabel: 'Backward',
              showTooltip: false,
              onPressed: canGoBackward ? () => _cursorBackward(ref) : null,
              icon: const Icon(CupertinoIcons.chevron_back),
            ),
          ),
          RepeatButton(
            onLongPress: canGoForward ? () => _cursorForward(ref) : null,
            child: BottomBarIconButton(
              key: const ValueKey('cursor-forward'),
              // TODO add translation
              semanticsLabel: 'Forward',
              showTooltip: false,
              onPressed: canGoForward ? () => _cursorForward(ref) : null,
              icon: const Icon(CupertinoIcons.chevron_forward),
            ),
          ),
        ],
      ),
    );
  }

  void _cursorForward(WidgetRef ref) {
    ref.read(gameCursorProvider(gameData.id).notifier).cursorForward();
  }

  void _cursorBackward(WidgetRef ref) {
    ref.read(gameCursorProvider(gameData.id).notifier).cursorBackward();
  }

  Future<void> _showGameMenu(BuildContext context, WidgetRef ref) {
    return showAdaptiveActionSheet(
      context: context,
      actions: [
        BottomSheetAction(
          label: Text(context.l10n.flipBoard),
          onPressed: (context) {
            ref.read(isBoardTurnedProvider.notifier).toggle();
          },
        ),
      ],
    );
  }
}
