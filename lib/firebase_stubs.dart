// ignore_for_file: avoid_classes_with_only_static_members

import 'package:flutter/foundation.dart';

class RemoteMessage {
  final Map<String, dynamic> data;
  final RemoteNotification? notification;

  RemoteMessage(this.data, this.notification);

  factory RemoteMessage.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final notification = json['notification'] as Map<String, dynamic>?;
    final remoteNotification = notification != null
        ? RemoteNotification(notification['title'] as String, notification['body'] as String)
        : null;
    return RemoteMessage(data, remoteNotification);
  }
}

class RemoteNotification {
  final String? title;
  final String? body;

  RemoteNotification(this.title, this.body);
}

class Firebase {
  static Firebase instance = Firebase();

  static Future<void> initializeApp({DefaultFirebaseOptions? options}) {
    return Future.value();
  }
}

class FirebaseOptions {
  const FirebaseOptions({
    required this.apiKey,
    required this.appId,
    required this.messagingSenderId,
    required this.projectId,
    this.storageBucket,
    this.iosClientId,
    this.iosBundleId,
  });

  final String apiKey;
  final String appId;
  final String messagingSenderId;
  final String projectId;
  final String? storageBucket;
  final String? iosClientId;
  final String? iosBundleId;
}

class DefaultFirebaseOptions {
  static DefaultFirebaseOptions? get currentPlatform => null;
}

typedef BackgroundMessageHandler = Future<void> Function(RemoteMessage message);

class FirebaseMessaging {
  static FirebaseMessaging instance = FirebaseMessaging();

  static Stream<RemoteMessage> get onMessage => const Stream.empty();

  static Stream<RemoteMessage> get onMessageOpenedApp => const Stream.empty();

  static void onBackgroundMessage(BackgroundMessageHandler handler) {}
}

class FirebaseCrashlytics {
  static FirebaseCrashlytics instance = FirebaseCrashlytics();

  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    Iterable<Object> information = const [],
    bool? printDetails,
    bool fatal = false,
  }) {
    return Future.value();
  }

  void recordFlutterFatalError(FlutterErrorDetails flutterErrorDetails) {
    return FlutterError.presentError(flutterErrorDetails);
  }

  Future<void> setCustomKey(String key, Object value) {
    return Future.value();
  }
}
