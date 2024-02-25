import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:http/http.dart' as http;
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/archived_game.dart';
import 'package:lichess_mobile/src/model/game/playable_game.dart';

class GameRepository {
  const GameRepository(this.client);

  final http.Client client;

  Future<ArchivedGame> getGame(GameId id) {
    return client.readJson(
      Uri.parse('$kLichessHost/game/export/$id?accuracy=1&clocks=1'),
      headers: {'Accept': 'application/json'},
      mapper: ArchivedGame.fromServerJson,
    );
  }

  Future<void> requestServerAnalysis(GameId id) async {
    final uri = Uri.parse('$kLichessHost/$id/request-analysis');
    final response = await client.post(
      Uri.parse('$kLichessHost/$id/request-analysis'),
    );
    if (response.statusCode >= 400) {
      throw http.ClientException(
        'Failed to request analysis: ${response.statusCode}',
        uri,
      );
    }
  }

  Future<IList<LightArchivedGame>> getRecentGames(UserId userId) {
    return client.readNdJsonList(
      Uri.parse(
        '$kLichessHost/api/games/user/$userId?max=10&moves=false&lastFen=true&accuracy=true&opening=true',
      ),
      headers: {'Accept': 'application/x-ndjson'},
      mapper: LightArchivedGame.fromServerJson,
    );
  }

  Future<FullGamePaginator> getFullGames(
    UserId userId,
    int page,
  ) {
    return client.readJson(
      Uri.parse('$kLichessHost/@/$userId/all?page=$page'),
      headers: {'Accept': 'application/json'},
      mapper: FullGamePaginator.fromServerJson,
    );
  }

  /// Returns the games of the current user, given a list of ids.
  Future<IList<PlayableGame>> getMyGamesByIds(ISet<GameId> ids) {
    if (ids.isEmpty) {
      return Future.value(IList<PlayableGame>());
    }
    return client.readJsonList(
      Uri.parse(
        '$kLichessHost/api/mobile/my-games?ids=${ids.join(',')}',
      ),
      mapper: PlayableGame.fromServerJson,
    );
  }

  Future<IList<LightArchivedGame>> getGamesByIds(ISet<GameId> ids) {
    return client.postReadNdJsonList(
      Uri.parse(
        '$kLichessHost/api/games/export/_ids?moves=false&lastFen=true',
      ),
      headers: {'Accept': 'application/x-ndjson'},
      body: ids.join(','),
      mapper: LightArchivedGame.fromServerJson,
    );
  }
}
