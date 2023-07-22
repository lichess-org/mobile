import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:lichess_mobile/src/model/auth/auth_client.dart';
import 'package:lichess_mobile/src/constants.dart';
import './tv_event.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:deep_pick/deep_pick.dart';
import './tv_channel.dart';

class TvRepository {
  const TvRepository({required this.apiClient, required Logger logger})
      : _log = logger;

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

  Stream<TvEvent> tvGameFeed(String id) async* {
    final resp =
        await apiClient.stream(Uri.parse('$kLichessHost/api/stream/game/$id'));
    _log.fine('Start streaming a game.');
    yield* resp.stream
        .toStringStream()
        .expand((e) => e.split('\n'))
        .where((event) => event.isNotEmpty && event != '\n')
        .map((event) => jsonDecode(event) as Map<String, dynamic>)
        .map((json) => TvEvent.gameFromJson(json))
        .handleError((Object error) => _log.warning(error));
  }

  FutureResult<TvChannels> getTvChannels() {
    return apiClient
        .get(Uri.parse('$kLichessHost/api/tv/channels'))
        .flatMap((response) {
      return readJsonObject(
        response,
        mapper: tvChannelsFromJson,
        logger: _log,
      );
    });
  }
}

IMap<ChannelVariant, TvChannel> tvChannelsFromJson(Map<String, dynamic> json) {
  final map = pick(json).asMapOrEmpty<String, Map<String, dynamic>>();
  return IMap({
    for (final entry in map.entries)
      if (channelVariantTitleMap.containsKey(entry.key))
        channelVariantTitleMap.get(entry.key)!: TvChannel.fromJson(entry.value),
  });
}
