import 'dart:async';
import 'dart:math';

import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/game/game_board_params.dart';
import 'package:lichess_mobile/src/model/game/offline_computer_game.dart';
import 'package:lichess_mobile/src/model/offline_computer/offline_computer_game_controller.dart';
import 'package:lichess_mobile/src/model/offline_computer/offline_computer_game_preferences.dart';
import 'package:lichess_mobile/src/model/offline_computer/offline_computer_game_storage.dart';
import 'package:lichess_mobile/src/model/offline_computer/practice_comment.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/chessboard.dart';
import 'package:lichess_mobile/src/utils/focus_detector.dart';
import 'package:lichess_mobile/src/utils/immersive_mode.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/game/status_l10n.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/board_preview.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/game_layout.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/material_diff.dart';
import 'package:lichess_mobile/src/widgets/misc.dart';
import 'package:lichess_mobile/src/widgets/non_linear_slider.dart';
import 'package:lichess_mobile/src/widgets/pgn.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';
import 'package:lichess_mobile/src/widgets/variant_app_bar_title.dart';
import 'package:lichess_mobile/src/widgets/yes_no_dialog.dart';

extension _MoveVerdictDisplay on MoveVerdict {
  IconData get icon => switch (this) {
    .goodMove => Icons.check_circle,
    .notBest => Icons.info,
    .inaccuracy => Icons.help,
    .mistake => Icons.error,
    .blunder => Icons.cancel,
  };

  Color get color => switch (this) {
    .goodMove || .notBest => Colors.lightGreen,
    .inaccuracy => innacuracyColor,
    .mistake => mistakeColor,
    .blunder => blunderColor,
  };
}

extension _PracticeCommentDisplay on PracticeComment {
  IconData get icon => isBookMove ? Icons.menu_book : verdict.icon;
  Color get color => verdict.color;
}

class OfflineComputerGameScreen extends ConsumerWidget {
  const OfflineComputerGameScreen({this.initialVariant, this.initialFen, super.key});

  /// Optional initial variant to be preselected in the "New Game" dialog.
  ///
  /// If null, the variant from the last game against the computer will be used.
  final Variant? initialVariant;

  /// Optional initial FEN to start the game from a custom position.
  final String? initialFen;

  static Route<void> buildRoute(
    BuildContext context, {
    Variant? initialVariant,
    String? initialFen,
  }) {
    return buildScreenRoute(
      context,
      screen: OfflineComputerGameScreen(initialVariant: initialVariant, initialFen: initialFen),
    );
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
      appBar: AppBar(
        title: AppBarTitleText(title),
        actions: [
          if (practiceMode)
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Practice settings',
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (_) => const _PracticeSettingsSheet(),
                );
              },
            ),
        ],
      ),
      body: _Body(initialVariant: initialVariant, initialFen: initialFen),
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body({required this.initialVariant, this.initialFen});

  final Variant? initialVariant;

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
        _showNewGameDialog(initialVariant: widget.initialVariant);
        return;
      }

      final savedGame = await ref.read(offlineComputerGameStorageProvider).fetchGame();
      if (savedGame != null && savedGame.game.steps.length > 1) {
        ref.read(offlineComputerGameControllerProvider.notifier).loadGame(savedGame);
      } else {
        if (!mounted) return;
        _showNewGameDialog(initialVariant: widget.initialVariant);
      }
    });
  }

  Future<void> _saveGameState() async {
    if (!mounted) return;
    final state = ref.read(offlineComputerGameControllerProvider);
    await ref
        .read(offlineComputerGameStorageProvider)
        .save(SavedOfflineComputerGame(game: state.game));
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(offlineComputerGameControllerProvider);
    final boardColorScheme = ref.watch(boardPreferencesProvider).boardTheme.colors;

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
                  _showNewGameDialog(initialVariant: gameState.game.meta.variant);
                },
              ),
              barrierDismissible: true,
            );
          }
        });
      }

      // Check for threefold repetition
      if (previous?.game.isThreefoldRepetition == false &&
          newGameState.game.isThreefoldRepetition == true) {
        Timer(const Duration(milliseconds: 500), () {
          if (context.mounted) {
            showAdaptiveDialog<void>(
              context: context,
              builder: (context) => YesNoDialog(
                title: Text(context.l10n.threefoldRepetition),
                content: Text(context.l10n.claimADraw),
                onYes: () {
                  Navigator.pop(context);
                  ref.read(offlineComputerGameControllerProvider.notifier).claimThreefoldDraw();
                },
                onNo: () => Navigator.pop(context),
              ),
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
                    orientation: variantBoardOrientation(
                      variant: gameState.game.meta.variant,
                      youAre: orientation,
                      isBoardTurned: isBoardFlipped,
                    ),
                    lastMove: gameState.lastMove,
                    explosionSquares: gameState.stepCursor > 0
                        ? atomicExplosionSquares(
                            gameState.game.stepAt(gameState.stepCursor - 1).position,
                            gameState.lastMove,
                          )
                        : null,
                    shapes: _buildBoardShapes(gameState, boardColorScheme),
                    boardParams: GameBoardParams.interactive(
                      variant: gameState.game.meta.variant,
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
                      onMove: (move, {viaDragAndDrop}) {
                        ref.read(offlineComputerGameControllerProvider.notifier).makeMove(move);
                      },
                      premovable: null,
                    ),
                    moves: gameState.moves,
                    currentMoveIndex: gameState.stepCursor,
                    userActionsBar: _BottomBar(
                      onNewGame: () =>
                          _showNewGameDialog(initialVariant: gameState.game.meta.variant),
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

  void _showNewGameDialog({required Variant? initialVariant}) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: screenHeight - (screenHeight / 10)),
      builder: (context) =>
          _NewGameSheet(initialVariant: initialVariant, initialFen: widget.initialFen),
    );
  }

  ISet<Shape>? _buildBoardShapes(
    OfflineComputerGameState gameState,
    ChessboardColorScheme colorScheme,
  ) {
    final shapes = <Shape>{};

    // Add hint circle if showing
    if (gameState.hintSquare != null) {
      final ds = colorScheme.darkSquare;
      final isGreenBoard = ds.g > ds.r && ds.g > ds.b;
      final hintColor = isGreenBoard ? const Color(0x990099C8) : const Color(0x994D9E4D);
      shapes.add(Circle(color: hintColor, orig: gameState.hintSquare!));
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
        if (gameState.game.finished || gameState.game.casual || gameState.game.practiceMode)
          BottomSheetAction(
            makeLabel: (context) => Text(context.l10n.analysis),
            onPressed: () => Navigator.of(context).push(
              AnalysisScreen.buildRoute(
                context,
                AnalysisOptions.pgn(
                  id: gameState.game.id,
                  orientation: gameState.game.playerSide,
                  pgn: gameState.game.makePgn(),
                  isComputerAnalysisAllowed: true,
                  variant: gameState.game.meta.variant,
                ),
              ),
            ),
          ),
        if (gameState.game.resignable)
          BottomSheetAction(
            makeLabel: (context) => Text(context.l10n.resign),
            onPressed: () => _showResignDialog(context, ref),
          ),
        BottomSheetAction(
          makeLabel: (context) => Text(context.l10n.mobileNewGame),
          onPressed: onNewGame,
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

    final isShortScreen = isShortVerticalScreen(context);

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
                    if (gameState.isEngineThinking) ...const [
                      SizedBox(width: 8),
                      Icon(Icons.hourglass_top, size: 16),
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

    final practiceStatusLabel = !game.practiceMode
        ? null
        : gameState.isEvaluatingMove
        ? context.l10n.evaluatingYourMove
        : gameState.isEngineThinking
        ? context.l10n.computerThinking
        : !gameState.finished && gameState.turn == game.playerSide
        ? context.l10n.yourTurn
        : null;

    return Column(
      crossAxisAlignment: .stretch,
      mainAxisAlignment: .center,
      mainAxisSize: .min,
      children: [
        if (game.practiceMode) ...[
          Padding(
            padding: isShortScreen
                ? const EdgeInsets.only(bottom: 4.0)
                : const EdgeInsets.only(bottom: 8),
            child: Text(
              practiceStatusLabel ?? '',
              style: TextStyle(
                fontSize: isShortScreen ? 11 : null,
                fontStyle: FontStyle.italic,
                color: textShade(context, 0.8),
                height: isShortScreen ? 1.0 : null,
              ),
            ),
          ),
          _PracticeCommentCard(gameState: gameState),
          SizedBox(height: isShortScreen ? 4.0 : 8.0),
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

class _PracticeCommentCard extends ConsumerStatefulWidget {
  const _PracticeCommentCard({required this.gameState});

  final OfflineComputerGameState gameState;

  @override
  ConsumerState<_PracticeCommentCard> createState() => _PracticeCommentCardState();
}

class _PracticeCommentCardState extends ConsumerState<_PracticeCommentCard> {
  // Last non-null comment, kept so we can show it with opacity while a new evaluation is in
  // progress and no new comment has arrived yet.
  PracticeComment? _previousComment;

  @override
  void didUpdateWidget(_PracticeCommentCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.gameState.practiceComment != null && widget.gameState.practiceComment == null) {
      _previousComment = oldWidget.gameState.practiceComment;
    }
  }

  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(offlineComputerGamePreferencesProvider);
    final hideBestMove = prefs.hideBestMove;
    final hideEvaluation = prefs.hideEvaluation;
    final gameState = widget.gameState;
    final isEvaluatingMove = gameState.isEvaluatingMove;
    final practiceComment =
        gameState.practiceComment ?? (isEvaluatingMove ? _previousComment : null);
    final showingSuggestedMove = gameState.showingSuggestedMove;
    final isShortScreen = isShortVerticalScreen(context);
    final evalTextStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: isShortScreen ? 12 : 14,
      color: textShade(context, 0.6),
    );

    final cardHeight = isShortScreen ? 40.0 : 54.0;

    Widget content;
    Color? backgroundColor;
    Color? iconColor;
    IconData? icon;

    if (gameState.finished) {
      content = Text(context.l10n.gameOver, style: const TextStyle(fontStyle: .italic));
    } else if (practiceComment != null) {
      final verdict = practiceComment.verdict;
      final eval = gameState.currentAnalysis?.evalString;
      icon = practiceComment.icon;
      iconColor = practiceComment.color;
      backgroundColor = practiceComment.color.withValues(alpha: 0.1);

      final verdictText = switch (verdict) {
        MoveVerdict.goodMove => context.l10n.studyGoodMove,
        MoveVerdict.notBest => "Good, but there's better",
        MoveVerdict.inaccuracy => context.l10n.inaccuracy,
        MoveVerdict.mistake => context.l10n.mistake,
        MoveVerdict.blunder => context.l10n.blunder,
      };

      Widget? suggestedMoveWidget;
      final suggestedMove = practiceComment.moveSuggestion;
      if (suggestedMove != null && !hideBestMove) {
        final moveText = suggestedMove.san;
        final labelText = practiceComment.verdict == MoveVerdict.goodMove
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
            style: TextStyle(fontSize: 12, color: textShade(context, 0.6)),
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
          if ((eval ?? practiceComment.evalAfter) != null && !hideEvaluation)
            Text(eval ?? practiceComment.evalAfter!, style: evalTextStyle),
        ],
      );
    } else if (gameState.turn == gameState.game.playerSide) {
      final eval = gameState.currentAnalysis?.evalString;
      content = Row(
        children: [
          const Spacer(),
          if (!hideEvaluation)
            if (eval != null) Text(eval, style: evalTextStyle),
        ],
      );
    } else {
      content = const SizedBox.shrink();
    }

    return AnimatedOpacity(
      opacity: isEvaluatingMove && gameState.practiceComment == null ? 0.5 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        height: cardHeight,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: backgroundColor ?? Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Align(alignment: Alignment.centerLeft, child: content),
      ),
    );
  }
}

class _NewGameSheet extends ConsumerStatefulWidget {
  const _NewGameSheet({required this.initialVariant, this.initialFen});

  final Variant? initialVariant;

  final String? initialFen;

  @override
  ConsumerState<_NewGameSheet> createState() => _NewGameSheetState();
}

class _NewGameSheetState extends ConsumerState<_NewGameSheet> {
  late StockfishLevel _selectedLevel;
  late SideChoice _selectedSideChoice;
  late Variant _selectedVariant;
  late bool _casual;
  late bool _practiceMode;
  String? _fromPositionFen;
  final _fenController = TextEditingController();

  String _sideChoiceLabel(BuildContext context, SideChoice choice) => switch (choice) {
    SideChoice.white => context.l10n.white,
    SideChoice.random => context.l10n.randomColor,
    SideChoice.black => context.l10n.black,
    // TODO: replace with a translated string once the feature is stable
    SideChoice.nextToPlay => 'Next to play',
  };

  @override
  void initState() {
    super.initState();
    final prefs = ref.read(offlineComputerGamePreferencesProvider);
    _selectedLevel = prefs.stockfishLevel;
    _selectedSideChoice = widget.initialFen != null ? SideChoice.nextToPlay : prefs.sideChoice;
    final preferredVariant = widget.initialVariant ?? prefs.variant;
    _selectedVariant = widget.initialFen == null && preferredVariant == Variant.fromPosition
        ? Variant.standard
        : preferredVariant;
    _casual = prefs.casual;
    _practiceMode = prefs.practiceMode;
    _fenController.addListener(() {
      setState(() => _fromPositionFen = _fenController.text);
    });
  }

  @override
  void dispose() {
    _fenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final boardPrefs = ref.watch(boardPreferencesProvider);

    return BottomSheetScrollableContainer(
      children: [
        if (widget.initialFen != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: StaticChessboard(
                      size: 150,
                      fen: widget.initialFen!,
                      orientation: _selectedSideChoice.toSide(fen: widget.initialFen) ?? Side.white,
                      pieceAssets: boardPrefs.pieceSet.assets,
                      colorScheme: boardPrefs.boardTheme.colors,
                      brightness: boardPrefs.brightness,
                      hue: boardPrefs.hue,
                      enableCoordinates: false,
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    Setup.parseFen(widget.initialFen!).turn == Side.white
                        ? context.l10n.whitePlays
                        : context.l10n.blackPlays,
                    style: TextStyle(fontStyle: FontStyle.italic, color: textShade(context, 0.7)),
                  ),
                ],
              ),
            ),
          ),
        ListSection(
          materialFilledCard: true,
          children: [
            ListTile(
              title: Text.rich(
                TextSpan(
                  text: '${context.l10n.level}: ',
                  children: [
                    TextSpan(
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      text: '${_selectedLevel.level}',
                    ),
                  ],
                ),
              ),
              subtitle: NonLinearSlider(
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
            ),
            SettingsListTile(
              settingsLabel: Text(context.l10n.side),
              settingsValue: _sideChoiceLabel(context, _selectedSideChoice),
              onTap: () {
                showChoicePicker(
                  context,
                  choices: (widget.initialFen != null || _selectedVariant == Variant.fromPosition)
                      ? SideChoice.values
                      : SideChoice.values.where((c) => c != SideChoice.nextToPlay).toList(),
                  selectedItem: _selectedSideChoice,
                  labelBuilder: (SideChoice choice) => Text(_sideChoiceLabel(context, choice)),
                  onSelectedItemChanged: (SideChoice choice) {
                    setState(() => _selectedSideChoice = choice);
                    ref.read(offlineComputerGamePreferencesProvider.notifier).setSideChoice(choice);
                  },
                );
              },
            ),
            SettingsListTile(
              settingsLabel: Text(context.l10n.variant),
              settingsValue: _selectedVariant.label,
              onTap: () {
                showChoicePicker(
                  context,
                  choices: playSupportedVariants.toList(),
                  selectedItem: _selectedVariant,
                  labelBuilder: (variant) => VariantLabel(variant),
                  onSelectedItemChanged: (Variant variant) {
                    setState(() {
                      _selectedVariant = variant;
                      if (variant == Variant.crazyhouse) {
                        _practiceMode = false;
                      }
                    });
                    ref.read(offlineComputerGamePreferencesProvider.notifier).setVariant(variant);
                  },
                );
              },
            ),
            if (widget.initialFen == null)
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
                child: _selectedVariant == Variant.fromPosition
                    ? SmallBoardPreview(
                        orientation:
                            _selectedSideChoice.toSide(fen: _fromPositionFen) ?? Side.white,
                        fen: _fromPositionFen ?? kEmptyFEN,
                        description: TextField(
                          maxLines: 5,
                          decoration: InputDecoration(
                            labelText: context.l10n.pasteTheFenStringHere,
                            suffixIcon: const Icon(Icons.paste),
                          ),
                          controller: _fenController,
                          readOnly: true,
                          onTap: _getClipboardData,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            SwitchSettingTile(
              title: const Text('Practice mode'),
              subtitle: const Text('Get feedback on your moves'),
              value: _practiceMode,
              onChanged: _selectedVariant == Variant.crazyhouse
                  ? null
                  : (value) {
                      setState(() => _practiceMode = value);
                      ref
                          .read(offlineComputerGamePreferencesProvider.notifier)
                          .setPracticeMode(value);
                    },
            ),
            SwitchSettingTile(
              title: Text(context.l10n.casual),
              subtitle: const Text('Allow takebacks and hints'),
              value: _practiceMode || _casual,
              onChanged: _practiceMode
                  ? null
                  : (value) {
                      setState(() => _casual = value);
                      ref.read(offlineComputerGamePreferencesProvider.notifier).setCasual(value);
                    },
            ),
          ],
        ),
        Padding(
          padding: Styles.horizontalBodyPadding,
          child: FilledButton(
            onPressed: _isPlayEnabled
                ? () {
                    final effectiveFen =
                        widget.initialFen ??
                        (_selectedVariant == Variant.fromPosition ? _fromPositionFen : null);
                    final side =
                        _selectedSideChoice.toSide(fen: effectiveFen) ??
                        Side.values[Random().nextInt(2)];
                    ref
                        .read(offlineComputerGameControllerProvider.notifier)
                        .startNewGame(
                          stockfishLevel: _selectedLevel,
                          playerSide: side,
                          casual: _practiceMode || _casual,
                          practiceMode: _practiceMode,
                          variant: _selectedVariant,
                          initialFen: effectiveFen,
                        );
                    Navigator.pop(context);
                  }
                : null,
            child: Text(context.l10n.play, style: Styles.bold),
          ),
        ),
      ],
    );
  }

  bool get _isPlayEnabled =>
      _selectedVariant != Variant.fromPosition ||
      widget.initialFen != null ||
      (_fromPositionFen != null && _fromPositionFen!.isNotEmpty);

  Future<void> _getClipboardData() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null) {
      try {
        Chess.fromSetup(Setup.parseFen(data.text!.trim()));
        _fenController.text = data.text!.trim();
      } catch (_) {
        if (mounted) {
          showSnackBar(context, context.l10n.invalidFen, type: SnackBarType.error);
        }
      }
    }
  }
}

class _PracticeSettingsSheet extends ConsumerWidget {
  const _PracticeSettingsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(offlineComputerGamePreferencesProvider);

    return BottomSheetScrollableContainer(
      children: [
        ListSection(
          header: const Text('Practice settings'),
          materialFilledCard: true,
          children: [
            SwitchSettingTile(
              title: Text(context.l10n.hideBestMove),
              value: prefs.hideBestMove,
              onChanged: (_) {
                ref.read(offlineComputerGamePreferencesProvider.notifier).toggleHideBestMove();
              },
            ),
            SwitchSettingTile(
              title: const Text('Hide evaluation'),
              value: prefs.hideEvaluation,
              onChanged: (_) {
                ref.read(offlineComputerGamePreferencesProvider.notifier).toggleHideEvaluation();
              },
            ),
          ],
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

    final subtitle = gameStatusL10n(
      context,
      variant: game.meta.variant,
      status: game.status,
      lastPosition: game.lastPosition,
      winner: game.winner,
      isThreefoldRepetition: game.isThreefoldRepetition,
    );

    return AlertDialog.adaptive(
      title: Text(title),
      content: Text(subtitle),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(context.l10n.close)),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              AnalysisScreen.buildRoute(
                context,
                AnalysisOptions.pgn(
                  id: game.id,
                  orientation: game.playerSide,
                  pgn: game.makePgn(),
                  isComputerAnalysisAllowed: true,
                  variant: game.meta.variant,
                ),
              ),
            );
          },
          child: Text(context.l10n.analysis),
        ),
        TextButton(onPressed: onNewGame, child: Text(context.l10n.mobileNewGame)),
      ],
    );
  }
}
