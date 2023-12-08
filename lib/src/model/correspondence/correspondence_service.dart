import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_client.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/auth/bearer.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/correspondence/correspondence_game_storage.dart';
import 'package:lichess_mobile/src/model/correspondence/offline_correspondence_game.dart';
import 'package:lichess_mobile/src/model/game/game_repository_providers.dart';
import 'package:lichess_mobile/src/model/game/game_socket_events.dart';
import 'package:lichess_mobile/src/model/game/playable_game.dart';
import 'package:logging/logging.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'correspondence_service.g.dart';

@Riverpod(keepAlive: true)
CorrespondenceService correspondenceService(CorrespondenceServiceRef ref) {
  return CorrespondenceService(
    Logger('CorrespondenceService'),
    ref: ref,
  );
}

class CorrespondenceService {
  CorrespondenceService(this._log, {required this.ref});

  final CorrespondenceServiceRef ref;
  final Logger _log;

  /// Syncs offline correspondence games with the server.
  Future<void> syncGames() async {
    _log.info('Syncing correspondence games...');

    await playRegisteredMoves();

    final storedOngoingGames = await _storage.fetchOngoingGames();

    // user can have more than 50 ongoing games, but we only sync the 50 most
    // recent ones
    ref.read(accountRepositoryProvider).getOngoingGames(nb: 50).forEach(
      (games) {
        for (final sg in storedOngoingGames) {
          final game = games.firstWhereOrNull((e) => e.id == sg.$2.id);
          if (game == null) {
            _log.info(
              'Deleting correspondence game ${sg.$2.id} because it is not present on the server anymore',
            );
            _storage.delete(sg.$2.id);
          }
        }

        ref
            .read(gameRepositoryProvider)
            .getPlayableGamesByIds(
              ISet(games.map((e) => e.id)),
            )
            .forEach((playableGames) {
          for (final playableGame in playableGames) {
            final fullId =
                games.firstWhere((e) => e.id == playableGame.id).fullId;

            updateGame(
              fullId,
              playableGame,
            );
          }
        });
      },
    );
  }

  Future<void> playRegisteredMoves() async {
    _log.info('Playing registered correspondence moves...');

    final games = await _storage.fetchGamesWithRegisteredMove().then(
          (games) => games.map((e) => e.$2).toList(),
        );

    WebSocket.userAgent = ref.read(userAgentProvider);
    final Map<String, String> wsHeaders = _session != null
        ? {
            'Authorization': 'Bearer ${signBearerToken(_session!.token)}',
          }
        : {};

    for (final gameToSync in games) {
      if (gameToSync.registeredMoveAtPgn == null) {
        continue;
      }
      final uri = Uri.parse('$kLichessWSHost/play/${gameToSync.fullId}/v6');
      WebSocket? socket;
      StreamSubscription<SocketEvent>? streamSubscription;
      try {
        socket = await WebSocket.connect(uri.toString(), headers: wsHeaders)
            .timeout(const Duration(seconds: 5));

        final eventStream = socket.where((e) => e != '0').map(
              (e) => SocketEvent.fromJson(
                jsonDecode(e as String) as Map<String, dynamic>,
              ),
            );

        final Completer<PlayableGame> gameCompleter = Completer();
        final Completer<void> movePlayedCompleter = Completer();

        streamSubscription = eventStream.listen((event) {
          switch (event.topic) {
            case 'full':
              final playableGame = GameFullEvent.fromJson(
                event.data as Map<String, dynamic>,
              ).game;
              gameCompleter.complete(playableGame);

            case 'move':
              final moveEvent =
                  MoveEvent.fromJson(event.data as Map<String, dynamic>);
              // move acknowledged
              if (moveEvent.uci == gameToSync.registeredMoveAtPgn!.$2.uci) {
                movePlayedCompleter.complete();
                streamSubscription?.cancel();
              }
          }
        });

        final playableGame = await gameCompleter.future;
        if (playableGame.sanMoves == gameToSync.registeredMoveAtPgn!.$1) {
          _log.info(
            'Playing move ${gameToSync.registeredMoveAtPgn!.$2} on game ${gameToSync.id} now...',
          );
          socket.add(
            jsonEncode({
              't': 'move',
              'd': {
                'u': gameToSync.registeredMoveAtPgn!.$2.uci,
              },
            }),
          );

          await movePlayedCompleter.future.timeout(const Duration(seconds: 3));

          ref.read(correspondenceGameStorageProvider).save(
                gameToSync.copyWith(
                  registeredMoveAtPgn: null,
                ),
              );
        } else {
          _log.info(
            'Cannot play game ${gameToSync.id} move because its state has changed',
          );
          updateGame(gameToSync.fullId, playableGame);
        }
      } catch (e, s) {
        _log.severe(
          'Failed to sync correspondence game ${gameToSync.id}',
          e,
          s,
        );
      } finally {
        streamSubscription?.cancel();
        socket?.close();
      }
    }
  }

  Future<void> updateGame(GameFullId fullId, PlayableGame game) async {
    return ref.read(correspondenceGameStorageProvider).save(
          OfflineCorrespondenceGame(
            id: game.id,
            fullId: fullId,
            rated: game.meta.rated,
            steps: game.steps,
            initialFen: game.initialFen,
            status: game.status,
            variant: game.meta.variant,
            speed: game.speed,
            perf: game.meta.perf,
            white: game.white,
            black: game.black,
            youAre: game.youAre!,
            daysPerTurn: game.meta.daysPerTurn,
            winner: game.winner,
            isThreefoldRepetition: game.isThreefoldRepetition,
          ),
        );
  }

  AuthSessionState? get _session => ref.read(authSessionProvider);

  CorrespondenceGameStorage get _storage =>
      ref.read(correspondenceGameStorageProvider);
}
