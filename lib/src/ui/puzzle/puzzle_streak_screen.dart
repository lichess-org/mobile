import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chessground/chessground.dart' as cg;
import 'package:dartchess/dartchess.dart';
import 'package:share_plus/share_plus.dart';
import 'package:result_extensions/result_extensions.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/widgets/adaptive_dialog.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/table_board_layout.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_streak.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/ui/settings/toggle_sound_button.dart';

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
    final session = ref.watch(authSessionProvider);

    return streak.when(
      data: (data) {
        return _Body(
          initialPuzzleContext: PuzzleContext(
            puzzle: data.puzzle,
            theme: PuzzleTheme.mix,
            userId: session?.user.id,
          ),
          streak: PuzzleStreak(
            streak: data.streak,
            index: 0,
            hasSkipped: false,
            finished: false,
          ),
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

  static const streakColor = LichessColors.brag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pieceSet =
        ref.watch(boardPreferencesProvider.select((p) => p.pieceSet));
    final viewModelProvider =
        puzzleViewModelProvider(initialPuzzleContext, initialStreak: streak);
    final puzzleState = ref.watch(viewModelProvider);

    ref.listen<bool>(
        viewModelProvider.select((s) => s.nextPuzzleStreakFetchError),
        (_, shouldShowDialog) {
      if (shouldShowDialog) {
        showAdaptiveDialog<void>(
          context: context,
          builder: (context) => _RetryFetchPuzzleDialog(
            viewModelProvider: viewModelProvider,
          ),
        );
      }
    });

    final content = Column(
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
                  isCheck: puzzleState.position.isCheck,
                  lastMove: puzzleState.lastMove?.cg,
                  sideToMove: puzzleState.position.turn.cg,
                  validMoves: puzzleState.validMoves,
                  onMove: (move, {isPremove}) {
                    ref
                        .read(viewModelProvider.notifier)
                        .onUserMove(Move.fromUci(move.uci)!);
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            LichessIcons.streak,
                            size: 40.0,
                            color: streakColor,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            (puzzleState.streak!.index).toString(),
                            style: const TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              color: streakColor,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        context.l10n.puzzleRatingX(
                          puzzleState.puzzle.puzzle.rating.toString(),
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

    return puzzleState.streak!.index == 0 || puzzleState.streak!.finished
        ? content
        : WillPopScope(
            onWillPop: () async {
              final result = await showAdaptiveDialog<bool>(
                context: context,
                builder: (context) => YesNoDialog(
                  title: const Text('Are you sure?'),
                  content: const Text(
                    'You will lose your current streak and your score will be saved.',
                  ),
                  onYes: () {
                    ref.read(viewModelProvider.notifier).sendStreakResult();
                    return Navigator.of(context).pop(true);
                  },
                  onNo: () => Navigator.of(context).pop(false),
                ),
              );
              return result ?? false;
            },
            child: content,
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
            if (!puzzleState.streak!.finished)
              BottomBarButton(
                icon: Icons.info_outline,
                label: context.l10n.aboutX('Streak'),
                shortLabel: context.l10n.about,
                showAndroidShortLabel: true,
                onTap: () => _streakInfoDialogBuilder(context),
              ),
            if (!puzzleState.streak!.finished)
              BottomBarButton(
                icon: Icons.skip_next,
                label: context.l10n.skipThisMove,
                shortLabel: 'Skip',
                showAndroidShortLabel: true,
                onTap: puzzleState.streak!.hasSkipped ||
                        puzzleState.mode == PuzzleMode.view
                    ? null
                    : () => ref.read(viewModelProvider.notifier).skipMove(),
              ),
            if (puzzleState.streak!.finished)
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
            if (puzzleState.streak!.finished)
              BottomBarButton(
                onTap: puzzleState.canGoBack
                    ? () => ref.read(viewModelProvider.notifier).userPrevious()
                    : null,
                label: 'Previous',
                shortLabel: 'Previous',
                icon: CupertinoIcons.chevron_back,
              ),
            if (puzzleState.streak!.finished)
              BottomBarButton(
                onTap: puzzleState.canGoNext
                    ? () => ref.read(viewModelProvider.notifier).userNext()
                    : null,
                label: context.l10n.next,
                shortLabel: context.l10n.next,
                icon: CupertinoIcons.chevron_forward,
              ),
            if (puzzleState.streak!.finished)
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

  Future<void> _streakInfoDialogBuilder(BuildContext context) {
    return showAdaptiveDialog(
      context: context,
      builder: (context) {
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoAlertDialog(
                title: Text(context.l10n.aboutX('Puzzle Streak')),
                content: Text(context.l10n.puzzleStreakDescription),
                actions: [
                  CupertinoDialogAction(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              )
            : AlertDialog(
                title: Text(context.l10n.aboutX('Puzzle Streak')),
                content: Text(context.l10n.puzzleStreakDescription),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              );
      },
    );
  }
}

class _RetryFetchPuzzleDialog extends ConsumerWidget {
  const _RetryFetchPuzzleDialog({
    required this.viewModelProvider,
  });

  final PuzzleViewModelProvider viewModelProvider;

  static const title = 'Could not fetch the puzzle';
  static const content = 'Please check your internet connection and try again.';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(viewModelProvider);

    Future<void> retryStreakNext() async {
      final result = await ref
          .read(viewModelProvider.notifier)
          .retryFetchNextStreakPuzzle(state.streak!);
      result.match(
        onSuccess: (data) {
          if (context.mounted) {
            Navigator.of(context).pop();
          }
          if (data != null) {
            ref.read(viewModelProvider.notifier).loadPuzzle(data);
          }
        },
      );
    }

    final canRetry = state.nextPuzzleStreakFetchError &&
        !state.nextPuzzleStreakFetchIsRetrying;

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoAlertDialog(
        title: const Text(title),
        content: const Text(content),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            isDestructiveAction: true,
            child: Text(context.l10n.cancel),
          ),
          CupertinoDialogAction(
            onPressed: canRetry ? retryStreakNext : null,
            isDefaultAction: true,
            child: Text(context.l10n.retry),
          ),
        ],
      );
    } else {
      return AlertDialog(
        title: const Text(title),
        content: const Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: canRetry ? retryStreakNext : null,
            child: Text(context.l10n.retry),
          ),
        ],
      );
    }
  }
}
