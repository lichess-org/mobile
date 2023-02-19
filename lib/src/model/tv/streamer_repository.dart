import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:async/async.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/common/api_client.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'package:lichess_mobile/src/common/errors.dart';
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

  FutureResult<IList<Streamer>> getStreamers() {
    return apiClient
        .get(Uri.parse('$kLichessHost/api/streamer/live'))
        .flatMap((response) {
      return _streamersFromListOfJson(
        response.body,
        logger: _log,
      );
    });
  }

  void dispose() => apiClient.close();
}

Result<IList<Streamer>> _streamersFromListOfJson(
  String json, {
  Logger? logger,
}) =>
    Result(() {
      final dynamic list = jsonDecode(json);
      if (list is! List<dynamic>) {
        logger?.severe('Received json is not a list');
        throw DataFormatException();
      }
      return IList(
        list.map((e) {
          if (e is! Map<String, dynamic>) {
            logger?.severe('Could not read json object as Streamer');
            throw DataFormatException();
          }
          return _streamersFromJson(e);
        }),
      );
    });

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
