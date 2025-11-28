import 'dart:async';

import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/computer/computer_controller.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/utils/immersive_mode.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/string.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/computer/configure_computer_game.dart';
import 'package:lichess_mobile/src/view/game/game_player.dart';
import 'package:lichess_mobile/src/view/game/game_result_dialog.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/game_layout.dart';
import 'package:lichess_mobile/src/widgets/yes_no_dialog.dart';

class ComputerScreen extends StatelessWidget {
  const ComputerScreen({super.key});

  static Route<void> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const ComputerScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.computer)),
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
  final _boardKey = GlobalKey(debugLabel: 'boardOnComputerScreen');

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(computerGameControllerProvider);
    final orientation = gameState.game.youAre!;

    ref.listen(computerGameControllerProvider, (previous, newGameState) {
      if (previous?.finished == false && newGameState.finished) {
        Timer(const Duration(milliseconds: 500), () {
          if (context.mounted) {
            showAdaptiveDialog<void>(
              context: context,
              builder: (context) => ComputerGameResultDialog(
                game: newGameState.game,
                onRematch: () {
                  setState(() {
                    ref.read(computerGameControllerProvider.notifier).rematch();
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
            showAdaptiveDialog<void>(
              context: context,
              builder: (context) => YesNoDialog(
                title: Text(context.l10n.threefoldRepetition),
                content: const Text('Accept draw?'),
                onYes: () {
                  Navigator.pop(context);
                  ref.read(computerGameControllerProvider.notifier).draw();
                },
                onNo: () {
                  Navigator.pop(context);
                },
              ),
            );
          }
        });
      }
    });

    return WakelockWidget(
      child: PopScope(
        child: Column(
          children: [
            Expanded(
              child: SafeArea(
                child: GameLayout(
                  key: _boardKey,
                  topTable: _Player(side: orientation.opposite),
                  bottomTable: _Player(side: orientation),
                  orientation: orientation,
                  fen: gameState.currentPosition.fen,
                  lastMove: gameState.lastMove,
                  interactiveBoardParams: (
                    variant: gameState.game.meta.variant,
                    position: gameState.currentPosition,
                    playerSide: gameState.game.finished
                        ? PlayerSide.none
                        : switch (gameState.game.youAre!) {
                            Side.white => PlayerSide.white,
                            Side.black => PlayerSide.black,
                          },
                    onPromotionSelection: ref
                        .read(computerGameControllerProvider.notifier)
                        .onPromotionSelection,
                    promotionMove: gameState.promotionMove,
                    onMove: (move, {isDrop}) {
                      ref.read(computerGameControllerProvider.notifier).onUserMove(move);
                    },
                    premovable: null,
                  ),
                  moves: gameState.moves,
                  currentMoveIndex: gameState.stepCursor,
                  userActionsBar: const _BottomBar(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomBar extends ConsumerWidget {
  const _BottomBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(computerGameControllerProvider);

    return BottomBar(
      children: [
        BottomBarButton(
          label: context.l10n.menu,
          onTap: (gameState.game.finished || gameState.game.drawable || gameState.game.resignable)
              ? () {
                  _showComputerGameMenu(context, ref);
                }
              : null,
          icon: Icons.menu,
        ),
        BottomBarButton(
          label: 'New game',
          onTap: () {
            showConfigureGameSheet(context, isDismissible: true);
          },
          icon: Icons.add_rounded,
        ),
        BottomBarButton(
          label: 'Previous',
          onTap: gameState.canGoBack
              ? () {
                  ref.read(computerGameControllerProvider.notifier).goBack();
                }
              : null,
          icon: CupertinoIcons.chevron_back,
        ),
        BottomBarButton(
          label: 'Next',
          onTap: gameState.canGoForward
              ? () {
                  ref.read(computerGameControllerProvider.notifier).goForward();
                }
              : null,
          icon: CupertinoIcons.chevron_forward,
        ),
      ],
    );
  }

  Future<void> _showComputerGameMenu(BuildContext context, WidgetRef ref) {
    final gameState = ref.read(computerGameControllerProvider);
    return showAdaptiveActionSheet(
      context: context,
      actions: [
        if (gameState.game.finished)
          BottomSheetAction(
            makeLabel: (context) => Text(context.l10n.analysis),
            onPressed: () => Navigator.of(context).push(
              AnalysisScreen.buildRoute(
                context,
                AnalysisOptions.standalone(
                  orientation: Side.white,
                  pgn: gameState.game.makePgn(),
                  isComputerAnalysisAllowed: true,
                  variant: gameState.game.meta.variant,
                ),
              ),
            ),
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
                    ref.read(computerGameControllerProvider.notifier).draw();
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
                    ref.read(computerGameControllerProvider.notifier).resign();
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
  const _Player({required this.side});

  final Side side;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(computerGameControllerProvider);
    final boardPreferences = ref.watch(boardPreferencesProvider);

    return GamePlayer(
      game: gameState.game,
      side: side,
      materialDiff: boardPreferences.materialDifferenceFormat.visible
          ? gameState.currentMaterialDiff(side)
          : null,
      materialDifferenceFormat: boardPreferences.materialDifferenceFormat,
      shouldLinkToUserProfile: false,
    );
  }
}
