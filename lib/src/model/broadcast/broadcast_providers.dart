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

    state = AsyncData(
      (
        active: broadcastList.active,
        past: broadcastList.past.addAll(broadcastListNewPage.past),
        nextPage: broadcastListNewPage.nextPage,
      ),
    );
  }
}

@riverpod
Future<BroadcastTournament> broadcastTournament(
  Ref ref,
  BroadcastTournamentId broadcastTournamentId,
) {
  return ref.withClient(
    (client) =>
        BroadcastRepository(client).getTournament(broadcastTournamentId),
  );
}

enum BroadcastPlayersSortingTypes { player, elo, score }

@riverpod
class BroadcastPlayers extends _$BroadcastPlayers {
  @override
  Future<IList<BroadcastPlayerExtended>> build(
    BroadcastTournamentId tournamentId,
  ) async {
    final players = ref.withClient(
      (client) => BroadcastRepository(client).getPlayers(tournamentId),
    );

    return players;
  }

  void sort(BroadcastPlayersSortingTypes sortingType, [bool reverse = false]) {
    if (!state.hasValue) return;

    final compare = switch (sortingType) {
      BroadcastPlayersSortingTypes.player =>
        (BroadcastPlayerExtended a, BroadcastPlayerExtended b) =>
            a.name.compareTo(b.name),
      BroadcastPlayersSortingTypes.elo =>
        (BroadcastPlayerExtended a, BroadcastPlayerExtended b) {
          if (a.rating == null) return -1;
          if (b.rating == null) return 1;
          return b.rating!.compareTo(a.rating!);
        },
      BroadcastPlayersSortingTypes.score =>
        (BroadcastPlayerExtended a, BroadcastPlayerExtended b) {
          if (a.score == null) return -1;
          if (b.score == null) return 1;
          return b.score!.compareTo(a.score!);
        }
    };

    state = AsyncData(
      reverse
          ? state.requireValue.sortReversed(compare)
          : state.requireValue.sort(compare),
    );
  }
}

@Riverpod(keepAlive: true)
BroadcastImageWorkerFactory broadcastImageWorkerFactory(Ref ref) {
  return const BroadcastImageWorkerFactory();
}

class BroadcastImageWorkerFactory {
  const BroadcastImageWorkerFactory();

  Future<ImageColorWorker> spawn() async {
    return ImageColorWorker.spawn();
  }
}
