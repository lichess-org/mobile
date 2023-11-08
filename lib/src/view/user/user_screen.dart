import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/player.dart';
import 'package:lichess_mobile/src/view/user/recent_games.dart';

import 'user_profile.dart';
import 'perf_cards.dart';
import 'user_activity.dart';

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
        title: PlayerTitle(
          userName: user.name,
          title: user.title,
          isPatron: user.isPatron,
        ),
      ),
      body: asyncUser.when(
        data: (user) {
          return ListView(
            children: [
              UserProfile(user: user),
              PerfCards(user: user),
              UserActivityWidget(user: user),
              RecentGames(user: user.lightUser),
            ],
          );
        },
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
        middle: PlayerTitle(
          userName: user.name,
          title: user.title,
          isPatron: user.isPatron,
        ),
      ),
      child: asyncUser.when(
        data: (user) => SafeArea(
          child: ListView(
            children: [
              UserProfile(user: user),
              PerfCards(user: user),
              UserActivityWidget(user: user),
              RecentGames(user: user.lightUser),
            ],
          ),
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
