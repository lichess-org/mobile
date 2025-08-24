import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_game_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_round_screen.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_screen.dart';
import 'package:lichess_mobile/src/view/study/study_screen.dart';
import 'package:lichess_mobile/src/view/tournament/tournament_screen.dart';
import 'package:lichess_mobile/src/view/user/user_screen.dart';
import 'package:linkify/linkify.dart';
import 'package:url_launcher/url_launcher.dart';

/// Resolves an app link [Uri] to a corresponding [Route].
Route<dynamic>? resolveAppLinkUri(BuildContext context, Uri appLinkUri) {
  if (appLinkUri.pathSegments.isEmpty) return null;

  switch (appLinkUri.pathSegments[0]) {
    case 'study':
      final id = appLinkUri.pathSegments[1];
      return StudyScreen.buildRoute(context, StudyId(id));
    case 'broadcast':
      final roundId = BroadcastRoundId(appLinkUri.pathSegments[3]);
      if (appLinkUri.pathSegments.length > 4) {
        final gameId = BroadcastGameId(appLinkUri.pathSegments[4]);
        return BroadcastGameScreen.buildRoute(context, roundId: roundId, gameId: gameId);
      } else {
        final tab = BroadcastRoundTab.tabOrNullFromString(appLinkUri.fragment);
        return BroadcastRoundScreenLoading.buildRoute(context, roundId, initialTab: tab);
      }
    case 'tournament':
      final tournamentId = TournamentId(appLinkUri.pathSegments[1]);
      return TournamentScreen.buildRoute(context, tournamentId);

    case 'training':
      final id = appLinkUri.pathSegments[1];
      return PuzzleScreen.buildRoute(
        context,
        angle: PuzzleAngle.fromKey('mix'),
        puzzleId: PuzzleId(id),
      );
    case _:
      final gameId = GameId(appLinkUri.pathSegments[0]);
      final orientation = appLinkUri.pathSegments.getOrNull(2);
      // The game id can also be a challenge. Challenge by link is not supported yet so let's ignore it.
      if (gameId.isValid) {
        return AnalysisScreen.buildRoute(
          context,
          AnalysisOptions.archivedGame(
            orientation: orientation == 'black' ? Side.black : Side.white,
            gameId: gameId,
            initialMoveCursor: 0,
          ),
        );
      }
  }

  return null;
}

const kLichessLinkifiers = [UrlLinkifier(), EmailLinkifier(), UserTagLinkifier()];

/// Handles link clicks in Linkify widgets throughout the app.
void onLinkifyOpen(BuildContext context, LinkableElement link) {
  if (link is UrlElement && link.url.startsWith(RegExp('https?:\\/\\/$kLichessHost'))) {
    // Handle Lichess links specifically
    final appLinkUri = Uri.parse(link.url);
    final route = resolveAppLinkUri(context, appLinkUri);
    if (route != null) {
      Navigator.of(context).push(route);
    } else {
      // If the link is not recognized, open it in a browser
      launchUrl(appLinkUri);
    }
  } else if (link.originText.startsWith('@')) {
    final username = link.originText.substring(1);
    Navigator.of(context).push(
      UserScreen.buildRoute(context, LightUser(id: UserId.fromUserName(username), name: username)),
    );
  } else {
    launchUrl(Uri.parse(link.url));
  }
}
