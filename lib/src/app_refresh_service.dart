import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/account/ongoing_games_notifier.dart';
import 'package:lichess_mobile/src/model/challenge/challenges.dart';
import 'package:lichess_mobile/src/model/game/game_history.dart';
import 'package:lichess_mobile/src/model/message/message_repository.dart';
import 'package:lichess_mobile/src/model/tournament/tournament_providers.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/view/home/following_carousel.dart';

final appRefreshProvider = Provider.autoDispose<AppRefreshService>(
  (ref) => AppRefreshService(ref, isOnline: ref.watch(isDeviceOnlineProvider)),
  name: 'AppRefreshProvider',
);

class AppRefreshService(final Ref ref, {required final bool isOnline}) {
  Future<void> refreshApp() async {
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
