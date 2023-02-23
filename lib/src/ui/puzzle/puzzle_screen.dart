import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chessground/chessground.dart' as cg;
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/common/lichess_icons.dart';
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
            interactableSide: puzzleState.pov == Side.white
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
          bottomPlayer: ListTile(
            leading: const Icon(LichessIcons.chess_king, size: 36),
            title: Text(context.l10n.yourTurn),
            subtitle: Text(context.l10n.findTheBestMoveForBlack),
          ),
        ),
      ),
    );
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
