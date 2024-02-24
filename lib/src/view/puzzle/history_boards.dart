import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/utils/layout.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/account/rating_pref_aware.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_screen.dart';
import 'package:lichess_mobile/src/widgets/board_thumbnail.dart';

class PuzzleHistoryBoards extends ConsumerWidget {
  const PuzzleHistoryBoards(this.history, {this.maxRows, super.key});

  final IList<PuzzleHistoryEntry> history;
  final int? maxRows;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > FormFactor.tablet ? 4 : 2;
        const columnGap = 12.0;
        final boardWidth =
            (constraints.maxWidth - (columnGap * crossAxisCount - columnGap)) /
                crossAxisCount;
        return LayoutGrid(
          columnSizes: List.generate(crossAxisCount, (_) => 1.fr),
          rowSizes: List.generate(
            (history.length / crossAxisCount).ceil(),
            (_) => auto,
          ),
          rowGap: 16.0,
          columnGap: columnGap,
          children: history.map((e) {
            final (fen, side, lastMove) = e.preview;
            return BoardThumbnail(
              size: boardWidth,
              onTap: () {
                pushPlatformRoute(
                  context,
                  rootNavigator: true,
                  builder: (_) => PuzzleScreen(
                    angle: const PuzzleTheme(PuzzleThemeKey.mix),
                    puzzleId: e.id,
                  ),
                );
              },
              orientation: side.cg,
              fen: fen,
              lastMove: lastMove.cg,
              footer: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ColoredBox(
                      color: e.win
                          ? context.lichessColors.good
                          : context.lichessColors.error,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 1,
                          horizontal: 3,
                        ),
                        child: Row(
                          children: [
                            if (e.win)
                              const Icon(
                                color: Colors.white,
                                Icons.done,
                                size: 20,
                              )
                            else
                              const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            if (e.solvingTime != null)
                              Text(
                                '${e.solvingTime!.inSeconds}s',
                                overflow: TextOverflow.fade,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    RatingPrefAware(child: Text(e.rating.toString())),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
