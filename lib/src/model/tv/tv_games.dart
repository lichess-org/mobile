import 'dart:async';
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
    final channelGames = channels.entries
        .map((entry) => (channel: entry.key, gameId: entry.value.id));

    socket.send(
      'startWatching',
      channelGames.map((id) => id.gameId.value).join(' '),
    );

    final snapshotsCompleters = {
      for (final tuple in channelGames) tuple: Completer<TvGameSnapshot>(),
    };

    final sub = stream.listen((event) {
      if (event.topic == 'fen') {
        final json = event.data as Map<String, dynamic>;
        final fenEvent = FenSocketEvent.fromJson(json);
        final tuple = channelGames.firstWhere(
          (tuple) => tuple.gameId == fenEvent.id,
        );
        final game = channels[tuple.channel]!;
        final orientation = game.side ?? Side.white;
        final snapshot = TvGameSnapshot(
          channel: tuple.channel,
          id: fenEvent.id,
          orientation: orientation,
          fen: fenEvent.fen,
          player: FeaturedPlayer(
            side: orientation,
            id: game.user.id,
            name: game.user.name,
            title: game.user.title,
            rating: game.rating,
          ),
          lastMove: fenEvent.lastMove,
        );
        snapshotsCompleters[tuple]?.complete(snapshot);
      }
    });

    return Future.wait(
      snapshotsCompleters.values.map((completer) => completer.future),
    ).then((snapshots) {
      sub.cancel();
      return IList(snapshots);
    });
  }

  void _handleSocketEvent(SocketEvent event) {}
}
