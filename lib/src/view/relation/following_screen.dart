import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:lichess_mobile/src/view/user/user_screen.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';
import 'package:lichess_mobile/src/widgets/user_list_tile.dart';

final _getFollowingAndOnlinesProvider = FutureProvider.autoDispose<(IList<User>, IList<LightUser>)>(
  (ref) async {
    final following = await ref.watch(followingProvider.future);
    final onlines = await ref.watch(onlineFriendsProvider.future);
    return (following, onlines);
  },
);

class FollowingScreen extends StatelessWidget {
  const FollowingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(title: Text(context.l10n.friends)),
      body: const _Body(),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followingAndOnlines = ref.watch(_getFollowingAndOnlinesProvider);

    return followingAndOnlines.when(
      data: (data) {
        IList<User> following = data.$1;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            if (following.isEmpty) {
              return Center(child: Text(context.l10n.mobileNotFollowingAnyUser));
            }
            return SafeArea(
              child: ColoredBox(
                color:
                    Theme.of(context).platform == TargetPlatform.iOS
                        ? CupertinoColors.systemBackground.resolveFrom(context)
                        : Colors.transparent,
                child: ListView.separated(
                  itemCount: following.length,
                  separatorBuilder:
                      (context, index) =>
                          const PlatformDivider(height: 1, cupertinoHasLeading: true),
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
                        _isOnline(user, data.$2),
                        onTap:
                            () => {
                              pushPlatformRoute(
                                context,
                                builder: (context) => UserScreen(user: user.lightUser),
                              ),
                            },
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
      error: (error, stackTrace) {
        debugPrint('SEVERE: [FollowingScreen] could not load following users; $error\n$stackTrace');
        return FullScreenRetryRequest(onRetry: () => ref.invalidate(followingProvider));
      },
      loading: () => const CenterLoadingIndicator(),
    );
  }

  bool _isOnline(User user, IList<LightUser> followingOnlines) {
    return followingOnlines.any((v) => v.id == user.id);
  }
}
