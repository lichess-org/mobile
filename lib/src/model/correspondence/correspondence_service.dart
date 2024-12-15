import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/auth/bearer.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/correspondence/correspondence_game_storage.dart';
import 'package:lichess_mobile/src/model/correspondence/offline_correspondence_game.dart';
import 'package:lichess_mobile/src/model/game/game_repository.dart';
import 'package:lichess_mobile/src/model/game/game_socket_events.dart';
import 'package:lichess_mobile/src/model/game/playable_game.dart';
import 'package:lichess_mobile/src/navigation.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'correspondence_service.g.dart';

@Riverpod(keepAlive: true)
CorrespondenceService correspondenceService(Ref ref) {
  return CorrespondenceService(Logger('CorrespondenceService'), ref: ref);
}

/// Services that manages correspondence games.
class CorrespondenceService {
  CorrespondenceService(this._log, {required this.ref});

  final Ref ref;
  final Logger _log;

  /// Handles a notification response that caused the app to open.
  Future<void> onNotificationResponse(GameFullId fullId) async {
    final context = ref.read(currentNavigatorKeyProvider).currentContext;
    if (context == null || !context.mounted) return;

    final rootNavState = Navigator.of(context, rootNavigator: true);
    if (rootNavState.canPop()) {
      rootNavState.popUntil((route) => route.isFirst);
    }

    pushPlatformRoute(
      context,
      rootNavigator: true,
      builder: (_) => GameScreen(initialGameId: fullId),
    );
  }

  /// Syncs offline correspondence games with the server.
  Future<void> syncGames() async {
    if (_session == null) {
      return;
    }

    _log.info('Syncing correspondence games...');

    await playRegisteredMoves();

    final storedOngoingGames = await (await _storage).fetchOngoingGames(_session?.user.id);

    ref.withClient((client) async {
      try {
        final accountRepository = AccountRepository(client);
        final gameRepository = GameRepository(client);
        // user can have more than 50 ongoing games, but we only sync the 50 most
        // recent ones
        final ongoingGames = await accountRepository.getOngoingGames(nb: 50);
        for (final sg in storedOngoingGames) {
          final game = ongoingGames.firstWhereOrNull((e) => e.id == sg.$2.id);
          if (game == null) {
            _log.info(
              'Deleting correspondence game ${sg.$2.id} because it is not present on the server anymore',
            );
            (await _storage).delete(sg.$2.id);
          }
        }

        final playableGames = await gameRepository.getMyGamesByIds(
          ISet(ongoingGames.map((e) => e.id)),
        );

        await Future.wait([
          for (final playableGame in playableGames)
            updateGame(
              ongoingGames.firstWhere((e) => e.id == playableGame.id).fullId,
              playableGame,
            ),
        ]);
      } catch (e, s) {
        _log.warning('Failed to sync correspondence games', e, s);
      }
    });
  }

  /// Plays correspondence moves that were registered while the user was offline.
  ///
  /// Returns a [Future] that completes with the number of moves played.
  Future<int> playRegisteredMoves() async {
    _log.info('Playing registered correspondence moves...');

    final games = await (await _storage)
        .fetchGamesWithRegisteredMove(_session?.user.id)
        .then((games) => games.map((e) => e.$2).toList());

    WebSocket.userAgent = ref.read(userAgentProvider);
    final Map<String, String> wsHeaders =
        _session != null ? {'Authorization': 'Bearer ${signBearerToken(_session!.token)}'} : {};

    int movesPlayed = 0;

    for (final gameToSync in games) {
      if (gameToSync.registeredMoveAtPgn == null) {
        continue;
      }
      final uri = lichessWSUri('/play/${gameToSync.fullId}/v6');
      WebSocket? socket;
      StreamSubscription<SocketEvent>? streamSubscription;
      try {
        socket = await WebSocket.connect(
          uri.toString(),
          headers: wsHeaders,
        ).timeout(const Duration(seconds: 5));

        final eventStream = socket
            .where((e) => e != '0')
            .map((e) => SocketEvent.fromJson(jsonDecode(e as String) as Map<String, dynamic>));

        final Completer<PlayableGame> gameCompleter = Completer();
        final Completer<void> movePlayedCompleter = Completer();

        streamSubscription = eventStream.listen((event) {
          switch (event.topic) {
            case 'full':
              final playableGame = GameFullEvent.fromJson(event.data as Map<String, dynamic>).game;
              gameCompleter.complete(playableGame);

            case 'move':
              final moveEvent = MoveEvent.fromJson(event.data as Map<String, dynamic>);
              // move acknowledged
              if (moveEvent.uci == gameToSync.registeredMoveAtPgn!.$2.uci) {
                movesPlayed++;
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
              'd': {'u': gameToSync.registeredMoveAtPgn!.$2.uci},
            }),
          );

          await movePlayedCompleter.future.timeout(const Duration(seconds: 3));

          (await ref.read(
            correspondenceGameStorageProvider.future,
          )).save(gameToSync.copyWith(registeredMoveAtPgn: null));
        } else {
          _log.info('Cannot play game ${gameToSync.id} move because its state has changed');
          updateGame(gameToSync.fullId, playableGame);
        }
      } catch (e, s) {
        _log.severe('Failed to sync correspondence game ${gameToSync.id}', e, s);
      } finally {
        streamSubscription?.cancel();
        socket?.close();
      }
    }

    return movesPlayed;
  }

  /// Handles a game update event from the server.
  Future<void> onServerUpdateEvent(
    GameFullId fullId,
    PlayableGame game, {
    required bool fromBackground,
  }) async {
    if (!fromBackground) {
      // opponent just played, invalidate ongoing games
      if (game.sideToMove == game.youAre) {
        ref.invalidate(ongoingGamesProvider);
      }
    }

    await updateGame(fullId, game);
  }

  /// Updates a stored correspondence game.
  Future<void> updateGame(GameFullId fullId, PlayableGame game) async {
    return (await ref.read(correspondenceGameStorageProvider.future)).save(
      OfflineCorrespondenceGame(
        id: game.id,
        fullId: fullId,
        meta: game.meta,
        rated: game.meta.rated,
        steps: game.steps,
        initialFen: game.initialFen,
        status: game.status,
        variant: game.meta.variant,
        speed: game.meta.speed,
        perf: game.meta.perf,
        white: game.white,
        black: game.black,
        youAre: game.youAre!,
        daysPerTurn: game.meta.daysPerTurn,
        clock: game.correspondenceClock,
        winner: game.winner,
        isThreefoldRepetition: game.isThreefoldRepetition,
      ),
    );
  }

  AuthSessionState? get _session => ref.read(authSessionProvider);

  Future<CorrespondenceGameStorage> get _storage =>
      ref.read(correspondenceGameStorageProvider.future);
}
