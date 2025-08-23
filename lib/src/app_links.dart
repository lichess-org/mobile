import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_repository.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game_repository.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_game_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_round_screen.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_screen.dart';
import 'package:lichess_mobile/src/view/study/study_screen.dart';
import 'package:lichess_mobile/src/view/tournament/tournament_screen.dart';
import 'package:lichess_mobile/src/view/user/challenge_requests_screen.dart';
import 'package:lichess_mobile/src/view/user/user_or_profile_screen.dart';
import 'package:lichess_mobile/src/view/watch/tv_screen.dart';
import 'package:linkify/linkify.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';

final _logger = Logger('AppLinks');

/// Resolves an app link [Uri] to one or more corresponding [Route]s.
Future<List<Route<dynamic>>?> resolveAppLinkUri(
  BuildContext context,
  Uri appLinkUri,
  WidgetRef ref,
) async {
  if (appLinkUri.pathSegments.isEmpty) return null;
  _logger.info('Resolving app link: $appLinkUri');
  switch (appLinkUri.pathSegments[0]) {
    case 'study':
      final id = appLinkUri.pathSegments[1];
      return [StudyScreen.buildRoute(context, StudyId(id))];
    case 'broadcast':
      final roundId = BroadcastRoundId(appLinkUri.pathSegments[3]);
      if (appLinkUri.pathSegments.length > 4) {
        final gameId = BroadcastGameId(appLinkUri.pathSegments[4]);
        return [
          BroadcastRoundScreenLoading.buildRoute(
            context,
            roundId,
            initialTab: BroadcastRoundTab.boards,
          ),
          BroadcastGameScreen.buildRoute(context, roundId: roundId, gameId: gameId),
        ];
      } else {
        final tab = BroadcastRoundTab.tabOrNullFromString(appLinkUri.fragment);
        return [BroadcastRoundScreenLoading.buildRoute(context, roundId, initialTab: tab)];
      }
    case 'tournament':
      final tournamentId = TournamentId(appLinkUri.pathSegments[1]);
      return [TournamentScreen.buildRoute(context, tournamentId)];
    case 'training':
      final id = appLinkUri.pathSegments[1];
      return [
        PuzzleScreen.buildRoute(context, angle: PuzzleAngle.fromKey('mix'), puzzleId: PuzzleId(id)),
      ];
    case _:
      final id = appLinkUri.pathSegments[0];

      try {
        final gameId = GameId(id);
        final game = await ref.read(gameRepositoryProvider).getGame(gameId);
        final orientation = appLinkUri.pathSegments.getOrNull(1) == 'black'
            ? Side.black
            : Side.white;
        final int ply = int.tryParse(appLinkUri.fragment) ?? 0;

        if (!context.mounted) return null;

        return [
          if (game.finished)
            AnalysisScreen.buildRoute(
              context,
              AnalysisOptions.archivedGame(
                orientation: orientation,
                gameId: gameId,
                initialMoveCursor: ply,
              ),
            )
          else
            TvScreen.buildRoute(
              context,
              gameId: gameId,
              user: game.playerOf(orientation).user,
              orientation: orientation,
            ),
        ];
      } catch (e) {
        _logger.info('Not a game link: $e');
      }

      try {
        final challenge = await ref.read(challengeRepositoryProvider).show(ChallengeId(id));
        if (!context.mounted) return null;
        return [ChallengeRequestsScreen.buildRoute(context, incomingChallenge: challenge)];
      } catch (e) {
        _logger.info('Not a challenge link: $e');
      }
  }

  return null;
}

/// Handles an app link [Uri] by navigating to the corresponding screen(s).
Future<void> handleAppLink(BuildContext context, Uri uri, WidgetRef ref) async {
  final navigator = Navigator.of(context);
  final routes = await resolveAppLinkUri(context, uri, ref);
  if (routes != null) {
    for (final route in routes) {
      navigator.push(route);
    }
  } else {
    launchUrl(uri);
  }
}

const kLichessLinkifiers = [UrlLinkifier(), EmailLinkifier(), UserTagLinkifier()];

/// Handles link clicks in Linkify widgets throughout the app.
Future<void> onLinkifyOpen(BuildContext context, LinkableElement link, WidgetRef ref) async {
  if (link is UrlElement && link.url.startsWith(RegExp('https?:\\/\\/$kLichessHost'))) {
    // Handle Lichess links specifically
    final appLinkUri = Uri.parse(link.url);
    await handleAppLink(context, appLinkUri, ref);
  } else if (link.originText.startsWith('@')) {
    final username = link.originText.substring(1);
    Navigator.of(context).push(
      UserOrProfileScreen.buildRoute(
        context,
        LightUser(id: UserId.fromUserName(username), name: username),
      ),
    );
  } else {
    launchUrl(Uri.parse(link.url));
  }
}
