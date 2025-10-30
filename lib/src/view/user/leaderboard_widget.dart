import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/user/leaderboard.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/user/leaderboard_screen.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';

/// Create a leaderboard list of the highest rated player for each perf.
///
/// The title routes to a Leaderboard Screen with the top 10 players for each perf.
class LeaderboardWidget extends ConsumerWidget {
  const LeaderboardWidget({required this.top1, super.key});

  final AsyncValue<Top1Leaderboard> top1;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Shimmer(
      child: switch (top1) {
        AsyncData(:final value) => ListSection(
          hasLeading: true,
          header: Text(context.l10n.leaderboard),
          onHeaderTap: () {
            Navigator.of(context).push(LeaderboardScreen.buildRoute(context));
          },
          children: [
            for (final entry in value.entries)
              LeaderboardListTile(user: entry.value, perfIcon: entry.key.icon),
          ],
        ),
        AsyncError() => const Padding(
          padding: Styles.bodySectionPadding,
          child: Text('Could not load leaderboard.'),
        ),
        _ => ShimmerLoading(
          isLoading: true,
          child: ListSection.loading(
            itemsNumber: 5,
            header: true,
            hasLeading: true,
          ),
        ),
      },
    );
  }
}
