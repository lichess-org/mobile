import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_history_storage.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/board_preview.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:chessground/chessground.dart';

import 'package:lichess_mobile/src/utils/l10n_context.dart';

class PuzzleHistoryWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.refresh(puzzleHistoryProvider);
    return history.when(
      data: (data) {
        if (data == null) {
          return const SizedBox.shrink();
        }
        return ListSection(
          header: Text(context.l10n.puzzleHistory),
          children: [_HistoryList(data[0]!)],
        );
      },
      error: (e, s) {
        debugPrint(
          'SEVERE: [PuzzleHistoryWidget] could not load next Puzzle; $e\n$s',
        );
        return const Center(child: Text('Could not load Puzzle History'));
      },
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList(this.history);

  final PuzzleHistory history;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constrains) {
        final crossAxisCount = math.min(2, constrains.maxWidth / 300).floor();
        return LayoutGrid(
          columnSizes: List.generate(crossAxisCount, (_) => 1.fr),
          rowSizes: List.generate(
            (history.puzzles.length / crossAxisCount).ceil(),
            (_) => auto,
          ),
          children: history.puzzles.map((puzzle) {
            final preview = PuzzlePreview.fromPuzzle(puzzle.puzzle);
            return SizedBox(
              width: constrains.maxWidth / 2,
              height: constrains.maxWidth / 2 + 30, // + 30 for text Widget
              child: BoardPreview(
                orientation: preview.orientation == Side.white
                    ? Side.white
                    : Side
                        .white, // conflict with dartchess and chessground on Side
                fen: preview.initialFen,
                footer: Text(
                  puzzle.result ? 'Solved' : 'Failed',
                  style: TextStyle(
                    color:
                        puzzle.result ? LichessColors.good : LichessColors.red,
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
