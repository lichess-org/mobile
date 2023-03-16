import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/common/lichess_icons.dart';
import 'package:lichess_mobile/src/common/styles.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';

import 'leaderboard_screen.dart';

/// Create a leaderboard list of the highest rated player for each perf.
///
/// The title routes to a Leaderboard Screen with the top 10 players for each perf.
class LeaderboardWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardState = ref.watch(leaderboardProvider);

    return leaderboardState.when(
      data: (data) {
        return ListSection(
          hasLeading: true,
          header: Text(
            context.l10n.leaderboard,
          ),
          onHeaderTap: () {
            pushPlatformRoute(
              context,
              builder: (context) => LeaderboardScreen(
                leaderboard: data,
              ),
            );
          },
          children: [
            LeaderboardListTile(
              user: data.bullet.first,
              perfIcon: LichessIcons.bullet,
            ),
            LeaderboardListTile(
              user: data.blitz.first,
              perfIcon: LichessIcons.blitz,
            ),
            LeaderboardListTile(
              user: data.rapid.first,
              perfIcon: LichessIcons.rapid,
            ),
            LeaderboardListTile(
              user: data.classical.first,
              perfIcon: LichessIcons.classical,
            ),
            LeaderboardListTile(
              user: data.ultrabullet.first,
              perfIcon: LichessIcons.ultrabullet,
            ),
          ],
        );
      },
      error: (error, stackTrace) {
        debugPrint(
          'SEVERE: [LeaderboardWidget] could not lead leaderboard data; $error\n $stackTrace',
        );
        return Padding(
          padding: Styles.bodySectionPadding,
          child: const Text('Could not load leaderboard.'),
        );
      },
      loading: () => const CenterLoadingIndicator(),
    );
  }
}
