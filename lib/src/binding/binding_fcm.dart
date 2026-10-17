import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lichess_mobile/src/binding/binding.dart';

/// Provides access to Firebase Cloud Messaging.
///
/// Only the Play Store binding mixes this in.
mixin FcmBinding on LichessBinding {
  /// Wraps [FirebaseMessaging.instance].
  FirebaseMessaging get firebaseMessaging => FirebaseMessaging.instance;

  /// Wraps [FirebaseMessaging.onMessage].
  Stream<RemoteMessage> get firebaseMessagingOnMessage => FirebaseMessaging.onMessage;

  /// Wraps [FirebaseMessaging.onMessageOpenedApp].
  Stream<RemoteMessage> get firebaseMessagingOnMessageOpenedApp =>
      FirebaseMessaging.onMessageOpenedApp;

  /// Wraps [FirebaseMessaging.onBackgroundMessage].
  void firebaseMessagingOnBackgroundMessage(BackgroundMessageHandler handler) {
    FirebaseMessaging.onBackgroundMessage(handler);
  }
}
