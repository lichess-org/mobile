import 'dart:async';
import 'package:async/async.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';

import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/auth/auth_socket.dart';

import 'tv_repository.dart';
import 'tv_event.dart';
import 'tv_game.dart';
import 'tv_channel.dart';
import 'featured_player.dart';

part 'tv_games.g.dart';

@riverpod
class TvGames extends _$TvGames {
  StreamSubscription<SocketEvent>? _socketSubscription;

  @override
  Future<IMap<TvChannel, TvGameSnapshot>> build() async {
    ref.onDispose(() {
      _socketSubscription?.cancel();
    });

    return _doStartWatching();
  }

  AuthSocket get _socket => ref.read(authSocketProvider);

  /// Start watching the TV games
  Future<void> startWatching() async {
    final (stream, _) = _socket.connect(Uri(path: kDefaultSocketRoute));
    _socketSubscription = stream.listen(_handleSocketEvent);

    final newState = await _doStartWatching();
    state = AsyncValue.data(newState);
  }

  /// Stop watching the TV games.
  void stopWatching() {
    _socketSubscription?.cancel();
  }

  Future<IMap<TvChannel, TvGameSnapshot>> _doStartWatching() async {
    final repo = ref.read(tvRepositoryProvider);
    final repoGames = await Result.release(repo.channels());

    _socket.send(
      'startWatching',
      repoGames.entries
          .where((e) => TvChannel.values.contains(e.key))
          .map((e) => e.value.id)
          .join(' '),
    );

    _socket.send('startWatchingTvChannels', null);

    return repoGames.map((channel, game) {
      return MapEntry(
        channel,
        TvGameSnapshot(
          channel: channel,
          id: game.id,
          orientation: game.side ?? Side.white,
          player: FeaturedPlayer(
            name: game.user.name,
            title: game.user.title,
            side: game.side ?? Side.white,
            rating: game.rating,
          ),
        ),
      );
    });
  }

  void _handleSocketEvent(SocketEvent event) {
    if (!state.hasValue) {
      assert(false, 'received a SocketEvent while TvGames state is null');
      return;
    }

    switch (event.topic) {
      case 'fen':
        final json = event.data as Map<String, dynamic>;
        print('fen: $json');
        final fenEvent = FenSocketEvent.fromJson(json);
        final snapshots =
            state.requireValue.values.where((s) => s.id == fenEvent.id);

        if (snapshots.isNotEmpty) {
          state = AsyncValue.data(
            state.requireValue.updateAll(
              (key, value) => value.id == fenEvent.id
                  ? value.copyWith(
                      fen: fenEvent.fen,
                      lastMove: fenEvent.lastMove,
                    )
                  : value,
            ),
          );
        }

      case 'tvSelect':
        final json = event.data as Map<String, dynamic>;
        print('tvSelect: $json');
        final requiredPick = pick(json).required();
        final channel = requiredPick('channel').asTvChannelOrNull();
        if (channel != null) {
          final side = requiredPick('color').asSideOrThrow();
          final newSnaphot = TvGameSnapshot(
            channel: channel,
            id: requiredPick('id').asGameIdOrThrow(),
            orientation: side,
            player: FeaturedPlayer(
              // don't know why server returns null sometimes
              name: requiredPick('player', 'name').asStringOrNull() ?? '',
              title: requiredPick('player', 'title').asStringOrNull(),
              side: side,
              rating: requiredPick('player', 'rating').asIntOrNull(),
            ),
          );

          state = AsyncValue.data(
            state.requireValue.update(channel, (_) => newSnaphot),
          );

          _socket.send('startWatching', newSnaphot.id.value);
        }
    }
  }
}
