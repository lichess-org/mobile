import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_repository.dart';
import 'package:lichess_mobile/src/model/auth/oauth_callback.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_repository.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_service.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game_repository.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/tab_scaffold.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_game_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_player_results_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_round_screen.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_screen.dart';
import 'package:lichess_mobile/src/view/study/study_screen.dart';
import 'package:lichess_mobile/src/view/tournament/tournament_screen.dart';
import 'package:lichess_mobile/src/view/user/user_or_profile_screen.dart';
import 'package:lichess_mobile/src/view/watch/tv_screen.dart';
import 'package:linkify/linkify.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';

final _logger = Logger('AppLinks');

final appLinksServiceProvider = Provider<AppLinksService>((ref) {
  final service = AppLinksService(ref);
  ref.onDispose(() => service.dispose());
  return service;
});

class AppLinksService {
  AppLinksService(this.ref);

  final Ref ref;

  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  Future<void> start() async {
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) async {
      try {
        // File links are handled by the sharing intent logic, so we can ignore them here.
        if (uri.scheme == 'file' || uri.scheme == 'content') {
          return;
        }
        if (uri.scheme == kLichessUriScheme && uri.host == kOAuthRedirectUriHost) {
          ref.read(oauthCallbackProvider).add(uri);
          return;
        }
        if (uri.scheme == kLichessUriScheme && uri.host == 'open-web') {
          _handleOpenWebLink(uri);
          return;
        }
        final context = ref.read(currentNavigatorKeyProvider).currentContext;
        if (context != null && context.mounted) {
          await handleAppLink(context, uri);
        }
      } catch (e, st) {
        _logger.severe('Error handling app link: $e\n$st');
      }
    });
  }

  void dispose() {
    _linkSubscription?.cancel();
  }

  /// Resolves an app link [Uri] to one or more corresponding [Route]s.
  Future<List<Route<dynamic>>?> resolveAppLinkUri(BuildContext context, Uri appLinkUri) async {
    if (appLinkUri.pathSegments.isEmpty) return null;
    _logger.info('Resolving app link: $appLinkUri');
    switch (appLinkUri.pathSegments[0]) {
      case 'study':
        final id = appLinkUri.pathSegments[1];
        final chapter = appLinkUri.pathSegments.getOrNull(2);
        return [
          StudyScreen.buildRoute(context, (
            id: StudyId(id),
            initialChapter: chapter != null ? StudyChapterId(chapter) : null,
          )),
        ];
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
          final fragment = appLinkUri.fragment;
          final tab = BroadcastRoundTab.tabOrNullFromString(fragment.split('/').first);
          if (tab == BroadcastRoundTab.players && fragment.length > 'players/'.length) {
            final playerId = Uri.decodeComponent(fragment.substring('players/'.length));
            return [
              BroadcastRoundScreenLoading.buildRoute(
                context,
                roundId,
                initialTab: BroadcastRoundTab.players,
              ),
              BroadcastPlayerResultsScreenLoading.buildRoute(context, roundId, playerId),
            ];
          }
          return [BroadcastRoundScreenLoading.buildRoute(context, roundId, initialTab: tab)];
        }
      case 'tournament':
        final tournamentId = TournamentId(appLinkUri.pathSegments[1]);
        return [TournamentScreen.buildRoute(context, tournamentId)];
      case 'training':
        final id = appLinkUri.pathSegments[1];
        return [
          PuzzleScreen.buildRoute(
            context,
            angle: PuzzleAngle.fromKey('mix'),
            puzzleId: PuzzleId(id),
          ),
        ];
      // This might be a challenge or a game link. There's currently no API endpoint that resolves both games and challenges
      // at the same time, so check if it's a game link first, and if that fails, we later check if it's a challenge link.
      case _:
        final gameRoutes = await _tryResolveGameLink(context, appLinkUri);
        if (gameRoutes != null) return gameRoutes;
    }

    return null;
  }

  /// Handles an `org.lichess.mobile://open-web?url=...` link (e.g. from the platform widget)
  /// by opening the encoded URL in the platform in-app browser.
  void _handleOpenWebLink(Uri uri) {
    final target = uri.queryParameters['url'];
    if (target != null) {
      final targetUri = Uri.tryParse(target);
      if (targetUri != null) {
        launchUrl(targetUri, mode: LaunchMode.inAppBrowserView);
      }
    }
  }

  Future<bool> _tryResolveChallengeLink(BuildContext context, Uri appLinkUri) async {
    try {
      final challengeId = ChallengeId(appLinkUri.pathSegments[0]);
      if (!challengeId.isValid) return false;
      final challenge = await ref.read(challengeRepositoryProvider).show(challengeId);
      if (!context.mounted) return false;

      ref.read(challengeServiceProvider).showConfirmDialog(context, challenge, fromLink: true);

      return true;
    } catch (e, st) {
      _logger.info('Not a challenge link: $e', e, st);
    }
    return false;
  }

  Future<List<Route<dynamic>>?> _tryResolveGameLink(BuildContext context, Uri appLinkUri) async {
    try {
      final gameId = GameId(appLinkUri.pathSegments[0]);
      if (!gameId.isValid) return null;

      final game = await ref.read(gameRepositoryProvider).getGame(gameId);
      final orientation = appLinkUri.pathSegments.getOrNull(1) == 'black' ? Side.black : Side.white;
      final int ply = int.tryParse(appLinkUri.fragment) ?? 0;

      if (!context.mounted) return null;

      if (game.finished) {
        return [
          AnalysisScreen.buildRoute(
            context,
            AnalysisOptions.archivedGame(
              orientation: orientation,
              gameId: gameId,
              initialMoveCursor: ply,
            ),
          ),
        ];
      }

      final user = game.playerOf(orientation).user;
      if (user != null) {
        return [TvScreen.buildRoute(context, gameId: gameId, user: user, orientation: orientation)];
      }
    } catch (e, st) {
      _logger.info('Not a game link: $e', e, st);
    }

    return null;
  }

  /// Handles an app link [Uri] by navigating to the corresponding screen(s).
  Future<void> handleAppLink(BuildContext context, Uri uri) async {
    final routes = await resolveAppLinkUri(context, uri);
    if (!context.mounted) return;

    if (routes != null) {
      for (final route in routes) {
        Navigator.of(context, rootNavigator: true).push(route);
      }
    } else {
      final isChallengeLink = await _tryResolveChallengeLink(context, uri);
      if (isChallengeLink) return;

      launchUrl(uri);
    }
  }

  static const kLichessLinkifiers = [UrlLinkifier(), EmailLinkifier(), UserTagLinkifier()];

  /// Handles link clicks in Linkify widgets throughout the app.
  Future<void> onLinkifyOpen(BuildContext context, LinkableElement link) async {
    if (link is UrlElement && link.url.startsWith(RegExp('https?:\\/\\/$kLichessHost'))) {
      // Handle Lichess links specifically
      final appLinkUri = Uri.parse(link.url);
      await handleAppLink(context, appLinkUri);
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
}
