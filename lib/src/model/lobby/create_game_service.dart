import 'dart:async';

import 'package:deep_pick/deep_pick.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_repository.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/model/lobby/lobby_repository.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_game_service.g.dart';
part 'create_game_service.freezed.dart';

/// The user response of a challenge request.
///
/// It can be:
/// - [ChallengeResponseAccepted]: The challenge was accepted and a game was created.
/// - [ChallengeResponseDeclined]: The challenge was declined.
sealed class ChallengeResponse {}

/// The [ChallengeResponse] when challenge was accepted and a game was created.
@freezed
sealed class ChallengeResponseAccepted
    with _$ChallengeResponseAccepted
    implements ChallengeResponse {
  const factory ChallengeResponseAccepted({required GameFullId gameFullId}) =
      _ChallengeResponseAccepted;
}

/// The [ChallengeResponse] when challenge was declined.
@freezed
sealed class ChallengeResponseDeclined
    with _$ChallengeResponseDeclined
    implements ChallengeResponse {
  const factory ChallengeResponseDeclined({
    required Challenge challenge,
    required ChallengeDeclineReason? declineReason,
  }) = _ChallengeResponseDeclined;
}

/// A provider for the [CreateGameService].
@riverpod
CreateGameService createGameService(Ref ref) {
  final service = CreateGameService(Logger('CreateGameService'), ref: ref);
  ref.onDispose(() {
    service.dispose();
  });
  return service;
}

/// A service to create a new game from the lobby or from a challenge.
class CreateGameService {
  CreateGameService(this._log, {required this.ref});

  final Ref ref;
  final Logger _log;

  LichessClient get lichessClient => ref.read(lichessClientProvider);
  ChallengeRepository get challengeRepository =>
      ref.read(challengeRepositoryProvider);

  /// The current lobby connection if we are creating a game from the lobby.
  StreamSubscription<SocketEvent>? _lobbyConnection;

  /// The current challenge connection if we are creating a game from a challenge.
  (
    ChallengeId,
    StreamSubscription<void>, // socket connects events
    StreamSubscription<SocketEvent>, // socket events
  )?
  _challengeConnection;

  Timer? _challengePingTimer;

  /// Create a new game from the lobby.
  Future<GameFullId> newLobbyGame(GameSeek seek) async {
    ref.read(recentGameSeekProvider.notifier).addSeek(seek);
    if (_lobbyConnection != null) {
      throw StateError('Already creating a game.');
    }

    final socketPool = ref.read(socketPoolProvider);
    final socketClient = socketPool.open(Uri(path: '/lobby/socket/v5'));

    // ensure the pending game connection is closed in any case
    final completer = Completer<GameFullId>()..future.whenComplete(dispose);

    _lobbyConnection = socketClient.stream.listen((event) {
      if (event.topic == 'redirect') {
        final data = event.data as Map<String, dynamic>;
        completer.complete(pick(data['id']).asGameFullIdOrThrow());
      }
    });

    _log.info('Creating new online game');

    // wait for the socket to be ready
    await socketClient.firstConnection;

    GameSeek actualSeek = seek;

    // if we have a rating delta, we need to get the account to get the rating
    // and set the rating range
    if (seek.ratingDelta != null) {
      final account = await ref.read(accountProvider.future);
      if (account != null) {
        actualSeek = actualSeek.withRatingRangeOf(account);
      }
    }

    try {
      await LobbyRepository(
        lichessClient,
      ).createSeek(actualSeek, sri: socketClient.sri);
    } catch (e) {
      _log.warning('Failed to create seek', e);
      // if the completer is not yet completed, complete it with an error
      if (!completer.isCompleted) {
        completer.completeError(e);
      }
    }

    return completer.future;
  }

  /// Create a new correspondence game.
  Future<void> newCorrespondenceGame(GameSeek seek) async {
    _log.info('Creating new correspondence game');

    await ref.withClient(
      (client) => LobbyRepository(
        client,
      ).createSeek(seek, sri: ref.read(preloadedDataProvider).requireValue.sri),
    );
  }

  /// Create a new real time challenge.
  ///
  /// Will listen to the challenge socket and await the response from the destinated user.
  Future<ChallengeResponse> newRealTimeChallenge(
    ChallengeRequest challengeReq,
  ) async {
    assert(challengeReq.timeControl == ChallengeTimeControlType.clock);

    if (_challengeConnection != null) {
      throw StateError('Already creating a challenge.');
    }

    // ensure the pending connection is closed in any case
    final completer = Completer<ChallengeResponse>()
      ..future.whenComplete(dispose);

    try {
      _log.info('Creating new challenge game');

      final challenge = await challengeRepository.create(challengeReq);

      final socketPool = ref.read(socketPoolProvider);
      final socketClient = socketPool.open(
        Uri(
          path: '/challenge/${challenge.id}/socket/v5',
          queryParameters: {'v': challenge.socketVersion.toString()},
        ),
      );

      _challengeConnection = (
        challenge.id,
        socketClient.connectedStream.listen((_) {
          socketClient.send('ping', null);
          _challengePingTimer?.cancel();
          _challengePingTimer = Timer.periodic(
            const Duration(seconds: 9),
            (_) => socketClient.send('ping', null),
          );
        }),
        socketClient.stream.listen((event) async {
          if (event.topic == 'reload') {
            try {
              final updatedChallenge = await challengeRepository.show(
                challenge.id,
              );
              if (updatedChallenge.gameFullId != null) {
                completer.complete(
                  ChallengeResponseAccepted(
                    gameFullId: updatedChallenge.gameFullId!,
                  ),
                );
              } else if (updatedChallenge.status == ChallengeStatus.declined) {
                completer.complete(
                  ChallengeResponseDeclined(
                    challenge: challenge,
                    declineReason: updatedChallenge.declineReason,
                  ),
                );
              }
            } catch (e) {
              _log.warning('Failed to reload challenge', e);
            }
          }
        }),
      );
    } catch (e) {
      _log.warning('Failed to create challenge', e);
      // if the completer is not yet completed, complete it with an error
      if (!completer.isCompleted) {
        completer.completeError(e);
      }
    }

    return completer.future;
  }

  /// Create a new correspondence challenge.
  ///
  /// It will wait a little bit in case of an immediate decline (e.g. bots), in that case a
  /// [ChallengeDeclineReason] will be returned.
  /// Otherwise, it means the challenge was created successfully.
  Future<ChallengeDeclineReason?> newCorrespondenceChallenge(
    ChallengeRequest challengeReq,
  ) async {
    assert(
      challengeReq.timeControl == ChallengeTimeControlType.correspondence ||
          challengeReq.timeControl == ChallengeTimeControlType.unlimited,
    );

    if (_challengeConnection != null) {
      throw StateError('Already creating a challenge.');
    }

    // ensure the pending connection is closed in any case
    final completer = Completer<ChallengeDeclineReason?>()
      ..future.whenComplete(dispose);

    try {
      _log.info('Creating new correspondence|unlimited challenge');

      final challenge = await challengeRepository.create(challengeReq);

      final socketPool = ref.read(socketPoolProvider);
      final socketClient = socketPool.open(
        Uri(
          path: '/challenge/${challenge.id}/socket/v5',
          queryParameters: {'v': challenge.socketVersion.toString()},
        ),
      );

      _challengeConnection = (
        challenge.id,
        socketClient.connectedStream.listen((_) {
          socketClient.send('ping', null);
          _challengePingTimer?.cancel();
          _challengePingTimer = Timer.periodic(
            const Duration(seconds: 9),
            (_) => socketClient.send('ping', null),
          );
        }),
        socketClient.stream.listen((event) async {
          if (event.topic == 'reload') {
            try {
              final updatedChallenge = await challengeRepository.show(
                challenge.id,
              );
              if (updatedChallenge.status == ChallengeStatus.declined) {
                completer.complete(
                  updatedChallenge.declineReason ??
                      ChallengeDeclineReason.generic,
                );
              }
            } catch (e) {
              _log.warning('Failed to reload challenge', e);
            }
          }
        }),
      );

      // wait a bit to see if the challenge is declined immediately
      await Future<void>.delayed(const Duration(seconds: 1));
      // if the completer is not yet completed, complete it with null
      if (!completer.isCompleted) {
        completer.complete(null);
      }
    } catch (e) {
      _log.warning('Failed to create challenge', e);
      // if the completer is not yet completed, complete it with an error
      if (!completer.isCompleted) {
        completer.completeError(e);
      }
    }

    return completer.future;
  }

  /// Cancel the current game creation.
  Future<void> cancelSeek() async {
    _log.info('Cancelling game creation');
    final sri = ref.read(preloadedDataProvider).requireValue.sri;
    try {
      await LobbyRepository(lichessClient).cancelSeek(sri: sri);
    } catch (e) {
      _log.warning('Failed to cancel seek: $e', e);
      rethrow;
    }
  }

  Future<void> cancelChallenge() async {
    final id = _challengeConnection?.$1;
    if (id != null) {
      try {
        _log.info('Cancelling challenge');
        await challengeRepository.cancel(id);
      } catch (e) {
        _log.warning('Failed to cancel challenge: $e', e);
        rethrow;
      }
    }
  }

  /// Dispose the service.
  void dispose() {
    _lobbyConnection?.cancel();
    _lobbyConnection = null;
    _challengeConnection?.$2.cancel();
    _challengeConnection?.$3.cancel();
    _challengePingTimer?.cancel();
    _challengeConnection = null;
  }
}
