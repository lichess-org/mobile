import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/features/user/data/leaderboard_repository.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/common/lichess_icons.dart';

import 'leaderboard_screen.dart';

final leaderListProvider = FutureProvider.autoDispose((ref) async {
  final leaderRepo = ref.watch(leaderboardRepositoryProvider);
  final either = await leaderRepo.getLeaderboard().run();
  return either.match((error) => throw error, (data) {
    return data;
  });
});

/// Create a leaderboard list of the highest rated player for each Variant
///
/// The title routes to a Leaderboard Screen with the top 10 players for each Variant
class LeaderboardWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardState = ref.watch(leaderListProvider);

    return leaderboardState.when(
        data: (data) {
          return Expanded(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              ListTile(
                title: Text(
                  context.l10n.leaderboard,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.of(context).push<void>(MaterialPageRoute(
                      builder: (context) => LeaderboardScreen(
                            leaderboard: data,
                          )));
                },
                trailing: const Icon(CupertinoIcons.forward),
              ),
              Expanded(
                  child: ListView(shrinkWrap: true, children: [
                LeaderboardListTile(
                    user: data.bullet[0], prefIcon: LichessIcons.bullet),
                LeaderboardListTile(
                    user: data.blitz[0], prefIcon: LichessIcons.blitz),
                LeaderboardListTile(
                    user: data.rapid[0], prefIcon: LichessIcons.rapid),
                LeaderboardListTile(
                    user: data.classical[0], prefIcon: LichessIcons.classical),
                LeaderboardListTile(
                    user: data.ultrabullet[0],
                    prefIcon: LichessIcons.ultrabullet),
                LeaderboardListTile(
                    user: data.crazyhouse[0], prefIcon: LichessIcons.h_square),
                LeaderboardListTile(
                    user: data.chess960[0], prefIcon: LichessIcons.die_six),
                LeaderboardListTile(
                    user: data.threeCheck[0],
                    prefIcon: LichessIcons.three_check),
                LeaderboardListTile(
                    user: data.atomic[0], prefIcon: LichessIcons.atom),
                LeaderboardListTile(
                    user: data.horde[0], prefIcon: LichessIcons.horde),
                LeaderboardListTile(
                    user: data.antichess[0], prefIcon: LichessIcons.antichess),
              ])),
            ]),
          );
        },
        error: (error, stackTrace) {
          debugPrint(
              'SEVERE: [LeaderboardWidget] could not lead leaderboard data; $error\n $stackTrace');
          return const Text('could not lead leaderboard');
        },
        loading: () => const CenterLoadingIndicator());
  }
}
