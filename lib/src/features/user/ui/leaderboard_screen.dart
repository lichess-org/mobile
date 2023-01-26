import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/utils/style.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/common/lichess_icons.dart';
import 'package:lichess_mobile/src/common/lichess_colors.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/features/user/model/leaderboard.dart';

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
          previousPageTitle: 'Home',
          middle: Text(context.l10n.leaderboard),
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          return CustomScrollView(slivers: [
            SliverSafeArea(
                sliver: SliverPadding(
                    padding: kBodyPadding,
                    sliver: constraints.maxWidth > kLargeScreenWidth
                        ? SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisExtent: 644,
                                    crossAxisCount:
                                        (constraints.maxWidth / 300).floor()),
                            delegate: SliverChildListDelegate(_buildList()))
                        : SliverList(
                            delegate: SliverChildListDelegate(_buildList()),
                          )))
          ]);
        }));
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.leaderboard),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > kLargeScreenWidth) {
            return GridView(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 644,
                crossAxisCount: (constraints.maxWidth / 300).floor(),
              ),
              children: _buildList(),
            );
          } else {
            return ListView(
              children: _buildList(),
            );
          }
        },
      ),
    );
  }

  List<Widget> _buildList() {
    return [
      _BuildLeaderboard(leaderboard.bullet, LichessIcons.bullet, 'BULLET'),
      _BuildLeaderboard(leaderboard.blitz, LichessIcons.blitz, 'BLITZ'),
      _BuildLeaderboard(leaderboard.rapid, LichessIcons.rapid, 'RAPID'),
      _BuildLeaderboard(
          leaderboard.classical, LichessIcons.classical, 'CLASSICAL'),
      _BuildLeaderboard(
          leaderboard.ultrabullet, LichessIcons.ultrabullet, 'ULTRA BULLET'),
      _BuildLeaderboard(
          leaderboard.crazyhouse, LichessIcons.h_square, 'CRAZYHOUSE'),
      _BuildLeaderboard(
          leaderboard.chess960, LichessIcons.die_six, 'CHESS 960'),
      _BuildLeaderboard(
          leaderboard.kingOfThehill, LichessIcons.bullet, 'KING OF THE HILL'),
      _BuildLeaderboard(
          leaderboard.threeCheck, LichessIcons.three_check, 'THREE CHECK'),
      _BuildLeaderboard(leaderboard.atomic, LichessIcons.atom, 'ATOMIC'),
      _BuildLeaderboard(leaderboard.horde, LichessIcons.horde, 'HORDE'),
      _BuildLeaderboard(
          leaderboard.antichess, LichessIcons.antichess, 'ANTICHESS'),
      _BuildLeaderboard(
          leaderboard.racingKings, LichessIcons.racing_kings, 'RACING KINGS'),
    ];
  }
}

class _BuildLeaderboard extends StatelessWidget {
  const _BuildLeaderboard(this.userList, this.iconData, this.title);
  final List<LeaderboardUser> userList;
  final IconData iconData;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(iconData, color: LichessColors.brag),
          title: Text(title),
        ),
        const Divider(),
        ...ListTile.divideTiles(
            color: dividerColor(context),
            context: context,
            tiles: userList.map((user) => LeaderboardListTile(user: user))),
        const SizedBox(height: 12),
      ],
    );
  }
}

class LeaderboardListTile extends StatelessWidget {
  const LeaderboardListTile({required this.user, this.prefIcon});
  final LeaderboardUser user;
  final IconData? prefIcon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _OnlineOrPatron(patron: user.patron, online: user.online),
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
      trailing:
          _RatingAndProgress(user.rating, user.progress, prefIcon: prefIcon),
    );
  }
}

class _RatingAndProgress extends StatelessWidget {
  const _RatingAndProgress(this.rating, this.progress, {this.prefIcon});
  final int rating;
  final int progress;
  final IconData? prefIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (prefIcon != null) ...[
          Flexible(child: Icon(prefIcon, color: LichessColors.brag)),
          const SizedBox(width: 10)
        ],
        const SizedBox(width: 5),
        if (progress < 0)
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(LichessIcons.arrow_full_lowerright,
                  size: 20, color: LichessColors.red),
              SizedBox(
                  width: 30,
                  child: Text(
                    '${progress.abs()} ',
                    style: const TextStyle(color: LichessColors.red),
                  ))
            ],
          )
        else if (progress > 0)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(LichessIcons.arrow_full_upperright,
                  size: 20, color: LichessColors.good),
              SizedBox(
                  width: 30,
                  child: Text(
                    '$progress',
                    style: const TextStyle(color: LichessColors.good),
                  ))
            ],
          )
        else
          const SizedBox(width: 50),
        const SizedBox(width: 5),
        SizedBox(width: 50, child: Text(rating.toString()))
      ],
    );
  }
}

class _OnlineOrPatron extends StatelessWidget {
  const _OnlineOrPatron({this.patron, this.online});
  final bool? patron;
  final bool? online;

  @override
  Widget build(BuildContext context) {
    if (patron != null) {
      return Icon(LichessIcons.patron,
          color: online != null ? LichessColors.good : LichessColors.grey);
    } else {
      return Icon(CupertinoIcons.circle_fill,
          size: 20,
          color: online != null ? LichessColors.good : LichessColors.grey);
    }
  }
}
