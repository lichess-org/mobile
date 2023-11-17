import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/player.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/view/user/user_profile.dart';
import 'package:lichess_mobile/src/view/user/recent_games.dart';
import 'package:lichess_mobile/src/view/user/perf_cards.dart';
import 'package:lichess_mobile/src/view/user/user_activity.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConsumerPlatformWidget(
      ref: ref,
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _buildAndroid(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider);
    return Scaffold(
      appBar: AppBar(
        title: account.when(
          data: (user) => user == null
              ? const SizedBox.shrink()
              : PlayerTitle(
                  userName: user.username,
                  title: user.title,
                  isPatron: user.isPatron,
                ),
          loading: () => const SizedBox.shrink(),
          error: (error, _) => const SizedBox.shrink(),
        ),
      ),
      body: account.when(
        data: (user) {
          if (user == null) {
            return const Center(
              child: Text('You must be logged in to view this page.'),
            );
          }
          return ListView(
            children: [
              UserProfile(user: user),
              const _PerfCards(),
              const UserActivityWidget(),
              const RecentGames(),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) {
          return FullScreenRetryRequest(
            onRetry: () => ref.invalidate(accountProvider),
          );
        },
      ),
    );
  }

  Widget _buildIos(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: account.when(
          data: (user) => user == null
              ? const SizedBox.shrink()
              : PlayerTitle(
                  userName: user.username,
                  title: user.title,
                  isPatron: user.isPatron,
                ),
          loading: () => const SizedBox.shrink(),
          error: (error, _) => const SizedBox.shrink(),
        ),
      ),
      child: account.when(
        data: (user) {
          if (user == null) {
            return const Center(
              child: Text('You must be logged in to view this page.'),
            );
          }
          return SafeArea(
            child: ListView(
              children: [
                UserProfile(user: user),
                const _PerfCards(),
                const UserActivityWidget(),
                const RecentGames(),
              ],
            ),
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, _) {
          return FullScreenRetryRequest(
            onRetry: () => ref.invalidate(accountProvider),
          );
        },
      ),
    );
  }
}

class _PerfCards extends ConsumerWidget {
  const _PerfCards();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider);
    return account.when(
      data: (user) {
        if (user != null) {
          return PerfCards(user: user);
        } else {
          return const SizedBox.shrink();
        }
      },
      loading: () => Shimmer(
        child: Padding(
          padding: Styles.bodySectionPadding,
          child: SizedBox(
            height: 106,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) => ShimmerLoading(
                isLoading: true,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }
}
