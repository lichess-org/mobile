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
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/tab_scaffold.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
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

// Deeplink host/path for the iOS daily-puzzle widget tap.
// Must stay in sync with Deeplinks.swift in the iOS widget extension.
const _kDailyPuzzleDeeplinkHost = 'training';
const _kDailyPuzzleDeeplinkPath = 'daily';

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
    // Handle the link that cold-started the app (if any) after the first frame
    // so the navigator is ready. Push without animation — the user launched the
    // app via this link so the target screen should just be there.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final initialUri = await _appLinks.getInitialLink();
        if (initialUri != null) {
          await _handleUri(initialUri, animated: false);
        }
      } catch (e, st) {
        _logger.severe('Error handling initial app link: $e\n$st');
      }
    });

    // Links received while the app is already running get a normal transition.
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) async {
      try {
        await _handleUri(uri, animated: true);
      } catch (e, st) {
        _logger.severe('Error handling app link: $e\n$st');
      }
    });
  }

  Future<void> _handleUri(Uri uri, {required bool animated}) async {
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
    if (uri.scheme == kLichessUriScheme &&
        uri.host == _kDailyPuzzleDeeplinkHost &&
        uri.pathSegments.firstOrNull == _kDailyPuzzleDeeplinkPath) {
      if (context != null && context.mounted) {
        await handleDailyPuzzleLink(
          context,
          uri.pathSegments.elementAtOrNull(1),
          animated: animated,
        );
      }
      return;
    }
    if (context != null && context.mounted) {
      await handleAppLink(context, uri, animated: animated);
    }
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

  /// Opens the native daily-puzzle screen (same path as tapping the daily-puzzle
  /// card on the puzzle tab) in response to `org.lichess.mobile://training/daily`
  /// or `org.lichess.mobile://training/daily/{id}` deeplinks emitted by the iOS
  /// home-screen widget.
  ///
  /// Always fetches the current daily puzzle first (cached, so no extra request
  /// in the common case). When [puzzleId] matches today's daily, it is used
  /// directly. When it differs (widget cached a stale id), that specific puzzle
  /// is fetched but NOT flagged as the daily so the user isn't confused when
  /// navigating back to the puzzle tab.
  @visibleForTesting
  Future<void> handleDailyPuzzleLink(
    BuildContext context,
    String? puzzleId, {
    bool animated = true,
  }) async {
    try {
      Puzzle puzzle;
      final dailyPuzzle = await ref.read(dailyPuzzleProvider.future);
      if (puzzleId == null || dailyPuzzle.puzzle.id == PuzzleId(puzzleId)) {
        puzzle = dailyPuzzle;
      } else {
        // Widget cached a different puzzle than today's daily — fetch it, but
        // don't mark as daily to avoid confusing the user.
        try {
          puzzle = await ref.read(puzzleProvider(PuzzleId(puzzleId)).future);
        } catch (e, st) {
          // Fall back to the current daily puzzle rather than leaving the tap
          // as a no-op when the widget's cached id is stale or unreachable.
          _logger.info('Failed to load widget puzzle id $puzzleId, falling back: $e', e, st);
          puzzle = dailyPuzzle;
        }
      }
      if (!context.mounted) return;
      final route = PuzzleScreen.buildRoute(
        context,
        angle: const PuzzleTheme(PuzzleThemeKey.mix),
        puzzle: puzzle,
      );
      await _pushDeepLinkRoute(
        Navigator.of(context, rootNavigator: true),
        route,
        animated: animated,
      );
    } catch (e, st) {
      _logger.severe('Failed to open daily puzzle from widget: $e\n$st');
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
  Future<void> handleAppLink(BuildContext context, Uri uri, {bool animated = true}) async {
    final routes = await resolveAppLinkUri(context, uri);
    if (!context.mounted) return;

    if (routes != null) {
      final navigator = Navigator.of(context, rootNavigator: true);
      for (final route in routes) {
        _pushDeepLinkRoute(navigator, route, animated: animated);
      }
    } else {
      final isChallengeLink = await _tryResolveChallengeLink(context, uri);
      if (isChallengeLink) return;

      launchUrl(uri);
    }
  }

  /// Pushes [route] onto [navigator], replacing the top route instead of
  /// stacking when the top is already the same screen type — preventing
  /// duplicates when the user taps a deep link while already on that screen.
  /// Also applies [_withNoTransition] when [animated] is `false`.
  static Future<void> _pushDeepLinkRoute(
    NavigatorState navigator,
    Route<dynamic> route, {
    required bool animated,
  }) {
    final pushed = animated ? route : _withNoTransition(route);
    Route<dynamic>? top;
    navigator.popUntil((r) {
      top = r;
      return true;
    });
    final topRoute = top;
    if (topRoute is ScreenRoute &&
        pushed is ScreenRoute &&
        topRoute.screen.runtimeType == pushed.screen.runtimeType) {
      return navigator.pushReplacement(pushed);
    }
    return navigator.push(pushed);
  }

  /// Returns a copy of [route] with [Duration.zero] transition so the screen
  /// appears instantly — used when the app is opened via a deep link and a
  /// transition would be jarring.
  static Route<dynamic> _withNoTransition(Route<dynamic> route) {
    if (route is ScreenRoute) {
      return MaterialScreenRoute(
        screen: route.screen,
        settings: route.settings,
        fullscreenDialog: route.fullscreenDialog,
        maintainState: route.maintainState,
        allowSnapshotting: route.allowSnapshotting,
        overrideTransitionDuration: Duration.zero,
      );
    }
    return route;
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
