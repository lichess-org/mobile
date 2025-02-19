import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/binding.dart';
import 'package:lichess_mobile/src/localizations.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/notifications/notifications.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/badge_service.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_service.g.dart';

final _logger = Logger('NotificationService');

/// A provider instance of the [FlutterLocalNotificationsPlugin].
@Riverpod(keepAlive: true)
FlutterLocalNotificationsPlugin notificationDisplay(Ref _) => FlutterLocalNotificationsPlugin();

/// A provider instance of the [NotificationService].
@Riverpod(keepAlive: true)
NotificationService notificationService(Ref ref) {
  final service = NotificationService(ref);

  ref.onDispose(() => service._dispose());

  return service;
}

/// Received FCM message and whether it was from the background.
typedef ReceivedFcmMessage = ({FcmMessage message, bool fromBackground});

/// A [NotificationResponse] and the associated [LocalNotification].
typedef ParsedLocalNotification = (NotificationResponse response, LocalNotification notification);

/// A service that manages notifications.
///
/// This service is responsible for handling incoming messages from the Firebase
/// Cloud Messaging service and showing notifications.
///
/// It broadcasts the parsed incoming FCM messages to the [fcmMessageStream].
///
/// It also listens for notification interaction responses and dispatches them to the [responseStream].
class NotificationService {
  NotificationService(this._ref);

  final Ref _ref;

  /// The Firebase Cloud Messaging token refresh subscription.
  StreamSubscription<String>? _fcmTokenRefreshSubscription;

  /// The connectivity changes stream subscription.
  ProviderSubscription<AsyncValue<ConnectivityStatus>>? _connectivitySubscription;

  /// The stream controller for notification responses.
  static final StreamController<ParsedLocalNotification> _responseStreamController =
      StreamController.broadcast();

  /// The stream of notification responses.
  ///
  /// A notification response is dispatched when a notification has been interacted with.
  static Stream<ParsedLocalNotification> get responseStream => _responseStreamController.stream;

  /// The stream controller for FCM messages.
  static final StreamController<ReceivedFcmMessage> _fcmMessageStreamController =
      StreamController.broadcast();

  /// The stream of FCM messages.
  ///
  /// A FCM message is dispatched when a message is received from the Firebase Cloud Messaging service.
  static Stream<ReceivedFcmMessage> get fcmMessageStream => _fcmMessageStreamController.stream;

  /// The stream subscription for notification responses.
  StreamSubscription<NotificationResponse>? _responseStreamSubscription;

  /// Whether the device has been registered for push notifications.
  bool _registeredDevice = false;

  AppLocalizations get _l10n => _ref.read(localizationsProvider).strings;

  FlutterLocalNotificationsPlugin get _notificationDisplay =>
      _ref.read(notificationDisplayProvider);

  /// Starts the notification service.
  ///
  /// This method listens for incoming messages and updates the application state
  /// accordingly.
  /// It also registers the device for push notifications once the app is online.
  ///
  /// This method should be called once the app is ready to receive notifications,
  /// and after [LichessBinding.initializeNotifications] has been called.
  Future<void> start() async {
    // listen for connectivity changes to register device once the app is online
    _connectivitySubscription = _ref.listen(connectivityChangesProvider, (prev, current) async {
      if (current.value?.isOnline == true && !_registeredDevice) {
        try {
          await registerDevice();
          _registeredDevice = true;
        } catch (e, st) {
          _logger.severe('Could not setup push notifications; $e\n$st');
        }
      }
    });

    // Listen for incoming messages while the app is in the foreground.
    LichessBinding.instance.firebaseMessagingOnMessage.listen((RemoteMessage message) {
      _processFcmMessage(message, fromBackground: false);
    });

    // Listen for incoming messages while the app is in the background.
    LichessBinding.instance.firebaseMessagingOnBackgroundMessage(
      _firebaseMessagingBackgroundHandler,
    );

    // Request permission to receive notifications. Pop-up will appear only
    // once.
    await LichessBinding.instance.firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );

    // Listen for token refresh and update the token on the server accordingly.
    _fcmTokenRefreshSubscription = LichessBinding.instance.firebaseMessaging.onTokenRefresh.listen((
      String token,
    ) {
      _registerToken(token);
    });

    // Get any messages which caused the application to open from
    // a terminated state.
    final RemoteMessage? initialMessage =
        await LichessBinding.instance.firebaseMessaging.getInitialMessage();

    if (initialMessage != null) {
      _handleFcmMessageOpenedApp(initialMessage);
    }

    // Handle any other interaction that caused the app to open when in background.
    LichessBinding.instance.firebaseMessagingOnMessageOpenedApp.listen(_handleFcmMessageOpenedApp);
  }

  /// Shows a notification.
  Future<int> show(LocalNotification notification) async {
    final id = notification.id;
    final payload = jsonEncode(notification.payload);

    await _notificationDisplay.show(
      id,
      notification.title(_l10n),
      notification.body(_l10n),
      notification.details(_l10n),
      payload: payload,
    );
    _logger.info(
      'Show local notification: ($id | ${notification.title}) ${notification.body} (Payload: ${notification.payload})',
    );

    return id;
  }

  /// Cancels/removes a notification.
  Future<void> cancel(int id) async {
    _logger.info('canceled notification id: [$id]');
    return _notificationDisplay.cancel(id);
  }

  void _dispose() {
    _fcmTokenRefreshSubscription?.cancel();
    _connectivitySubscription?.close();
    _responseStreamSubscription?.cancel();
  }

  /// Function called by the notification plugin when a notification has been tapped on.
  static void onDidReceiveNotificationResponse(NotificationResponse response) {
    _logger.fine('received local notification ${response.id} response in foreground.');

    final rawPayload = response.payload;

    if (rawPayload == null) {
      _logger.warning('Received a notification response with no payload.');
      return;
    }

    final json = jsonDecode(rawPayload) as Map<String, dynamic>;
    final notification = LocalNotification.fromJson(json);

    _responseStreamController.add((response, notification));
  }

  /// Handle an FCM message that caused the application to open
  void _handleFcmMessageOpenedApp(RemoteMessage message) {
    final parsedMessage = FcmMessage.fromRemoteMessage(message);

    switch (parsedMessage) {
      case final CorresGameUpdateFcmMessage corresMessage:
        final notification = CorresGameUpdateNotification.fromFcmMessage(corresMessage);
        _responseStreamController.add((
          NotificationResponse(
            notificationResponseType: NotificationResponseType.selectedNotification,
            id: notification.id,
            payload: jsonEncode(notification.payload),
          ),
          notification,
        ));

      // TODO: handle other notification types
      case UnhandledFcmMessage(data: final data):
        _logger.warning('Received unhandled FCM notification type: ${data['lichess.type']}');

      case MalformedFcmMessage(data: final data):
        _logger.severe('Received malformed FCM message: $data');
    }
  }

  /// Process a message received from the Firebase Cloud Messaging service.
  ///
  /// If the message contains a [RemoteMessage.notification] field and if it is
  /// received while the app was in foreground, the notification is by default not
  /// shown to the user.
  /// Depending on the message type, we may as well show a local notification.
  ///
  /// Some messages (whether or not they have an associated notification), have
  /// a [RemoteMessage.data] field used to update the application state according
  /// to the message type.
  ///
  /// A special data field, 'lichess.iosBadge', is used to update the iOS app's
  /// badge count according to the value held by the server.
  Future<void> _processFcmMessage(
    RemoteMessage message, {

    /// Whether the message was received while the app was in the background.
    required bool fromBackground,
  }) async {
    _logger.fine(
      'Processing a FCM message from ${fromBackground ? 'background' : 'foreground'}: ${message.data}',
    );

    final parsedMessage = FcmMessage.fromRemoteMessage(message);

    _fcmMessageStreamController.add((message: parsedMessage, fromBackground: fromBackground));

    switch (parsedMessage) {
      case CorresGameUpdateFcmMessage(fullId: final fullId, notification: final notification):
        if (fromBackground == false && notification != null) {
          await show(CorresGameUpdateNotification(fullId, notification.title!, notification.body!));
        }

      // TODO: handle other notification types

      case UnhandledFcmMessage(data: final data):
        _logger.warning('Received unhandled FCM notification type: ${data['lichess.type']}');

      case MalformedFcmMessage(data: final data):
        _logger.severe('Received malformed FCM message: $data');
    }

    // update badge
    final badge = message.data['lichess.iosBadge'] as String?;
    if (badge != null) {
      try {
        await BadgeService.instance.setBadge(int.parse(badge));
      } catch (e) {
        _logger.severe('Could not parse badge: $badge');
      }
    }
  }

  /// Register the device for push notifications.
  Future<void> registerDevice() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      if (apnsToken == null) {
        _logger.warning('APNS token is null');
        return;
      }
    }
    final token = await LichessBinding.instance.firebaseMessaging.getToken();
    if (token != null) {
      await _registerToken(token);
    }
  }

  /// Unregister the device from push notifications.
  Future<void> unregister() async {
    _logger.info('will unregister');
    final session = _ref.read(authSessionProvider);
    if (session == null) {
      return;
    }
    try {
      await _ref.withClient((client) => client.post(Uri(path: '/mobile/unregister')));
    } catch (e, st) {
      _logger.severe('could not unregister device; $e', e, st);
    }
  }

  Future<void> _registerToken(String token) async {
    final settings = await LichessBinding.instance.firebaseMessaging.getNotificationSettings();
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      return;
    }
    _logger.info('will register fcmToken: $token');
    final session = _ref.read(authSessionProvider);
    if (session == null) {
      return;
    }
    try {
      await _ref.withClient((client) => client.post(Uri(path: '/mobile/register/firebase/$token')));
    } catch (e, st) {
      _logger.severe('could not register device; $e', e, st);
    }
  }

  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // create a new provider scope for the background isolate
    final ref = ProviderContainer();

    final lichessBinding = AppLichessBinding.ensureInitialized();
    await lichessBinding.preloadSharedPreferences();
    await ref.read(preloadedDataProvider.future);

    try {
      await ref.read(notificationServiceProvider)._processFcmMessage(message, fromBackground: true);

      ref.dispose();
    } catch (e) {
      _logger.severe('Error when processing an FCM background message: $e');
      ref.dispose();
    }
  }
}
