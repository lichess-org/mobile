import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/features/leaderboard/data/leaderboard_repository.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/common/lichess_icons.dart';

import '../model/leaderboard.dart';
import './leaderboard_screen.dart';

final leaderListProvider = FutureProvider.autoDispose((ref) async {
  final leaderRepo = ref.watch(leaderboardRepositoryProvider);
  final either = await leaderRepo.getLeaderboard().run();
  return either.match((error) => throw error, (data) {
    ref.keepAlive();
    return data;
  });
});

class LeaderboardWidget extends ConsumerStatefulWidget {
  const LeaderboardWidget({super.key});

  @override
  ConsumerState<LeaderboardWidget> createState() => _LeaderboardWidgetState();
}

class _LeaderboardWidgetState extends ConsumerState<LeaderboardWidget> {
  @override
  Widget build(BuildContext context) {
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
                  child: ListView(
                shrinkWrap: true,
                children: _buildList(context, data),
              )),
            ]),
          );
        },
        error: (error, stackTrace) {
          debugPrint(
              'SEVERE: [LeaderboardWidget] could not lead leaderboard data; ${error.toString()}\n $stackTrace');
          return const Text('could not lead leaderboard');
        },
        loading: () => const CenterLoadingIndicator());
  }

  List<Widget> _buildList(BuildContext context, Leaderboard leaderboard) {
    return [
      ListCard(user: leaderboard.bullet[0], prefIcon: LichessIcons.bullet),
      ListCard(user: leaderboard.blitz[0], prefIcon: LichessIcons.blitz),
      ListCard(user: leaderboard.rapid[0], prefIcon: LichessIcons.rapid),
      ListCard(
          user: leaderboard.classical[0], prefIcon: LichessIcons.classical),
      ListCard(
          user: leaderboard.ultrabullet[0], prefIcon: LichessIcons.ultrabullet),
      ListCard(
          user: leaderboard.crazyhouse[0], prefIcon: LichessIcons.h_square),
      ListCard(user: leaderboard.chess960[0], prefIcon: LichessIcons.die_six),
      ListCard(
          user: leaderboard.threeCheck[0], prefIcon: LichessIcons.three_check),
      ListCard(user: leaderboard.atomic[0], prefIcon: LichessIcons.atom),
      ListCard(user: leaderboard.horde[0], prefIcon: LichessIcons.horde),
      ListCard(
          user: leaderboard.antichess[0], prefIcon: LichessIcons.antichess),
    ];
  }
}
