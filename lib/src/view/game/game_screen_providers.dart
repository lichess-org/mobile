import 'package:dartchess/dartchess.dart' show Move, Side;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_controller.dart';
import 'package:lichess_mobile/src/model/lobby/create_game_service.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_screen_providers.g.dart';

typedef LoadedGame = ({GameFullId gameId, String? lastFen, Move? lastMove, Side? side});
typedef CurrentGameState = ({
  LoadedGame? game,
  Challenge? challenge,
  ChallengeDeclineReason? declineReason,
});

/// A provider that returns the currently loaded [GameFullId] for the [GameScreen].
///
/// If the [gameId] is provided, it will simply return it.
/// If not, it uses the [CreateGameService] to create a new game from the lobby or from a challenge.
@riverpod
class CurrentGame extends _$CurrentGame {
  @override
  Future<CurrentGameState> build({
    GameSeek? seek,
    ChallengeRequest? challenge,
    ({GameFullId gameId, String? lastFen, Move? lastMove, Side? side})? game,
  }) {
    assert(
      game != null || seek != null || challenge != null,
      'Either a seek, challenge or a game id must be provided.',
    );

    final service = ref.watch(createGameServiceProvider);

    if (seek != null) {
      return service
          .newLobbyGame(seek)
          .then(
            (id) => (
              game: (gameId: id, lastFen: null, lastMove: null, side: null),
              challenge: null,
              declineReason: null,
            ),
          );
    } else if (challenge != null) {
      return service
          .newRealTimeChallenge(challenge)
          .then(
            (data) => (
              game: data.gameFullId != null
                  ? (gameId: data.gameFullId!, lastFen: null, lastMove: null, side: null)
                  : null,
              challenge: data.challenge,
              declineReason: data.declineReason,
            ),
          );
    }

    return Future.value((game: game!, challenge: null, declineReason: null));
  }

  /// Search for a new opponent (lobby only).
  Future<void> newOpponent() async {
    if (seek != null) {
      final service = ref.read(createGameServiceProvider);
      state = const AsyncValue.loading();
      state = AsyncValue.data(
        await service
            .newLobbyGame(seek!)
            .then(
              (id) => (
                game: (gameId: id, lastFen: null, lastMove: null, side: null),
                challenge: null,
                declineReason: null,
              ),
            ),
      );
    }
  }

  /// Load a game from its id.
  void loadGame(GameFullId id) {
    state = AsyncValue.data((
      game: (gameId: id, lastFen: null, lastMove: null, side: null),
      challenge: null,
      declineReason: null,
    ));
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
