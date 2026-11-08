import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
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
import 'package:lichess_mobile/src/view/user/user_or_profile_screen.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/platform_search_bar.dart';
import 'package:material_ui/material_ui.dart';

class const PlayerScreen({super.key}) extends ConsumerWidget {
  static Route<dynamic> buildRoute() {
    return buildScreenRoute(screen: const PlayerScreen());
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
        appBar: PlatformAppBar(
          title: Text(context.l10n.players),
          largeTitle: true,
          actions: [
            SearchHeroButton(
              heroTag: SearchScreen.heroTag,
              onPressed: () => Navigator.of(context).push(
                SearchScreen.buildRoute(
                  onUserTap: (user) {
                    Navigator.of(context).push(UserOrProfileScreen.buildRoute(user));
                  },
                ),
              ),
            ),
          ],
        ),
        body: const _Body(),
      ),
    );
  }
}

class const _Body() extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUser = ref.watch(authControllerProvider);
    final onlineFriends = ref.watch(onlineFriendsProvider);
    final onlineBots = ref.watch(onlineBotsProvider);
    final top1 = ref.watch(top1Provider);

    return ListView(
      children: [
        if (authUser != null) OnlineFriendsWidget(onlineFriends: onlineFriends),
        OnlineBotsWidget(onlineBots: onlineBots),
        RatingPrefAware(child: LeaderboardWidget(top1: top1)),
      ],
    );
  }
}
