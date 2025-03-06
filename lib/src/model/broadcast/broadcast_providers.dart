import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_repository.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/image.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'broadcast_providers.g.dart';

/// This provider is used to get a list of tournaments broadcasts.
/// It implements pagination with a maximum number of pages of 20.
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

    if (nextPage == null || nextPage > 20) return;

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
Future<IList<BroadcastPlayerWithResult>> broadcastPlayers(
  Ref ref,
  BroadcastTournamentId tournamentId,
) {
  return ref.withClient((client) => BroadcastRepository(client).getPlayers(tournamentId));
}

@riverpod
Future<BroadcastPlayerWithGames> broadcastPlayerResult(
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
