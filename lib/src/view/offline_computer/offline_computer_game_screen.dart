import 'dart:async';
import 'dart:math';

import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/offline_computer_game.dart';
import 'package:lichess_mobile/src/model/offline_computer/offline_computer_game_controller.dart';
import 'package:lichess_mobile/src/model/offline_computer/offline_computer_game_preferences.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/utils/immersive_mode.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/game_layout.dart';
import 'package:lichess_mobile/src/widgets/material_diff.dart';
import 'package:lichess_mobile/src/widgets/non_linear_slider.dart';
import 'package:lichess_mobile/src/widgets/yes_no_dialog.dart';

class OfflineComputerGameScreen extends StatelessWidget {
  const OfflineComputerGameScreen({super.key});

  static Route<void> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const OfflineComputerGameScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.playAgainstComputer)),
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
  final _boardKey = GlobalKey(debugLabel: 'boardOnOfflineComputerScreen');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showNewGameDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(offlineComputerGameControllerProvider);

    ref.listen(offlineComputerGameControllerProvider, (previous, newGameState) {
      if (previous?.finished == false && newGameState.finished) {
        Timer(const Duration(milliseconds: 500), () {
          if (context.mounted) {
            showAdaptiveDialog<void>(
              context: context,
              builder: (context) => OfflineComputerGameResultDialog(
                game: newGameState.game,
                onNewGame: () {
                  Navigator.pop(context);
                  _showNewGameDialog();
                },
              ),
              barrierDismissible: true,
            );
          }
        });
      }
    });

    final orientation = gameState.game.playerSide;
    final isPlayerTurn = gameState.turn == orientation && !gameState.isEngineThinking;

    return WakelockWidget(
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop) return;

          final navigator = Navigator.of(context);
          final game = gameState.game;
          if (game.abortable) {
            return navigator.pop();
          }

          if (game.playable) {
            final shouldPop = await showAdaptiveDialog<bool>(
              context: context,
              builder: (context) => YesNoDialog(
                title: Text(context.l10n.mobileAreYouSure),
                content: const Text('Your game will be lost.'),
                onNo: () => Navigator.of(context).pop(false),
                onYes: () => Navigator.of(context).pop(true),
              ),
            );
            if (shouldPop == true) {
              navigator.pop();
            }
          } else {
            navigator.pop();
          }
        },
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
                    variant: Variant.standard,
                    position: gameState.currentPosition,
                    playerSide: gameState.game.finished
                        ? PlayerSide.none
                        : isPlayerTurn
                        ? (orientation == Side.white ? PlayerSide.white : PlayerSide.black)
                        : PlayerSide.none,
                    onPromotionSelection: ref
                        .read(offlineComputerGameControllerProvider.notifier)
                        .onPromotionSelection,
                    promotionMove: gameState.promotionMove,
                    onMove: (move, {isDrop}) {
                      ref.read(offlineComputerGameControllerProvider.notifier).makeMove(move);
                    },
                    premovable: null,
                  ),
                  moves: gameState.moves,
                  currentMoveIndex: gameState.stepCursor,
                  userActionsBar: _BottomBar(onNewGame: _showNewGameDialog),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNewGameDialog() {
    showAdaptiveDialog<void>(context: context, builder: (context) => const _NewGameDialog());
  }
}

class _BottomBar extends ConsumerWidget {
  const _BottomBar({required this.onNewGame});

  final VoidCallback onNewGame;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(offlineComputerGameControllerProvider);

    return BottomBar(
      children: [
        BottomBarButton(
          label: context.l10n.menu,
          onTap: () => _showGameMenu(context, ref),
          icon: Icons.menu,
        ),
        BottomBarButton(
          label: context.l10n.takeback,
          onTap: gameState.canTakeback
              ? () => ref.read(offlineComputerGameControllerProvider.notifier).takeback()
              : null,
          icon: CupertinoIcons.arrow_uturn_left,
        ),
        BottomBarButton(
          label: context.l10n.resign,
          onTap: gameState.game.resignable ? () => _showResignDialog(context, ref) : null,
          icon: CupertinoIcons.flag,
        ),
        BottomBarButton(label: 'New game', onTap: onNewGame, icon: CupertinoIcons.plus),
      ],
    );
  }

  Future<void> _showGameMenu(BuildContext context, WidgetRef ref) {
    final gameState = ref.read(offlineComputerGameControllerProvider);
    return showAdaptiveActionSheet(
      context: context,
      actions: [
        BottomSheetAction(makeLabel: (context) => const Text('New game'), onPressed: onNewGame),
        if (gameState.game.finished)
          BottomSheetAction(
            makeLabel: (context) => Text(context.l10n.analysis),
            onPressed: () => Navigator.of(context).push(
              AnalysisScreen.buildRoute(
                context,
                AnalysisOptions.standalone(
                  orientation: gameState.game.playerSide,
                  pgn: gameState.game.makePgn(),
                  isComputerAnalysisAllowed: true,
                  variant: Variant.standard,
                ),
              ),
            ),
          ),
        if (gameState.game.resignable)
          BottomSheetAction(
            makeLabel: (context) => Text(context.l10n.resign),
            onPressed: () => _showResignDialog(context, ref),
          ),
      ],
    );
  }

  void _showResignDialog(BuildContext context, WidgetRef ref) {
    showAdaptiveDialog<void>(
      context: context,
      builder: (context) => YesNoDialog(
        title: Text(context.l10n.resign),
        content: Text(context.l10n.mobileAreYouSure),
        onYes: () {
          Navigator.pop(context);
          ref.read(offlineComputerGameControllerProvider.notifier).resign();
        },
        onNo: () => Navigator.pop(context),
      ),
    );
  }
}

class _Player extends ConsumerWidget {
  const _Player({required this.side});

  final Side side;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(offlineComputerGameControllerProvider);
    final boardPreferences = ref.watch(boardPreferencesProvider);
    final game = gameState.game;
    final isStockfish = side != game.playerSide;
    final materialDiff = boardPreferences.materialDifferenceFormat.visible
        ? gameState.currentMaterialDiff(side)
        : null;

    if (isStockfish) {
      return Row(
        children: [
          Image.asset('assets/images/stockfish/icon.png', width: 44, height: 44),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      context.l10n.aiNameLevelAiLevel(
                        'Stockfish',
                        game.stockfishLevel.level.toString(),
                      ),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (gameState.isEngineThinking) ...[
                      const SizedBox(width: 8),
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                      ),
                    ],
                  ],
                ),
                MaterialDifferenceDisplay(
                  materialDiff: materialDiff,
                  materialDifferenceFormat: boardPreferences.materialDifferenceFormat,
                ),
              ],
            ),
          ),
        ],
      );
    }

    // Human player - just show captured pieces
    return Row(
      mainAxisSize: .max,
      mainAxisAlignment: .start,
      children: [
        MaterialDifferenceDisplay(
          materialDiff: materialDiff,
          materialDifferenceFormat: boardPreferences.materialDifferenceFormat,
        ),
      ],
    );
  }
}

class _NewGameDialog extends ConsumerStatefulWidget {
  const _NewGameDialog();

  @override
  ConsumerState<_NewGameDialog> createState() => _NewGameDialogState();
}

class _NewGameDialogState extends ConsumerState<_NewGameDialog> {
  late StockfishLevel _selectedLevel;
  late SideChoice _selectedSideChoice;

  @override
  void initState() {
    super.initState();
    final prefs = ref.read(offlineComputerGamePreferencesProvider);
    _selectedLevel = prefs.stockfishLevel;
    _selectedSideChoice = prefs.sideChoice;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text(context.l10n.gameSetup),
      content: Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Text('${context.l10n.level}: ${_selectedLevel.level}'),
            NonLinearSlider(
              value: _selectedLevel.level,
              values: StockfishLevel.values.map((l) => l.level).toList(),
              onChange: (value) {
                setState(() {
                  _selectedLevel = StockfishLevel.values[value.toInt() - 1];
                });
              },
              onChangeEnd: (value) {
                setState(() {
                  _selectedLevel = StockfishLevel.values[value.toInt() - 1];
                });
                ref.read(offlineComputerGamePreferencesProvider.notifier).setStockfishLevel(
                  _selectedLevel,
                );
              },
            ),
            const SizedBox(height: 16),
            Text(context.l10n.side),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              alignment: WrapAlignment.center,
              children: [
                ChoiceChip(
                  label: Text(context.l10n.white),
                  selected: _selectedSideChoice == SideChoice.white,
                  onSelected: (_) {
                    setState(() => _selectedSideChoice = SideChoice.white);
                    ref.read(offlineComputerGamePreferencesProvider.notifier).setSideChoice(
                      SideChoice.white,
                    );
                  },
                ),
                ChoiceChip(
                  label: Text(context.l10n.randomColor),
                  selected: _selectedSideChoice == SideChoice.random,
                  onSelected: (_) {
                    setState(() => _selectedSideChoice = SideChoice.random);
                    ref.read(offlineComputerGamePreferencesProvider.notifier).setSideChoice(
                      SideChoice.random,
                    );
                  },
                ),
                ChoiceChip(
                  label: Text(context.l10n.black),
                  selected: _selectedSideChoice == SideChoice.black,
                  onSelected: (_) {
                    setState(() => _selectedSideChoice = SideChoice.black);
                    ref.read(offlineComputerGamePreferencesProvider.notifier).setSideChoice(
                      SideChoice.black,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(context.l10n.cancel)),
        TextButton(
          onPressed: () {
            final side = _selectedSideChoice.toSide() ?? Side.values[Random().nextInt(2)];
            ref
                .read(offlineComputerGameControllerProvider.notifier)
                .startNewGame(stockfishLevel: _selectedLevel, playerSide: side);
            Navigator.pop(context);
          },
          child: Text(context.l10n.play),
        ),
      ],
    );
  }
}

class OfflineComputerGameResultDialog extends StatelessWidget {
  const OfflineComputerGameResultDialog({required this.game, required this.onNewGame, super.key});

  final OfflineComputerGame game;
  final VoidCallback onNewGame;

  @override
  Widget build(BuildContext context) {
    final winner = game.winner;
    final playerWon = winner == game.playerSide;
    final isDraw = winner == null && game.finished;

    final String title;
    if (isDraw) {
      title = context.l10n.draw;
    } else if (playerWon) {
      title = context.l10n.victory;
    } else {
      title = context.l10n.gameOver;
    }

    final String subtitle;
    if (game.status == GameStatus.mate) {
      subtitle = context.l10n.checkmate;
    } else if (game.status == GameStatus.resign) {
      subtitle = context.l10n.resign;
    } else if (game.status == GameStatus.stalemate) {
      subtitle = context.l10n.stalemate;
    } else {
      subtitle = context.l10n.draw;
    }

    return AlertDialog.adaptive(
      title: Text(title),
      content: Text(subtitle),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(context.l10n.close)),
        TextButton(onPressed: onNewGame, child: const Text('New game')),
      ],
    );
  }
}
