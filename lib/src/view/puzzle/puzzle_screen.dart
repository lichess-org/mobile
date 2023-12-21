import 'package:chessground/chessground.dart' as cg;
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_activity.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_controller.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_difficulty.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_opening.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_preferences.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/utils/connectivity.dart';
import 'package:lichess_mobile/src/utils/immersive_mode.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/account/rating_pref_aware.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';
import 'package:lichess_mobile/src/view/settings/toggle_sound_button.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/board_table.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar_button.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:share_plus/share_plus.dart';

import 'puzzle_feedback_widget.dart';
import 'puzzle_session_widget.dart';

class PuzzleScreen extends ConsumerStatefulWidget {
  const PuzzleScreen({
    required this.angle,
    this.initialPuzzleContext,
    super.key,
  });

  final PuzzleAngle angle;
  final PuzzleContext? initialPuzzleContext;

  @override
  ConsumerState<PuzzleScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends ConsumerState<PuzzleScreen>
    with RouteAware, ImmersiveMode {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null && route is PageRoute) {
      rootNavPageRouteObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    rootNavPageRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPop() {
    super.didPop();
    ref.invalidate(nextPuzzleProvider(widget.angle));
    ref.invalidate(puzzleDashboardProvider);
    ref.invalidate(puzzleRecentActivityProvider);
  }

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
        title: _Title(angle: widget.angle),
      ),
      body: widget.initialPuzzleContext != null
          ? _Body(
              initialPuzzleContext: widget.initialPuzzleContext!,
            )
          : _LoadPuzzle(angle: widget.angle),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        padding: Styles.cupertinoAppBarTrailingWidgetPadding,
        middle: _Title(angle: widget.angle),
        trailing: ToggleSoundButton(),
      ),
      child: widget.initialPuzzleContext != null
          ? _Body(
              initialPuzzleContext: widget.initialPuzzleContext!,
            )
          : _LoadPuzzle(angle: widget.angle),
    );
  }
}

class _Title extends ConsumerWidget {
  const _Title({
    required this.angle,
  });

  final PuzzleAngle angle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (angle) {
      PuzzleTheme(themeKey: final key) => key == PuzzleThemeKey.mix
          ? Text(context.l10n.puzzleDesc)
          : Text(puzzleThemeL10n(context, key).name),
      PuzzleOpening(key: final key) => ref
          .watch(
            puzzleOpeningNameProvider(key),
          )
          .when(
            data: (data) => Text(data),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => Text(key.replaceAll('_', ' ')),
          ),
    };
  }
}

class _LoadPuzzle extends ConsumerWidget {
  const _LoadPuzzle({required this.angle});

  final PuzzleAngle angle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nextPuzzle = ref.watch(nextPuzzleProvider(angle));

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

class _Body extends ConsumerWidget {
  const _Body({
    required this.initialPuzzleContext,
  });

  final PuzzleContext initialPuzzleContext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = puzzleControllerProvider(initialPuzzleContext);
    final puzzleState = ref.watch(ctrlProvider);

    final currentEvalBest = ref.watch(
      engineEvaluationProvider.select((s) => s.eval?.bestMove),
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
                        isLocalEngineAvailable: true,
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
                      initialPuzzleContext: initialPuzzleContext,
                      ctrlProvider: ctrlProvider,
                    ),
                  ],
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
      color: defaultTargetPlatform == TargetPlatform.iOS
          ? CupertinoTheme.of(context).barBackgroundColor
          : Theme.of(context).bottomAppBarTheme.color,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: kBottomBarHeight,
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
              if (puzzleState.mode != PuzzleMode.view)
                BottomBarButton(
                  icon: Icons.help,
                  label: context.l10n.viewTheSolution,
                  showLabel: true,
                  onTap: puzzleState.canViewSolution
                      ? () => ref.read(ctrlProvider.notifier).viewSolution()
                      : null,
                ),
              if (puzzleState.mode == PuzzleMode.view)
                Expanded(
                  child: BottomBarButton(
                    onTap: () {
                      Share.share(
                        '$kLichessHost/training/${puzzleState.puzzle.puzzle.id}',
                      );
                    },
                    label: 'Share this puzzle',
                    icon: defaultTargetPlatform == TargetPlatform.iOS
                        ? CupertinoIcons.share
                        : Icons.share,
                  ),
                ),
              if (puzzleState.mode == PuzzleMode.view)
                Expanded(
                  child: BottomBarButton(
                    onTap: () {
                      ref.read(ctrlProvider.notifier).toggleLocalEvaluation();
                    },
                    label: context.l10n.toggleLocalEvaluation,
                    icon: CupertinoIcons.gauge,
                    highlighted: puzzleState.isLocalEvalEnabled,
                  ),
                ),
              if (puzzleState.mode == PuzzleMode.view)
                Expanded(
                  child: RepeatButton(
                    triggerDelays: _repeatTriggerDelays,
                    onLongPress:
                        puzzleState.canGoBack ? () => _moveBackward(ref) : null,
                    child: BottomBarButton(
                      onTap: puzzleState.canGoBack
                          ? () => _moveBackward(ref)
                          : null,
                      label: 'Previous',
                      icon: CupertinoIcons.chevron_back,
                      showTooltip: false,
                    ),
                  ),
                ),
              if (puzzleState.mode == PuzzleMode.view)
                Expanded(
                  child: RepeatButton(
                    triggerDelays: _repeatTriggerDelays,
                    onLongPress:
                        puzzleState.canGoNext ? () => _moveForward(ref) : null,
                    child: BottomBarButton(
                      onTap: puzzleState.canGoNext
                          ? () => _moveForward(ref)
                          : null,
                      label: context.l10n.next,
                      icon: CupertinoIcons.chevron_forward,
                      showTooltip: false,
                    ),
                  ),
                ),
              if (puzzleState.mode == PuzzleMode.view)
                Expanded(
                  child: BottomBarButton(
                    onTap: puzzleState.mode == PuzzleMode.view &&
                            puzzleState.nextContext != null
                        ? () => ref
                            .read(ctrlProvider.notifier)
                            .loadPuzzle(puzzleState.nextContext!)
                        : null,
                    highlighted: true,
                    label: context.l10n.puzzleContinueTraining,
                    icon: CupertinoIcons.play_arrow_solid,
                  ),
                ),
            ],
          ),
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
            showLabel: true,
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
