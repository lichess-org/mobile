import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chessground/chessground.dart' as cg;
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/common/lichess_icons.dart';
import 'package:lichess_mobile/src/common/lichess_colors.dart';
import 'package:lichess_mobile/src/common/styles.dart';
import 'package:lichess_mobile/src/widgets/game_board_layout.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/settings/providers.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';

import 'puzzle_screen_state.dart';

part 'puzzle_screen.g.dart';

@riverpod
Future<Tuple2<Puzzle?, UserId?>> _nextPuzzle(
  _NextPuzzleRef ref,
  PuzzleTheme theme,
) async {
  final session = await ref.watch(authControllerProvider.future);
  final puzzleService = ref.watch(puzzleServiceProvider);
  final puzzle = await puzzleService.nextPuzzle(
    userId: session?.user.id,
    angle: theme,
  );
  return Tuple2(puzzle, session?.user.id);
}

class PuzzlesScreen extends StatelessWidget {
  const PuzzlesScreen({super.key});

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
      body: const _LoadPuzzle(),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(context.l10n.puzzles),
      ),
      child: const _LoadPuzzle(),
    );
  }
}

class _LoadPuzzle extends ConsumerWidget {
  const _LoadPuzzle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(puzzleThemePrefProvider);
    final nextPuzzle = ref.watch(_nextPuzzleProvider(theme));

    return nextPuzzle.when(
      data: (data) {
        if (data.item1 == null) {
          return const Center(
            child: GameBoardLayout(
              topPlayer: kEmptyWidget,
              bottomPlayer: kEmptyWidget,
              boardData: cg.BoardData(
                fen: kEmptyFen,
                interactableSide: cg.InteractableSide.none,
                orientation: cg.Side.white,
              ),
              errorMessage: 'No more puzzles. Go online to get more.',
            ),
          );
        } else {
          return _Body(puzzle: data.item1!, userId: data.item2);
        }
      },
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (e, s) {
        debugPrint(
          'SEVERE: [PuzzleScreen] could not load next puzzle; $e\n$s',
        );
        return Center(
          child: GameBoardLayout(
            topPlayer: kEmptyWidget,
            bottomPlayer: kEmptyWidget,
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
            subtitle: Text(context.l10n.continueTraining),
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
            const _BottomBarButton(
              onTap: null,
              label: 'Themes',
              icon: LichessIcons.target,
            ),
            _BottomBarButton(
              onTap: puzzleState.mode == PuzzleMode.view
                  ? () {
                      // be sure to invalidate the providers in case there is no more puzzle
                      ref.invalidate(_nextPuzzleProvider);
                      ref.invalidate(puzzleStateProvider);
                      Navigator.of(context).pushReplacement(
                        PageRouteBuilder<void>(
                          pageBuilder: (context, _, __) =>
                              const PuzzlesScreen(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    }
                  : null,
              highlighted: puzzleState.mode == PuzzleMode.view,
              label: 'Continue',
              icon: CupertinoIcons.play_arrow_solid,
            ),
            _BottomBarButton(
              onTap: puzzleState.canGoBack
                  ? () =>
                      ref.read(puzzleStateProvider.notifier).goToPreviousNode()
                  : null,
              label: 'Previous',
              icon: CupertinoIcons.chevron_back,
            ),
            _BottomBarButton(
              onTap: puzzleState.canGoNext
                  ? () => ref.read(puzzleStateProvider.notifier).goToNextNode()
                  : null,
              label: context.l10n.next,
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
    required this.onTap,
    this.highlighted = false,
  });

  final IconData icon;
  final String label;
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
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: onTap,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(icon, color: highlighted ? hightlightedColor : null),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      color: highlighted ? hightlightedColor : null,
                    ),
                  ),
                ],
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
