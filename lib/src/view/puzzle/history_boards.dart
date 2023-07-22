import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_screen.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/board_thumbnail.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';

class PuzzleHistoryBoards extends ConsumerStatefulWidget {
  const PuzzleHistoryBoards(this.history, {this.maxRows, super.key});

  final IList<PuzzleHistoryEntry> history;
  final int? maxRows;

  @override
  ConsumerState createState() => _PuzzleHistoryState();
}

class _PuzzleHistoryState extends ConsumerState<PuzzleHistoryBoards> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > kTabletThreshold ? 4 : 2;
        const columnGap = 12.0;
        final boardWidth =
            (constraints.maxWidth - (columnGap * crossAxisCount - columnGap)) /
                crossAxisCount;
        return LayoutGrid(
          columnSizes: List.generate(crossAxisCount, (_) => 1.fr),
          rowSizes: List.generate(
            (widget.history.length / crossAxisCount).ceil(),
            (_) => auto,
          ),
          rowGap: 16.0,
          columnGap: columnGap,
          children: widget.history.map((e) {
            final (fen, side, lastMove) = e.preview;
            return BoardThumbnail(
              size: boardWidth,
              onTap: isLoading
                  ? null
                  : () async {
                      final session = ref.read(authSessionProvider);
                      Puzzle? puzzle;
                      try {
                        setState(() => isLoading = true);
                        puzzle = await ref.read(puzzleProvider(e.id).future);
                      } catch (e) {
                        showPlatformSnackbar(
                          context,
                          e.toString(),
                        );
                      } finally {
                        if (mounted && puzzle != null) {
                          setState(() => isLoading = false);
                          pushPlatformRoute(
                            context,
                            rootNavigator: true,
                            builder: (_) => PuzzleScreen(
                              theme: PuzzleTheme.mix,
                              initialPuzzleContext: PuzzleContext(
                                theme: PuzzleTheme.mix,
                                puzzle: puzzle!,
                                userId: session?.user.id,
                              ),
                            ),
                          );
                        }
                      }
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
                      color: e.win ? LichessColors.good : LichessColors.red,
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
                    Text(e.rating.toString()),
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
