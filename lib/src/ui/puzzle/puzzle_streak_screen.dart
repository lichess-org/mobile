import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chessground/chessground.dart' as cg;
import 'package:dartchess/dartchess.dart';
import 'package:share_plus/share_plus.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/common/styles.dart';
import 'package:lichess_mobile/src/common/lichess_icons.dart';
import 'package:lichess_mobile/src/common/lichess_colors.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/table_board_layout.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_streak.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';

import 'puzzle_view_model.dart';
import 'puzzle_feedback_widget.dart';

class PuzzleStreakScreen extends StatelessWidget {
  const PuzzleStreakScreen({super.key});

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
        title: const Text('Puzzle Streak'),
      ),
      body: const _Load(),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Puzzle Streak'),
        trailing: ToggleSoundButton(),
      ),
      child: const _Load(),
    );
  }
}

class _Load extends ConsumerWidget {
  const _Load();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(streakProvider);

    return streak.when(
      data: (data) {
        return _Body(
          initialPuzzleContext: PuzzleContext(
            puzzle: data.item2.puzzle,
            theme: PuzzleTheme.mix,
            userId: data.item1,
          ),
          streakData: data.item2,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (e, s) {
        debugPrint(
          'SEVERE: [PuzzleStreakScreen] could not load streak; $e\n$s',
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
    required this.initialPuzzleContext,
    required this.streakData,
  });

  final PuzzleContext initialPuzzleContext;
  final StreakData streakData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pieceSet =
        ref.watch(boardPreferencesProvider.select((p) => p.pieceSet));
    final viewModelProvider =
        puzzleViewModelProvider(initialPuzzleContext, streakData: streakData);
    final puzzleState = ref.watch(viewModelProvider);
    const streakColor = LichessColors.brag;
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
                      onStreak: true,
                    ),
                  ),
                ),
                bottomTable: Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    left: 10.0,
                    right: 10.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        LichessIcons.streak,
                        size: 40.0,
                        color: streakColor,
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        (puzzleState.streakIndex ?? 0).toString(),
                        style: const TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: streakColor,
                        ),
                      ),
                    ],
                  ),
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
                icon: Icons.skip_next,
                label: context.l10n.skipThisMove,
                shortLabel: 'Skip',
                showAndroidShortLabel: true,
                onTap: puzzleState.streakHasSkipped == true ||
                        puzzleState.mode == PuzzleMode.view
                    ? null
                    : () => ref.read(viewModelProvider.notifier).skipMove(),
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
              if (puzzleState.result == PuzzleResult.win)
                BottomBarButton(
                  onTap: puzzleState.mode == PuzzleMode.view &&
                          puzzleState.nextContext != null
                      ? () => ref
                          .read(viewModelProvider.notifier)
                          .continueWithNextPuzzle(puzzleState.nextContext!)
                      : null,
                  highlighted: true,
                  label: context.l10n.puzzleContinueTheStreak,
                  shortLabel: 'Continue',
                  icon: CupertinoIcons.play_arrow_solid,
                )
              else
                BottomBarButton(
                  onTap: ref.read(streakProvider).isLoading == false
                      ? () => ref.invalidate(streakProvider)
                      : null,
                  highlighted: true,
                  label: context.l10n.puzzleNewStreak,
                  shortLabel: 'New Streak',
                  icon: CupertinoIcons.play_arrow_solid,
                ),
          ],
        ),
      ),
    );
  }
}
