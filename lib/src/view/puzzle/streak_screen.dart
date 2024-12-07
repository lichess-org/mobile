import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_controller.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_streak.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/immersive_mode.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/settings/toggle_sound_button.dart';
import 'package:lichess_mobile/src/widgets/board_table.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar_button.dart';
import 'package:lichess_mobile/src/widgets/platform_alert_dialog.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';
import 'package:lichess_mobile/src/widgets/yes_no_dialog.dart';
import 'package:result_extensions/result_extensions.dart';

import 'puzzle_feedback_widget.dart';

class StreakScreen extends StatelessWidget {
  const StreakScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const WakelockWidget(
      child: PlatformScaffold(
        appBar: PlatformAppBar(
          actions: [ToggleSoundButton()],
          title: Text('Puzzle Streak'),
        ),
        body: _Load(),
      ),
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
          streak: data.streak,
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
            fen: kEmptyFen,
            orientation: Side.white,
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
    final ctrlProvider =
        puzzleControllerProvider(initialPuzzleContext, initialStreak: streak);
    final puzzleState = ref.watch(ctrlProvider);

    ref.listen<bool>(ctrlProvider.select((s) => s.nextPuzzleStreakFetchError),
        (_, shouldShowDialog) {
      if (shouldShowDialog) {
        showAdaptiveDialog<void>(
          context: context,
          builder: (context) => _RetryFetchPuzzleDialog(
            initialPuzzleContext: initialPuzzleContext,
            streak: streak,
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
                orientation: puzzleState.pov,
                fen: puzzleState.fen,
                lastMove: puzzleState.lastMove as NormalMove?,
                gameData: GameData(
                  playerSide: puzzleState.mode == PuzzleMode.load ||
                          puzzleState.position.isGameOver
                      ? PlayerSide.none
                      : puzzleState.mode == PuzzleMode.view
                          ? PlayerSide.both
                          : puzzleState.pov == Side.white
                              ? PlayerSide.white
                              : PlayerSide.black,
                  isCheck: puzzleState.position.isCheck,
                  sideToMove: puzzleState.position.turn,
                  validMoves: puzzleState.validMoves,
                  promotionMove: puzzleState.promotionMove,
                  onMove: (move, {isDrop, captured}) {
                    ref.read(ctrlProvider.notifier).onUserMove(move);
                  },
                  onPromotionSelection: (role) {
                    ref.read(ctrlProvider.notifier).onPromotionSelection(role);
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
          streak: streak,
        ),
      ],
    );

    return PopScope(
      canPop: puzzleState.streak!.index == 0 || puzzleState.streak!.finished,
      onPopInvokedWithResult: (bool didPop, _) async {
        if (didPop) {
          return;
        }
        final NavigatorState navigator = Navigator.of(context);
        final shouldPop = await showAdaptiveDialog<bool>(
          context: context,
          builder: (context) => YesNoDialog(
            title: Text(context.l10n.mobileAreYouSure),
            content:
                const Text('No worries, your score will be saved locally.'),
            onYes: () {
              ref.read(ctrlProvider.notifier).saveStreakResultLocally();
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
    required this.streak,
  });

  final PuzzleContext initialPuzzleContext;
  final PuzzleStreak streak;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider =
        puzzleControllerProvider(initialPuzzleContext, initialStreak: streak);
    final puzzleState = ref.watch(ctrlProvider);

    return BottomBar(
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
          BottomBarButton(
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
        if (puzzleState.streak!.finished)
          BottomBarButton(
            onTap: () {
              pushPlatformRoute(
                context,
                builder: (context) => AnalysisScreen(
                  options: AnalysisOptions(
                    orientation: puzzleState.pov,
                    standalone: (
                      pgn: ref.read(ctrlProvider.notifier).makePgn(),
                      isComputerAnalysisAllowed: true,
                      variant: Variant.standard,
                    ),
                    initialMoveCursor: 0,
                  ),
                ),
              );
            },
            label: context.l10n.analysis,
            icon: Icons.biotech,
          ),
        if (puzzleState.streak!.finished)
          BottomBarButton(
            onTap: puzzleState.canGoBack
                ? () => ref.read(ctrlProvider.notifier).userPrevious()
                : null,
            label: 'Previous',
            icon: CupertinoIcons.chevron_back,
          ),
        if (puzzleState.streak!.finished)
          BottomBarButton(
            onTap: puzzleState.canGoNext
                ? () => ref.read(ctrlProvider.notifier).userNext()
                : null,
            label: context.l10n.next,
            icon: CupertinoIcons.chevron_forward,
          ),
        if (puzzleState.streak!.finished)
          BottomBarButton(
            onTap: ref.read(streakProvider).isLoading == false
                ? () => ref.invalidate(streakProvider)
                : null,
            highlighted: true,
            label: context.l10n.puzzleNewStreak,
            icon: CupertinoIcons.play_arrow_solid,
          ),
      ],
    );
  }

  Future<void> _streakInfoDialogBuilder(BuildContext context) {
    return showAdaptiveDialog(
      context: context,
      builder: (context) => PlatformAlertDialog(
        title: Text(context.l10n.aboutX('Puzzle Streak')),
        content: Text(context.l10n.puzzleStreakDescription),
        actions: [
          PlatformDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.mobileOkButton),
          ),
        ],
      ),
    );
  }
}

class _RetryFetchPuzzleDialog extends ConsumerWidget {
  const _RetryFetchPuzzleDialog({
    required this.initialPuzzleContext,
    required this.streak,
  });

  final PuzzleContext initialPuzzleContext;
  final PuzzleStreak streak;

  static const title = 'Could not fetch the puzzle';
  static const content = 'Please check your internet connection and try again.';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider =
        puzzleControllerProvider(initialPuzzleContext, initialStreak: streak);
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
            ref.read(ctrlProvider.notifier).loadPuzzle(
                  data,
                  nextStreak:
                      state.streak!.copyWith(index: state.streak!.index + 1),
                );
          }
        },
      );
    }

    final canRetry = state.nextPuzzleStreakFetchError &&
        !state.nextPuzzleStreakFetchIsRetrying;

    return PlatformAlertDialog(
      title: const Text(title),
      content: const Text(content),
      actions: [
        PlatformDialogAction(
          onPressed: () => Navigator.of(context).pop(),
          cupertinoIsDestructiveAction: true,
          child: Text(context.l10n.cancel),
        ),
        PlatformDialogAction(
          onPressed: canRetry ? retryStreakNext : null,
          cupertinoIsDefaultAction: true,
          child: Text(context.l10n.retry),
        ),
      ],
    );
  }
}
