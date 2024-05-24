import 'package:flutter/widgets.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:lichess_mobile/src/widgets/board_thumbnail.dart';

class LayoutBoard extends StatelessWidget {
  final List<BoardThumbnail> Function(int, double) builder;

  const LayoutBoard({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600
            ? 4
            : constraints.maxWidth > 450
                ? 3
                : 2;
        const columnGap = 12.0;
        final boardWidth =
            (constraints.maxWidth - (columnGap * crossAxisCount - columnGap)) /
                crossAxisCount;
        final boards = builder(crossAxisCount, boardWidth);

        return LayoutGrid(
          columnSizes: List.generate(crossAxisCount, (_) => 1.fr),
          rowSizes: List.generate(
            (boards.length / crossAxisCount).floor(),
            (_) => auto,
          ),
          rowGap: 16.0,
          columnGap: columnGap,
          children: boards,
        );
      },
    );
  }
}
