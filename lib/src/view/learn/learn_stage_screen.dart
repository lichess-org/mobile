import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/learn/learn_level.dart';
import 'package:lichess_mobile/src/model/learn/learn_level_state.dart';
import 'package:lichess_mobile/src/model/learn/learn_progress.dart';
import 'package:lichess_mobile/src/model/learn/learn_score.dart';
import 'package:lichess_mobile/src/model/learn/learn_stage_controller.dart';
import 'package:lichess_mobile/src/model/learn/learn_stages.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/view/learn/learn_screen.dart';
import 'package:lichess_mobile/src/view/settings/toggle_sound_button.dart';
import 'package:lichess_mobile/src/widgets/board.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

/// Plays the levels of a learn stage.
class const LearnStageScreen({required final LearnStage stage, super.key}) extends ConsumerWidget {
  static Route<dynamic> buildRoute(LearnStage stage) {
    return buildScreenRoute(screen: LearnStageScreen(stage: stage));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stageNumber = learnStages.indexOf(stage) + 1;
    return Scaffold(
      appBar: AppBar(
        title: Text('${context.l10n.learnStageX('$stageNumber')}: ${stage.title(context.l10n)}'),
        actions: const [ToggleSoundButton()],
      ),
      // The controller reads the saved progress to pick the level to start with.
      body: switch (ref.watch(learnProgressProvider)) {
        AsyncData() => _Body(stage: stage),
        AsyncError(:final error) => Center(child: Text('Could not load progress: $error')),
        _ => const Center(child: CircularProgressIndicator.adaptive()),
      },
    );
  }
}

class const _Body({required final LearnStage stage}) extends ConsumerStatefulWidget {
  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState() extends ConsumerState<_Body> {
  late final ChessboardController _boardController;

  @override
  void initState() {
    super.initState();
    final provider = learnStageControllerProvider(widget.stage);
    _boardController = ChessboardController(game: _gameData(ref.read(provider).level));
    ref.listenManual(provider.select((s) => s.level), (prev, level) {
      // A new level replaces the position without animation.
      final isNewLevel = prev?.level != level.level || level.nbMoves < (prev?.nbMoves ?? 0);
      _boardController.updatePosition(_gameData(level), animate: !isNewLevel, resetPremove: true);
    });
  }

  @override
  void dispose() {
    _boardController.dispose();
    super.dispose();
  }

  GameData _gameData(LearnLevelState level) => GameData(
    fen: level.displayFen,
    playerSide: level.isPlayerTurn
        ? (level.level.color == Side.white ? PlayerSide.white : PlayerSide.black)
        : PlayerSide.none,
    sideToMove: level.position.turn,
    validMoves: level.playerDests,
    lastMove: level.lastMove,
    kingSquareInCheck: level.checkSquare,
  );

  @override
  Widget build(BuildContext context) {
    final provider = learnStageControllerProvider(widget.stage);
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);
    final boardPrefs = ref.watch(boardPreferencesProvider);

    return Stack(
      children: [
        SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isTablet = isTabletOrLarger(context);
              final isLandscape = constraints.biggest.aspectRatio > 1;
              final defaultBoardSize = constraints.biggest.shortestSide;
              final remainingHeight = constraints.maxHeight - defaultBoardSize;
              final boardSize = isTablet || isLandscape || remainingHeight < kSmallHeightMinusBoard
                  ? defaultBoardSize - kTabletBoardTableSidePadding * 2
                  : defaultBoardSize;

              final settings = boardPrefs
                  .toBoardSettings(Variant.standard)
                  .copyWith(
                    enablePremoves: false,
                    autoQueenPromotion: false,
                    borderRadius: isTablet || isLandscape
                        ? Styles.boardBorderRadius
                        : BorderRadius.zero,
                    boxShadow: isTablet || isLandscape ? boardShadows : const <BoxShadow>[],
                  );

              final board = _LearnBoard(
                size: boardSize,
                level: state.level,
                controller: _boardController,
                settings: settings,
                onMove: (move) {
                  if (move is NormalMove) controller.onUserMove(move);
                },
              );

              final table = _Table(state: state);

              return isLandscape
                  ? Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(kTabletBoardTableSidePadding),
                          child: board,
                        ),
                        Expanded(child: table),
                      ],
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: boardSize < defaultBoardSize
                              ? const EdgeInsets.all(kTabletBoardTableSidePadding)
                              : EdgeInsets.zero,
                          child: board,
                        ),
                        Expanded(child: table),
                      ],
                    );
            },
          ),
        ),
        if (state.starting)
          _Overlay(
            onDismiss: controller.hideIntro,
            child: _StageIntro(stage: widget.stage, onStart: controller.hideIntro),
          )
        else if (state.stageCompleted)
          _Overlay(child: _StageComplete(stage: widget.stage)),
      ],
    );
  }
}

/// The board, with the apples and hints of the level.
class const _LearnBoard({
  required final double size,
  required final LearnLevelState level,
  required final ChessboardController controller,
  required final ChessboardSettings settings,
  required final void Function(Move move) onMove,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orientation = level.level.color;
    final borderWidth = settings.border?.width ?? 0.0;
    final squareSize = (size - borderWidth * 2) / 8;

    Offset squareOffset(Square square) {
      final x = orientation == Side.white ? square.file : 7 - square.file;
      final y = orientation == Side.white ? 7 - square.rank : square.rank;
      return Offset(borderWidth + x * squareSize, borderWidth + y * squareSize);
    }

    final highlightedRank = level.level.highlightedRank;
    final threat = level.threatSquare;

    return SizedBox.square(
      dimension: size,
      child: Stack(
        children: [
          BoardWidget(
            size: size,
            orientation: orientation,
            controller: controller,
            settings: settings,
            onMove: (move, {viaDragAndDrop}) => onMove(move),
            shapes: {
              ...level.shapes.map(_toBoardShape),
              for (final apple in level.apples)
                CustomShape(orig: apple, scale: 0.8, child: const _Apple()),
            },
            annotations: threat != null
                ? {threat: const Annotation(symbol: '!', color: LichessColors.error)}
                : const {},
          ),
          if (highlightedRank != null)
            Positioned(
              left: borderWidth,
              top: squareOffset(Square.fromCoords(File.a, Rank.values[highlightedRank - 1])).dy,
              width: squareSize * 8,
              height: squareSize,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: LichessColors.good, width: 3.0),
                    color: LichessColors.good.withValues(alpha: 0.15),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

Shape _toBoardShape(LearnShape shape) {
  final color = switch (shape.brush) {
    LearnBrush.green => ShapeColor.green.color,
    LearnBrush.paleGreen => ShapeColor.green.color.withValues(alpha: 0.4),
    LearnBrush.red => ShapeColor.red.color,
    LearnBrush.yellow => ShapeColor.yellow.color,
    LearnBrush.blue => ShapeColor.blue.color,
  };
  final dest = shape.dest;
  return dest != null
      ? Arrow(color: color, orig: shape.orig, dest: dest)
      : Circle(color: color, orig: shape.orig);
}

/// A star to collect.
///
/// Scaled to the box the board gives it, so it must stay `const`: [CustomShape] compares its child
/// by equality to decide whether the shape layer changed.
class const _Apple() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const FittedBox(
      child: Icon(
        Symbols.star_rounded,
        fill: 1,
        size: 48.0,
        color: Color(0xFFFFD43B),
        shadows: [Shadow(color: Color(0xAAD86D00), blurRadius: 4.0, offset: Offset(0, 1))],
      ),
    );
  }
}

/// The goal of the level, its result, and the progress through the stage.
class const _Table({required final LearnStageState state}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(learnStageControllerProvider(state.stage).notifier);
    final level = state.level;
    final l10n = context.l10n;
    final progress = ref.watch(learnProgressProvider).value ?? LearnProgress.empty;

    final Widget result;
    if (level.failed) {
      result = Column(
        children: [
          Text(
            l10n.learnPuzzleFailed,
            style: Styles.title.copyWith(color: context.lichessColors.error),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12.0),
          FilledButton.icon(
            onPressed: controller.retry,
            icon: const Icon(Icons.refresh),
            label: Text(l10n.learnRetry),
          ),
        ],
      );
    } else if (level.completed) {
      result = Column(
        children: [
          Text(
            _congrats(l10n, state.levelIndex),
            style: Styles.title.copyWith(color: context.lichessColors.good),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12.0),
          if (level.level.nextButton)
            FilledButton(onPressed: controller.next, child: Text(l10n.learnNext))
          else
            LearnStars(rank: learnLevelRank(level.level, level.score), size: 32.0),
        ],
      );
    } else {
      result = Column(
        children: [
          Text(
            level.level.goal(l10n),
            style: Styles.callout.copyWith(fontSize: 18.0),
            textAlign: TextAlign.center,
          ),
          if (level.level.explainPromotion && _isPawnAboutToPromote(level)) ...[
            const SizedBox(height: 12.0),
            Text(l10n.learnPawnPromotion, style: Styles.title),
            Text(
              '${l10n.learnYourPawnReachedTheEndOfTheBoard} '
              '${l10n.learnItNowPromotesToAStrongerPiece} ${l10n.learnSelectThePieceYouWant}',
              textAlign: TextAlign.center,
            ),
          ],
        ],
      );
    }

    return ListView(
      padding: Styles.bodyPadding,
      children: [
        Row(
          children: [
            LearnStageIcon(stage: state.stage, size: 48.0),
            const SizedBox(width: 12.0),
            Expanded(
              child: Text(
                state.stage.subtitle(l10n),
                style: TextStyle(color: textShade(context, Styles.subtitleOpacity)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24.0),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: KeyedSubtree(
            key: ValueKey((state.levelIndex, level.failed, level.completed)),
            child: result,
          ),
        ),
        const SizedBox(height: 24.0),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            for (final (index, lvl) in state.stage.levels.indexed)
              _LevelChip(
                number: index + 1,
                isCurrent: index == state.levelIndex,
                rank: progress.levelScore(state.stage, index) > 0
                    ? learnLevelRank(lvl, progress.levelScore(state.stage, index))
                    : null,
                onTap: () => controller.goToLevel(index),
              ),
          ],
        ),
      ],
    );
  }

  bool _isPawnAboutToPromote(LearnLevelState level) {
    final color = level.level.color;
    final seventh = SquareSet.fromRank(color == Side.white ? Rank.seventh : Rank.second);
    return level.position.board.piecesOf(color, Role.pawn).isIntersected(seventh);
  }
}

String _congrats(AppLocalizations l10n, int levelIndex) {
  final messages = [
    l10n.learnAwesome,
    l10n.learnExcellent,
    l10n.learnGreatJob,
    l10n.learnPerfect,
    l10n.learnOutstanding,
    l10n.learnWayToGo,
    l10n.learnYesYesYes,
    l10n.learnYoureGoodAtThis,
    l10n.learnNailedIt,
    l10n.learnRightOn,
  ];
  return messages[levelIndex % messages.length];
}

/// A level of the stage, with its stars once completed.
class const _LevelChip({
  required final int number,
  required final bool isCurrent,
  required final LearnRank? rank,
  required final VoidCallback onTap,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    return Material(
      color: isCurrent
          ? colorScheme.primaryContainer
          : rank != null
          ? colorScheme.secondaryContainer
          : colorScheme.surfaceContainerHighest,
      shape: const StadiumBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 44.0, minHeight: 36.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Center(
              widthFactor: 1.0,
              child: switch (rank) {
                final rank? => LearnStars(rank: rank, size: 14.0),
                null => Text('$number'),
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// A scrim covering the screen, with a card in the middle.
class const _Overlay({required final Widget child, final VoidCallback? onDismiss})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: onDismiss,
        child: ColoredBox(
          color: Colors.black54,
          child: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500.0),
                child: Padding(
                  padding: Styles.bodyPadding,
                  child: GestureDetector(
                    onTap: () {},
                    child: Card(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24.0),
                        child: child,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class const _StageIntro({required final LearnStage stage, required final VoidCallback onStart})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${l10n.learnStageX('${learnStages.indexOf(stage) + 1}')}: ${stage.title(l10n)}',
          style: Styles.title,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16.0),
        LearnStageIcon(stage: stage, size: 80.0),
        const SizedBox(height: 16.0),
        Text(stage.intro(l10n), textAlign: TextAlign.center),
        const SizedBox(height: 24.0),
        FilledButton(onPressed: onStart, child: Text(l10n.learnLetsGo)),
      ],
    );
  }
}

class const _StageComplete({required final LearnStage stage}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final progress = ref.watch(learnProgressProvider).value ?? LearnProgress.empty;
    final stageIndex = learnStages.indexOf(stage);
    final next = stageIndex + 1 < learnStages.length ? learnStages[stageIndex + 1] : null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LearnStars(rank: learnStageRank(stage, progress.stageScores(stage)), size: 48.0),
        const SizedBox(height: 16.0),
        Text(l10n.learnStageXComplete('${stageIndex + 1}'), style: Styles.title),
        const SizedBox(height: 8.0),
        Text(l10n.yourScore('${progress.stageScore(stage)}')),
        const SizedBox(height: 16.0),
        Text(stage.complete(l10n), textAlign: TextAlign.center),
        const SizedBox(height: 24.0),
        if (next != null)
          FilledButton.icon(
            onPressed: () =>
                Navigator.of(context).pushReplacement(LearnStageScreen.buildRoute(next)),
            icon: const Icon(Icons.chevron_right),
            iconAlignment: IconAlignment.end,
            label: Text(l10n.learnNextX(next.title(l10n))),
          ),
        const SizedBox(height: 8.0),
        OutlinedButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.chevron_left),
          label: Text(l10n.learnBackToMenu),
        ),
      ],
    );
  }
}
