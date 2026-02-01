import 'dart:async';
import 'dart:math';

import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/offline_computer_game.dart';
import 'package:lichess_mobile/src/model/offline_computer/offline_computer_game_controller.dart';
import 'package:lichess_mobile/src/model/offline_computer/offline_computer_game_preferences.dart';
import 'package:lichess_mobile/src/model/offline_computer/offline_computer_game_storage.dart';
import 'package:lichess_mobile/src/model/offline_computer/practice_comment.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/utils/focus_detector.dart';
import 'package:lichess_mobile/src/utils/immersive_mode.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/game_layout.dart';
import 'package:lichess_mobile/src/widgets/material_diff.dart';
import 'package:lichess_mobile/src/widgets/non_linear_slider.dart';
import 'package:lichess_mobile/src/widgets/yes_no_dialog.dart';

class OfflineComputerGameScreen extends ConsumerWidget {
  const OfflineComputerGameScreen({this.initialFen, super.key});

  /// Optional initial FEN to start the game from a custom position.
  final String? initialFen;

  static Route<void> buildRoute(BuildContext context, {String? initialFen}) {
    return buildScreenRoute(context, screen: OfflineComputerGameScreen(initialFen: initialFen));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final practiceMode = ref.watch(
      offlineComputerGameControllerProvider.select((s) => s.game.practiceMode),
    );
    final title = practiceMode
        ? context.l10n.practiceWithComputer
        : context.l10n.playAgainstComputer;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: _Body(initialFen: initialFen),
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body({this.initialFen});

  final String? initialFen;

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  final _boardKey = GlobalKey(debugLabel: 'boardOnOfflineComputerScreen');

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // If we have an initial FEN, always show the new game dialog
      if (widget.initialFen != null) {
        if (!mounted) return;
        _showNewGameDialog();
        return;
      }

      final savedGame = await ref.read(offlineComputerGameStorageProvider).fetchGame();
      if (savedGame != null && savedGame.game.steps.length > 1 && !savedGame.game.finished) {
        ref.read(offlineComputerGameControllerProvider.notifier).loadGame(savedGame);
      } else {
        if (!mounted) return;
        _showNewGameDialog();
      }
    });
  }

  Future<void> _saveGameState() async {
    if (!mounted) return;
    final state = ref.read(offlineComputerGameControllerProvider);
    await ref
        .read(offlineComputerGameStorageProvider)
        .save(
          SavedOfflineComputerGame(
            game: state.game,
            gameSessionId: state.gameSessionId.value,
            lastPracticeComment: state.practiceComment,
            lastEvalString: state.cachedEvalString,
          ),
        );
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

    final isBoardFlipped = ref.watch(_isBoardFlippedProvider);
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
                content: const Text('No worries, your game will be saved.'),
                onNo: () => Navigator.of(context).pop(false),
                onYes: () => Navigator.of(context).pop(true),
              ),
            );
            if (shouldPop == true) {
              await _saveGameState();
              navigator.pop();
            }
          } else {
            // Save state even if the game is finished, we might want to analyse it later
            await _saveGameState();
            navigator.pop();
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
                    topTable: _Player(side: isBoardFlipped ? orientation : orientation.opposite),
                    bottomTable: _Player(side: isBoardFlipped ? orientation.opposite : orientation),
                    topTableFlex: 1,
                    bottomTableFlex: gameState.game.practiceMode ? 2 : 1,
                    orientation: isBoardFlipped ? orientation.opposite : orientation,
                    fen: gameState.currentPosition.fen,
                    lastMove: gameState.lastMove,
                    shapes: _buildBoardShapes(gameState),
                    interactiveBoardParams: (
                      variant: Variant.standard,
                      position: gameState.currentPosition,
                      playerSide: gameState.game.finished
                          ? PlayerSide.none
                          : isPlayerTurn && !gameState.isEvaluatingMove
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
      ),
    );
  }

  void _showNewGameDialog() {
    showAdaptiveDialog<void>(
      context: context,
      builder: (context) => _NewGameDialog(initialFen: widget.initialFen),
    );
  }

  ISet<Shape>? _buildBoardShapes(OfflineComputerGameState gameState) {
    final shapes = <Shape>{};

    // Add hint circle if showing
    if (gameState.hintSquare != null) {
      shapes.add(Circle(color: const Color(0x664D9E4D), orig: gameState.hintSquare!));
    }

    // Add suggested move arrow if showing
    final suggestedMove = gameState.showingSuggestedMove;
    if (suggestedMove != null) {
      final color = gameState.practiceComment?.verdict.color ?? Colors.blue;
      shapes.add(
        Arrow(
          color: color.withValues(alpha: 0.8),
          orig: suggestedMove.from,
          dest: suggestedMove.to,
        ),
      );
    }

    return shapes.isNotEmpty ? ISet(shapes) : null;
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
          onTap: gameState.canTakeback && (gameState.game.casual || gameState.game.practiceMode)
              ? () => ref.read(offlineComputerGameControllerProvider.notifier).takeback()
              : null,
          icon: CupertinoIcons.arrow_uturn_left,
        ),
        BottomBarButton(
          label: context.l10n.resign,
          onTap: gameState.game.resignable ? () => _showResignDialog(context, ref) : null,
          icon: CupertinoIcons.flag,
        ),
        BottomBarButton(
          label: context.l10n.getAHint,
          onTap: _canGetHint(gameState)
              ? () => ref.read(offlineComputerGameControllerProvider.notifier).hint()
              : null,
          icon: CupertinoIcons.lightbulb,
          highlighted: gameState.hintSquare != null,
        ),
      ],
    );
  }

  Future<void> _showGameMenu(BuildContext context, WidgetRef ref) {
    final gameState = ref.read(offlineComputerGameControllerProvider);
    return showAdaptiveActionSheet(
      context: context,
      actions: [
        BottomSheetAction(
          makeLabel: (context) => Text(context.l10n.flipBoard),
          onPressed: () {
            ref.read(_isBoardFlippedProvider.notifier).toggle();
          },
        ),
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

  bool _canGetHint(OfflineComputerGameState gameState) {
    return (gameState.game.casual || gameState.game.practiceMode) &&
        gameState.game.playable &&
        !gameState.isEngineThinking &&
        !gameState.isLoadingHint &&
        !gameState.isEvaluatingMove &&
        gameState.turn == gameState.game.playerSide;
  }
}

final _isBoardFlippedProvider = NotifierProvider.autoDispose<IsBoardFlippedNotifier, bool>(
  IsBoardFlippedNotifier.new,
  name: 'IsBoardFlippedProvider',
);

class IsBoardFlippedNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void toggle() {
    state = !state;
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

    // Human player - just show captured pieces and practice comment
    return Column(
      crossAxisAlignment: .stretch,
      mainAxisAlignment: .center,
      mainAxisSize: .min,
      children: [
        if (game.practiceMode) ...[
          _PracticeCommentCard(gameState: gameState),
          const SizedBox(height: 8),
        ],
        Row(
          mainAxisSize: .max,
          mainAxisAlignment: .start,
          children: [
            MaterialDifferenceDisplay(
              materialDiff: materialDiff,
              materialDifferenceFormat: boardPreferences.materialDifferenceFormat,
            ),
          ],
        ),
      ],
    );
  }
}

class _PracticeCommentCard extends ConsumerWidget {
  const _PracticeCommentCard({required this.gameState});

  final OfflineComputerGameState gameState;

  static const _cardHeight = 54.0;
  static const _evalTextStyle = TextStyle(fontWeight: FontWeight.w600, fontSize: 14);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEvaluatingMove = gameState.isEvaluatingMove;
    final practiceComment = gameState.practiceComment;
    final showingSuggestedMove = gameState.showingSuggestedMove;

    Widget content;
    Color? backgroundColor;
    Color? iconColor;
    IconData? icon;

    if (isEvaluatingMove) {
      content = Row(
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator.adaptive(strokeWidth: 2),
          ),
          const SizedBox(width: 8),
          Text(context.l10n.evaluatingYourMove),
        ],
      );
    } else if (practiceComment != null) {
      final verdict = practiceComment.verdict;
      icon = verdict.icon;
      iconColor = verdict.color;
      backgroundColor = verdict.color.withValues(alpha: 0.1);

      final verdictText = switch (verdict) {
        MoveVerdict.goodMove => context.l10n.studyGoodMove,
        MoveVerdict.inaccuracy => context.l10n.inaccuracy,
        MoveVerdict.mistake => context.l10n.mistake,
        MoveVerdict.blunder => context.l10n.blunder,
      };

      Widget? suggestedMoveWidget;
      final suggestedMove = practiceComment.suggestedMove;
      if (suggestedMove != null) {
        final moveText = suggestedMove.san;
        final labelText = practiceComment.isShowingAlternative
            ? context.l10n.anotherWasX('')
            : context.l10n.bestWasX('');
        final label = labelText.replaceAll(' ', '').isEmpty
            ? ''
            : labelText.substring(0, labelText.length - 1);
        final isShowing = showingSuggestedMove == suggestedMove.move;

        suggestedMoveWidget = GestureDetector(
          onTap: () {
            final move = suggestedMove.move;
            if (move is NormalMove) {
              ref.read(offlineComputerGameControllerProvider.notifier).toggleSuggestedMove(move);
            }
          },
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: label),
                const TextSpan(text: ' '),
                TextSpan(
                  text: moveText,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isShowing ? iconColor : null,
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.dotted,
                  ),
                ),
              ],
            ),
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        );
      }

      content = Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  verdictText,
                  style: TextStyle(fontWeight: FontWeight.w600, color: iconColor),
                ),
                if (suggestedMoveWidget != null) suggestedMoveWidget,
              ],
            ),
          ),
          if (practiceComment.evalAfter != null)
            Text(practiceComment.evalAfter!, style: _evalTextStyle),
        ],
      );
    } else if (gameState.finished) {
      // Game is over
      content = Text(context.l10n.gameOver, style: const TextStyle(fontStyle: .italic));
    } else {
      final cachedEval = gameState.cachedEvalString;
      content = Row(
        children: [
          Expanded(
            child: Text(context.l10n.yourTurn, style: const TextStyle(fontStyle: .italic)),
          ),
          if (cachedEval != null)
            Text(cachedEval, style: _evalTextStyle)
          else
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator.adaptive(strokeWidth: 2),
            ),
        ],
      );
    }

    return Container(
      height: _cardHeight,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Align(alignment: Alignment.centerLeft, child: content),
    );
  }
}

class _NewGameDialog extends ConsumerStatefulWidget {
  const _NewGameDialog({this.initialFen});

  final String? initialFen;

  @override
  ConsumerState<_NewGameDialog> createState() => _NewGameDialogState();
}

class _NewGameDialogState extends ConsumerState<_NewGameDialog> {
  late StockfishLevel _selectedLevel;
  late SideChoice _selectedSideChoice;
  late bool _casual;
  late bool _practiceMode;

  String _sideChoiceLabel(BuildContext context, SideChoice choice) => switch (choice) {
    SideChoice.white => context.l10n.white,
    SideChoice.random => context.l10n.randomColor,
    SideChoice.black => context.l10n.black,
  };

  @override
  void initState() {
    super.initState();
    final prefs = ref.read(offlineComputerGamePreferencesProvider);
    _selectedLevel = prefs.stockfishLevel;
    _selectedSideChoice = prefs.sideChoice;
    _casual = prefs.casual;
    _practiceMode = prefs.practiceMode;
  }

  @override
  Widget build(BuildContext context) {
    final boardPrefs = ref.watch(boardPreferencesProvider);

    return AlertDialog.adaptive(
      title: Text(context.l10n.gameSetup),
      content: Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.initialFen != null) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: 150,
                height: 150,
                child: StaticChessboard(
                  size: 150,
                  fen: widget.initialFen!,
                  orientation: _selectedSideChoice.toSide() ?? Side.white,
                  pieceAssets: boardPrefs.pieceSet.assets,
                  colorScheme: boardPrefs.boardTheme.colors,
                  brightness: boardPrefs.brightness,
                  hue: boardPrefs.hue,
                  enableCoordinates: false,
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                ),
              ),
              const SizedBox(height: 16),
            ] else
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
                ref
                    .read(offlineComputerGamePreferencesProvider.notifier)
                    .setStockfishLevel(_selectedLevel);
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(context.l10n.side),
              trailing: TextButton(
                onPressed: () {
                  showChoicePicker(
                    context,
                    choices: SideChoice.values,
                    selectedItem: _selectedSideChoice,
                    labelBuilder: (SideChoice choice) => Text(_sideChoiceLabel(context, choice)),
                    onSelectedItemChanged: (SideChoice choice) {
                      setState(() => _selectedSideChoice = choice);
                      ref
                          .read(offlineComputerGamePreferencesProvider.notifier)
                          .setSideChoice(choice);
                    },
                  );
                },
                child: Text(_sideChoiceLabel(context, _selectedSideChoice)),
              ),
            ),
            SwitchListTile.adaptive(
              title: const Text('Practice mode'),
              subtitle: const Text('Get feedback on your moves'),
              value: _practiceMode,
              onChanged: (value) {
                setState(() => _practiceMode = value);
                ref.read(offlineComputerGamePreferencesProvider.notifier).setPracticeMode(value);
              },
              contentPadding: EdgeInsets.zero,
            ),
            SwitchListTile.adaptive(
              title: Text(context.l10n.casual),
              subtitle: const Text('Allow takebacks and hints'),
              value: _practiceMode || _casual,
              onChanged: _practiceMode
                  ? null
                  : (value) {
                      setState(() => _casual = value);
                      ref.read(offlineComputerGamePreferencesProvider.notifier).setCasual(value);
                    },
              contentPadding: EdgeInsets.zero,
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
                .startNewGame(
                  stockfishLevel: _selectedLevel,
                  playerSide: side,
                  // In practice mode, casual is always true
                  casual: _practiceMode || _casual,
                  practiceMode: _practiceMode,
                  initialFen: widget.initialFen,
                );
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
