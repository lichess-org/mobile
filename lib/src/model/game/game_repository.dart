import 'dart:convert';

import 'package:async/async.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_client.dart';
import 'package:lichess_mobile/src/model/common/errors.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/archived_game.dart';
import 'package:lichess_mobile/src/model/game/playable_game.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'package:logging/logging.dart';
import 'package:result_extensions/result_extensions.dart';

class GameRepository {
  const GameRepository(
    Logger log, {
    required this.apiClient,
  }) : _log = log;

  final AuthClient apiClient;
  final Logger _log;

  FutureResult<ArchivedGame> getGame(GameId id) {
    return apiClient.get(
      Uri.parse('$kLichessHost/game/export/$id?accuracy=1&clocks=1'),
      headers: {'Accept': 'application/json'},
    ).flatMap((response) {
      return readJsonObjectFromResponse(
        response,
        mapper: ArchivedGame.fromServerJson,
        logger: _log,
      );
    });
  }

  FutureResult<void> requestServerAnalysis(GameId id) {
    return apiClient.post(
      Uri.parse('$kLichessHost/$id/request-analysis'),
    );
  }

  FutureResult<IList<LightArchivedGame>> getRecentGames(UserId userId) {
    return apiClient.get(
      Uri.parse(
        '$kLichessHost/api/games/user/$userId?max=10&moves=false&lastFen=true&accuracy=true&opening=true',
      ),
      headers: {'Accept': 'application/x-ndjson'},
    ).flatMap(
      (r) => readNdJsonListFromResponse(
        r,
        mapper: LightArchivedGame.fromServerJson,
        logger: _log,
      ),
    );
  }

  /// Returns the games of the current user, given a list of ids.
  FutureResult<IList<PlayableGame>> getMyGamesByIds(ISet<GameId> ids) {
    if (ids.isEmpty) {
      return Future.value(Result.value(IList<PlayableGame>()));
    }
    return apiClient
        .get(
          Uri.parse(
            '$kLichessHost/api/mobile/my-games?ids=${ids.join(',')}',
          ),
        )
        .flatMap(
          (resp) => Result(() {
            final dynamic list = jsonDecode(utf8.decode(resp.bodyBytes));
            if (list is! List<dynamic>) {
              _log.severe(
                'Could not read games from response: ${resp.body}',
              );
              throw DataFormatException();
            }
            return list;
          }).flatMap(
            (list) => readJsonListOfObjects(
              list,
              mapper: PlayableGame.fromServerJson,
              logger: _log,
            ),
          ),
        );
  }

  FutureResult<IList<LightArchivedGame>> getGamesByIds(ISet<GameId> ids) {
    return apiClient
        .post(
          Uri.parse(
            '$kLichessHost/api/games/export/_ids?moves=false&lastFen=true',
          ),
          headers: {'Accept': 'application/x-ndjson'},
          body: ids.join(','),
        )
        .flatMap(
          (r) => readNdJsonListFromResponse(
            r,
            mapper: LightArchivedGame.fromServerJson,
            logger: _log,
          ),
        );
  }
}
