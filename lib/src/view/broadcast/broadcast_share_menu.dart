import 'package:flutter/widgets.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/widgets/platform_context_menu_button.dart';
import 'package:share_plus/share_plus.dart';

/// The actions of the "Share & export" submenu of a broadcast round.
List<ContextMenuAction> makeBroadcastShareMenuActions(
  BuildContext context,
  BroadcastTournamentData broadcastData,
  BroadcastRound round,
) => [
  ContextMenuAction(
    label: broadcastData.name,
    onPressed: () {
      launchShareDialog(
        context,
        ShareParams(uri: lichessUri('/broadcast/${broadcastData.slug}/${broadcastData.id}')),
      );
    },
  ),
  ContextMenuAction(
    label: round.name,
    onPressed: () {
      launchShareDialog(
        context,
        ShareParams(uri: lichessUri('/broadcast/${broadcastData.slug}/${round.slug}/${round.id}')),
      );
    },
  ),
  ContextMenuAction(
    label: '${round.name} PGN',
    onPressed: () {
      launchShareDialog(
        context,
        ShareParams(
          uri: lichessUri('/broadcast/${broadcastData.slug}/${round.slug}/${round.id}.pgn'),
        ),
      );
    },
  ),
];
