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
import 'package:lichess_mobile/src/view/user/search_screen.dart';
import 'package:lichess_mobile/src/view/user/user_context_menu.dart';
import 'package:lichess_mobile/src/view/user/user_or_profile_screen.dart';
import 'package:lichess_mobile/src/view/watch/tv_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/filter.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/widgets/user.dart';
import 'package:lichess_mobile/src/widgets/user_list_tile.dart';
import 'package:material_ui/material_ui.dart';

enum _FriendSortType {
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

final followingProvider = FutureProvider.autoDispose<IList<User>>((ref) {
  return ref.read(relationRepositoryProvider).getAllFollowing();
});

class FriendScreen extends ConsumerStatefulWidget {
  const FriendScreen({super.key});

  static Route<dynamic> buildRoute() {
    return buildScreenRoute(screen: const FriendScreen());
  }

  @override
  ConsumerState<FriendScreen> createState() => _FriendScreenState();
}

class _FriendScreenState extends ConsumerState<FriendScreen> with TickerProviderStateMixin {
  late final TabController _tabController;
  _FriendSortType sortType = _FriendSortType.ratingDesc;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onlineFriendsCount = ref.watch(onlineFriendsProvider.select((v) => v.value?.length ?? 0));
    final followingCount = ref.watch(followingProvider.select((v) => v.value?.length ?? 0));

    final searchButton = SemanticIconButton(
      icon: const Icon(Icons.search),
      onPressed: () {
        Navigator.of(context).push(
          SearchScreen.buildRoute(
            onUserTap: (user) {
              Navigator.of(context).push(UserOrProfileScreen.buildRoute(user));
            },
          ),
        );
      },
      semanticsLabel: context.l10n.searchSearch,
    );

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
        actions: [searchButton, sortButton],
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
        children: [const _Online(), _Following(sortType)],
      ),
    );
  }
}

class OnlineFriendsWidget extends ConsumerWidget {
  const OnlineFriendsWidget({required this.onlineFriends});

  final AsyncValue<IList<OnlineFriend>> onlineFriends;

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

class _OnlineFriendListTile extends ConsumerWidget {
  const _OnlineFriendListTile({required this.onlineFriend});

  final OnlineFriend onlineFriend;

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

class _Online extends ConsumerWidget {
  const _Online();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onlineFriends = ref.watch(onlineFriendsProvider);

    switch (onlineFriends) {
      case AsyncData(:final value):
        if (value.isEmpty) {
          return Center(child: Text(context.l10n.nbFriendsOnline(0)));
        }
        return ListView.separated(
          itemCount: value.length,
          separatorBuilder: (context, index) => Theme.of(context).platform == TargetPlatform.iOS
              ? const PlatformDivider(height: 1)
              : const SizedBox.shrink(),
          itemBuilder: (context, index) {
            return _OnlineFriendListTile(onlineFriend: value[index]);
          },
        );
      case _:
        return const CenterLoadingIndicator();
    }
  }
}

class _Following extends ConsumerWidget {
  const _Following(this.sortType);
  final _FriendSortType sortType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final following = ref.watch(followingProvider);

    switch (following) {
      case AsyncData(:final value):
        IList<User> following = switch (sortType) {
          _FriendSortType.alphabetical => value.sort(
            (a, b) => a.username.toLowerCase().compareTo(b.username.toLowerCase()),
          ),
          _FriendSortType.ratingDesc =>
            value
                .sort(
                  (a, b) => (int.tryParse(a.perfs.displayRating ?? '0') ?? 0).compareTo(
                    int.tryParse(b.perfs.displayRating ?? '0') ?? 0,
                  ),
                )
                .reversed,
          _FriendSortType.ratingAsc => value.sort(
            (a, b) => (int.tryParse(a.perfs.displayRating ?? '0') ?? 0).compareTo(
              int.tryParse(b.perfs.displayRating ?? '0') ?? 0,
            ),
          ),
          _FriendSortType.lastOnline =>
            value
                .sort((a, b) => (a.seenAt ?? DateTime(1970)).compareTo(b.seenAt ?? DateTime(1970)))
                .reversed,
        };
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            if (following.isEmpty) {
              return Center(child: Text(context.l10n.mobileNotFollowingAnyUser));
            }
            return ListView.separated(
              itemCount: following.length,
              separatorBuilder: (context, index) => Theme.of(context).platform == TargetPlatform.iOS
                  ? const PlatformDivider(height: 1)
                  : const SizedBox.shrink(),
              itemBuilder: (context, index) {
                final user = following[index];
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
