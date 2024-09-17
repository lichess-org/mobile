import 'dart:convert';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/app_initialization.dart';
import 'package:lichess_mobile/src/db/database.dart';
import 'package:lichess_mobile/src/intl.dart';
import 'package:lichess_mobile/src/log.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_repository.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/correspondence/correspondence_game_storage.dart';
import 'package:lichess_mobile/src/model/correspondence/offline_correspondence_game.dart';
import 'package:lichess_mobile/src/model/game/playable_game.dart';
import 'package:lichess_mobile/src/model/notifications/challenge_notification.dart';
import 'package:lichess_mobile/src/model/notifications/local_notification.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/utils/badge_service.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'firebase_options.dart';
import 'src/app.dart';
import 'src/utils/color_palette.dart';

final _notificationPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  final systemLocale = widgetsBinding.platformDispatcher.locale;

  // logging setup
  setupLogger();

  SharedPreferences.setPrefix('lichess.');

  // Get locale from shared preferences, if any
  final prefs = await SharedPreferences.getInstance();
  final json = prefs.getString(kGeneralPreferencesKey);
  final generalPref = json != null
      ? GeneralPrefsState.fromJson(jsonDecode(json) as Map<String, dynamic>)
      : GeneralPrefsState.defaults;
  final prefsLocale = generalPref.locale;

  final locale = prefsLocale ?? systemLocale;

  // Intl and timeago setup
  await setupIntl(locale);

  // Local notifications setup
  final l10n = await AppLocalizations.delegate.load(locale);
  await _notificationPlugin.initialize(
    InitializationSettings(
      android: const AndroidInitializationSettings('logo_black'),
      iOS: DarwinInitializationSettings(
        requestBadgePermission: false,
        notificationCategories: <DarwinNotificationCategory>[
          ChallengeNotification.darwinNotificationCategory(l10n),
        ],
      ),
    ),
    onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  // Firebase setup
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Crashlytics
  if (kReleaseMode) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  // preload sounds
  final soundTheme = GeneralPreferences.fetchFromStorage(prefs).soundTheme;
  await preloadSounds(soundTheme);

  // Get android 12+ core palette
  try {
    await DynamicColorPlugin.getCorePalette().then((value) {
      setCorePalette(value);
    });
  } catch (e) {
    debugPrint('Could not get core palette: $e');
  }

  // Show splash screen until app is ready
  // See src/app.dart for splash screen removal
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  if (defaultTargetPlatform == TargetPlatform.android) {
    // lock orientation to portrait on android phones
    final view = widgetsBinding.platformDispatcher.views.first;
    final data = MediaQueryData.fromView(view);
    if (data.size.shortestSide < FormFactor.tablet) {
      await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp],
      );
    }

    // Sets edge-to-edge system UI mode on Android 12+
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarContrastEnforced: true,
      ),
    );
  }

  runApp(
    ProviderScope(
      observers: [
        ProviderLogger(),
      ],
      child: const AppInitializationScreen(),
    ),
  );
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  // create a new provider container for the background isolate
  final ref = ProviderContainer();

  ref.listen(
    appInitializationProvider,
    (prev, now) {
      if (!now.hasValue) return;

      if (response.id == null || response.payload == null) return;

      try {
        final payload = NotificationPayload.fromJson(
          jsonDecode(response.payload!) as Map<String, dynamic>,
        );
        switch (payload.type) {
          case NotificationType.challenge:
            // only decline action is supported in the background
            if (response.actionId == 'decline') {
              final challengeId = ChallengePayload.fromNotification(payload).id;
              ref.read(challengeRepositoryProvider).decline(challengeId);
            }
          default:
            debugPrint('Unknown notification type: $payload');
        }

        ref.dispose();
      } catch (e) {
        debugPrint('Failed to handle notification background response: $e');
        ref.dispose();
      }
    },
  );

  ref.read(appInitializationProvider);
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
