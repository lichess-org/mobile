import 'dart:async';
import 'package:collection/collection.dart';
import 'package:async/async.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/auth/auth_socket.dart';

import 'tv_repository.dart';
import 'tv_event.dart';
import 'tv_game.dart';
import 'featured_player.dart';

part 'tv_games.g.dart';

@riverpod
class TvGames extends _$TvGames {
  StreamSubscription<SocketEvent>? _socketSubscription;

  @override
  Future<IList<TvGameSnapshot>> build() async {
    final socket = ref.watch(authSocketProvider);
    final (stream, _) = socket.connect(Uri(path: kDefaultSocketRoute));

    _socketSubscription = stream.listen(_handleSocketEvent);

    ref.onDispose(() {
      _socketSubscription?.cancel();
    });

    final repo = ref.watch(tvRepositoryProvider);

    final channels = await Result.release(repo.channels());
    final snapshots = channels.entries.map((entry) {
      final orientation = entry.value.side ?? Side.white;
      return TvGameSnapshot(
        channel: entry.key,
        id: entry.value.id,
        orientation: orientation,
        player: FeaturedPlayer(
          id: entry.value.user.id,
          name: entry.value.user.name,
          side: orientation,
          rating: entry.value.rating,
        ),
      );
    });

    socket.send(
      'startWatching',
      snapshots.map((s) => s.id).join(' '),
    );

    return snapshots.toIList();
  }

  void _handleSocketEvent(SocketEvent event) {
    if (!state.hasValue) {
      assert(false, 'received a SocketEvent while TvGames state is null');
      return;
    }

    switch (event.topic) {
      case 'fen':
        final json = event.data as Map<String, dynamic>;
        final fenEvent = FenSocketEvent.fromJson(json);
        final snapshot =
            state.requireValue.firstWhereOrNull((s) => s.id == fenEvent.id);

        if (snapshot != null) {
          final newSnapshot = snapshot.copyWith(
            fen: fenEvent.fen,
            lastMove: fenEvent.lastMove,
          );
          state = AsyncValue.data(
            state.requireValue
                .map((s) => s.id == newSnapshot.id ? newSnapshot : s)
                .toIList(),
          );
        }
    }
  }
}
