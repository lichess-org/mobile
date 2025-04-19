import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lichess_mobile/src/model/relation/online_friends.dart';
import 'package:lichess_mobile/src/model/relation/relation_repository.dart';
import 'package:lichess_mobile/src/model/relation/relation_repository_providers.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/user/user_context_menu.dart';
import 'package:lichess_mobile/src/view/user/user_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';
import 'package:lichess_mobile/src/widgets/user_list_tile.dart';

final _getFollowingAndOnlinesProvider = FutureProvider.autoDispose<(IList<User>, IList<LightUser>)>(
  (ref) async {
    final following = await ref.watch(followingProvider.future);
    final onlines = await ref.watch(onlineFriendsProvider.future);
    return (following, onlines);
  },
);

class FriendScreen extends ConsumerStatefulWidget {
  const FriendScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const FriendScreen());
  }

  @override
  ConsumerState<FriendScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends ConsumerState<FriendScreen> with TickerProviderStateMixin {
  late final TabController _tabController;

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
    final followingAndOnlines = ref.watch(_getFollowingAndOnlinesProvider);

    switch (followingAndOnlines) {
      case AsyncData(:final value):
        return Scaffold(
          appBar: AppBar(
            title: Text(context.l10n.friends),
            bottom: TabBar(
              controller: _tabController,
              tabs: <Widget>[
                Tab(text: context.l10n.nbFriendsOnline(value.$2.length)),
                Tab(text: context.l10n.nbFollowing(value.$1.length)),
              ],
            ),
          ),
          body: TabBarView(controller: _tabController, children: const [_Online(), _Following()]),
        );
      case _:
        return Scaffold(
          appBar: AppBar(title: Text(context.l10n.friends)),
          body: const CenterLoadingIndicator(),
        );
    }
  }
}

class OnlineFriendsWidget extends ConsumerWidget {
  const OnlineFriendsWidget({required this.onlineFriends});

  final AsyncValue<IList<LightUser>> onlineFriends;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Shimmer(
      child: onlineFriends.when(
        data: (data) {
          return ListSection(
            header: Text(context.l10n.nbFriendsOnline(data.length)),
            headerTrailing:
                data.isEmpty
                    ? null
                    : NoPaddingTextButton(
                      onPressed: () => _handleTap(context, data),
                      child: Text(context.l10n.more),
                    ),
            children: [
              if (data.isEmpty)
                ListTile(
                  title: Text(context.l10n.friends),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _handleTap(context, data),
                ),
              for (final user in data.take(5))
                ListTile(
                  title: UserFullNameWidget(user: user),
                  onTap: () => Navigator.of(context).push(UserScreen.buildRoute(context, user)),
                  onLongPress:
                      () => showAdaptiveBottomSheet<void>(
                        context: context,
                        useRootNavigator: true,
                        isDismissible: true,
                        isScrollControlled: true,
                        showDragHandle: true,
                        builder: (context) => UserContextMenu(userId: user.id),
                      ),
                ),
            ],
          );
        },
        error: (error, stackTrace) {
          debugPrint(
            'SEVERE: [PlayerScreen] could not load following online users; $error\n $stackTrace',
          );
          return const Center(child: Text('Could not load online friends'));
        },
        loading:
            () => ShimmerLoading(
              isLoading: true,
              child: ListSection.loading(itemsNumber: 5, header: true),
            ),
      ),
    );
  }

  void _handleTap(BuildContext context, IList<LightUser> followingOnlines) {
    Navigator.of(context).push(FriendScreen.buildRoute(context));
  }
}

class _Online extends ConsumerWidget {
  const _Online();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onlineFriends = ref.watch(onlineFriendsProvider);

    switch (onlineFriends) {
      case AsyncData(:final value):
        return ListView.separated(
          itemCount: value.length,
          separatorBuilder:
              (context, index) =>
                  Theme.of(context).platform == TargetPlatform.iOS
                      ? const PlatformDivider(height: 1)
                      : const SizedBox.shrink(),
          itemBuilder: (context, index) {
            final user = value[index];
            return ListTile(
              title: UserFullNameWidget(user: user),
              onTap: () => Navigator.of(context).push(UserScreen.buildRoute(context, user)),
              onLongPress:
                  () => showAdaptiveBottomSheet<void>(
                    context: context,
                    useRootNavigator: true,
                    isDismissible: true,
                    isScrollControlled: true,
                    showDragHandle: true,
                    builder: (context) => UserContextMenu(userId: user.id),
                  ),
            );
          },
        );
      case _:
        return const CenterLoadingIndicator();
    }
  }
}

class _Following extends ConsumerWidget {
  const _Following();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followingAndOnlines = ref.watch(_getFollowingAndOnlinesProvider);

    switch (followingAndOnlines) {
      case AsyncData(:final value):
        IList<User> following = value.$1;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            if (following.isEmpty) {
              return Center(child: Text(context.l10n.mobileNotFollowingAnyUser));
            }
            return SafeArea(
              child: ListView.separated(
                itemCount: following.length,
                separatorBuilder:
                    (context, index) =>
                        Theme.of(context).platform == TargetPlatform.iOS
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
                              await ref.withClient(
                                (client) => RelationRepository(client).unfollow(user.id),
                              );
                            } catch (_) {
                              setState(() {
                                following = oldState;
                              });
                            }
                          },
                          backgroundColor: context.lichessColors.error,
                          foregroundColor: Colors.white,
                          icon: Icons.person_remove,
                          // TODO translate
                          label: 'Unfollow',
                        ),
                      ],
                    ),
                    child: UserListTile.fromUser(
                      user,
                      _isOnline(user, value.$2),
                      onTap:
                          () => {
                            Navigator.of(
                              context,
                            ).push(UserScreen.buildRoute(context, user.lightUser)),
                          },
                    ),
                  );
                },
              ),
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

  bool _isOnline(User user, IList<LightUser> followingOnlines) {
    return followingOnlines.any((v) => v.id == user.id);
  }
}
