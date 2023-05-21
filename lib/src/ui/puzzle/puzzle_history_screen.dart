import 'package:flutter/cupertino.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_repository.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/widgets/board_preview.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';

class PuzzleHistoryWidget extends ConsumerWidget {
  final List<PuzzleAndResult> data = [];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
      stream: ref.read(
        puzzleRepositoryProvider
            .select((value) => value.puzzleActivity(10, DateTime.now())),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Shimmer(
            child: ShimmerLoading(
              isLoading: true,
              child: ListSection.loading(itemsNumber: 5, header: true),
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Could not load puzzle history'),
          );
        } else if (snapshot.hasData) {
          if (snapshot.data != null) data.add(snapshot.data!);
          if (snapshot.data == null) print(null);
          return Shimmer(
            child: ShimmerLoading(
              isLoading: true,
              child: ListSection.loading(itemsNumber: 5, header: true),
            ),
          );
        } else {
          print(data.length);
          return Text('${snapshot.data} complete');
        }
      },
    );
  }
}
