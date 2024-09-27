import 'dart:async';
import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/binding.dart';

/// The binding instance used in tests.
TestLichessBinding get testBinding => TestLichessBinding.instance;

/// Binding instance for testing.
class TestLichessBinding extends LichessBinding {
  TestLichessBinding();

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
  static TestLichessBinding get instance =>
      LichessBinding.checkInstance(_instance);
  static TestLichessBinding? _instance;

  @override
  void initInstance() {
    super.initInstance();
    _instance = this;
  }

  /// Reset the binding instance.
  ///
  /// Should be called using [addTearDown] in tests.
  void reset() {
    _firebaseMessaging = null;
  }

  FakeFirebaseMessaging? _firebaseMessaging;

  @override
  Future<void> initializeNotifications(Locale locale) async {}

  @override
  FakeFirebaseMessaging get firebaseMessaging {
    return _firebaseMessaging ??= FakeFirebaseMessaging();
  }

  @override
  void firebaseMessagingOnBackgroundMessage(BackgroundMessageHandler handler) {
    firebaseMessaging.onBackgroundMessage.stream.listen(handler);
  }

  @override
  Stream<RemoteMessage> get firebaseMessagingOnMessage =>
      firebaseMessaging.onMessage.stream;

  @override
  Stream<RemoteMessage> get firebaseMessagingOnMessageOpenedApp =>
      firebaseMessaging.onMessageOpenedApp.stream;
}

typedef FirebaseMessagingRequestPermissionCall = ({
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
  }) async {
    _requestPermissionCalls.add(
      (
        alert: alert,
        announcement: announcement,
        badge: badge,
        carPlay: carPlay,
        criticalAlert: criticalAlert,
        provisional: provisional,
        sound: sound,
      ),
    );
    return _notificationSettings = NotificationSettings(
      alert: alert
          ? AppleNotificationSetting.enabled
          : AppleNotificationSetting.disabled,
      announcement: announcement
          ? AppleNotificationSetting.enabled
          : AppleNotificationSetting.disabled,
      authorizationStatus: _willGrantPermission
          ? AuthorizationStatus.authorized
          : AuthorizationStatus.denied,
      badge: badge
          ? AppleNotificationSetting.enabled
          : AppleNotificationSetting.disabled,
      carPlay: carPlay
          ? AppleNotificationSetting.enabled
          : AppleNotificationSetting.disabled,
      lockScreen: AppleNotificationSetting.enabled,
      notificationCenter: AppleNotificationSetting.enabled,
      showPreviews: AppleShowPreviewSetting.whenAuthenticated,
      timeSensitive: AppleNotificationSetting.disabled,
      criticalAlert: criticalAlert
          ? AppleNotificationSetting.enabled
          : AppleNotificationSetting.disabled,
      sound: sound
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

  final StreamController<String> _tokenController =
      StreamController<String>.broadcast();

  @override
  Future<String?> getToken({String? vapidKey}) async {
    assert(vapidKey == null);
    return _token;
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
  StreamController<RemoteMessage> onMessageOpenedApp =
      StreamController.broadcast();

  /// Controller for [onBackgroundMessage].
  ///
  /// Call [StreamController.add] to simulate a message received from FCM while
  /// the application is in background.
  StreamController<RemoteMessage> onBackgroundMessage =
      StreamController.broadcast();
}
