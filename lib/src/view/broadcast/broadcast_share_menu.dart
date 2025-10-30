import 'package:flutter/widgets.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:share_plus/share_plus.dart';

Future<void> showBroadcastShareMenu(
  BuildContext context,
  Broadcast broadcast,
) => showAdaptiveActionSheet<void>(
  context: context,
  actions: [
    BottomSheetAction(
      makeLabel: (context) => Text(broadcast.title),
      onPressed: () {
        launchShareDialog(
          context,
          ShareParams(
            uri: lichessUri(
              '/broadcast/${broadcast.tour.slug}/${broadcast.tour.id}',
            ),
          ),
        );
      },
    ),
    BottomSheetAction(
      makeLabel: (context) => Text(broadcast.round.name),
      onPressed: () {
        launchShareDialog(
          context,
          ShareParams(
            uri: lichessUri(
              '/broadcast/${broadcast.tour.slug}/${broadcast.round.slug}/${broadcast.round.id}',
            ),
          ),
        );
      },
    ),
    BottomSheetAction(
      makeLabel: (context) => Text('${broadcast.round.name} PGN'),
      onPressed: () {
        launchShareDialog(
          context,
          ShareParams(
            uri: lichessUri(
              '/broadcast/${broadcast.tour.slug}/${broadcast.round.slug}/${broadcast.round.id}.pgn',
            ),
          ),
        );
      },
    ),
  ],
);
