import 'package:chessground/chessground.dart' as cg;
import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_controller.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_streak.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/utils/immersive_mode.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/settings/toggle_sound_button.dart';
import 'package:lichess_mobile/src/widgets/board_table.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar_button.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/yes_no_dialog.dart';
import 'package:result_extensions/result_extensions.dart';

import 'puzzle_feedback_widget.dart';

class StreakScreen extends StatelessWidget {
  const StreakScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WakelockWidget(
      child: PlatformWidget(
        androidBuilder: _androidBuilder,
        iosBuilder: _iosBuilder,
      ),
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
        backgroundColor: Styles.cupertinoScaffoldColor.resolveFrom(context),
        border: null,
        padding: Styles.cupertinoAppBarTrailingWidgetPadding,
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
            angle: const PuzzleTheme(PuzzleThemeKey.mix),
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
          'SEVERE: [StreakScreen] could not load streak; $e\n$s',
        );
        return Center(
          child: BoardTable(
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
    final ctrlProvider = puzzleControllerProvider(
      initialPuzzleContext,
      initialStreak: streak,
    );
    final puzzleState = ref.watch(ctrlProvider);

    ref.listen<bool>(ctrlProvider.select((s) => s.nextPuzzleStreakFetchError),
        (_, shouldShowDialog) {
      if (shouldShowDialog) {
        showAdaptiveDialog<void>(
          context: context,
          builder: (context) => _RetryFetchPuzzleDialog(
            ctrlProvider: ctrlProvider,
          ),
        );
      }
    });

    final content = Column(
      children: [
        Expanded(
          child: Center(
            child: SafeArea(
              child: BoardTable(
                onMove: (move, {isDrop, isPremove}) {
                  ref
                      .read(ctrlProvider.notifier)
                      .onUserMove(Move.fromUci(move.uci)!);
                },
                boardData: cg.BoardData(
                  orientation: puzzleState.pov.cg,
                  interactableSide: puzzleState.mode == PuzzleMode.load ||
                          puzzleState.position.isGameOver
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
                ),
                topTable: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    child: PuzzleFeedbackWidget(
                      puzzle: puzzleState.puzzle,
                      state: puzzleState,
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
                          Icon(
                            LichessIcons.streak,
                            size: 40.0,
                            color: context.lichessColors.brag,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            puzzleState.streak!.index.toString(),
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              color: context.lichessColors.brag,
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
          ctrlProvider: ctrlProvider,
        ),
      ],
    );

    return PopScope(
      canPop: puzzleState.streak!.index == 0 || puzzleState.streak!.finished,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
        final NavigatorState navigator = Navigator.of(context);
        final shouldPop = await showAdaptiveDialog<bool>(
          context: context,
          builder: (context) => YesNoDialog(
            title: const Text('Are you sure?'),
            content: const Text(
              'You will lose your current streak and your score will be saved.',
            ),
            onYes: () {
              ref.read(ctrlProvider.notifier).sendStreakResult();
              return Navigator.of(context).pop(true);
            },
            onNo: () => Navigator.of(context).pop(false),
          ),
        );
        if (shouldPop ?? false) {
          navigator.pop();
        }
      },
      child: content,
    );
  }
}

class _BottomBar extends ConsumerWidget {
  const _BottomBar({
    required this.initialPuzzleContext,
    required this.ctrlProvider,
  });

  final PuzzleContext initialPuzzleContext;
  final PuzzleControllerProvider ctrlProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puzzleState = ref.watch(ctrlProvider);

    return Container(
      color: Theme.of(context).platform == TargetPlatform.iOS
          ? null
          : Theme.of(context).bottomAppBarTheme.color,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: kBottomBarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (!puzzleState.streak!.finished)
                BottomBarButton(
                  icon: Icons.info_outline,
                  label: context.l10n.aboutX('Streak'),
                  showLabel: true,
                  onTap: () => _streakInfoDialogBuilder(context),
                ),
              if (!puzzleState.streak!.finished)
                BottomBarButton(
                  icon: Icons.skip_next,
                  label: context.l10n.skipThisMove,
                  showLabel: true,
                  onTap: puzzleState.streak!.hasSkipped ||
                          puzzleState.mode == PuzzleMode.view
                      ? null
                      : () => ref.read(ctrlProvider.notifier).skipMove(),
                ),
              if (puzzleState.streak!.finished)
                Expanded(
                  child: BottomBarButton(
                    onTap: () {
                      launchShareDialog(
                        context,
                        text: lichessUri(
                          '/training/${puzzleState.puzzle.puzzle.id}',
                        ).toString(),
                      );
                    },
                    label: 'Share this puzzle',
                    icon: Theme.of(context).platform == TargetPlatform.iOS
                        ? CupertinoIcons.share
                        : Icons.share,
                  ),
                ),
              if (puzzleState.streak!.finished)
                Expanded(
                  child: BottomBarButton(
                    onTap: () {
                      pushPlatformRoute(
                        context,
                        builder: (context) => AnalysisScreen(
                          title: context.l10n.analysis,
                          pgnOrId: ref.read(ctrlProvider.notifier).makePgn(),
                          options: AnalysisOptions(
                            isLocalEvaluationAllowed: true,
                            variant: Variant.standard,
                            orientation: puzzleState.pov,
                            id: standaloneAnalysisId,
                            initialMoveCursor: 0,
                          ),
                        ),
                      );
                    },
                    label: context.l10n.analysis,
                    icon: Icons.biotech,
                  ),
                ),
              if (puzzleState.streak!.finished)
                Expanded(
                  child: BottomBarButton(
                    onTap: puzzleState.canGoBack
                        ? () => ref.read(ctrlProvider.notifier).userPrevious()
                        : null,
                    label: 'Previous',
                    icon: CupertinoIcons.chevron_back,
                  ),
                ),
              if (puzzleState.streak!.finished)
                Expanded(
                  child: BottomBarButton(
                    onTap: puzzleState.canGoNext
                        ? () => ref.read(ctrlProvider.notifier).userNext()
                        : null,
                    label: context.l10n.next,
                    icon: CupertinoIcons.chevron_forward,
                  ),
                ),
              if (puzzleState.streak!.finished)
                Expanded(
                  child: BottomBarButton(
                    onTap: ref.read(streakProvider).isLoading == false
                        ? () => ref.invalidate(streakProvider)
                        : null,
                    highlighted: true,
                    label: context.l10n.puzzleNewStreak,
                    icon: CupertinoIcons.play_arrow_solid,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _streakInfoDialogBuilder(BuildContext context) {
    return showAdaptiveDialog(
      context: context,
      builder: (context) {
        return Theme.of(context).platform == TargetPlatform.iOS
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
    required this.ctrlProvider,
  });

  final PuzzleControllerProvider ctrlProvider;

  static const title = 'Could not fetch the puzzle';
  static const content = 'Please check your internet connection and try again.';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ctrlProvider);

    Future<void> retryStreakNext() async {
      final result = await ref
          .read(ctrlProvider.notifier)
          .retryFetchNextStreakPuzzle(state.streak!);
      result.match(
        onSuccess: (data) {
          if (context.mounted) {
            Navigator.of(context).pop();
          }
          if (data != null) {
            ref.read(ctrlProvider.notifier).loadPuzzle(data);
          }
        },
      );
    }

    final canRetry = state.nextPuzzleStreakFetchError &&
        !state.nextPuzzleStreakFetchIsRetrying;

    if (Theme.of(context).platform == TargetPlatform.iOS) {
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
