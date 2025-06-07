import 'dart:async';

import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/model/game/game_repository_providers.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_controller.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_difficulty.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_opening.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_preferences.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/tab_scaffold.dart';
import 'package:lichess_mobile/src/utils/gestures_exclusion.dart';
import 'package:lichess_mobile/src/utils/immersive_mode.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/view/account/rating_pref_aware.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_feedback_widget.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_layout.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_session_widget.dart';
import 'package:lichess_mobile/src/view/settings/board_settings_screen.dart';
import 'package:lichess_mobile/src/view/settings/toggle_sound_button.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/pgn.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';
import 'package:share_plus/share_plus.dart';

class PuzzleScreen extends ConsumerStatefulWidget {
  /// Creates a new puzzle screen.
  ///
  /// If [puzzle] or [puzzleId] are provided, the screen will load the puzzle with that id. Otherwise, it will load the next puzzle from the queue.
  const PuzzleScreen({
    required this.angle,
    this.puzzle,
    this.puzzleId,
    this.openCasualRun = false,
    super.key,
  });

  final PuzzleAngle angle;
  final Puzzle? puzzle;
  final PuzzleId? puzzleId;

  /// If true, all puzzles played in this run will be casual puzzles. (Only if [puzzleId] is provided.)
  final bool openCasualRun;

  static Route<dynamic> buildRoute(
    BuildContext context, {
    required PuzzleAngle angle,
    PuzzleId? puzzleId,
    Puzzle? puzzle,
    bool openCasualRun = false,
  }) {
    return buildScreenRoute(
      context,
      screen: PuzzleScreen(
        angle: angle,
        puzzleId: puzzleId,
        puzzle: puzzle,
        openCasualRun: openCasualRun,
      ),
    );
  }

  @override
  ConsumerState<PuzzleScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends ConsumerState<PuzzleScreen> with RouteAware {
  final _boardKey = GlobalKey(debugLabel: 'boardOnPuzzleScreen');

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
    if (mounted) {
      ref.invalidate(nextPuzzleProvider(widget.angle));
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.puzzle != null
        ? _LoadPuzzleFromPuzzle(boardKey: _boardKey, angle: widget.angle, puzzle: widget.puzzle!)
        : widget.puzzleId != null
        ? _LoadPuzzleFromId(
            boardKey: _boardKey,
            angle: widget.angle,
            id: widget.puzzleId!,
            openCasualRun: widget.openCasualRun,
          )
        : _LoadNextPuzzle(boardKey: _boardKey, angle: widget.angle);
  }
}

class _Title extends ConsumerWidget {
  const _Title({required this.angle, this.initialPuzzleContext});

  final PuzzleAngle angle;
  final PuzzleContext? initialPuzzleContext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDailyPuzzle = false;
    if (initialPuzzleContext != null) {
      isDailyPuzzle =
          ref.watch(puzzleControllerProvider(initialPuzzleContext!)).puzzle.isDailyPuzzle == true;
    }

    if (isDailyPuzzle) {
      return Text(context.l10n.puzzleDailyPuzzle);
    }

    return switch (angle) {
      PuzzleTheme(themeKey: final key) =>
        key == PuzzleThemeKey.mix
            ? Text(context.l10n.puzzleDesc)
            : Text(key.l10n(context.l10n).name),
      PuzzleOpening(key: final key) =>
        ref
            .watch(puzzleOpeningNameProvider(key))
            .when(
              data: (data) => Text(data),
              loading: () => const SizedBox.shrink(),
              error: (_, _) => Text(key.replaceAll('_', ' ')),
            ),
    };
  }
}

class _LoadNextPuzzle extends ConsumerWidget {
  const _LoadNextPuzzle({required this.boardKey, required this.angle});

  final PuzzleAngle angle;
  final GlobalKey boardKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nextPuzzle = ref.watch(nextPuzzleProvider(angle));

    switch (nextPuzzle) {
      case AsyncData(:final value):
        if (value == null) {
          return _PuzzleScaffold(
            angle: angle,
            initialPuzzleContext: null,
            body: const Center(
              child: PuzzleLayout(
                fen: kEmptyFen,
                orientation: Side.white,
                errorMessage: 'No more puzzles. Go online to get more.',
              ),
            ),
          );
        } else {
          return _PuzzleScaffold(
            angle: angle,
            initialPuzzleContext: value,
            body: _Body(boardKey: boardKey, initialPuzzleContext: value),
          );
        }
      case AsyncError(:final error, :final stackTrace):
        debugPrint('SEVERE: [PuzzleScreen] could not load next puzzle; $error\n$stackTrace');
        return _PuzzleScaffold(
          angle: angle,
          initialPuzzleContext: null,
          body: Center(
            child: PuzzleLayout(
              fen: kEmptyFen,
              orientation: Side.white,
              errorMessage: error.toString(),
            ),
          ),
        );
      case _:
        return _PuzzleScaffold(
          angle: angle,
          initialPuzzleContext: null,
          body: const Center(child: CircularProgressIndicator.adaptive()),
        );
    }
  }
}

class _LoadPuzzleFromPuzzle extends ConsumerWidget {
  const _LoadPuzzleFromPuzzle({required this.boardKey, required this.angle, required this.puzzle});

  final PuzzleAngle angle;
  final Puzzle puzzle;
  final GlobalKey boardKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionProvider);
    final initialPuzzleContext = PuzzleContext(
      angle: const PuzzleTheme(PuzzleThemeKey.mix),
      puzzle: puzzle,
      userId: session?.user.id,
    );
    return _PuzzleScaffold(
      angle: angle,
      initialPuzzleContext: initialPuzzleContext,
      body: _Body(boardKey: boardKey, initialPuzzleContext: initialPuzzleContext),
    );
  }
}

class _LoadPuzzleFromId extends ConsumerWidget {
  const _LoadPuzzleFromId({
    required this.boardKey,
    required this.angle,
    required this.id,
    this.openCasualRun = false,
  });

  final PuzzleAngle angle;
  final PuzzleId id;
  final GlobalKey boardKey;
  final bool openCasualRun;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puzzle = ref.watch(puzzleProvider(id));
    final session = ref.watch(authSessionProvider);

    switch (puzzle) {
      case AsyncData(value: final data):
        final initialPuzzleContext = PuzzleContext(
          angle: const PuzzleTheme(PuzzleThemeKey.mix),
          puzzle: data,
          userId: session?.user.id,
          casualRun: openCasualRun ? true : null,
        );
        return _PuzzleScaffold(
          angle: angle,
          initialPuzzleContext: initialPuzzleContext,
          body: _Body(boardKey: boardKey, initialPuzzleContext: initialPuzzleContext),
        );
      case AsyncError(:final error, :final stackTrace):
        debugPrint('SEVERE: [PuzzleScreen] could not load next puzzle; $error\n$stackTrace');
        return _PuzzleScaffold(
          angle: angle,
          initialPuzzleContext: null,
          body: Column(
            children: [
              Expanded(
                child: SafeArea(
                  child: PuzzleLayout(
                    fen: kEmptyFen,
                    orientation: Side.white,
                    errorMessage: error.toString(),
                  ),
                ),
              ),
              const SizedBox(height: kBottomBarHeight),
            ],
          ),
        );
      case _:
        return _PuzzleScaffold(
          angle: angle,
          initialPuzzleContext: null,
          body: const Column(
            children: [
              Expanded(child: PuzzleLayout.empty(showEngineGaugePlaceholder: true)),
              BottomBar.empty(),
            ],
          ),
        );
    }
  }
}

class _PuzzleScaffold extends StatelessWidget {
  const _PuzzleScaffold({
    required this.angle,
    required this.initialPuzzleContext,
    required this.body,
  });

  final PuzzleAngle angle;
  final PuzzleContext? initialPuzzleContext;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return WakelockWidget(
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            const ToggleSoundButton(),
            if (initialPuzzleContext != null) _PuzzleSettingsButton(initialPuzzleContext!),
          ],
          title: _Title(angle: angle, initialPuzzleContext: initialPuzzleContext),
        ),
        body: body,
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.boardKey, required this.initialPuzzleContext});

  final GlobalKey boardKey;
  final PuzzleContext initialPuzzleContext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardPreferences = ref.watch(boardPreferencesProvider);
    final ctrlProvider = puzzleControllerProvider(initialPuzzleContext);
    final puzzleState = ref.watch(ctrlProvider);
    final enginePrefs = ref.watch(engineEvaluationPreferencesProvider);
    final currentEvalBest = ref.watch(engineEvaluationProvider.select((s) => s.eval?.bestMove));
    final evalBestMove = (currentEvalBest ?? puzzleState.node.eval?.bestMove) as NormalMove?;

    final content = PopScope(
      canPop: puzzleState.mode == PuzzleMode.view,
      child: SafeArea(
        // view padding can change on Android when immersive mode is enabled, so to prevent any
        // board vertical shift, we set `maintainBottomViewPadding` to true.
        maintainBottomViewPadding: true,
        child: PuzzleLayout(
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
            onMove: (move, {isDrop}) {
              ref.read(ctrlProvider.notifier).onUserMove(move);
            },
            onPromotionSelection: (role) {
              ref.read(ctrlProvider.notifier).onPromotionSelection(role);
            },
            premovable: null,
          ),
          shapes:
              puzzleState.isEngineAvailable(enginePrefs) && evalBestMove != null
                  ? ISet([
                    Arrow(
                      color: const Color(0x66003088),
                      orig: evalBestMove.from,
                      dest: evalBestMove.to,
                    ),
                  ])
                  : puzzleState.hintSquare != null
                  ? ISet([Circle(color: ShapeColor.green.color, orig: puzzleState.hintSquare!)])
                  : null,
          engineGauge:
              puzzleState.isEngineAvailable(enginePrefs)
                  ? (
                    isLocalEngineAvailable: true,
                    orientation: puzzleState.pov,
                    position: puzzleState.currentPosition,
                    savedEval: puzzleState.node.eval,
                    serverEval: puzzleState.node.serverEval,
                  )
                  : null,
          showEngineGaugePlaceholder: true,
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
                    padding: const EdgeInsets.only(top: 10.0),
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
                              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
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
          landscapeMoveList: Card(
            clipBehavior: Clip.hardEdge,
            margin: EdgeInsets.zero,
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  DebouncedPgnTreeView(
                    root: puzzleState.root,
                    currentPath: puzzleState.currentPath,
                    pgnRootComments: null,
                    shouldShowComputerAnalysis: false,
                    shouldShowComments: false,
                    shouldShowAnnotations: false,
                    displayMode: PgnTreeDisplayMode.twoColumn,
                  ),
                ],
              ),
            ),
          ),
          userActionsBar: _BottomBar(
            initialPuzzleContext: initialPuzzleContext,
            puzzleId: puzzleState.puzzle.puzzle.id,
          ),
        ),
      ),
    );

    return Theme.of(context).platform == TargetPlatform.android
        ? AndroidGesturesExclusionWidget(
            boardKey: boardKey,
            shouldExcludeGesturesOnFocusGained: () => puzzleState.mode != PuzzleMode.view,
            shouldSetImmersiveMode: boardPreferences.immersiveModeWhilePlaying ?? false,
            child: content,
          )
        : content;
  }
}

class _BottomBar extends ConsumerStatefulWidget {
  const _BottomBar({required this.initialPuzzleContext, required this.puzzleId});

  final PuzzleContext initialPuzzleContext;
  final PuzzleId puzzleId;

  static const _repeatTriggerDelays = [
    Duration(milliseconds: 500),
    Duration(milliseconds: 250),
    Duration(milliseconds: 100),
  ];

  @override
  ConsumerState<_BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends ConsumerState<_BottomBar> {
  static const viewSolutionDelay = Duration(seconds: 4);

  Timer? _viewSolutionTimer;
  Completer<void> _viewSolutionCompleter = Completer<void>();

  @override
  void initState() {
    super.initState();

    _viewSolutionTimer = Timer(viewSolutionDelay, () {
      _viewSolutionCompleter.complete();
    });
  }

  @override
  void didUpdateWidget(covariant _BottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.puzzleId != widget.puzzleId) {
      _viewSolutionCompleter = Completer<void>();
      _viewSolutionTimer?.cancel();
      _viewSolutionTimer = Timer(viewSolutionDelay, () {
        _viewSolutionCompleter.complete();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();

    _viewSolutionTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final ctrlProvider = puzzleControllerProvider(widget.initialPuzzleContext);
    final puzzleState = ref.watch(ctrlProvider);
    final enginePrefs = ref.watch(engineEvaluationPreferencesProvider);

    return BottomBar(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (puzzleState.mode != PuzzleMode.view)
          FutureBuilder(
            future: _viewSolutionCompleter.future,
            builder: (context, snapshot) {
              return BottomBarButton(
                icon: Icons.info,
                label: context.l10n.getAHint,
                showLabel: true,
                highlighted: puzzleState.hintSquare != null,
                onTap: snapshot.connectionState == ConnectionState.done
                    ? () => ref.read(ctrlProvider.notifier).toggleHint()
                    : null,
              );
            },
          ),
        if (puzzleState.mode != PuzzleMode.view)
          FutureBuilder(
            future: _viewSolutionCompleter.future,
            builder: (context, snapshot) {
              return BottomBarButton(
                icon: Icons.help,
                label: context.l10n.viewTheSolution,
                showLabel: true,
                onTap: snapshot.connectionState == ConnectionState.done
                    ? () => ref.read(ctrlProvider.notifier).viewSolution()
                    : null,
              );
            },
          ),
        if (puzzleState.mode == PuzzleMode.view)
          BottomBarButton(
            label: context.l10n.menu,
            onTap: () {
              _showPuzzleMenu(context, ref);
            },
            icon: Icons.menu,
          ),
        if (puzzleState.mode == PuzzleMode.view)
          Builder(
            builder: (context) {
              Future<void>? toggleFuture;
              return FutureBuilder<void>(
                future: toggleFuture,
                builder: (context, snapshot) {
                  return BottomBarButton(
                    onTap: snapshot.connectionState != ConnectionState.waiting
                        ? () async {
                            toggleFuture = ref.read(ctrlProvider.notifier).toggleEvaluation();
                            try {
                              await toggleFuture;
                            } finally {
                              toggleFuture = null;
                            }
                          }
                        : null,
                    label: context.l10n.toggleLocalEvaluation,
                    icon: CupertinoIcons.gauge,
                    highlighted: puzzleState.isEngineAvailable(enginePrefs),
                  );
                },
              );
            },
          ),
        if (puzzleState.mode == PuzzleMode.view)
          RepeatButton(
            triggerDelays: _BottomBar._repeatTriggerDelays,
            onLongPress: puzzleState.canGoBack ? () => _moveBackward(ref) : null,
            child: BottomBarButton(
              onTap: puzzleState.canGoBack ? () => _moveBackward(ref) : null,
              label: 'Previous',
              icon: CupertinoIcons.chevron_back,
              showTooltip: false,
            ),
          ),
        if (puzzleState.mode == PuzzleMode.view)
          RepeatButton(
            triggerDelays: _BottomBar._repeatTriggerDelays,
            onLongPress: puzzleState.canGoNext ? () => _moveForward(ref) : null,
            child: BottomBarButton(
              onTap: puzzleState.canGoNext ? () => _moveForward(ref) : null,
              label: context.l10n.next,
              icon: CupertinoIcons.chevron_forward,
              showTooltip: false,
              blink: puzzleState.shouldBlinkNextArrow,
            ),
          ),
        if (puzzleState.mode == PuzzleMode.view)
          BottomBarButton(
            onTap: puzzleState.mode == PuzzleMode.view && puzzleState.nextContext != null
                ? () => ref.read(ctrlProvider.notifier).onLoadPuzzle(puzzleState.nextContext!)
                : null,
            highlighted: true,
            label: context.l10n.puzzleContinueTraining,
            icon: CupertinoIcons.play_arrow_solid,
          ),
      ],
    );
  }

  Future<void> _showPuzzleMenu(BuildContext context, WidgetRef ref) {
    final puzzleState = ref.watch(puzzleControllerProvider(widget.initialPuzzleContext));
    return showAdaptiveActionSheet(
      context: context,
      actions: [
        BottomSheetAction(
          makeLabel: (context) => Text(context.l10n.mobileSharePuzzle),
          onPressed: () {
            launchShareDialog(
              context,
              ShareParams(text: lichessUri('/training/${puzzleState.puzzle.puzzle.id}').toString()),
            );
          },
        ),
        BottomSheetAction(
          makeLabel: (context) => Text(context.l10n.analysis),
          onPressed: () {
            Navigator.of(context).push(
              AnalysisScreen.buildRoute(
                context,
                AnalysisOptions(
                  orientation: puzzleState.pov,
                  standalone: (
                    pgn: ref
                        .read(puzzleControllerProvider(widget.initialPuzzleContext).notifier)
                        .makePgn(),
                    isComputerAnalysisAllowed: true,
                    variant: Variant.standard,
                  ),
                  initialMoveCursor: 0,
                ),
              ),
            );
          },
        ),
        BottomSheetAction(
          makeLabel: (context) =>
              Text(context.l10n.puzzleFromGameLink(puzzleState.puzzle.game.id.value)),
          onPressed: () async {
            final game = await ref.read(
              archivedGameProvider(id: puzzleState.puzzle.game.id).future,
            );
            if (context.mounted) {
              Navigator.of(context).push(
                AnalysisScreen.buildRoute(
                  context,
                  AnalysisOptions(
                    orientation: puzzleState.pov,
                    gameId: game.id,
                    initialMoveCursor: puzzleState.puzzle.puzzle.initialPly + 1,
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  void _moveForward(WidgetRef ref) {
    ref.read(puzzleControllerProvider(widget.initialPuzzleContext).notifier).userNext();
  }

  void _moveBackward(WidgetRef ref) {
    ref.read(puzzleControllerProvider(widget.initialPuzzleContext).notifier).userPrevious();
  }
}

class _PuzzleSettingsButton extends StatelessWidget {
  const _PuzzleSettingsButton(this.initialPuzzleContext);

  final PuzzleContext initialPuzzleContext;

  @override
  Widget build(BuildContext context) {
    return SemanticIconButton(
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        constraints: BoxConstraints(minHeight: MediaQuery.sizeOf(context).height * 0.5),
        builder: (_) => _PuzzleSettingsBottomSheet(initialPuzzleContext),
      ),
      semanticsLabel: context.l10n.settingsSettings,
      icon: const Icon(Icons.settings),
    );
  }
}

class _PuzzleSettingsBottomSheet extends ConsumerWidget {
  const _PuzzleSettingsBottomSheet(this.initialPuzzleContext);

  final PuzzleContext initialPuzzleContext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionProvider);
    final autoNext = ref.watch(puzzlePreferencesProvider.select((value) => value.autoNext));
    final rated = ref.watch(puzzlePreferencesProvider.select((value) => value.rated));
    final ctrlProvider = puzzleControllerProvider(initialPuzzleContext);
    final puzzleState = ref.watch(ctrlProvider);
    final difficulty = ref.watch(puzzlePreferencesProvider.select((state) => state.difficulty));
    final isOnline = ref.watch(connectivityChangesProvider).valueOrNull?.isOnline ?? false;
    return BottomSheetScrollableContainer(
      padding: const EdgeInsets.only(bottom: 16),
      children: [
        ListSection(
          header: Text(context.l10n.settingsSettings),
          materialFilledCard: true,
          children: [
            if (initialPuzzleContext.userId != null &&
                puzzleState.mode != PuzzleMode.view &&
                isOnline)
              StatefulBuilder(
                builder: (context, setState) {
                  PuzzleDifficulty selectedDifficulty = difficulty;
                  return SettingsListTile(
                    settingsLabel: Text(context.l10n.puzzleDifficultyLevel),
                    settingsValue: puzzleDifficultyL10n(context, difficulty),
                    onTap: puzzleState.isChangingDifficulty
                        ? null
                        : () {
                            showChoicePicker(
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
                            ).then((_) async {
                              if (selectedDifficulty == difficulty) {
                                return;
                              }
                              final nextContext = await ref
                                  .read(ctrlProvider.notifier)
                                  .changeDifficulty(selectedDifficulty);
                              if (context.mounted && nextContext != null) {
                                ref.read(ctrlProvider.notifier).onLoadPuzzle(nextContext);
                              }
                            });
                          },
                  );
                },
              ),
            SwitchSettingTile(
              title: Text(context.l10n.puzzleJumpToNextPuzzleImmediately),
              value: autoNext,
              onChanged: (value) {
                ref.read(puzzlePreferencesProvider.notifier).setAutoNext(value);
              },
            ),
            if (session != null)
              SwitchSettingTile(
                title: Text(context.l10n.rated),
                // ignore: avoid_bool_literals_in_conditional_expressions
                value: initialPuzzleContext.casualRun == true ? false : rated,
                onChanged: initialPuzzleContext.casualRun == true
                    ? null
                    : (value) {
                        ref.read(puzzlePreferencesProvider.notifier).setRated(value);
                      },
              ),
            ListTile(
              title: const Text('Board settings'),
              trailing: const Icon(CupertinoIcons.chevron_right),
              onTap: () {
                Navigator.of(
                  context,
                ).push(BoardSettingsScreen.buildRoute(context, fullscreenDialog: true));
              },
            ),
          ],
        ),
      ],
    );
  }
}
