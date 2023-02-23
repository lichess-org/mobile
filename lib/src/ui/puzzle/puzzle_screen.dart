import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chessground/chessground.dart' as cg;
import 'package:dartchess/dartchess.dart';

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
  const PuzzlesScreen({required this.puzzle, super.key});

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
      body: _Body(puzzle: puzzle),
      bottomNavigationBar: const _BottomBar(),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(context.l10n.puzzles),
      ),
      child: Column(
        children: [
          Expanded(
            child: _Body(puzzle: puzzle),
          ),
          const _BottomBar(),
        ],
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.puzzle});

  final Puzzle puzzle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pieceSet = ref.watch(pieceSetPrefProvider);
    final boardTheme = ref.watch(boardThemePrefProvider);
    final puzzleState = ref.watch(puzzleScreenStateProvider(puzzle));
    return Center(
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
                  .read(puzzleScreenStateProvider(puzzle).notifier)
                  .playUserMove(Move.fromUci(move.uci)!);
            },
          ),
          boardSettings: cg.BoardSettings(
            pieceAssets: pieceSet.assets,
            colorScheme: boardTheme.colors,
          ),
          topPlayer: const SizedBox.shrink(),
          bottomPlayer: Padding(
            padding: const EdgeInsets.all(10.0),
            child: _Feedback(state: puzzleState, pieceSet: pieceSet),
          ),
        ),
      ),
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
  const _BottomBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              onTap: () {},
              label: context.l10n.puzzleThemes,
              icon: LichessIcons.target,
            ),
            _BottomBarButton(
              onTap: () {},
              label: context.l10n.flipBoard,
              icon: Icons.swap_vert,
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
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return SizedBox(
          height: 50,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(icon, color: Theme.of(context).iconTheme.color),
                  Text(
                    label,
                    style: const TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
        );
      case TargetPlatform.iOS:
        final color = CupertinoTheme.of(context).textTheme.textStyle.color;
        return SizedBox(
          height: 50,
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon, color: color),
                Text(
                  label,
                  style: TextStyle(fontSize: 11, color: color),
                ),
              ],
            ),
          ),
        );
      default:
        assert(false, 'Unexpected platform $defaultTargetPlatform');
        return const SizedBox.shrink();
    }
  }
}
