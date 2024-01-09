import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/view/user/recent_games.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';

import 'perf_cards.dart';
import 'user_activity.dart';
import 'user_profile.dart';

class UserScreen extends ConsumerWidget {
  const UserScreen._({this.lightUser, this.user, super.key})
      : assert(
          (lightUser != null || user != null) &&
              !(lightUser != null && user != null),
          'Either lightUser or User should be provided but not both',
        );

  const factory UserScreen.fromUser({required User user, Key? key}) =
      UserScreen._;

  const factory UserScreen.fromLightUser({
    required LightUser lightUser,
    Key? key,
  }) = UserScreen._;

  final LightUser? lightUser;
  final User? user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConsumerPlatformWidget(
      ref: ref,
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _buildAndroid(BuildContext context, WidgetRef ref) {
    if (user != null) {
      return Scaffold(
        appBar: AppBar(title: UserFullNameWidget(user: user!.lightUser)),
        body: _UserProfileListView(user!),
      );
    } else {
      final asyncUser = ref.watch(userProvider(id: lightUser!.id));
      return Scaffold(
        appBar: AppBar(
          title: UserFullNameWidget(user: lightUser),
        ),
        body: asyncUser.when(
          data: (user) => _UserProfileListView(user),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) {
            return FullScreenRetryRequest(
              onRetry: () => ref.invalidate(userProvider(id: lightUser!.id)),
            );
          },
        ),
      );
    }
  }

  Widget _buildIos(BuildContext context, WidgetRef ref) {
    if (user != null) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: UserFullNameWidget(user: user!.lightUser),
        ),
        child: _UserProfileListView(user!),
      );
    } else {
      final asyncUser = ref.watch(userProvider(id: lightUser!.id));
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: UserFullNameWidget(user: lightUser),
        ),
        child: asyncUser.when(
          data: (user) => SafeArea(
            child: _UserProfileListView(user),
          ),
          loading: () =>
              const Center(child: CircularProgressIndicator.adaptive()),
          error: (error, _) {
            return FullScreenRetryRequest(
              onRetry: () => ref.invalidate(userProvider(id: lightUser!.id)),
            );
          },
        ),
      );
    }
  }
}

class _UserProfileListView extends StatelessWidget {
  const _UserProfileListView(this.user);
  final User user;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        UserProfile(user: user),
        PerfCards(user: user),
        UserActivityWidget(user: user),
        RecentGames(user: user.lightUser),
      ],
    );
  }
}
