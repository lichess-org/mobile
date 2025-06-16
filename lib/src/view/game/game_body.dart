import 'dart:async';

import 'package:chessground/chessground.dart';
import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/game/game_controller.dart';
import 'package:lichess_mobile/src/model/game/game_preferences.dart';
import 'package:lichess_mobile/src/model/game/playable_game.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
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
import 'package:lichess_mobile/src/widgets/board_table.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/clock.dart';
import 'package:lichess_mobile/src/widgets/platform_alert_dialog.dart';
import 'package:lichess_mobile/src/widgets/yes_no_dialog.dart';

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
    required this.loadedGame,
    required this.whiteClockKey,
    required this.blackClockKey,
    required this.onLoadGameCallback,
    required this.onNewOpponentCallback,
    required this.boardKey,
  });

  final LoadedGame loadedGame;

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
    final ctrlProvider = gameControllerProvider(loadedGame.gameId);

    ref.listen(
      ctrlProvider,
      (prev, state) => _stateListener(prev, state, context: context, ref: ref),
    );

    final boardPreferences = ref.watch(boardPreferencesProvider);
    final gamePrefs = ref.watch(gamePreferencesProvider);
    final blindfoldMode = gamePrefs.blindfoldMode ?? false;

    switch (ref.watch(ctrlProvider)) {
      case AsyncError(error: final e, stackTrace: final s):
        debugPrint('SEVERE: [GameBody] could not load game data; $e\n$s');
        return const LoadGameError('Sorry, we could not load the game. Please try again later.');
      case AsyncData(value: final gameState, isRefreshing: false):
        final youAre = gameState.game.youAre ?? Side.white;

        final black = GamePlayer(
          game: gameState.game,
          side: Side.black,
          materialDiff: boardPreferences.materialDifferenceFormat.visible
              ? gameState.game.materialDiffAt(gameState.stepCursor, Side.black)
              : null,
          materialDifferenceFormat: boardPreferences.materialDifferenceFormat,
          timeToMove: gameState.game.sideToMove == Side.black ? gameState.timeToMove : null,
          mePlaying: youAre == Side.black,
          canGoForward: gameState.canGoForward,
          zenMode: gameState.isZenModeActive,
          clockPosition: boardPreferences.clockPosition,
          confirmMoveCallbacks: youAre == Side.black && gameState.moveToConfirm != null
              ? (
                  confirm: () {
                    ref.read(ctrlProvider.notifier).confirmMove();
                  },
                  cancel: () {
                    ref.read(ctrlProvider.notifier).cancelMove();
                  },
                )
              : null,
          clock: gameState.liveClock != null
              ? RepaintBoundary(
                  child: ValueListenableBuilder(
                    key: blackClockKey,
                    valueListenable: gameState.liveClock!.black,
                    builder: (context, value, _) {
                      return Clock(
                        key: const ValueKey('black-clock'),
                        timeLeft: value,
                        active: gameState.activeClockSide == Side.black,
                        emergencyThreshold: youAre == Side.black
                            ? gameState.game.meta.clock?.emergency
                            : null,
                      );
                    },
                  ),
                )
              : gameState.game.correspondenceClock != null
              ? CorrespondenceClock(
                  duration: gameState.game.correspondenceClock!.black,
                  active: gameState.activeClockSide == Side.black,
                  onFlag: () => ref.read(ctrlProvider.notifier).onFlag(),
                )
              : null,
        );
        final white = GamePlayer(
          game: gameState.game,
          side: Side.white,
          materialDiff: boardPreferences.materialDifferenceFormat.visible
              ? gameState.game.materialDiffAt(gameState.stepCursor, Side.white)
              : null,
          materialDifferenceFormat: boardPreferences.materialDifferenceFormat,
          timeToMove: gameState.game.sideToMove == Side.white ? gameState.timeToMove : null,
          mePlaying: youAre == Side.white,
          canGoForward: gameState.canGoForward,
          zenMode: gameState.isZenModeActive,
          clockPosition: boardPreferences.clockPosition,
          confirmMoveCallbacks: youAre == Side.white && gameState.moveToConfirm != null
              ? (
                  confirm: () {
                    ref.read(ctrlProvider.notifier).confirmMove();
                  },
                  cancel: () {
                    ref.read(ctrlProvider.notifier).cancelMove();
                  },
                )
              : null,
          clock: gameState.liveClock != null
              ? RepaintBoundary(
                  child: ValueListenableBuilder(
                    key: whiteClockKey,
                    valueListenable: gameState.liveClock!.white,
                    builder: (context, value, _) {
                      return Clock(
                        key: const ValueKey('white-clock'),
                        timeLeft: value,
                        active: gameState.activeClockSide == Side.white,
                        emergencyThreshold: youAre == Side.white
                            ? gameState.game.meta.clock?.emergency
                            : null,
                      );
                    },
                  ),
                )
              : gameState.game.correspondenceClock != null
              ? CorrespondenceClock(
                  duration: gameState.game.correspondenceClock!.white,
                  active: gameState.activeClockSide == Side.white,
                  onFlag: () => ref.read(ctrlProvider.notifier).onFlag(),
                )
              : null,
        );

        final isBoardTurned = ref.watch(isBoardTurnedProvider);

        final topPlayerIsBlack =
            youAre == Side.white && !isBoardTurned || youAre == Side.black && isBoardTurned;
        final topPlayer = topPlayerIsBlack ? black : white;
        final bottomPlayer = topPlayerIsBlack ? white : black;

        final animationDuration =
            gameState.game.meta.speed == Speed.ultraBullet ||
                gameState.game.meta.speed == Speed.bullet
            ? Duration.zero
            : boardPreferences.pieceAnimationDuration;

        return FocusDetector(
          onFocusRegained: () {
            ref.read(ctrlProvider.notifier).onFocusRegained();
          },
          child: WakelockWidget(
            shouldEnableOnFocusGained: () => gameState.game.playable,
            child: Column(
              children: [
                Expanded(
                  child: BoardTable(
                    key: boardKey,
                    boardSettingsOverrides: BoardSettingsOverrides(
                      animationDuration: animationDuration,
                      autoQueenPromotion: gameState.canAutoQueen,
                      autoQueenPromotionOnPremove: gameState.canAutoQueenOnPremove,
                      blindfoldMode: blindfoldMode,
                    ),
                    orientation: isBoardTurned ? youAre.opposite : youAre,
                    lastMove: gameState.game.moveAt(gameState.stepCursor) as NormalMove?,
                    interactiveBoardParams: (
                      variant: gameState.game.meta.variant,
                      position: gameState.currentPosition,
                      playerSide: gameState.game.playable && !gameState.isReplaying
                          ? youAre == Side.white
                                ? PlayerSide.white
                                : PlayerSide.black
                          : PlayerSide.none,
                      promotionMove: gameState.promotionMove,
                      onMove: (move, {isDrop}) {
                        ref.read(ctrlProvider.notifier).userMove(move, isDrop: isDrop);
                      },
                      onPromotionSelection: (role) {
                        ref.read(ctrlProvider.notifier).onPromotionSelection(role);
                      },
                      premovable: gameState.canPremove && boardPreferences.premoves
                          ? (
                              onSetPremove: (move) {
                                ref.read(ctrlProvider.notifier).setPremove(move);
                              },
                              premove: gameState.premove,
                            )
                          : null,
                    ),
                    topTable: topPlayer,
                    bottomTable:
                        gameState.canShowClaimWinCountdown &&
                            gameState.opponentLeftCountdown != null
                        ? _ClaimWinCountdown(countdown: gameState.opponentLeftCountdown!)
                        : bottomPlayer,
                    moves: gameState.game.steps
                        .skip(1)
                        .map((e) => e.sanMove!.san)
                        .toList(growable: false),
                    currentMoveIndex: gameState.stepCursor,
                    onSelectMove: (moveIndex) {
                      ref.read(ctrlProvider.notifier).cursorAt(moveIndex);
                    },
                    zenMode: gameState.isZenModeActive,
                  ),
                ),
                _GameBottomBar(
                  id: loadedGame.gameId,
                  onLoadGameCallback: onLoadGameCallback,
                  onNewOpponentCallback: onNewOpponentCallback,
                ),
              ],
            ),
          ),
        );

      case AsyncData(:final value, isRefreshing: true):
        return Column(
          children: [
            Expanded(
              child: StandaloneGameLoadingBoard(
                fen: value.game.lastPosition.fen,
                lastMove: value.game.moveAt(value.stepCursor) as NormalMove?,
                orientation: value.game.youAre,
              ),
            ),
            _GameBottomBar(
              id: loadedGame.gameId,
              onLoadGameCallback: onLoadGameCallback,
              onNewOpponentCallback: onNewOpponentCallback,
            ),
          ],
        );
      case final _:
        return Column(
          children: [
            Expanded(
              child: StandaloneGameLoadingBoard(
                fen: loadedGame.lastFen,
                lastMove: loadedGame.lastMove,
                orientation: loadedGame.side,
              ),
            ),
            _GameBottomBar(
              id: loadedGame.gameId,
              onLoadGameCallback: onLoadGameCallback,
              onNewOpponentCallback: onNewOpponentCallback,
            ),
          ],
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
      if (prev?.valueOrNull?.isZenModeActive == true &&
          state.requireValue.isZenModeActive == false) {
        if (context.mounted) {
          // when Zen mode is disabled, reload chat data
          ref
              .read(gameControllerProvider(loadedGame.gameId).notifier)
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
              builder: (context) => GameResultDialog(
                id: loadedGame.gameId,
                onNewOpponentCallback: onNewOpponentCallback,
              ),
              barrierDismissible: true,
            );
          }
        });
      }

      // true when the game was loaded, playable, and just finished
      if (prev?.valueOrNull?.game.playable == true && state.requireValue.game.playable == false) {
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
            builder: (context) => _ClaimWinDialog(id: loadedGame.gameId),
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

    switch (ref.watch(gameControllerProvider(id))) {
      case AsyncData(value: final gameState):
        final canShowChat =
            gamePrefs.enableChat == true &&
            gameState.chatOptions != null &&
            kidModeAsync.valueOrNull == false;
        return BottomBar(
          children: [
            BottomBarButton(
              label: context.l10n.menu,
              onTap: () {
                _showGameMenu(context, ref);
              },
              icon: Icons.menu,
            ),
            if (gameState.canBerserk)
              BottomBarButton(
                label: context.l10n.arenaBerserk,
                onTap: gameState.canBerserk && !gameState.hasBerserked
                    ? ref.read(gameControllerProvider(id).notifier).berserk
                    : null,
                icon: LichessIcons.body_cut,
              ),
            if (gameState.game.playable && gameState.game.opponent?.offeringDraw == true)
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
            else if (gameState.game.playable && gameState.game.isThreefoldRepetition == true)
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
            else if (gameState.game.playable && gameState.game.opponent?.proposingTakeback == true)
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
            else if (gameState.game.playable && gameState.game.meta.speed == Speed.correspondence)
              BottomBarButton(
                label: 'Go to the next game',
                icon: Icons.skip_next,
                onTap: ongoingGames.maybeWhen(
                  data: (games) {
                    final nextTurn = games
                        .whereNot((g) => g.fullId == id)
                        .firstWhereOrNull((g) => g.isMyTurn);
                    return nextTurn != null ? () => onLoadGameCallback(nextTurn.fullId) : null;
                  },
                  orElse: () => null,
                ),
              )
            else if (gameState.game.finished)
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
                onTap: gameState.game.resignable
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
            if (canShowChat) ChatBottomBarButton(options: gameState.chatOptions!),
            RepeatButton(
              onLongPress: gameState.canGoBackward ? () => _moveBackward(ref) : null,
              child: BottomBarButton(
                onTap: gameState.canGoBackward ? () => _moveBackward(ref) : null,
                label: 'Previous',
                icon: CupertinoIcons.chevron_back,
                showTooltip: false,
              ),
            ),
            RepeatButton(
              onLongPress: gameState.canGoForward ? () => _moveForward(ref) : null,
              child: BottomBarButton(
                onTap: gameState.canGoForward ? () => _moveForward(ref) : null,
                label: context.l10n.next,
                icon: CupertinoIcons.chevron_forward,
                showTooltip: false,
                blink:
                    gameState.game.playable &&
                    gameState.stepCursor != gameState.game.steps.length - 1 &&
                    gameState.game.sideToMove == gameState.game.youAre,
              ),
            ),
          ],
        );
      case _:
        return const BottomBar.empty();
    }
  }

  void _moveForward(WidgetRef ref) {
    ref.read(gameControllerProvider(id).notifier).cursorForward();
  }

  void _moveBackward(WidgetRef ref) {
    ref.read(gameControllerProvider(id).notifier).cursorBackward();
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
              Navigator.of(
                context,
              ).push(AnalysisScreen.buildRoute(context, gameState.analysisOptions));
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
              Navigator.of(
                context,
              ).push(TournamentScreen.buildRoute(context, gameState.tournament!.id));
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
  const _ClaimWinCountdown({required this.countdown});

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
            return Text(context.l10n.opponentLeftCounter(duration.inSeconds));
          },
        ),
      ),
    );
  }
}
