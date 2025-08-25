import 'package:dartchess/dartchess.dart' show Side;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_controller.dart';
import 'package:lichess_mobile/src/model/lobby/create_game_service.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_screen_providers.g.dart';
part 'game_screen_providers.freezed.dart';

sealed class CurrentGameState {}

/// This is used in the following cases:
/// - A game that had already been created is loaded.
/// - A game has been created from a lobby seek.
/// - A challenge has been accepted and a game has been created from it.
@freezed
sealed class GameCreatedState with _$GameCreatedState implements CurrentGameState {
  const GameCreatedState._();

  const factory GameCreatedState(GameFullId createdGameId) = _GameCreatedState;
}

/// A real time challenge has been declined.
@freezed
sealed class ChallengeDeclinedState with _$ChallengeDeclinedState implements CurrentGameState {
  const ChallengeDeclinedState._();

  const factory ChallengeDeclinedState(ChallengeDeclinedResponse response) =
      _ChallengeDeclinedState;
}

sealed class GameScreenSource {}

@freezed
sealed class ExistingGameSource with _$ExistingGameSource implements GameScreenSource {
  const ExistingGameSource._();

  const factory ExistingGameSource(GameFullId id) = _ExistingGameSource;
}

@freezed
sealed class LobbySource with _$LobbySource implements GameScreenSource {
  const LobbySource._();

  const factory LobbySource(GameSeek seek) = _LobbySource;
}

@freezed
sealed class UserChallengeSource with _$UserChallengeSource implements GameScreenSource {
  const UserChallengeSource._();

  const factory UserChallengeSource(ChallengeRequest challengeRequest) = _UserChallengeSource;
}

/// A provider that returns the currently loaded [GameFullId] for the [GameScreen].
///
/// If the [gameId] is provided, it will simply return it.
/// If not, it uses the [CreateGameService] to create a new game from the lobby or from a challenge.
@riverpod
class CurrentGame extends _$CurrentGame {
  @override
  Future<CurrentGameState> build(GameScreenSource source) {
    final service = ref.watch(createGameServiceProvider);

    return switch (source) {
      LobbySource(:final seek) => service.newLobbyGame(seek).then((id) => GameCreatedState(id)),
      UserChallengeSource(:final challengeRequest) =>
        service
            .newRealTimeChallenge(challengeRequest)
            .then(
              (data) => switch (data) {
                ChallengeAcceptedResponse(:final gameFullId) => GameCreatedState(gameFullId),
                ChallengeDeclinedResponse() => ChallengeDeclinedState(data),
              },
            ),
      ExistingGameSource(:final id) => Future.value(GameCreatedState(id)),
    };
  }

  /// Search for a new opponent (lobby only).
  Future<void> newOpponent() async {
    if (source case LobbySource(:final seek)) {
      final service = ref.read(createGameServiceProvider);
      state = const AsyncValue.loading();
      state = AsyncValue.data(await service.newLobbyGame(seek).then((id) => GameCreatedState(id)));
    }
  }

  /// Load a game from its id.
  void loadGame(GameFullId id) {
    state = AsyncValue.data(GameCreatedState(id));
  }
}

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
Future<bool> isGameBookmarked(Ref ref, GameFullId gameId) {
  return ref.watch(
    gameControllerProvider(gameId).selectAsync((state) => state.game.bookmarked ?? false),
  );
}

@riverpod
Future<({bool finished, Side? pov})> gameShareData(Ref ref, GameFullId gameId) {
  return ref.watch(
    gameControllerProvider(
      gameId,
    ).selectAsync((state) => (finished: state.game.finished, pov: state.game.youAre)),
  );
}

@riverpod
Future<bool> isRealTimePlayableGame(Ref ref, GameFullId gameId) {
  return ref.watch(
    gameControllerProvider(
      gameId,
    ).selectAsync((state) => state.game.meta.speed != Speed.correspondence && state.game.playable),
  );
}

/// User game preferences, defined server-side.
@riverpod
Future<({ServerGamePrefs? prefs, bool shouldConfirmMove, bool isZenModeEnabled, bool canAutoQueen})>
userGamePrefs(Ref ref, GameFullId gameId) async {
  final prefs = await ref.watch(
    gameControllerProvider(gameId).selectAsync((state) => state.game.prefs),
  );
  final shouldConfirmMove = await ref.watch(
    gameControllerProvider(gameId).selectAsync((state) => state.shouldConfirmMove),
  );
  final isZenModeEnabled = await ref.watch(
    gameControllerProvider(gameId).selectAsync((state) => state.isZenModeEnabled),
  );
  final canAutoQueen = await ref.watch(
    gameControllerProvider(gameId).selectAsync((state) => state.canAutoQueen),
  );
  return (
    prefs: prefs,
    shouldConfirmMove: shouldConfirmMove,
    isZenModeEnabled: isZenModeEnabled,
    canAutoQueen: canAutoQueen,
  );
}

/// Returns the [PlayableGameMeta].
///
/// This is data that won't change during the game.
@riverpod
Future<GameMeta> gameMeta(Ref ref, GameFullId gameId) async {
  return await ref.watch(gameControllerProvider(gameId).selectAsync((state) => state.game.meta));
}

@riverpod
Future<TournamentMeta?> gameTournament(Ref ref, GameFullId gameId) async {
  return await ref.watch(gameControllerProvider(gameId).selectAsync((state) => state.tournament));
}
