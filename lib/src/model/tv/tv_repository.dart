import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/common/errors.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:logging/logging.dart';
import 'package:async/async.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:lichess_mobile/src/common/http.dart';
import 'package:lichess_mobile/src/constants.dart';
import './tv_event.dart';

class TvRepository {
  const TvRepository(
    Logger log, {
    required this.apiClient,
  }) : _log = log;

  final ApiClient apiClient;
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

  Stream<TvEvent> tvChannelGameStream(String gameId) async* {
    final resp = await apiClient
        .stream(Uri.parse('$kLichessHost/api/stream/game/$gameId'));
    _log.fine('Start Streaming Channel Game');
    yield* resp.stream
        .toStringStream()
        .where((event) => event.isNotEmpty && event != '\n')
        .map((event) => jsonDecode(event) as Map<String, dynamic>)
        .map((json) => TvEvent.fromChannelGame(json))
        .handleError((Object error) => _log.warning(error));
  }

  FutureResult<String> tvChannelGame(String channel) {
    return apiClient
        .get(Uri.parse('$kLichessHost/api/tv/channels'))
        .flatMap((response) => gameIdfromJson(response.body, channel));
  }

  Result<String> gameIdfromJson(String json, String channel) => Result(() {
        final dynamic obj = jsonDecode(json);
        if (obj is! Map<String, dynamic>) {
          _log.severe('Could not read json object');
          throw DataFormatException();
        }
        final jsonPick = pick(obj).required();
        return jsonPick(channel)
            .letOrThrow((mapPick) => mapPick('gameId').asStringOrThrow());
      });

  void dispose() {
    apiClient.close();
  }
}

final tvRepositoryProvider = Provider<TvRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final repo = TvRepository(Logger('TvRepository'), apiClient: apiClient);
  ref.onDispose(() => repo.dispose());
  return repo;
});
