import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/styles/transparent_image.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_description_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_game_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/default_broadcast_image.dart';
import 'package:lichess_mobile/src/widgets/list.dart';

class BroadcastTile extends StatelessWidget {
  const BroadcastTile({
    required this.broadcast,
  });

  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    return PlatformListTile(
      leading: (broadcast.tour.imageUrl != null)
          ? FadeInImage.memoryNetwork(
              placeholder: transparentImage,
              image: broadcast.tour.imageUrl!,
              width: 60,
              height: 30,
            )
          : const DefaultBroadcastImage(width: 60),
      onTap: () {
        pushPlatformRoute(
          context,
          builder: (context) => (broadcast.curentRound != null)
              ? BroadcastGameScreen(
                  roundId: broadcast.curentRound!.id,
                )
              : BroadcastDescriptionScreen(
                  broadcast: broadcast,
                ),
        );
      },
      title: Padding(
        padding: const EdgeInsets.only(right: 5.0),
        child: Row(
          children: [
            Flexible(
              child: Text(
                broadcast.tour.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      trailing: (broadcast.rounds.any((r) => r.status == RoundStatus.live))
          ? const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.circle, color: Colors.red, size: 20),
                SizedBox(height: 5),
                Text(
                  'LIVE',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
              ],
            )
          : null,
    );
  }
}
