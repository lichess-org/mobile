import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chessground/chessground.dart' as cg;
import 'package:dartchess/dartchess.dart';
import 'package:share_plus/share_plus.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/common/styles.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/table_board_layout.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';

import 'puzzle_view_model.dart';
import 'puzzle_feedback_widget.dart';
import 'puzzle_session_widget.dart';

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
            puzzle: data.puzzle,
            theme: PuzzleTheme.mix,
            userId: null,
          ),
          streak: data.streak,
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
    required this.streak,
  });

  final PuzzleContext initialPuzzleContext;
  final PuzzleStreak streak;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pieceSet =
        ref.watch(boardPreferencesProvider.select((p) => p.pieceSet));
    final viewModelProvider =
        puzzleViewModelProvider(initialPuzzleContext, streak: streak);
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
