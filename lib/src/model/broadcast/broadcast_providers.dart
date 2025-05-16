import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_repository.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/image.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'broadcast_providers.g.dart';

/// A provider that fetches a paginated list of broadcasts.
@riverpod
class BroadcastsPaginator extends _$BroadcastsPaginator {
  @override
  Future<BroadcastList> build() async {
    final broadcastList = await ref.withClient(
      (client) => BroadcastRepository(client).getBroadcasts(),
    );

    return broadcastList;
  }

  Future<void> next() async {
    final broadcastList = state.requireValue;
    final nextPage = broadcastList.nextPage;

    if (nextPage == null) return;

    state = const AsyncLoading();

    final broadcastListNewPage = await ref.withClient(
      (client) => BroadcastRepository(client).getBroadcasts(page: nextPage),
    );

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
  Future<BroadcastSearchList> build(String searchTerm) async {
    final broadcastSearchList = await ref.withClient(
      (client) => BroadcastRepository(client).searchBroadcasts(searchTerm: searchTerm),
    );

    return broadcastSearchList;
  }

  Future<void> next() async {
    final broadcastSearchList = state.requireValue;
    final nextPage = broadcastSearchList.nextPage;

    if (nextPage == null) return;

    state = const AsyncLoading();

    final broadcastSearchListNewPage = await ref.withClient(
      (client) =>
          BroadcastRepository(client).searchBroadcasts(searchTerm: searchTerm, page: nextPage),
    );

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
  return ref.withClient(
    (client) => BroadcastRepository(client).getTournament(broadcastTournamentId),
  );
}

@riverpod
Future<BroadcastRoundResponse> broadcastRound(Ref ref, BroadcastRoundId roundId) {
  return ref.withClient((client) => BroadcastRepository(client).getRound(roundId));
}

@riverpod
Future<IList<BroadcastPlayerWithOverallResult>> broadcastPlayers(
  Ref ref,
  BroadcastTournamentId tournamentId,
) {
  return ref.withClient((client) => BroadcastRepository(client).getPlayers(tournamentId));
}

@riverpod
Future<BroadcastPlayerWithGameResults> broadcastPlayer(
  Ref ref,
  BroadcastTournamentId broadcastTournamentId,
  String playerId,
) {
  return ref.withClient(
    (client) => BroadcastRepository(client).getPlayerResults(broadcastTournamentId, playerId),
  );
}

@Riverpod(keepAlive: true)
BroadcastImageWorkerFactory broadcastImageWorkerFactory(Ref ref) {
  return const BroadcastImageWorkerFactory();
}

class BroadcastImageWorkerFactory {
  const BroadcastImageWorkerFactory();

  Future<ImageColorWorker> spawn() {
    return ImageColorWorker.spawn();
  }
}
