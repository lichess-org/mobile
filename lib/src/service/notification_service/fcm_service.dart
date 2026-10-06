import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/binding/binding.dart';
import 'package:lichess_mobile/src/binding/binding_fcm.dart';
import 'package:lichess_mobile/src/binding/binding_play.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/notifications/notifications.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/service/notification_service/notification_service.dart';

/// Notification service implementation using Firebase Cloud Messaging
class FcmService(super.ref) extends NotificationService {
  /// The active binding's FCM capabilities.
  FcmBinding get _fcmBinding => LichessBinding.instance as FcmBinding;

  /// The Firebase Cloud Messaging token refresh subscription.
  StreamSubscription<String>? _fcmTokenRefreshSubscription;

  /// The connectivity changes stream subscription.
  ProviderSubscription<AsyncValue<ConnectivityStatus>>? _connectivitySubscription;

  /// Whether the device has been registered for push notifications.
  bool _registeredDevice = false;

  @override
  Future<bool> register() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final apnsToken = await _fcmBinding.firebaseMessaging.getAPNSToken();
      if (apnsToken == null) {
        notificationLogger.warning('APNS token is null');
        return false;
      }
    }
    // The server sends notifications to FCM registration tokens (see `onTokenRefresh` above).
    // TODO: remove this when server-side support for Firebase installation IDs is added
    // ignore: deprecated_member_use
    final token = await _fcmBinding.firebaseMessaging.getToken();
    if (token == null) {
      notificationLogger.warning('FCM token is null');
      return false;
    }
    return await _registerToken(token);
  }

  @override
  Future<void> unregister() async {
    notificationLogger.info('will unregister');
    final authUser = ref.read(authControllerProvider);
    if (authUser == null) {
      return;
    }
    try {
      await ref.withClient((client) => client.post(Uri(path: '/mobile/unregister')));
    } catch (e, st) {
      notificationLogger.severe('could not unregister device:', e, st);
    }
  }

  @override
  Future<void> start() async {
    // Firebase auto-init is disabled at build time (`FirebaseMessagingAutoInitEnabled` in
    // Info.plist, `firebase_messaging_auto_init_enabled` in AndroidManifest.xml) so that nothing
    // is registered with Firebase before the app actually starts its notification service.
    // Since firebase_messaging 16.5.0, the iOS plugin skips `registerForRemoteNotifications` and
    // ignores the APNS device token entirely while auto-init is disabled, so we have to enable it
    // explicitly here, otherwise `getAPNSToken()` always returns null and the device can never be
    // registered for push notifications.
    await _fcmBinding.firebaseMessaging.setAutoInitEnabled(true);

    await startAuthEventListener();

    // Listen for incoming messages while the app is in the foreground.
    _fcmBinding.firebaseMessagingOnMessage.listen((RemoteMessage message) {
      processPushMessage(message.toPushMessage(), fromBackground: false);
    });

    // Listen for incoming messages while the app is in the background.
    _fcmBinding.firebaseMessagingOnBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Request permission to receive notifications. Pop-up will appear only
    // once.
    await _fcmBinding.firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );

    // Listen for token refresh and update the token on the server accordingly.
    //
    // The server sends notifications to FCM registration tokens, not to the Firebase installation
    // IDs that `register()` and `onRegistered` replace them with.
    // TODO: remove this when server-side support for Firebase installation IDs is added
    // ignore: deprecated_member_use
    _fcmTokenRefreshSubscription = _fcmBinding.firebaseMessaging.onTokenRefresh.listen((
      String token,
    ) {
      _registerToken(token);
    });

    // listen for connectivity changes to register device once the app is online
    // This needs to be done *after* via have gotten permission, otherwise on iOS
    // getAPNSToken() might still return null.
    _connectivitySubscription = ref.listen(connectivityChangesProvider, (prev, current) async {
      if (current.value?.isOnline == true && !_registeredDevice) {
        try {
          final success = await register();
          if (success) _registeredDevice = true;
        } catch (e, st) {
          notificationLogger.severe('Could not setup push notifications:', e, st);
        }
      }
    });

    // Get any messages which caused the application to open from
    // a terminated state.
    final RemoteMessage? initialMessage = await _fcmBinding.firebaseMessaging.getInitialMessage();

    if (initialMessage != null) {
      _handleFcmMessageOpenedApp(initialMessage);
    }

    // Handle any other interaction that caused the app to open when in background.
    _fcmBinding.firebaseMessagingOnMessageOpenedApp.listen(_handleFcmMessageOpenedApp);
  }

  @override
  void dispose() {
    _fcmTokenRefreshSubscription?.cancel();
    _connectivitySubscription?.close();
    super.dispose();
  }

  /// Handle an FCM message that caused the application to open
  void _handleFcmMessageOpenedApp(RemoteMessage message) {
    final parsedMessage = ParsedPushMessage.fromPushMessage(message.toPushMessage());
    final notification = parsedMessage.toLocalNotification();
    if (notification != null) {
      _emitOpenedResponse(notification);
    } else {
      logUnsupportedMessage(parsedMessage);
    }
  }

  /// Emits the response of a local notification the user has just opened.
  void _emitOpenedResponse(LocalNotification notification) {
    NotificationService.responseStreamController.add((
      NotificationResponse(
        notificationResponseType: NotificationResponseType.selectedNotification,
        id: notification.id,
        payload: jsonEncode(notification.payload),
      ),
      notification,
    ));
  }

  /// FCM Messages received in background are displayed by the system.
  @override
  bool shouldShow(ParsedPushMessage message, {required bool fromBackground}) {
    if (fromBackground) return false;
    if (message is CorresChallengeCreatePushMessage) return false;
    return message.hasDisplayableNotification;
  }

  Future<bool> _registerToken(String token) async {
    final settings = await _fcmBinding.firebaseMessaging.getNotificationSettings();
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      return false;
    }
    notificationLogger.info('will register fcmToken: $token');
    final authUser = ref.read(authControllerProvider);
    if (authUser == null) {
      return false;
    }
    try {
      await ref.withClient((client) => client.post(Uri(path: '/mobile/register/firebase/$token')));
      return true;
    } catch (e, st) {
      notificationLogger.severe('could not register device:', e, st);
      return false;
    }
  }

  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // create a new provider scope for the background isolate
    final ref = ProviderContainer(
      overrides: [notificationServiceFactoryProvider.overrideWithValue(FcmService.new)],
    );

    final lichessBinding = PlayLichessBinding.ensureInitialized();
    await lichessBinding.preloadSharedPreferences();
    await ref.read(preloadedDataProvider.future);

    try {
      await ref
          .read(notificationServiceProvider)
          .processPushMessage(message.toPushMessage(), fromBackground: true);
      ref.dispose();
    } catch (e, st) {
      notificationLogger.severe('Error when processing an FCM background message:', e, st);
      ref.dispose();
    }
  }
}

extension on RemoteMessage {
  PushMessage toPushMessage() {
    return PushMessage(data: data, notification: notification?.toPushNotification());
  }
}

extension on RemoteNotification {
  PushNotification toPushNotification() {
    return PushNotification(title: title, body: body);
  }
}
