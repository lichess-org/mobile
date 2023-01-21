import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lichess_mobile/src/constants.dart';

import 'package:lichess_mobile/src/utils/style.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/common/lichess_icons.dart';
import 'package:lichess_mobile/src/common/lichess_colors.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

import '../model/leaderboard.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({required this.leaderboard, super.key});
  final Leaderboard leaderboard;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(context.l10n.leaderboard),
        ),
        child: CustomScrollView(slivers: [
          SliverSafeArea(
              sliver: SliverPadding(
                  padding: kBodyPadding,
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(_buildList(context)),
                  )))
        ]));
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.leaderboard),
      ),
      body: ListView(
        children: _buildList(context),
      ),
    );
  }

  List<Widget> _buildList(BuildContext context) {
    return [
      _buildLeaderboard(
          context, leaderboard.bullet, LichessIcons.bullet, 'Bullet'),
      _buildLeaderboard(
          context, leaderboard.blitz, LichessIcons.blitz, 'Blitz'),
      _buildLeaderboard(
          context, leaderboard.rapid, LichessIcons.rapid, 'Rapid'),
      _buildLeaderboard(
          context, leaderboard.classical, LichessIcons.classical, 'Classical'),
      _buildLeaderboard(context, leaderboard.ultrabullet,
          LichessIcons.ultrabullet, 'Ultra Bullet'),
      _buildLeaderboard(
          context, leaderboard.crazyhouse, LichessIcons.h_square, 'Crazyhouse'),
      _buildLeaderboard(
          context, leaderboard.chess960, LichessIcons.die_six, 'Chess 960'),
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
  const ListCard({required this.user, this.prefIcon, super.key});
  final LightUser user;
  final IconData? prefIcon;

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
          const Spacer(),
        ],
      ),
      trailing: _ratingAndProgress(user),
    );
  }

  Widget _ratingAndProgress(LightUser user) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      if (prefIcon != null) ...[
        Icon(prefIcon, color: LichessColors.brag),
        const SizedBox(width: 5)
      ],
      Text(user.rating.toString()),
      const SizedBox(width: 5),
      if (user.progress < 0)
        IntrinsicWidth(
            stepWidth: 50,
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(LichessIcons.arrow_full_lowerright,
                  color: LichessColors.red),
              Text(
                '${user.progress.abs()} ',
                style: const TextStyle(color: LichessColors.red),
              )
            ]))
      else if (user.progress > 0)
        IntrinsicWidth(
            stepWidth: 50,
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(LichessIcons.arrow_full_upperright,
                  color: LichessColors.good),
              Text('${user.progress} ',
                  style: const TextStyle(color: LichessColors.good))
            ]))
      else
        const SizedBox(width: 50),
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
