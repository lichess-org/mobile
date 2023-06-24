import 'package:flutter/foundation.dart';
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
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/table_board_layout.dart';
import 'package:lichess_mobile/src/widgets/player.dart';
import 'package:lichess_mobile/src/widgets/adaptive_dialog.dart';
import 'package:lichess_mobile/src/utils/immersive_mode.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';

import 'ping_rating.dart';
import 'game_loader.dart';

part 'game_screen.g.dart';

@riverpod
Future<GameFullId> _createGame(_CreateGameRef ref) {
  final service = ref.watch(createGameServiceProvider);
  ref.onDispose(service.cancel);
  return service.newOnlineGame();
}

@riverpod
class IsBoardTurned extends _$IsBoardTurned {
  @override
  bool build() {
    return false;
  }

  void toggle() {
    state = !state;
  }
}

class GameScreen extends ConsumerWidget {
  const GameScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameId = ref.watch(_createGameProvider);
    final playPrefs = ref.watch(playPreferencesProvider);

    return gameId.when(
      data: (id) {
        final ctrlProvider = gameCtrlProvider(id);
        final gameState = ref.watch(ctrlProvider);
        return gameState.when(
          data: (state) {
            final body = _Body(gameState: state, ctrlProvider: ctrlProvider);
            return PlatformWidget(
              androidBuilder: (context) => _androidBuilder(
                context: context,
                playPrefs: playPrefs,
                body: body,
                gameState: state,
              ),
              iosBuilder: (context) => _iosBuilder(
                context: context,
                playPrefs: playPrefs,
                body: body,
                gameState: state,
              ),
            );
          },
          loading: () => _loadingContent(playPrefs),
          error: (e, s) {
            debugPrint(
              'SEVERE: [GameScreen] could not create game; $e\n$s',
            );
            return _errorContent(playPrefs);
          },
        );
      },
      loading: () => _loadingContent(playPrefs),
      error: (e, s) {
        debugPrint(
          'SEVERE: [GameScreen] could not create game; $e\n$s',
        );
        return _errorContent(playPrefs);
      },
    );
  }

  Widget _loadingContent(PlayPrefs playPrefs) {
    return PlatformWidget(
      androidBuilder: (context) => _androidBuilder(
        context: context,
        playPrefs: playPrefs,
        body: const GameLoader(),
      ),
      iosBuilder: (context) => _iosBuilder(
        context: context,
        playPrefs: playPrefs,
        body: const GameLoader(),
      ),
    );
  }

  Widget _errorContent(PlayPrefs playPrefs) {
    return PlatformWidget(
      androidBuilder: (context) => _androidBuilder(
        context: context,
        playPrefs: playPrefs,
        body: const _CreateGameError(),
      ),
      iosBuilder: (context) => _iosBuilder(
        context: context,
        playPrefs: playPrefs,
        body: const _CreateGameError(),
      ),
    );
  }

  Widget _androidBuilder({
    required BuildContext context,
    required PlayPrefs playPrefs,
    required Widget body,
    GameCtrlState? gameState,
  }) {
    return Scaffold(
      appBar: AppBar(
        leading: gameState == null || gameState.playable == true
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
                child: PingRating(size: 24.0),
              )
            : null,
        title: _GameTitle(playPrefs: playPrefs),
        actions: [
          ToggleSoundButton(),
        ],
      ),
      body: body,
    );
  }

  Widget _iosBuilder({
    required BuildContext context,
    required PlayPrefs playPrefs,
    required Widget body,
    GameCtrlState? gameState,
  }) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        padding: const EdgeInsetsDirectional.only(end: 16.0),
        leading: gameState == null || gameState.playable == true
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: PingRating(size: 24.0),
              )
            : null,
        middle: _GameTitle(playPrefs: playPrefs),
        trailing: ToggleSoundButton(),
      ),
      child: body,
    );
  }
}

class _GameTitle extends StatelessWidget {
  const _GameTitle({
    required this.playPrefs,
  });

  final PlayPrefs playPrefs;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          playPrefs.speedIcon,
          color: DefaultTextStyle.of(context).style.color,
        ),
        const SizedBox(width: 4.0),
        Text(playPrefs.gameTitle),
      ],
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
    final isBoardTurned = ref.watch(isBoardTurnedProvider);

    final content = Column(
      children: [
        Expanded(
          child: Center(
            child: SafeArea(
              child: TableBoardLayout(
                boardData: cg.BoardData(
                  interactableSide: state.playable
                      ? orientation == Side.white
                          ? cg.InteractableSide.white
                          : cg.InteractableSide.black
                      : cg.InteractableSide.none,
                  orientation:
                      isBoardTurned ? orientation.opposite.cg : orientation.cg,
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
                moves: state.game.steps
                    .skip(1)
                    .map((e) => e.sanMove!.san)
                    .toList(growable: false),
                currentMoveIndex: state.stepCursor,
                onSelectMove: (moveIndex) {
                  ref.read(widget.ctrlProvider.notifier).cursorAt(moveIndex);
                },
              ),
            ),
          ),
        ),
        _GameBottomBar(gameState: state, ctrlProvider: widget.ctrlProvider),
      ],
    );

    return state.playable
        ? WillPopScope(
            onWillPop: () async => false,
            child: content,
          )
        : content;
  }
}

class _GameBottomBar extends ConsumerWidget {
  const _GameBottomBar({
    required this.gameState,
    required this.ctrlProvider,
  });

  final GameCtrlState gameState;
  final GameCtrlProvider ctrlProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: Styles.horizontalBodyPadding,
      color: defaultTargetPlatform == TargetPlatform.iOS
          ? CupertinoTheme.of(context).barBackgroundColor
          : Theme.of(context).bottomAppBarTheme.color,
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BottomBarButton(
              label: context.l10n.menu,
              shortLabel: context.l10n.menu,
              onTap: () {
                _showGameMenu(context, ref);
              },
              icon: Icons.menu,
            ),
            const SizedBox(
              width: 44.0,
            ),
            RepeatButton(
              onLongPress:
                  gameState.canGoBackward ? () => _moveBackward(ref) : null,
              child: BottomBarButton(
                onTap:
                    gameState.canGoBackward ? () => _moveBackward(ref) : null,
                label: 'Previous',
                shortLabel: 'Previous',
                icon: CupertinoIcons.chevron_back,
              ),
            ),
            RepeatButton(
              onLongPress: gameState.canGoForward
                  ? () => _moveForward(ref, hapticFeedback: false)
                  : null,
              child: BottomBarButton(
                onTap: gameState.canGoForward ? () => _moveForward(ref) : null,
                label: context.l10n.next,
                shortLabel: context.l10n.next,
                icon: CupertinoIcons.chevron_forward,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _moveForward(WidgetRef ref, {bool hapticFeedback = true}) {
    ref
        .read(ctrlProvider.notifier)
        .cursorForward(hapticFeedback: hapticFeedback);
  }

  void _moveBackward(WidgetRef ref) {
    ref.read(ctrlProvider.notifier).cursorBackward();
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
        if (gameState.abortable)
          BottomSheetAction(
            leading: const Icon(Icons.cancel),
            label: Text(context.l10n.abortGame),
            onPressed: (context) {
              ref.read(ctrlProvider.notifier).abortGame();
            },
          ),
        if (gameState.resignable)
          BottomSheetAction(
            leading: const Icon(Icons.flag),
            label: Text(context.l10n.resign),
            onPressed: (context) async {
              await Navigator.of(context).maybePop();
              if (context.mounted) {
                final result = await showAdaptiveDialog<bool>(
                  context: context,
                  builder: (context) => YesNoDialog(
                    title: const Text('Are you sure?'),
                    content: Text(context.l10n.resignTheGame),
                    onYes: () {
                      return Navigator.of(context).pop(true);
                    },
                    onNo: () => Navigator.of(context).pop(false),
                  ),
                );
                if (result == true) {
                  ref.read(ctrlProvider.notifier).resignGame();
                }
              }
            },
          ),
      ],
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
