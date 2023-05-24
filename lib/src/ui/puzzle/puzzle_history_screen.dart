import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart' as cg;
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/board_preview.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';

class PuzzleHistoryWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(puzzleHistoryProvider);

    return state.when(
      data: (data) {
        final crossAxisCount =
            MediaQuery.of(context).size.width > kTabletThreshold ? 4 : 2;
        final boardWidth = MediaQuery.of(context).size.width / crossAxisCount;
        return ListSection(
          header: Text(context.l10n.puzzleHistory),
          headerTrailing: NoPaddingTextButton(
            onPressed: () {
              pushPlatformRoute(
                context,
                builder: (context) => PuzzleHistoryScreen(data.historyList),
              );
            },
            child: Text(
              context.l10n.more,
            ),
          ),
          children: [
            for (var i = 0; i < data.historyList.length; i += crossAxisCount)
              Row(
                children: data.historyList
                    .getRange(
                      i,
                      min(i + crossAxisCount, data.historyList.length),
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
        debugPrint('SEVERE: [PuzzleHistoryWidget] could not load dashboard');
        return const Center(child: Text('Could not load Puzzle History'));
      },
      loading: () => ShimmerLoading(
        isLoading: true,
        child: ListSection.loading(
          itemsNumber: 10,
          header: true,
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
        _scrollController.position.maxScrollExtent) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoading) return;
    _isLoading = true;
    try {
      await ref.read(puzzleHistoryProvider.notifier).getNext();
      final newState = ref.read(puzzleHistoryProvider);
      if (newState.hasValue) {
        _historyList.addAll(newState.requireValue.historyList);
      }
    } catch (e) {
      // Handle error
      print('Error loading more puzzles: $e');
    } finally {
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final crossAxisCount =
        MediaQuery.of(context).size.width > kTabletThreshold ? 4 : 2;
    final boardWidth = MediaQuery.of(context).size.width / crossAxisCount;

    return ListView.builder(
      controller: _scrollController,
      itemCount: _isLoading
          ? (_historyList.length + 1) ~/ crossAxisCount
          : _historyList.length ~/ crossAxisCount,
      itemBuilder: (context, index) {
        if (index >= _historyList.length) {
          return const CircularProgressIndicator();
        } else {
          return Row(
            children: _historyList
                .getRange(
                  index,
                  min(index + crossAxisCount, _historyList.length),
                )
                .map(
                  (e) => _HistoryBoard(e, boardWidth),
                )
                .toList(),
          );
        }
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
