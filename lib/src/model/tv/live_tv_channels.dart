import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/tv/featured_player.dart';
import 'package:lichess_mobile/src/model/tv/tv_channel.dart';
import 'package:lichess_mobile/src/model/tv/tv_game.dart';
import 'package:lichess_mobile/src/model/tv/tv_repository.dart';
import 'package:lichess_mobile/src/model/tv/tv_socket_events.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'live_tv_channels.g.dart';

typedef LiveTvChannelsState = IMap<TvChannel, TvGameSnapshot>;

@riverpod
class LiveTvChannels extends _$LiveTvChannels {
  StreamSubscription<SocketEvent>? _socketSubscription;
  StreamSubscription<void>? _socketReadySubscription;

  late SocketClient _socketClient;

  @override
  Future<LiveTvChannelsState> build() async {
    ref.onDispose(() {
      _socketSubscription?.cancel();
      _socketReadySubscription?.cancel();
    });

    return _doStartWatching();
  }

  /// Start watching the TV games
  Future<void> startWatching() async {
    final newState = await _doStartWatching();
    state = AsyncValue.data(newState);
  }

  /// Stop watching the TV games.
  void stopWatching() {
    _socketSubscription?.cancel();
    _socketReadySubscription?.cancel();
  }

  Future<IMap<TvChannel, TvGameSnapshot>> _doStartWatching() async {
    final repoGames = await ref.withClient((client) => TvRepository(client).channels());

    _socketClient = ref.read(socketPoolProvider).open(Uri(path: kDefaultSocketRoute));

    await _socketClient.firstConnection;
    _socketWatch(repoGames);

    _socketReadySubscription?.cancel();
    _socketReadySubscription = _socketClient.connectedStream.listen((_) async {
      final repoGames = await ref.withClient((client) => TvRepository(client).channels());
      _socketWatch(repoGames);
    });

    _socketSubscription?.cancel();
    _socketSubscription = _socketClient.stream.listen(_handleSocketEvent);

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

  void _socketWatch(IMap<TvChannel, TvGame> games) {
    _socketClient.send('startWatchingTvChannels', null);
    _socketClient.send(
      'startWatching',
      games.entries.where((e) => TvChannel.values.contains(e.key)).map((e) => e.value.id).join(' '),
    );
  }

  void _handleSocketEvent(SocketEvent event) {
    if (!state.hasValue) {
      assert(false, 'received a SocketEvent while LiveTvChannels state is null');
      return;
    }

    switch (event.topic) {
      case 'fen':
        final json = event.data as Map<String, dynamic>;
        final fenEvent = FenSocketEvent.fromJson(json);
        final snapshots = state.requireValue.values.where((s) => s.id == fenEvent.id);

        if (snapshots.isNotEmpty) {
          state = AsyncValue.data(
            state.requireValue.updateAll(
              (key, value) =>
                  value.id == fenEvent.id
                      ? value.copyWith(fen: fenEvent.fen, lastMove: fenEvent.lastMove)
                      : value,
            ),
          );
        }

      case 'tvSelect':
        final json = event.data as Map<String, dynamic>;
        final channel = pick(json, 'channel').asTvChannelOrNull();
        if (channel != null) {
          final selectEvent = TvSelectEvent.fromJson(json);
          final newSnaphot = TvGameSnapshot(
            channel: selectEvent.channel,
            id: selectEvent.id,
            orientation: selectEvent.orientation,
            player: FeaturedPlayer(
              // don't know why server returns null sometimes
              name: selectEvent.player.name,
              title: selectEvent.player.title,
              side: selectEvent.orientation,
              rating: selectEvent.player.rating,
            ),
          );

          state = AsyncValue.data(
            state.requireValue.update(selectEvent.channel, (_) => newSnaphot),
          );

          _socketClient.send('startWatching', newSnaphot.id);
        }
    }
  }
}
