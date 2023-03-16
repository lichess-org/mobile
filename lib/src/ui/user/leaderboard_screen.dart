import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/common/lichess_icons.dart';
import 'package:lichess_mobile/src/common/lichess_colors.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/model/user/leaderboard.dart';
import 'package:lichess_mobile/src/ui/user/user_screen.dart';

/// Create a Screen with Top 10 players for each Lichess Variant
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
      child: _Body(leaderboard: leaderboard),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.leaderboard),
      ),
      body: _Body(leaderboard: leaderboard),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.leaderboard});
  final Leaderboard leaderboard;

  @override
  Widget build(BuildContext context) {
    final List<Widget> list = [
      _Leaderboard(leaderboard.bullet, LichessIcons.bullet, 'BULLET'),
      _Leaderboard(leaderboard.blitz, LichessIcons.blitz, 'BLITZ'),
      _Leaderboard(leaderboard.rapid, LichessIcons.rapid, 'RAPID'),
      _Leaderboard(
        leaderboard.classical,
        LichessIcons.classical,
        'CLASSICAL',
      ),
      _Leaderboard(
        leaderboard.ultrabullet,
        LichessIcons.ultrabullet,
        'ULTRA BULLET',
      ),
      _Leaderboard(
        leaderboard.crazyhouse,
        LichessIcons.h_square,
        'CRAZYHOUSE',
      ),
      _Leaderboard(
        leaderboard.chess960,
        LichessIcons.die_six,
        'CHESS 960',
      ),
      _Leaderboard(
        leaderboard.kingOfThehill,
        LichessIcons.bullet,
        'KING OF THE HILL',
      ),
      _Leaderboard(
        leaderboard.threeCheck,
        LichessIcons.three_check,
        'THREE CHECK',
      ),
      _Leaderboard(leaderboard.atomic, LichessIcons.atom, 'ATOMIC'),
      _Leaderboard(leaderboard.horde, LichessIcons.horde, 'HORDE'),
      _Leaderboard(
        leaderboard.antichess,
        LichessIcons.antichess,
        'ANTICHESS',
      ),
      _Leaderboard(
        leaderboard.racingKings,
        LichessIcons.racing_kings,
        'RACING KINGS',
        showDivider: false,
      ),
    ];

    return SafeArea(
      child: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount =
                math.min(3, (constraints.maxWidth / 300).floor());
            return LayoutGrid(
              columnSizes: List.generate(
                crossAxisCount,
                (_) => 1.fr,
              ),
              rowSizes: List.generate(
                (list.length / crossAxisCount).ceil(),
                (_) => auto,
              ),
              children: list,
            );
          },
        ),
      ),
    );
  }
}

/// A List Tile for the Leaderboard
///
/// Optionaly Provide the [perfIcon] for the Variant of the List
class LeaderboardListTile extends StatelessWidget {
  const LeaderboardListTile({required this.user, this.perfIcon});
  final LeaderboardUser user;
  final IconData? perfIcon;

  @override
  Widget build(BuildContext context) {
    return PlatformListTile(
      onTap: () => _handleTap(context),
      leading: _OnlineOrPatron(patron: user.patron, online: user.online),
      title: Padding(
        padding: const EdgeInsets.only(right: 5.0),
        child: Row(
          children: [
            if (user.title != null) ...[
              Text(
                user.title!,
                style: const TextStyle(
                  color: LichessColors.brag,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 5)
            ],
            Flexible(
              child: Text(user.username, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
      subtitle: perfIcon != null
          ? Row(
              children: [
                Icon(perfIcon, size: 16),
                const SizedBox(width: 5),
                Text(user.rating.toString()),
              ],
            )
          : null,
      trailing: perfIcon != null
          ? _Progress(user.progress)
          : Text(user.rating.toString()),
    );
  }

  void _handleTap(BuildContext context) {
    pushPlatformRoute(
      context,
      builder: (context) => UserScreen(
        user: user.lightUser,
      ),
    );
  }
}

class _Progress extends StatelessWidget {
  const _Progress(this.progress);
  final int progress;

  @override
  Widget build(BuildContext context) {
    if (progress == 0) return const SizedBox.shrink();
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          progress > 0
              ? LichessIcons.arrow_full_upperright
              : LichessIcons.arrow_full_lowerright,
          size: 16,
          color: progress > 0 ? LichessColors.good : LichessColors.red,
        ),
        Text(
          '${progress.abs()}',
          maxLines: 1,
          style: TextStyle(
            fontSize: 12,
            color: progress > 0 ? LichessColors.good : LichessColors.red,
          ),
        )
      ],
    );
  }
}

class _Leaderboard extends StatelessWidget {
  const _Leaderboard(
    this.userList,
    this.iconData,
    this.title, {
    this.showDivider = true,
  });
  final List<LeaderboardUser> userList;
  final IconData iconData;
  final String title;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: ListSection(
        hasLeading: true,
        showDivider: showDivider,
        header: Row(
          children: [
            Icon(iconData, color: LichessColors.brag),
            const SizedBox(width: 10.0),
            Text(title),
          ],
        ),
        children:
            userList.map((user) => LeaderboardListTile(user: user)).toList(),
      ),
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
      return Icon(
        LichessIcons.patron,
        color: online != null ? LichessColors.good : LichessColors.grey,
      );
    } else {
      return Icon(
        CupertinoIcons.circle_fill,
        size: 20,
        color: online != null ? LichessColors.good : LichessColors.grey,
      );
    }
  }
}
