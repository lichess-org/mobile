import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/game/game_bookmarks.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/game/game_list_tile.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';

class GameBookmarksScreen extends ConsumerWidget {
  const GameBookmarksScreen({required this.nbBookmarks, super.key});

  final int nbBookmarks;

  static Route<dynamic> buildRoute(BuildContext context, {required int nbBookmarks}) {
    return buildScreenRoute(
      context,
      screen: GameBookmarksScreen(nbBookmarks: nbBookmarks),
      title: context.l10n.nbBookmarks(nbBookmarks),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PlatformThemedScaffold(
      backgroundColor: Styles.listingsScreenBackgroundColor(context),
      appBar: PlatformAppBar(title: Text(context.l10n.nbBookmarks(nbBookmarks))),
      body: const _Body(),
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body();

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

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
      final state = ref.read(gameBookmarksPaginatorProvider);

      if (!state.hasValue) {
        return;
      }

      final hasMore = state.requireValue.hasMore;
      final isLoading = state.requireValue.isLoading;

      if (hasMore && !isLoading) {
        ref.read(gameBookmarksPaginatorProvider.notifier).getNext();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameListState = ref.watch(gameBookmarksPaginatorProvider);

    return gameListState.when(
      data: (state) {
        final list = state.gameList;

        return list.isEmpty
            ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0),
              child: Center(child: Text('No games found')),
            )
            : ListView.separated(
              controller: _scrollController,
              separatorBuilder:
                  (context, index) =>
                      Theme.of(context).platform == TargetPlatform.iOS
                          ? const PlatformDivider(height: 1, cupertinoHasLeading: true)
                          : const SizedBox.shrink(),
              itemCount: list.length + (state.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (state.isLoading && index == list.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: CenterLoadingIndicator(),
                  );
                } else if (state.hasError && state.hasMore && index == list.length) {
                  // TODO: add a retry button
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: Center(child: Text('Could not load more games')),
                  );
                }

                final game = list[index].game;

                Future<void> onRemoveBookmark(BuildContext context) async {
                  try {
                    await ref
                        .read(accountServiceProvider)
                        .setGameBookmark(game.id, bookmark: false);
                    ref.read(gameBookmarksPaginatorProvider.notifier).removeBookmark(game.id);
                  } on Exception catch (_) {
                    if (context.mounted) {
                      showPlatformSnackbar(
                        context,
                        'Bookmark action failed',
                        type: SnackBarType.error,
                      );
                    }
                  }
                }

                final gameTile = GameListTile(
                  item: list[index],
                  // see: https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/cupertino/list_tile.dart#L30 for horizontal padding value
                  padding:
                      Theme.of(context).platform == TargetPlatform.iOS
                          ? const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0)
                          : null,
                );

                return Slidable(
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                        onPressed: onRemoveBookmark,
                        icon: Icons.bookmark_remove_outlined,
                        label: 'Unbookmark',
                      ),
                    ],
                  ),
                  child: gameTile,
                );
              },
            );
      },
      error: (e, s) {
        debugPrint('SEVERE: [GameBookmarksScreen] could not load bookmarks');
        return const Center(child: Text('Could not load bookmarks.'));
      },
      loading: () => const CenterLoadingIndicator(),
    );
  }
}
