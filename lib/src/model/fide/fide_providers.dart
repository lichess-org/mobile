import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_repository.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/fide/fide_player.dart';
import 'package:lichess_mobile/src/model/fide/fide_repository.dart';

typedef FidePlayerListParams = ({FidePlayerOrder order, String? query});

/// The FIDE players sorted by an order, or matching a search query, loaded page by page.
final fidePlayerListProvider = AsyncNotifierProvider.autoDispose
    .family<FidePlayerListNotifier, FidePlayerPage, FidePlayerListParams>(
      FidePlayerListNotifier.new,
      name: 'FidePlayerListProvider',
    );

class FidePlayerListNotifier(final FidePlayerListParams params)
    extends AsyncNotifier<FidePlayerPage> {
  @override
  Future<FidePlayerPage> build() => _fetchPage(1);

  /// Appends the next page to the list, if there is one.
  Future<void> next() async {
    final current = state.requireValue;
    final nextPage = current.nextPage;
    if (nextPage == null) return;

    final page = await _fetchPage(nextPage);
    if (!ref.mounted) return;

    state = AsyncData((players: current.players.addAll(page.players), nextPage: page.nextPage));
  }

  Future<FidePlayerPage> _fetchPage(int page) => ref
      .read(fideRepositoryProvider)
      .getPlayers(page: page, order: params.order, query: params.query);
}

/// A FIDE player with their rating history and linked lichess account.
final fidePlayerProvider = FutureProvider.autoDispose.family<FidePlayerDetails, FideId>(
  (ref, id) => ref.watch(fideRepositoryProvider).getPlayer(id),
  name: 'FidePlayerProvider',
);

/// The players the user followed or unfollowed since a FIDE screen opened, which take precedence
/// over the follow status of the players fetched before.
///
/// The FIDE player list and player screens share them, so that a player followed on the player
/// screen shows as followed back in the list without refetching it.
final fideFollowingProvider =
    NotifierProvider.autoDispose<FideFollowingNotifier, IMap<FideId, bool>>(
      FideFollowingNotifier.new,
      name: 'FideFollowingProvider',
    );

class FideFollowingNotifier() extends Notifier<IMap<FideId, bool>> {
  @override
  IMap<FideId, bool> build() => const IMapConst({});

  /// Follows or unfollows a player, showing the new status at once.
  ///
  /// Reverts the status and rethrows if the request fails.
  Future<void> setFollowing(FideId id, bool following) async {
    state = state.add(id, following);
    try {
      await ref.read(broadcastRepositoryProvider).setFollowingPlayer(id, following);
    } catch (_) {
      if (ref.mounted) state = state.add(id, !following);
      rethrow;
    }
  }
}
