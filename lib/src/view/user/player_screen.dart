import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/relation/online_friends.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/focus_detector.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/account/rating_pref_aware.dart';
import 'package:lichess_mobile/src/view/relation/following_screen.dart';
import 'package:lichess_mobile/src/view/user/leaderboard_widget.dart';
import 'package:lichess_mobile/src/view/user/search_screen.dart';
import 'package:lichess_mobile/src/view/user/user_screen.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';
import 'package:lichess_mobile/src/widgets/platform_search_bar.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';

class PlayerScreen extends ConsumerWidget {
  const PlayerScreen({super.key});

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

    return ListView(
      children: [
        const Padding(padding: Styles.bodySectionPadding, child: _SearchButton()),
        if (session != null) _OnlineFriendsWidget(),
        const RatingPrefAware(child: LeaderboardWidget()),
      ],
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class _SearchButton extends StatelessWidget {
  const _SearchButton();

  @override
  Widget build(BuildContext context) {
    void onUserTap(LightUser user) =>
        pushPlatformRoute(context, builder: (ctx) => UserScreen(user: user));

    return PlatformSearchBar(
      hintText: context.l10n.searchSearch,
      focusNode: AlwaysDisabledFocusNode(),
      onTap:
          () => pushPlatformRoute(
            context,
            fullscreenDialog: true,
            builder: (_) => SearchScreen(onUserTap: onUserTap),
          ),
    );
  }
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
              PlatformListTile(
                title: Text(context.l10n.friends),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _handleTap(context, data),
              ),
            for (final user in data)
              PlatformListTile(
                title: Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: UserFullNameWidget(user: user),
                ),
                onTap:
                    () => pushPlatformRoute(
                      context,
                      title: user.name,
                      builder: (_) => UserScreen(user: user),
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
    pushPlatformRoute(
      context,
      title: context.l10n.friends,
      builder: (_) => const FollowingScreen(),
    );
  }
}
