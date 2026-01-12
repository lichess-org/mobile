import 'package:flutter/widgets.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:share_plus/share_plus.dart';

Future<void> showBroadcastShareMenu(
  BuildContext context,
  BroadcastTournamentData broadcastData,
  BroadcastRound round,
) => showAdaptiveActionSheet<void>(
  context: context,
  actions: [
    BottomSheetAction(
      makeLabel: (context) => Text(broadcastData.name),
      onPressed: () {
        launchShareDialog(
          context,
          ShareParams(uri: lichessUri('/broadcast/${broadcastData.slug}/${broadcastData.id}')),
        );
      },
    ),
    BottomSheetAction(
      makeLabel: (context) => Text(round.name),
      onPressed: () {
        launchShareDialog(
          context,
          ShareParams(
            uri: lichessUri('/broadcast/${broadcastData.slug}/${round.slug}/${round.id}'),
          ),
        );
      },
    ),
    BottomSheetAction(
      makeLabel: (context) => Text('${round.name} PGN'),
      onPressed: () {
        launchShareDialog(
          context,
          ShareParams(
            uri: lichessUri('/broadcast/${broadcastData.slug}/${round.slug}/${round.id}.pgn'),
          ),
        );
      },
    ),
  ],
);
