import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_screen.dart';
import 'package:lichess_mobile/src/widgets/list.dart';

class BroadcastTile extends StatelessWidget {
  const BroadcastTile({
    required this.broadcast,
    this.showSubtitle = false,
  });

  final Broadcast broadcast;
  final bool showSubtitle;

  @override
  Widget build(BuildContext context) {
    return PlatformListTile(
      leading: broadcast.tour.image(60.0),
      onTap: () {
        pushPlatformRoute(
          context,
          builder: (context) => BroadcastScreen(
            roundId: broadcast.rounds
                .where((r) => r.status == BroadcastStatus.ongoing)
                .first
                .id,
          ),
        );
      },
      title: Padding(
        padding: const EdgeInsets.only(right: 5.0),
        child: Row(
          children: [
            Flexible(
              child: Text(broadcast.tour.name, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
      subtitle: Text(broadcast.tour.description),
      isThreeLine: showSubtitle,
    );
  }
}
