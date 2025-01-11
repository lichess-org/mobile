import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/user/leaderboard_screen.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';

/// Create a leaderboard list of the highest rated player for each perf.
///
/// The title routes to a Leaderboard Screen with the top 10 players for each perf.
class LeaderboardWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardState = ref.watch(top1Provider);

    return leaderboardState.when(
      data: (data) {
        return ListSection(
          hasLeading: true,
          header: Text(context.l10n.leaderboard),
          headerTrailing: NoPaddingTextButton(
            onPressed: () {
              pushPlatformRoute(
                context,
                title: context.l10n.leaderboard,
                builder: (context) => const LeaderboardScreen(),
              );
            },
            child: Text(context.l10n.more),
          ),
          children: [
            for (final entry in data.entries)
              LeaderboardListTile(user: entry.value, perfIcon: entry.key.icon),
          ],
        );
      },
      error: (error, stackTrace) {
        debugPrint(
          'SEVERE: [LeaderboardWidget] could not lead leaderboard data; $error\n $stackTrace',
        );
        return const Padding(
          padding: Styles.bodySectionPadding,
          child: Text('Could not load leaderboard.'),
        );
      },
      loading:
          () => Shimmer(
            child: ShimmerLoading(
              isLoading: true,
              child: ListSection.loading(itemsNumber: 5, header: true),
            ),
          ),
    );
  }
}
