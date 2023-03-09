import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chessground/chessground.dart' as cg;
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/common/lichess_colors.dart';
import 'package:lichess_mobile/src/common/styles.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/table_board_layout.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_difficulty.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_preferences.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';

import 'puzzle_screen_state.dart';
import 'puzzle_difficulty_controller.dart';

class PuzzlesScreen extends StatelessWidget {
  const PuzzlesScreen({
    required this.theme,
    this.userId,
    this.puzzle,
    this.isDailyPuzzle = false,
    super.key,
  });

  final UserId? userId;
  final Puzzle? puzzle;
  final PuzzleTheme theme;
  final bool isDailyPuzzle;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [ToggleSoundButton()],
        title: isDailyPuzzle
            ? const Text('Daily Puzzle')
            : Text(puzzleThemeL10n(context, theme).name),
      ),
      body: puzzle != null
          ? _Body(
              userId: userId,
              puzzle: puzzle!,
              theme: theme,
              isDailyPuzzle: isDailyPuzzle,
            )
          : _LoadPuzzle(theme: theme),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: isDailyPuzzle
            ? const Text('Daily Puzzle')
            : Text(puzzleThemeL10n(context, theme).name),
        trailing: ToggleSoundButton(),
      ),
      child: puzzle != null
          ? _Body(
              userId: userId,
              puzzle: puzzle!,
              theme: theme,
              isDailyPuzzle: isDailyPuzzle,
            )
          : _LoadPuzzle(theme: theme),
    );
  }
}

class _LoadPuzzle extends ConsumerWidget {
  const _LoadPuzzle({required this.theme});

  final PuzzleTheme theme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nextPuzzle = ref.watch(nextPuzzleProvider(theme));

    return nextPuzzle.when(
      data: (data) {
        if (data.item2 == null) {
          return const Center(
            child: TableBoardLayout(
              topTable: kEmptyWidget,
              bottomTable: kEmptyWidget,
              boardData: cg.BoardData(
                fen: kEmptyFen,
                interactableSide: cg.InteractableSide.none,
                orientation: cg.Side.white,
              ),
              errorMessage: 'No more puzzles. Go online to get more.',
            ),
          );
        } else {
          return _Body(
            puzzle: data.item2!,
            userId: data.item1,
            theme: theme,
            isDailyPuzzle: false,
          );
        }
      },
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (e, s) {
        debugPrint(
          'SEVERE: [PuzzleScreen] could not load next puzzle; $e\n$s',
        );
        return Center(
          child: TableBoardLayout(
            topTable: kEmptyWidget,
            bottomTable: kEmptyWidget,
            boardData: const cg.BoardData(
              fen: kEmptyFen,
              interactableSide: cg.InteractableSide.none,
              orientation: cg.Side.white,
            ),
            errorMessage: e.toString(),
          ),
        );
      },
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({
    required this.puzzle,
    required this.userId,
    required this.theme,
    required this.isDailyPuzzle,
  });

  final Puzzle puzzle;
  final PuzzleTheme theme;
  final UserId? userId;
  final bool isDailyPuzzle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pieceSet =
        ref.watch(boardPrefsStateProvider.select((p) => p.pieceSet));
    final puzzleStateProvider =
        puzzleScreenStateProvider(userId, theme, puzzle);
    final puzzleState = ref.watch(puzzleStateProvider);
    return Column(
      children: [
        Expanded(
          child: Center(
            child: SafeArea(
              child: TableBoardLayout(
                boardData: cg.BoardData(
                  orientation: puzzleState.pov.cg,
                  interactableSide: puzzleState.mode == PuzzleMode.view
                      ? cg.InteractableSide.both
                      : puzzleState.pov == Side.white
                          ? cg.InteractableSide.white
                          : cg.InteractableSide.black,
                  fen: puzzleState.fen,
                  lastMove: puzzleState.lastMove?.cg,
                  sideToMove: puzzleState.position.turn.cg,
                  validMoves: puzzleState.validMoves,
                  onMove: (move, {isPremove}) {
                    ref
                        .read(puzzleStateProvider.notifier)
                        .playUserMove(Move.fromUci(move.uci)!);
                  },
                ),
                topTable: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: _Feedback(
                    puzzle: puzzle,
                    state: puzzleState,
                    pieceSet: pieceSet,
                  ),
                ),
                bottomTable: const SizedBox.shrink(),
              ),
            ),
          ),
        ),
        _BottomBar(
          puzzle: puzzle,
          userId: userId,
          theme: theme,
          isDailyPuzzle: isDailyPuzzle,
        ),
      ],
    );
  }
}

class _Feedback extends StatelessWidget {
  const _Feedback({
    required this.puzzle,
    required this.state,
    required this.pieceSet,
  });

  final Puzzle puzzle;
  final PuzzleVm state;
  final cg.PieceSet pieceSet;

  @override
  Widget build(BuildContext context) {
    switch (state.mode) {
      case PuzzleMode.view:
        final puzzleRating =
            context.l10n.ratingX(puzzle.puzzle.rating.toString());
        final playedXTimes = context.l10n.playedXTimes(puzzle.puzzle.plays);
        return PlatformCard(
          child: ListTile(
            leading: state.result == PuzzleResult.win
                ? const Icon(Icons.check, size: 36, color: LichessColors.good)
                : null,
            title: Text(
              state.result == PuzzleResult.win
                  ? context.l10n.puzzleSuccess
                  : context.l10n.puzzleComplete,
            ),
            subtitle: Text('$puzzleRating. $playedXTimes.'),
          ),
        );
      case PuzzleMode.play:
        if (state.feedback == PuzzleFeedback.bad) {
          return PlatformCard(
            child: ListTile(
              leading: const Icon(
                Icons.close,
                size: 36,
                color: LichessColors.error,
              ),
              title: Text(context.l10n.notTheMove),
              subtitle: Text(context.l10n.trySomethingElse),
            ),
          );
        } else if (state.feedback == PuzzleFeedback.good) {
          return PlatformCard(
            child: ListTile(
              leading:
                  const Icon(Icons.check, size: 36, color: LichessColors.good),
              title: Text(context.l10n.bestMove),
              subtitle: Text(context.l10n.keepGoing),
            ),
          );
        } else {
          return PlatformCard(
            child: ListTile(
              leading: Image(
                image: pieceSet.assets[state.pov == Side.white
                    ? cg.PieceKind.whiteKing
                    : cg.PieceKind.blackKing]!,
                height: 56,
              ),
              title: Text(context.l10n.yourTurn),
              subtitle: Text(
                state.pov == Side.white
                    ? context.l10n.findTheBestMoveForWhite
                    : context.l10n.findTheBestMoveForBlack,
              ),
            ),
          );
        }
    }
  }
}

void _goToNextPuzzle(
  BuildContext context,
  WidgetRef ref,
  PuzzleTheme theme,
  UserId? userId,
  Puzzle nextPuzzle,
) {
  ref.invalidate(nextPuzzleProvider(theme));
  Navigator.of(context).pushReplacement(
    PageRouteBuilder<void>(
      pageBuilder: (context, _, __) => PuzzlesScreen(
        theme: theme,
        userId: userId,
        puzzle: nextPuzzle,
      ),
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    ),
  );
}

class _BottomBar extends ConsumerWidget {
  const _BottomBar({
    required this.puzzle,
    required this.theme,
    required this.userId,
    required this.isDailyPuzzle,
  });

  final Puzzle puzzle;
  final PuzzleTheme theme;
  final UserId? userId;
  final bool isDailyPuzzle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puzzleStateProvider =
        puzzleScreenStateProvider(userId, theme, puzzle);
    final puzzleState = ref.watch(puzzleStateProvider);

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
            if (userId != null &&
                !isDailyPuzzle &&
                puzzleState.mode != PuzzleMode.view)
              _DifficultySelector(theme: theme, userId: userId),
            if (puzzleState.mode == PuzzleMode.view)
              _BottomBarButton(
                onTap: puzzleState.mode == PuzzleMode.view &&
                        puzzleState.nextPuzzle != null
                    ? () {
                        _goToNextPuzzle(
                          context,
                          ref,
                          theme,
                          userId,
                          puzzleState.nextPuzzle!,
                        );
                      }
                    : null,
                highlighted: puzzleState.mode == PuzzleMode.view,
                label: context.l10n.continueTraining,
                shortLabel: 'Continue',
                icon: CupertinoIcons.play_arrow_solid,
              ),
            if (puzzleState.mode != PuzzleMode.view)
              _BottomBarButton(
                icon: Icons.help,
                label: context.l10n.viewTheSolution,
                shortLabel: context.l10n.solution,
                showAndroidShortLabel: true,
                onTap: puzzleState.mode == PuzzleMode.view
                    ? null
                    : () =>
                        ref.read(puzzleStateProvider.notifier).viewSolution(),
              ),
            if (puzzleState.mode == PuzzleMode.view)
              _BottomBarButton(
                onTap: puzzleState.canGoBack
                    ? () =>
                        ref.read(puzzleStateProvider.notifier).userPrevious()
                    : null,
                label: 'Previous',
                shortLabel: 'Previous',
                icon: CupertinoIcons.chevron_back,
              ),
            if (puzzleState.mode == PuzzleMode.view)
              _BottomBarButton(
                onTap: puzzleState.canGoNext
                    ? () => ref.read(puzzleStateProvider.notifier).userNext()
                    : null,
                label: context.l10n.next,
                shortLabel: context.l10n.next,
                icon: CupertinoIcons.chevron_forward,
              ),
          ],
        ),
      ),
    );
  }
}

class _DifficultySelector extends ConsumerWidget {
  const _DifficultySelector({
    required this.userId,
    required this.theme,
  });

  final UserId? userId;
  final PuzzleTheme theme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final difficulty = ref.watch(
      puzzlePrefsStateProvider(userId).select((state) => state.difficulty),
    );
    final difficultyController = ref.watch(puzzleDifficultyControllerProvider);
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        PuzzleDifficulty selectedDifficulty = difficulty;
        return _BottomBarButton(
          icon: Icons.tune,
          label: context.l10n.difficultyLevel,
          shortLabel: puzzleDifficultyL10n(context, difficulty),
          showAndroidShortLabel: true,
          onTap: difficultyController.isLoading
              ? null
              : () {
                  showChoicesPicker(
                    context,
                    choices: PuzzleDifficulty.values,
                    selectedItem: difficulty,
                    labelBuilder: (t) => Text(puzzleDifficultyL10n(context, t)),
                    onSelectedItemChanged: (PuzzleDifficulty? d) {
                      if (d != null) {
                        setState(() {
                          selectedDifficulty = d;
                        });
                      }
                    },
                  ).then(
                    (_) async {
                      if (selectedDifficulty == difficulty) {
                        return;
                      }
                      final nextPuzzle = await ref
                          .read(
                            puzzleDifficultyControllerProvider.notifier,
                          )
                          .changeDifficulty(
                            userId,
                            theme,
                            selectedDifficulty,
                          );
                      if (context.mounted && nextPuzzle != null) {
                        _goToNextPuzzle(
                          context,
                          ref,
                          theme,
                          userId,
                          nextPuzzle,
                        );
                      }
                    },
                  );
                },
        );
      },
    );
  }
}

class _BottomBarButton extends StatelessWidget {
  const _BottomBarButton({
    required this.icon,
    required this.label,
    required this.shortLabel,
    required this.onTap,
    this.highlighted = false,
    this.showAndroidShortLabel = false,
  });

  final IconData icon;
  final String label;
  final String shortLabel;
  final VoidCallback? onTap;
  final bool highlighted;
  final bool showAndroidShortLabel;

  bool get enabled => onTap != null;

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        final themeData = Theme.of(context);
        return Theme(
          data: themeData,
          child: SizedBox(
            height: 50,
            child: showAndroidShortLabel
                ? TextButton.icon(
                    onPressed: onTap,
                    icon: Icon(icon),
                    label: Text(shortLabel),
                    style: TextButton.styleFrom(
                      foregroundColor: themeData.colorScheme.onBackground,
                    ),
                  )
                : IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: onTap,
                    icon: Icon(icon),
                    tooltip: label,
                  ),
          ),
        );
      case TargetPlatform.iOS:
        final themeData = CupertinoTheme.of(context);
        final hightlightedColor = themeData.primaryColor;
        return CupertinoTheme(
          data: themeData.copyWith(
            primaryColor: themeData.textTheme.textStyle.color,
          ),
          child: SizedBox(
            height: 50,
            child: Tooltip(
              message: label,
              triggerMode: TooltipTriggerMode.longPress,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: onTap,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(icon, color: highlighted ? hightlightedColor : null),
                    Text(
                      shortLabel,
                      style: TextStyle(
                        fontSize: 11,
                        color: highlighted ? hightlightedColor : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      default:
        assert(false, 'Unexpected platform $defaultTargetPlatform');
        return const SizedBox.shrink();
    }
  }
}
