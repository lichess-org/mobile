import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/common/lichess_icons.dart';
import 'package:lichess_mobile/src/model/user/leaderboard_repository.dart';

final leaderListProvider = FutureProvider.autoDispose((ref) {
  final leaderRepo = ref.watch(leaderboardRepositoryProvider);
  return Result.release(leaderRepo.getLeaderboard());
});

/// Create a leaderboard list of the highest rated player for each perf.
///
/// The title routes to a Leaderboard Screen with the top 10 players for each perf.
class StreamersWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardState = ref.watch(leaderListProvider);

    return leaderboardState.when(
      data: (data) {
        return ListSection(
          hasLeading: true,
          header: Text(
            context.l10n.leaderboard,
          ),
          onHeaderTap: () {
            /*
            Navigator.of(context).push<void>(
              MaterialPageRoute(
                builder: (context) => LeaderboardScreen(
                  leaderboard: data,
                ),
              ),
            );*/
          },
          children: const [
            Text("Goes here"),
          ],
        );
      },
      error: (error, stackTrace) {
        debugPrint(
          'SEVERE: [LeaderboardWidget] could not lead leaderboard data; $error\n $stackTrace',
        );
        return const Text('Could not load leaderboard.');
      },
      loading: () => const CenterLoadingIndicator(),
    );
  }
}
