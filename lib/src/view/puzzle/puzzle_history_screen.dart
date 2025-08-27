import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_activity.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_screen.dart';
import 'package:lichess_mobile/src/widgets/board_thumbnail.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

final _dateFormatter = DateFormat.yMMMd();

/// Shows a short preview of the puzzle history.
class PuzzleHistoryPreview extends ConsumerWidget {
  const PuzzleHistoryPreview(
    this.history, {
    this.maxRows,
    this.shouldOpenCasualPuzzleRun,
    super.key,
  });

  final IList<PuzzleHistoryEntry> history;
  final int? maxRows;
  final bool? shouldOpenCasualPuzzleRun;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _PreviewBoardsGrid(
      rowGap: 16,
      builder: (crossAxisCount, boardWidth) {
        final cappedHistory = maxRows != null ? history.take(crossAxisCount * maxRows!) : history;

        return cappedHistory.map((e) {
          final (fen, side, lastMove) = e.preview;
          return BoardThumbnail(
            size: boardWidth,
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                PuzzleScreen.buildRoute(
                  context,
                  angle: const PuzzleTheme(PuzzleThemeKey.mix),
                  puzzleId: e.id,
                  openCasual: shouldOpenCasualPuzzleRun ?? false,
                ),
              );
            },
            orientation: side,
            fen: fen,
            lastMove: lastMove,
            footer: Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Row(children: [_PuzzleResult(e)]),
            ),
          );
        }).toList();
      },
    );
  }
}

/// A screen that displays the full puzzle history.
class PuzzleHistoryScreen extends StatelessWidget {
  const PuzzleHistoryScreen();

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const PuzzleHistoryScreen());
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(title: Text(context.l10n.puzzleHistory)),
      body: _Body(),
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  @override
  ConsumerState<_Body> createState() => _BodyState();
}

const _kPuzzlePadding = 10.0;

class _BodyState extends ConsumerState<_Body> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
      final currentState = ref.read(puzzleActivityProvider).valueOrNull;
      if (currentState != null && !currentState.isLoading) {
        ref.read(puzzleActivityProvider.notifier).getNext();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final historyState = ref.watch(puzzleActivityProvider);

    return historyState.when(
      data: (state) {
        if (state.hasError) {
          showSnackBar(context, 'Error loading history', type: SnackBarType.error);
        }
        final crossAxisCount = MediaQuery.sizeOf(context).width > FormFactor.tablet ? 4 : 2;
        final columnsGap = _kPuzzlePadding * crossAxisCount + _kPuzzlePadding;
        final boardWidth = (MediaQuery.sizeOf(context).width - columnsGap) / crossAxisCount;

        // List prepared for the ListView.builder.
        // It includes the date headers, and puzzles are sliced into rows of `crossAxisCount` length.
        // So one element can be either:
        //  - a DateTime to show a date header.
        //  - a List<PuzzleHistoryEntry> to show a row of puzzles.
        final list = <dynamic>[];
        for (final entry in state.historyByDay.entries) {
          list.add(entry.key);
          list.addAll(entry.value.slices(crossAxisCount));
        }

        return ListView.builder(
          controller: _scrollController,
          itemCount: list.length + (state.isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (state.isLoading && index == list.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 32.0),
                child: CenterLoadingIndicator(),
              );
            }
            final element = list[index];
            if (element is List) {
              return Padding(
                padding: const EdgeInsets.only(right: _kPuzzlePadding),
                child: Row(
                  children: element
                      .map((e) => PuzzleHistoryBoard(e as PuzzleHistoryEntry, boardWidth))
                      .toList(),
                ),
              );
            } else if (element is DateTime) {
              final title = DateTime.now().difference(element).inDays >= 15
                  ? _dateFormatter.format(element)
                  : relativeDate(context.l10n, element);
              return Padding(
                padding: const EdgeInsets.only(left: _kPuzzlePadding).add(Styles.sectionTopPadding),
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        );
      },
      error: (e, s) {
        debugPrint('SEVERE: [PuzzleHistoryScreen] could not load puzzle history');
        return const Center(child: Text('Could not load Puzzle History'));
      },
      loading: () => const CenterLoadingIndicator(),
    );
  }
}

class PuzzleHistoryBoard extends ConsumerWidget {
  const PuzzleHistoryBoard(this.puzzle, this.boardWidth);

  final PuzzleHistoryEntry puzzle;
  final double boardWidth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (fen, turn, lastMove) = puzzle.preview;
    return Padding(
      padding: const EdgeInsets.only(
        left: _kPuzzlePadding,
        top: _kPuzzlePadding,
        bottom: _kPuzzlePadding,
      ),
      child: BoardThumbnail(
        size: boardWidth,
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(
            PuzzleScreen.buildRoute(
              context,
              angle: const PuzzleTheme(PuzzleThemeKey.mix),
              puzzleId: puzzle.id,
            ),
          );
        },
        orientation: turn,
        fen: fen,
        lastMove: lastMove,
        footer: Padding(padding: const EdgeInsets.only(top: 2), child: _PuzzleResult(puzzle)),
      ),
    );
  }
}

class _PuzzleResult extends StatelessWidget {
  const _PuzzleResult(this.entry);

  final PuzzleHistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: entry.win
          ? context.lichessColors.good.withValues(alpha: 0.7)
          : context.lichessColors.error.withValues(alpha: 0.7),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 3),
        child: Row(
          children: [
            Text(
              entry.win
                  ? String.fromCharCode(Icons.done.codePoint)
                  : String.fromCharCode(Icons.close.codePoint),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'MaterialIcons',
                color: Colors.white,
                height: 1.0,
              ),
            ),
            const SizedBox(width: 2),
            if (entry.solvingTime != null)
              Text(
                '${entry.solvingTime!.inSeconds}s',
                overflow: TextOverflow.fade,
                style: const TextStyle(color: Colors.white, fontSize: 10, height: 1.0),
              )
            else
              Text(
                (entry.win ? context.l10n.puzzleSolved : context.l10n.puzzleFailed).toUpperCase(),
                overflow: TextOverflow.fade,
                style: const TextStyle(fontSize: 10, color: Colors.white, height: 1.0),
              ),
          ],
        ),
      ),
    );
  }
}

class _PreviewBoardsGrid extends StatelessWidget {
  final List<BoardThumbnail> Function(int, double) builder;
  final double rowGap;

  const _PreviewBoardsGrid({required this.builder, required this.rowGap});

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
            (constraints.maxWidth - (columnGap * crossAxisCount - columnGap)) / crossAxisCount;
        final boards = builder(crossAxisCount, boardWidth);

        return LayoutGrid(
          columnSizes: List.generate(crossAxisCount, (_) => 1.fr),
          rowSizes: List.generate((boards.length / crossAxisCount).ceil(), (_) => auto),
          rowGap: rowGap,
          columnGap: columnGap,
          children: boards,
        );
      },
    );
  }
}
