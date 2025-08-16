import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/game/exported_game.dart';
import 'package:lichess_mobile/src/model/game/game_filter.dart';
import 'package:lichess_mobile/src/model/game/playable_game.dart';
import 'package:lichess_mobile/src/network/aggregator.dart';
import 'package:lichess_mobile/src/network/http.dart';

/// A provider for the [GameRepository].
final gameRepositoryProvider = Provider<GameRepository>((ref) {
  final client = ref.read(lichessClientProvider);
  final aggregator = ref.read(aggregatorProvider);
  return GameRepository(client, aggregator);
}, name: 'GameRepositoryProvider');

class GameRepository {
  const GameRepository(this.client, this.aggregator);

  final LichessClient client;
  final Aggregator aggregator;

  Future<ExportedGame> getGame(GameId id, {bool withBookmarked = false}) {
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
      mapper: (json) => ExportedGame.fromServerJson(json, withBookmarked: withBookmarked),
    );
  }

  Future<void> requestServerAnalysis(GameId id) async {
    final uri = Uri(path: '/$id/request-analysis');
    final response = await client.post(Uri(path: '/$id/request-analysis'));
    if (response.statusCode >= 400) {
      throw http.ClientException('Failed to request analysis: ${response.statusCode}', uri);
    }
  }

  Future<IList<LightExportedGameWithPov>> getUserGames(
    UserId userId, {
    int max = 20,
    DateTime? until,
    GameFilterState filter = const GameFilterState(),
    bool withBookmarked = false,
    bool withMoves = false,
  }) {
    assert(!filter.perfs.contains(Perf.fromPosition));
    assert(!filter.perfs.contains(Perf.puzzle));
    assert(!filter.perfs.contains(Perf.storm));
    assert(!filter.perfs.contains(Perf.streak));
    return aggregator
        .readNdJsonList(
          Uri(
            path: '/api/games/user/$userId',
            queryParameters: {
              'max': max.toString(),
              if (until != null) 'until': until.millisecondsSinceEpoch.toString(),
              'moves': withMoves ? 'true' : 'false',
              'lastFen': 'true',
              'accuracy': 'true',
              'opening': 'true',
              if (filter.perfs.isNotEmpty)
                'perfType': filter.perfs.map((perf) => perf.name).join(','),
              if (filter.side != null) 'color': filter.side!.name,
              if (filter.opponent != null) 'vs': filter.opponent!.id.value,
              if (withBookmarked) 'withBookmarked': 'true',
            },
          ),
          headers: {'Accept': 'application/x-ndjson'},
          mapper: (json) => LightExportedGame.fromServerJson(json, withBookmarked: withBookmarked),
        )
        .then(
          (value) => value
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

  Future<IList<LightExportedGameWithPov>> getBookmarkedGames(
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
          mapper: (json) => LightExportedGame.fromServerJson(json, isBookmarked: true),
        )
        .then(
          (value) => value
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

  Future<IList<LightExportedGame>> getGamesByIds(ISet<GameId> ids) {
    return client.postReadNdJsonList(
      Uri(path: '/api/games/export/_ids', queryParameters: {'moves': 'false', 'lastFen': 'true'}),
      headers: {'Accept': 'application/x-ndjson'},
      body: ids.join(','),
      mapper: LightExportedGame.fromServerJson,
    );
  }

  Future<void> saveForecast({
    required GameFullId gameId,
    required String forecast,
    Move? moveToPlay,
  }) async {
    final uri = Uri(
      path: moveToPlay != null ? '$gameId/forecasts/${moveToPlay.uci}' : '$gameId/forecasts',
    );
    final response = await client.post(
      uri,
      body: forecast,
      headers: {'Content-type': 'application/json'},
    );
    if (response.statusCode >= 400) {
      throw http.ClientException(
        'Failed to save forecast: ${response.body} (${response.statusCode})',
        uri,
      );
    }
  }

  Future<PlayableGame> getActiveCorrespondenceGame(GameFullId id) {
    return client.readJson(
      Uri(path: '/$id/forecasts'),
      headers: {'Accept': 'application/json'},
      mapper: PlayableGame.fromServerJson,
    );
  }
}
