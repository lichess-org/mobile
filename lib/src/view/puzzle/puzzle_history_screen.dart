import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_activity.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart' as cg;
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/board_thumbnail.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_screen.dart';
import 'package:lichess_mobile/src/view/account/rating_pref_aware.dart';

final _dateFormatter = DateFormat.yMMMd(Intl.getCurrentLocale());
final _puzzleLoadingProvider = StateProvider<bool>((ref) => false);

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

const _kPuzzlePadding = 10.0;

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
            MediaQuery.sizeOf(context).width > kTabletThreshold ? 4 : 2;
        final columnsGap = _kPuzzlePadding * crossAxisCount + _kPuzzlePadding;
        final boardWidth =
            (MediaQuery.sizeOf(context).width - columnsGap) / crossAxisCount;

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
                      .map(
                        (e) =>
                            _HistoryBoard(e as PuzzleHistoryEntry, boardWidth),
                      )
                      .toList(),
                ),
              );
            } else if (element is DateTime) {
              final title = DateTime.now().difference(element).inDays >= 15
                  ? _dateFormatter.format(element)
                  : timeago.format(element);
              return Padding(
                padding: const EdgeInsets.only(left: _kPuzzlePadding)
                    .add(Styles.sectionTopPadding),
                child: Text(
                  title,
                  style: Styles.sectionTitle,
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        );
      },
      error: (e, s) {
        debugPrint(
          'SEVERE: [PuzzleHistoryScreen] could not load puzzle history',
        );
        return const Center(child: Text('Could not load Puzzle History'));
      },
      loading: () => const CenterLoadingIndicator(),
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
      padding: const EdgeInsets.only(
        left: _kPuzzlePadding,
        top: _kPuzzlePadding,
        bottom: _kPuzzlePadding,
      ),
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
              RatingPrefAware(child: Text(puzzle.rating.toString())),
            ],
          ),
        ),
      ),
    );
  }
}
