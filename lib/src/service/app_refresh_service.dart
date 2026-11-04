import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/account/ongoing_games_notifier.dart';
import 'package:lichess_mobile/src/model/challenge/challenges.dart';
import 'package:lichess_mobile/src/model/game/game_history.dart';
import 'package:lichess_mobile/src/model/message/message_repository.dart';
import 'package:lichess_mobile/src/model/tournament/tournament_providers.dart';
import 'package:lichess_mobile/src/view/home/following_carousel.dart';

final appRefreshServiceProvider = Provider<AppRefreshService>((ref) {
  return AppRefreshService(ref);
}, name: 'AppRefreshService');

class AppRefreshService(final Ref ref) {
  Future<void>? _refresher;
  bool _wasOnline = false;

  Future<void> refreshApp({required bool isOnline}) {
    final curRefresher = _refresher;
    if (curRefresher != null && (_wasOnline || !isOnline)) return curRefresher;
    _wasOnline = isOnline;

    late final Future<void> future;
    future = _refresh(isOnline: isOnline).whenComplete(() {
      // prevent older refresh from clearing newer one
      if (identical(_refresher, future)) _refresher = null;
    });
    _refresher = future;
    return future;
  }

  Future<void> _refresh({required bool isOnline}) async {
    try {
      await Future.wait([
        ref.refresh(myRecentGamesProvider.future),
        if (isOnline) ref.refresh(challengesProvider.future),
        if (isOnline) ref.refresh(unreadMessagesProvider.future),
        if (isOnline) ref.refresh(accountProvider.future),
        if (isOnline) ref.refresh(ongoingGamesProvider.future),
        if (isOnline) ref.refresh(featuredTournamentsProvider.future),
        if (isOnline) ref.refresh(followingCarouselProvider.future),
      ]);
    } catch (_) {
      // Refreshing while the server is unavailable is expected to fail. Each
      // provider surfaces its own error, and the failed responses are what keep
      // the server status up to date, so there is nothing to do here.
    }
  }
}
