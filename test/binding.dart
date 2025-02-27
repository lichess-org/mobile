import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/binding.dart';
import 'package:lichess_mobile/src/model/engine/engine.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/engine/fake_stockfish.dart';

/// The binding instance used in tests.
TestLichessBinding get testBinding => TestLichessBinding.instance;

/// Lichess binding for testing.
class TestLichessBinding extends LichessBinding {
  TestLichessBinding() {
    Logger.root.level = Level.FINE;
    Logger.root.onRecord.listen((record) {
      if (record.level >= Level.WARNING) {
        // ignore: avoid_print
        print(
          '${DateFormat('H:m:s.S').format(record.time)} [${record.level}] ${record.loggerName}: ${record.message}',
        );
      }
    });
  }

  /// Initialize the binding if necessary, and ensure it is a [TestLichessBinding].
  ///
  /// If there is an existing binding but it is not a [TestLichessBinding],
  /// this method throws an error.
  factory TestLichessBinding.ensureInitialized() {
    if (_instance == null) {
      TestLichessBinding();
    }
    return instance;
  }

  /// The single instance of the binding.
  static TestLichessBinding get instance => LichessBinding.checkInstance(_instance);
  static TestLichessBinding? _instance;

  @override
  void initInstance() {
    super.initInstance();
    _instance = this;
  }

  /// Set the initial values for shared preferences.
  Future<void> setInitialSharedPreferencesValues(Map<String, Object> values) async {
    for (final entry in values.entries) {
      if (entry.value is String) {
        await sharedPreferences.setString(entry.key, entry.value as String);
      } else if (entry.value is bool) {
        await sharedPreferences.setBool(entry.key, entry.value as bool);
      } else if (entry.value is double) {
        await sharedPreferences.setDouble(entry.key, entry.value as double);
      } else if (entry.value is int) {
        await sharedPreferences.setInt(entry.key, entry.value as int);
      } else if (entry.value is List<String>) {
        await sharedPreferences.setStringList(entry.key, entry.value as List<String>);
      } else {
        throw ArgumentError.value(
          entry.value,
          'values',
          'Unsupported value type: ${entry.value.runtimeType}',
        );
      }
    }
  }

  FakeSharedPreferences? _sharedPreferences;

  @override
  FakeSharedPreferences get sharedPreferences {
    return _sharedPreferences ??= FakeSharedPreferences();
  }

  /// Reset the binding instance.
  ///
  /// Should be called using [addTearDown] in tests.
  void reset() {
    _firebaseMessaging = null;
    _sharedPreferences = null;
  }

  FakeFirebaseMessaging? _firebaseMessaging;

  @override
  Future<void> initializeFirebase() async {}

  @override
  FakeFirebaseMessaging get firebaseMessaging {
    return _firebaseMessaging ??= FakeFirebaseMessaging();
  }

  @override
  void firebaseMessagingOnBackgroundMessage(BackgroundMessageHandler handler) {
    firebaseMessaging.onBackgroundMessage.stream.listen(handler);
  }

  @override
  Stream<RemoteMessage> get firebaseMessagingOnMessage => firebaseMessaging.onMessage.stream;

  @override
  Stream<RemoteMessage> get firebaseMessagingOnMessageOpenedApp =>
      firebaseMessaging.onMessageOpenedApp.stream;

  @override
  StockfishFactory get stockfishFactory => const FakeStockfishFactory();
}

class FakeSharedPreferences implements SharedPreferencesWithCache {
  final Map<String, dynamic> _values = {};

  @override
  Future<bool> remove(String key) async {
    _values.remove(key);
    return true;
  }

  @override
  Future<void> clear({Set<String>? allowList}) async {
    _values.clear();
  }

  @override
  bool containsKey(String key) {
    return _values.containsKey(key);
  }

  @override
  String? getString(String key) {
    return _values[key] as String?;
  }

  @override
  bool? getBool(String key) {
    return _values[key] as bool?;
  }

  @override
  double? getDouble(String key) {
    return _values[key] as double?;
  }

  @override
  int? getInt(String key) {
    return _values[key] as int?;
  }

  @override
  List<String>? getStringList(String key) {
    return _values[key] as List<String>?;
  }

  @override
  Future<bool> setString(String key, String value) async {
    _values[key] = value;
    return true;
  }

  @override
  Future<void> setBool(String key, bool value) {
    _values[key] = value;
    return Future.value();
  }

  @override
  Future<void> setDouble(String key, double value) {
    _values[key] = value;
    return Future.value();
  }

  @override
  Future<void> setInt(String key, int value) {
    _values[key] = value;
    return Future.value();
  }

  @override
  Future<void> setStringList(String key, List<String> value) {
    _values[key] = value;
    return Future.value();
  }

  @override
  Object? get(String key) {
    return _values[key];
  }

  @override
  Set<String> get keys => _values.keys.toSet();

  @override
  Future<void> reloadCache() {
    return Future.value();
  }
}

typedef FirebaseMessagingRequestPermissionCall =
    ({
      bool alert,
      bool announcement,
      bool badge,
      bool carPlay,
      bool criticalAlert,
      bool provisional,
      bool sound,
    });

class FakeFirebaseMessaging extends Fake implements FirebaseMessaging {
  /// Whether [requestPermission] will grant permission.
  bool _willGrantPermission = true;

  /// Set whether [requestPermission] will grant permission.
  // ignore: avoid_setters_without_getters
  set willGrantPermission(bool value) {
    _willGrantPermission = value;
  }

  List<FirebaseMessagingRequestPermissionCall> verifyRequestPermissionCalls() {
    final result = _requestPermissionCalls;
    _requestPermissionCalls = [];
    return result;
  }

  List<FirebaseMessagingRequestPermissionCall> _requestPermissionCalls = [];

  NotificationSettings _notificationSettings = const NotificationSettings(
    alert: AppleNotificationSetting.disabled,
    announcement: AppleNotificationSetting.disabled,
    authorizationStatus: AuthorizationStatus.notDetermined,
    badge: AppleNotificationSetting.disabled,
    carPlay: AppleNotificationSetting.disabled,
    lockScreen: AppleNotificationSetting.disabled,
    notificationCenter: AppleNotificationSetting.disabled,
    showPreviews: AppleShowPreviewSetting.always,
    timeSensitive: AppleNotificationSetting.disabled,
    criticalAlert: AppleNotificationSetting.disabled,
    sound: AppleNotificationSetting.disabled,
    providesAppNotificationSettings: AppleNotificationSetting.disabled,
  );

  @override
  Future<NotificationSettings> requestPermission({
    bool alert = true,
    bool announcement = false,
    bool badge = true,
    bool carPlay = false,
    bool criticalAlert = false,
    bool provisional = false,
    bool sound = true,
    bool providesAppNotificationSettings = false,
  }) async {
    _requestPermissionCalls.add((
      alert: alert,
      announcement: announcement,
      badge: badge,
      carPlay: carPlay,
      criticalAlert: criticalAlert,
      provisional: provisional,
      sound: sound,
    ));
    return _notificationSettings = NotificationSettings(
      alert: alert ? AppleNotificationSetting.enabled : AppleNotificationSetting.disabled,
      announcement:
          announcement ? AppleNotificationSetting.enabled : AppleNotificationSetting.disabled,
      authorizationStatus:
          _willGrantPermission ? AuthorizationStatus.authorized : AuthorizationStatus.denied,
      badge: badge ? AppleNotificationSetting.enabled : AppleNotificationSetting.disabled,
      carPlay: carPlay ? AppleNotificationSetting.enabled : AppleNotificationSetting.disabled,
      lockScreen: AppleNotificationSetting.enabled,
      notificationCenter: AppleNotificationSetting.enabled,
      showPreviews: AppleShowPreviewSetting.whenAuthenticated,
      timeSensitive: AppleNotificationSetting.disabled,
      criticalAlert:
          criticalAlert ? AppleNotificationSetting.enabled : AppleNotificationSetting.disabled,
      sound: sound ? AppleNotificationSetting.enabled : AppleNotificationSetting.disabled,
      providesAppNotificationSettings:
          providesAppNotificationSettings
              ? AppleNotificationSetting.enabled
              : AppleNotificationSetting.disabled,
    );
  }

  @override
  Future<NotificationSettings> getNotificationSettings() {
    return Future.value(_notificationSettings);
  }

  @override
  Future<RemoteMessage?> getInitialMessage() async {
    return null;
  }

  // assume the token is initially available
  String? _token = 'test-token';

  void setToken(String token) {
    _token = token;
    _tokenController.add(token);
  }

  final StreamController<String> _tokenController = StreamController<String>.broadcast();

  @override
  Future<String?> getToken({String? vapidKey}) async {
    assert(vapidKey == null);
    return _token;
  }

  @override
  Future<String?> getAPNSToken() {
    return Future.value('test-apns-token');
  }

  @override
  Stream<String> get onTokenRefresh => _tokenController.stream;

  /// Controller for [onMessage].
  ///
  /// Call [StreamController.add] to simulate a message received from FCM while
  /// the application is in foreground.
  StreamController<RemoteMessage> onMessage = StreamController.broadcast();

  /// Controller for [onMessageOpenedApp].
  ///
  /// Call [StreamController.add] to simulate a user press on a notification message
  /// sent by FCM.
  StreamController<RemoteMessage> onMessageOpenedApp = StreamController.broadcast();

  /// Controller for [onBackgroundMessage].
  ///
  /// Call [StreamController.add] to simulate a message received from FCM while
  /// the application is in background.
  StreamController<RemoteMessage> onBackgroundMessage = StreamController.broadcast();
}
