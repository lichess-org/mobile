import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_screen_providers.g.dart';

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
Future<bool> shouldPreventGoingBack(
  ShouldPreventGoingBackRef ref,
  GameFullId gameId,
) {
  return ref.watch(
    gameControllerProvider(gameId).selectAsync(
      (state) =>
          state.game.speed != Speed.correspondence && state.game.playable,
    ),
  );
}

/// User game preferences, defined server-side.
@riverpod
Future<({GamePrefs? prefs, bool shouldConfirmMove, bool isZenModeEnabled})>
    userGamePrefs(
  UserGamePrefsRef ref,
  GameFullId gameId,
) async {
  final prefs = await ref.watch(
    gameControllerProvider(gameId).selectAsync((state) => state.game.prefs),
  );
  final shouldConfirmMove = await ref.watch(
    gameControllerProvider(gameId).selectAsync(
      (state) => state.shouldConfirmMove,
    ),
  );
  final isZenModeEnabled = await ref.watch(
    gameControllerProvider(gameId).selectAsync(
      (state) => state.isZenModeEnabled,
    ),
  );
  return (
    prefs: prefs,
    shouldConfirmMove: shouldConfirmMove,
    isZenModeEnabled: isZenModeEnabled
  );
}

/// Returns the [PlayableGameMeta].
///
/// This is data that won't change during the game.
@riverpod
Future<PlayableGameMeta> gameMeta(
  GameMetaRef ref,
  GameFullId gameId,
) async {
  return await ref.watch(
    gameControllerProvider(gameId).selectAsync((state) => state.game.meta),
  );
}
