import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_repository_providers.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';

part 'archived_game_controller.g.dart';

@riverpod
class ArchivedGameController extends _$ArchivedGameController {
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

  FutureOr<String> getAnalysisPgn() async {
    final (game, _) = state.requireValue;
    if (game.data.hasServerAnalysis) {
      return ref.read(gameAnalysisPgnProvider(id: game.data.id).future);
    }
    return game.pgn;
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
