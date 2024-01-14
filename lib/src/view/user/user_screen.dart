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
  const UserScreen({required this.user, super.key});

  final LightUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConsumerPlatformWidget(
      ref: ref,
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _buildAndroid(BuildContext context, WidgetRef ref) {
    final asyncUser = ref.watch(userProvider(id: user.id));
    return Scaffold(
      appBar: AppBar(
        title: UserFullNameWidget(user: user),
      ),
      body: asyncUser.when(
        data: (user) => _UserProfileListView(user),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) {
          return FullScreenRetryRequest(
            onRetry: () => ref.invalidate(userProvider(id: user.id)),
          );
        },
      ),
    );
  }

  Widget _buildIos(BuildContext context, WidgetRef ref) {
    final asyncUser = ref.watch(userProvider(id: user.id));
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: UserFullNameWidget(user: user),
      ),
      child: asyncUser.when(
        data: (user) => SafeArea(
          child: _UserProfileListView(user),
        ),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, _) {
          return FullScreenRetryRequest(
            onRetry: () => ref.invalidate(userProvider(id: user.id)),
          );
        },
      ),
    );
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
