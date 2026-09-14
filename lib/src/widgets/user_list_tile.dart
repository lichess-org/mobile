import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/widgets/user.dart';
import 'package:material_ui/material_ui.dart';

class const UserListTile._(
  final String username,
  final String? title,
  final int? patronColor,
  final String? flair,
  final VoidCallback? onTap,
  final IMap<Perf, UserPerf>? userPerfs,
) extends StatelessWidget {
  factory fromUser(User user, {VoidCallback? onTap}) {
    return UserListTile._(
      user.username,
      user.title,
      user.patronColor,
      user.flair,
      onTap,
      user.perfs,
    );
  }

  factory fromLightUser(LightUser user, {VoidCallback? onTap}) {
    return UserListTile._(user.name, user.title, user.patronColor, user.flair, onTap, null);
  }

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

class const _UserRating({required final IMap<Perf, UserPerf> perfs}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userPerfs = perfs.sortedUserPerfs;

    if (userPerfs.isEmpty) return const SizedBox.shrink();

    final rating = perfs[userPerfs.first]?.rating.toString() ?? '?';
    final icon = userPerfs.first.icon;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [Icon(icon, size: 16), const SizedBox(width: 5), Text(rating)],
    );
  }
}
