import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartchess/dartchess.dart';
import 'package:chessground/chessground.dart' as cg;

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_socket.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/create_game_service.dart';
import 'package:lichess_mobile/src/model/game/game_ctrl.dart';
import 'package:lichess_mobile/src/model/settings/play_preferences.dart';
import 'package:lichess_mobile/src/ui/settings/toggle_sound_button.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/table_board_layout.dart';
import 'package:lichess_mobile/src/widgets/player.dart';
import 'package:lichess_mobile/src/widgets/adaptive_dialog.dart';
import 'package:lichess_mobile/src/utils/immersive_mode.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';

import 'ping_rating.dart';

part 'game_screen.g.dart';

@riverpod
Future<GameFullId> _createGame(_CreateGameRef ref) {
  final service = ref.watch(createGameServiceProvider);
  ref.onDispose(service.cancel);
  return service.newOnlineGame();
}

@riverpod
Stream<({int nbPlayers, int nbGames})> lobbyNumbers(
  LobbyNumbersRef ref,
) async* {
  final socket = ref.watch(authSocketProvider);
  final stream = socket.connect();
  await for (final msg in stream) {
    if (msg.topic == 'n') {
      final data = msg.data as Map<String, int>;
      yield (
        nbPlayers: data['nbPlayers']!,
        nbGames: data['nbGames']!,
      );
    }
  }
}

class OnlineGameScreen extends ConsumerWidget {
  const OnlineGameScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PlatformWidget(
      androidBuilder: (context) => _androidBuilder(context, ref),
      iosBuilder: (context) => _iosBuilder(context, ref),
    );
  }

  Widget _androidBuilder(BuildContext context, WidgetRef ref) {
    final playPrefs = ref.watch(playPreferencesProvider);
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
          child: PingRating(size: 24.0),
        ),
        title: _GameTitle(playPrefs: playPrefs),
        actions: [
          ToggleSoundButton(),
        ],
      ),
      body: const _WaitForGame(),
      // bottomNavigationBar: _BottomBar(game: game),
    );
  }

  Widget _iosBuilder(BuildContext context, WidgetRef ref) {
    final playPrefs = ref.watch(playPreferencesProvider);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        padding: const EdgeInsetsDirectional.only(end: 16.0),
        leading: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: PingRating(size: 24.0),
        ),
        middle: _GameTitle(playPrefs: playPrefs),
        trailing: ToggleSoundButton(),
      ),
      child: const _WaitForGame(),
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

Future<bool?> _showExitConfirmDialog(BuildContext context) {
  return showAdaptiveDialog<bool?>(
    context: context,
    builder: (BuildContext context) {
      return YesNoDialog(
        title: const Text('Exit.'),
        content: const Text('Are you sure you want to quit?'),
        onYes: () {
          Navigator.of(context).pop(true);
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

    return !state.playable
        ? content
        : WillPopScope(
            onWillPop: () async {
              final result = await _showExitConfirmDialog(context);
              return result ?? false;
            },
            child: content,
          );
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
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Styles.horizontalBodyPadding,
      color: defaultTargetPlatform == TargetPlatform.iOS
          ? CupertinoTheme.of(context).barBackgroundColor
          : Theme.of(context).bottomAppBarTheme.color,
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: children,
        ),
      ),
    );
  }
}

class _GameLoader extends ConsumerWidget {
  const _GameLoader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeControlPref = ref
        .watch(playPreferencesProvider.select((prefs) => prefs.timeIncrement));

    return Column(
      children: [
        Expanded(
          child: Center(
            child: SafeArea(
              child: TableBoardLayout(
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
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('${context.l10n.waitingForOpponent}...'),
                        const SizedBox(height: 26.0),
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
                        const SizedBox(height: 16.0),
                        _LobbyNumbers(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        _BottomBar(
          children: [
            BottomBarButton(
              onTap: () => Navigator.of(context).pop(),
              label: context.l10n.cancel,
              shortLabel: context.l10n.cancel,
              icon: CupertinoIcons.xmark,
              showAndroidShortLabel: true,
            ),
          ],
        ),
      ],
    );
  }
}

class _LobbyNumbers extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lobbyNumbers = ref.watch(lobbyNumbersProvider);
    return lobbyNumbers.when(
      data: (numbers) => Column(
        children: [
          _AnimatedLobbyNumber(
            labelBuilder: (nb) => context.l10n.nbPlayers(nb),
            value: numbers.nbPlayers,
          ),
          const SizedBox(height: 8.0),
          _AnimatedLobbyNumber(
            labelBuilder: (nb) => context.l10n.nbGamesInPlay(nb),
            value: numbers.nbGames,
          ),
        ],
      ),
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Column(
          children: [
            Text(''),
            SizedBox(height: 8.0),
            Text(''),
          ],
        ),
      ),
      error: (err, __) {
        return const SizedBox.shrink();
      },
    );
  }
}

class _AnimatedLobbyNumber extends StatefulWidget {
  const _AnimatedLobbyNumber({
    required this.labelBuilder,
    required this.value,
  });

  final String Function(int) labelBuilder;
  final int value;

  @override
  State<_AnimatedLobbyNumber> createState() => _AnimatedLobbyNumberState();
}

class _AnimatedLobbyNumberState extends State<_AnimatedLobbyNumber> {
  int previousValue = 0;
  int value = 0;

  @override
  void didUpdateWidget(covariant _AnimatedLobbyNumber oldWidget) {
    previousValue = oldWidget.value;
    value = widget.value;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(
        begin: previousValue,
        end: value,
      ),
      duration: const Duration(milliseconds: 500),
      builder: (context, int value, _) {
        return Text(widget.labelBuilder(value));
      },
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
