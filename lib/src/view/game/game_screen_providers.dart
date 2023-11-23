import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/lobby/lobby_game.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/model/game/game_controller.dart';
import 'package:lichess_mobile/src/model/game/game.dart';

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
Future<bool> lobbyGameIsPlayable(
  LobbyGameIsPlayableRef ref,
  GameSeek seek,
) async {
  final (gameId, fromRematch: _) =
      await ref.watch(lobbyGameProvider(seek).future);
  return ref.watch(
    gameControllerProvider(gameId).selectAsync((state) => state.game.playable),
  );
}

@riverpod
Future<bool> gameIsPlayable(
  GameIsPlayableRef ref,
  GameFullId gameId,
) {
  return ref.watch(
    gameControllerProvider(gameId).selectAsync((state) => state.game.playable),
  );
}

@riverpod
Future<({GamePrefs? prefs, bool shouldConfirmMove, bool isZenModeEnabled})>
    gamePrefs(
  GamePrefsRef ref,
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

/// Returns the [GameMeta] and the [ClockData] of a game.
///
/// This is data won't change during the game.
@riverpod
Future<(PlayableGameMeta, ClockData?, ({int daysPerTurn})?)> gameMeta(
  GameMetaRef ref,
  GameFullId gameId,
) async {
  final meta = await ref.watch(
    gameControllerProvider(gameId).selectAsync((state) => state.game.meta),
  );
  final initial = await ref.watch(
    gameControllerProvider(gameId)
        .selectAsync((state) => state.game.clock?.initial),
  );
  final increment = await ref.watch(
    gameControllerProvider(gameId)
        .selectAsync((state) => state.game.clock?.increment),
  );
  final days = await ref.watch(
    gameControllerProvider(gameId).selectAsync(
      (state) => state.game.correspondenceClock?.daysPerTurn,
    ),
  );
  return (
    meta,
    initial != null && increment != null
        ? ClockData(initial: initial, increment: increment)
        : null,
    days != null ? (daysPerTurn: days) : null,
  );
}
