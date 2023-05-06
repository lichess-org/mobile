import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_history_storage.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/auth/user_session.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_service.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';

import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/ui/puzzle/puzzle_screen.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/widgets/board_preview.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen(this.history, this.session);

  final IList<PuzzleHistoryDay> history;
  final UserSession? session;

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
        child: _HistoryScrollView(
          history: history,
          session: session,
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
        child: _HistoryScrollView(history: history, session: session),
      ),
    );
  }
}

class _HistoryScrollView extends ConsumerStatefulWidget {
  const _HistoryScrollView({required this.history, required this.session});

  final IList<PuzzleHistoryDay> history;
  final UserSession? session;

  @override
  ConsumerState<_HistoryScrollView> createState() => _HistoryScrollViewState();
}

class _HistoryScrollViewState extends ConsumerState<_HistoryScrollView> {
  final _scrollController = ScrollController();
  int _pageNumber = 1;
  bool _isLoading = false;
  bool _hasMoreItems = true;
  final List<_HistoryColumn> _items = [];
  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    _items.addAll(widget.history.map((e) => _HistoryColumn(e)));
    super.initState();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadPage();
    }
  }

  Future<void> _loadPage() async {
    if (!_isLoading && _hasMoreItems) {
      setState(() {
        _isLoading = true;
      });
      final data = await _fetchItems();
      if (data != null && data.isNotEmpty) {
        if (mounted) {
          setState(() {
            _pageNumber++;
            _isLoading = false;
            _items.addAll(data);
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _hasMoreItems = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<List<_HistoryColumn>?> _fetchItems() async {
    final data = await ref.watch(puzzleHistoryPageProvider(_pageNumber).future);
    if (data == null) {
      return null;
    }
    return data.map((e) => _HistoryColumn(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(children: _items),
          ),
        ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.only(top: 10, bottom: 40),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}

class _HistoryColumn extends StatelessWidget {
  const _HistoryColumn(this.history);

  final PuzzleHistoryDay history;

  @override
  Widget build(BuildContext context) {
    return ListSection(
      headerTrailing: Text(
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
        HistoryBoards(history),
      ],
    );
  }
}

class HistoryBoards extends ConsumerWidget {
  const HistoryBoards(this.history);

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
