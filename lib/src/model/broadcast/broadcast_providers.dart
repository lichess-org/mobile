import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_repository.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'broadcast_providers.g.dart';

/// This provider is used to get a list of tournaments broadcasts.
/// It implements pagination with a maximum number of pages of 20.
@riverpod
class BroadcastTournamentsList extends _$BroadcastTournamentsList {
  @override
  Future<BroadcastTournamentsListState> build() async {
    final broadcastResponse = await ref.withClient(
      (client) => BroadcastRepository(client).getBroadcasts(),
    );

    return broadcastResponse;
  }

  Future<void> next() async {
    final nextPage = state.requireValue.nextPage;

    if (nextPage > 20) return;

    state = const AsyncLoading();

    final broadcastResponse = await ref.withClient(
      (client) => BroadcastRepository(client).getBroadcasts(page: nextPage),
    );

    state = AsyncData(
      state.requireValue.copyWith(
        past: state.requireValue.past.addAll(broadcastResponse.past),
        nextPage: broadcastResponse.nextPage,
      ),
    );
  }
}

@riverpod
Future<IList<BroadcastGameSnapshot>> broadcastRound(
  BroadcastRoundRef ref,
  BroadcastRoundId broadcastRoundId,
) async {
  return ref.withClient(
    (client) => BroadcastRepository(client).getRound(broadcastRoundId),
  );
}
