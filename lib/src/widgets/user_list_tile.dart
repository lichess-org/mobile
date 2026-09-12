import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/widgets/user.dart';
import 'package:material_ui/material_ui.dart';

class UserListTile extends StatelessWidget {
  const UserListTile._(
    this.username,
    this.title,
    this.patronColor,
    this.flair,
    this.onTap,
    this.userPerfs,
  );

  factory UserListTile.fromUser(User user, {VoidCallback? onTap}) {
    return UserListTile._(
      user.username,
      user.title,
      user.patronColor,
      user.flair,
      onTap,
      user.perfs,
    );
  }

  factory UserListTile.fromLightUser(LightUser user, {VoidCallback? onTap}) {
    return UserListTile._(user.name, user.title, user.patronColor, user.flair, onTap, null);
  }

  final String? title;
  final String username;
  final String? flair;
  final int? patronColor;
  final VoidCallback? onTap;

  final IMap<Perf, UserPerf>? userPerfs;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap != null ? () => onTap?.call() : null,
      title: UserFullNameWidget(
        user: LightUser(
          id: UserId.fromUserName(username),
          name: username,
          title: title,
          flair: flair,
          patronColor: patronColor,
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
    final userPerfs = _sortedUserPerfs(perfs);

    if (userPerfs.isEmpty) return const SizedBox.shrink();

    final rating = perfs[userPerfs.first]?.rating.toString() ?? '?';
    final icon = userPerfs.first.icon;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [Icon(icon, size: 16), const SizedBox(width: 5), Text(rating)],
    );
  }
}

/// Perfs with enough rated games, sorted by game count descending.
///
/// This runs in every row of every scrolling user list (leaderboards, search,
/// teams), so the filter + sort is memoized per map instance. [IMap] is
/// immutable, so instance identity implies value identity and the cached list
/// stays valid as long as the map is alive.
final _sortedPerfsCache = Expando<List<Perf>>('sortedUserPerfs');

List<Perf> _sortedUserPerfs(IMap<Perf, UserPerf> perfs) {
  return _sortedPerfsCache[perfs] ??=
      Perf.values
          .where((element) {
            final p = perfs[element];
            return p != null && p.numberOfGamesOrRuns > 0 && p.ratingDeviation < kClueLessDeviation;
          })
          .toList(growable: false)
        ..sort(
          (p1, p2) => perfs[p2]!.numberOfGamesOrRuns.compareTo(perfs[p1]!.numberOfGamesOrRuns),
        );
}
