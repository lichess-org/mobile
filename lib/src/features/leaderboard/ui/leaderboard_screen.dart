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
          context, leaderboard.bullet, LichessIcons.bullet, 'BULLET'),
      _buildLeaderboard(
          context, leaderboard.blitz, LichessIcons.blitz, 'BLITZ'),
      _buildLeaderboard(
          context, leaderboard.rapid, LichessIcons.rapid, 'RAPID'),
      _buildLeaderboard(
          context, leaderboard.classical, LichessIcons.classical, 'CLASSICAL'),
      _buildLeaderboard(context, leaderboard.ultrabullet,
          LichessIcons.ultrabullet, 'ULTRA BULLET'),
      _buildLeaderboard(
          context, leaderboard.crazyhouse, LichessIcons.h_square, 'CRAZYHOUSE'),
      _buildLeaderboard(
          context, leaderboard.chess960, LichessIcons.die_six, 'CHESS 960'),
      _buildLeaderboard(context, leaderboard.kingOfThehill, LichessIcons.bullet,
          'KING OF THE HILL'),
      _buildLeaderboard(context, leaderboard.threeCheck,
          LichessIcons.three_check, 'THREE CHECK'),
      _buildLeaderboard(
          context, leaderboard.atomic, LichessIcons.atom, 'ATOMIC'),
      _buildLeaderboard(
          context, leaderboard.horde, LichessIcons.horde, 'HORDE'),
      _buildLeaderboard(
          context, leaderboard.antichess, LichessIcons.antichess, 'ANTICHESS'),
      _buildLeaderboard(context, leaderboard.racingKings,
          LichessIcons.racing_kings, 'RACING KINGS'),
    ];
  }

  Widget _buildLeaderboard(BuildContext context, List<LightUser> userList,
      IconData iconData, String title) {
    return Column(
      children: [
        Material(
          color: LichessColors.brag,
          child: ListTile(
            leading: Icon(iconData, color: const Color(0xFFFFFFFF)),
            title: Text(title),
          ),
        ),
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
          Flexible(
            child: Text(user.username, overflow: TextOverflow.ellipsis),
          ),
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
      const SizedBox(width: 5),
      if (user.progress < 0)
        Row(mainAxisSize: MainAxisSize.max, children: [
          const Icon(LichessIcons.arrow_full_lowerright,
              size: 20, color: LichessColors.red),
          Text(
            '${user.progress.abs()} ',
            textWidthBasis: TextWidthBasis.parent,
            style: const TextStyle(color: LichessColors.red),
          )
        ])
      else if (user.progress > 0)
        Row(mainAxisSize: MainAxisSize.max, children: [
          const Icon(LichessIcons.arrow_full_upperright,
              size: 20, color: LichessColors.good),
          Text('${user.progress} ',
              style: const TextStyle(color: LichessColors.good))
        ]),
      const SizedBox(width: 5),
      Flexible(child: Text(user.rating.toString()))
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
