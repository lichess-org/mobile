import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/exported_game.dart';
import 'package:lichess_mobile/src/model/game/game_repository.dart';
import 'package:lichess_mobile/src/model/game/game_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_repository_providers.g.dart';

/// Fetches a game from the server or from the local storage if not available online.
@riverpod
Future<ExportedGame> archivedGame(Ref ref, {required GameId id}) async {
  ExportedGame game;
  try {
    final isLoggedIn = ref.watch(isLoggedInProvider);
    game = await ref
        .read(gameRepositoryProvider)
        .getGame(id, withBookmarked: isLoggedIn);
  } catch (_) {
    final gameStorage = await ref.watch(gameStorageProvider.future);
    final storedGame = await gameStorage.fetch(gameId: id);
    if (storedGame != null) {
      game = storedGame;
    } else {
      throw Exception('Game $id not found in local storage.');
    }
  }
  return game;
}

@riverpod
Future<IList<LightExportedGame>> gamesById(
  Ref ref, {
  required ISet<GameId> ids,
}) {
  return ref.read(gameRepositoryProvider).getGamesByIds(ids);
}
