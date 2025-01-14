import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/archived_game.dart';
import 'package:lichess_mobile/src/model/game/game_repository.dart';
import 'package:lichess_mobile/src/model/game/game_storage.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_repository_providers.g.dart';

/// Fetches a game from the local storage if available, otherwise fetches it from the server.
@riverpod
Future<ArchivedGame> archivedGame(Ref ref, {required GameId id}) async {
  final isLoggedIn = ref.watch(authSessionProvider.select((session) => session != null));
  final gameStorage = await ref.watch(gameStorageProvider.future);
  final game = await gameStorage.fetch(gameId: id);
  if (game != null) return game;
  return ref.withClientCacheFor(
    (client) => GameRepository(client).getGame(id, withBookmarked: isLoggedIn),
    const Duration(seconds: 10),
  );
}

@riverpod
Future<IList<LightArchivedGame>> gamesById(Ref ref, {required ISet<GameId> ids}) {
  return ref.withClient((client) => GameRepository(client).getGamesByIds(ids));
}
