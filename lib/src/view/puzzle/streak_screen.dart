import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_controller.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_streak.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/gestures_exclusion.dart';
import 'package:lichess_mobile/src/utils/immersive_mode.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_error_board_widget.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_feedback_widget.dart';
import 'package:lichess_mobile/src/view/settings/toggle_sound_button.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/board.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/pgn.dart';
import 'package:lichess_mobile/src/widgets/platform_alert_dialog.dart';
import 'package:lichess_mobile/src/widgets/yes_no_dialog.dart';
import 'package:share_plus/share_plus.dart';

class StreakScreen extends StatelessWidget {
  const StreakScreen({super.key});

  static Route<dynamic> buildRoute() {
    return buildScreenRoute(screen: const StreakScreen());
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
    final authUser = ref.watch(authControllerProvider);
    final streak = ref.watch(puzzleStreakControllerProvider);

    // A background rebuild that fails (e.g. tapping 'New streak' while offline)
    // keeps showing the previous board (see the switch below), so surface the
    // failure explicitly instead of leaving the user with no feedback.
    ref.listen(puzzleStreakControllerProvider, (previous, next) {
      if (previous?.hasError == false && next.hasError && next.hasValue) {
        showSnackBar(
          context,
          'Could not load the streak. Please check your connection.',
          type: SnackBarType.error,
        );
      }
    });

    switch (streak) {
      // Match a retained value before the error arm: a background rebuild that
      // fails (e.g. offline) still carries the previous value, and we must keep
      // showing the live board rather than tearing it down for the error board.
      case AsyncValue(:final value?):
        return _Body(
          initialPuzzleContext: PuzzleContext(
            puzzle: value.puzzle,
            angle: const PuzzleTheme(PuzzleThemeKey.mix),
            userId: authUser?.user.id,
            isPuzzleStreak: true,
          ),
          streak: value.streak,
        );
      case AsyncValue(:final error?, :final stackTrace):
        debugPrint('SEVERE: [StreakScreen] could not load streak; $error\n$stackTrace');
        // The streak needs the network for an uncached puzzle (a brand-new
        // streak, or resuming past the offline prefetch buffer). Degrade to a
        // static "go online" board instead of surfacing a raw error.
        return const PuzzleErrorBoardWidget(
          errorMessage: 'Go online to start or continue your streak.',
        );
      case _:
        return const Center(child: CircularProgressIndicator.adaptive());
    }
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body({required this.initialPuzzleContext, required this.streak});

  final PuzzleContext initialPuzzleContext;
  final PuzzleStreak streak;

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  final _boardKey = GlobalKey(debugLabel: 'boardOnPuzzleStreakScreen');
  late final ChessboardController _controller;

  /// The solved puzzle under review — its index in the streak and its own
  /// [PuzzleContext] — or `null` when the live puzzle is displayed.
  ///
  /// Reviewing uses a separate [puzzleControllerProvider] (a distinct family
  /// key) so the live puzzle keeps its in-progress state and needs no reload
  /// on return.
  ({int index, PuzzleContext context})? _review;

  /// The puzzle shown on the board: the reviewed one, else the live one.
  PuzzleContext get _displayedContext => _review?.context ?? widget.initialPuzzleContext;

  /// Bumped on every navigation intent (view another puzzle, return to live, or
  /// a live-puzzle swap); an in-flight [_viewPuzzleAt] bails out if a newer
  /// intent superseded it while its fetch was resolving.
  int _navGeneration = 0;

  @override
  void initState() {
    super.initState();
    _controller = ChessboardController(game: _buildGameData());
  }

  @override
  void didUpdateWidget(_Body oldWidget) {
    super.didUpdateWidget(oldWidget);
    // A new live puzzle swaps the context: exit any review (superseding an
    // in-flight review navigation) and push it to the board.
    if (oldWidget.initialPuzzleContext != widget.initialPuzzleContext) {
      _navGeneration++;
      _review = null;
      _applyBoardUpdate();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  PlayerSide _playerSide(PuzzleState state) {
    return state.mode == PuzzleMode.load || state.currentPosition.isGameOver
        ? PlayerSide.none
        : state.mode == PuzzleMode.view
        ? PlayerSide.both
        : state.pov == Side.white
        ? PlayerSide.white
        : PlayerSide.black;
  }

  GameData _buildGameData() {
    final state = ref.read(puzzleControllerProvider(_displayedContext));
    final boardPreferences = ref.read(boardPreferencesProvider);
    return buildGameData(
      fen: state.currentPosition.fen,
      variant: Variant.standard,
      position: state.currentPosition,
      playerSide: _playerSide(state),
      lastMove: state.lastMove,
      castlingMethod: boardPreferences.castlingMethod,
      boardHighlights: boardPreferences.boardHighlights,
    );
  }

  /// Pushes the latest puzzle position to the board controller without rebuilding it.
  void _applyBoardUpdate() {
    _controller.updatePosition(_buildGameData());
  }

  /// Loads the solved puzzle at [index] into the board for review.
  Future<void> _viewPuzzleAt(int index) async {
    final generation = ++_navGeneration;
    final puzzle = await ref
        .read(puzzleStreakControllerProvider.notifier)
        .fetchPuzzle(widget.streak.streak[index]);
    // Bail if unmounted or a newer navigation intent superseded this fetch.
    if (!mounted || generation != _navGeneration) return;
    if (puzzle == null) {
      showSnackBar(context, 'Could not load puzzle', type: SnackBarType.error);
      return;
    }
    final authUser = ref.read(authControllerProvider);
    final reviewContext = PuzzleContext(
      puzzle: puzzle,
      angle: widget.initialPuzzleContext.angle,
      userId: authUser?.user.id,
      isPuzzleStreak: true,
    );
    _controller.clearDrawnShapes();
    ref.read(puzzleControllerProvider(reviewContext).notifier).loadForReview(reviewContext);
    setState(() {
      _review = (index: index, context: reviewContext);
    });
    _applyBoardUpdate();
  }

  void _viewPreviousPuzzle() {
    final currentIndex = _review?.index ?? widget.streak.index;
    if (currentIndex > 0) {
      _viewPuzzleAt(currentIndex - 1);
    }
  }

  void _viewNextPuzzle() {
    final reviewIndex = _review?.index;
    if (reviewIndex == null) return;
    if (reviewIndex + 1 >= widget.streak.index) {
      _returnToCurrentPuzzle();
    } else {
      _viewPuzzleAt(reviewIndex + 1);
    }
  }

  void _returnToCurrentPuzzle() {
    // Supersede any in-flight _viewPuzzleAt, then re-display the untouched live
    // puzzle (its in-progress/solved state is preserved).
    _navGeneration++;
    _controller.clearDrawnShapes();
    setState(() {
      _review = null;
    });
    _applyBoardUpdate();
  }

  @override
  Widget build(BuildContext context) {
    final boardPreferences = ref.watch(boardPreferencesProvider);
    // The live puzzle drives streak progression; the displayed puzzle drives the
    // board and bottom bar. Same provider unless a review is open.
    final liveProvider = puzzleControllerProvider(widget.initialPuzzleContext);
    final ctrlProvider = puzzleControllerProvider(_displayedContext);
    final puzzleState = ref.watch(ctrlProvider);

    // fix for #1951 : when failing the first puzzle, need to do
    // an explicit check when restarting, or else the puzzle will be in a bugged state
    ref.listen(puzzleStreakControllerProvider, (previous, next) {
      if (previous?.hasValue == true && next.hasValue) {
        if (next.requireValue.streak.finished == false &&
            previous!.requireValue.streak.finished == true) {
          _controller.clearDrawnShapes();
          final authUser = ref.read(authControllerProvider);
          ref
              .read(liveProvider.notifier)
              .onLoadPuzzle(
                PuzzleContext(
                  puzzle: next.requireValue.puzzle,
                  angle: widget.initialPuzzleContext.angle,
                  userId: authUser?.user.id,
                ),
              );
        }
      }
    });

    // Streak progression is driven only by the live puzzle, never a reviewed one.
    ref.listen(liveProvider, (previous, next) {
      if (previous?.result != PuzzleResult.lose && next.result == PuzzleResult.lose) {
        ref.read(puzzleStreakControllerProvider.notifier).gameOver();
      } else if (previous?.result != PuzzleResult.win && next.result == PuzzleResult.win) {
        ref.read(puzzleStreakControllerProvider.notifier).next().then((result) {
          // The puzzle was solved but the next one couldn't be loaded. Tell the
          // user instead of silently freezing on the solved board, and don't
          // claim they are offline when it was a server error.
          if (!context.mounted || result != StreakAdvance.unavailable) return;
          final isOnline = ref.read(onlineStatusProvider).value ?? false;
          showSnackBar(
            context,
            isOnline
                ? 'Could not load the next puzzle. Leave and rejoin the streak to retry.'
                : "You're offline. Your streak will continue when you reconnect.",
            type: isOnline ? SnackBarType.error : SnackBarType.info,
          );
        });
      }
    });

    // Drive the board on position/interactivity changes without rebuilding it.
    ref.listen(
      ctrlProvider.select(
        (s) => (fen: s.currentPosition.fen, lastMoveUci: s.lastMove?.uci, side: _playerSide(s)),
      ),
      (_, _) => _applyBoardUpdate(),
    );
    ref.listen(
      boardPreferencesProvider.select((p) => (p.castlingMethod, p.boardHighlights)),
      (_, _) => _applyBoardUpdate(),
    );

    final content = PopScope(
      canPop: widget.streak.index == 0 || widget.streak.finished,
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
      child: SafeArea(
        // view padding can change on Android when immersive mode is enabled, so to prevent any
        // board vertical shift, we set `maintainBottomViewPadding` to true.
        maintainBottomViewPadding: true,
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SafeArea(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final orientation = constraints.maxWidth > constraints.maxHeight
                          ? Orientation.landscape
                          : Orientation.portrait;
                      final isTablet = isTabletOrLarger(context);

                      final defaultSettings = boardPreferences
                          .toBoardSettings(Variant.standard)
                          .copyWith(
                            borderRadius: isTablet ? Styles.boardBorderRadius : BorderRadius.zero,
                            boxShadow: isTablet ? boardShadows : const <BoxShadow>[],
                            drawShape: DrawShapeOptions(
                              enable: boardPreferences.enableShapeDrawings,
                              newShapeColor: boardPreferences.shapeColor.color,
                            ),
                          );

                      if (orientation == Orientation.landscape) {
                        final defaultBoardSize =
                            constraints.biggest.shortestSide - (kTabletBoardTableSidePadding * 2);
                        final sideWidth = constraints.biggest.longestSide - defaultBoardSize;
                        final boardSize = sideWidth >= 250
                            ? defaultBoardSize
                            : constraints.biggest.longestSide / kGoldenRatio -
                                  (kTabletBoardTableSidePadding * 2);
                        return Padding(
                          padding: const EdgeInsets.all(kTabletBoardTableSidePadding),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              BoardWidget(
                                boardKey: _boardKey,
                                size: boardSize,
                                controller: _controller,
                                onMove: (move, {viaDragAndDrop}) {
                                  ref.read(ctrlProvider.notifier).onUserMove(move);
                                },
                                orientation: puzzleState.pov,
                                settings: defaultSettings,
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                            child: PuzzleFeedbackWidget(
                                              puzzle: puzzleState.puzzle,
                                              state: puzzleState,
                                              onStreak: true,
                                            ),
                                          ),
                                          Text(
                                            context.l10n.puzzleRatingX(
                                              puzzleState.puzzle.puzzle.rating.toString(),
                                            ),
                                          ),
                                          const SizedBox(width: 16.0),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isTablet ? kTabletBoardTableSidePadding : 12.0,
                                        vertical: 32.0,
                                      ),
                                      child: Center(
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(24.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  LichessIcons.streak,
                                                  size: 150.0,
                                                  color: ColorScheme.of(context).primary,
                                                ),
                                                const SizedBox(width: 8.0),
                                                Text(
                                                  widget.streak.index.toString(),
                                                  style: TextStyle(
                                                    fontSize: 90.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: ColorScheme.of(context).primary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Card(
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
                                    ),
                                    _BottomBar(
                                      puzzleContext: _displayedContext,
                                      streak: widget.streak,
                                      viewingIndex: _review?.index,
                                      onViewPrevious: _viewPreviousPuzzle,
                                      onViewNext: _viewNextPuzzle,
                                      onJumpToLive: _returnToCurrentPuzzle,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        final defaultBoardSize = constraints.biggest.shortestSide;
                        final double boardSize = isTablet
                            ? defaultBoardSize - kTabletBoardTableSidePadding * 2
                            : defaultBoardSize;

                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isTablet ? kTabletBoardTableSidePadding : 12.0,
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                    child: PuzzleFeedbackWidget(
                                      puzzle: puzzleState.puzzle,
                                      state: puzzleState,
                                      onStreak: true,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: isTablet
                                  ? const EdgeInsets.symmetric(
                                      horizontal: kTabletBoardTableSidePadding,
                                    )
                                  : EdgeInsets.zero,
                              child: BoardWidget(
                                boardKey: _boardKey,
                                size: boardSize,
                                controller: _controller,
                                onMove: (move, {viaDragAndDrop}) {
                                  ref.read(ctrlProvider.notifier).onUserMove(move);
                                },
                                orientation: puzzleState.pov,
                                settings: defaultSettings,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isTablet ? kTabletBoardTableSidePadding : 12.0,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10.0,
                                    left: 10.0,
                                    right: 10.0,
                                  ),
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
                                                widget.streak.index.toString(),
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
                            _BottomBar(
                              puzzleContext: _displayedContext,
                              streak: widget.streak,
                              viewingIndex: _review?.index,
                              onViewPrevious: _viewPreviousPuzzle,
                              onViewNext: _viewNextPuzzle,
                              onJumpToLive: _returnToCurrentPuzzle,
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Theme.of(context).platform == TargetPlatform.android
        ? AndroidGesturesExclusionWidget(
            boardKey: _boardKey,
            shouldExcludeGesturesOnFocusGained: puzzleState.mode != PuzzleMode.view,
            shouldSetImmersiveMode: boardPreferences.immersiveModeWhilePlaying ?? false,
            child: content,
          )
        : content;
  }
}

class _BottomBar extends ConsumerWidget {
  const _BottomBar({
    required this.puzzleContext,
    required this.streak,
    required this.viewingIndex,
    required this.onViewPrevious,
    required this.onViewNext,
    required this.onJumpToLive,
  });

  /// Puzzle shown on the board (live or reviewed).
  final PuzzleContext puzzleContext;
  final PuzzleStreak streak;

  /// Index of the solved puzzle being reviewed, or `null` for the live puzzle.
  final int? viewingIndex;
  final VoidCallback onViewPrevious;
  final VoidCallback onViewNext;
  final VoidCallback onJumpToLive;

  /// Whether there is an earlier solved puzzle to review.
  bool get _canViewPrevious => (viewingIndex ?? streak.index) > 0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = puzzleControllerProvider(puzzleContext);
    final puzzleState = ref.watch(ctrlProvider);
    final isOnline = ref.watch(onlineStatusProvider).value ?? false;

    final viewing = viewingIndex != null;

    final previousMoveButton = BottomBarButton(
      key: const ValueKey('previous-move'),
      onTap: puzzleState.canGoBack ? () => ref.read(ctrlProvider.notifier).userPrevious() : null,
      label: 'Previous',
      icon: CupertinoIcons.chevron_back,
    );

    final nextMoveButton = BottomBarButton(
      key: const ValueKey('next-move'),
      onTap: puzzleState.canGoNext ? () => ref.read(ctrlProvider.notifier).userNext() : null,
      label: context.l10n.next,
      icon: CupertinoIcons.chevron_forward,
    );

    final menuButton = BottomBarButton(
      key: const ValueKey('menu'),
      onTap: () => _showMenu(context, puzzleState),
      label: context.l10n.menu,
      icon: Icons.menu,
    );

    final analysisButton = BottomBarButton(
      key: const ValueKey('analysis'),
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          AnalysisScreen.buildRoute(
            AnalysisOptions.pgn(
              id: puzzleState.puzzle.puzzle.id,
              orientation: puzzleState.pov,
              pgn: ref.read(ctrlProvider.notifier).makePgn(),
              isComputerAnalysisAllowed: true,
              variant: Variant.standard,
              initialMoveCursor: 0,
            ),
          ),
        );
      },
      label: context.l10n.analysis,
      icon: Icons.biotech,
    );

    return BottomBar(
      children: [
        menuButton,
        if (viewing || streak.finished) ...[
          analysisButton,
          previousMoveButton,
          nextMoveButton,
          if (viewing)
            BottomBarButton(
              key: const ValueKey('next-puzzle'),
              icon: CupertinoIcons.arrow_right,
              label: 'Next',
              showLabel: true,
              onTap: onViewNext,
            )
          else
            BottomBarButton(
              key: const ValueKey('new-streak'),
              // A brand-new streak always needs the network.
              onTap: isOnline && ref.read(puzzleStreakControllerProvider).isLoading == false
                  ? () => ref.invalidate(puzzleStreakControllerProvider)
                  : null,
              highlighted: true,
              label: context.l10n.puzzleNewStreak,
              icon: CupertinoIcons.play_arrow_solid,
            ),
        ] else ...[
          if (_canViewPrevious)
            BottomBarButton(
              key: const ValueKey('previous-puzzle'),
              icon: CupertinoIcons.arrow_left,
              label: 'Previous puzzle',
              showLabel: true,
              onTap: onViewPrevious,
            ),
          BottomBarButton(
            key: const ValueKey('skip'),
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
        ],
      ],
    );
  }

  Future<void> _showMenu(BuildContext context, PuzzleState puzzleState) {
    final viewing = viewingIndex != null;
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
        // On the live puzzle the bottom bar already has a previous-puzzle button.
        if (viewing && _canViewPrevious)
          BottomSheetAction(
            makeLabel: (context) => const Text('Previous puzzle'),
            onPressed: onViewPrevious,
          ),
        if (viewing)
          BottomSheetAction(
            makeLabel: (context) => const Text('Jump to live'),
            onPressed: onJumpToLive,
          ),
        BottomSheetAction(
          makeLabel: (context) => Text(context.l10n.aboutX('Streak')),
          onPressed: () => _streakInfoDialogBuilder(context),
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
