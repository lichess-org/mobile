import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_repository_providers.dart';

part 'archived_game_screen_providers.g.dart';

@riverpod
class IsBoardTurned extends _$IsBoardTurned {
  @override
  bool build() {
    return false;
  }

  void toggle() {
    state = !state;
  }
}

@riverpod
bool canGoForward(CanGoForwardRef ref, GameId id) {
  final gameCursor = ref.watch(gameCursorProvider(id));
  if (gameCursor.hasValue) {
    final (game, cursor) = gameCursor.value!;
    final stepsLength = game.steps.length;
    return cursor < stepsLength - 1;
  }
  return false;
}

@riverpod
bool canGoBackward(CanGoBackwardRef ref, GameId id) {
  final gameCursor = ref.watch(gameCursorProvider(id));
  if (gameCursor.hasValue) {
    final (_, cursor) = gameCursor.value!;
    return cursor > 0;
  }
  return false;
}

@riverpod
class GameCursor extends _$GameCursor {
  @override
  FutureOr<(ArchivedGame, int)> build(GameId id) async {
    final data = await ref.watch(archivedGameProvider(id: id).future);

    return (data, data.steps.length - 1);
  }

  void cursorAt(int newPosition) {
    if (state.hasValue) {
      final (game, _) = state.value!;
      state = AsyncValue.data((game, newPosition));
    }
  }

  void cursorForward() {
    if (state.hasValue) {
      final (game, cursor) = state.value!;
      state = AsyncValue.data((game, cursor + 1));
    }
  }

  void cursorBackward() {
    if (state.hasValue) {
      final (game, cursor) = state.value!;
      state = AsyncValue.data((game, cursor - 1));
    }
  }

  void cursorLast() {
    if (state.hasValue) {
      final (game, _) = state.value!;
      state = AsyncValue.data((game, game.steps.length - 1));
    }
  }
}
