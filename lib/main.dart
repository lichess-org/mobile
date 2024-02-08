import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/intl.dart';
import 'package:lichess_mobile/src/log.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/correspondence/correspondence_game_storage.dart';
import 'package:lichess_mobile/src/model/correspondence/offline_correspondence_game.dart';
import 'package:lichess_mobile/src/model/game/playable_game.dart';
import 'package:lichess_mobile/src/utils/badge_service.dart';
import 'package:lichess_mobile/src/utils/layout.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

import 'firebase_options.dart';
import 'src/app.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // logging setup
  setupLogger();

  // Intl and timeago setup
  await setupIntl();

  // Firebase setup
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Crashlytics
  if (kReleaseMode) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  // Show splash screen until app is ready
  // See src/app.dart for splash screen removal
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // lock orientation to portrait on android phones
  if (defaultTargetPlatform == TargetPlatform.android) {
    final view = widgetsBinding.platformDispatcher.views.first;
    final data = MediaQueryData.fromView(view);
    if (data.size.shortestSide < FormFactor.tablet) {
      await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp],
      );
    }
  }

  runApp(
    ProviderScope(
      observers: [
        ProviderLogger(),
      ],
      child: const LoadingAppScreen(),
    ),
  );
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling a background message: ${message.data}');

  final gameFullId = message.data['lichess.fullId'] as String?;
  final round = message.data['lichess.round'] as String?;

  // update correspondence game
  if (gameFullId != null && round != null) {
    final dbPath = path.join(await getDatabasesPath(), kLichessDatabaseName);
    final db = await openDb(databaseFactory, dbPath);
    final fullId = GameFullId(gameFullId);
    final game = PlayableGame.fromServerJson(
      jsonDecode(round) as Map<String, dynamic>,
    );
    final corresGame = OfflineCorrespondenceGame(
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

  // update badge
  final badge = message.data['lichess.iosBadge'] as String?;
  if (badge != null) {
    try {
      BadgeService.instance.setBadge(int.parse(badge));
    } catch (e) {
      debugPrint('Could not parse badge: $badge');
    }
  }
}
