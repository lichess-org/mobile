import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartchess/dartchess.dart';
import 'package:chessground/chessground.dart' as cg;

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/create_game_service.dart';
import 'package:lichess_mobile/src/model/game/game_ctrl.dart';
import 'package:lichess_mobile/src/model/settings/play_preferences.dart';
import 'package:lichess_mobile/src/ui/settings/toggle_sound_button.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/table_board_layout.dart';
import 'package:lichess_mobile/src/widgets/player.dart';
import 'package:lichess_mobile/src/widgets/adaptive_dialog.dart';
import 'package:lichess_mobile/src/utils/immersive_mode.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';

part 'game_screen.g.dart';

@riverpod
Future<GameFullId> _createGame(_CreateGameRef ref) {
  final service = ref.watch(createGameServiceProvider);
  ref.onDispose(service.cancel);
  return service.newOnlineGame();
}

class OnlineGameScreen extends ConsumerWidget {
  const OnlineGameScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      // TODO handle confirmation dialog logic
      onWillPop: () async => true,
      child: PlatformWidget(
        androidBuilder: (context) => _androidBuilder(context, ref),
        iosBuilder: (context) => _iosBuilder(context, ref),
      ),
    );
  }

  Widget _androidBuilder(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ToggleSoundButton(),
        ],
      ),
      body: const _WaitForGame(),
      // bottomNavigationBar: _BottomBar(game: game),
    );
  }

  Widget _iosBuilder(BuildContext context, WidgetRef ref) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        padding: const EdgeInsetsDirectional.only(end: 16.0),
        trailing: ToggleSoundButton(),
      ),
      child: const SafeArea(
        child: Column(
          children: [
            Expanded(child: _WaitForGame()),
            // _BottomBar(game: game),
          ],
        ),
      ),
    );
  }
}

Future<bool?> _showExitConfirmDialog(BuildContext context) {
  return showAdaptiveDialog<bool?>(
    context: context,
    builder: (BuildContext context) {
      return YesNoDialog(
        title: const Text('Exit.'),
        content: const Text('Are you sure you want to quit?'),
        onYes: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        onNo: () {
          Navigator.of(context).pop(false);
        },
      );
    },
  );
}

class _WaitForGame extends ConsumerWidget {
  const _WaitForGame();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameId = ref.watch(_createGameProvider);

    return gameId.when(
      data: (id) {
        final ctrlProvider = gameCtrlProvider(id);
        final gameState = ref.watch(ctrlProvider);
        return gameState.when(
          data: (state) => _Body(gameState: state, ctrlProvider: ctrlProvider),
          loading: () => const _GameLoader(),
          error: (e, s) {
            debugPrint(
              'SEVERE: [OnlineGameScreen] could not create game; $e\n$s',
            );
            return const _CreateGameError();
          },
        );
      },
      loading: () => const _GameLoader(),
      error: (e, s) {
        debugPrint(
          'SEVERE: [OnlineGameScreen] could not create game; $e\n$s',
        );
        return const _CreateGameError();
      },
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body({
    required this.gameState,
    required this.ctrlProvider,
  });

  final GameCtrlState gameState;
  final GameCtrlProvider ctrlProvider;

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> with AndroidImmersiveMode {
  @override
  Widget build(BuildContext context) {
    final state = widget.gameState;
    final black = BoardPlayer(
      player: state.game.black,
      clock: state.game.clock?.black,
      active: state.activeClockSide == Side.black,
      diff: state.game.materialDiffAt(state.stepCursor, Side.black),
    );
    final white = BoardPlayer(
      player: state.game.white,
      clock: state.game.clock?.white,
      active: state.activeClockSide == Side.white,
      diff: state.game.materialDiffAt(state.stepCursor, Side.white),
    );
    final orientation = state.game.youAre ?? Side.white;
    final topPlayer = orientation == Side.white ? black : white;
    final bottomPlayer = orientation == Side.white ? white : black;
    final position = state.game.positionAt(state.stepCursor);
    final content = TableBoardLayout(
      boardData: cg.BoardData(
        interactableSide: state.playable
            ? orientation == Side.white
                ? cg.InteractableSide.white
                : cg.InteractableSide.black
            : cg.InteractableSide.none,
        orientation: orientation.cg,
        fen: position.fen,
        lastMove: state.game.moveAt(state.stepCursor)?.cg,
        isCheck: position.isCheck,
        sideToMove: position.turn.cg,
        validMoves: algebraicLegalMoves(position),
        onMove: (move, {isPremove}) {
          ref
              .read(widget.ctrlProvider.notifier)
              .onUserMove(Move.fromUci(move.uci)!);
        },
      ),
      topTable: topPlayer,
      bottomTable: bottomPlayer,
    );

    return !state.playable
        ? content
        : WillPopScope(
            onWillPop: () async {
              final result = await _showExitConfirmDialog(context);
              return result ?? true;
            },
            child: content,
          );
  }
}

class _GameLoader extends ConsumerWidget {
  const _GameLoader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeControlPref = ref
        .watch(playPreferencesProvider.select((prefs) => prefs.timeIncrement));

    return TableBoardLayout(
      boardData: const cg.BoardData(
        interactableSide: cg.InteractableSide.none,
        orientation: cg.Side.white,
        fen: kEmptyFen,
      ),
      topTable: const SizedBox.shrink(),
      bottomTable: const SizedBox.shrink(),
      showMoveListPlaceholder: true,
      boardOverlay: PlatformCard(
        elevation: 2.0,
        borderRadius: BorderRadius.zero,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(timeControlPref.speed.icon),
                  const SizedBox(width: 8.0),
                  Text(
                    timeControlPref.display,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: 36.0),
              const CircularProgressIndicator.adaptive(),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreateGameError extends StatelessWidget {
  const _CreateGameError();

  @override
  Widget build(BuildContext context) {
    return const TableBoardLayout(
      boardData: cg.BoardData(
        interactableSide: cg.InteractableSide.none,
        orientation: cg.Side.white,
        fen: kEmptyFen,
      ),
      topTable: SizedBox.shrink(),
      bottomTable: SizedBox.shrink(),
      showMoveListPlaceholder: true,
      errorMessage:
          'Sorry, we could not create the game. Please try again later.',
    );
  }
}
