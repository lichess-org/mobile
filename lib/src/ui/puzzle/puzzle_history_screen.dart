import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_repository.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart' as cg;
import 'package:lichess_mobile/src/widgets/board_preview.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';

class PuzzleHistoryWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(puzzleHistoryProvider);

    return list.when(
      data: (data) {
        final boardWidth = MediaQuery.of(context).size.width;
        return Column(
          children: data.historyList.map((e) {
            final (fen, turn, _) = e.puzzle.preview();
            return SizedBox(
              width: boardWidth / 2,
              height: boardWidth / 2,
              child: BoardPreview(orientation: turn.cg, fen: fen),
            );
          }).toList(),
        );
      },
      error: (e, s) => Text(e.toString()),
      loading: () => const CenterLoadingIndicator(),
    );
  }
}
