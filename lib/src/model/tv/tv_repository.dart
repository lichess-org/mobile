import 'dart:convert';
import 'package:async/async.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_client.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';

import './tv_event.dart';
import './tv_game.dart';
import './tv_channel.dart';

part 'tv_repository.g.dart';

@Riverpod(keepAlive: true)
TvRepository tvRepository(TvRepositoryRef ref) {
  final apiClient = ref.watch(authClientProvider);
  return TvRepository(Logger('TvRepository'), apiClient: apiClient);
}

typedef TvGames = IMap<TvChannel, TvGame>;

class TvRepository {
  const TvRepository(
    Logger log, {
    required this.apiClient,
  }) : _log = log;

  final AuthClient apiClient;
  final Logger _log;

  Stream<TvEvent> tvFeed() async* {
    final resp = await apiClient.stream(Uri.parse('$kLichessHost/api/tv/feed'));
    _log.fine('Start streaming TV.');
    yield* resp.stream
        .toStringStream()
        .where((event) => event.isNotEmpty && event != '\n')
        .map((event) => jsonDecode(event) as Map<String, dynamic>)
        .where((json) => json['t'] == 'featured' || json['t'] == 'fen')
        .map((json) => TvEvent.fromJson(json))
        .handleError((Object error) => _log.warning(error));
  }

  Future<TvGameSnapshot> currentBestSnapshot() {
    return tvFeed()
        .firstWhere((event) => event is TvFeaturedEvent)
        .then((event) async {
      final featured = event as TvFeaturedEvent;
      final perf = await Result.release(
        apiClient.get(
          Uri.parse('$kLichessHost/game/export/${featured.id}'),
          headers: {'Accept': 'application/json'},
        ).map((response) {
          final obj = jsonDecode(utf8.decode(response.bodyBytes))
              as Map<String, dynamic>;
          return pick(obj).required()('perf').asPerfOrThrow();
        }),
      );
      return TvGameSnapshot(
        id: featured.id,
        orientation: featured.orientation,
        fen: featured.fen,
        white: featured.white,
        black: featured.black,
        perf: perf,
      );
    });
  }
}
