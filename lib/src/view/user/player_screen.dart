import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/relation/online_friends.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/utils/focus_detector.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/account/rating_pref_aware.dart';
import 'package:lichess_mobile/src/view/relation/friend_screen.dart';
import 'package:lichess_mobile/src/view/user/leaderboard_widget.dart';
import 'package:lichess_mobile/src/view/user/online_bots_screen.dart';
import 'package:lichess_mobile/src/view/user/search_screen.dart';
import 'package:lichess_mobile/src/view/user/user_screen.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/platform_search_bar.dart';

class PlayerScreen extends ConsumerWidget {
  const PlayerScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const PlayerScreen());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FocusDetector(
      onFocusRegained: () {
        ref.read(onlineFriendsProvider.notifier).startWatchingFriends();
      },
      onFocusLost: () {
        if (context.mounted) {
          ref.read(onlineFriendsProvider.notifier).stopWatchingFriends();
        }
      },
      child: PlatformScaffold(
        appBar: PlatformAppBar(title: Text(context.l10n.players)),
        body: _Body(),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionProvider);
    final onlineFriends = ref.watch(onlineFriendsProvider);
    final onlineBots = ref.watch(onlineBotsProvider);
    final top1 = ref.watch(top1Provider);

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: PlatformSearchBar(
            hintText: context.l10n.searchSearch,
            focusNode: AlwaysDisabledFocusNode(),
            onTap: () => Navigator.of(context).push(
              SearchScreen.buildRoute(
                context,
                onUserTap: (user) {
                  Navigator.of(context).push(UserScreen.buildRoute(context, user));
                },
              ),
            ),
          ),
        ),
        if (session != null) OnlineFriendsWidget(onlineFriends: onlineFriends),
        OnlineBotsWidget(onlineBots: onlineBots),
        RatingPrefAware(child: LeaderboardWidget(top1: top1)),
      ],
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
