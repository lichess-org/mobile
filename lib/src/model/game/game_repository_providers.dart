import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/exported_game.dart';
import 'package:lichess_mobile/src/model/game/game_repository.dart';

final archivedGameProvider = FutureProvider.autoDispose.family<ExportedGame, GameId>((
  Ref ref,
  GameId id,
) {
  final isLoggedIn = ref.watch(isLoggedInProvider);
  return ref.read(gameRepositoryProvider).getGame(id, withBookmarked: isLoggedIn);
}, name: 'ArchivedGameProvider');

final gamesByIdProvider = FutureProvider.autoDispose.family<IList<LightExportedGame>, ISet<GameId>>(
  (Ref ref, ISet<GameId> ids) {
    return ref.read(gameRepositoryProvider).getGamesByIds(ids);
  },
  name: 'GamesByIdProvider',
);
