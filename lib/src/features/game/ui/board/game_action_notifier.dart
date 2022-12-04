import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/common/models.dart';
import '../../data/game_repository.dart';

class GameActionNotifier extends AutoDisposeNotifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() {
    return const AsyncData(null);
  }

  Future<void> abort(GameId id) async {
    state = const AsyncLoading();
    state = (await ref.read(gameRepositoryProvider).abort(id).run()).match(
        (error) => AsyncValue.error(error.message, error.stackTrace),
        AsyncValue.data);
  }

  Future<void> resign(GameId id) async {
    state = const AsyncLoading();
    state = (await ref.read(gameRepositoryProvider).resign(id).run()).match(
        (error) => AsyncValue.error(error.message, error.stackTrace),
        AsyncValue.data);
  }
}

final gameActionProvider =
    AutoDisposeNotifierProvider<GameActionNotifier, AsyncValue<void>>(
        GameActionNotifier.new);
