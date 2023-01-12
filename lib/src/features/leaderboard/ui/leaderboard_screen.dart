import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';

import 'package:lichess_mobile/src/features/leaderboard/data/leaderboard_repository.dart';
import 'package:lichess_mobile/src/utils/style.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/common/lichess_icons.dart';
import 'package:lichess_mobile/src/common/lichess_colors.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

import '../model/leaderboard.dart';

final leaderListProvider = FutureProvider.autoDispose((ref) async {
  final leaderRepo = ref.watch(leaderboardRepositoryProvider);
  final either = await leaderRepo.getLeaderboard().run();
  return either.match((error) => throw error, (data) {
    ref.keepAlive();
    return data;
  });
});

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }

  Widget _buildIos(BuildContext context) {
    final leaderboardState = ref.watch(leaderListProvider);

    return CupertinoPageScaffold(
        child: CustomScrollView(slivers: [
      CupertinoSliverNavigationBar(
        largeTitle: Text(context.l10n.leaderboard),
      ),
      ...leaderboardState.when(
        data: (data) {
          return [
            SliverSafeArea(
              top: false,
              sliver: SliverList(
                  delegate: SliverChildListDelegate(_buildList(context, data))),
            )
          ];
        },
        error: (error, stackTrack) {
          debugPrint(
              'SEVERE: [LeaderboardScreen] could not lead leaderboard data; ${error.toString()}\n $stackTrack');
          return [
            const SliverFillRemaining(
                child: Center(child: Text('Could not load leaderboard')))
          ];
        },
        loading: () => [const CircularProgressIndicator.adaptive()],
      )
    ]));
  }

  Widget _buildAndroid(BuildContext context) {
    final leaderboardState = ref.watch(leaderListProvider);

    return Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.leaderboard),
        ),
        body: leaderboardState.when(
            data: (data) {
              return ListView(
                children: _buildList(context, data),
              );
            },
            error: (error, stackTrace) {
              debugPrint(
                  'SEVERE: [LeaderboardScreen] cound not load leaderboard data; ${error.toString()}\n $stackTrace');
              return const Text('could not load leaderboard');
            },
            loading: () => const CenterLoadingIndicator()));
  }

  List<Widget> _buildList(BuildContext context, Leaderboard leaderboard) {
    return [
      _buildLeaderboard(
          context, leaderboard.bullet, LichessIcons.bullet, 'Bullet'),
      _buildLeaderboard(
          context, leaderboard.blitz, LichessIcons.blitz, 'Blitz'),
      _buildLeaderboard(
          context, leaderboard.rapid, LichessIcons.rapid, 'Rapid'),
      _buildLeaderboard(
          context, leaderboard.classical, LichessIcons.classical, 'Classical'),
      _buildLeaderboard(context, leaderboard.ultrabullet, LichessIcons.bullet,
          'Ultra Bullet'),
      _buildLeaderboard(context, leaderboard.crazyhouse, LichessIcons.blitz,
          'Crazyhouse'), // no icon
      _buildLeaderboard(context, leaderboard.chess960, LichessIcons.chess_king,
          'Chess 960'), // no icon
      _buildLeaderboard(context, leaderboard.kingOfThehill, LichessIcons.bullet,
          'King of The Hill'),
      _buildLeaderboard(context, leaderboard.threeCheck,
          LichessIcons.three_check, 'Three Check'),
      _buildLeaderboard(
          context, leaderboard.atomic, LichessIcons.atom, 'Atomic'),
      _buildLeaderboard(
          context, leaderboard.horde, LichessIcons.horde, 'Horde'),
      _buildLeaderboard(
          context, leaderboard.antichess, LichessIcons.antichess, 'Antichess'),
      _buildLeaderboard(context, leaderboard.racingKings,
          LichessIcons.racing_kings, 'Racing Kings'),
    ];
  }

  Widget _buildLeaderboard(BuildContext context, List<LightUser> userList,
      IconData iconData, String title) {
    return Column(
      children: [
        ListTile(
            leading: Icon(iconData, color: LichessColors.brag),
            title: Text(title)),
        ..._leaderboardList(context, userList),
        const SizedBox(height: 12),
      ],
    );
  }

  List<Widget> _leaderboardList(
      BuildContext context, List<LightUser> userList) {
    return ListTile.divideTiles(
            color: dividerColor(context),
            context: context,
            tiles: userList.map((user) => ListCard(user: user)))
        .toList(growable: false);
  }
}

class ListCard extends StatelessWidget {
  const ListCard({required this.user, super.key});
  final LightUser user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _onlineOrPatron(user),
      title: Row(
        children: [
          if (user.title != null) ...[
            Text(user.title!,
                style: const TextStyle(
                    color: LichessColors.brag, fontWeight: FontWeight.bold)),
            const SizedBox(width: 5)
          ],
          Text(user.username, overflow: TextOverflow.ellipsis),
        ],
      ),
      trailing: _ratingAndProgress(user),
    );
  }

  Widget _ratingAndProgress(LightUser user) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Text('${user.rating}'),
      if (user.progress < 0)
        Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(CupertinoIcons.arrow_down_right, color: LichessColors.red),
          Text(
            '${user.progress.abs()} ',
            style: const TextStyle(color: LichessColors.red),
          )
        ])
      else if (user.progress > 0)
        Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(CupertinoIcons.arrow_up_right, color: LichessColors.good),
          Text('${user.progress} ',
              style: const TextStyle(color: LichessColors.good))
        ]),
    ]);
  }

  Widget _onlineOrPatron(LightUser user) {
    if (user.patron != null) {
      return Icon(LichessIcons.patron,
          color: user.online != null ? LichessColors.good : LichessColors.grey);
    } else {
      return Icon(CupertinoIcons.circle,
          color: user.online != null ? LichessColors.good : LichessColors.grey);
    }
  }
}
