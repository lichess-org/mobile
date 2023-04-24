import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartchess/dartchess.dart';
import 'package:chessground/chessground.dart' as cg;

import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/async_value.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/table_board_layout.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/player.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_repository_providers.dart';

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
        actions: [
          ToggleSoundButton(),
        ],
      ),
      body: _BoardBody(
        gameData: gameData,
        orientation: orientation,
      ),
      bottomNavigationBar: _BottomBar(gameData: gameData),
    );
  }

  Widget _iosBuilder(BuildContext context, WidgetRef ref) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
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
            _BottomBar(gameData: gameData),
          ],
        ),
      ),
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
    ref.listen<AsyncValue<ArchivedGame>>(archivedGameProvider(id: gameData.id),
        (_, state) {
      state.showSnackbarOnError(context);
    });

    final isBoardTurned = ref.watch(isBoardTurnedProvider);
    final gameCursor = ref.watch(gameCursorProvider(gameData.id));
    final black = BoardPlayer(
      key: const ValueKey('black-player'),
      player: gameData.black,
      active: false,
    );
    final white = BoardPlayer(
      key: const ValueKey('white-player'),
      player: gameData.white,
      active: false,
    );
    final topPlayer = orientation == Side.white ? black : white;
    final bottomPlayer = orientation == Side.white ? white : black;
    final loadingBoard = TableBoardLayout(
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
        final game = data.item1;
        final cursor = data.item2;
        final black = BoardPlayer(
          key: const ValueKey('black-player'),
          player: gameData.black,
          active: false,
          clock: game.blackClockAt(cursor),
        );
        final white = BoardPlayer(
          key: const ValueKey('white-player'),
          player: gameData.white,
          active: false,
          clock: game.whiteClockAt(cursor),
        );
        final topPlayer = orientation == Side.white ? black : white;
        final bottomPlayer = orientation == Side.white ? white : black;

        return TableBoardLayout(
          boardData: cg.BoardData(
            interactableSide: cg.InteractableSide.none,
            orientation:
                (isBoardTurned ? orientation.opposite : orientation).cg,
            fen: game.fenAt(cursor) ?? gameData.lastFen ?? kInitialBoardFEN,
            lastMove: game.moveAt(cursor)?.cg,
          ),
          topTable: topPlayer,
          bottomTable: bottomPlayer,
          moves: game.steps.map((e) => e.san).toList(growable: false),
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
  const _BottomBar({required this.gameData});

  final ArchivedGameData gameData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canGoForward = ref.watch(canGoForwardProvider(gameData.id));
    final canGoBackward = ref.watch(canGoBackwardProvider(gameData.id));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BottomBarIconButton(
          semanticsLabel: context.l10n.menu,
          onPressed: () {
            _showGameMenu(context, ref);
          },
          icon: const Icon(Icons.menu),
        ),
        Row(
          children: [
            BottomBarIconButton(
              key: const ValueKey('cursor-first'),
              semanticsLabel: 'First position',
              onPressed: canGoBackward
                  ? () {
                      ref
                          .read(gameCursorProvider(gameData.id).notifier)
                          .cursorAt(0);
                    }
                  : null,
              icon: const Icon(LichessIcons.fast_backward, size: 20),
            ),
            BottomBarIconButton(
              key: const ValueKey('cursor-back'),
              // TODO add translation
              semanticsLabel: 'Backward',
              onPressed: canGoBackward
                  ? () {
                      ref
                          .read(gameCursorProvider(gameData.id).notifier)
                          .cursorBackward();
                    }
                  : null,
              icon: const Icon(LichessIcons.step_backward, size: 20),
            ),
            BottomBarIconButton(
              key: const ValueKey('cursor-forward'),
              // TODO add translation
              semanticsLabel: 'Forward',
              onPressed: canGoForward
                  ? () {
                      ref
                          .read(gameCursorProvider(gameData.id).notifier)
                          .cursorForward();
                    }
                  : null,
              icon: const Icon(LichessIcons.step_forward, size: 20),
            ),
            BottomBarIconButton(
              key: const ValueKey('cursor-last'),
              // TODO add translation
              semanticsLabel: 'Last position',
              onPressed: canGoForward
                  ? () {
                      ref
                          .read(gameCursorProvider(gameData.id).notifier)
                          .cursorLast();
                    }
                  : null,
              icon: const Icon(LichessIcons.fast_forward, size: 20),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _showGameMenu(BuildContext context, WidgetRef ref) {
    return showAdaptiveActionSheet(
      context: context,
      actions: [
        BottomSheetAction(
          leading: const Icon(Icons.swap_vert),
          label: Text(context.l10n.flipBoard),
          onPressed: (context) {
            ref.read(isBoardTurnedProvider.notifier).toggle();
          },
        ),
      ],
    );
  }
}
