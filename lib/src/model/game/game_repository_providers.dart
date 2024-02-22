import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/archived_game.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'game_repository.dart';

part 'game_repository_providers.g.dart';

@riverpod
Future<ArchivedGame> archivedGame(ArchivedGameRef ref, {required GameId id}) {
  return ref.withClient(
    (client) => GameRepository(client).getGame(id),
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
