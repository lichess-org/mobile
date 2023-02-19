import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:async/async.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/common/api_client.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'streamer.dart';

part 'streamer_repository.g.dart';

@Riverpod(keepAlive: true)
StreamerRepository streamerRepository(StreamerRepositoryRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  return StreamerRepository(
    apiClient: apiClient,
    logger: Logger('StreamerRepository'),
  );
}

@riverpod
Future<IList<Streamer>> streamerList(StreamerListRef ref) {
  final repo = ref.watch(streamerRepositoryProvider);
  return Result.release(repo.getStreamers());
}

class StreamerRepository {
  const StreamerRepository({required this.apiClient, required Logger logger})
      : _log = logger;

  final ApiClient apiClient;
  final Logger _log;

  FutureResult<IList<Streamer>> getStreamers() {
    return apiClient
        .get(Uri.parse('$kLichessHost/api/streamer/live'))
        .flatMap((response) {
      return readJsonListOfObjects(
        utf8.decode(response.bodyBytes),
        mapper: _streamersFromJson,
        logger: _log,
      );
    });
  }

  void dispose() => apiClient.close();
}

Streamer _streamersFromJson(Map<String, dynamic> json) =>
    _streamersFromPick(pick(json).required());

Streamer _streamersFromPick(RequiredPick pick) {
  final stream = pick('stream');
  final streamer = pick('streamer');
  return Streamer(
    username: pick('name').asStringOrThrow(),
    id: pick('id').asUserIdOrThrow(),
    patron: pick('patron').asBoolOrNull(),
    platform: stream('service').asStringOrThrow(),
    status: stream('status').asStringOrThrow(),
    lang: stream('lang').asStringOrThrow(),
    streamerName: streamer('name').asStringOrThrow(),
    headline: streamer('headline').asStringOrThrow(),
    title: pick('title').asStringOrNull(),
    image: streamer('image').asStringOrThrow(),
    twitch: streamer('twitch').asStringOrNull(),
    youTube: streamer('youTube').asStringOrNull(),
  );
}
