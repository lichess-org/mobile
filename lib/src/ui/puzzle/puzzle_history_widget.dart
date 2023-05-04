import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_history_storage.dart';
import 'package:lichess_mobile/src/ui/puzzle/puzzle_screen.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/board_preview.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:lichess_mobile/src/utils/l10n_context.dart';

class PuzzleHistoryWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(puzzleHistoryProvider);
    return history.when(
      data: (data) {
        if (data == null) {
          return const SizedBox.shrink();
        }
        return ListSection(
          header: Text(context.l10n.puzzleHistory),
          onHeaderTap: () {
            pushPlatformRoute(context, builder: (ctx) => HistoryScreen(data));
          },
          children: getFirst10(data).map((e) => _HistoryList(e)).toList(),
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

  IList<PuzzleHistoryDay> getFirst10(IList<PuzzleHistoryDay> history) {
    final first10 = <PuzzleHistoryDay>[];
    var totalPuzzles = 0;
    for (final h in history) {
      final remaining = 10 - totalPuzzles;
      if (remaining <= 0) {
        break;
      }
      final puzzles = h.puzzles.take(remaining).toList();
      totalPuzzles += puzzles.length;
      first10.add(h.copyWith(puzzles: puzzles.toIList()));
    }
    return first10.toIList();
  }
}

class _HistoryList extends ConsumerWidget {
  const _HistoryList(this.history);

  final PuzzleHistoryDay history;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: DefaultTextStyle.merge(
            style: Styles.sectionTitle,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(puzzleThemeL10n(context, history.angle).name),
                Text(
                  timeago.format(history.day),
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
        _HistoryBoards(history),
      ],
    );
  }
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen(this.history);

  final IList<PuzzleHistoryDay> history;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(context.l10n.puzzleHistory),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: history
                .map(
                  (e) => _HistoryColumn(e),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.puzzleHistory),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: history
                .map(
                  (e) => _HistoryColumn(e),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _HistoryColumn extends ConsumerWidget {
  const _HistoryColumn(this.history);

  final PuzzleHistoryDay history;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListSection(
      trailingWidget: Text(
        timeago.format(history.day),
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          color: Colors.grey,
        ),
      ),
      header: Row(
        children: [
          Text(puzzleThemeL10n(context, history.angle).name),
        ],
      ),
      children: [
        _HistoryBoards(history),
      ],
    );
  }
}

class _HistoryBoards extends ConsumerWidget {
  const _HistoryBoards(this.history);

  final PuzzleHistoryDay history;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final crossAxisCount =
        MediaQuery.of(context).size.width > MediaQuery.of(context).size.height
            ? 4
            : 2;
    final boardWidth = MediaQuery.of(context).size.width / crossAxisCount;
    return LayoutGrid(
      columnSizes: List.generate(crossAxisCount, (_) => 1.fr),
      rowSizes: List.generate(
        (history.puzzles.length / crossAxisCount).ceil(),
        (_) => auto,
      ),
      children: history.puzzles.take(history.puzzles.length).map((puzzle) {
        final preview = PuzzlePreview.fromPuzzle(puzzle.puzzle);
        return SizedBox(
          width: boardWidth,
          height: boardWidth + 30, // + 30 for text Widget
          child: BoardPreview(
            orientation: preview.orientation.cg,
            fen: preview.initialFen,
            footer: Text(
              puzzle.result ? 'Solved' : 'Failed',
              style: TextStyle(
                color: puzzle.result ? LichessColors.good : LichessColors.red,
              ),
            ),
            onTap: () {
              final session = ref.read(authSessionProvider);
              pushPlatformRoute(
                context,
                rootNavigator: true,
                builder: (ctx) => PuzzleScreen(
                  theme: history.angle,
                  initialPuzzleContext: PuzzleContext(
                    theme: history.angle,
                    puzzle: puzzle.puzzle,
                    userId: session?.user.id,
                  ),
                ),
              ).then(
                (_) => ref.invalidate(nextPuzzleProvider(history.angle)),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}
