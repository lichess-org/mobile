import 'package:logging/logging.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deep_pick/deep_pick.dart';

import 'package:lichess_mobile/src/common/api_client.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'streamer.dart';

final streamerRepositoryProvider = Provider<StreamerRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final repo = StreamerRepository(
    apiClient: apiClient,
    logger: Logger('StreamerRepository'),
  );
  ref.onDispose(() => repo.dispose());
  return repo;
});

class StreamerRepository {
  const StreamerRepository({required this.apiClient, required Logger logger})
      : _log = logger;

  final ApiClient apiClient;
  final Logger _log;

  FutureResult<List<Streamer>> getStreamers() {
    return apiClient
        .get(Uri.parse('$kLichessHost/api/streamer/live'))
        .flatMap((response) {
      return readJsonObject(
        response.body,
        mapper: _streamersFromJson,
        logger: _log,
      );
    });
  }

  void dispose() => apiClient.close();
}

List<Streamer> _streamersFromJson(Map<String, dynamic> json) =>
    _streamersFromPick(pick(json).required());

List<Streamer> _streamersFromPick(RequiredPick pick) {
  final stream = pick('stream');
  final streamer = pick('streamer');
  return pick([]).asListOrThrow((pick) {
    print('Testing....');
    print(pick('name').asStringOrThrow());
    return Streamer(
      username: pick('name').asStringOrThrow(),
      id: pick('id').asUserIdOrThrow(),
      patron: pick('patron').asBoolOrNull(),
      streamService: stream('service').asStringOrThrow(),
      streamStatus: stream('status').asStringOrThrow(),
      lang: stream('lang').asStringOrThrow(),
      streamerName: streamer('name').asStringOrThrow(),
      streamerDesc: streamer('description').asStringOrThrow(),
      streamerHeadline: streamer('headline').asStringOrThrow(),
      image: streamer('image').asStringOrThrow(),
      twitch: streamer('twitch').asStringOrNull(),
      youTube: streamer('youTube').asStringOrNull(),
    );
  });
}
