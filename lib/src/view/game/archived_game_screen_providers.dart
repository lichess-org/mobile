import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/game/exported_game.dart';
import 'package:lichess_mobile/src/model/game/game_repository_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
bool canGoForward(Ref ref, GameId id) {
  final gameCursor = ref.watch(gameCursorProvider(id));
  if (gameCursor.hasValue) {
    final (game, cursor) = gameCursor.value!;
    final stepsLength = game.steps.length;
    return cursor < stepsLength - 1;
  }
  return false;
}

@riverpod
bool canGoBackward(Ref ref, GameId id) {
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
  FutureOr<(ExportedGame, int)> build(GameId id) async {
    final data = await ref.watch(archivedGameProvider(id: id).future);

    return (data, data.steps.length - 1);
  }

  void cursorAt(int newPosition) {
    assert(newPosition >= 0);
    if (state.hasValue) {
      final (game, _) = state.value!;
      state = AsyncValue.data((game, newPosition));
    }
  }

  void cursorForward() {
    if (state.hasValue) {
      final (game, cursor) = state.value!;
      if (cursor < game.steps.length - 1) {
        state = AsyncValue.data((game, cursor + 1));
        final san = game.stepAt(cursor + 1).sanMove?.san;
        if (san != null) {
          _playMoveSound(san);
        }
      }
    }
  }

  void cursorBackward() {
    if (state.hasValue) {
      final (game, cursor) = state.value!;
      if (cursor > 0) {
        state = AsyncValue.data((game, cursor - 1));
        final san = game.stepAt(cursor - 1).sanMove?.san;
        if (san != null) {
          _playMoveSound(san);
        }
      }
    }
  }

  void _playMoveSound(String san) {
    final soundService = ref.read(soundServiceProvider);
    if (san.contains('x')) {
      soundService.play(Sound.capture);
    } else {
      soundService.play(Sound.move);
    }
  }
}
