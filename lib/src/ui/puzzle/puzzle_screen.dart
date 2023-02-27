import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chessground/chessground.dart' as cg;
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/common/lichess_icons.dart';
import 'package:lichess_mobile/src/common/lichess_colors.dart';
import 'package:lichess_mobile/src/common/styles.dart';
import 'package:lichess_mobile/src/widgets/game_board_layout.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/settings/providers.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';

import 'puzzle_screen_state.dart';

class PuzzlesScreen extends StatelessWidget {
  const PuzzlesScreen({
    required this.userId,
    required this.puzzle,
    super.key,
  });

  final UserId? userId;
  final Puzzle puzzle;

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
        title: Text(context.l10n.puzzles),
      ),
      body: _Body(userId: userId, puzzle: puzzle),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(context.l10n.puzzles),
      ),
      child: _Body(userId: userId, puzzle: puzzle),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.puzzle, required this.userId});

  final Puzzle puzzle;
  final UserId? userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pieceSet = ref.watch(pieceSetPrefProvider);
    final boardTheme = ref.watch(boardThemePrefProvider);
    final puzzleStateProvider = puzzleScreenStateProvider(puzzle, userId);
    final puzzleState = ref.watch(puzzleStateProvider);
    return Column(
      children: [
        Expanded(
          child: Center(
            child: SafeArea(
              child: GameBoardLayout(
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
                        .read(puzzleStateProvider.notifier)
                        .playUserMove(Move.fromUci(move.uci)!);
                  },
                ),
                boardSettings: cg.BoardSettings(
                  pieceAssets: pieceSet.assets,
                  colorScheme: boardTheme.colors,
                ),
                topPlayer: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: _Feedback(state: puzzleState, pieceSet: pieceSet),
                ),
                bottomPlayer: const SizedBox.shrink(),
              ),
            ),
          ),
        ),
        _BottomBar(puzzle: puzzle, userId: userId),
      ],
    );
  }
}

class _Feedback extends StatelessWidget {
  const _Feedback({
    required this.state,
    required this.pieceSet,
  });

  final PuzzleVm state;
  final cg.PieceSet pieceSet;

  @override
  Widget build(BuildContext context) {
    switch (state.mode) {
      case PuzzleMode.view:
        final puzzleRating =
            context.l10n.ratingX(state.puzzle.rating.toString());
        final playedXTimes = context.l10n.playedXTimes(state.puzzle.plays);
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

class _BottomBar extends ConsumerWidget {
  const _BottomBar({required this.puzzle, required this.userId});

  final Puzzle puzzle;
  final UserId? userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puzzleStateProvider = puzzleScreenStateProvider(puzzle, userId);
    final puzzleState = ref.watch(puzzleStateProvider);

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
            _BottomBarButton(
              onTap: null,
              label: context.l10n.puzzleThemes,
              shortLabel: 'Themes',
              icon: LichessIcons.target,
            ),
            _BottomBarButton(
              onTap: puzzleState.mode == PuzzleMode.view &&
                      puzzleState.nextPuzzle != null
                  ? () {
                      Navigator.of(context).pushReplacement(
                        PageRouteBuilder<void>(
                          pageBuilder: (context, _, __) => PuzzlesScreen(
                            userId: puzzleState.userId,
                            puzzle: puzzleState.nextPuzzle!,
                          ),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    }
                  : null,
              highlighted: puzzleState.mode == PuzzleMode.view,
              label: context.l10n.continueTraining,
              shortLabel: 'Continue',
              icon: CupertinoIcons.play_arrow_solid,
            ),
            _BottomBarButton(
              onTap: puzzleState.canGoBack
                  ? () =>
                      ref.read(puzzleStateProvider.notifier).goToPreviousNode()
                  : null,
              label: 'Previous',
              shortLabel: 'Previous',
              icon: CupertinoIcons.chevron_back,
            ),
            _BottomBarButton(
              onTap: puzzleState.canGoNext
                  ? () => ref.read(puzzleStateProvider.notifier).goToNextNode()
                  : null,
              label: context.l10n.next,
              shortLabel: context.l10n.next,
              icon: CupertinoIcons.chevron_forward,
            ),
          ],
        ),
      ),
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
  });

  final IconData icon;
  final String label;
  final String shortLabel;
  final VoidCallback? onTap;
  final bool highlighted;

  bool get enabled => onTap != null;

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return Theme(
          data: Theme.of(context),
          child: SizedBox(
            height: 50,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: onTap,
                  icon: Icon(icon),
                  tooltip: label,
                ),
              ],
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
