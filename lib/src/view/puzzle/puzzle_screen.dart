import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chessground/chessground.dart' as cg;
import 'package:dartchess/dartchess.dart';
import 'package:share_plus/share_plus.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/connectivity.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/board_table.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_controller.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_difficulty.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_preferences.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/model/engine/engine_evaluation.dart';
import 'package:lichess_mobile/src/utils/immersive_mode.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/utils/wakelock.dart';
import 'package:lichess_mobile/src/view/account/rating_pref_aware.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';
import 'package:lichess_mobile/src/view/settings/toggle_sound_button.dart';

import 'puzzle_feedback_widget.dart';
import 'puzzle_session_widget.dart';

class PuzzleScreen extends StatelessWidget {
  const PuzzleScreen({
    required this.theme,
    this.initialPuzzleContext,
    super.key,
  });

  final PuzzleTheme theme;
  final PuzzleContext? initialPuzzleContext;

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
        title: const Text('Puzzle training'),
      ),
      body: initialPuzzleContext != null
          ? _Body(
              initialPuzzleContext: initialPuzzleContext!,
            )
          : _LoadPuzzle(theme: theme),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Puzzle training'),
        trailing: ToggleSoundButton(),
      ),
      child: initialPuzzleContext != null
          ? _Body(
              initialPuzzleContext: initialPuzzleContext!,
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
        if (data == null) {
          return const Center(
            child: BoardTable(
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
            initialPuzzleContext: data,
          );
        }
      },
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (e, s) {
        debugPrint(
          'SEVERE: [PuzzleScreen] could not load next puzzle; $e\n$s',
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

class _Body extends ConsumerStatefulWidget {
  const _Body({
    required this.initialPuzzleContext,
  });

  final PuzzleContext initialPuzzleContext;

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body>
    with AndroidImmersiveMode, Wakelock {
  @override
  Widget build(BuildContext context) {
    final ctrlProvider = puzzleControllerProvider(widget.initialPuzzleContext);
    final puzzleState = ref.watch(ctrlProvider);

    final currentEvalBest = ref.watch(
      engineEvaluationProvider(puzzleState.evaluationContext)
          .select((e) => e?.bestMove),
    );
    final evalBestMove =
        (currentEvalBest ?? puzzleState.node.eval?.bestMove)?.cg;

    return Column(
      children: [
        Expanded(
          child: Center(
            child: SafeArea(
              bottom: false,
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
                  shapes: puzzleState.isEngineEnabled && evalBestMove != null
                      ? ISet([
                          cg.Arrow(
                            color: const Color(0x40003088),
                            orig: evalBestMove.from,
                            dest: evalBestMove.to,
                          ),
                        ])
                      : null,
                ),
                engineGauge: puzzleState.isEngineEnabled
                    ? EngineGaugeParams(
                        orientation: puzzleState.pov,
                        evaluationContext: puzzleState.evaluationContext,
                        position: puzzleState.position,
                        savedEval: puzzleState.node.eval,
                      )
                    : null,
                topTable: Center(
                  child: PuzzleFeedbackWidget(
                    puzzle: puzzleState.puzzle,
                    state: puzzleState,
                    onStreak: false,
                  ),
                ),
                bottomTable: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (puzzleState.glicko != null)
                      RatingPrefAware(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 10.0,
                          ),
                          child: Row(
                            children: [
                              Text(context.l10n.rating),
                              const SizedBox(width: 5.0),
                              TweenAnimationBuilder<double>(
                                tween: Tween<double>(
                                  begin: puzzleState.glicko!.rating,
                                  end:
                                      puzzleState.nextContext?.glicko?.rating ??
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
                      ),
                    PuzzleSessionWidget(
                      initialPuzzleContext: widget.initialPuzzleContext,
                      ctrlProvider: ctrlProvider,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        _BottomBar(
          initialPuzzleContext: widget.initialPuzzleContext,
          ctrlProvider: ctrlProvider,
        ),
      ],
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

  static const _repeatTriggerDelays = [
    Duration(milliseconds: 500),
    Duration(milliseconds: 250),
    Duration(milliseconds: 100),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puzzleState = ref.watch(ctrlProvider);
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
                ctrlProvider: ctrlProvider,
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
            if (puzzleState.mode == PuzzleMode.view)
              BottomBarButton(
                onTap: () {
                  ref.read(ctrlProvider.notifier).toggleLocalEvaluation();
                },
                label: context.l10n.toggleLocalEvaluation,
                shortLabel: 'Evaluation',
                icon: CupertinoIcons.gauge,
                highlighted: puzzleState.isLocalEvalEnabled,
              ),
            if (puzzleState.mode != PuzzleMode.view)
              BottomBarButton(
                icon: Icons.help,
                label: context.l10n.viewTheSolution,
                shortLabel: context.l10n.solution,
                showAndroidShortLabel: true,
                onTap: puzzleState.canViewSolution
                    ? () => ref.read(ctrlProvider.notifier).viewSolution()
                    : null,
              ),
            if (puzzleState.mode == PuzzleMode.view)
              RepeatButton(
                triggerDelays: _repeatTriggerDelays,
                onLongPress:
                    puzzleState.canGoBack ? () => _moveBackward(ref) : null,
                child: BottomBarButton(
                  onTap:
                      puzzleState.canGoBack ? () => _moveBackward(ref) : null,
                  label: 'Previous',
                  shortLabel: 'Previous',
                  icon: CupertinoIcons.chevron_back,
                  showAndroidTooltip: false,
                ),
              ),
            if (puzzleState.mode == PuzzleMode.view)
              RepeatButton(
                triggerDelays: _repeatTriggerDelays,
                onLongPress:
                    puzzleState.canGoNext ? () => _moveForward(ref) : null,
                child: BottomBarButton(
                  onTap: puzzleState.canGoNext ? () => _moveForward(ref) : null,
                  label: context.l10n.next,
                  shortLabel: context.l10n.next,
                  icon: CupertinoIcons.chevron_forward,
                  showAndroidTooltip: false,
                ),
              ),
            if (puzzleState.mode == PuzzleMode.view)
              BottomBarButton(
                onTap: puzzleState.mode == PuzzleMode.view &&
                        puzzleState.nextContext != null
                    ? () => ref
                        .read(ctrlProvider.notifier)
                        .loadPuzzle(puzzleState.nextContext!)
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

  void _moveForward(WidgetRef ref) {
    ref.read(ctrlProvider.notifier).userNext();
  }

  void _moveBackward(WidgetRef ref) {
    ref.read(ctrlProvider.notifier).userPrevious();
  }
}

class _DifficultySelector extends ConsumerWidget {
  const _DifficultySelector({
    required this.initialPuzzleContext,
    required this.ctrlProvider,
  });

  final PuzzleContext initialPuzzleContext;
  final PuzzleControllerProvider ctrlProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final difficulty = ref.watch(
      puzzlePreferencesProvider(initialPuzzleContext.userId)
          .select((state) => state.difficulty),
    );
    final state = ref.watch(ctrlProvider);
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
                    showChoicePicker(
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
                            .read(ctrlProvider.notifier)
                            .changeDifficulty(selectedDifficulty);
                        if (context.mounted && nextContext != null) {
                          ref
                              .read(ctrlProvider.notifier)
                              .loadPuzzle(nextContext);
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
