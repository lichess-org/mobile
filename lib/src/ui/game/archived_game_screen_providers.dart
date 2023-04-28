import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuple/tuple.dart';

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
    final stepsLength = gameCursor.value!.item1.steps.length;
    final cursor = gameCursor.value!.item2;
    return cursor < stepsLength - 1;
  }
  return false;
}

@riverpod
bool canGoBackward(CanGoBackwardRef ref, GameId id) {
  final gameCursor = ref.watch(gameCursorProvider(id));
  if (gameCursor.hasValue) {
    final cursor = gameCursor.value!.item2;
    return cursor > 0;
  }
  return false;
}

@riverpod
class GameCursor extends _$GameCursor {
  @override
  FutureOr<Tuple2<ArchivedGame, int>> build(GameId id) async {
    final data = await ref.watch(archivedGameProvider(id: id).future);

    return Tuple2(data, data.steps.length - 1);
  }

  void cursorAt(int newPosition) {
    if (state.hasValue) {
      state = AsyncValue.data(state.value!.withItem2(newPosition));
    }
  }

  void cursorForward() {
    if (state.hasValue) {
      final current = state.value!;
      state = AsyncValue.data(current.withItem2(current.item2 + 1));
    }
  }

  void cursorBackward() {
    if (state.hasValue) {
      final current = state.value!;
      state = AsyncValue.data(current.withItem2(current.item2 - 1));
    }
  }

  void cursorLast() {
    if (state.hasValue) {
      final current = state.value!;
      state =
          AsyncValue.data(current.withItem2(current.item1.steps.length - 1));
    }
  }
}
