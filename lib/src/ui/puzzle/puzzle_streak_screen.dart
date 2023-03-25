import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chessground/chessground.dart' as cg;
import 'package:dartchess/dartchess.dart';
import 'package:share_plus/share_plus.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/common/styles.dart';
import 'package:lichess_mobile/src/common/connectivity.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/table_board_layout.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_difficulty.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_preferences.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';

import 'puzzle_view_model.dart';
import 'puzzle_feedback_widget.dart';
import 'puzzle_session_widget.dart';

class PuzzleStreakScreen extends StatelessWidget {
  const PuzzleStreakScreen({
    required this.theme,
    required this.initialPuzzleContext,
    super.key,
  });

  final PuzzleTheme theme;
  final PuzzleContext initialPuzzleContext;

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
        title: Text(puzzleThemeL10n(context, theme).name),
      ),
      body: _Body(
        initialPuzzleContext: initialPuzzleContext,
      ),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(puzzleThemeL10n(context, theme).name),
        trailing: ToggleSoundButton(),
      ),
      child: _Body(
        initialPuzzleContext: initialPuzzleContext,
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({
    required this.initialPuzzleContext,
  });

  final PuzzleContext initialPuzzleContext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pieceSet =
        ref.watch(boardPreferencesProvider.select((p) => p.pieceSet));
    final viewModelProvider = puzzleViewModelProvider(initialPuzzleContext);
    final puzzleState = ref.watch(viewModelProvider);
    return Column(
      children: [
        Expanded(
          child: Center(
            child: SafeArea(
              child: TableBoardLayout(
                boardData: cg.BoardData(
                  orientation: puzzleState.pov.cg,
                  interactableSide: puzzleState.position.isGameOver
                      ? cg.InteractableSide.none
                      : puzzleState.mode == PuzzleMode.view
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
                        .read(viewModelProvider.notifier)
                        .playUserMove(Move.fromUci(move.uci)!);
                  },
                ),
                topTable: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    child: PuzzleFeedbackWidget(
                      puzzle: puzzleState.puzzle,
                      state: puzzleState,
                      pieceSet: pieceSet,
                    ),
                  ),
                ),
                bottomTable: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (puzzleState.glicko != null)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                          left: 10.0,
                          right: 10.0,
                        ),
                        child: Row(
                          children: [
                            Text(context.l10n.rating),
                            const SizedBox(width: 5.0),
                            TweenAnimationBuilder<double>(
                              tween: Tween<double>(
                                begin: puzzleState.glicko!.rating,
                                end: puzzleState.nextContext?.glicko?.rating ??
                                    puzzleState.glicko!.rating,
                              ),
                              duration: const Duration(milliseconds: 500),
                              builder: (context, double rating, _) {
                                return Text(
                                  rating.truncate().toString(),
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    PuzzleSessionWidget(
                      initialPuzzleContext: initialPuzzleContext,
                      viewModelProvider: viewModelProvider,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        _BottomBar(
          initialPuzzleContext: initialPuzzleContext,
          viewModelProvider: viewModelProvider,
        ),
      ],
    );
  }
}

class _BottomBar extends ConsumerWidget {
  const _BottomBar({
    required this.initialPuzzleContext,
    required this.viewModelProvider,
  });

  final PuzzleContext initialPuzzleContext;
  final PuzzleViewModelProvider viewModelProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puzzleState = ref.watch(viewModelProvider);
    final isDailyPuzzle = puzzleState.puzzle.isDailyPuzzle == true;

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
            if (initialPuzzleContext.userId != null &&
                !isDailyPuzzle &&
                puzzleState.mode != PuzzleMode.view)
              _DifficultySelector(
                initialPuzzleContext: initialPuzzleContext,
                viewModelProvider: viewModelProvider,
              ),
            if (puzzleState.mode == PuzzleMode.view)
              BottomBarButton(
                onTap: () {
                  Share.share(
                    '$kLichessHost/training/${puzzleState.puzzle.puzzle.id}',
                  );
                },
                label: 'Share this puzzle',
                shortLabel: 'Share',
                icon: defaultTargetPlatform == TargetPlatform.iOS
                    ? CupertinoIcons.share
                    : Icons.share,
              ),
            if (puzzleState.mode != PuzzleMode.view)
              BottomBarButton(
                icon: Icons.help,
                label: context.l10n.viewTheSolution,
                shortLabel: context.l10n.solution,
                showAndroidShortLabel: true,
                onTap: puzzleState.mode == PuzzleMode.view
                    ? null
                    : () => ref.read(viewModelProvider.notifier).viewSolution(),
              ),
            if (puzzleState.mode == PuzzleMode.view)
              BottomBarButton(
                onTap: puzzleState.canGoBack
                    ? () => ref.read(viewModelProvider.notifier).userPrevious()
                    : null,
                label: 'Previous',
                shortLabel: 'Previous',
                icon: CupertinoIcons.chevron_back,
              ),
            if (puzzleState.mode == PuzzleMode.view)
              BottomBarButton(
                onTap: puzzleState.canGoNext
                    ? () => ref.read(viewModelProvider.notifier).userNext()
                    : null,
                label: context.l10n.next,
                shortLabel: context.l10n.next,
                icon: CupertinoIcons.chevron_forward,
              ),
            if (puzzleState.mode == PuzzleMode.view)
              BottomBarButton(
                onTap: puzzleState.mode == PuzzleMode.view &&
                        puzzleState.nextContext != null
                    ? () => ref
                        .read(viewModelProvider.notifier)
                        .continueWithNextPuzzle(puzzleState.nextContext!)
                    : null,
                highlighted: true,
                label: context.l10n.puzzleContinueTraining,
                shortLabel: 'Continue',
                icon: CupertinoIcons.play_arrow_solid,
              ),
          ],
        ),
      ),
    );
  }
}

class _DifficultySelector extends ConsumerWidget {
  const _DifficultySelector({
    required this.initialPuzzleContext,
    required this.viewModelProvider,
  });

  final PuzzleContext initialPuzzleContext;
  final PuzzleViewModelProvider viewModelProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final difficulty = ref.watch(
      puzzlePreferencesProvider(initialPuzzleContext.userId)
          .select((state) => state.difficulty),
    );
    final state = ref.watch(viewModelProvider);
    final connectivity = ref.watch(connectivityChangesProvider);
    return connectivity.when(
      data: (data) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          PuzzleDifficulty selectedDifficulty = difficulty;
          return BottomBarButton(
            icon: Icons.tune,
            label: context.l10n.puzzleDifficultyLevel,
            shortLabel: puzzleDifficultyL10n(context, difficulty),
            showAndroidShortLabel: true,
            onTap: !data.isOnline || state.isChangingDifficulty
                ? null
                : () {
                    showChoicesPicker(
                      context,
                      choices: PuzzleDifficulty.values,
                      selectedItem: difficulty,
                      labelBuilder: (t) =>
                          Text(puzzleDifficultyL10n(context, t)),
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
                        final nextContext = await ref
                            .read(viewModelProvider.notifier)
                            .changeDifficulty(selectedDifficulty);
                        if (context.mounted && nextContext != null) {
                          ref
                              .read(viewModelProvider.notifier)
                              .continueWithNextPuzzle(nextContext);
                        }
                      },
                    );
                  },
          );
        },
      ),
      loading: () => const ButtonLoadingIndicator(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
