import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game_history.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/view/game/game_list_tile.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

class FullGameScreen extends StatelessWidget {
  const FullGameScreen({required this.user, super.key});
  final LightUser user;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Full Game History'),
      ),
      child: _Body(userId: user.id),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Game History'),
      ),
      body: _Body(userId: user.id),
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body({required this.userId});
  final UserId userId;
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
        ref.read(userGameHistoryProvider(widget.userId).notifier).getNext();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameListState = ref.watch(userGameHistoryProvider(widget.userId));

    return gameListState.when(
      data: (state) {
        _hasMore = state.hasMore;
        _isLoading = state.isLoading;
        if (state.hasError) {
          showPlatformSnackbar(
            context,
            'Error loading Game History',
            type: SnackBarType.error,
          );
        }

        final list = state.gameList;
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

            return Slidable(
              endActionPane: const ActionPane(
                motion: ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: null,
                    icon: Icons.bookmark_add_outlined,
                    label: 'Bookmark',
                  ),
                ],
              ),
              child: ExtendedGameListTile(
                item: list[index],
                userId: widget.userId,
              ),
            );
          },
        );
      },
      error: (e, s) {
        debugPrint(
          'SEVERE: [FullGameHistoryScreen] could not load game list',
        );
        return const Center(child: Text('Could not load Game History'));
      },
      loading: () => const CenterLoadingIndicator(),
    );
  }
}
