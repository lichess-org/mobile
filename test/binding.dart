import 'dart:async';
import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/src/flutter_local_notifications_plugin.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/binding.dart';

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

  FakeFirebaseMessaging? _firebaseMessaging;
  FakeFlutterLocalNotificationsPlugin? _notificationsPlugin;

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

  @override
  FakeFlutterLocalNotificationsPlugin get notifications =>
      _notificationsPlugin ??= FakeFlutterLocalNotificationsPlugin();
}

class FakeFirebaseMessaging extends Fake implements FirebaseMessaging {
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

class FakeFlutterLocalNotificationsPlugin extends Fake
    implements FlutterLocalNotificationsPlugin {}
