import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:deep_pick/deep_pick.dart';

import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_client.dart';

import './tv_channel.dart';
import './tv_game.dart';

part 'tv_repository.g.dart';

typedef TvChannels = IMap<TvChannel, TvGame>;

@Riverpod(keepAlive: true)
TvRepository tvRepository(TvRepositoryRef ref) {
  final apiClient = ref.watch(authClientProvider);
  return TvRepository(Logger('TvRepository'), apiClient: apiClient);
}

class TvRepository {
  const TvRepository(
    Logger log, {
    required this.apiClient,
  }) : _log = log;

  final AuthClient apiClient;
  final Logger _log;

  FutureResult<TvChannels> channels() {
    return apiClient
        .get(Uri.parse('$kLichessHost/api/tv/channels'))
        .flatMap((response) {
      return readJsonObject(
        response,
        mapper: _tvGamesFromJson,
        logger: _log,
      );
    });
  }
}

TvChannels _tvGamesFromJson(Map<String, dynamic> json) {
  final map = pick(json).asMapOrEmpty<String, Map<String, dynamic>>();
  return IMap({
    for (final entry in map.entries)
      if (TvChannel.nameMap.containsKey(entry.key))
        TvChannel.nameMap[entry.key]!: _tvGameFromJson(entry.value),
  });
}

TvGame _tvGameFromJson(Map<String, dynamic> json) =>
    _tvGameFromPick(pick(json).required());

TvGame _tvGameFromPick(RequiredPick pick) => TvGame(
      user: pick('user').asLightUserOrThrow(),
      rating: pick('rating').asIntOrNull(),
      id: pick('gameId').asGameIdOrThrow(),
      side: pick('color').asSideOrNull(),
    );
