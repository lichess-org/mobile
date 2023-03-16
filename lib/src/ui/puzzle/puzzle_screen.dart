import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chessground/chessground.dart' as cg;
import 'package:dartchess/dartchess.dart';
import 'package:share_plus/share_plus.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/common/brightness.dart';
import 'package:lichess_mobile/src/common/lichess_colors.dart';
import 'package:lichess_mobile/src/common/styles.dart';
import 'package:lichess_mobile/src/common/connectivity.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/table_board_layout.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_difficulty.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_preferences.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_session.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';

import 'puzzle_screen_model.dart';

class PuzzlesScreen extends StatelessWidget {
  const PuzzlesScreen({
    required this.theme,
    this.puzzleContext,
    this.isDailyPuzzle = false,
    super.key,
  });

  final PuzzleTheme theme;
  final PuzzleContext? puzzleContext;
  final bool isDailyPuzzle;

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
        title: isDailyPuzzle
            ? const Text('Daily Puzzle')
            : Text(puzzleThemeL10n(context, theme).name),
      ),
      body: puzzleContext != null
          ? _Body(
              puzzleContext: puzzleContext!,
              isDailyPuzzle: isDailyPuzzle,
            )
          : _LoadPuzzle(theme: theme),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: isDailyPuzzle
            ? const Text('Daily Puzzle')
            : Text(puzzleThemeL10n(context, theme).name),
        trailing: ToggleSoundButton(),
      ),
      child: puzzleContext != null
          ? _Body(
              puzzleContext: puzzleContext!,
              isDailyPuzzle: isDailyPuzzle,
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
            child: TableBoardLayout(
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
            puzzleContext: data,
            isDailyPuzzle: false,
          );
        }
      },
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (e, s) {
        debugPrint(
          'SEVERE: [PuzzleScreen] could not load next puzzle; $e\n$s',
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
    required this.puzzleContext,
    required this.isDailyPuzzle,
  });

  final PuzzleContext puzzleContext;
  final bool isDailyPuzzle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pieceSet =
        ref.watch(boardPreferencesProvider.select((p) => p.pieceSet));
    final screenModelProvider = puzzleScreenModelProvider(puzzleContext);
    final puzzleState = ref.watch(screenModelProvider);
    return Column(
      children: [
        Expanded(
          child: Center(
            child: SafeArea(
              child: TableBoardLayout(
                boardData: cg.BoardData(
                  orientation: puzzleState.pov.cg,
                  interactableSide: puzzleState.mode == PuzzleMode.view
                      ? cg.InteractableSide.both
                      : puzzleState.pov == Side.white
                          ? cg.InteractableSide.white
                          : cg.InteractableSide.black,
                  fen: puzzleState.fen,
                  lastMove: puzzleState.lastMove?.cg,
                  sideToMove: puzzleState.position.turn.cg,
                  validMoves: puzzleState.validMoves,
                  onMove: (move, {isPremove}) {
                    ref
                        .read(screenModelProvider.notifier)
                        .playUserMove(Move.fromUci(move.uci)!);
                  },
                ),
                topTable: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 16.0,
                  ),
                  child: _Feedback(
                    puzzle: puzzleContext.puzzle,
                    state: puzzleState,
                    pieceSet: pieceSet,
                  ),
                ),
                bottomTable: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (puzzleContext.glicko != null)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                          left: 10.0,
                          right: 10.0,
                        ),
                        child: Row(
                          children: [
                            Text(context.l10n.yourRating),
                            const SizedBox(width: 5.0),
                            Text(
                              puzzleContext.glicko!.rating
                                  .truncate()
                                  .toString(),
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    _PuzzleSession(
                      puzzleContext: puzzleContext,
                      screenModelProvider: screenModelProvider,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        _BottomBar(
          puzzleContext: puzzleContext,
          isDailyPuzzle: isDailyPuzzle,
          screenModelProvider: screenModelProvider,
        ),
      ],
    );
  }
}

class _Feedback extends StatelessWidget {
  const _Feedback({
    required this.puzzle,
    required this.state,
    required this.pieceSet,
  });

  final Puzzle puzzle;
  final PuzzleScreenState state;
  final cg.PieceSet pieceSet;

  @override
  Widget build(BuildContext context) {
    switch (state.mode) {
      case PuzzleMode.view:
        final puzzleRating =
            context.l10n.ratingX(puzzle.puzzle.rating.toString());
        final playedXTimes = context.l10n.playedXTimes(puzzle.puzzle.plays);
        return PlatformCard(
          child: ListTile(
            leading: state.result == PuzzleResult.win
                ? const Icon(Icons.check, size: 36, color: LichessColors.good)
                : null,
            title: Text(
              state.result == PuzzleResult.win
                  ? context.l10n.puzzleSuccess
                  : context.l10n.puzzleComplete,
            ),
            subtitle: Text('$puzzleRating. $playedXTimes.'),
          ),
        );
      case PuzzleMode.play:
        if (state.feedback == PuzzleFeedback.bad) {
          return PlatformCard(
            child: ListTile(
              leading: const Icon(
                Icons.close,
                size: 36,
                color: LichessColors.error,
              ),
              title: Text(context.l10n.notTheMove),
              subtitle: Text(context.l10n.trySomethingElse),
            ),
          );
        } else if (state.feedback == PuzzleFeedback.good) {
          return PlatformCard(
            child: ListTile(
              leading:
                  const Icon(Icons.check, size: 36, color: LichessColors.good),
              title: Text(context.l10n.bestMove),
              subtitle: Text(context.l10n.keepGoing),
            ),
          );
        } else {
          return PlatformCard(
            child: ListTile(
              leading: Image(
                image: pieceSet.assets[state.pov == Side.white
                    ? cg.PieceKind.whiteKing
                    : cg.PieceKind.blackKing]!,
                height: 56,
              ),
              title: Text(context.l10n.yourTurn),
              subtitle: Text(
                state.pov == Side.white
                    ? context.l10n.findTheBestMoveForWhite
                    : context.l10n.findTheBestMoveForBlack,
              ),
            ),
          );
        }
    }
  }
}

class _PuzzleSession extends ConsumerStatefulWidget {
  const _PuzzleSession({
    required this.puzzleContext,
    required this.screenModelProvider,
  });

  final PuzzleContext puzzleContext;
  final PuzzleScreenModelProvider screenModelProvider;

  @override
  ConsumerState<_PuzzleSession> createState() => _PuzzleSessionState();
}

class _PuzzleSessionState extends ConsumerState<_PuzzleSession> {
  final lastAttemptKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (lastAttemptKey.currentContext != null) {
        Scrollable.ensureVisible(
          lastAttemptKey.currentContext!,
        );
      }
    });
  }

  @override
  void didUpdateWidget(covariant _PuzzleSession oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (lastAttemptKey.currentContext != null) {
        Scrollable.ensureVisible(
          lastAttemptKey.currentContext!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(
      puzzleSessionProvider(
        widget.puzzleContext.userId,
        widget.puzzleContext.theme,
      ),
    );
    final puzzleState = ref.watch(widget.screenModelProvider);
    final brightness = ref.watch(currentBrightnessProvider);
    final currentAttempt = session.attempts.firstWhereOrNull(
      (a) => a.id == widget.puzzleContext.puzzle.puzzle.id,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
      child: SizedBox(
        height: 60,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            verticalDirection: VerticalDirection.up,
            children: [
              for (final attempt in session.attempts)
                _SessionItem(
                  isCurrent:
                      attempt.id == widget.puzzleContext.puzzle.puzzle.id,
                  brightness: brightness,
                  attempt: attempt,
                ),
              if (puzzleState.mode == PuzzleMode.view || currentAttempt == null)
                _SessionItem(
                  isCurrent: currentAttempt == null,
                  brightness: brightness,
                  key: lastAttemptKey,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SessionItem extends StatelessWidget {
  const _SessionItem({
    this.attempt,
    required this.isCurrent,
    required this.brightness,
    super.key,
  });

  final bool isCurrent;
  final PuzzleAttempt? attempt;
  final Brightness brightness;

  Color get good => brightness == Brightness.light
      ? LichessColors.good.shade300
      : defaultTargetPlatform == TargetPlatform.iOS
          ? LichessColors.good.shade600
          : LichessColors.good.shade400;

  Color get error => brightness == Brightness.light
      ? LichessColors.error.shade300
      : defaultTargetPlatform == TargetPlatform.iOS
          ? LichessColors.error.shade600
          : LichessColors.error.shade400;

  Color get next => brightness == Brightness.light
      ? LichessColors.primary.shade300
      : LichessColors.primary.shade600;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 26,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: isCurrent
            ? Colors.grey
            : attempt != null
                ? attempt!.win
                    ? good
                    : error
                : next,
        borderRadius: BorderRadius.circular(5),
      ),
      child: attempt?.ratingDiff != null && attempt!.ratingDiff != 0
          ? Padding(
              padding: const EdgeInsets.all(2.0),
              child: FittedBox(
                fit: BoxFit.cover,
                child: Text(
                  attempt!.ratingDiffString!,
                  maxLines: 1,
                  style: const TextStyle(
                    color: Colors.white,
                    height: 1,
                  ),
                ),
              ),
            )
          : Icon(
              attempt != null
                  ? attempt!.win
                      ? Icons.check
                      : Icons.close
                  : null,
              color: Colors.white,
              size: 18,
            ),
    );
  }
}

void _goToNextPuzzle(
  BuildContext context,
  WidgetRef ref,
  PuzzleContext nextContext,
) {
  Navigator.of(context).pushReplacement(
    _PuzzleTransitionPageRoute(
      builder: (context) => PuzzlesScreen(
        theme: nextContext.theme,
        puzzleContext: nextContext,
      ),
    ),
  );
}

class _PuzzleTransitionPageRoute extends PageRoute<void> {
  _PuzzleTransitionPageRoute({
    required this.builder,
  });

  final WidgetBuilder builder;

  @override
  bool get opaque => true;

  @override
  bool get barrierDismissible => false;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => false;

  @override
  Duration get transitionDuration => Duration.zero;

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final PageTransitionsTheme theme = Theme.of(context).pageTransitionsTheme;
    return theme.buildTransitions(
      this,
      context,
      animation,
      secondaryAnimation,
      child,
    );
  }
}

class _BottomBar extends ConsumerWidget {
  const _BottomBar({
    required this.puzzleContext,
    required this.screenModelProvider,
    required this.isDailyPuzzle,
  });

  final PuzzleContext puzzleContext;
  final bool isDailyPuzzle;
  final PuzzleScreenModelProvider screenModelProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puzzleState = ref.watch(screenModelProvider);

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
            if (puzzleContext.userId != null &&
                !isDailyPuzzle &&
                puzzleState.mode != PuzzleMode.view)
              _DifficultySelector(
                puzzleContext: puzzleContext,
                screenModelProvider: screenModelProvider,
              ),
            if (puzzleState.mode == PuzzleMode.view)
              _BottomBarButton(
                onTap: () {
                  Share.share(
                    '$kLichessHost/training/${puzzleContext.puzzle.puzzle.id}',
                  );
                },
                label: 'Share this puzzle',
                shortLabel: 'Share',
                icon: defaultTargetPlatform == TargetPlatform.iOS
                    ? CupertinoIcons.share
                    : Icons.share,
              ),
            if (puzzleState.mode != PuzzleMode.view)
              _BottomBarButton(
                icon: Icons.help,
                label: context.l10n.viewTheSolution,
                shortLabel: context.l10n.solution,
                showAndroidShortLabel: true,
                onTap: puzzleState.mode == PuzzleMode.view
                    ? null
                    : () =>
                        ref.read(screenModelProvider.notifier).viewSolution(),
              ),
            if (puzzleState.mode == PuzzleMode.view)
              _BottomBarButton(
                onTap: puzzleState.canGoBack
                    ? () =>
                        ref.read(screenModelProvider.notifier).userPrevious()
                    : null,
                label: 'Previous',
                shortLabel: 'Previous',
                icon: CupertinoIcons.chevron_back,
              ),
            if (puzzleState.mode == PuzzleMode.view)
              _BottomBarButton(
                onTap: puzzleState.canGoNext
                    ? () => ref.read(screenModelProvider.notifier).userNext()
                    : null,
                label: context.l10n.next,
                shortLabel: context.l10n.next,
                icon: CupertinoIcons.chevron_forward,
              ),
            if (puzzleState.mode == PuzzleMode.view)
              _BottomBarButton(
                onTap: puzzleState.mode == PuzzleMode.view &&
                        puzzleState.nextContext != null
                    ? () {
                        _goToNextPuzzle(
                          context,
                          ref,
                          puzzleState.nextContext!,
                        );
                      }
                    : null,
                highlighted: true,
                label: context.l10n.continueTraining,
                shortLabel: 'Continue',
                icon: CupertinoIcons.play_arrow_solid,
              ),
          ],
        ),
      ),
    );
  }
}

class _DifficultySelector extends ConsumerWidget {
  const _DifficultySelector({
    required this.puzzleContext,
    required this.screenModelProvider,
  });

  final PuzzleContext puzzleContext;
  final PuzzleScreenModelProvider screenModelProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final difficulty = ref.watch(
      puzzlePreferencesProvider(puzzleContext.userId)
          .select((state) => state.difficulty),
    );
    final state = ref.watch(screenModelProvider);
    final connectivity = ref.watch(connectivityChangesProvider);
    return connectivity.when(
      data: (data) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          PuzzleDifficulty selectedDifficulty = difficulty;
          return _BottomBarButton(
            icon: Icons.tune,
            label: context.l10n.difficultyLevel,
            shortLabel: puzzleDifficultyL10n(context, difficulty),
            showAndroidShortLabel: true,
            onTap: !data.isOnline || state.isChangingDifficulty
                ? null
                : () {
                    showChoicesPicker(
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
                            .read(screenModelProvider.notifier)
                            .changeDifficulty(selectedDifficulty);
                        if (context.mounted && nextContext != null) {
                          _goToNextPuzzle(
                            context,
                            ref,
                            nextContext,
                          );
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

class _BottomBarButton extends StatelessWidget {
  const _BottomBarButton({
    required this.icon,
    required this.label,
    required this.shortLabel,
    required this.onTap,
    this.highlighted = false,
    this.showAndroidShortLabel = false,
  });

  final IconData icon;
  final String label;
  final String shortLabel;
  final VoidCallback? onTap;
  final bool highlighted;
  final bool showAndroidShortLabel;

  bool get enabled => onTap != null;

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        final themeData = Theme.of(context);
        return Theme(
          data: themeData,
          child: SizedBox(
            height: 50,
            child: showAndroidShortLabel
                ? TextButton.icon(
                    onPressed: onTap,
                    icon: Icon(icon),
                    label: Text(shortLabel),
                    style: TextButton.styleFrom(
                      foregroundColor: themeData.colorScheme.onBackground,
                    ),
                  )
                : IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: onTap,
                    icon: Icon(icon),
                    tooltip: label,
                    color: highlighted ? LichessColors.primary : null,
                  ),
          ),
        );
      case TargetPlatform.iOS:
        final themeData = CupertinoTheme.of(context);
        final hightlightedColor = themeData.primaryColor;
        return CupertinoTheme(
          data: themeData.copyWith(
            primaryColor: themeData.textTheme.textStyle.color,
          ),
          child: SizedBox(
            height: 50,
            child: Tooltip(
              message: label,
              triggerMode: TooltipTriggerMode.longPress,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: onTap,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(icon, color: highlighted ? hightlightedColor : null),
                    Text(
                      shortLabel,
                      style: TextStyle(
                        fontSize: 11,
                        color: highlighted ? hightlightedColor : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      default:
        assert(false, 'Unexpected platform $defaultTargetPlatform');
        return const SizedBox.shrink();
    }
  }
}
