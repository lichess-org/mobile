/// @docImport 'package:firebase_crashlytics/firebase_crashlytics.dart';
/// @docImport 'package:lichess_mobile/src/binding/binding_fdroid.dart';
/// @docImport 'package:lichess_mobile/src/binding/binding_play.dart';
library;

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:lichess_mobile/src/crashlytics/crashlytics.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A singleton class that provides access to plugins and external APIs.
///
/// Only one instance of this class will be created during the app's lifetime.
/// See concrete implementations [PlayLichessBinding] and [FdroidLichessBinding] for the app.
///
/// Modeled after the Flutter framework's [WidgetsBinding] class.
///
/// The preferred way to mock or fake a plugin or external API is to create a
/// provider with riverpod because it gives more flexibility and control over
/// the behavior of the fake.
/// However, if the plugin is used in a way that doesn't allow for easy mocking
/// with riverpod, a test binding can be used to provide a fake implementation.
abstract class LichessBinding() {
  this : assert(_instance == null) {
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
            'In the app, this is done by the ensureInitialized() call in the '
            '`Future<void> bootstrapApp()` function.',
          ),
          ErrorHint(
            'In a test, one can call `TestLichessBinding.ensureInitialized()` as the '
            "first line in the test's `main()` function to initialize the binding.",
          ),
        ]);
      }
      return true;
    }());
    return instance!;
  }

  /// Counts how many times the app has been (cold) started.
  int get numAppStarts;

  /// The shared preferences instance. Must be preloaded before use.
  ///
  /// This is a synchronous getter that throws an error if shared preferences
  /// have not yet been initialized.
  SharedPreferencesWithCache get sharedPreferences;

  /// Initialize Firebase.
  ///
  /// This wraps [Firebase.initializeApp].
  ///
  /// This should be called only once before the app starts.
  Future<void> initializeFirebase();

  /// Wraps [FirebaseMessaging.instance].
  FirebaseMessaging get firebaseMessaging;

  /// Wraps [FirebaseCrashlytics.instance].
  Crashlytics get firebaseCrashlytics;

  /// Wraps [FirebaseMessaging.onMessage].
  Stream<RemoteMessage> get firebaseMessagingOnMessage;

  /// Wraps [FirebaseMessaging.onMessageOpenedApp].
  Stream<RemoteMessage> get firebaseMessagingOnMessageOpenedApp;

  /// Wraps [FirebaseMessaging.onBackgroundMessage].
  void firebaseMessagingOnBackgroundMessage(BackgroundMessageHandler handler);
}

/// Base class for [LichessBinding] implementations, providing shared logic for the Play Store and
/// F-Droid versions.
abstract class LichessBindingBase() extends LichessBinding {
  late Future<SharedPreferencesWithCache> _sharedPreferencesWithCache;
  SharedPreferencesWithCache? _syncSharedPreferencesWithCache;

  @override
  SharedPreferencesWithCache get sharedPreferences {
    if (_syncSharedPreferencesWithCache == null) {
      throw FlutterError.fromParts([
        ErrorSummary('Shared preferences have not yet been preloaded.'),
        ErrorHint(
          'In the app, this is done by waiting the `preloadSharedPreferences()` call in the '
          '`Future<void> bootstrapApp()` function.',
        ),
        ErrorHint(
          'In a test, one can call `TestLichessBinding.setInitialSharedPreferencesValues({})` as the '
          "first line in the test's `main()` function.",
        ),
      ]);
    }
    return _syncSharedPreferencesWithCache!;
  }

  static const String _kNumAppStartsKey = 'app_starts';

  @override
  int get numAppStarts => sharedPreferences.getInt(_kNumAppStartsKey) ?? 0;

  /// Preload shared preferences.
  ///
  /// This should be called only once before the app starts. Must be called before
  /// [sharedPreferences] is accessed.
  Future<void> preloadSharedPreferences() async {
    _sharedPreferencesWithCache = SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );
    _syncSharedPreferencesWithCache = await _sharedPreferencesWithCache;

    final appStarts = sharedPreferences.getInt(_kNumAppStartsKey) ?? 0;
    sharedPreferences.setInt(_kNumAppStartsKey, appStarts + 1);
  }

  @override
  FirebaseMessaging get firebaseMessaging => FirebaseMessaging.instance;

  @override
  void firebaseMessagingOnBackgroundMessage(BackgroundMessageHandler handler) {
    FirebaseMessaging.onBackgroundMessage(handler);
  }

  @override
  Stream<RemoteMessage> get firebaseMessagingOnMessage => FirebaseMessaging.onMessage;

  @override
  Stream<RemoteMessage> get firebaseMessagingOnMessageOpenedApp =>
      FirebaseMessaging.onMessageOpenedApp;
}
