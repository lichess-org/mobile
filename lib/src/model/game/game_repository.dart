import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:http/http.dart' as http;
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/game/archived_game.dart';
import 'package:lichess_mobile/src/model/game/game_filter.dart';
import 'package:lichess_mobile/src/model/game/playable_game.dart';
import 'package:lichess_mobile/src/network/http.dart';

class GameRepository {
  const GameRepository(this.client);

  final LichessClient client;

  Future<ArchivedGame> getGame(GameId id, {bool withBookmarked = false}) {
    return client.readJson(
      Uri(
        path: '/game/export/$id',
        queryParameters: {
          'clocks': '1',
          'accuracy': '1',
          if (withBookmarked) 'withBookmarked': '1',
        },
      ),
      headers: {'Accept': 'application/json'},
      mapper: (json) => ArchivedGame.fromServerJson(json, withBookmarked: withBookmarked),
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
    bool withBookmarked = false,
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
              if (withBookmarked) 'withBookmarked': 'true',
            },
          ),
          headers: {'Accept': 'application/x-ndjson'},
          mapper: (json) => LightArchivedGame.fromServerJson(json, withBookmarked: withBookmarked),
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

  Future<IList<LightArchivedGameWithPov>> getBookmarkedGames(
    AuthSessionState session, {
    int max = 20,
    DateTime? until,
  }) {
    return client
        .readNdJsonList(
          Uri(
            path: '/api/games/export/bookmarks',
            queryParameters: {
              'max': max.toString(),
              if (until != null) 'until': until.millisecondsSinceEpoch.toString(),
              'moves': 'false',
              'lastFen': 'true',
              'accuracy': 'true',
              'opening': 'true',
            },
          ),
          headers: {'Accept': 'application/x-ndjson'},
          mapper: (json) => LightArchivedGame.fromServerJson(json, isBookmarked: true),
        )
        .then(
          (value) =>
              value
                  .map(
                    (e) => (
                      game: e,
                      // we know here user is not null for at least one of the players
                      pov: e.white.user?.id == session.user.id ? Side.white : Side.black,
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
