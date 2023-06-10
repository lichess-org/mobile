import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/history_provider.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/ui/puzzle/history_boards.dart';
import 'package:lichess_mobile/src/ui/puzzle/puzzle_screen.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart' as cg;
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/board_thumbnail.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';

final _puzzleLoadingProvider = StateProvider<bool>((ref) => false);

class PuzzleHistoryWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(puzzleRecentActivityProvider);
    return history.when(
      data: (data) {
        if (data.isEmpty) {
          return ListSection(
            header: Text(context.l10n.puzzleHistory),
            children: [
              Center(
                child: Text(context.l10n.puzzleNoPuzzlesToShow),
              )
            ],
          );
        }

        return ListSection(
          header: Text(context.l10n.puzzleHistory),
          headerTrailing: NoPaddingTextButton(
            onPressed: () => pushPlatformRoute(
              context,
              builder: (context) => PuzzleHistoryScreen(),
            ),
            child: Text(
              context.l10n.more,
            ),
          ),
          children: [
            Padding(
              padding: Styles.bodySectionPadding,
              child: PuzzleHistoryBoards(data),
            ),
          ],
        );
      },
      error: (e, s) {
        debugPrint(
          'SEVERE: [PuzzleHistoryWidget] could not load puzzle history',
        );
        return const Center(child: Text('Could not load Puzzle History'));
      },
      loading: () => Shimmer(
        child: ShimmerLoading(
          isLoading: true,
          child: ListSection.loading(
            itemsNumber: 5,
            header: true,
          ),
        ),
      ),
    );
  }
}

class PuzzleHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(context.l10n.puzzleHistory),
      ),
      child: _Body(),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.puzzleHistory)),
      body: _Body(),
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  final ScrollController _scrollController = ScrollController();
  bool _hasMore = true;
  bool _isLoading = false;

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
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (_hasMore && !_isLoading) {
        ref.read(puzzleActivityProvider.notifier).getNext();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final historyState = ref.watch(puzzleActivityProvider);

    return historyState.when(
      data: (state) {
        _hasMore = state.hasMore;
        _isLoading = state.isLoading;
        if (state.hasError) {
          showPlatformSnackbar(context, 'Error loading history');
        }
        final crossAxisCount =
            MediaQuery.of(context).size.width > kTabletThreshold ? 4 : 2;
        const columnGap = 32.0;
        final boardWidth =
            (MediaQuery.of(context).size.width / crossAxisCount) -
                (columnGap / crossAxisCount);
        return ListView.builder(
          controller: _scrollController,
          itemCount:
              state.list.length ~/ crossAxisCount + (state.isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (state.isLoading &&
                index == state.list.length ~/ crossAxisCount) {
              return const CenterLoadingIndicator();
            }
            final rowStartIndex = index * crossAxisCount;
            final rowEndIndex =
                min(rowStartIndex + crossAxisCount, state.list.length);
            return Row(
              children: state.list
                  .getRange(index * crossAxisCount, rowEndIndex)
                  .map(
                    (e) => _HistoryBoard(e, boardWidth),
                  )
                  .toList(),
            );
          },
        );
      },
      error: (e, s) {
        debugPrint(
          'SEVERE: [PuzzleHistoryScreen] could not load puzzle history',
        );
        return const Center(child: Text('Could not load Puzzle History'));
      },
      loading: () => Shimmer(
        child: ShimmerLoading(
          isLoading: true,
          child: ListSection.loading(itemsNumber: 5),
        ),
      ),
    );
  }
}

class _HistoryBoard extends ConsumerWidget {
  const _HistoryBoard(this.puzzle, this.boardWidth);

  final PuzzleHistoryEntry puzzle;
  final double boardWidth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (fen, turn, lastMove) = puzzle.preview;
    final isLoading = ref.watch(_puzzleLoadingProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BoardThumbnail(
        size: boardWidth,
        onTap: isLoading
            ? null
            : () async {
                Puzzle? puzzleData;
                ref
                    .read(_puzzleLoadingProvider.notifier)
                    .update((state) => true);
                puzzleData = await ref.read(puzzleProvider(puzzle.id).future);
                ref
                    .read(_puzzleLoadingProvider.notifier)
                    .update((state) => false);
                final session = ref.read(authSessionProvider);
                if (context.mounted) {
                  pushPlatformRoute(
                    context,
                    rootNavigator: true,
                    builder: (ctx) => PuzzleScreen(
                      theme: PuzzleTheme.mix,
                      initialPuzzleContext: PuzzleContext(
                        puzzle: puzzleData!,
                        theme: PuzzleTheme.mix,
                        userId: session?.user.id,
                      ),
                    ),
                  );
                }
              },
        orientation: turn.cg,
        fen: fen,
        lastMove: lastMove.cg,
        footer: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              ColoredBox(
                color: puzzle.win ? LichessColors.good : LichessColors.red,
                child: Icon(
                  size: 20,
                  color: Colors.white,
                  (puzzle.win) ? Icons.done : Icons.close,
                ),
              ),
              const SizedBox(width: 8),
              Text(puzzle.rating.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
