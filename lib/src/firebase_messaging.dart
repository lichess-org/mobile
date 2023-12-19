import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_client.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/correspondence/correspondence_game_storage.dart';
import 'package:lichess_mobile/src/model/correspondence/correspondence_service.dart';
import 'package:lichess_mobile/src/model/correspondence/offline_correspondence_game.dart';
import 'package:lichess_mobile/src/model/game/playable_game.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'firebase_messaging.g.dart';

@Riverpod(keepAlive: true)
FirebaseMessagingService firebaseMessagingService(
  FirebaseMessagingServiceRef ref,
) {
  return FirebaseMessagingService(
    Logger('FirebaseMessagingService'),
    ref: ref,
  );
}

class FirebaseMessagingService {
  FirebaseMessagingService(this._log, {required this.ref});

  final FirebaseMessagingServiceRef ref;
  final Logger _log;

  Future<void> registerDevice() async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await registerToken(token);
    }
  }

  Future<void> registerToken(String token) async {
    final settings = await FirebaseMessaging.instance.getNotificationSettings();
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      return;
    }
    _log.info('will register fcmToken: $token');
    final authClient = ref.read(authClientProvider);
    final session = ref.read(authSessionProvider);
    if (session == null) {
      return;
    }
    final result = await authClient
        .post(Uri.parse('$kLichessHost/mobile/register/firebase/$token'));
    if (result.isError) {
      _log.severe(
        'could not register device; ${result.asError!.error}',
      );
    }
  }

  Future<void> unregister() async {
    _log.info('will unregister');
    final authClient = ref.read(authClientProvider);
    final session = ref.read(authSessionProvider);
    if (session == null) {
      return;
    }
    final result =
        await authClient.post(Uri.parse('$kLichessHost/mobile/unregister'));
    if (result.isError) {
      _log.severe('could not unregister');
    }
  }

  /// Process a message received while the app is in the foreground.
  Future<void> processDataMessage(RemoteMessage message) async {
    _log.fine('processing message received in foreground: $message');
    final gameFullId = message.data['lichess.fullId'] as String?;
    final round = message.data['lichess.round'] as String?;
    // update correspondence game
    if (gameFullId != null && round != null) {
      final fullId = GameFullId(gameFullId);
      final game = PlayableGame.fromServerJson(
        jsonDecode(round) as Map<String, dynamic>,
      );
      // opponent just played, invalidate ongoing games
      if (game.sideToMove == game.youAre) {
        ref.invalidate(ongoingGamesProvider);
      }
      ref.read(correspondenceServiceProvider).updateGame(fullId, game);
    }
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling a background message: ${message.data}');

  final gameFullId = message.data['lichess.fullId'] as String?;
  final round = message.data['lichess.round'] as String?;

  // update correspondence game
  if (gameFullId != null && round != null) {
    final dbPath = path.join(await getDatabasesPath(), 'lichess_mobile.db');
    final db = await openDb(databaseFactory, dbPath);
    final fullId = GameFullId(gameFullId);
    final game = PlayableGame.fromServerJson(
      jsonDecode(round) as Map<String, dynamic>,
    );
    final corresGame = OfflineCorrespondenceGame(
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
      clock: game.correspondenceClock,
      winner: game.winner,
      isThreefoldRepetition: game.isThreefoldRepetition,
    );

    await db.insert(
      kCorrespondenceStorageTable,
      {
        'userId':
            corresGame.me.user?.id.toString() ?? kCorrespondenceStorageAnonId,
        'gameId': corresGame.id.toString(),
        'lastModified': DateTime.now().toIso8601String(),
        'data': jsonEncode(corresGame.toJson()),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
