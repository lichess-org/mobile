import 'dart:async';
import 'dart:math';

import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game_board_params.dart';
import 'package:lichess_mobile/src/model/over_the_board/over_the_board_clock.dart';
import 'package:lichess_mobile/src/model/over_the_board/over_the_board_game_controller.dart';
import 'package:lichess_mobile/src/model/over_the_board/over_the_board_game_storage.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/over_the_board_preferences.dart';
import 'package:lichess_mobile/src/utils/focus_detector.dart';
import 'package:lichess_mobile/src/utils/immersive_mode.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/string.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/game/game_player.dart';
import 'package:lichess_mobile/src/view/game/game_result_dialog.dart';
import 'package:lichess_mobile/src/view/over_the_board/configure_over_the_board_game.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/clock.dart';
import 'package:lichess_mobile/src/widgets/game_layout.dart';
import 'package:lichess_mobile/src/widgets/yes_no_dialog.dart';

class OverTheBoardScreen extends StatelessWidget {
  const OverTheBoardScreen({super.key});

  static Route<void> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const OverTheBoardScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.mobileOverTheBoard),
        actions: [
          SemanticIconButton(
            onPressed: () => showConfigureDisplaySettings(context),
            semanticsLabel: context.l10n.settingsSettings,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: const _Body(),
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body();

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  final _boardKey = GlobalKey(debugLabel: 'boardOnOverTheBoardScreen');

  Side orientation = Side.white;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final ongoingGame = await ref.read(overTheBoardGameStorageProvider).fetchOngoingGame();
      if (ongoingGame != null && ongoingGame.game.steps.length > 1 && !ongoingGame.game.finished) {
        ref.read(overTheBoardGameControllerProvider.notifier).loadOngoingGame(ongoingGame.game);

        ref
            .read(overTheBoardClockProvider.notifier)
            .setupClock(
              ongoingGame.timeIncrement,
              whiteTimeLeft: ongoingGame.whiteTimeLeft,
              blackTimeLeft: ongoingGame.blackTimeLeft,
            );
      } else {
        if (!mounted) return;
        showConfigureGameSheet(context, isDismissible: true);
      }
    });
  }

  void _saveGameState() {
    if (!context.mounted) return;
    final clockState = ref.read(overTheBoardClockProvider);
    final gameState = ref.read(overTheBoardGameControllerProvider);
    ref
        .read(overTheBoardGameStorageProvider)
        .save(
          gameState.game,
          timeIncrement: clockState.timeIncrement,
          whiteTimeLeft: clockState.whiteTimeLeft,
          blackTimeLeft: clockState.blackTimeLeft,
        );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(overTheBoardGameControllerProvider);
    final overTheBoardPrefs = ref.watch(overTheBoardPreferencesProvider);

    ref.listen(overTheBoardClockProvider.select((value) => value.flagSide), (previous, flagSide) {
      if (previous == null && flagSide != null) {
        ref.read(overTheBoardGameControllerProvider.notifier).onFlag(flagSide);
      }
    });

    ref.listen(overTheBoardGameControllerProvider, (previous, newGameState) {
      if (previous?.finished == false && newGameState.finished) {
        ref.read(overTheBoardClockProvider.notifier).pause();
        Timer(const Duration(milliseconds: 500), () {
          if (context.mounted) {
            showAdaptiveDialog<void>(
              context: context,
              builder: (context) => OverTheBoardGameResultDialog(
                game: newGameState.game,
                onRematch: () {
                  setState(() {
                    orientation = orientation.opposite;
                    ref.read(overTheBoardGameControllerProvider.notifier).rematch();
                    ref.read(overTheBoardClockProvider.notifier).restart();
                    Navigator.pop(context);
                  });
                },
              ),
              barrierDismissible: true,
            );
          }
        });
      }

      if (previous?.game.isThreefoldRepetition == false &&
          newGameState.game.isThreefoldRepetition == true) {
        Timer(const Duration(milliseconds: 500), () {
          if (context.mounted) {
            ref.read(overTheBoardClockProvider.notifier).pause();
            showAdaptiveDialog<void>(
              context: context,
              builder: (context) => YesNoDialog(
                title: Text(context.l10n.threefoldRepetition),
                content: const Text('Accept draw?'),
                onYes: () {
                  Navigator.pop(context);
                  ref.read(overTheBoardGameControllerProvider.notifier).draw();
                },
                onNo: () {
                  Navigator.pop(context);
                  ref.read(overTheBoardClockProvider.notifier).resume(previous!.turn);
                },
              ),
            );
          }
        });
      }
    });

    return WakelockWidget(
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop) {
            return;
          }

          final navigator = Navigator.of(context);
          final game = gameState.game;
          if (game.abortable || game.finished) {
            return navigator.pop();
          }

          if (game.playable) {
            ref.read(overTheBoardClockProvider.notifier).pause();
          }

          final shouldPop = await showAdaptiveDialog<bool>(
            context: context,
            builder: (context) {
              return YesNoDialog(
                title: Text(context.l10n.mobileAreYouSure),
                content: const Text('No worries, your game will be saved.'),
                onNo: () => Navigator.of(context).pop(false),
                onYes: () {
                  _saveGameState();
                  Navigator.of(context).pop(true);
                },
              );
            },
          );
          if (shouldPop == true) {
            navigator.pop();
          } else if (game.playable) {
            ref.read(overTheBoardClockProvider.notifier).resume(gameState.turn);
          }
        },
        child: FocusDetector(
          onForegroundLost: _saveGameState,
          child: Column(
            children: [
              Expanded(
                child: SafeArea(
                  child: GameLayout(
                    key: _boardKey,
                    topTable: _Player(
                      side: orientation.opposite,
                      clockKey: const ValueKey('topClock'),
                    ),
                    topTableUpsideDown:
                        !overTheBoardPrefs.flipPiecesAfterMove || orientation != gameState.turn,
                    bottomTable: _Player(
                      side: orientation,
                      clockKey: const ValueKey('bottomClock'),
                    ),
                    bottomTableUpsideDown:
                        overTheBoardPrefs.flipPiecesAfterMove && orientation != gameState.turn,
                    orientation: orientation,
                    lastMove: gameState.lastMove,
                    boardParams: GameBoardParams.interactive(
                      variant: gameState.game.meta.variant,
                      position: gameState.currentPosition,
                      playerSide: gameState.game.finished
                          ? PlayerSide.none
                          : gameState.turn == Side.white
                          ? PlayerSide.white
                          : PlayerSide.black,
                      onPromotionSelection: ref
                          .read(overTheBoardGameControllerProvider.notifier)
                          .onPromotionSelection,
                      promotionMove: gameState.promotionMove,
                      onMove: (move, {viaDragAndDrop}) {
                        ref
                            .read(overTheBoardClockProvider.notifier)
                            .onMove(newSideToMove: gameState.turn.opposite);
                        ref.read(overTheBoardGameControllerProvider.notifier).makeMove(move);
                      },
                      premovable: null,
                    ),
                    moves: gameState.moves,
                    currentMoveIndex: gameState.stepCursor,
                    boardSettingsOverrides: BoardSettingsOverrides(
                      drawShape: const DrawShapeOptions(enable: false),
                      pieceOrientationBehavior: overTheBoardPrefs.flipPiecesAfterMove
                          ? PieceOrientationBehavior.sideToPlay
                          : PieceOrientationBehavior.opponentUpsideDown,
                      pieceAssets: overTheBoardPrefs.symmetricPieces
                          ? PieceSet.symmetric.assets
                          : null,
                    ),
                    userActionsBar: _BottomBar(
                      onFlipBoard: () {
                        setState(() {
                          orientation = orientation.opposite;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomBar extends ConsumerWidget {
  const _BottomBar({required this.onFlipBoard});

  final VoidCallback onFlipBoard;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(overTheBoardGameControllerProvider);
    final clock = ref.watch(overTheBoardClockProvider);

    return BottomBar(
      children: [
        BottomBarButton(
          label: context.l10n.menu,
          onTap: () {
            _showOtbGameMenu(context, ref);
          },
          icon: Icons.menu,
        ),
        if (!clock.timeIncrement.isInfinite)
          BottomBarButton(
            label: clock.active ? 'Pause' : 'Resume',
            onTap: gameState.finished
                ? null
                : () {
                    if (clock.active) {
                      ref.read(overTheBoardClockProvider.notifier).pause();
                    } else {
                      ref.read(overTheBoardClockProvider.notifier).resume(gameState.turn);
                    }
                  },
            icon: clock.active ? CupertinoIcons.pause : CupertinoIcons.play,
          ),
        BottomBarButton(
          label: 'Previous',
          onTap: gameState.canGoBack
              ? () {
                  ref.read(overTheBoardGameControllerProvider.notifier).goBack();
                  if (clock.active) {
                    ref
                        .read(overTheBoardClockProvider.notifier)
                        .switchSide(newSideToMove: gameState.turn.opposite, addIncrement: false);
                  }
                }
              : null,
          icon: CupertinoIcons.chevron_back,
        ),
        BottomBarButton(
          label: 'Next',
          onTap: gameState.canGoForward
              ? () {
                  ref.read(overTheBoardGameControllerProvider.notifier).goForward();
                  if (clock.active) {
                    ref
                        .read(overTheBoardClockProvider.notifier)
                        .switchSide(newSideToMove: gameState.turn.opposite, addIncrement: false);
                  }
                }
              : null,
          icon: CupertinoIcons.chevron_forward,
        ),
        BottomBarButton(
          label: 'Takeback',
          onTap: gameState.canGoBack
              ? () {
                  ref.read(overTheBoardGameControllerProvider.notifier).goBack();
                  if (clock.active) {
                    ref
                        .read(overTheBoardClockProvider.notifier)
                        .switchSide(newSideToMove: gameState.turn.opposite, addIncrement: false);
                  }
                }
              : null,
          icon: Icons.undo,
        ),
      ],
    );
  }

  Future<void> _showOtbGameMenu(BuildContext context, WidgetRef ref) {
    final gameState = ref.read(overTheBoardGameControllerProvider);
    return showAdaptiveActionSheet(
      context: context,
      actions: [
        BottomSheetAction(
          makeLabel: (context) => Text(context.l10n.mobileNewGame),
          onPressed: () => showConfigureGameSheet(context, isDismissible: true),
        ),
        if (gameState.game.finished)
          BottomSheetAction(
            makeLabel: (context) => Text(context.l10n.analysis),
            onPressed: () => Navigator.of(context).push(
              AnalysisScreen.buildRoute(
                context,
                AnalysisOptions.standalone(
                  id: const StringId('standalone'),
                  orientation: Side.white,
                  pgn: gameState.game.makePgn(),
                  isComputerAnalysisAllowed: true,
                  variant: gameState.game.meta.variant,
                ),
              ),
            ),
          ),
        BottomSheetAction(
          makeLabel: (context) => Text(context.l10n.flipBoard),
          onPressed: onFlipBoard,
        ),
        if (gameState.game.drawable)
          BottomSheetAction(
            makeLabel: (context) => Text(context.l10n.offerDraw),
            onPressed: () {
              final offerer = gameState.turn.name.capitalize();
              showAdaptiveDialog<void>(
                context: context,
                builder: (context) => YesNoDialog(
                  title: Text('${context.l10n.draw}?'),
                  content: Text('$offerer offers draw. Does opponent accept?'),
                  onYes: () {
                    Navigator.pop(context);
                    ref.read(overTheBoardGameControllerProvider.notifier).draw();
                  },
                  onNo: () => Navigator.pop(context),
                ),
              );
            },
          ),
        if (gameState.game.resignable)
          BottomSheetAction(
            makeLabel: (context) => Text(context.l10n.resign),
            onPressed: () {
              final offerer = gameState.turn.name.capitalize();
              showAdaptiveDialog<void>(
                context: context,
                builder: (context) => YesNoDialog(
                  title: Text('${context.l10n.resign}?'),
                  content: Text('Are you sure you want to resign as $offerer?'),
                  onYes: () {
                    Navigator.pop(context);
                    ref.read(overTheBoardGameControllerProvider.notifier).resign();
                  },
                  onNo: () => Navigator.pop(context),
                ),
              );
            },
          ),
      ],
    );
  }
}

class _Player extends ConsumerWidget {
  const _Player({required this.clockKey, required this.side});

  final Side side;
  final Key clockKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(overTheBoardGameControllerProvider);
    final boardPreferences = ref.watch(boardPreferencesProvider);
    final clock = ref.watch(overTheBoardClockProvider);

    return GamePlayer(
      game: gameState.game,
      side: side,
      materialDiff: boardPreferences.materialDifferenceFormat.visible
          ? gameState.currentMaterialDiff(side)
          : null,
      materialDifferenceFormat: boardPreferences.materialDifferenceFormat,
      shouldLinkToUserProfile: false,
      clock: clock.timeIncrement.isInfinite
          ? null
          : Clock(
              timeLeft: Duration(milliseconds: max(0, clock.timeLeft(side)!.inMilliseconds)),
              key: clockKey,
              active: clock.activeClock == side,
              emergencyThreshold: Duration(
                seconds: (clock.timeIncrement.time * 0.125).clamp(10, 60).toInt(),
              ),
            ),
    );
  }
}
