import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_repository.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'broadcast_providers.g.dart';

/// A provider that fetches a paginated list of broadcasts.
@riverpod
class BroadcastsPaginator extends _$BroadcastsPaginator {
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
@riverpod
class BroadcastsSearchPaginator extends _$BroadcastsSearchPaginator {
  @override
  Future<BroadcastSearchList> build(String searchTerm) {
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

@riverpod
Future<BroadcastTournament> broadcastTournament(
  Ref ref,
  BroadcastTournamentId broadcastTournamentId,
) {
  return ref.read(broadcastRepositoryProvider).getTournament(broadcastTournamentId);
}

@riverpod
Future<BroadcastRoundResponse> broadcastRound(Ref ref, BroadcastRoundId roundId) {
  return ref.read(broadcastRepositoryProvider).getRound(roundId);
}

@riverpod
Future<IList<BroadcastPlayerWithOverallResult>> broadcastPlayers(
  Ref ref,
  BroadcastTournamentId tournamentId,
) {
  return ref.read(broadcastRepositoryProvider).getPlayers(tournamentId);
}

@riverpod
Future<BroadcastPlayerWithGameResults> broadcastPlayer(
  Ref ref,
  BroadcastTournamentId broadcastTournamentId,
  String playerId,
) {
  return ref.read(broadcastRepositoryProvider).getPlayerResults(broadcastTournamentId, playerId);
}

@riverpod
Future<IList<BroadcastTeamMatch>> broadcastTeamMatches(Ref ref, BroadcastRoundId roundId) {
  return ref.read(broadcastRepositoryProvider).getTeamMatches(roundId);
}
