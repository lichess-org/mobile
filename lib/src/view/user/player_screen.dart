import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/relation/online_friends.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/focus_detector.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/account/rating_pref_aware.dart';
import 'package:lichess_mobile/src/view/relation/following_screen.dart';
import 'package:lichess_mobile/src/view/user/leaderboard_widget.dart';
import 'package:lichess_mobile/src/view/user/online_bots_screen.dart';
import 'package:lichess_mobile/src/view/user/search_screen.dart';
import 'package:lichess_mobile/src/view/user/user_context_menu.dart';
import 'package:lichess_mobile/src/view/user/user_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';
import 'package:lichess_mobile/src/widgets/platform_search_bar.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';

class PlayerScreen extends ConsumerWidget {
  const PlayerScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const PlayerScreen());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onUserTap(LightUser user) =>
        Navigator.of(context).push(UserScreen.buildRoute(context, user));

    final searchButton = PreferredSize(
      preferredSize: Size.fromHeight(
        Theme.of(context).platform == TargetPlatform.iOS
            ? kMinInteractiveDimensionCupertino + 16.0
            : kToolbarHeight,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: PlatformSearchBar(
          hintText: context.l10n.searchSearch,
          focusNode: AlwaysDisabledFocusNode(),
          onTap:
              () => Navigator.of(
                context,
              ).push(SearchScreen.buildRoute(context, onUserTap: onUserTap)),
        ),
      ),
    );

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
        appBarTitle: Text(context.l10n.players),
        appBarBottom: searchButton,
        body: _Body(),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionProvider);

    return ListView(
      children: [
        if (session != null) _OnlineFriendsWidget(),
        const OnlineBotsWidget(),
        RatingPrefAware(child: LeaderboardWidget()),
      ],
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class _OnlineFriendsWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncFriends = ref.watch(onlineFriendsProvider);

    return asyncFriends.when(
      data: (data) {
        return ListSection(
          header: Text(context.l10n.nbFriendsOnline(data.length)),
          headerTrailing:
              data.isEmpty
                  ? null
                  : NoPaddingTextButton(
                    onPressed: () => _handleTap(context, data),
                    child: Text(context.l10n.more),
                  ),
          children: [
            if (data.isEmpty)
              ListTile(
                title: Text(context.l10n.friends),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _handleTap(context, data),
              ),
            for (final user in data)
              ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: UserFullNameWidget(user: user),
                ),
                onTap: () => Navigator.of(context).push(UserScreen.buildRoute(context, user)),
                onLongPress:
                    () => showAdaptiveBottomSheet<void>(
                      context: context,
                      useRootNavigator: true,
                      isDismissible: true,
                      isScrollControlled: true,
                      showDragHandle: true,
                      builder: (context) => UserContextMenu(userId: user.id),
                    ),
              ),
          ],
        );
      },
      error: (error, stackTrace) {
        debugPrint(
          'SEVERE: [PlayerScreen] could not load following online users; $error\n $stackTrace',
        );
        return const Center(child: Text('Could not load online friends'));
      },
      loading:
          () => Shimmer(
            child: ShimmerLoading(
              isLoading: true,
              child: ListSection.loading(itemsNumber: 3, header: true),
            ),
          ),
    );
  }

  void _handleTap(BuildContext context, IList<LightUser> followingOnlines) {
    Navigator.of(context).push(FollowingScreen.buildRoute(context));
  }
}
