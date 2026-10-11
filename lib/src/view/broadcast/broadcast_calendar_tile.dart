import 'package:clock/clock.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_round_screen.dart';
import 'package:lichess_mobile/src/widgets/network_image.dart';
import 'package:material_ui/material_ui.dart';

/// A calendar row styled like the Lichess TV tiles on the Watch tab.
class const BroadcastCalendarTile({required final Broadcast broadcast}) extends StatelessWidget {
  static const _coverSize = 52.0;

  @override
  Widget build(BuildContext context) {
    // The calendar payload has no `ongoing` flag, so a round that started and
    // isn't finished counts as live.
    final isLive =
        broadcast.isLive ||
        (broadcast.round.startsAt != null &&
            !broadcast.isFinished &&
            !broadcast.round.startsAt!.isAfter(clock.now()));

    final subtitle = broadcast.round.startsAt != null
        ? '${broadcast.round.name} · ${relativeDate(context.l10n, broadcast.round.startsAt!)}'
        : broadcast.round.name;

    final fallbackIcon = Icon(
      LichessIcons.radio_tower_lichess,
      color: isLive ? context.lichessColors.error : null,
    );

    return ListTile(
      leading: broadcast.tour.imageUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: HttpNetworkImageWidget(
                broadcast.tour.imageUrl!,
                width: _coverSize,
                height: _coverSize,
                fit: BoxFit.cover,
                errorBuilder: (context, _, _) => fallbackIcon,
              ),
            )
          : fallbackIcon,
      title: Text(broadcast.title),
      subtitle: isLive
          ? Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'LIVE · ',
                    style: TextStyle(
                      color: context.lichessColors.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: subtitle),
                ],
              ),
            )
          : Text(subtitle),
      trailing: Theme.of(context).platform == TargetPlatform.iOS
          ? const CupertinoListTileChevron()
          : null,
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(BroadcastRoundScreen.buildRoute(broadcast));
      },
    );
  }
}
