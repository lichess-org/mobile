import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_round_screen.dart';
import 'package:material_ui/material_ui.dart';

/// A calendar row styled like the Lichess TV tiles on the Watch tab.
class const BroadcastCalendarTile({required final Broadcast broadcast}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final subtitle = broadcast.round.startsAt != null
        ? '${broadcast.round.name} · ${relativeDate(context.l10n, broadcast.round.startsAt!)}'
        : broadcast.round.name;

    return ListTile(
      leading: Icon(
        LichessIcons.radio_tower_lichess,
        color: broadcast.isLive ? context.lichessColors.error : null,
      ),
      title: Text(broadcast.title),
      subtitle: Text(subtitle),
      trailing: Theme.of(context).platform == TargetPlatform.iOS
          ? const CupertinoListTileChevron()
          : null,
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(BroadcastRoundScreen.buildRoute(broadcast));
      },
    );
  }
}
