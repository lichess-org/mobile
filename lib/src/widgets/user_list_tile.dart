import 'package:cached_network_image/cached_network_image.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/lichess_assets.dart';
import 'package:lichess_mobile/src/widgets/list.dart';

class UserListTile extends StatelessWidget {
  const UserListTile._(
    this.username,
    this.title,
    this.isOnline,
    this.isPatron,
    this.flair,
    this.onTap,
    this.userPerfs,
  );

  factory UserListTile.fromUser(User user, bool isOnline, {VoidCallback? onTap}) {
    return UserListTile._(
      user.username,
      user.title,
      isOnline,
      user.isPatron,
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
      user.isPatron,
      user.flair,
      onTap,
      null,
    );
  }

  final String? title;
  final String username;
  final String? flair;
  final bool? isOnline;
  final bool? isPatron;
  final VoidCallback? onTap;

  final IMap<Perf, UserPerf>? userPerfs;

  @override
  Widget build(BuildContext context) {
    return PlatformListTile(
      onTap: onTap != null ? () => onTap?.call() : null,
      padding: Theme.of(context).platform == TargetPlatform.iOS ? Styles.bodyPadding : null,
      leading: Icon(
        isOnline == true ? Icons.cloud : Icons.cloud_off,
        color: isOnline == true ? context.lichessColors.good : null,
      ),
      title: Padding(
        padding: const EdgeInsets.only(right: 5.0),
        child: Row(
          children: [
            if (isPatron == true) ...[
              Icon(LichessIcons.patron, semanticLabel: context.l10n.patronLichessPatron),
              const SizedBox(width: 5),
            ],
            if (title != null) ...[
              Text(
                title!,
                style: TextStyle(color: context.lichessColors.brag, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 5),
            ],
            Flexible(child: Text(maxLines: 1, overflow: TextOverflow.ellipsis, username)),
            if (flair != null) ...[
              const SizedBox(width: 5),
              CachedNetworkImage(
                imageUrl: lichessFlairSrc(flair!),
                errorWidget: (_, _, _) => kEmptyWidget,
                width: DefaultTextStyle.of(context).style.fontSize,
                height: DefaultTextStyle.of(context).style.fontSize,
              ),
            ],
          ],
        ),
      ),
      subtitle: userPerfs != null ? _UserRating(perfs: userPerfs!) : null,
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
          return p != null && p.numberOfGamesOrRuns > 0 && p.ratingDeviation < kClueLessDeviation;
        })
        .toList(growable: false);

    if (userPerfs.isEmpty) return const SizedBox.shrink();

    userPerfs.sort(
      (p1, p2) => perfs[p1]!.numberOfGamesOrRuns.compareTo(perfs[p2]!.numberOfGamesOrRuns),
    );
    userPerfs = userPerfs.reversed.toList();

    final rating = perfs[userPerfs.first]?.rating.toString() ?? '?';
    final icon = userPerfs.first.icon;

    return Row(children: [Icon(icon, size: 16), const SizedBox(width: 5), Text(rating)]);
  }
}
