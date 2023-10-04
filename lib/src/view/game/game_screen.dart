import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartchess/dartchess.dart';
import 'package:chessground/chessground.dart' as cg;

import 'package:lichess_mobile/src/model/auth/auth_socket.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/game/game_controller.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/game_repository_providers.dart';
import 'package:lichess_mobile/src/model/lobby/lobby_game.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/board_table.dart';
import 'package:lichess_mobile/src/widgets/countdown_clock.dart';
import 'package:lichess_mobile/src/widgets/yes_no_dialog.dart';
import 'package:lichess_mobile/src/utils/immersive_mode.dart';
import 'package:lichess_mobile/src/utils/wakelock.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';

import 'game_screen_providers.dart';
import 'game_player.dart';
import 'ping_rating.dart';
import 'lobby_game_loading_board.dart';
import 'game_settings.dart';
import 'status_l10n.dart';

final RouteObserver<PageRoute<void>> gameRouteObserver =
    RouteObserver<PageRoute<void>>();

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({
    required this.seek,
    super.key,
  });

  final GameSeek seek;

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen>
    with AndroidImmersiveMode, RouteAware, Wakelock {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null && route is PageRoute) {
      gameRouteObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    gameRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPop() {
    ref.invalidate(userRecentGamesProvider);
    ref.invalidate(accountProvider);
    ref.invalidate(userActivityProvider);
    ref.read(authSocketProvider).close();
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = lobbyGameProvider(widget.seek);
    final gameId = ref.watch(gameProvider);

    return gameId.when(
      data: (id) {
        final ctrlProvider = gameControllerProvider(id);
        final gameState = ref.watch(ctrlProvider);
        return gameState.when(
          data: (state) {
            final body = _Body(
              gameState: state,
              ctrlProvider: ctrlProvider,
              gameProvider: gameProvider,
            );
            return PlatformWidget(
              androidBuilder: (context) => _androidBuilder(
                context: context,
                body: body,
                gameState: state,
                ctrlProvider: ctrlProvider,
              ),
              iosBuilder: (context) => _iosBuilder(
                context: context,
                body: body,
                gameState: state,
                ctrlProvider: ctrlProvider,
              ),
            );
          },
          loading: () => _loadingContent(),
          error: (e, s) {
            debugPrint(
              'SEVERE: [GameScreen] could not load game data; $e\n$s',
            );
            return _errorContent();
          },
        );
      },
      loading: () => _loadingContent(),
      error: (e, s) {
        debugPrint(
          'SEVERE: [GameScreen] could not create game; $e\n$s',
        );
        return _errorContent();
      },
    );
  }

  Widget _loadingContent() {
    return PlatformWidget(
      androidBuilder: (context) => _androidBuilder(
        context: context,
        body: LobbyGameLoadingBoard(widget.seek),
      ),
      iosBuilder: (context) => _iosBuilder(
        context: context,
        body: LobbyGameLoadingBoard(widget.seek),
      ),
    );
  }

  Widget _errorContent() {
    return PlatformWidget(
      androidBuilder: (context) => _androidBuilder(
        context: context,
        body: const CreateGameError(),
      ),
      iosBuilder: (context) => _iosBuilder(
        context: context,
        body: const CreateGameError(),
      ),
    );
  }

  Widget _androidBuilder({
    required BuildContext context,
    required Widget body,
    GameControllerProvider? ctrlProvider,
    GameState? gameState,
  }) {
    return Scaffold(
      appBar: AppBar(
        leading: gameState == null || gameState.game.playable == true
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
                child: PingRating(size: 24.0),
              )
            : null,
        title: _GameTitle(seek: widget.seek),
        actions: [
          SettingsButton(
            onPressed: () => showAdaptiveBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (_) => GameSettings(ctrlProvider),
            ),
          ),
        ],
      ),
      body: body,
    );
  }

  Widget _iosBuilder({
    required BuildContext context,
    required Widget body,
    GameControllerProvider? ctrlProvider,
    GameState? gameState,
  }) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        padding: const EdgeInsetsDirectional.only(end: 16.0),
        leading: gameState == null || gameState.game.playable == true
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: PingRating(size: 24.0),
              )
            : null,
        middle: _GameTitle(seek: widget.seek),
        trailing: SettingsButton(
          onPressed: () => showAdaptiveBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (_) => GameSettings(ctrlProvider),
          ),
        ),
      ),
      child: body,
    );
  }
}

class _GameTitle extends ConsumerWidget {
  const _GameTitle({
    required this.seek,
  });

  final GameSeek seek;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode =
        seek.rated ? ' • ${context.l10n.rated}' : ' • ${context.l10n.casual}';
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          seek.perf.icon,
          color: DefaultTextStyle.of(context).style.color,
        ),
        const SizedBox(width: 4.0),
        Text('${seek.timeIncrement.display}$mode'),
      ],
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({
    required this.gameState,
    required this.ctrlProvider,
    required this.gameProvider,
  });

  final GameState gameState;
  final GameControllerProvider ctrlProvider;
  final LobbyGameProvider gameProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      ctrlProvider,
      (prev, state) => _stateListener(
        prev,
        state,
        context: context,
        ref: ref,
      ),
    );
    final shouldShowMaterialDiff = ref.watch(
      boardPreferencesProvider.select(
        (prefs) => prefs.showMaterialDifference,
      ),
    );
    final blindfoldMode = ref.watch(
      boardPreferencesProvider.select(
        (prefs) => prefs.blindfoldMode,
      ),
    );

    final position = gameState.game.positionAt(gameState.stepCursor);
    final sideToMove = position.turn;
    final youAre = gameState.game.youAre ?? Side.white;

    final black = GamePlayer(
      player: gameState.game.black,
      materialDiff: shouldShowMaterialDiff
          ? gameState.game.materialDiffAt(gameState.stepCursor, Side.black)
          : null,
      timeToMove: sideToMove == Side.black ? gameState.timeToMove : null,
      shouldLinkToUserProfile: youAre != Side.black,
      mePlaying: youAre == Side.black,
      zenMode: gameState.isZenModeEnabled,
      confirmMoveCallbacks:
          youAre == Side.black && gameState.moveToConfirm != null
              ? (
                  confirm: () {
                    ref.read(ctrlProvider.notifier).confirmMove();
                  },
                  cancel: () {
                    ref.read(ctrlProvider.notifier).cancelMove();
                  },
                )
              : null,
      clock: gameState.game.clock != null
          ? CountdownClock(
              duration: gameState.game.clock!.black,
              active: gameState.activeClockSide == Side.black,
              emergencyThreshold:
                  youAre == Side.black ? gameState.game.clock?.emergency : null,
              onFlag: youAre == Side.black
                  ? () => ref.read(ctrlProvider.notifier).onFlag()
                  : null,
            )
          : null,
    );
    final white = GamePlayer(
      player: gameState.game.white,
      materialDiff: shouldShowMaterialDiff
          ? gameState.game.materialDiffAt(gameState.stepCursor, Side.white)
          : null,
      timeToMove: sideToMove == Side.white ? gameState.timeToMove : null,
      shouldLinkToUserProfile: youAre != Side.white,
      mePlaying: youAre == Side.white,
      zenMode: gameState.isZenModeEnabled,
      confirmMoveCallbacks:
          youAre == Side.white && gameState.moveToConfirm != null
              ? (
                  confirm: () {
                    ref.read(ctrlProvider.notifier).confirmMove();
                  },
                  cancel: () {
                    ref.read(ctrlProvider.notifier).cancelMove();
                  },
                )
              : null,
      clock: gameState.game.clock != null
          ? CountdownClock(
              duration: gameState.game.clock!.white,
              active: gameState.activeClockSide == Side.white,
              emergencyThreshold:
                  youAre == Side.white ? gameState.game.clock?.emergency : null,
              onFlag: youAre == Side.white
                  ? () => ref.read(ctrlProvider.notifier).onFlag()
                  : null,
            )
          : null,
    );

    final topPlayer = youAre == Side.white ? black : white;
    final bottomPlayer = youAre == Side.white ? white : black;
    final isBoardTurned = ref.watch(isBoardTurnedProvider);

    final content = Column(
      children: [
        Expanded(
          child: SafeArea(
            bottom: false,
            child: BoardTable(
              boardSettingsOverrides: BoardSettingsOverrides(
                autoQueenPromotion: gameState.canAutoQueen,
                autoQueenPromotionOnPremove: gameState.canAutoQueenOnPremove,
                blindfoldMode: blindfoldMode,
              ),
              onMove: (move, {isDrop, isPremove}) {
                ref.read(ctrlProvider.notifier).onUserMove(
                      Move.fromUci(move.uci)!,
                      isPremove: isPremove,
                      isDrop: isDrop,
                    );
              },
              onPremove: gameState.canPremove
                  ? (move) {
                      ref.read(ctrlProvider.notifier).setPremove(move);
                    }
                  : null,
              boardData: cg.BoardData(
                interactableSide:
                    gameState.game.playable && !gameState.isReplaying
                        ? youAre == Side.white
                            ? cg.InteractableSide.white
                            : cg.InteractableSide.black
                        : cg.InteractableSide.none,
                orientation: isBoardTurned ? youAre.opposite.cg : youAre.cg,
                fen: position.fen,
                lastMove: gameState.game.moveAt(gameState.stepCursor)?.cg,
                isCheck: position.isCheck,
                sideToMove: sideToMove.cg,
                validMoves: algebraicLegalMoves(position),
                premove: gameState.premove,
              ),
              topTable: topPlayer,
              bottomTable: gameState.canShowClaimWinCountdown &&
                      gameState.opponentLeftCountdown != null
                  ? _ClaimWinCountdown(
                      duration: gameState.opponentLeftCountdown!,
                    )
                  : bottomPlayer,
              moves: gameState.game.steps
                  .skip(1)
                  .map((e) => e.sanMove!.san)
                  .toList(growable: false),
              currentMoveIndex: gameState.stepCursor,
              onSelectMove: (moveIndex) {
                ref.read(ctrlProvider.notifier).cursorAt(moveIndex);
              },
            ),
          ),
        ),
        _GameBottomBar(
          gameState: gameState,
          ctrlProvider: ctrlProvider,
          gameProvider: gameProvider,
        ),
      ],
    );

    return WillPopScope(
      onWillPop: gameState.game.playable ? () async => false : null,
      child: content,
    );
  }

  void _stateListener(
    AsyncValue<GameState>? prev,
    AsyncValue<GameState> state, {
    required BuildContext context,
    required WidgetRef ref,
  }) {
    if (prev?.hasValue == true && state.hasValue) {
      // If the game is no longer playable, show the game end dialog.
      if (prev!.requireValue.game.playable == true &&
          state.requireValue.game.playable == false) {
        Timer(const Duration(milliseconds: 500), () {
          if (context.mounted) {
            showAdaptiveDialog<void>(
              context: context,
              builder: (context) => _GameEndDialog(
                ctrlProvider: ctrlProvider,
                gameProvider: gameProvider,
              ),
              barrierDismissible: true,
            );
          }
        });
      }

      // Opponent is gone long enough to show the claim win dialog.
      if (!prev.requireValue.game.canClaimWin &&
          state.requireValue.game.canClaimWin) {
        if (context.mounted) {
          showAdaptiveDialog<void>(
            context: context,
            builder: (context) => _ClaimWinDialog(
              ctrlProvider: ctrlProvider,
            ),
            barrierDismissible: true,
          );
        }
      }

      if (state.requireValue.redirectGameId != null) {
        // Be sure to pop any dialogs that might be on top of the game screen.
        Navigator.of(context).popUntil((route) => route is! RawDialogRoute);
        ref
            .read(gameProvider.notifier)
            .rematch(state.requireValue.redirectGameId!);
      }
    }
  }
}

class _GameBottomBar extends ConsumerWidget {
  const _GameBottomBar({
    required this.gameState,
    required this.ctrlProvider,
    required this.gameProvider,
  });

  final GameState gameState;
  final GameControllerProvider ctrlProvider;
  final LobbyGameProvider gameProvider;

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
            if (gameState.game.finished)
              BottomBarButton(
                label: context.l10n.gameAnalysis,
                shortLabel: 'Analysis',
                icon: Icons.biotech,
                onTap: () => pushPlatformRoute(
                  context,
                  builder: (_) => AnalysisScreen(
                    options: gameState.analysisOptions,
                    title: context.l10n.gameAnalysis,
                  ),
                ),
              ),
            if (gameState.game.playable &&
                gameState.game.opponent?.offeringDraw == true)
              BottomBarButton(
                label: context.l10n.yourOpponentOffersADraw,
                highlighted: true,
                shortLabel: context.l10n.draw,
                onTap: () {
                  showAdaptiveDialog<void>(
                    context: context,
                    builder: (context) => _GameNegotiationDialog(
                      title: Text(context.l10n.yourOpponentOffersADraw),
                      onAccept: () {
                        ref.read(ctrlProvider.notifier).offerOrAcceptDraw();
                      },
                      onDecline: () {
                        ref.read(ctrlProvider.notifier).cancelOrDeclineDraw();
                      },
                    ),
                    barrierDismissible: true,
                  );
                },
                icon: Icons.handshake_outlined,
              )
            else if (gameState.game.playable &&
                gameState.game.isThreefoldRepetition == true)
              BottomBarButton(
                label: context.l10n.threefoldRepetition,
                highlighted: true,
                shortLabel: context.l10n.draw,
                onTap: () {
                  showAdaptiveDialog<void>(
                    context: context,
                    builder: (context) =>
                        _ThreefoldDialog(ctrlProvider: ctrlProvider),
                    barrierDismissible: true,
                  );
                },
                icon: Icons.handshake_outlined,
              )
            else if (gameState.game.playable &&
                gameState.game.opponent?.proposingTakeback == true)
              BottomBarButton(
                label: context.l10n.yourOpponentProposesATakeback,
                highlighted: true,
                shortLabel: context.l10n.takeback,
                onTap: () {
                  showAdaptiveDialog<void>(
                    context: context,
                    builder: (context) => _GameNegotiationDialog(
                      title: Text(context.l10n.yourOpponentProposesATakeback),
                      onAccept: () {
                        ref.read(ctrlProvider.notifier).acceptTakeback();
                      },
                      onDecline: () {
                        ref
                            .read(ctrlProvider.notifier)
                            .cancelOrDeclineTakeback();
                      },
                    ),
                    barrierDismissible: true,
                  );
                },
                icon: CupertinoIcons.arrowshape_turn_up_left,
              )
            else
              const SizedBox(
                width: 44.0,
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
                showAndroidTooltip: false,
              ),
            ),
            RepeatButton(
              onLongPress:
                  gameState.canGoForward ? () => _moveForward(ref) : null,
              child: BottomBarButton(
                onTap: gameState.canGoForward ? () => _moveForward(ref) : null,
                label: context.l10n.next,
                shortLabel: context.l10n.next,
                icon: CupertinoIcons.chevron_forward,
                showAndroidTooltip: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _moveForward(WidgetRef ref) {
    ref.read(ctrlProvider.notifier).cursorForward();
  }

  void _moveBackward(WidgetRef ref) {
    ref.read(ctrlProvider.notifier).cursorBackward();
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
        if (gameState.game.abortable)
          BottomSheetAction(
            label: Text(context.l10n.abortGame),
            onPressed: (context) {
              ref.read(ctrlProvider.notifier).abortGame();
            },
          ),
        if (gameState.game.clock != null && gameState.game.canGiveTime)
          BottomSheetAction(
            label: Text(
              context.l10n.giveNbSeconds(
                gameState.game.clock!.moreTime?.inSeconds ?? 15,
              ),
            ),
            onPressed: (context) {
              ref.read(ctrlProvider.notifier).moreTime();
            },
          ),
        if (gameState.game.canTakeback)
          BottomSheetAction(
            label: Text(context.l10n.takeback),
            onPressed: (context) {
              ref.read(ctrlProvider.notifier).offerTakeback();
            },
          ),
        if (gameState.game.player?.proposingTakeback == true)
          BottomSheetAction(
            label: const Text('Cancel takeback offer'),
            isDestructiveAction: true,
            onPressed: (context) {
              ref.read(ctrlProvider.notifier).cancelOrDeclineTakeback();
            },
          ),
        if (gameState.game.player?.offeringDraw == true)
          BottomSheetAction(
            label: const Text('Cancel draw offer'),
            isDestructiveAction: true,
            onPressed: (context) {
              ref.read(ctrlProvider.notifier).cancelOrDeclineDraw();
            },
          )
        else if (gameState.canOfferDraw)
          BottomSheetAction(
            label: Text(context.l10n.offerDraw),
            onPressed: gameState.shouldConfirmResignAndDrawOffer
                ? (context) => _showConfirmDialog(
                      context,
                      description: Text(context.l10n.offerDraw),
                      onConfirm: () {
                        ref.read(ctrlProvider.notifier).offerOrAcceptDraw();
                      },
                    )
                : (context) {
                    ref.read(ctrlProvider.notifier).offerOrAcceptDraw();
                  },
          ),
        if (gameState.game.resignable)
          BottomSheetAction(
            label: Text(context.l10n.resign),
            dismissOnPress: false,
            onPressed: gameState.shouldConfirmResignAndDrawOffer
                ? (context) => _showConfirmDialog(
                      context,
                      description: Text(context.l10n.resignTheGame),
                      onConfirm: () {
                        ref.read(ctrlProvider.notifier).resignGame();
                      },
                    )
                : (context) {
                    ref.read(ctrlProvider.notifier).resignGame();
                  },
          ),
        if (gameState.game.canClaimWin) ...[
          BottomSheetAction(
            label: Text(context.l10n.forceDraw),
            dismissOnPress: true,
            onPressed: (context) {
              ref.read(ctrlProvider.notifier).forceDraw();
            },
          ),
          BottomSheetAction(
            label: Text(context.l10n.forceResignation),
            dismissOnPress: true,
            onPressed: (context) {
              ref.read(ctrlProvider.notifier).forceResign();
            },
          ),
        ],
        if (gameState.game.player?.offeringRematch == true)
          BottomSheetAction(
            label: Text(context.l10n.cancelRematchOffer),
            dismissOnPress: true,
            isDestructiveAction: true,
            onPressed: (context) {
              ref.read(ctrlProvider.notifier).declineRematch();
            },
          )
        else if (gameState.canOfferRematch &&
            gameState.game.opponent?.onGame == true)
          BottomSheetAction(
            label: Text(context.l10n.rematch),
            dismissOnPress: true,
            onPressed: (context) {
              ref.read(ctrlProvider.notifier).proposeOrAcceptRematch();
            },
          ),
        if (gameState.canGetNewOpponent)
          BottomSheetAction(
            label: Text(context.l10n.newOpponent),
            onPressed: (_) {
              ref.read(gameProvider.notifier).newOpponent();
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
    await Navigator.of(context).maybePop();
    if (context.mounted) {
      final result = await showAdaptiveDialog<bool>(
        context: context,
        builder: (context) => YesNoDialog(
          title: const Text('Are you sure?'),
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
}

class _GameEndDialog extends ConsumerStatefulWidget {
  const _GameEndDialog({
    required this.ctrlProvider,
    required this.gameProvider,
  });

  final GameControllerProvider ctrlProvider;
  final LobbyGameProvider gameProvider;

  @override
  ConsumerState<_GameEndDialog> createState() => _GameEndDialogState();
}

class _GameEndDialogState extends ConsumerState<_GameEndDialog> {
  late Timer _buttonActivationTimer;
  bool _activateButtons = false;

  @override
  void initState() {
    _buttonActivationTimer = Timer(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _activateButtons = true;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _buttonActivationTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(widget.ctrlProvider).requireValue;

    final showWinner = gameState.game.winner != null
        ? ' • ${gameState.game.winner == Side.white ? context.l10n.whiteIsVictorious : context.l10n.blackIsVictorious}'
        : '';

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (gameState.game.status.value >= GameStatus.mate.value)
          Text(
            gameState.game.winner == null
                ? '½-½'
                : gameState.game.winner == Side.white
                    ? '1-0'
                    : '0-1',
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        const SizedBox(height: 6.0),
        Text(
          '${gameStatusL10n(context, gameState)}$showWinner',
          style: const TextStyle(
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16.0),
        if (gameState.game.player?.offeringRematch == true)
          SecondaryButton(
            semanticsLabel: context.l10n.cancelRematchOffer,
            onPressed: () {
              ref.read(widget.ctrlProvider.notifier).declineRematch();
            },
            child: Text(context.l10n.cancelRematchOffer),
          )
        else if (gameState.canOfferRematch)
          SecondaryButton(
            semanticsLabel: context.l10n.rematch,
            onPressed:
                _activateButtons && gameState.game.opponent?.onGame == true
                    ? () {
                        ref
                            .read(widget.ctrlProvider.notifier)
                            .proposeOrAcceptRematch();
                      }
                    : null,
            glowing: gameState.game.opponent?.offeringRematch == true,
            child: Text(context.l10n.rematch),
          ),
        SecondaryButton(
          semanticsLabel: context.l10n.newOpponent,
          onPressed: _activateButtons
              ? () {
                  ref.read(widget.gameProvider.notifier).newOpponent();
                  // Other alert dialogs may be shown before this one, so be sure to pop them all
                  Navigator.of(context)
                      .popUntil((route) => route is! RawDialogRoute);
                }
              : null,
          child: Text(context.l10n.newOpponent),
        ),
        SecondaryButton(
          semanticsLabel: context.l10n.analysis,
          onPressed: () => pushPlatformRoute(
            context,
            builder: (_) => AnalysisScreen(
              options: gameState.analysisOptions,
              title: context.l10n.gameAnalysis,
            ),
          ),
          child: Text(context.l10n.analysis),
        ),
      ],
    );

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoAlertDialog(
        content: content,
      );
    } else {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: content,
        ),
      );
    }
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

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoAlertDialog(
        content: title,
        actions: [
          CupertinoDialogAction(
            onPressed: accept,
            child: Text(context.l10n.accept),
          ),
          CupertinoDialogAction(
            onPressed: decline,
            child: Text(context.l10n.decline),
          ),
        ],
      );
    } else {
      return AlertDialog(
        content: title,
        actions: [
          TextButton(
            onPressed: accept,
            child: Text(context.l10n.accept),
          ),
          TextButton(
            onPressed: decline,
            child: Text(context.l10n.decline),
          ),
        ],
      );
    }
  }
}

class _ThreefoldDialog extends ConsumerWidget {
  const _ThreefoldDialog({
    required this.ctrlProvider,
  });

  final GameControllerProvider ctrlProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = Text(context.l10n.threefoldRepetition);

    void decline() {
      Navigator.of(context).pop();
    }

    void accept() {
      Navigator.of(context).pop();
      ref.read(ctrlProvider.notifier).claimDraw();
    }

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoAlertDialog(
        content: content,
        actions: [
          CupertinoDialogAction(
            onPressed: accept,
            child: Text(context.l10n.claimADraw),
          ),
          CupertinoDialogAction(
            onPressed: decline,
            child: Text(context.l10n.cancel),
          ),
        ],
      );
    } else {
      return AlertDialog(
        content: content,
        actions: [
          TextButton(
            onPressed: accept,
            child: Text(context.l10n.claimADraw),
          ),
          TextButton(
            onPressed: decline,
            child: Text(context.l10n.cancel),
          ),
        ],
      );
    }
  }
}

class _ClaimWinDialog extends ConsumerWidget {
  const _ClaimWinDialog({
    required this.ctrlProvider,
  });

  final GameControllerProvider ctrlProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoAlertDialog(
        content: content,
        actions: [
          CupertinoDialogAction(
            onPressed: gameState.game.canClaimWin ? onClaimWin : null,
            isDefaultAction: true,
            child: Text(context.l10n.forceResignation),
          ),
          CupertinoDialogAction(
            onPressed: gameState.game.canClaimWin ? onClaimDraw : null,
            child: Text(context.l10n.forceDraw),
          ),
        ],
      );
    } else {
      return AlertDialog(
        content: content,
        actions: [
          TextButton(
            onPressed: gameState.game.canClaimWin ? onClaimWin : null,
            child: Text(context.l10n.forceResignation),
          ),
          TextButton(
            onPressed: gameState.game.canClaimWin ? onClaimDraw : null,
            child: Text(context.l10n.forceDraw),
          ),
        ],
      );
    }
  }
}

class _ClaimWinCountdown extends StatelessWidget {
  const _ClaimWinCountdown({
    required this.duration,
  });

  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final secs = duration.inSeconds.remainder(60);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(context.l10n.opponentLeftCounter(secs)),
      ),
    );
  }
}
