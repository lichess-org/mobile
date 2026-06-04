import 'dart:async';

import 'package:chessground/chessground.dart';
import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/account/ongoing_game.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/game/game_board_params.dart';
import 'package:lichess_mobile/src/model/game/game_controller.dart';
import 'package:lichess_mobile/src/model/game/game_preferences.dart';
import 'package:lichess_mobile/src/model/game/playable_game.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/utils/chessboard.dart';
import 'package:lichess_mobile/src/utils/focus_detector.dart';
import 'package:lichess_mobile/src/utils/gestures_exclusion.dart';
import 'package:lichess_mobile/src/utils/immersive_mode.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/chat/chat_screen.dart';
import 'package:lichess_mobile/src/view/game/correspondence_clock_widget.dart';
import 'package:lichess_mobile/src/view/game/game_loading_board.dart';
import 'package:lichess_mobile/src/view/game/game_player.dart';
import 'package:lichess_mobile/src/view/game/game_result_dialog.dart';
import 'package:lichess_mobile/src/view/game/game_screen_providers.dart';
import 'package:lichess_mobile/src/view/tournament/tournament_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/board.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/clock.dart';
import 'package:lichess_mobile/src/widgets/game_layout.dart';
import 'package:lichess_mobile/src/widgets/move_list.dart';
import 'package:lichess_mobile/src/widgets/platform_alert_dialog.dart';
import 'package:lichess_mobile/src/widgets/yes_no_dialog.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

typedef LoadingPosition = ({String? fen, Move? lastMove, Side? orientation});

/// Game body for the [GameScreen].
///
/// This widget is responsible for displaying the board, the clocks, the players,
/// and the bottom bar.
///
/// It also listens to the game state and shows dialogs when necessary.
///
/// Handles the immersive mode through focus detection, and the pop scope to
/// prevent the user from going back to the previous screen.
class GameBody extends ConsumerWidget {
  const GameBody({
    required this.gameId,
    this.loadingPosition,
    required this.whiteClockKey,
    required this.blackClockKey,
    required this.onLoadGameCallback,
    required this.onNewOpponentCallback,
    required this.boardKey,
  });

  final GameFullId gameId;

  final LoadingPosition? loadingPosition;

  /// [GlobalKey] for the white clock.
  ///
  /// This parameter is mandatory because the clock state needs to be preserved
  /// when the orientation changes on tablet.
  final GlobalKey whiteClockKey;

  /// [GlobalKey] for the black clock.
  ///
  /// This parameter is mandatory because the clock state needs to be preserved
  /// when the orientation changes on tablet.
  final GlobalKey blackClockKey;

  /// [GlobalKey] for the board.
  ///
  /// Used to set gestures exclusion on android.
  final GlobalKey boardKey;

  /// Callback to load a new game. Used when the game is finished and the user
  /// wants to play a rematch, or when switching through games in correspondence
  /// chess.
  final void Function(GameFullId id) onLoadGameCallback;

  /// Callback to load a new opponent.
  final void Function(PlayableGame game) onNewOpponentCallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = gameControllerProvider(gameId);

    ref.listen(
      ctrlProvider,
      (prev, state) => _stateListener(prev, state, context: context, ref: ref),
    );

    // Only watch the coarse async phase here so a move (which changes the
    // GameState value but not the phase) does NOT rebuild the whole body. The
    // playable shell, board, players and move list are driven by [_PlayableGameBoard]
    // and its self-watching children instead.
    switch (ref.watch(ctrlProvider.select(_gamePhaseOf))) {
      case _GamePhase.error:
        final state = ref.read(ctrlProvider);
        debugPrint(
          'SEVERE: [GameBody] could not load game data; ${state.error}\n${state.stackTrace}',
        );
        return const LoadGameError('Sorry, we could not load the game. Please try again later.');
      case _GamePhase.data:
        return _PlayableGameBoard(
          gameId: gameId,
          whiteClockKey: whiteClockKey,
          blackClockKey: blackClockKey,
          boardKey: boardKey,
          onLoadGameCallback: onLoadGameCallback,
          onNewOpponentCallback: onNewOpponentCallback,
        );
      case _GamePhase.refreshing:
        final value = ref.read(ctrlProvider).requireValue;
        return StandaloneGameLoadingContent(
          position: (
            fen: value.game.lastPosition.fen,
            lastMove: value.game.moveAt(value.stepCursor),
            orientation: value.game.youAre,
          ),
          userActionsBar: _GameBottomBar(
            id: gameId,
            onLoadGameCallback: onLoadGameCallback,
            onNewOpponentCallback: onNewOpponentCallback,
          ),
        );
      case _GamePhase.loading:
        return StandaloneGameLoadingContent(
          position: loadingPosition,
          userActionsBar: _GameBottomBar(
            id: gameId,
            onLoadGameCallback: onLoadGameCallback,
            onNewOpponentCallback: onNewOpponentCallback,
          ),
        );
    }
  }

  void _stateListener(
    AsyncValue<GameState>? prev,
    AsyncValue<GameState> state, {
    required BuildContext context,
    required WidgetRef ref,
  }) {
    if (state.hasValue) {
      if (!state.requireValue.game.playable) {
        WakelockPlus.disable();
      }
      if (prev?.value?.isZenModeActive == true && state.requireValue.isZenModeActive == false) {
        if (context.mounted) {
          // when Zen mode is disabled, reload chat data
          ref
              .read(gameControllerProvider(gameId).notifier)
              .onToggleChat(state.requireValue.chatOptions != null);
        }
      }

      // If the game is no longer playable, show the game end dialog.
      // We want to show it only once, whether the game is already finished on
      // first load or not.
      if ((prev?.hasValue != true || prev!.requireValue.game.playable == true) &&
          state.requireValue.game.playable == false) {
        Timer(const Duration(milliseconds: 500), () {
          if (context.mounted) {
            showAdaptiveDialog<void>(
              context: context,
              builder: (context) =>
                  GameResultDialog(id: gameId, onNewOpponentCallback: onNewOpponentCallback),
              barrierDismissible: true,
            );
          }
        });
      }

      // true when the game was loaded, playable, and just finished
      if (prev?.value?.game.playable == true && state.requireValue.game.playable == false) {
        clearAndroidBoardGesturesExclusion();
      }
      // true when the game was not loaded: handles rematches
      else if (prev?.hasValue != true) {
        final game = state.requireValue.game;
        if (game.meta.speed != Speed.correspondence && game.playable) {
          setAndroidBoardGesturesExclusion(
            boardKey,
            withImmersiveMode:
                ref.read(boardPreferencesProvider).immersiveModeWhilePlaying ?? false,
          );
        }
      }
    }

    if (prev?.hasValue == true && state.hasValue) {
      // Opponent is gone long enough to show the claim win dialog.
      if (!prev!.requireValue.game.canClaimWin && state.requireValue.game.canClaimWin) {
        if (context.mounted) {
          showAdaptiveDialog<void>(
            context: context,
            builder: (context) => _ClaimWinDialog(id: gameId),
            barrierDismissible: true,
          );
        }
      }

      if (state.requireValue.redirectGameId != null) {
        // Be sure to pop any dialogs that might be on top of the game screen.
        Navigator.of(context).popUntil((route) => route is! PopupRoute);
        onLoadGameCallback(state.requireValue.redirectGameId!);
      }
    }
  }
}

/// Coarse rendering phase for the [GameBody], derived from the controller's
/// [AsyncValue]. Used so that per-move state changes (which stay in the [data]
/// phase) do not rebuild the whole body.
enum _GamePhase { loading, data, refreshing, error }

_GamePhase _gamePhaseOf(AsyncValue<GameState> state) => switch (state) {
  AsyncError() => _GamePhase.error,
  AsyncData(isRefreshing: true) => _GamePhase.refreshing,
  AsyncData() => _GamePhase.data,
  _ => _GamePhase.loading,
};

/// The playable game shell for the high-performance path.
///
/// Owns the [ChessboardController] and drives it directly via [ref.listen] on a
/// narrow position selector, so a move repaints the board's [CustomPainter]
/// without rebuilding this widget. The shell itself (orientation, board settings,
/// player table slots) only rebuilds on rare changes (board flip, zen toggle,
/// game-end). Player tables, the move list and the bottom bar are self-watching
/// children that rebuild independently.
class _PlayableGameBoard extends ConsumerStatefulWidget {
  const _PlayableGameBoard({
    required this.gameId,
    required this.whiteClockKey,
    required this.blackClockKey,
    required this.boardKey,
    required this.onLoadGameCallback,
    required this.onNewOpponentCallback,
  });

  final GameFullId gameId;
  final GlobalKey whiteClockKey;
  final GlobalKey blackClockKey;
  final GlobalKey boardKey;
  final void Function(GameFullId id) onLoadGameCallback;
  final void Function(PlayableGame game) onNewOpponentCallback;

  @override
  ConsumerState<_PlayableGameBoard> createState() => _PlayableGameBoardState();
}

class _PlayableGameBoardState extends ConsumerState<_PlayableGameBoard> {
  late final ChessboardController _controller;

  /// Ply of the position currently shown on the board. Used to tell a forward
  /// move (opponent move) from a position revert (takeback), so a queued premove
  /// is only ever played on the former.
  late int _lastPly;

  late final _ctrlProvider = gameControllerProvider(widget.gameId);

  @override
  void initState() {
    super.initState();
    final state = ref.read(_ctrlProvider).requireValue;
    final boardPrefs = ref.read(boardPreferencesProvider);
    _lastPly = state.currentPosition.ply;
    _controller = ChessboardController(
      game: buildGameData(
        fen: state.currentPosition.fen,
        variant: state.game.meta.variant,
        position: state.currentPosition,
        playerSide: _playerSide(state),
        lastMove: state.game.moveAt(state.stepCursor),
        castlingMethod: boardPrefs.castlingMethod,
        boardHighlights: boardPrefs.boardHighlights,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  PlayerSide _playerSide(GameState state) {
    if (!state.game.playable || state.isReplaying) return PlayerSide.none;
    return (state.game.youAre ?? Side.white) == Side.white ? PlayerSide.white : PlayerSide.black;
  }

  /// Pushes the current controller position from the latest [GameState], without
  /// rebuilding this widget. Called from [ref.listen] whenever the position-relevant
  /// slice of the state changes.
  void _applyBoardUpdate() {
    final state = ref.read(_ctrlProvider).value;
    if (state == null) return;
    final boardPrefs = ref.read(boardPreferencesProvider);
    final fen = state.currentPosition.fen;
    final newPly = state.currentPosition.ply;
    final lastMove = state.game.moveAt(state.stepCursor);
    final gameData = buildGameData(
      fen: fen,
      variant: state.game.meta.variant,
      position: state.currentPosition,
      playerSide: _playerSide(state),
      lastMove: lastMove,
      castlingMethod: boardPrefs.castlingMethod,
      boardHighlights: boardPrefs.boardHighlights,
    );

    final fenChanged = fen != _controller.fen;
    // A revert (e.g. takeback, or a reconnection that rolled the line back)
    // shortens the game line. A premove must never be played in that case.
    final isRevert = newPly < _lastPly;
    _lastPly = newPly;

    if (state.isReplaying) {
      // History navigation — animate and clear premove on position change.
      _controller.updatePosition(gameData, resetPremove: fenChanged);
      return;
    }

    if (!fenChanged) {
      // Only game metadata changed (e.g. playable went false).
      _controller.updatePosition(gameData);
      return;
    }

    if (isRevert) {
      // Position was rolled back: clear any queued premove instead of playing it.
      _controller.updatePosition(gameData, resetPremove: true);
      return;
    }

    // A move was added to the game (a live opponent move, or one that arrived
    // during a reconnection): advance the board and play any queued premove.
    _controller.updatePosition(gameData);
    final explosion = state.stepCursor > 0
        ? atomicExplosionSquares(
            state.game.positionAt(state.stepCursor - 1),
            state.game.moveAt(state.stepCursor),
          )
        : null;
    if (explosion != null) _controller.triggerExplosion(explosion);
    tryExecutePremove(
      _controller,
      state.currentPosition,
      (move) => ref.read(_ctrlProvider.notifier).userMove(move, isPremove: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Drive the board controller on position changes without rebuilding.
    ref.listen(
      _ctrlProvider.select((s) {
        final state = s.value;
        if (state == null) return null;
        return (
          fen: state.currentPosition.fen,
          lastMoveUci: state.game.moveAt(state.stepCursor)?.uci,
          isReplaying: state.isReplaying,
          playable: state.game.playable,
        );
      }),
      (prev, next) {
        if (next != null) _applyBoardUpdate();
      },
    );

    final boardPrefs = ref.watch(boardPreferencesProvider);
    final blindfoldMode = ref.watch(
      gamePreferencesProvider.select((p) => p.blindfoldMode ?? false),
    );
    final isBoardTurned = ref.watch(isBoardTurnedProvider);

    // Shell-affecting slice: only rebuilds the layout on rare changes.
    final shell = ref.watch(_ctrlProvider.select(_shellOf));
    if (shell == null) return const SizedBox.shrink();

    final orientation = variantBoardOrientation(
      variant: shell.variant,
      youAre: shell.youAre,
      isBoardTurned: isBoardTurned,
    );

    final topPlayerIsBlack =
        shell.youAre == Side.white && !isBoardTurned || shell.youAre == Side.black && isBoardTurned;
    final topSide = topPlayerIsBlack ? Side.black : Side.white;
    final bottomSide = topPlayerIsBlack ? Side.white : Side.black;

    final animationDuration = shell.speed == Speed.ultraBullet || shell.speed == Speed.bullet
        ? Duration.zero
        : boardPrefs.pieceAnimationDuration;

    return FocusDetector(
      onFocusRegained: () {
        if (context.mounted) {
          ref.read(_ctrlProvider.notifier).onFocusRegained();
        }
      },
      onForegroundLost: () {
        if (context.mounted) {
          ref.read(_ctrlProvider.notifier).onForegroundLost();
        }
      },
      child: WakelockWidget(
        shouldEnableOnFocusGained: () => shell.playable,
        child: GameLayout(
          boardKey: widget.boardKey,
          controllerParams: ControllerBoardParams(
            controller: _controller,
            variant: shell.variant,
            pockets: shell.pockets,
            onMove: (move, {viaDragAndDrop}) {
              ref.read(_ctrlProvider.notifier).userMove(move, viaDragAndDrop: viaDragAndDrop);
            },
          ),
          boardSettingsOverrides: BoardSettingsOverrides(
            animationDuration: animationDuration,
            autoQueenPromotion: shell.canAutoQueen,
            autoQueenPromotionOnPremove: shell.canAutoQueenOnPremove,
            blindfoldMode: blindfoldMode,
            enablePremoves: shell.canPremove && boardPrefs.premoves,
          ),
          orientation: orientation,
          topTable: _GamePlayerTable(
            gameId: widget.gameId,
            side: topSide,
            clockKey: topSide == Side.white ? widget.whiteClockKey : widget.blackClockKey,
          ),
          bottomTable: shell.showClaimWinCountdown
              ? _ClaimWinCountdown(
                  gameId: widget.gameId,
                  canClaimWin: shell.canClaimWin,
                  countdown: shell.opponentLeftCountdown!,
                )
              : _GamePlayerTable(
                  gameId: widget.gameId,
                  side: bottomSide,
                  clockKey: bottomSide == Side.white ? widget.whiteClockKey : widget.blackClockKey,
                ),
          moveListBuilder: (type) => _GameMoveList(gameId: widget.gameId, type: type),
          zenMode: shell.zen,
          userActionsBar: _GameBottomBar(
            id: widget.gameId,
            onLoadGameCallback: widget.onLoadGameCallback,
            onNewOpponentCallback: widget.onNewOpponentCallback,
          ),
        ),
      ),
    );
  }
}

/// Rare-changing fields that affect the [_PlayableGameBoard] shell layout.
typedef _ShellData = ({
  Variant variant,
  Side youAre,
  Speed speed,
  bool zen,
  bool playable,
  bool canPremove,
  bool canAutoQueen,
  bool canAutoQueenOnPremove,
  bool showClaimWinCountdown,
  bool canClaimWin,
  (Duration, DateTime)? opponentLeftCountdown,
  // Crazyhouse pockets (null for other variants). [Pockets] has value equality,
  // so this both supplies the pocket counts and drives the shell to rebuild on
  // each move in Crazyhouse, while other variants keep the build-once shell.
  Pockets? pockets,
});

_ShellData? _shellOf(AsyncValue<GameState> state) {
  final s = state.value;
  if (s == null) return null;
  return (
    variant: s.game.meta.variant,
    youAre: s.game.youAre ?? Side.white,
    speed: s.game.meta.speed,
    zen: s.isZenModeActive,
    playable: s.game.playable,
    canPremove: s.canPremove,
    canAutoQueen: s.canAutoQueen,
    canAutoQueenOnPremove: s.canAutoQueenOnPremove,
    showClaimWinCountdown: s.canShowClaimWinCountdown && s.opponentLeftCountdown != null,
    canClaimWin: s.game.canClaimWin,
    opponentLeftCountdown: s.opponentLeftCountdown,
    pockets: s.currentPosition.pockets,
  );
}

/// A self-watching player table (clock, name, material diff) for one [side].
///
/// Lives inside the [_PlayableGameBoard] shell and rebuilds independently on the
/// state it actually needs, so it does not force the shell or board to rebuild.
class _GamePlayerTable extends ConsumerWidget {
  const _GamePlayerTable({required this.gameId, required this.side, required this.clockKey});

  final GameFullId gameId;
  final Side side;
  final GlobalKey clockKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = gameControllerProvider(gameId);

    // Narrow watch: only the slice this table renders. In particular it excludes
    // spectator-count and other unrelated state churn (nbWatchers, watcherNames,
    // redirectGameId, …) so a spectator joining/leaving no longer rebuilds the
    // player tables. [liveClock]'s notifiers are stable across emissions, so it
    // doesn't trigger spurious rebuilds either.
    final data = ref.watch(
      ctrlProvider.select((s) {
        final state = s.value;
        if (state == null) return null;
        return (
          game: state.game,
          gameFullId: state.gameFullId,
          stepCursor: state.stepCursor,
          timeToMove: state.timeToMove,
          canGoForward: state.canGoForward,
          isZenModeActive: state.isZenModeActive,
          moveToConfirm: state.moveToConfirm,
          liveClock: state.liveClock,
          activeClockSide: state.activeClockSide,
        );
      }),
    );
    if (data == null) return const SizedBox.shrink();

    final boardPrefs = ref.watch(boardPreferencesProvider);
    final clockTenths = ref.watch(
      accountPreferencesProvider.select((prefs) => prefs.value?.clockTenths),
    );

    final game = data.game;
    final youAre = game.youAre ?? Side.white;
    final mePlaying = youAre == side;

    final matchupData = game.white.user != null && game.black.user != null
        ? ref
              .watch(
                crosstableProvider((
                  userId1: game.white.user!.id,
                  userId2: game.black.user!.id,
                  matchup: true,
                )),
              )
              .value
              ?.matchup
        : null;

    final sideUser = side == Side.white ? game.white.user : game.black.user;

    return GamePlayer(
      game: game,
      side: side,
      socketUri: GameController.socketUri(data.gameFullId),
      matchupScore: matchupData?.users[sideUser!.id],
      materialDiff: boardPrefs.materialDifferenceFormat.visible
          ? game.materialDiffAt(data.stepCursor, side)
          : null,
      materialDifferenceFormat: boardPrefs.materialDifferenceFormat,
      timeToMove: game.sideToMove == side ? data.timeToMove : null,
      mePlaying: mePlaying,
      canGoForward: data.canGoForward,
      zenMode: data.isZenModeActive,
      clockPosition: boardPrefs.clockPosition,
      confirmMoveCallbacks: mePlaying && data.moveToConfirm != null
          ? (
              confirm: () {
                ref.read(ctrlProvider.notifier).confirmMove();
              },
              cancel: () {
                ref.read(ctrlProvider.notifier).cancelMove();
              },
            )
          : null,
      clock: data.liveClock != null
          ? RepaintBoundary(
              child: ValueListenableBuilder(
                key: clockKey,
                valueListenable: side == Side.white ? data.liveClock!.white : data.liveClock!.black,
                builder: (context, value, _) {
                  return Clock(
                    key: ValueKey('${side.name}-clock'),
                    timeLeft: value,
                    active: data.activeClockSide == side,
                    emergencyThreshold: youAre == side ? game.meta.clock?.emergency : null,
                    clockTenths: clockTenths,
                  );
                },
              ),
            )
          : game.correspondenceClock != null && game.lastPosition.fullmoves > 1
          ? CorrespondenceClock(
              duration: side == Side.white
                  ? game.correspondenceClock!.white
                  : game.correspondenceClock!.black,
              active: data.activeClockSide == side,
              resetId: game.correspondenceClock!.resetId,
              onFlag: () => ref.read(ctrlProvider.notifier).onFlag(),
            )
          : null,
    );
  }
}

/// A self-watching move list, driven by the game controller so move updates do
/// not force the [GameLayout] shell to rebuild.
class _GameMoveList extends ConsumerWidget {
  const _GameMoveList({required this.gameId, required this.type});

  final GameFullId gameId;
  final MoveListType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = gameControllerProvider(gameId);
    final data = ref.watch(
      ctrlProvider.select((s) {
        final state = s.value;
        return state == null ? null : (steps: state.game.steps, cursor: state.stepCursor);
      }),
    );
    if (data == null) return const SizedBox.shrink();

    return MoveList(
      type: type,
      slicedMoves: data.steps
          .skip(1)
          .indexed
          .map((e) => MapEntry(e.$1, e.$2.sanMove!.san))
          .slices(2),
      currentMoveIndex: data.cursor,
      onSelectMove: (moveIndex) {
        ref.read(ctrlProvider.notifier).cursorAt(moveIndex);
      },
    );
  }
}

class _GameBottomBar extends ConsumerWidget {
  const _GameBottomBar({
    required this.id,
    required this.onLoadGameCallback,
    required this.onNewOpponentCallback,
  });

  final GameFullId id;
  final void Function(GameFullId id) onLoadGameCallback;
  final void Function(PlayableGame game) onNewOpponentCallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ongoingGames = ref.watch(ongoingGamesProvider);
    final gamePrefs = ref.watch(gamePreferencesProvider);
    final boardPreferences = ref.watch(boardPreferencesProvider);
    final kidModeAsync = ref.watch(kidModeProvider);

    // Narrow watch: only the discrete flags this bar renders, so the heavy
    // menu/resign/draw/chat buttons do not rebuild on every move (the per-move
    // prev/next state is isolated in [_MoveNavButton]). Spectator-count and
    // other unrelated state churn no longer rebuilds the bar either.
    final data = ref.watch(
      gameControllerProvider(id).select((s) {
        final gameState = s.value;
        if (gameState == null) return null;
        final game = gameState.game;
        return (
          canBerserk: gameState.canBerserk,
          hasBerserked: gameState.hasBerserked,
          playable: game.playable,
          finished: game.finished,
          resignable: game.resignable,
          offeringDraw: game.opponent?.offeringDraw == true,
          isThreefoldRepetition: game.isThreefoldRepetition == true,
          proposingTakeback: game.opponent?.proposingTakeback == true,
          isCorrespondence: game.meta.speed == Speed.correspondence,
          numPremoveLines: game.correspondenceForecast?.length,
          chatOptions: gameState.chatOptions,
        );
      }),
    );

    if (data == null) return const BottomBar.empty();

    final canShowChat =
        gamePrefs.enableChat == true && data.chatOptions != null && kidModeAsync.value == false;
    final numPremoveLines = data.numPremoveLines;

    return BottomBar(
      children: [
        BottomBarButton(
          label: context.l10n.menu,
          onTap: () {
            _showGameMenu(context, ref);
          },
          icon: Icons.menu,
        ),
        if (data.canBerserk)
          BottomBarButton(
            label: context.l10n.arenaBerserk,
            onTap: data.canBerserk && !data.hasBerserked
                ? ref.read(gameControllerProvider(id).notifier).berserk
                : null,
            icon: LichessIcons.body_cut,
          ),
        if (data.playable && data.offeringDraw)
          BottomBarButton(
            label: context.l10n.yourOpponentOffersADraw,
            highlighted: true,
            onTap: () {
              showAdaptiveDialog<void>(
                context: context,
                builder: (context) => _GameNegotiationDialog(
                  title: Text(context.l10n.yourOpponentOffersADraw),
                  onAccept: () {
                    ref.read(gameControllerProvider(id).notifier).offerOrAcceptDraw();
                  },
                  onDecline: () {
                    ref.read(gameControllerProvider(id).notifier).cancelOrDeclineDraw();
                  },
                ),
                barrierDismissible: true,
              );
            },
            icon: Icons.handshake_outlined,
          )
        else if (data.playable && data.isThreefoldRepetition)
          BottomBarButton(
            label: context.l10n.threefoldRepetition,
            highlighted: true,
            onTap: () {
              showAdaptiveDialog<void>(
                context: context,
                builder: (context) => _ThreefoldDialog(id: id),
                barrierDismissible: true,
              );
            },
            icon: Icons.handshake_outlined,
          )
        else if (data.playable && data.proposingTakeback)
          BottomBarButton(
            label: context.l10n.yourOpponentProposesATakeback,
            highlighted: true,
            onTap: () {
              showAdaptiveDialog<void>(
                context: context,
                builder: (context) => _GameNegotiationDialog(
                  title: Text(context.l10n.yourOpponentProposesATakeback),
                  onAccept: () {
                    ref.read(gameControllerProvider(id).notifier).acceptTakeback();
                  },
                  onDecline: () {
                    ref.read(gameControllerProvider(id).notifier).cancelOrDeclineTakeback();
                  },
                ),
                barrierDismissible: true,
              );
            },
            icon: CupertinoIcons.arrowshape_turn_up_left,
          )
        else if (data.playable && data.isCorrespondence) ...[
          BottomBarButton(
            label: 'Go to the next game',
            icon: Icons.skip_next,
            onTap: ongoingGames.maybeWhen(
              data: (games) {
                final gamesWithMyTurn = games.where((g) => g.isMyTurn).toList();
                if (gamesWithMyTurn.isEmpty) return null;
                final currentIndex = gamesWithMyTurn.indexWhere((g) => g.fullId == id);
                // If the current game is the only one where it's my turn, disable.
                if (currentIndex != -1 && gamesWithMyTurn.length == 1) return null;
                final nextIndex = (currentIndex + 1) % gamesWithMyTurn.length;
                return () => onLoadGameCallback(gamesWithMyTurn[nextIndex].fullId);
              },
              orElse: () => null,
            ),
          ),
          BottomBarButton(
            label: context.l10n.analysis,
            icon: Icons.biotech,
            badgeLabel: (numPremoveLines ?? 0) > 0 ? numPremoveLines.toString() : null,
            onTap: () {
              final analysisOptions = ref
                  .read(gameControllerProvider(id))
                  .requireValue
                  .analysisOptions;
              Navigator.of(context).push(AnalysisScreen.buildRoute(analysisOptions));
            },
          ),
        ] else if (data.finished)
          BottomBarButton(
            label: context.l10n.mobileShowResult,
            onTap: () {
              showAdaptiveDialog<void>(
                context: context,
                builder: (context) =>
                    GameResultDialog(id: id, onNewOpponentCallback: onNewOpponentCallback),
                barrierDismissible: true,
              );
            },
            icon: Icons.info_outline,
          )
        else
          BottomBarButton(
            label: context.l10n.resign,
            onTap: data.resignable
                ? boardPreferences.confirmResignAndDraw
                      ? () => _showConfirmDialog(
                          context,
                          description: Text(context.l10n.resignTheGame),
                          onConfirm: () {
                            ref.read(gameControllerProvider(id).notifier).resignGame();
                          },
                        )
                      : () {
                          ref.read(gameControllerProvider(id).notifier).resignGame();
                        }
                : null,
            icon: Icons.flag_outlined,
          ),
        if (canShowChat) ChatBottomBarButton(options: data.chatOptions!),
        _MoveNavButton(id: id, forward: false),
        _MoveNavButton(id: id, forward: true),
      ],
    );
  }

  Future<void> _showGameMenu(BuildContext context, WidgetRef ref) {
    final gameState = ref.read(gameControllerProvider(id)).requireValue;
    final boardPreferences = ref.read(boardPreferencesProvider);
    return showAdaptiveActionSheet(
      context: context,
      actions: [
        BottomSheetAction(
          makeLabel: (context) => Text(context.l10n.flipBoard),
          onPressed: () {
            ref.read(isBoardTurnedProvider.notifier).toggle();
          },
        ),
        if (gameState.game.playable && gameState.game.meta.speed == Speed.correspondence ||
            gameState.game.finished)
          BottomSheetAction(
            makeLabel: (context) => Text(context.l10n.analysis),
            onPressed: () {
              Navigator.of(context).push(AnalysisScreen.buildRoute(gameState.analysisOptions));
            },
          ),
        if (gameState.game.abortable)
          BottomSheetAction(
            makeLabel: (context) => Text(context.l10n.abortGame),
            onPressed: () {
              ref.read(gameControllerProvider(id).notifier).abortGame();
            },
          ),
        if (gameState.game.meta.clock != null && gameState.game.canGiveTime)
          BottomSheetAction(
            makeLabel: (context) => Text(
              context.l10n.giveNbSeconds(gameState.game.meta.clock!.moreTime?.inSeconds ?? 15),
            ),
            onPressed: () {
              ref.read(gameControllerProvider(id).notifier).moreTime();
            },
          ),
        if (gameState.game.canTakeback)
          BottomSheetAction(
            makeLabel: (context) => Text(context.l10n.takeback),
            onPressed: () {
              ref.read(gameControllerProvider(id).notifier).offerTakeback();
            },
          ),
        if (gameState.game.me?.proposingTakeback == true)
          BottomSheetAction(
            makeLabel: (context) => Text(context.l10n.mobileCancelTakebackOffer),
            isDestructiveAction: true,
            onPressed: () {
              ref.read(gameControllerProvider(id).notifier).cancelOrDeclineTakeback();
            },
          ),
        if (gameState.canOfferDraw)
          BottomSheetAction(
            makeLabel: (context) => Text(context.l10n.offerDraw),
            onPressed: boardPreferences.confirmResignAndDraw
                ? () => _showConfirmDialog(
                    context,
                    description: Text(context.l10n.offerDraw),
                    onConfirm: () {
                      ref.read(gameControllerProvider(id).notifier).offerOrAcceptDraw();
                    },
                  )
                : () {
                    ref.read(gameControllerProvider(id).notifier).offerOrAcceptDraw();
                  },
          ),
        if (gameState.game.resignable)
          BottomSheetAction(
            makeLabel: (context) => Text(context.l10n.resign),
            onPressed: boardPreferences.confirmResignAndDraw
                ? () => _showConfirmDialog(
                    context,
                    description: Text(context.l10n.resignTheGame),
                    onConfirm: () {
                      ref.read(gameControllerProvider(id).notifier).resignGame();
                    },
                  )
                : () {
                    ref.read(gameControllerProvider(id).notifier).resignGame();
                  },
          ),
        if (gameState.game.canClaimWin) ...[
          BottomSheetAction(
            makeLabel: (context) => Text(context.l10n.forceDraw),
            dismissOnPress: true,
            onPressed: () {
              ref.read(gameControllerProvider(id).notifier).forceDraw();
            },
          ),
          BottomSheetAction(
            makeLabel: (context) => Text(context.l10n.forceResignation),
            dismissOnPress: true,
            onPressed: () {
              ref.read(gameControllerProvider(id).notifier).forceResign();
            },
          ),
        ],
        if (gameState.game.me?.offeringRematch == true)
          BottomSheetAction(
            makeLabel: (context) => Text(context.l10n.cancelRematchOffer),
            dismissOnPress: true,
            isDestructiveAction: true,
            onPressed: () {
              ref.read(gameControllerProvider(id).notifier).declineRematch();
            },
          )
        else if (gameState.canOfferRematch && gameState.game.opponent?.onGame == true)
          BottomSheetAction(
            makeLabel: (context) => Text(context.l10n.rematch),
            dismissOnPress: true,
            onPressed: () {
              ref.read(gameControllerProvider(id).notifier).proposeOrAcceptRematch();
            },
          ),
        if (gameState.canGetNewOpponent)
          BottomSheetAction(
            makeLabel: (context) => Text(context.l10n.newOpponent),
            onPressed: () => onNewOpponentCallback(gameState.game),
          ),
        if (gameState.tournament?.isFinished == true)
          BottomSheetAction(
            makeLabel: (context) => Text(context.l10n.backToTournament),
            onPressed: () {
              Navigator.of(context).push(TournamentScreen.buildRoute(gameState.tournament!.id));
            },
          ),
      ],
    );
  }

  Future<void> _showConfirmDialog(
    BuildContext context, {
    required Widget description,
    required VoidCallback onConfirm,
  }) async {
    final result = await showAdaptiveDialog<bool>(
      context: context,
      builder: (context) => YesNoDialog(
        title: Text(context.l10n.mobileAreYouSure),
        content: description,
        onYes: () {
          return Navigator.of(context).pop(true);
        },
        onNo: () => Navigator.of(context).pop(false),
      ),
    );
    if (result == true) {
      onConfirm();
    }
  }
}

/// A single self-watching move-navigation button (previous or next) for the
/// game bottom bar.
///
/// Isolated from [_GameBottomBar] so that the per-move changes it depends on
/// (cursor position, blink hint) repaint only this button instead of rebuilding
/// the whole bar on every move.
class _MoveNavButton extends ConsumerWidget {
  const _MoveNavButton({required this.id, required this.forward});

  final GameFullId id;
  final bool forward;

  void _move(WidgetRef ref) {
    final notifier = ref.read(gameControllerProvider(id).notifier);
    if (forward) {
      notifier.cursorForward();
    } else {
      notifier.cursorBackward();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!forward) {
      final canGoBackward = ref.watch(
        gameControllerProvider(id).select((s) => s.value?.canGoBackward ?? false),
      );
      return RepeatButton(
        onLongPress: canGoBackward ? () => _move(ref) : null,
        child: BottomBarButton(
          onTap: canGoBackward ? () => _move(ref) : null,
          label: 'Previous',
          icon: CupertinoIcons.chevron_back,
          showTooltip: false,
        ),
      );
    }

    final (canGoForward, blink) = ref.watch(
      gameControllerProvider(id).select((s) {
        final state = s.value;
        if (state == null) return (false, false);
        return (
          state.canGoForward,
          state.game.playable &&
              state.stepCursor != state.game.steps.length - 1 &&
              state.game.sideToMove == state.game.youAre,
        );
      }),
    );
    return RepeatButton(
      onLongPress: canGoForward ? () => _move(ref) : null,
      child: BottomBarButton(
        onTap: canGoForward ? () => _move(ref) : null,
        label: context.l10n.next,
        icon: CupertinoIcons.chevron_forward,
        showTooltip: false,
        blink: blink,
      ),
    );
  }
}

class _GameNegotiationDialog extends StatelessWidget {
  const _GameNegotiationDialog({
    required this.title,
    required this.onAccept,
    required this.onDecline,
  });

  final Widget title;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  @override
  Widget build(BuildContext context) {
    void decline() {
      Navigator.of(context).pop();
      onDecline();
    }

    void accept() {
      Navigator.of(context).pop();
      onAccept();
    }

    return AlertDialog.adaptive(
      content: title,
      actions: [
        PlatformDialogAction(onPressed: accept, child: Text(context.l10n.accept)),
        PlatformDialogAction(onPressed: decline, child: Text(context.l10n.decline)),
      ],
    );
  }
}

class _ThreefoldDialog extends ConsumerWidget {
  const _ThreefoldDialog({required this.id});

  final GameFullId id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = Text(context.l10n.threefoldRepetition);

    void decline() {
      Navigator.of(context).pop();
    }

    void accept() {
      Navigator.of(context).pop();
      ref.read(gameControllerProvider(id).notifier).claimDraw();
    }

    return AlertDialog.adaptive(
      content: content,
      actions: [
        PlatformDialogAction(onPressed: accept, child: Text(context.l10n.claimADraw)),
        PlatformDialogAction(onPressed: decline, child: Text(context.l10n.cancel)),
      ],
    );
  }
}

class _ClaimWinDialog extends ConsumerWidget {
  const _ClaimWinDialog({required this.id});

  final GameFullId id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = gameControllerProvider(id);
    final gameState = ref.watch(ctrlProvider).requireValue;

    final content = Text(context.l10n.opponentLeftChoices);

    void onClaimWin() {
      Navigator.of(context).pop();
      ref.read(ctrlProvider.notifier).forceResign();
    }

    void onClaimDraw() {
      Navigator.of(context).pop();
      ref.read(ctrlProvider.notifier).forceDraw();
    }

    return AlertDialog.adaptive(
      content: content,
      actions: [
        PlatformDialogAction(
          onPressed: gameState.game.canClaimWin ? onClaimWin : null,
          cupertinoIsDefaultAction: true,
          child: Text(context.l10n.forceResignation),
        ),
        PlatformDialogAction(
          onPressed: gameState.game.canClaimWin ? onClaimDraw : null,
          child: Text(context.l10n.forceDraw),
        ),
      ],
    );
  }
}

class _ClaimWinCountdown extends StatelessWidget {
  const _ClaimWinCountdown({
    required this.gameId,
    required this.canClaimWin,
    required this.countdown,
  });

  final GameFullId gameId;
  final bool canClaimWin;
  final (Duration, DateTime) countdown;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: CountdownClockBuilder(
          timeLeft: countdown.$1,
          clockUpdatedAt: countdown.$2,
          active: true,
          builder: (context, duration) {
            return InkWell(
              onTap: canClaimWin
                  ? () {
                      showAdaptiveDialog<void>(
                        context: context,
                        builder: (context) => _ClaimWinDialog(id: gameId),
                        barrierDismissible: true,
                      );
                    }
                  : null,
              child: Text(context.l10n.opponentLeftCounter(duration.inSeconds)),
            );
          },
        ),
      ),
    );
  }
}
