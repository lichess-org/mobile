import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/relation/relation_ctrl.dart';
import 'package:lichess_mobile/src/view/relation/following_screen.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';

class RelationScreen extends ConsumerStatefulWidget {
  const RelationScreen({super.key});
  @override
  ConsumerState<RelationScreen> createState() => _RelationScreenState();
}

class _RelationScreenState extends ConsumerState<RelationScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(relationCtrlProvider.notifier).getFollowingOnlines();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
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

class _Body extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  onPressed: () => _handleTap(context),
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
                onTap: () => _handleTap(context),
              ),
            for (final user in data.followingOnlines)
              PlatformListTile(
                title: Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Row(
                    children: [
                      if (user.title != null) ...[
                        Text(
                          user.title!,
                          style: const TextStyle(
                            color: LichessColors.brag,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 5),
                      ],
                      Flexible(
                        child: Text(
                          user.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
      error: (error, stackTrace) {
        debugPrint(
          'SEVERE: [RelationScreen] could not lead online friends data; $error\n $stackTrace',
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

  void _handleTap(BuildContext context) {
    pushPlatformRoute(
      context,
      title: context.l10n.following,
      builder: (_) => const FollowingScreen(),
    );
  }
}
