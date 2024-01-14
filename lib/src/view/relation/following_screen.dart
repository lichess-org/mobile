import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lichess_mobile/src/model/relation/relation_ctrl.dart';
import 'package:lichess_mobile/src/model/relation/relation_repository_providers.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/user/user_screen.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/user_list_tile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'following_screen.g.dart';

@riverpod
Future<(IList<User>, IList<LightUser>)> _getFollowingAndOnlines(
  _GetFollowingAndOnlinesRef ref,
) async {
  final following = await ref.watch(followingProvider.future);
  final onlines = await ref.watch(relationCtrlProvider.future);
  return (following, onlines.followingOnlines);
}

class FollowingScreen extends StatelessWidget {
  const FollowingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }

  Widget _buildIos(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(),
      child: _Body(),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.following),
      ),
      body: const _Body(),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followingAndOnlines = ref.watch(
      _getFollowingAndOnlinesProvider,
    );

    return followingAndOnlines.when(
      data: (data) {
        IList<User> following = data.$1;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            if (following.isEmpty) {
              return const Center(
                child: Text('You are not following any user'),
              );
            }
            return SafeArea(
              child: ColoredBox(
                color: defaultTargetPlatform == TargetPlatform.iOS
                    ? CupertinoColors.systemBackground.resolveFrom(context)
                    : Colors.transparent,
                child: ListView.separated(
                  itemCount: following.length,
                  separatorBuilder: (context, index) => const PlatformDivider(
                    height: 1,
                    cupertinoHasLeading: true,
                  ),
                  itemBuilder: (context, index) {
                    final user = following[index];
                    return Slidable(
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        extentRatio: 0.3,
                        children: [
                          SlidableAction(
                            onPressed: (BuildContext context) async {
                              final oldState = following;
                              setState(() {
                                following = following.removeWhere(
                                  (v) => v.id == user.id,
                                );
                              });

                              final res = await ref
                                  .read(relationRepositoryProvider)
                                  .unfollow(user.username);
                              if (res.isError) {
                                setState(() {
                                  following = oldState;
                                });
                              }
                            },
                            backgroundColor: LichessColors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.person_remove,
                            label: 'Unfollow',
                          ),
                        ],
                      ),
                      child: UserListTile.fromUser(
                        user,
                        _isOnline(user, data.$2),
                        onTap: () => {
                          pushPlatformRoute(
                            context,
                            builder: (context) => UserScreen.fromLightUser(
                              lightUser: user.lightUser,
                            ),
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
        debugPrint(
          'SEVERE: [FollowingScreen] could not load following users; $error\n$stackTrace',
        );
        return FullScreenRetryRequest(
          onRetry: () => ref.invalidate(followingProvider),
        );
      },
      loading: () => const CenterLoadingIndicator(),
    );
  }

  bool _isOnline(User user, IList<LightUser> followingOnlines) {
    return followingOnlines.any((v) => v.id == user.id);
  }
}
