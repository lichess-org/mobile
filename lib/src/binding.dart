import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lichess_mobile/firebase_options.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/db/secure_storage.dart';
import 'package:lichess_mobile/src/log.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/auth/session_storage.dart';
import 'package:lichess_mobile/src/model/notifications/notification_service.dart';
import 'package:lichess_mobile/src/model/notifications/notifications.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/utils/string.dart';
import 'package:lichess_mobile/src/utils/system.dart';
import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _logger = Logger('LichessBinding');

/// A singleton class that provides access to plugins and external APIs.
///
/// Only one instance of this class will be created during the app's lifetime.
/// See [AppLichessBinding] for the concrete implementation.
///
/// Modeled after the Flutter framework's [WidgetsBinding] class.
///
/// The preferred way to mock or fake a plugin or external API is to create a
/// provider with riverpod because it gives more flexibility and control over
/// the behavior of the fake.
/// However, if the plugin is used in a way that doesn't allow for easy mocking
/// with riverpod, a test binding can be used to provide a fake implementation.
abstract class LichessBinding {
  LichessBinding() : assert(_instance == null) {
    initInstance();
  }

  /// The single instance of [LichessBinding].
  static LichessBinding get instance => checkInstance(_instance);
  static LichessBinding? _instance;

  @protected
  @mustCallSuper
  void initInstance() {
    _instance = this;
  }

  static T checkInstance<T extends LichessBinding>(T? instance) {
    assert(() {
      if (instance == null) {
        throw FlutterError.fromParts([
          ErrorSummary('Lichess binding has not yet been initialized.'),
          ErrorHint(
            'In the app, this is done by the `AppLichessBinding.ensureInitialized()` call '
            'in the `void main()` method.',
          ),
          ErrorHint(
            'In a test, one can call `TestLichessBinding.ensureInitialized()` as the '
            "first line in the test's `main()` method to initialize the binding.",
          ),
        ]);
      }
      return true;
    }());
    return instance!;
  }

  /// The shared preferences instance. Must be preloaded before use.
  ///
  /// This is a synchronous getter that throws an error if shared preferences
  /// have not yet been initialized.
  SharedPreferencesWithCache get sharedPreferences;

  /// Application package information.
  PackageInfo get packageInfo;

  /// Device information.
  BaseDeviceInfo get deviceInfo;

  /// The user session read during app initialization.
  AuthSessionState? get initialUserSession;

  /// Socket Random Identifier.
  String get sri;

  /// Maximum memory in MB that the engine can use.
  ///
  /// This is 10% of the total physical memory.
  int get engineMaxMemoryInMb;

  /// Initialize notifications.
  ///
  /// This wraps [Firebase.initializeApp] and [FlutterLocalNotificationsPlugin.initialize].
  ///
  /// This should be called only once before the app starts.
  Future<void> initializeNotifications(Locale locale);

  /// Wraps [FirebaseMessaging.instance].
  FirebaseMessaging get firebaseMessaging;

  /// Wraps [FirebaseMessaging.onMessage].
  Stream<RemoteMessage> get firebaseMessagingOnMessage;

  /// Wraps [FirebaseMessaging.onMessageOpenedApp].
  Stream<RemoteMessage> get firebaseMessagingOnMessageOpenedApp;

  /// Wraps [FirebaseMessaging.onBackgroundMessage].
  void firebaseMessagingOnBackgroundMessage(BackgroundMessageHandler handler);
}

/// A concrete implementation of [LichessBinding] for the app.
class AppLichessBinding extends LichessBinding {
  AppLichessBinding() {
    setupLogging();
  }

  /// Returns an instance of the binding that implements [LichessBinding].
  ///
  /// If no binding has yet been initialized, the [AppLichessBinding] class is
  /// used to create and initialize one.
  factory AppLichessBinding.ensureInitialized() {
    if (LichessBinding._instance == null) {
      AppLichessBinding();
    }
    return LichessBinding.instance as AppLichessBinding;
  }

  late Future<SharedPreferencesWithCache> _sharedPreferencesWithCache;
  SharedPreferencesWithCache? _syncSharedPreferencesWithCache;

  @override
  SharedPreferencesWithCache get sharedPreferences {
    if (_syncSharedPreferencesWithCache == null) {
      throw FlutterError.fromParts([
        ErrorSummary('Shared preferences have not yet been preloaded.'),
        ErrorHint(
          'In the app, this is done by the `await AppLichessBinding.preloadSharedPreferences()` call '
          'in the `Future<void> main()` method.',
        ),
        ErrorHint(
          'In a test, one can call `TestLichessBinding.setInitialSharedPreferencesValues({})` as the '
          "first line in the test's `main()` method.",
        ),
      ]);
    }
    return _syncSharedPreferencesWithCache!;
  }

  /// Preload shared preferences.
  ///
  /// This should be called only once before the app starts. Must be called before
  /// [sharedPreferences] is accessed.
  Future<void> preloadSharedPreferences() async {
    _sharedPreferencesWithCache = SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );
    _syncSharedPreferencesWithCache = await _sharedPreferencesWithCache;
  }

  late PackageInfo _syncPackageInfo;
  late BaseDeviceInfo _syncDeviceInfo;
  AuthSessionState? _syncInitialUserSession;
  late String _syncSri;
  late int _syncEngineMaxMemoryInMb;

  @override
  PackageInfo get packageInfo => _syncPackageInfo;

  @override
  BaseDeviceInfo get deviceInfo => _syncDeviceInfo;

  @override
  AuthSessionState? get initialUserSession => _syncInitialUserSession;

  @override
  String get sri => _syncSri;

  @override
  int get engineMaxMemoryInMb => _syncEngineMaxMemoryInMb;

  /// Preload useful data.
  ///
  /// This must be called only once before the app starts.
  Future<void> preloadData() async {
    _syncPackageInfo = await PackageInfo.fromPlatform();
    _syncDeviceInfo = await DeviceInfoPlugin().deviceInfo;

    final string = await SecureStorage.instance.read(key: kSessionStorageKey);
    if (string != null) {
      _syncInitialUserSession = AuthSessionState.fromJson(
        jsonDecode(string) as Map<String, dynamic>,
      );
    }

    final storedSri = await SecureStorage.instance.read(key: kSRIStorageKey);

    if (storedSri == null) {
      _logger.warning('SRI not found in secure storage');
    }

    _syncSri = storedSri ?? genRandomString(12);

    final physicalMemory = await System.instance.getTotalRam() ?? 256.0;
    final engineMaxMemory = (physicalMemory / 10).ceil();
    _syncEngineMaxMemoryInMb = engineMaxMemory;
  }

  @override
  Future<void> initializeNotifications(Locale locale) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    if (kReleaseMode) {
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    }

    final l10n = await AppLocalizations.delegate.load(locale);
    await FlutterLocalNotificationsPlugin().initialize(
      InitializationSettings(
        android: const AndroidInitializationSettings('logo_black'),
        iOS: DarwinInitializationSettings(
          requestBadgePermission: false,
          notificationCategories: <DarwinNotificationCategory>[
            ChallengeNotification.darwinPlayableVariantCategory(l10n),
            ChallengeNotification.darwinUnplayableVariantCategory(l10n),
          ],
        ),
      ),
      onDidReceiveNotificationResponse:
          NotificationService.onDidReceiveNotificationResponse,
      // onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  @override
  FirebaseMessaging get firebaseMessaging => FirebaseMessaging.instance;

  @override
  void firebaseMessagingOnBackgroundMessage(BackgroundMessageHandler handler) {
    FirebaseMessaging.onBackgroundMessage(handler);
  }

  @override
  Stream<RemoteMessage> get firebaseMessagingOnMessage =>
      FirebaseMessaging.onMessage;

  @override
  Stream<RemoteMessage> get firebaseMessagingOnMessageOpenedApp =>
      FirebaseMessaging.onMessageOpenedApp;
}
