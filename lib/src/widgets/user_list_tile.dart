import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/widgets/user.dart';

class UserListTile extends StatelessWidget {
  const UserListTile._(
    this.username,
    this.title,
    this.isOnline,
    this.patronColor,
    this.flair,
    this.onTap,
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
      user.patronColor,
      user.flair,
      onTap,
      user.perfs,
    );
  }

  factory UserListTile.fromLightUser(LightUser user, {VoidCallback? onTap}) {
    return UserListTile._(
      user.name,
      user.title,
      user.isOnline,
      user.patronColor,
      user.flair,
      onTap,
      null,
    );
  }

  final String? title;
  final String username;
  final String? flair;
  final bool? isOnline;
  final int? patronColor;
  final VoidCallback? onTap;

  final IMap<Perf, UserPerf>? userPerfs;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap != null ? () => onTap?.call() : null,
      title: UserFullNameWidget(
        shouldShowOnline: true,
        user: LightUser(
          id: UserId.fromUserName(username),
          name: username,
          title: title,
          flair: flair,
          patronColor: patronColor,
          isOnline: isOnline,
        ),
      ),
      trailing: userPerfs != null ? _UserRating(perfs: userPerfs!) : null,
    );
  }
}

class _UserRating extends StatelessWidget {
  const _UserRating({required this.perfs});

  final IMap<Perf, UserPerf> perfs;

  @override
  Widget build(BuildContext context) {
    List<Perf> userPerfs = Perf.values
        .where((element) {
          final p = perfs[element];
          return p != null &&
              p.numberOfGamesOrRuns > 0 &&
              p.ratingDeviation < kClueLessDeviation;
        })
        .toList(growable: false);

    if (userPerfs.isEmpty) return const SizedBox.shrink();

    userPerfs.sort(
      (p1, p2) => perfs[p1]!.numberOfGamesOrRuns.compareTo(
        perfs[p2]!.numberOfGamesOrRuns,
      ),
    );
    userPerfs = userPerfs.reversed.toList();

    final rating = perfs[userPerfs.first]?.rating.toString() ?? '?';
    final icon = userPerfs.first.icon;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [Icon(icon, size: 16), const SizedBox(width: 5), Text(rating)],
    );
  }
}
