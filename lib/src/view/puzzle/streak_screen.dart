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
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_controller.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_streak.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
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
import 'package:lichess_mobile/src/view/puzzle/puzzle_feedback_widget.dart';
import 'package:lichess_mobile/src/view/settings/toggle_sound_button.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/pgn.dart';
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
        return Center(child: _ErrorBody(errorMessage: error.toString()));
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

class _ErrorBody extends ConsumerWidget {
  const _ErrorBody({required this.errorMessage});

  final String errorMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardPreferences = ref.watch(boardPreferencesProvider);

    return Column(
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

                  final defaultSettings = boardPreferences.toBoardSettings().copyWith(
                    borderRadius: isTablet ? Styles.boardBorderRadius : BorderRadius.zero,
                    boxShadow: isTablet ? boardShadows : const <BoxShadow>[],
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
                          _BoardWidget(
                            size: boardSize,
                            fen: kEmptyBoardFEN,
                            orientation: Side.white,
                            gameData: null,
                            settings: defaultSettings,
                            error: errorMessage,
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
                        Padding(
                          padding: isTablet
                              ? const EdgeInsets.symmetric(horizontal: kTabletBoardTableSidePadding)
                              : EdgeInsets.zero,
                          child: _BoardWidget(
                            size: boardSize,
                            fen: kEmptyBoardFEN,
                            orientation: Side.white,
                            gameData: null,
                            settings: defaultSettings,
                            error: errorMessage,
                          ),
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
    );
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
  ISet<Shape> userShapes = ISet();
  final _boardKey = GlobalKey(debugLabel: 'boardOnPuzzleStreakScreen');

  @override
  Widget build(BuildContext context) {
    final boardPreferences = ref.watch(boardPreferencesProvider);
    final ctrlProvider = puzzleControllerProvider(
      widget.initialPuzzleContext,
      isPuzzleStreak: true,
    );
    final puzzleState = ref.watch(ctrlProvider);

    ref.listen(ctrlProvider, (previous, next) {
      if (previous?.result != PuzzleResult.lose && next.result == PuzzleResult.lose) {
        ref.read(puzzleStreakControllerProvider.notifier).gameOver();
      } else if (previous?.result != PuzzleResult.win && next.result == PuzzleResult.win) {
        ref.read(puzzleStreakControllerProvider.notifier).next();
      }
    });

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

                      final defaultSettings = boardPreferences.toBoardSettings().copyWith(
                        borderRadius: isTablet ? Styles.boardBorderRadius : BorderRadius.zero,
                        boxShadow: isTablet ? boardShadows : const <BoxShadow>[],
                        drawShape: DrawShapeOptions(
                          enable: boardPreferences.enableShapeDrawings,
                          onCompleteShape: _onCompleteShape,
                          onClearShapes: _onClearShapes,
                          newShapeColor: boardPreferences.shapeColor.color,
                        ),
                      );

                      final gameData = boardPreferences.toGameData(
                        variant: Variant.standard,
                        position: puzzleState.currentPosition,
                        playerSide: puzzleState.mode == PuzzleMode.load || puzzleState.currentPosition.isGameOver
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
                              _BoardWidget(
                                boardKey: _boardKey,
                                size: boardSize,
                                fen: puzzleState.currentPosition.fen,
                                orientation: puzzleState.pov,
                                gameData: gameData,
                                lastMove: puzzleState.lastMove as NormalMove?,
                                settings: defaultSettings,
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Center(
                                      child: PuzzleFeedbackWidget(
                                        puzzle: puzzleState.puzzle,
                                        state: puzzleState,
                                        onStreak: true,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isTablet ? kTabletBoardTableSidePadding : 12.0,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 32.0),
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
                                      initialPuzzleContext: widget.initialPuzzleContext,
                                      streak: widget.streak,
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
                              child: _BoardWidget(
                                boardKey: _boardKey,
                                size: boardSize,
                                fen: puzzleState.currentPosition.fen,
                                orientation: puzzleState.pov,
                                gameData: gameData,
                                lastMove: puzzleState.lastMove as NormalMove?,
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
                              initialPuzzleContext: widget.initialPuzzleContext,
                              streak: widget.streak,
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
            shouldExcludeGesturesOnFocusGained: () => puzzleState.mode != PuzzleMode.view,
            shouldSetImmersiveMode: boardPreferences.immersiveModeWhilePlaying ?? false,
            child: content,
          )
        : content;
  }

  void _onCompleteShape(Shape shape) {
    if (!mounted) return;

    if (userShapes.any((element) => element == shape)) {
      setState(() {
        userShapes = userShapes.remove(shape);
      });
      return;
    } else {
      setState(() {
        userShapes = userShapes.add(shape);
      });
    }
  }

  void _onClearShapes() {
    if (!mounted) return;

    setState(() {
      userShapes = ISet();
    });
  }
}

class _BoardWidget extends StatelessWidget {
  const _BoardWidget({
    this.boardKey,
    required this.size,
    required this.fen,
    required this.orientation,
    required this.gameData,
    this.lastMove,
    required this.settings,
    this.error,
  });

  final double size;
  final String fen;
  final Side orientation;
  final GameData? gameData;
  final Move? lastMove;
  final ChessboardSettings settings;
  final String? error;
  final GlobalKey? boardKey;

  @override
  Widget build(BuildContext context) {
    final board = Chessboard(
      key: boardKey,
      size: size,
      fen: fen,
      orientation: orientation,
      game: gameData,
      lastMove: lastMove,
      settings: settings,
    );

    if (error != null) {
      return SizedBox.square(
        dimension: size,
        child: Stack(
          children: [
            board,
            _ErrorWidget(errorMessage: error!, boardSize: size),
          ],
        ),
      );
    }

    return board;
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({required this.errorMessage, required this.boardSize});
  final double boardSize;
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: boardSize,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Padding(padding: const EdgeInsets.all(10.0), child: Text(errorMessage)),
          ),
        ),
      ),
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
