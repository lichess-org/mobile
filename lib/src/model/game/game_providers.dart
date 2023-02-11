import 'package:async/async.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'game.dart';
import 'game_repository.dart';

part 'game_providers.g.dart';

@Riverpod(keepAlive: true)
Future<ArchivedGame> archivedGame(
  ArchivedGameRef ref, {
  required GameId id,
}) {
  final repo = ref.watch(gameRepositoryProvider);
  return Result.release(repo.getGame(id));
}
