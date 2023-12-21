import 'dart:async';
import 'dart:math' as math;

import 'package:chessground/chessground.dart' as cg;
import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/game/chat_controller.dart';
import 'package:lichess_mobile/src/model/game/game_controller.dart';
import 'package:lichess_mobile/src/model/game/game_repository_providers.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/model/lobby/lobby_providers.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/game/correspondence_clock_widget.dart';
import 'package:lichess_mobile/src/view/game/message_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/board_table.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar_button.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/countdown_clock.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';
import 'package:lichess_mobile/src/widgets/yes_no_dialog.dart';

import 'game_common_widgets.dart';
import 'game_loading_board.dart';
import 'game_player.dart';
import 'game_result_dialog.dart';
import 'game_screen_providers.dart';

part 'game_body.freezed.dart';

@freezed
class InitialStandaloneGameParams with _$InitialStandaloneGameParams {
  const factory InitialStandaloneGameParams({
    required GameFullId id,
    String? fen,
    Move? lastMove,
    Side? orientation,
  }) = _InitialStandaloneGameParams;
}

/// Common body for the [LobbyGameScreen] and [StandaloneGameScreen].
///
/// This widget is responsible for displaying the board, the clocks, the players,
/// and the bottom bar.
///
/// The [seek] parameter is only used in the [LobbyGameScreen]. If [seek] is not
/// null, it will display a button to get a new opponent and the game
/// provider will be [lobbyGameProvider].
/// If [seek] is null the game provider will be the [onlineGameProvider]
/// parameterized with the [initialStandAloneParams.id].
class GameBody extends ConsumerWidget {
  /// Constructs a [GameBody].
  ///
  /// You must provide either [seek] or [initialStandAloneParams], but not both.
  const GameBody({
    this.seek,
    this.initialStandAloneParams,
    required this.id,
    required this.whiteClockKey,
    required this.blackClockKey,
    this.isRematch = false,
  }) : assert(
          (seek != null || initialStandAloneParams != null) &&
              !(seek != null && initialStandAloneParams != null),
          'Either seek or initialStandAloneParams must be provided, but not both.',
        );

  /// The [GameSeek] used to get a new opponent when the game is coming from lobby.
  final GameSeek? seek;

  /// The initial game params when the game was not loaded from lobby.
  final InitialStandaloneGameParams? initialStandAloneParams;

  final GameFullId id;
  final GlobalKey whiteClockKey;
  final GlobalKey blackClockKey;

  /// Whether this game is a rematch.
  ///
  /// Only useful for the loading screen from lobby.
  final bool isRematch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = gameControllerProvider(id);

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

    final gameStateAsync = ref.watch(ctrlProvider);

    return gameStateAsync.when(
      data: (gameState) {
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
          clock: gameState.game.meta.clock != null
              ? CountdownClock(
                  key: blackClockKey,
                  duration: gameState.game.clock!.black,
                  active: gameState.activeClockSide == Side.black,
                  emergencyThreshold: youAre == Side.black
                      ? gameState.game.meta.clock?.emergency
                      : null,
                  onFlag: () => ref.read(ctrlProvider.notifier).onFlag(),
                )
              : gameState.game.correspondenceClock != null
                  ? CorrespondenceClock(
                      duration: gameState.game.correspondenceClock!.black,
                      active: gameState.activeClockSide == Side.black,
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
          clock: gameState.game.meta.clock != null
              ? CountdownClock(
                  key: whiteClockKey,
                  duration: gameState.game.clock!.white,
                  active: gameState.activeClockSide == Side.white,
                  emergencyThreshold: youAre == Side.white
                      ? gameState.game.meta.clock?.emergency
                      : null,
                  onFlag: () => ref.read(ctrlProvider.notifier).onFlag(),
                )
              : gameState.game.correspondenceClock != null
                  ? CorrespondenceClock(
                      duration: gameState.game.correspondenceClock!.white,
                      active: gameState.activeClockSide == Side.white,
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
                    autoQueenPromotionOnPremove:
                        gameState.canAutoQueenOnPremove,
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
              seek: seek,
              initialStandAloneId: initialStandAloneParams?.id,
              id: id,
              gameState: gameState,
            ),
          ],
        );

        return PopScope(
          canPop: gameState.game.speed == Speed.correspondence ||
              !gameState.game.playable,
          child: content,
        );
      },
      loading: () => PopScope(
        canPop: true,
        child: seek != null
            ? LobbyGameLoadingBoard(seek!, isRematch: isRematch)
            : id == initialStandAloneParams?.id
                ? StandaloneGameLoadingBoard(
                    fen: initialStandAloneParams?.fen,
                    lastMove: initialStandAloneParams?.lastMove,
                    orientation: initialStandAloneParams?.orientation,
                  )
                : const StandaloneGameLoadingBoard(),
      ),
      error: (e, s) {
        debugPrint(
          'SEVERE: [GameBody] could not load game data; $e\n$s',
        );
        return const PopScope(
          child: LoadGameError(),
        );
      },
    );
  }

  void _stateListener(
    AsyncValue<GameState>? prev,
    AsyncValue<GameState> state, {
    required BuildContext context,
    required WidgetRef ref,
  }) {
    if (state.hasValue) {
      // If the game is no longer playable, show the game end dialog.
      // We want to show it only once, whether the game is already finished on
      // first load or not.
      if ((prev?.hasValue != true ||
              prev!.requireValue.game.playable == true) &&
          state.requireValue.game.playable == false) {
        Timer(const Duration(milliseconds: 500), () {
          if (context.mounted) {
            showAdaptiveDialog<void>(
              context: context,
              builder: (context) => GameResultDialog(id: id, seek: seek),
              barrierDismissible: true,
            );
          }
        });
      }
    }

    if (prev?.hasValue == true && state.hasValue) {
      // Opponent is gone long enough to show the claim win dialog.
      if (!prev!.requireValue.game.canClaimWin &&
          state.requireValue.game.canClaimWin) {
        if (context.mounted) {
          showAdaptiveDialog<void>(
            context: context,
            builder: (context) => _ClaimWinDialog(id: id),
            barrierDismissible: true,
          );
        }
      }

      if (state.requireValue.redirectGameId != null) {
        // Be sure to pop any dialogs that might be on top of the game screen.
        Navigator.of(context).popUntil((route) => route is! RawDialogRoute);
        if (seek != null) {
          ref
              .read(lobbyGameProvider(seek!).notifier)
              .rematch(state.requireValue.redirectGameId!);
        } else if (initialStandAloneParams != null) {
          ref
              .read(
                standaloneGameProvider(initialStandAloneParams!.id).notifier,
              )
              .newGame(state.requireValue.redirectGameId!);
        }
      }
    }
  }
}

class _GameBottomBar extends ConsumerWidget {
  const _GameBottomBar({
    this.seek,
    required this.initialStandAloneId,
    required this.id,
    required this.gameState,
  });

  final GameSeek? seek;
  final GameFullId? initialStandAloneId;
  final GameFullId id;
  final GameState gameState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ongoingGames = ref.watch(ongoingGamesProvider);
    final chatState = ref.watch(chatControllerProvider(id));

    return Container(
      color: defaultTargetPlatform == TargetPlatform.iOS
          ? CupertinoTheme.of(context).barBackgroundColor
          : Theme.of(context).bottomAppBarTheme.color,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: kBottomBarHeight,
          child: Row(
            children: [
              Expanded(
                child: BottomBarButton(
                  label: context.l10n.menu,
                  onTap: () {
                    _showGameMenu(context, ref);
                  },
                  icon: Icons.menu,
                ),
              ),
              if (gameState.game.playable &&
                  gameState.game.opponent?.offeringDraw == true)
                Expanded(
                  child: BottomBarButton(
                    label: context.l10n.yourOpponentOffersADraw,
                    highlighted: true,
                    onTap: () {
                      showAdaptiveDialog<void>(
                        context: context,
                        builder: (context) => _GameNegotiationDialog(
                          title: Text(context.l10n.yourOpponentOffersADraw),
                          onAccept: () {
                            ref
                                .read(gameControllerProvider(id).notifier)
                                .offerOrAcceptDraw();
                          },
                          onDecline: () {
                            ref
                                .read(gameControllerProvider(id).notifier)
                                .cancelOrDeclineDraw();
                          },
                        ),
                        barrierDismissible: true,
                      );
                    },
                    icon: Icons.handshake_outlined,
                  ),
                )
              else if (gameState.game.playable &&
                  gameState.game.isThreefoldRepetition == true)
                Expanded(
                  child: BottomBarButton(
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
                  ),
                )
              else if (gameState.game.playable &&
                  gameState.game.opponent?.proposingTakeback == true)
                Expanded(
                  child: BottomBarButton(
                    label: context.l10n.yourOpponentProposesATakeback,
                    highlighted: true,
                    onTap: () {
                      showAdaptiveDialog<void>(
                        context: context,
                        builder: (context) => _GameNegotiationDialog(
                          title:
                              Text(context.l10n.yourOpponentProposesATakeback),
                          onAccept: () {
                            ref
                                .read(gameControllerProvider(id).notifier)
                                .acceptTakeback();
                          },
                          onDecline: () {
                            ref
                                .read(gameControllerProvider(id).notifier)
                                .cancelOrDeclineTakeback();
                          },
                        ),
                        barrierDismissible: true,
                      );
                    },
                    icon: CupertinoIcons.arrowshape_turn_up_left,
                  ),
                )
              else if (gameState.game.playable &&
                  gameState.game.speed == Speed.correspondence)
                Expanded(
                  child: BottomBarButton(
                    label: context.l10n.analysis,
                    icon: Icons.biotech,
                    onTap: () {
                      pushPlatformRoute(
                        context,
                        builder: (_) => AnalysisScreen(
                          options: gameState.analysisOptions.copyWith(
                            isLocalEvaluationAllowed: false,
                          ),
                          title: context.l10n.analysis,
                        ),
                      );
                    },
                  ),
                )
              else if (gameState.game.finished)
                Builder(
                  builder: (context) {
                    Future<void>? pendingPgn;
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return FutureBuilder(
                          future: pendingPgn,
                          builder: (context, snapshot) {
                            return Expanded(
                              child: BottomBarButton(
                                label: context.l10n.gameAnalysis,
                                icon: Icons.biotech,
                                onTap: snapshot.connectionState ==
                                        ConnectionState.waiting
                                    ? null
                                    : () async {
                                        final future = ref.read(
                                          gameAnalysisPgnProvider(
                                            id: gameState.game.id,
                                          ).future,
                                        );
                                        setState(() {
                                          pendingPgn = future;
                                        });
                                        final pgn = await future;
                                        if (context.mounted) {
                                          pushPlatformRoute(
                                            context,
                                            builder: (_) => AnalysisScreen(
                                              options: gameState.analysisOptions
                                                  .copyWith(
                                                pgn: pgn,
                                              ),
                                              title: context.l10n.gameAnalysis,
                                            ),
                                          );
                                        }
                                      },
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                )
              else
                const SizedBox(
                  width: 44.0,
                ),
              if (gameState.game.speed == Speed.correspondence &&
                  initialStandAloneId != null)
                Expanded(
                  child: BottomBarButton(
                    label: 'Go to the next game',
                    icon: Icons.skip_next,
                    onTap: ongoingGames.maybeWhen(
                      data: (games) {
                        final nextTurn = games
                            .whereNot((g) => g.fullId == id)
                            .firstWhereOrNull((g) => g.isMyTurn);
                        return nextTurn != null
                            ? () {
                                ref
                                    .read(
                                      standaloneGameProvider(
                                        initialStandAloneId!,
                                      ).notifier,
                                    )
                                    .newGame(nextTurn.fullId);
                              }
                            : null;
                      },
                      orElse: () => null,
                    ),
                  ),
                ),
              Expanded(
                child: BottomBarButton(
                  label: context.l10n.chat,
                  onTap: () {
                    pushPlatformRoute(
                      context,
                      fullscreenDialog: true,
                      builder: (BuildContext context) {
                        return MessageScreen(
                          title: UserFullNameWidget(
                            user: gameState.game.opponent?.user,
                          ),
                          me: gameState.game.me?.user,
                          chatContext: id,
                        );
                      },
                    );
                  },
                  icon: defaultTargetPlatform == TargetPlatform.iOS
                      ? CupertinoIcons.chat_bubble
                      : Icons.chat_bubble_outline,
                  chip: chatState.unreadMessages > 0
                      ? Text(math.min(9, chatState.unreadMessages).toString())
                      : null,
                ),
              ),
              Expanded(
                child: RepeatButton(
                  onLongPress:
                      gameState.canGoBackward ? () => _moveBackward(ref) : null,
                  child: BottomBarButton(
                    onTap: gameState.canGoBackward
                        ? () => _moveBackward(ref)
                        : null,
                    label: 'Previous',
                    icon: CupertinoIcons.chevron_back,
                    showTooltip: false,
                  ),
                ),
              ),
              Expanded(
                child: RepeatButton(
                  onLongPress:
                      gameState.canGoForward ? () => _moveForward(ref) : null,
                  child: BottomBarButton(
                    onTap:
                        gameState.canGoForward ? () => _moveForward(ref) : null,
                    label: context.l10n.next,
                    icon: CupertinoIcons.chevron_forward,
                    showTooltip: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _moveForward(WidgetRef ref) {
    ref.read(gameControllerProvider(id).notifier).cursorForward();
  }

  void _moveBackward(WidgetRef ref) {
    ref.read(gameControllerProvider(id).notifier).cursorBackward();
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
              ref.read(gameControllerProvider(id).notifier).abortGame();
            },
          ),
        if (gameState.game.meta.clock != null && gameState.game.canGiveTime)
          BottomSheetAction(
            label: Text(
              context.l10n.giveNbSeconds(
                gameState.game.meta.clock!.moreTime?.inSeconds ?? 15,
              ),
            ),
            onPressed: (context) {
              ref.read(gameControllerProvider(id).notifier).moreTime();
            },
          ),
        if (gameState.game.canTakeback)
          BottomSheetAction(
            label: Text(context.l10n.takeback),
            onPressed: (context) {
              ref.read(gameControllerProvider(id).notifier).offerTakeback();
            },
          ),
        if (gameState.game.me?.proposingTakeback == true)
          BottomSheetAction(
            label: const Text('Cancel takeback offer'),
            isDestructiveAction: true,
            onPressed: (context) {
              ref
                  .read(gameControllerProvider(id).notifier)
                  .cancelOrDeclineTakeback();
            },
          ),
        if (gameState.game.me?.offeringDraw == true)
          BottomSheetAction(
            label: const Text('Cancel draw offer'),
            isDestructiveAction: true,
            onPressed: (context) {
              ref
                  .read(gameControllerProvider(id).notifier)
                  .cancelOrDeclineDraw();
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
                        ref
                            .read(gameControllerProvider(id).notifier)
                            .offerOrAcceptDraw();
                      },
                    )
                : (context) {
                    ref
                        .read(gameControllerProvider(id).notifier)
                        .offerOrAcceptDraw();
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
                        ref
                            .read(gameControllerProvider(id).notifier)
                            .resignGame();
                      },
                    )
                : (context) {
                    ref.read(gameControllerProvider(id).notifier).resignGame();
                  },
          ),
        if (gameState.game.canClaimWin) ...[
          BottomSheetAction(
            label: Text(context.l10n.forceDraw),
            dismissOnPress: true,
            onPressed: (context) {
              ref.read(gameControllerProvider(id).notifier).forceDraw();
            },
          ),
          BottomSheetAction(
            label: Text(context.l10n.forceResignation),
            dismissOnPress: true,
            onPressed: (context) {
              ref.read(gameControllerProvider(id).notifier).forceResign();
            },
          ),
        ],
        if (gameState.game.me?.offeringRematch == true)
          BottomSheetAction(
            label: Text(context.l10n.cancelRematchOffer),
            dismissOnPress: true,
            isDestructiveAction: true,
            onPressed: (context) {
              ref.read(gameControllerProvider(id).notifier).declineRematch();
            },
          )
        else if (gameState.canOfferRematch &&
            gameState.game.opponent?.onGame == true)
          BottomSheetAction(
            label: Text(context.l10n.rematch),
            dismissOnPress: true,
            onPressed: (context) {
              ref
                  .read(gameControllerProvider(id).notifier)
                  .proposeOrAcceptRematch();
            },
          ),
        if (gameState.canGetNewOpponent && seek != null)
          BottomSheetAction(
            label: Text(context.l10n.newOpponent),
            onPressed: (_) {
              ref.read(lobbyGameProvider(seek!).notifier).newOpponent();
            },
          ),
        if (gameState.game.finished)
          BottomSheetAction(
            label: const Text('Show result'),
            onPressed: (_) {
              showAdaptiveDialog<void>(
                context: context,
                builder: (context) => GameResultDialog(id: id, seek: seek),
                barrierDismissible: true,
              );
            },
          ),
        if (gameState.game.finished)
          ...makeFinishedGameShareActions(
            gameState.game,
            currentGamePosition:
                gameState.game.positionAt(gameState.stepCursor),
            lastMove: gameState.game.moveAt(gameState.stepCursor),
            orientation: gameState.game.youAre ?? Side.white,
            context: context,
            ref: ref,
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
    required this.id,
  });

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
    required this.id,
  });

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
