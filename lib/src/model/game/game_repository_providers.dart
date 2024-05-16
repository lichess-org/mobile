import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/archived_game.dart';
import 'package:lichess_mobile/src/model/game/game_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'game_repository.dart';

part 'game_repository_providers.g.dart';

/// Fetches a game from the local storage if available, otherwise fetches it from the server.
@riverpod
Future<ArchivedGame> archivedGame(
  ArchivedGameRef ref, {
  required GameId id,
}) async {
  final gameStorage = ref.watch(gameStorageProvider);
  final game = await gameStorage.fetch(gameId: id);
  if (game != null) return game;
  return ref.withClientCacheFor(
    (client) => GameRepository(client).getGame(id),
    const Duration(seconds: 10),
  );
}

@riverpod
Future<IList<LightArchivedGame>> userRecentGames(
  UserRecentGamesRef ref, {
  required UserId userId,
}) {
  return ref.withClientCacheFor(
    (client) => GameRepository(client).getRecentGames(userId),
    // cache is important because the associated widget is in a [ListView] and
    // the provider may be instanciated multiple times in a short period of time
    // (e.g. when scrolling)
    // TODO: consider debouncing the request instead of caching it, or make the
    // request in the parent widget and pass the result to the child
    const Duration(minutes: 1),
  );
}

@riverpod
Future<IList<LightArchivedGame>> gamesById(
  GamesByIdRef ref, {
  required ISet<GameId> ids,
}) {
  return ref.withClient(
    (client) => GameRepository(client).getGamesByIds(ids),
  );
}
