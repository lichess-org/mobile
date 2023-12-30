import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/widgets/list.dart';

class UserListTile extends StatelessWidget {
  const UserListTile._(
    this.username,
    this.title,
    this.isOnline,
    this.isPatron,
    this.onTap,
    this.isFullUser,
    this.userPerfs,
  );

  factory UserListTile.fromUser(
    User user,
    bool isOnline, {
    VoidCallback? onTap,
  }) {
    return UserListTile._(
      user.username,
      user.title,
      isOnline,
      user.isPatron,
      onTap,
      true,
      user.perfs,
    );
  }

  factory UserListTile.fromLightUser(LightUser user, {VoidCallback? onTap}) {
    return UserListTile._(
      user.name,
      user.title,
      user.isOnline,
      user.isPatron,
      onTap,
      false,
      null,
    );
  }

  final String? title;
  final String username;
  final VoidCallback? onTap;
  final bool? isOnline;
  final bool? isPatron;

  final bool isFullUser;
  final IMap<Perf, UserPerf>? userPerfs;

  @override
  Widget build(BuildContext context) {
    return PlatformListTile(
      onTap: onTap != null ? () => onTap?.call() : null,
      padding: defaultTargetPlatform == TargetPlatform.iOS
          ? Styles.bodyPadding
          : null,
      leading: _OnlineOrPatron(
        patron: isPatron,
        online: isOnline,
      ),
      title: Padding(
        padding: const EdgeInsets.only(right: 5.0),
        child: Row(
          children: [
            if (title != null) ...[
              Text(
                title!,
                style: const TextStyle(
                  color: LichessColors.brag,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 5),
            ],
            Flexible(
              child: Text(
                username,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      subtitle: isFullUser ? _UserRating(perfs: userPerfs!) : null,
    );
  }
}

class _UserRating extends StatelessWidget {
  const _UserRating({required this.perfs});

  final IMap<Perf, UserPerf> perfs;

  @override
  Widget build(BuildContext context) {
    List<Perf> userPerfs = Perf.values.where((element) {
      final p = perfs[element];
      return p != null &&
          p.numberOfGames > 0 &&
          p.ratingDeviation < kClueLessDeviation;
    }).toList(growable: false);

    if (userPerfs.isEmpty) return const SizedBox.shrink();

    userPerfs.sort(
      (p1, p2) => perfs[p1]!.numberOfGames.compareTo(perfs[p2]!.numberOfGames),
    );
    userPerfs = userPerfs.reversed.toList();

    final rating = perfs[userPerfs.first]?.rating.toString() ?? '?';
    final icon = userPerfs.first.icon;

    return Row(
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 5),
        Text(rating),
      ],
    );
  }
}

class _OnlineOrPatron extends StatelessWidget {
  const _OnlineOrPatron({
    required this.patron,
    required this.online,
  });

  final bool? patron;
  final bool? online;

  @override
  Widget build(BuildContext context) {
    if (patron != null) {
      return Icon(
        LichessIcons.patron,
        color:
            online != null && online! ? LichessColors.good : LichessColors.grey,
      );
    } else {
      return Icon(
        CupertinoIcons.circle_fill,
        size: 20,
        color:
            online != null && online! ? LichessColors.good : LichessColors.grey,
      );
    }
  }
}
