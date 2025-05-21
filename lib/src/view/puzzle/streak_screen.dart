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
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_streak.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/utils/immersive_mode.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_feedback_widget.dart';
import 'package:lichess_mobile/src/view/settings/toggle_sound_button.dart';
import 'package:lichess_mobile/src/widgets/board_table.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/platform_alert_dialog.dart';
import 'package:lichess_mobile/src/widgets/yes_no_dialog.dart';
import 'package:share_plus/share_plus.dart';

class StreakScreen extends StatelessWidget {
  const StreakScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const StreakScreen());
  }

  @override
  Widget build(BuildContext context) {
    return WakelockWidget(
      child: Scaffold(
        appBar: AppBar(actions: const [ToggleSoundButton()], title: const Text('Puzzle Streak')),
        body: const _Load(),
      ),
    );
  }
}

class _Load extends ConsumerWidget {
  const _Load();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionProvider);
    final streak = ref.watch(puzzleStreakControllerProvider);

    switch (streak) {
      case AsyncValue(:final error?, :final stackTrace):
        debugPrint('SEVERE: [StreakScreen] could not load streak; $error\n$stackTrace');
        return Center(
          child: BoardTable(
            topTable: kEmptyWidget,
            bottomTable: kEmptyWidget,
            fen: kEmptyFen,
            orientation: Side.white,
            errorMessage: error.toString(),
          ),
        );
      case AsyncValue(:final value?):
        return _Body(
          initialPuzzleContext: PuzzleContext(
            puzzle: value.puzzle,
            angle: const PuzzleTheme(PuzzleThemeKey.mix),
            userId: session?.user.id,
          ),
          streak: value.streak,
        );
      case _:
        return const Center(child: CircularProgressIndicator.adaptive());
    }
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.initialPuzzleContext, required this.streak});

  final PuzzleContext initialPuzzleContext;
  final PuzzleStreak streak;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = puzzleControllerProvider(initialPuzzleContext, isPuzzleStreak: true);
    final puzzleState = ref.watch(ctrlProvider);

    ref.listen(ctrlProvider, (previous, next) {
      if (previous?.result != PuzzleResult.lose && next.result == PuzzleResult.lose) {
        ref.read(puzzleStreakControllerProvider.notifier).gameOver();
      } else if (previous?.result != PuzzleResult.win && next.result == PuzzleResult.win) {
        ref.read(puzzleStreakControllerProvider.notifier).next();
      }
    });

    final content = Column(
      children: [
        Expanded(
          child: Center(
            child: SafeArea(
              child: BoardTable(
                orientation: puzzleState.pov,
                lastMove: puzzleState.lastMove as NormalMove?,
                interactiveBoardParams: (
                  variant: Variant.standard,
                  position: puzzleState.currentPosition,
                  playerSide:
                      puzzleState.mode == PuzzleMode.load || puzzleState.currentPosition.isGameOver
                      ? PlayerSide.none
                      : puzzleState.mode == PuzzleMode.view
                      ? PlayerSide.both
                      : puzzleState.pov == Side.white
                      ? PlayerSide.white
                      : PlayerSide.black,
                  promotionMove: puzzleState.promotionMove,
                  onMove: (move, {isDrop, captured}) {
                    ref.read(ctrlProvider.notifier).onUserMove(move);
                  },
                  onPromotionSelection: (role) {
                    ref.read(ctrlProvider.notifier).onPromotionSelection(role);
                  },
                  premovable: null,
                ),
                topTable: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: PuzzleFeedbackWidget(
                      puzzle: puzzleState.puzzle,
                      state: puzzleState,
                      onStreak: true,
                    ),
                  ),
                ),
                bottomTable: Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                LichessIcons.streak,
                                size: 50.0,
                                color: ColorScheme.of(context).primary,
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                streak.index.toString(),
                                style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                  color: ColorScheme.of(context).primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(context.l10n.puzzleRatingX(puzzleState.puzzle.puzzle.rating.toString())),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        _BottomBar(initialPuzzleContext: initialPuzzleContext, streak: streak),
      ],
    );

    return PopScope(
      canPop: streak.index == 0 || streak.finished,
      onPopInvokedWithResult: (bool didPop, _) async {
        if (didPop) {
          return;
        }
        final NavigatorState navigator = Navigator.of(context);
        final shouldPop = await showAdaptiveDialog<bool>(
          context: context,
          builder: (context) => YesNoDialog(
            title: Text(context.l10n.mobileAreYouSure),
            content: const Text('No worries, your score will be saved locally.'),
            onYes: () => Navigator.of(context).pop(true),
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
  const _BottomBar({required this.initialPuzzleContext, required this.streak});

  final PuzzleContext initialPuzzleContext;
  final PuzzleStreak streak;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = puzzleControllerProvider(initialPuzzleContext, isPuzzleStreak: true);
    final puzzleState = ref.watch(ctrlProvider);

    return BottomBar(
      children: [
        if (!streak.finished)
          BottomBarButton(
            icon: Icons.info_outline,
            label: context.l10n.aboutX('Streak'),
            showLabel: true,
            onTap: () => _streakInfoDialogBuilder(context),
          ),
        if (!streak.finished)
          BottomBarButton(
            icon: Icons.skip_next,
            label: context.l10n.skipThisMove,
            showLabel: true,
            onTap: streak.hasSkipped || puzzleState.mode == PuzzleMode.view
                ? null
                : () {
                    ref.read(ctrlProvider.notifier).skipMove();
                    ref.read(puzzleStreakControllerProvider.notifier).skipMove();
                  },
          ),
        if (streak.finished)
          BottomBarButton(
            onTap: () {
              launchShareDialog(
                context,
                ShareParams(
                  text: lichessUri('/training/${puzzleState.puzzle.puzzle.id}').toString(),
                ),
              );
            },
            label: 'Share this puzzle',
            icon: Theme.of(context).platform == TargetPlatform.iOS ? Icons.ios_share : Icons.share,
          ),
        if (streak.finished)
          BottomBarButton(
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                AnalysisScreen.buildRoute(
                  context,
                  AnalysisOptions(
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
        if (streak.finished)
          BottomBarButton(
            onTap: puzzleState.canGoBack
                ? () => ref.read(ctrlProvider.notifier).userPrevious()
                : null,
            label: 'Previous',
            icon: CupertinoIcons.chevron_back,
          ),
        if (streak.finished)
          BottomBarButton(
            onTap: puzzleState.canGoNext ? () => ref.read(ctrlProvider.notifier).userNext() : null,
            label: context.l10n.next,
            icon: CupertinoIcons.chevron_forward,
          ),
        if (streak.finished)
          BottomBarButton(
            onTap: ref.read(puzzleStreakControllerProvider).isLoading == false
                ? () => ref.invalidate(puzzleStreakControllerProvider)
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
      builder: (context) => AlertDialog.adaptive(
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
