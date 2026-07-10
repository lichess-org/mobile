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
