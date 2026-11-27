import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/tab_navigation.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_round_screen.dart';
import 'package:lichess_mobile/src/widgets/network_image.dart';
import 'package:material_ui/material_ui.dart';

/// Placeholder shown when a tour has no cover photo, or it fails to load.
///
/// Keeps the 2:1 cover ratio so rows stay aligned with photo tiles.
class const BroadcastCalendarFallbackIcon({super.key, required final bool isLive})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: BroadcastCalendarTile.coverWidth,
      height: BroadcastCalendarTile.coverHeight,
      child: Center(
        child: Icon(
          LichessIcons.radio_tower_lichess,
          color: isLive ? context.lichessColors.error : null,
        ),
      ),
    );
  }
}

/// A calendar row styled like the Lichess TV tiles on the Watch tab.
class const BroadcastCalendarTile({required final Broadcast broadcast}) extends StatelessWidget {
  // Cover photo keeps the web header image aspect ratio of 2.
  static const coverWidth = 80.0;
  static const coverHeight = 40.0;

  @override
  Widget build(BuildContext context) {
    final isLive = broadcast.isLive;

    final subtitle = !isLive && broadcast.round.startsAt != null
        ? '${broadcast.round.name} · ${relativeDate(context.l10n, broadcast.round.startsAt!)}'
        : broadcast.round.name;

    final fallbackIcon = BroadcastCalendarFallbackIcon(isLive: isLive);

    return ListTile(
      leading: broadcast.tour.imageUrl != null
          ? SizedBox(
              width: coverWidth,
              height: coverHeight,
              child: ClipRRect(
                borderRadius: .circular(8.0),
                child: HttpNetworkImageWidget(
                  broadcast.tour.imageUrl!,
                  width: coverWidth,
                  height: coverHeight,
                  cacheWidth: (coverWidth * MediaQuery.devicePixelRatioOf(context)).toInt(),
                  fit: .cover,
                  errorBuilder: (context, _, _) => fallbackIcon,
                ),
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
                    style: TextStyle(color: context.lichessColors.error, fontWeight: .bold),
                  ),
                  TextSpan(text: subtitle),
                ],
              ),
            )
          : Text(subtitle),
      trailing: Theme.of(context).platform == .iOS ? const CupertinoListTileChevron() : null,
      onTap: () {
        Navigator.of(context).pushHidingTabBar(BroadcastRoundScreen.buildRoute(broadcast));
      },
    );
  }
}
