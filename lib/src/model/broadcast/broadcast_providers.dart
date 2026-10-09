import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_repository.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/network/http.dart';

/// A provider that fetches a paginated list of broadcasts.
final broadcastsPaginatorProvider =
    AsyncNotifierProvider.autoDispose<BroadcastsPaginator, BroadcastList>(
      BroadcastsPaginator.new,
      name: 'BroadcastsPaginatorProvider',
    );

class BroadcastsPaginator() extends AsyncNotifier<BroadcastList> {
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

class BroadcastsSearchPaginator(final String searchTerm)
    extends AsyncNotifier<BroadcastSearchList> {
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

final broadcastTeamStandingsProvider = FutureProvider.autoDispose
    .family<IList<BroadcastTeamStanding>, BroadcastTournamentId>((
      Ref ref,
      BroadcastTournamentId tournamentId,
    ) {
      return ref.withClientCacheFor(
        (client) => ref.read(broadcastRepositoryProvider).getTeamStandings(tournamentId),
        const Duration(seconds: 30),
      );
    }, name: 'BroadcastTeamStandingsProvider');

typedef BroadcastCalendarDay = ({DateTime date, IList<Broadcast> broadcasts});

IList<BroadcastCalendarDay> groupBroadcastsByDate(IList<Broadcast> broadcasts) {
  final byDay = <DateTime, List<Broadcast>>{};
  final undated = <Broadcast>[];
  for (final broadcast in broadcasts) {
    final startsAt = broadcast.round.startsAt?.toUtc();
    if (startsAt == null) {
      undated.add(broadcast);
      continue;
    }
    final day = DateTime.utc(startsAt.year, startsAt.month, startsAt.day);
    (byDay[day] ??= []).add(broadcast);
  }
  final days = byDay.entries.toList(growable: false)..sort((a, b) => a.key.compareTo(b.key));
  for (final entry in days) {
    entry.value.sort((a, b) {
      final aStart = a.round.startsAt;
      final bStart = b.round.startsAt;
      if (aStart == null) return 1;
      if (bStart == null) return -1;
      return aStart.compareTo(bStart);
    });
  }
  if (undated.isNotEmpty && days.isNotEmpty) {
    days.first.value.addAll(undated);
  }
  return days.map((entry) => (date: entry.key, broadcasts: entry.value.toIList())).toIList();
}

final broadcastCalendarProvider = FutureProvider.autoDispose
    .family<IList<BroadcastCalendarDay>, ({int year, int month})>((
      Ref ref,
      ({int year, int month}) params,
    ) async {
      final broadcasts = await ref.withClientCacheFor(
        (client) => ref
            .read(broadcastRepositoryProvider)
            .getCalendar(year: params.year, month: params.month),
        const Duration(hours: 1),
      );
      return groupBroadcastsByDate(broadcasts);
    }, name: 'BroadcastCalendarProvider');
