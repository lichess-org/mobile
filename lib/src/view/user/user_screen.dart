import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' show ClientException;
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
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
    final asyncUser = ref.watch(userAndStatusProvider(id: user.id));
    final updatedLightUser = asyncUser.maybeWhen(
      data: (data) => data.$1.lightUser.copyWith(isOnline: data.$2.online),
      orElse: () => null,
    );
    return Scaffold(
      appBar: AppBar(
        title: UserFullNameWidget(
          user: updatedLightUser ?? user,
          shouldShowOnline: updatedLightUser != null,
        ),
      ),
      body: asyncUser.when(
        data: (data) => _UserProfileListView(data.$1),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) {
          if (error is ClientException && error.message.contains('404')) {
            return Center(
              child: Text(
                textAlign: TextAlign.center,
                context.l10n.usernameNotFound(user.name),
                style: Styles.bold,
              ),
            );
          }
          return FullScreenRetryRequest(
            onRetry: () => ref.invalidate(userProvider(id: user.id)),
          );
        },
      ),
    );
  }

  Widget _buildIos(BuildContext context, WidgetRef ref) {
    final asyncUser = ref.watch(userAndStatusProvider(id: user.id));
    final updatedLightUser = asyncUser.maybeWhen(
      data: (data) => data.$1.lightUser.copyWith(isOnline: data.$2.online),
      orElse: () => null,
    );
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: UserFullNameWidget(
          user: updatedLightUser ?? user,
          shouldShowOnline: updatedLightUser != null,
        ),
      ),
      child: asyncUser.when(
        data: (data) => SafeArea(
          child: _UserProfileListView(data.$1),
        ),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, _) {
          if (error is ClientException && error.message.contains('404')) {
            return Center(
              child: Text(
                textAlign: TextAlign.center,
                context.l10n.usernameNotFound(user.name),
                style: Styles.bold,
              ),
            );
          }
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
    if (user.disabled == true) {
      return Center(
        child: Text(
          context.l10n.settingsThisAccountIsClosed,
          style: Styles.bold,
        ),
      );
    }
    return ListView(
      children: [
        UserProfileWidget(user: user),
        PerfCards(user: user, isMe: false),
        UserActivityWidget(user: user),
        RecentGamesWidget(user: user.lightUser),
      ],
    );
  }
}
