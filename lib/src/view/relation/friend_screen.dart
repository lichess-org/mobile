import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lichess_mobile/src/model/relation/online_friends.dart';
import 'package:lichess_mobile/src/model/relation/relation_repository.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/user/user_context_menu.dart';
import 'package:lichess_mobile/src/view/user/user_or_profile_screen.dart';
import 'package:lichess_mobile/src/view/watch/tv_screen.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/widgets/user.dart';
import 'package:lichess_mobile/src/widgets/user_list_tile.dart';

final followingProvider = FutureProvider.autoDispose<IList<User>>((ref) {
  return ref.withClient((client) => RelationRepository(client).getFollowing());
});

final onlineAndFollowingProvider =
    Provider.autoDispose<AsyncValue<(IList<OnlineFriend> onlineFriends, IList<User> following)>>((
      ref,
    ) {
      final online = ref.watch(onlineFriendsProvider);
      final following = ref.watch(followingProvider);

      return online.when(
        data: (onlineData) => following.when(
          data: (followingData) => AsyncValue.data((onlineData, followingData)),
          error: (e, st) => AsyncValue.error(e, st),
          loading: () => const AsyncValue.loading(),
        ),
        error: (e, st) => AsyncValue.error(e, st),
        loading: () => const AsyncValue.loading(),
      );
    });

class FriendScreen extends ConsumerStatefulWidget {
  const FriendScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const FriendScreen());
  }

  @override
  ConsumerState<FriendScreen> createState() => _FriendScreenState();
}

class _FriendScreenState extends ConsumerState<FriendScreen> with TickerProviderStateMixin {
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
    final onlineAndFollowing = ref.watch(onlineAndFollowingProvider);

    return onlineAndFollowing.when(
      data: (value) => PlatformScaffold(
        appBar: PlatformAppBar(
          title: Text(context.l10n.friends),
          bottom: TabBar(
            controller: _tabController,
            tabs: <Widget>[
              Tab(text: context.l10n.nbFriendsOnline(value.$1.length)),
              Tab(text: context.l10n.nbFollowing(value.$2.length)),
            ],
          ),
        ),
        body: TabBarView(controller: _tabController, children: const [_Online(), _Following()]),
      ),
      error: (error, stack) => PlatformScaffold(
        appBar: PlatformAppBar(title: Text(context.l10n.friends)),
        body: FullScreenRetryRequest(
          onRetry: () {
            ref.invalidate(onlineFriendsProvider);
            ref.invalidate(followingProvider);
          },
        ),
      ),
      loading: () => PlatformScaffold(
        appBar: PlatformAppBar(title: Text(context.l10n.friends)),
        body: const CenterLoadingIndicator(),
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
          if (data.isEmpty) return const SizedBox.shrink();
          return ListSection(
            header: Text(context.l10n.nbFriendsOnline(data.length)),
            onHeaderTap: () => _handleTap(context),
            children: [
              for (final friend in data.take(10)) _OnlineFriendListTile(onlineFriend: friend),
            ],
          );
        },
        error: (error, stackTrace) {
          debugPrint('SEVERE: [OnlineFriendsWidget] load failed: $error');
          return const SizedBox.shrink();
        },
        loading: () => ShimmerLoading(
          isLoading: true,
          child: ListSection.loading(itemsNumber: 3, header: true),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) {
    Navigator.of(context).push(FriendScreen.buildRoute(context));
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
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).push(TvScreen.buildRoute(context, user: user));
              },
              icon: const Icon(Icons.live_tv),
            )
          : null,
      onTap: () => Navigator.of(context).push(UserOrProfileScreen.buildRoute(context, user)),
      onLongPress: () => showModalBottomSheet<void>(
        context: context,
        useRootNavigator: true,
        showDragHandle: true,
        isScrollControlled: true,
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

    return onlineFriends.when(
      data: (value) {
        if (value.isEmpty) {
          return Center(child: Text(context.l10n.nbFriendsOnline(0)));
        }
        return ListView.separated(
          itemCount: value.length,
          separatorBuilder: (context, index) => Theme.of(context).platform == TargetPlatform.iOS
              ? const PlatformDivider(height: 1)
              : const SizedBox.shrink(),
          itemBuilder: (context, index) => _OnlineFriendListTile(onlineFriend: value[index]),
        );
      },
      error: (_, _) => const Center(child: Text('Could not load online friends')),
      loading: () => const CenterLoadingIndicator(),
    );
  }
}

class _Following extends ConsumerWidget {
  const _Following();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followingAsync = ref.watch(followingProvider);

    return followingAsync.when(
      data: (followingList) {
        if (followingList.isEmpty) {
          return Center(child: Text(context.l10n.mobileNotFollowingAnyUser));
        }
        return ListView.separated(
          itemCount: followingList.length,
          separatorBuilder: (context, index) => Theme.of(context).platform == TargetPlatform.iOS
              ? const PlatformDivider(height: 1)
              : const SizedBox.shrink(),
          itemBuilder: (context, index) {
            final user = followingList[index];
            return Slidable(
              dragStartBehavior: DragStartBehavior.start,
              endActionPane: ActionPane(
                motion: const StretchMotion(),
                extentRatio: 0.3,
                children: [
                  SlidableAction(
                    onPressed: (context) async {
                      try {
                        await ref.withClient(
                          (client) => RelationRepository(client).unfollow(user.id),
                        );
                        ref.invalidate(followingProvider);
                      } catch (e) {
                        if (context.mounted) {
                          return showSnackBar(
                            context,
                            'Failed to unfollow: ${user.id}',
                            type: SnackBarType.error,
                          );
                        }
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
                onTap: () => Navigator.of(
                  context,
                ).push(UserOrProfileScreen.buildRoute(context, user.lightUser)),
              ),
            );
          },
        );
      },
      error: (e, st) => FullScreenRetryRequest(onRetry: () => ref.invalidate(followingProvider)),
      loading: () => const CenterLoadingIndicator(),
    );
  }
}
