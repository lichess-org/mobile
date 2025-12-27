import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_repository.dart';
import 'package:lichess_mobile/src/model/common/id.dart';

/// A provider that fetches a paginated list of broadcasts.
final broadcastsPaginatorProvider =
    AsyncNotifierProvider.autoDispose<BroadcastsPaginator, BroadcastList>(
      BroadcastsPaginator.new,
      name: 'BroadcastsPaginatorProvider',
    );

class BroadcastsPaginator extends AsyncNotifier<BroadcastList> {
  @override
  Future<BroadcastList> build() {
    return ref.read(broadcastRepositoryProvider).getBroadcasts();
  }

  /// This function should be called only if there are more pages.
  Future<void> next() async {
    final broadcastList = state.requireValue;
    final nextPage = broadcastList.nextPage;

    assert(nextPage != null && nextPage <= 20);

    final broadcastListNewPage = await ref
        .read(broadcastRepositoryProvider)
        .getBroadcasts(page: nextPage!);

    state = AsyncData((
      active: broadcastList.active,
      past: broadcastList.past.addAll(broadcastListNewPage.past),
      nextPage: broadcastListNewPage.nextPage,
    ));
  }
}

/// A provider that fetches a paginated list of broadcasts matching the [searchTerm].
final broadcastsSearchPaginatorProvider = AsyncNotifierProvider.autoDispose
    .family<BroadcastsSearchPaginator, BroadcastSearchList, String>(
      BroadcastsSearchPaginator.new,
      name: 'BroadcastsSearchPaginatorProvider',
    );

class BroadcastsSearchPaginator extends AsyncNotifier<BroadcastSearchList> {
  BroadcastsSearchPaginator(this.searchTerm);

  final String searchTerm;

  @override
  Future<BroadcastSearchList> build() {
    return ref.read(broadcastRepositoryProvider).searchBroadcasts(searchTerm: searchTerm);
  }

  /// This function should be called only if there are more pages.
  Future<void> next() async {
    final broadcastSearchList = state.requireValue;
    final nextPage = broadcastSearchList.nextPage;

    assert(nextPage != null && nextPage <= 20);

    final broadcastSearchListNewPage = await ref
        .read(broadcastRepositoryProvider)
        .searchBroadcasts(searchTerm: searchTerm, page: nextPage!);

    state = AsyncData((
      broadcasts: broadcastSearchList.broadcasts.addAll(broadcastSearchListNewPage.broadcasts),
      nextPage: broadcastSearchListNewPage.nextPage,
    ));
  }
}

final broadcastTournamentProvider = FutureProvider.autoDispose
    .family<BroadcastTournament, BroadcastTournamentId>((
      Ref ref,
      BroadcastTournamentId broadcastTournamentId,
    ) {
      return ref.read(broadcastRepositoryProvider).getTournament(broadcastTournamentId);
    }, name: 'BroadcastTournamentProvider');

final broadcastRoundProvider = FutureProvider.autoDispose
    .family<BroadcastRoundResponse, BroadcastRoundId>((Ref ref, BroadcastRoundId roundId) {
      return ref.read(broadcastRepositoryProvider).getRound(roundId);
    }, name: 'BroadcastRoundProvider');

final broadcastPlayersProvider = FutureProvider.autoDispose
    .family<IList<BroadcastPlayerWithOverallResult>, BroadcastTournamentId>((
      Ref ref,
      BroadcastTournamentId tournamentId,
    ) {
      return ref.read(broadcastRepositoryProvider).getPlayers(tournamentId);
    }, name: 'BroadcastPlayersProvider');

final broadcastPlayerProvider = FutureProvider.autoDispose
    .family<BroadcastPlayerWithGameResults, (BroadcastTournamentId, String)>((
      Ref ref,
      (BroadcastTournamentId, String) params,
    ) {
      return ref.read(broadcastRepositoryProvider).getPlayerResults(params.$1, params.$2);
    }, name: 'BroadcastPlayerProvider');

final broadcastTeamMatchesProvider = FutureProvider.autoDispose
    .family<IList<BroadcastTeamMatch>, BroadcastRoundId>((Ref ref, BroadcastRoundId roundId) {
      return ref.read(broadcastRepositoryProvider).getTeamMatches(roundId);
    }, name: 'BroadcastTeamMatchesProvider');
