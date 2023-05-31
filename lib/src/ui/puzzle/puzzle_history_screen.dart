import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/ui/puzzle/puzzle_screen.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart' as cg;
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/board_preview.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';

class PuzzleHistoryWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyState = ref.watch(puzzleHistoryProvider);
    return historyState.when(
      data: (data) {
        final crossAxisCount =
            MediaQuery.of(context).size.width > kTabletThreshold ? 4 : 2;
        final boardWidth =
            (MediaQuery.of(context).size.width / crossAxisCount) * 0.90;
        return ListSection(
          header: Text(context.l10n.puzzleHistory),
          headerTrailing: NoPaddingTextButton(
            onPressed: () => pushPlatformRoute(
              context,
              builder: (context) => PuzzleHistoryScreen(data.historyList),
            ),
            child: Text(
              context.l10n.more,
            ),
          ),
          children: [
            for (var i = 0; i < data.historyList.length; i += crossAxisCount)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: data.historyList
                    .getRange(
                      i,
                      i + crossAxisCount <= data.historyList.length
                          ? i + crossAxisCount
                          : data.historyList.length,
                    )
                    .map(
                      (e) => _HistoryBoard(e, boardWidth),
                    )
                    .toList(),
              ),
          ],
        );
      },
      error: (e, s) {
        debugPrint(
          'SEVERE: [PuzzleHistoryWidget] could not load dashboard',
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
  const PuzzleHistoryScreen(this.historyList);

  final List<PuzzleAndResult> historyList;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(context.l10n.puzzleHistory),
      ),
      child: _Body(historyList),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.puzzleHistory)),
      body: _Body(historyList),
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body(this.historyList);
  final List<PuzzleAndResult> historyList;
  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  late ScrollController _scrollController;
  late List<PuzzleAndResult> _historyList;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _historyList = [...widget.historyList];
    _scrollController = ScrollController();
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
            _scrollController.position.maxScrollExtent &&
        _historyList.length < 500) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    final newList = await ref.read(puzzleHistoryProvider.notifier).getNext();
    if (mounted) {
      setState(() {
        _isLoading = false;
        _historyList.addAll(newList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final crossAxisCount =
        MediaQuery.of(context).size.width > kTabletThreshold ? 4 : 2;
    final boardWidth = MediaQuery.of(context).size.width / crossAxisCount;
    return ListView.builder(
      controller: _scrollController,
      itemCount: _historyList.length ~/ crossAxisCount + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (_isLoading && index == _historyList.length ~/ crossAxisCount) {
          return const CenterLoadingIndicator();
        }
        final rowStartIndex = index * crossAxisCount;
        final rowEndIndex =
            min(rowStartIndex + crossAxisCount, _historyList.length);
        return Row(
          children: _historyList
              .getRange(rowStartIndex, rowEndIndex)
              .map(
                (e) => _HistoryBoard(e, boardWidth),
              )
              .toList(),
        );
      },
    );
  }
}

class _HistoryBoard extends ConsumerWidget {
  const _HistoryBoard(this.puzzle, this.boardWidth);

  final PuzzleAndResult puzzle;
  final double boardWidth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (fen, turn, _) = puzzle.puzzle.preview();
    return SizedBox(
      width: boardWidth,
      height: boardWidth + 33,
      child: BoardPreview(
        onTap: () async {
          Puzzle? puzzleData;
          try {
            puzzleData =
                await ref.read(puzzleProvider(puzzle.puzzle.id).future);
          } catch (e) {
            // show error
          } finally {
            final session = ref.read(authSessionProvider);
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
        footer: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              ColoredBox(
                color: puzzle.win ? LichessColors.good : LichessColors.red,
                child: Icon(
                  color: Colors.white,
                  (puzzle.win) ? Icons.done : Icons.close,
                ),
              ),
              const SizedBox(width: 8),
              Text(puzzle.puzzle.rating.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
