import 'package:async/async.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:logging/logging.dart';

import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/auth/auth_client.dart';
import 'package:lichess_mobile/src/utils/riverpod.dart';
import 'game.dart';
import 'game_repository.dart';

part 'game_repository_providers.g.dart';

@Riverpod(keepAlive: true)
GameRepository gameRepository(GameRepositoryRef ref) {
  final apiClient = ref.watch(authClientProvider);
  return GameRepository(Logger('GameRepository'), apiClient: apiClient);
}

@Riverpod(keepAlive: true)
Future<ArchivedGame> archivedGame(
  ArchivedGameRef ref, {
  required GameId id,
}) {
  final repo = ref.watch(gameRepositoryProvider);
  return Result.release(repo.getGame(id));
}

@riverpod
Future<IList<ArchivedGameData>> userRecentGames(
  UserRecentGamesRef ref, {
  required UserId userId,
}) async {
  final link = ref.cacheFor(const Duration(minutes: 5));
  final repo = ref.watch(gameRepositoryProvider);
  final result = await repo.getUserGames(userId);
  if (result.isError) {
    link.close();
  }
  return result.asFuture;
}

@Riverpod(keepAlive: true)
Future<IList<ArchivedGameData>> gamesById(
  GamesByIdRef ref, {
  required ISet<GameId> ids,
}) {
  final repo = ref.watch(gameRepositoryProvider);
  return Result.release(repo.getGamesByIds(ids));
}
