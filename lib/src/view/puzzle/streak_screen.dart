import 'package:chessground/chessground.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_controller.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_streak.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_streak_controller.dart';
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
import 'package:material_ui/material_ui.dart';
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

    switch (streak) {
      case AsyncValue(:final error?, :final stackTrace):
        debugPrint('SEVERE: [StreakScreen] could not load streak; $error\n$stackTrace');
        return PuzzleErrorBoardWidget(
          errorMessage: ref.watch(isDeviceOnlineProvider)
              ? error.toString()
              : 'Go online to start or continue your streak.',
        );
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

  /// The solved puzzle under review, or null when the live puzzle is displayed. It has its own
  /// controller, so the live puzzle keeps its state.
  ({int index, PuzzleContext context})? _review;

  /// Bumped by every review navigation, so that a load overtaken by a later one is dropped.
  int _reviewLoad = 0;

  /// Set once the solved live puzzle could not advance, until the next attempt.
  bool _advanceFailed = false;

  PuzzleContext get _displayedContext => _review?.context ?? widget.initialPuzzleContext;

  ({int index, int total})? get _streakReview {
    final review = _review;
    return review == null ? null : (index: review.index, total: widget.streak.score);
  }

  @override
  void initState() {
    super.initState();
    _controller = ChessboardController(game: _buildGameData());
  }

  @override
  void didUpdateWidget(_Body oldWidget) {
    super.didUpdateWidget(oldWidget);
    // A new run (they may share puzzles, never a start time) has no review to keep.
    if (oldWidget.streak.timestamp != widget.streak.timestamp && _review != null) {
      _leaveReview();
    }
    // A reviewer stays on their puzzle; returning to live picks up the new one.
    if (oldWidget.initialPuzzleContext != widget.initialPuzzleContext && _review == null) {
      _applyBoardUpdate();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  PlayerSide _playerSide(PuzzleState state) {
    if (state.mode == PuzzleMode.load || state.currentPosition.isGameOver) {
      return PlayerSide.none;
    }
    // In a replay the board locks while the opponent's reply is on its way.
    if (state.mode == PuzzleMode.replay && state.currentPosition.turn != state.pov) {
      return PlayerSide.none;
    }
    return state.pov == Side.white ? PlayerSide.white : PlayerSide.black;
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

  Future<void> _viewPuzzleAt(int index) async {
    final load = ++_reviewLoad;
    final Puzzle puzzle;
    try {
      final service = await ref.read(puzzleServiceProvider.future);
      puzzle = await service.loadPuzzle(widget.streak.streak[index]);
    } catch (_) {
      if (mounted && load == _reviewLoad) {
        showSnackBar(context, 'Could not load puzzle', type: SnackBarType.error);
      }
      return;
    }
    if (!mounted || load != _reviewLoad) return;
    _controller.clearDrawnShapes();
    setState(() {
      _review = (
        index: index,
        context: PuzzleContext(
          puzzle: puzzle,
          angle: widget.initialPuzzleContext.angle,
          // A user id would refresh the glicko through the batch endpoint on every load.
          userId: null,
          isPuzzleStreak: true,
          isReview: true,
        ),
      );
    });
    _applyBoardUpdate();
  }

  /// Index in the run of the puzzle on the board.
  int get _displayedIndex => _review?.index ?? widget.streak.index;

  void _viewPreviousPuzzle() => _viewPuzzleAt(_displayedIndex - 1);

  /// The puzzle after the reviewed one, the live puzzle being the last.
  void _viewNextPuzzle() {
    final index = _displayedIndex + 1;
    if (index >= widget.streak.index) {
      _returnToCurrentPuzzle();
    } else {
      _viewPuzzleAt(index);
    }
  }

  /// Moves the streak on to the next puzzle, and tells the user when it cannot.
  Future<void> _advance() async {
    if (_advanceFailed) {
      setState(() {
        _advanceFailed = false;
      });
    }
    final result = await ref.read(puzzleStreakControllerProvider.notifier).next();
    if (!mounted) return;
    switch (result) {
      case .advanced || .aborted:
        return;
      case .ended:
        showSnackBar(context, 'The next puzzle is no longer available, so your streak ends here.');
      case .unavailable:
        // The feedback tile says what is wrong, and the bottom bar offers a retry while online.
        setState(() {
          _advanceFailed = true;
        });
        if (!ref.read(isDeviceOnlineProvider)) {
          showSnackBar(context, "You're offline. Your streak will continue when you reconnect.");
        }
    }
  }

  /// What the feedback tile says while the solved live puzzle waits for the next one.
  String? _advanceNotice({required bool isOnline}) {
    if (!isOnline) return 'Waiting for connection to load the next puzzle.';
    return _advanceFailed ? 'Could not load the next puzzle.' : null;
  }

  void _leaveReview() {
    _reviewLoad++;
    _review = null;
    _controller.clearDrawnShapes();
  }

  void _returnToCurrentPuzzle() {
    setState(_leaveReview);
    _applyBoardUpdate();
  }

  @override
  Widget build(BuildContext context) {
    final boardPreferences = ref.watch(boardPreferencesProvider);
    // The live puzzle drives the streak; the displayed one, the board and the bottom bar.
    final liveProvider = puzzleControllerProvider(widget.initialPuzzleContext);
    final ctrlProvider = puzzleControllerProvider(_displayedContext);
    final puzzleState = ref.watch(ctrlProvider);

    // Set while the live puzzle is solved and its successor not there yet. Connectivity is only
    // watched then, so that it does not rebuild the screen during play.
    final pendingAdvance = _review == null && widget.streak.advancePending;
    final isOnline = !pendingAdvance || ref.watch(isDeviceOnlineProvider);

    // Shared by the portrait and landscape layouts.
    final feedback = PuzzleFeedbackWidget(
      puzzle: puzzleState.puzzle,
      state: puzzleState,
      onStreak: true,
      streakReview: _streakReview,
      streakAdvanceNotice: pendingAdvance ? _advanceNotice(isOnline: isOnline) : null,
    );
    final bottomBar = _BottomBar(
      puzzleContext: _displayedContext,
      streak: widget.streak,
      isReviewing: _review != null,
      onViewPrevious: _displayedIndex > 0 ? _viewPreviousPuzzle : null,
      onViewNext: _review != null ? _viewNextPuzzle : null,
      onJumpToLive: _returnToCurrentPuzzle,
      // Offline, the streak controller retries by itself on reconnect.
      onRetryAdvance: pendingAdvance && _advanceFailed && isOnline ? _advance : null,
    );

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

    ref.listen(liveProvider, (previous, next) {
      if (previous?.result != PuzzleResult.lose && next.result == PuzzleResult.lose) {
        ref.read(puzzleStreakControllerProvider.notifier).gameOver();
      } else if (previous?.result != PuzzleResult.win && next.result == PuzzleResult.win) {
        _advance();
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
      canPop: _review == null && (widget.streak.score == 0 || widget.streak.finished),
      onPopInvokedWithResult: (bool didPop, _) async {
        if (didPop) {
          return;
        }
        // Back from a review returns to the live puzzle, not to the puzzle tab.
        if (_review != null) {
          _returnToCurrentPuzzle();
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
                                          Expanded(child: feedback),
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
                                                  widget.streak.score.toString(),
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
                                    bottomBar,
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
                                    child: feedback,
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
                                                widget.streak.score.toString(),
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
                            bottomBar,
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
            // The board is played in every mode here, a done puzzle being replayed.
            shouldExcludeGesturesOnFocusGained: true,
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
    required this.isReviewing,
    required this.onViewPrevious,
    required this.onViewNext,
    required this.onJumpToLive,
    required this.onRetryAdvance,
  });

  final PuzzleContext puzzleContext;
  final PuzzleStreak streak;

  /// Whether a solved puzzle is on the board rather than the live one.
  final bool isReviewing;

  /// Walk the run puzzle by puzzle; null at either end of it.
  final VoidCallback? onViewPrevious;
  final VoidCallback? onViewNext;
  final VoidCallback onJumpToLive;

  /// Set while the solved live puzzle could not advance: tries again to load the next puzzle.
  final VoidCallback? onRetryAdvance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = puzzleControllerProvider(puzzleContext);
    // Skipping is for the live puzzle in play; nothing else here depends on the puzzle.
    final isReplaying = ref.watch(ctrlProvider.select((s) => s.mode == PuzzleMode.replay));

    // The buttons that move through the run are labelled; menu and analysis stay icon-only, as
    // on the puzzle screen.
    final menuButton = BottomBarButton(
      key: const ValueKey('menu'),
      onTap: () => _showMenu(context, ref),
      label: context.l10n.menu,
      icon: Icons.menu,
    );
    final analysisButton = BottomBarButton(
      key: const ValueKey('analysis'),
      onTap: () => _openAnalysis(context, ref),
      label: context.l10n.analysis,
      icon: Icons.biotech,
    );
    // Greyed out on the first puzzle rather than removed, so that the bar keeps its shape.
    final previousPuzzleButton = BottomBarButton(
      key: const ValueKey('previous-puzzle'),
      icon: CupertinoIcons.arrow_left,
      label: 'Previous',
      tooltip: 'Previous puzzle',
      showLabel: true,
      onTap: onViewPrevious,
    );

    return BottomBar(
      children: [
        menuButton,
        // Off the live puzzle, the arrows walk the run; stepping through moves is for analysis.
        if (isReviewing || streak.finished) ...[
          analysisButton,
          previousPuzzleButton,
          BottomBarButton(
            key: const ValueKey('next-puzzle'),
            icon: CupertinoIcons.arrow_right,
            label: context.l10n.next,
            tooltip: context.l10n.puzzleNextPuzzle,
            showLabel: true,
            onTap: onViewNext,
          ),
          if (streak.finished)
            BottomBarButton(
              key: const ValueKey('new-streak'),
              // Stays tappable offline, so that it can say why a new streak needs the network.
              onTap: ref.watch(puzzleStreakControllerProvider.select((s) => s.isLoading))
                  ? null
                  : () {
                      if (!ref.read(isDeviceOnlineProvider)) {
                        showSnackBar(context, "You're offline. Go online to start a new streak.");
                        return;
                      }
                      ref.invalidate(puzzleStreakControllerProvider);
                    },
              highlighted: true,
              label: context.l10n.puzzleNewStreak,
              icon: Icons.skip_next,
              showLabel: true,
            ),
        ] else ...[
          previousPuzzleButton,
          // A solved puzzle cannot be skipped, so a retry takes the button's place when needed.
          if (onRetryAdvance case final retry?)
            BottomBarButton(
              key: const ValueKey('retry-advance'),
              icon: Icons.refresh,
              label: context.l10n.retry,
              showLabel: true,
              onTap: retry,
            )
          else
            BottomBarButton(
              key: const ValueKey('skip'),
              icon: Icons.skip_next,
              label: context.l10n.skipThisMove,
              showLabel: true,
              onTap: streak.hasSkipped || isReplaying
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

  void _openAnalysis(BuildContext context, WidgetRef ref) {
    final ctrlProvider = puzzleControllerProvider(puzzleContext);
    final puzzleState = ref.read(ctrlProvider);
    Navigator.of(context, rootNavigator: true).push(
      AnalysisScreen.buildRoute(
        puzzleState.makeAnalysisOptions(ref.read(ctrlProvider.notifier).makePgn),
      ),
    );
  }

  Future<void> _showMenu(BuildContext context, WidgetRef ref) {
    final ctrlProvider = puzzleControllerProvider(puzzleContext);
    return showAdaptiveActionSheet(
      context: context,
      actions: [
        if (isReviewing)
          BottomSheetAction(
            makeLabel: (context) => const Text('Back to current puzzle'),
            onPressed: onJumpToLive,
          ),
        BottomSheetAction(
          makeLabel: (context) => Text(context.l10n.mobileSharePuzzle),
          onPressed: () {
            final id = ref.read(ctrlProvider).puzzle.puzzle.id;
            launchShareDialog(context, ShareParams(text: lichessUri('/training/$id').toString()));
          },
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
