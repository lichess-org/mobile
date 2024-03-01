import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/relation/relation_ctrl.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/focus_detector.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/relation/following_screen.dart';
import 'package:lichess_mobile/src/view/user/user_screen.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';

class RelationScreen extends ConsumerWidget {
  const RelationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FocusDetector(
      onFocusRegained: () {
        ref.read(relationCtrlProvider.notifier).startWatchingFriends();
      },
      onFocusLost: () {
        if (context.mounted) {
          ref.read(relationCtrlProvider.notifier).stopWatchingFriends();
        }
      },
      child: PlatformWidget(
        androidBuilder: _androidBuilder,
        iosBuilder: _iosBuilder,
      ),
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.friends),
      ),
      body: _Body(),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: [_OnlineFriendsWidget()],
      ),
    );
  }
}

class _OnlineFriendsWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relationState = ref.watch(relationCtrlProvider);

    return relationState.when(
      data: (data) {
        return ListSection(
          header:
              Text(context.l10n.nbFriendsOnline(data.followingOnlines.length)),
          headerTrailing: data.followingOnlines.isEmpty
              ? null
              : NoPaddingTextButton(
                  onPressed: () => _handleTap(context, data.followingOnlines),
                  child: Text(
                    context.l10n.more,
                  ),
                ),
          children: [
            if (data.followingOnlines.isEmpty)
              PlatformListTile(
                title: Text(context.l10n.following),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
                onTap: () => _handleTap(context, data.followingOnlines),
              ),
            for (final user in data.followingOnlines)
              PlatformListTile(
                title: Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: UserFullNameWidget(user: user),
                ),
                onTap: () => pushPlatformRoute(
                  context,
                  title: user.name,
                  builder: (_) => UserScreen(
                    user: user,
                  ),
                ),
              ),
          ],
        );
      },
      error: (error, stackTrace) {
        debugPrint(
          'SEVERE: [RelationScreen] could not load following online users; $error\n $stackTrace',
        );
        return const Center(
          child: Text('Could not load online friends'),
        );
      },
      loading: () => Shimmer(
        child: ShimmerLoading(
          isLoading: true,
          child: ListSection.loading(
            itemsNumber: 3,
            header: true,
          ),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context, IList<LightUser> followingOnlines) {
    pushPlatformRoute(
      context,
      title: context.l10n.following,
      builder: (_) => const FollowingScreen(),
    );
  }
}
