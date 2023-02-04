import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartchess/dartchess.dart';
import 'package:chessground/chessground.dart' as cg;

import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/common/lichess_icons.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/utils/async_value.dart';
import 'package:lichess_mobile/src/widgets/game_board_layout.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/player.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/model/settings/is_sound_muted_provider.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/play_action_notifier.dart';
import 'package:lichess_mobile/src/model/game/playable_game_providers.dart';

class PlayableGameScreen extends ConsumerWidget {
  const PlayableGameScreen({
    required this.game,
    required this.account,
    super.key,
  });

  final PlayableGame game;
  final User account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(
      gameActionProvider,
      (_, state) => state.showSnackbarOnError(context),
    );
    ref.listen<AsyncValue<PlayableGame?>>(playActionProvider, (_, state) {
      state.showSnackbarOnError(context);

      if (state.valueOrNull is PlayableGame) {
        ref.invalidate(playActionProvider);
        ref.invalidate(positionCursorProvider);
        ref.invalidate(isBoardTurnedProvider);
        ref.invalidate(gameStateProvider);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (context) =>
                PlayableGameScreen(game: state.value!, account: account),
          ),
        );
      }
    });

    return WillPopScope(
      onWillPop: () async => false,
      child: PlatformWidget(
        androidBuilder: (context) => _androidBuilder(context, ref),
        iosBuilder: (context) => _iosBuilder(context, ref),
      ),
    );
  }

  Widget _androidBuilder(BuildContext context, WidgetRef ref) {
    final isSoundMuted = ref.watch(isSoundMutedProvider);
    final gameState = ref.watch(gameStateProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (gameState?.gameOver == true) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            } else {
              _showExitConfirmDialog(context);
            }
          },
        ),
        actions: [
          IconButton(
            icon: isSoundMuted
                ? const Icon(Icons.volume_off)
                : const Icon(Icons.volume_up),
            onPressed: () =>
                ref.read(isSoundMutedProvider.notifier).toggleSound(),
          )
        ],
      ),
      body: _BoardBody(game: game, account: account),
      bottomNavigationBar: _BottomBar(game: game, account: account),
    );
  }

  Widget _iosBuilder(BuildContext context, WidgetRef ref) {
    final isSoundMuted = ref.watch(isSoundMutedProvider);
    final gameState = ref.watch(gameStateProvider);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        padding: const EdgeInsetsDirectional.only(end: 16.0),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            if (gameState?.gameOver == true) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            } else {
              _showExitConfirmDialog(context);
            }
          },
          child: const Icon(CupertinoIcons.back),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: isSoundMuted
              ? const Icon(CupertinoIcons.volume_off)
              : const Icon(CupertinoIcons.volume_up),
          onPressed: () =>
              ref.read(isSoundMutedProvider.notifier).toggleSound(),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(child: _BoardBody(game: game, account: account)),
            _BottomBar(game: game, account: account),
          ],
        ),
      ),
    );
  }

  Future<void> _showExitConfirmDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exit.'),
          content: const Text('Are you sure you want to quit the game?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(context.l10n.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(context.l10n.accept),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        );
      },
    );
  }
}

class _BoardBody extends ConsumerWidget {
  const _BoardBody({required this.game, required this.account});

  final PlayableGame game;
  final User account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);
    final gameClockStream = ref.watch(gameStreamProvider(game.id));
    final positionCursor = ref.watch(positionCursorProvider);
    final isBoardTurned = ref.watch(isBoardTurnedProvider);
    final isReplaying =
        gameState != null && positionCursor < gameState.positionIndex;

    return gameClockStream.when(
      data: (clock) {
        final black = BoardPlayer(
          key: const ValueKey('black-player'),
          name: game.black.name,
          rating: game.black.rating,
          title: game.black.title,
          active: gameState != null &&
              gameState.status == GameStatus.started &&
              gameState.position.fullmoves > 1 &&
              gameState.position.turn == Side.black,
          clock: clock.blackTime,
        );
        final white = BoardPlayer(
          key: const ValueKey('white-player'),
          name: game.white.name,
          rating: game.white.rating,
          title: game.white.title,
          active: gameState != null &&
              gameState.status == GameStatus.started &&
              gameState.position.fullmoves > 1 &&
              gameState.position.turn == Side.white,
          clock: clock.whiteTime,
        );
        final topPlayer = game.orientation == Side.white ? black : white;
        final bottomPlayer = game.orientation == Side.white ? white : black;

        return GameBoardLayout(
          boardData: cg.BoardData(
            interactableSide:
                gameState == null || !gameState.playing || isReplaying
                    ? cg.InteractableSide.none
                    : game.orientation == Side.white
                        ? cg.InteractableSide.white
                        : cg.InteractableSide.black,
            orientation:
                (isBoardTurned ? game.orientation.opposite : game.orientation)
                    .cg,
            fen: gameState?.positions[positionCursor].fen ?? game.initialFen,
            validMoves: gameState?.validMoves,
            lastMove: gameState != null && gameState.gameOver
                ? positionCursor > 0
                    ? gameState.moveAtPly(positionCursor - 1)?.cg
                    : null
                : gameState?.lastMove?.cg,
            sideToMove: gameState?.position.turn.cg ?? game.orientation.cg,
            onMove: (cg.Move move, {bool? isPremove}) => ref
                .read(gameStateProvider.notifier)
                .onUserMove(game.id, Move.fromUci(move.uci)!),
          ),
          topPlayer: topPlayer,
          bottomPlayer: bottomPlayer,
          moves: gameState?.sanMoves,
          currentMoveIndex: positionCursor - 1,
        );
      },
      loading: () {
        final player = BoardPlayer(
          name: game.player.name,
          rating: game.player.rating,
          title: game.player.title,
          active: false,
          clock: Duration.zero,
        );
        final opponent = BoardPlayer(
          name: game.opponent.name,
          rating: game.opponent.rating,
          title: game.opponent.title,
          active: false,
          clock: Duration.zero,
        );

        return GameBoardLayout(
          topPlayer: opponent,
          bottomPlayer: player,
          boardData: cg.BoardData(
            interactableSide: cg.InteractableSide.none,
            orientation: game.orientation.cg,
            fen: game.initialFen,
          ),
        );
      },
      error: (err, stackTrace) {
        debugPrint(
          'SEVERE: [PlayableGameScreen] could not load game; $err\n$stackTrace',
        );
        return const Text('Could not load game stream.');
      },
    );
  }
}

class _BottomBar extends ConsumerWidget {
  const _BottomBar({required this.game, required this.account});

  final PlayableGame game;
  final User account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final positionCursor = ref.watch(positionCursorProvider);
    final gameState = ref.watch(gameStateProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            _showGameMenu(context, ref);
          },
          icon: const Icon(Icons.menu),
        ),
        Row(
          children: [
            IconButton(
              key: const ValueKey('cursor-first'),
              // TODO add translation
              tooltip: 'First position',
              onPressed: positionCursor > 0
                  ? () {
                      ref.read(positionCursorProvider.notifier).state = 0;
                    }
                  : null,
              icon: const Icon(LichessIcons.fast_backward),
              iconSize: 20,
            ),
            IconButton(
              key: const ValueKey('cursor-back'),
              // TODO add translation
              tooltip: 'Backward',
              onPressed: positionCursor > 0
                  ? () {
                      ref.read(positionCursorProvider.notifier).state--;
                    }
                  : null,
              icon: const Icon(LichessIcons.step_backward),
              iconSize: 20,
            ),
            IconButton(
              key: const ValueKey('cursor-forward'),
              // TODO add translation
              tooltip: 'Forward',
              onPressed: positionCursor < (gameState?.positionIndex ?? 0)
                  ? () {
                      ref.read(positionCursorProvider.notifier).state++;
                    }
                  : null,
              icon: const Icon(LichessIcons.step_forward),
              iconSize: 20,
            ),
            IconButton(
              key: const ValueKey('cursor-last'),
              // TODO add translation
              tooltip: 'Last position',
              onPressed: positionCursor < (gameState?.positionIndex ?? 0)
                  ? () {
                      ref.read(positionCursorProvider.notifier).state =
                          gameState?.positionIndex ?? 0;
                    }
                  : null,
              icon: const Icon(LichessIcons.fast_forward),
              iconSize: 20,
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _showGameMenu(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);
    final gameActionAsync = ref.watch(gameActionProvider);
    final playActionAsync = ref.watch(playActionProvider);

    return showAdaptiveActionSheet(
      context: context,
      actions: [
        BottomSheetAction(
          leading: const Icon(Icons.swap_vert),
          label: Text(context.l10n.flipBoard),
          onPressed: (context) {
            ref.read(isBoardTurnedProvider.notifier).state =
                !ref.read(isBoardTurnedProvider);
          },
        ),
        if (gameState?.abortable == true)
          BottomSheetAction(
            leading: const Icon(LichessIcons.cancel),
            label: Text(context.l10n.abortTheGame),
            onPressed: (context) {
              if (!gameActionAsync.isLoading) {
                ref.read(gameActionProvider.notifier).abort(game.id);
              }
            },
          ),
        if (gameState?.resignable == true)
          BottomSheetAction(
            leading: const Icon(Icons.flag),
            label: Text(context.l10n.resignTheGame),
            onPressed: (context) {
              if (!gameActionAsync.isLoading) {
                ref.read(gameActionProvider.notifier).resign(game.id);
              }
            },
          ),
        if (gameState?.gameOver == true)
          BottomSheetAction(
            leading: const Icon(CupertinoIcons.arrow_2_squarepath),
            label: playActionAsync.isLoading
                ? const ButtonLoadingIndicator()
                : Text(context.l10n.rematch),
            onPressed: (context) {
              if (!playActionAsync.isLoading) {
                ref.read(playActionProvider.notifier).createGame(
                      account: account,
                      side: game.orientation.opposite,
                    );
              }
            },
          ),
      ],
    );
  }
}
