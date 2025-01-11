import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:http/http.dart' as http;
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/game/archived_game.dart';
import 'package:lichess_mobile/src/model/game/game_filter.dart';
import 'package:lichess_mobile/src/model/game/playable_game.dart';
import 'package:lichess_mobile/src/network/http.dart';

class GameRepository {
  const GameRepository(this.client);

  final LichessClient client;

  Future<ArchivedGame> getGame(GameId id) {
    return client.readJson(
      Uri(path: '/game/export/$id', queryParameters: {'clocks': '1', 'accuracy': '1'}),
      headers: {'Accept': 'application/json'},
      mapper: ArchivedGame.fromServerJson,
    );
  }

  Future<void> requestServerAnalysis(GameId id) async {
    final uri = Uri(path: '/$id/request-analysis');
    final response = await client.post(Uri(path: '/$id/request-analysis'));
    if (response.statusCode >= 400) {
      throw http.ClientException('Failed to request analysis: ${response.statusCode}', uri);
    }
  }

  Future<IList<LightArchivedGameWithPov>> getUserGames(
    UserId userId, {
    int max = 20,
    DateTime? until,
    GameFilterState filter = const GameFilterState(),
  }) {
    assert(!filter.perfs.contains(Perf.fromPosition));
    assert(!filter.perfs.contains(Perf.puzzle));
    assert(!filter.perfs.contains(Perf.storm));
    assert(!filter.perfs.contains(Perf.streak));
    return client
        .readNdJsonList(
          Uri(
            path: '/api/games/user/$userId',
            queryParameters: {
              'max': max.toString(),
              if (until != null) 'until': until.millisecondsSinceEpoch.toString(),
              'moves': 'false',
              'lastFen': 'true',
              'accuracy': 'true',
              'opening': 'true',
              if (filter.perfs.isNotEmpty)
                'perfType': filter.perfs.map((perf) => perf.name).join(','),
              if (filter.side != null) 'color': filter.side!.name,
            },
          ),
          headers: {'Accept': 'application/x-ndjson'},
          mapper: LightArchivedGame.fromServerJson,
        )
        .then(
          (value) =>
              value
                  .map(
                    (e) => (
                      game: e,
                      // we know here user is not null for at least one of the players
                      pov: e.white.user?.id == userId ? Side.white : Side.black,
                    ),
                  )
                  .toIList(),
        );
  }

  /// Returns the games of the current user, given a list of ids.
  Future<IList<PlayableGame>> getMyGamesByIds(ISet<GameId> ids) {
    if (ids.isEmpty) {
      return Future.value(IList<PlayableGame>());
    }
    return client.readJsonList(
      Uri(path: '/api/mobile/my-games', queryParameters: {'ids': ids.join(',')}),
      mapper: PlayableGame.fromServerJson,
    );
  }

  Future<IList<LightArchivedGame>> getGamesByIds(ISet<GameId> ids) {
    return client.postReadNdJsonList(
      Uri(path: '/api/games/export/_ids', queryParameters: {'moves': 'false', 'lastFen': 'true'}),
      headers: {'Accept': 'application/x-ndjson'},
      body: ids.join(','),
      mapper: LightArchivedGame.fromServerJson,
    );
  }
}
