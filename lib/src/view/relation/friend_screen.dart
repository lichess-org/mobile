import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/relation/online_friends.dart';
import 'package:lichess_mobile/src/model/relation/relation_repository.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/user/user_context_menu.dart';
import 'package:lichess_mobile/src/view/user/user_or_profile_screen.dart';
import 'package:lichess_mobile/src/view/watch/tv_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/filter.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/platform_search_bar.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/widgets/user.dart';
import 'package:lichess_mobile/src/widgets/user_list_tile.dart';
import 'package:material_ui/material_ui.dart';

enum _FriendSortType() {
  alphabetical,
  ratingDesc,
  ratingAsc,
  lastOnline;

  String l10n(AppLocalizations l10n) {
    switch (this) {
      case _FriendSortType.alphabetical:
        return l10n.studyAlphabetical;
      case ratingDesc:
        return 'Rating Descending';
      case _FriendSortType.ratingAsc:
        return 'Rating Ascending';
      case _FriendSortType.lastOnline:
        return 'Last Seen';
    }
  }
}

class const FriendScreen({super.key}) extends ConsumerStatefulWidget {
  static Route<dynamic> buildRoute() {
    return buildScreenRoute(screen: const FriendScreen());
  }

  @override
  ConsumerState<FriendScreen> createState() => _FriendScreenState();
}

class _FriendScreenState() extends ConsumerState<FriendScreen> with TickerProviderStateMixin {
  late final TabController _tabController;
  final _searchController = TextEditingController();
  _FriendSortType sortType = _FriendSortType.lastOnline;
  String searchTerm = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onlineFriendsCount = ref.watch(onlineFriendsProvider.select((v) => v.value?.length ?? 0));
    final followingCount = ref.watch(followingProvider.select((v) => v.value?.length ?? 0));

    final sortButton = SemanticIconButton(
      icon: const Icon(Icons.sort),
      // TODO: translate
      semanticsLabel: 'Sort friends',
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        constraints: BoxConstraints(minHeight: MediaQuery.heightOf(context) * 0.4),
        builder: (_) => StatefulBuilder(
          builder: (context, setLocalState) {
            return BottomSheetScrollableContainer(
              padding: const EdgeInsets.all(16.0),
              children: [
                const SizedBox(height: 16.0),
                Text('Sort by', style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 16.0),
                Filter<_FriendSortType>(
                  filterType: FilterType.singleChoice,
                  choices: _FriendSortType.values,
                  choiceSelected: (choice) => sortType == choice,
                  choiceLabel: (category) => Text(category.l10n(context.l10n)),
                  onSelected: (value, selected) {
                    if (_tabController.index == 0) {
                      _tabController.animateTo(1, duration: kTabScrollDuration);
                    }
                    setLocalState(() => sortType = value);
                    setState(() => sortType = value);
                  },
                ),
                const SizedBox(height: 16.0),
              ],
            );
          },
        ),
      ),
    );

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(context.l10n.friends),
        actions: [sortButton],
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(text: context.l10n.nbFriendsOnline(onlineFriendsCount)),
            Tab(text: context.l10n.nbFollowing(followingCount)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _Online(searchTerm, _searchController, _onSearchChanged),
          _Following(sortType, searchTerm, _searchController, _onSearchChanged),
        ],
      ),
    );
  }

  void _onSearchChanged(String term) {
    setState(() => searchTerm = term);
  }
}

/// Search bar shown as the first item of each friend list.
class const _SearchBarItem({
  required final TextEditingController controller,
  required final ValueChanged<String> onChanged,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: PlatformSearchBar(
        controller: controller,
        hintText: context.l10n.searchSearch,
        onChanged: onChanged,
        onClear: () {
          controller.clear();
          onChanged('');
        },
      ),
    );
  }
}

class const OnlineFriendsWidget({required final AsyncValue<IList<OnlineFriend>> onlineFriends})
    extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Shimmer(
      child: onlineFriends.when(
        data: (data) {
          return ListSection(
            header: Text(context.l10n.nbFriendsOnline(data.length)),
            onHeaderTap: () => _handleTap(context),
            children: [
              for (final friend in data.take(10)) _OnlineFriendListTile(onlineFriend: friend),
            ],
          );
        },
        error: (error, stackTrace) {
          debugPrint(
            'SEVERE: [PlayerScreen] could not load following online users; $error\n $stackTrace',
          );
          return const Center(child: Text('Could not load online friends'));
        },
        loading: () => ShimmerLoading(
          isLoading: true,
          child: ListSection.loading(itemsNumber: 5, header: true),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) {
    Navigator.of(context).push(FriendScreen.buildRoute());
  }
}

class const _OnlineFriendListTile({required final OnlineFriend onlineFriend})
    extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (:user, :playing) = onlineFriend;

    return ListTile(
      title: UserFullNameWidget(user: user),
      trailing: playing
          ? IconButton(
              tooltip: context.l10n.watchGames,
              onPressed: () {
                Navigator.of(context, rootNavigator: true).push(TvScreen.buildRoute(user: user));
              },
              icon: const Icon(Icons.live_tv),
            )
          : null,
      onTap: () => Navigator.of(context).push(UserOrProfileScreen.buildRoute(user)),
      onLongPress: () => showModalBottomSheet<void>(
        context: context,
        useRootNavigator: true,
        isDismissible: true,
        isScrollControlled: true,
        showDragHandle: true,
        constraints: BoxConstraints(minHeight: MediaQuery.heightOf(context) * 0.5),
        builder: (context) => UserContextMenu(userId: user.id),
      ),
    );
  }
}

class const _Online(
  final String searchTerm,
  final TextEditingController searchController,
  final ValueChanged<String> onSearchChanged,
) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onlineFriends = ref.watch(onlineFriendsProvider);

    switch (onlineFriends) {
      case AsyncData(value: final friends):
        // based on the unfiltered list, so the bar doesn't disappear while searching
        final showSearchBar = friends.length >= _kMinItemsForSearchBar;
        final offset = showSearchBar ? 1 : 0;
        final value = friends.where((f) => _matchesSearch(f.user.name, searchTerm)).toIList();
        return ListView.separated(
          // an empty list shows a message instead of tiles
          itemCount: (value.isEmpty ? 1 : value.length) + offset,
          separatorBuilder: (context, index) =>
              index >= offset && Theme.of(context).platform == TargetPlatform.iOS
              ? const PlatformDivider(height: 1)
              : const SizedBox.shrink(),
          itemBuilder: (context, index) {
            if (showSearchBar && index == 0) {
              return _SearchBarItem(controller: searchController, onChanged: onSearchChanged);
            }
            if (value.isEmpty) {
              return _EmptyListMessage(
                searchTerm.isEmpty
                    ? context.l10n.nbFriendsOnline(0)
                    : context.l10n.mobileNoSearchResults,
              );
            }
            return _OnlineFriendListTile(onlineFriend: value[index - offset]);
          },
        );
      case _:
        return const CenterLoadingIndicator();
    }
  }
}

class const _EmptyListMessage(final String message) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      child: Center(child: Text(message)),
    );
  }
}

/// Minimum number of friends in a list before the search bar is shown.
const _kMinItemsForSearchBar = 15;

bool _matchesSearch(String username, String searchTerm) =>
    searchTerm.isEmpty || username.toLowerCase().contains(searchTerm.toLowerCase().trim());

class const _Following(
  final _FriendSortType sortType,
  final String searchTerm,
  final TextEditingController searchController,
  final ValueChanged<String> onSearchChanged,
) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final following = ref.watch(followingProvider);

    switch (following) {
      case AsyncData(value: final users):
        // based on the unfiltered list, so the bar doesn't disappear while searching
        final showSearchBar = users.length >= _kMinItemsForSearchBar;
        final offset = showSearchBar ? 1 : 0;
        final value = users.where((u) => _matchesSearch(u.username, searchTerm)).toIList();
        IList<User> following = switch (sortType) {
          _FriendSortType.alphabetical => value.sort(
            (a, b) => a.username.toLowerCase().compareTo(b.username.toLowerCase()),
          ),
          _FriendSortType.ratingDesc =>
            value
                .sort((a, b) => (a.perfs.displayRating ?? 0).compareTo(b.perfs.displayRating ?? 0))
                .reversed,
          _FriendSortType.ratingAsc => value.sort(
            (a, b) => (a.perfs.displayRating ?? 0).compareTo(b.perfs.displayRating ?? 0),
          ),
          _FriendSortType.lastOnline =>
            value
                .sort((a, b) => (a.seenAt ?? DateTime(1970)).compareTo(b.seenAt ?? DateTime(1970)))
                .reversed,
        };
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return ListView.separated(
              // an empty list shows a message instead of tiles
              itemCount: (following.isEmpty ? 1 : following.length) + offset,
              separatorBuilder: (context, index) =>
                  index >= offset && Theme.of(context).platform == TargetPlatform.iOS
                  ? const PlatformDivider(height: 1)
                  : const SizedBox.shrink(),
              itemBuilder: (context, index) {
                if (showSearchBar && index == 0) {
                  return _SearchBarItem(controller: searchController, onChanged: onSearchChanged);
                }
                if (following.isEmpty) {
                  return _EmptyListMessage(
                    searchTerm.isEmpty
                        ? context.l10n.mobileNotFollowingAnyUser
                        : context.l10n.mobileNoSearchResults,
                  );
                }
                final user = following[index - offset];
                return Slidable(
                  dragStartBehavior: DragStartBehavior.start,
                  endActionPane: ActionPane(
                    motion: const StretchMotion(),
                    extentRatio: 0.3,
                    children: [
                      SlidableAction(
                        onPressed: (BuildContext context) async {
                          final oldState = following;
                          setState(() {
                            following = following.removeWhere((v) => v.id == user.id);
                          });
                          try {
                            await ref.read(relationRepositoryProvider).unfollow(user.id);
                          } catch (_) {
                            setState(() {
                              following = oldState;
                            });
                          }
                        },
                        backgroundColor: context.lichessColors.error,
                        foregroundColor: Colors.white,
                        icon: Icons.person_remove,
                        label: context.l10n.unfollow,
                      ),
                    ],
                  ),
                  child: UserListTile.fromUser(
                    user,
                    onTap: () =>
                        Navigator.of(context).push(UserOrProfileScreen.buildRoute(user.lightUser)),
                  ),
                );
              },
            );
          },
        );
      case AsyncError(:final error, :final stackTrace):
        debugPrint('SEVERE: [FriendScreen] could not load following users; $error\n$stackTrace');
        return FullScreenRetryRequest(onRetry: () => ref.invalidate(followingProvider));
      case _:
        return const CenterLoadingIndicator();
    }
  }
}
