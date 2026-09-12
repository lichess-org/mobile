import 'package:dartchess/dartchess.dart' show Side;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_controller.dart';
import 'package:lichess_mobile/src/model/lobby/create_game_service.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';

part 'game_screen_providers.freezed.dart';

/// The state of the [GameScreen].
///
/// It can be:
/// - [GameCreatedState]: A game has been created or loaded.
/// - [ChallengeDeclinedState]: A real time challenge has been declined.
/// - [SeekCancelledState]: A game seek has been cancelled.
/// - [ChallengeCancelledState]: A real time challenge has been cancelled.
sealed class GameScreenState();

/// Game screen state when a game has been created or loaded.
///
/// This is used in the following cases:
/// - A game that had already been created is loaded.
/// - A game has been created from a lobby seek.
/// - A challenge has been accepted and a game has been created from it.
@freezed
sealed class const GameCreatedState._() with _$GameCreatedState implements GameScreenState {
  const factory(GameFullId createdGameId) = _GameCreatedState;
}

/// An open challenge has been created but not yet accepted.
/// We're waiting for someone to accept it via the challenge link.
@freezed
sealed class const OpenChallengeCreatedState._()
    with _$OpenChallengeCreatedState
    implements GameScreenState {
  const factory(Challenge challenge) = _OpenChallengeCreatedState;
}

/// We challenged another user and are currently waiting for them to accept or decline.
@freezed
sealed class const UserChallengeCreatedState._()
    with _$UserChallengeCreatedState
    implements GameScreenState {
  const factory(Challenge challenge) = _UserChallengeCreatedState;
}

/// A real time challenge has been declined.
@freezed
sealed class const ChallengeDeclinedState._()
    with _$ChallengeDeclinedState
    implements GameScreenState {
  const factory(ChallengeResponseDeclined response) = _ChallengeDeclinedState;
}

/// A game seek has been cancelled.
@freezed
sealed class const SeekCancelledState._() with _$SeekCancelledState implements GameScreenState {
  const factory() = _SeekCancelledState;
}

/// A real time challenge has been cancelled.
@freezed
sealed class const ChallengeCancelledState._()
    with _$ChallengeCancelledState
    implements GameScreenState {
  const factory() = _ChallengeCancelledState;
}

/// The source from which the [GameScreen] was opened.
///
/// It can be:
/// - An existing game, see [ExistingGameSource].
/// - A lobby seek, see [LobbySource].
/// - A user challenge, see [UserChallengeSource].
///
/// In case of a lobby seek or a user challenge, a new game will be created and the screen will show
/// a loading indicator until the game is created.
sealed class GameScreenSource();

/// An existing game source for [GameScreen], identified by its [GameFullId].
@freezed
sealed class const ExistingGameSource._() with _$ExistingGameSource implements GameScreenSource {
  const factory(GameFullId id) = _ExistingGameSource;
}

/// A lobby source for [GameScreen], identified by the [GameSeek] from which the game will be created.
@freezed
sealed class const LobbySource._() with _$LobbySource implements GameScreenSource {
  const factory(GameSeek seek) = _LobbySource;
}

/// A user challenge source for [GameScreen], identified by the [ChallengeRequest] from which the game will be created.
@freezed
sealed class const UserChallengeSource._() with _$UserChallengeSource implements GameScreenSource {
  const factory(ChallengeRequest challengeRequest) = _UserChallengeSource;
}

/// A provider that loads or creates a game for the [GameScreen].
final gameScreenLoaderProvider = AsyncNotifierProvider.autoDispose
    .family<GameScreenLoaderNotifier, GameScreenState, GameScreenSource>(
      GameScreenLoaderNotifier.new,
      name: 'GameScreenLoaderProvider',
    );

class GameScreenLoaderNotifier(final GameScreenSource source)
    extends AsyncNotifier<GameScreenState> {
  @override
  Future<GameScreenState> build() async {
    final service = ref.watch(createGameServiceProvider);

    switch (source) {
      case LobbySource(:final seek):
        return await service
            .newLobbyGame(seek)
            .then(
              (data) => switch (data) {
                GameSeekCreated(:final fullId) => GameCreatedState(fullId),
                GameSeekCancelled() => const SeekCancelledState(),
              },
            );
      case UserChallengeSource(:final challengeRequest):
        {
          final challenge = await service.newOpenOrRealTimeChallenge(challengeRequest);
          service.waitForChallengeResponse(challenge).then((data) {
            if (!ref.mounted) return;
            state = AsyncValue.data(switch (data) {
              ChallengeResponseAccepted(:final gameFullId) => GameCreatedState(gameFullId),
              ChallengeResponseDeclined() => ChallengeDeclinedState(data),
              ChallengeResponseCancelled() => const ChallengeCancelledState(),
            });
          });
          return await Future.value(
            challenge.destUser != null
                ? UserChallengeCreatedState(challenge)
                : OpenChallengeCreatedState(challenge),
          );
        }
      case ExistingGameSource(:final id):
        return await Future.value(GameCreatedState(id));
    }
  }

  /// Search for a new opponent (lobby only).
  Future<void> newOpponent() async {
    if (source case LobbySource(:final seek)) {
      final service = ref.read(createGameServiceProvider);
      state = const AsyncValue.loading();
      state = AsyncValue.data(
        await service
            .newLobbyGame(seek)
            .then(
              (data) => switch (data) {
                GameSeekCreated(:final fullId) => GameCreatedState(fullId),
                GameSeekCancelled() => const SeekCancelledState(),
              },
            ),
      );
    }
  }

  /// Load a game from its id.
  void loadGame(GameFullId id) {
    state = AsyncValue.data(GameCreatedState(id));
  }
}

final isBoardTurnedProvider = NotifierProvider.autoDispose<IsBoardTurnedNotifier, bool>(
  IsBoardTurnedNotifier.new,
  name: 'IsBoardTurnedProvider',
);

class IsBoardTurnedNotifier() extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void toggle() {
    state = !state;
  }
}

/// A provider that indicates whether the game is bookmarked.
final isGameBookmarkedProvider = FutureProvider.autoDispose.family<bool, GameFullId>((
  Ref ref,
  GameFullId gameId,
) async {
  return (await ref.watch(gameControllerProvider(gameId).future)).game.bookmarked ?? false;
}, name: 'IsGameBookmarkedProvider');

/// A provider that exposes data needed for sharing the game.
final gameShareDataProvider = FutureProvider.autoDispose
    .family<({bool finished, Side? pov}), GameFullId>((Ref ref, GameFullId gameId) async {
      final state = await ref.watch(gameControllerProvider(gameId).future);
      return (finished: state.game.finished, pov: state.game.youAre);
    }, name: 'GameShareDataProvider');

/// User game preferences, defined server-side.
final userGamePrefsProvider = FutureProvider.autoDispose
    .family<
      ({ServerGamePrefs? prefs, bool shouldConfirmMove, bool isZenModeEnabled, bool canAutoQueen}),
      GameFullId
    >((Ref ref, GameFullId gameId) async {
      final state = await ref.watch(gameControllerProvider(gameId).future);
      return (
        prefs: state.game.prefs,
        shouldConfirmMove: state.shouldConfirmMove,
        isZenModeEnabled: state.isZenModeEnabled,
        canAutoQueen: state.canAutoQueen,
      );
    }, name: 'UserGamePrefsProvider');
