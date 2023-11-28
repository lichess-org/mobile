import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_client.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/auth/bearer.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/correspondence/correspondence_game_storage.dart';
import 'package:lichess_mobile/src/model/correspondence/offline_correspondence_game.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_socket_events.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_move_service.g.dart';

@Riverpod(keepAlive: true)
CorrespondenceSyncMoveService syncMoveService(SyncMoveServiceRef ref) {
  return CorrespondenceSyncMoveService(
    Logger('CorrespondenceSyncMoveService'),
    ref: ref,
  );
}

class CorrespondenceSyncMoveService {
  CorrespondenceSyncMoveService(this._log, {required this.ref});

  final SyncMoveServiceRef ref;
  final Logger _log;

  Future<void> run() async {
    _log.info('Syncing correspondence moves with server...');

    final games = await _storage.fetchOngoingGames().then(
          (games) => games
              .where((game) => game.$2.registeredMoveAtPgn != null)
              .map((e) => e.$2)
              .toList(),
        );

    WebSocket.userAgent = ref.read(userAgentProvider);
    final Map<String, String> wsHeaders = _session != null
        ? {
            'Authorization': 'Bearer ${signBearerToken(_session!.token)}',
          }
        : {};

    for (final gameToSync in games) {
      final uri = Uri.parse('$kLichessWSHost/play/${gameToSync.fullId}/v6');
      WebSocket? socket;
      try {
        socket = await WebSocket.connect(uri.toString(), headers: wsHeaders)
            .timeout(const Duration(seconds: 5));

        final fullEvent = await socket
            .where((e) => e != '0')
            .map(
              (e) => SocketEvent.fromJson(
                jsonDecode(e as String) as Map<String, dynamic>,
              ),
            )
            .firstWhere((event) => event.topic == 'full');
        final playableGame =
            GameFullEvent.fromJson(fullEvent.data as Map<String, dynamic>).game;
        if (playableGame.sanMoves == gameToSync.registeredMoveAtPgn!.$1) {
          _log.info('Syncing game ${gameToSync.id} now...');
          socket.add(
            jsonEncode({
              't': 'move',
              'd': {
                'u': gameToSync.registeredMoveAtPgn!.$2,
              },
            }),
          );
          ref.read(correspondenceGameStorageProvider).save(
                gameToSync.copyWith(
                  registeredMoveAtPgn: null,
                ),
              );
        } else {
          _log.info(
            'Game ${gameToSync.id} cannot be sync because its state has changed',
          );
          _saveCorrespondencePlayableGame(gameToSync.fullId, playableGame);
        }
      } catch (e, s) {
        _log.severe(
          'Failed to sync correspondence game ${gameToSync.id}',
          e,
          s,
        );
      } finally {
        socket?.close();
      }
    }
  }

  void _saveCorrespondencePlayableGame(GameFullId fullId, PlayableGame game) {
    ref.read(correspondenceGameStorageProvider).save(
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
