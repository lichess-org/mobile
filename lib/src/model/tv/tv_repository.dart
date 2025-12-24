import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/tv/tv_channel.dart';
import 'package:lichess_mobile/src/model/tv/tv_game.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/aggregator.dart';
import 'package:lichess_mobile/src/network/http.dart';

typedef TvChannels = IMap<TvChannel, TvGame>;

/// A provider for the [TvRepository].
final tvRepositoryProvider = Provider<TvRepository>((ref) {
  final client = ref.watch(lichessClientProvider);
  final aggregator = ref.watch(aggregatorProvider);
  return TvRepository(client, aggregator);
}, name: 'TvRepositoryProvider');

class TvRepository {
  const TvRepository(this.client, this.aggregator);

  final LichessClient client;
  final Aggregator aggregator;

  Future<TvChannels> channels() {
    return aggregator.readJson(
      Uri(path: '/api/tv/channels'),
      atomicMapper: tvChannelsFromServerJson,
    );
  }
}

TvChannels tvChannelsFromServerJson(Map<String, dynamic> json) {
  final map = pick(json).asMapOrEmpty<String, Map<String, dynamic>>();
  return IMap({
    for (final entry in map.entries)
      if (TvChannel.nameMap.containsKey(entry.key))
        TvChannel.nameMap[entry.key]!: _tvGameFromJson(entry.value),
  });
}

TvGame _tvGameFromJson(Map<String, dynamic> json) => _tvGameFromPick(pick(json).required());

TvGame _tvGameFromPick(RequiredPick pick) => TvGame(
  user: pick('user').asLightUserOrThrow(),
  rating: pick('rating').asIntOrNull(),
  id: pick('gameId').asGameIdOrThrow(),
  side: pick('color').asSideOrNull(),
);
