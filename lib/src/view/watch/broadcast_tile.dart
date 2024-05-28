import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/widgets/list.dart';

class BroadcastTile extends StatelessWidget {
  const BroadcastTile({required this.broadcast, this.showSubtitle = false});

  final Broadcast broadcast;
  final bool showSubtitle;

  @override
  Widget build(BuildContext context) {
    return PlatformListTile(
      onTap: () => {},
      leading: broadcast.tour.image(60.0),
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
