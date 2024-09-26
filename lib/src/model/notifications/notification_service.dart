import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/firebase_options.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/init.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_service.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/correspondence/correspondence_service.dart';
import 'package:lichess_mobile/src/model/game/playable_game.dart';
import 'package:lichess_mobile/src/model/notifications/notifications.dart';
import 'package:lichess_mobile/src/utils/badge_service.dart';
import 'package:lichess_mobile/src/utils/connectivity.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_service.g.dart';

final _localNotificationPlugin = FlutterLocalNotificationsPlugin();
final _logger = Logger('NotificationService');

/// Notification types defined by the server.
///
/// This corresponds to the 'lichess.type' field in the FCM message's data.
enum ServerNotificationType {
  /// There is not much time left to make a move in a correspondence game.
  corresAlarm,

  /// A takeback offer has been made in a correspondence game.
  gameTakebackOffer,

  /// A draw offer has been made in a correspondence game.
  gameDrawOffer,

  /// A move has been made in a correspondence game.
  gameMove,

  /// A correspondence game just finished.
  gameFinish,

  /// Server notification type not handled by the app.
  unhandled;

  static ServerNotificationType fromString(String type) {
    switch (type) {
      case 'corresAlarm':
        return corresAlarm;
      case 'gameTakebackOffer':
        return gameTakebackOffer;
      case 'gameDrawOffer':
        return gameDrawOffer;
      case 'gameMove':
        return gameMove;
      case 'gameFinish':
        return gameFinish;
      default:
        return unhandled;
    }
  }
}

/// A provider instance of the [NotificationService].
@Riverpod(keepAlive: true)
NotificationService notificationService(NotificationServiceRef ref) {
  final service = NotificationService(ref);

  ref.onDispose(() => service._dispose());

  return service;
}

/// A service that manages notifications.
///
/// This service is responsible for handling incoming messages from the Firebase
/// Cloud Messaging service and showing notifications.
///
/// It also listens for notification interaction responses and dispatches them to the
/// appropriate services.
class NotificationService {
  NotificationService(this._ref);

  final NotificationServiceRef _ref;

  /// The Firebase Cloud Messaging token refresh subscription.
  StreamSubscription<String>? _fcmTokenRefreshSubscription;

  /// The connectivity changes stream subscription.
  ProviderSubscription<AsyncValue<ConnectivityStatus>>?
      _connectivitySubscription;

  /// The stream controller for notification responses.
  static final StreamController<NotificationResponse>
      _responseStreamController = StreamController.broadcast();

  /// The stream subscription for notification responses.
  StreamSubscription<NotificationResponse>? _responseStreamSubscription;

  /// Whether the device has been registered for push notifications.
  bool _registeredDevice = false;

  AppLocalizations get _l10n => _ref.read(l10nProvider).strings;

  /// Initialize the notification service.
  ///
  /// It will initialize the Firebase and the local notification plugins.
  ///
  /// This should be called once when the app starts.
  static Future<void> initialize(Locale locale) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final l10n = await AppLocalizations.delegate.load(locale);
    await _localNotificationPlugin.initialize(
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
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
      // onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  /// Starts the notification service.
  ///
  /// This method listens for incoming messages and updates the application state
  /// accordingly.
  /// It also registers the device for push notifications once the app is online.
  ///
  /// This method should be called once the app is ready to receive notifications and after [initialize].
  Future<void> start() async {
    _connectivitySubscription =
        _ref.listen(connectivityChangesProvider, (prev, current) async {
      // register device once the app is online
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
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _processFcmMessage(message, fromBackground: false);
    });

    // Listen for incoming messages while the app is in the background.
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Request permission to receive notifications. Pop-up will appear only
    // once.
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );

    // Listen for token refresh and update the token on the server accordingly.
    _fcmTokenRefreshSubscription =
        FirebaseMessaging.instance.onTokenRefresh.listen((String token) {
      _registerToken(token);
    });

    // Get any messages which caused the application to open from
    // a terminated state.
    final RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleFcmMessageOpenedApp(initialMessage);
    }

    // Handle any other interaction that caused the app to open when in background.
    FirebaseMessaging.onMessageOpenedApp.listen(_handleFcmMessageOpenedApp);

    // start listening for notification responses
    _responseStreamSubscription =
        _responseStreamController.stream.listen(_dispatchNotificationResponse);
  }

  /// Shows a notification.
  Future<int> show(LocalNotification notification) async {
    final id = notification.id;
    final payload = jsonEncode(notification.payload);

    await _localNotificationPlugin.show(
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
    return _localNotificationPlugin.cancel(id);
  }

  void _dispose() {
    _fcmTokenRefreshSubscription?.cancel();
    _connectivitySubscription?.close();
    _responseStreamSubscription?.cancel();
  }

  /// Dispatch a notification response to the appropriate service according to the notification type.
  void _dispatchNotificationResponse(NotificationResponse response) {
    final rawPayload = response.payload;

    if (rawPayload == null) return;

    final json = jsonDecode(rawPayload) as Map<String, dynamic>;
    final notification = LocalNotification.fromJson(json);

    switch (notification) {
      case CorresGameUpdateNotification(fullId: final gameFullId):
        _ref
            .read(correspondenceServiceProvider)
            .onNotificationResponse(gameFullId);
      case ChallengeNotification(challenge: final challenge):
        _ref.read(challengeServiceProvider).onNotificationResponse(
              response.actionId,
              challenge,
            );
    }
  }

  /// Function called when a notification has been interacted with and the app is in the foreground.
  static void _onDidReceiveNotificationResponse(NotificationResponse response) {
    _logger.fine(
      'received local notification ${response.id} response in foreground.',
    );

    _responseStreamController.add(response);
  }

  /// Handle an FCM message that caused the application to open
  void _handleFcmMessageOpenedApp(RemoteMessage message) {
    final messageType = message.data['lichess.type'] as String?;
    if (messageType == null) return;

    switch (ServerNotificationType.fromString(messageType)) {
      case ServerNotificationType.corresAlarm:
      case ServerNotificationType.gameTakebackOffer:
      case ServerNotificationType.gameDrawOffer:
      case ServerNotificationType.gameMove:
      case ServerNotificationType.gameFinish:
        final gameFullId = message.data['lichess.fullId'] as String?;
        if (gameFullId != null) {
          _ref.read(correspondenceServiceProvider).onNotificationResponse(
                GameFullId(gameFullId),
              );
        }

      case ServerNotificationType.unhandled:
        _logger
            .warning('Received unhandled FCM notification type: $messageType');
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

    final RemoteNotification? notification = message.notification;
    final messageType = message.data['lichess.type'] as String?;

    if (messageType != null) {
      switch (ServerNotificationType.fromString(messageType)) {
        case ServerNotificationType.corresAlarm:
        case ServerNotificationType.gameTakebackOffer:
        case ServerNotificationType.gameDrawOffer:
        case ServerNotificationType.gameMove:
        case ServerNotificationType.gameFinish:
          final gameFullId = message.data['lichess.fullId'] as String?;
          final round = message.data['lichess.round'] as String?;

          if (gameFullId != null && round != null) {
            final fullId = GameFullId(gameFullId);
            final game = PlayableGame.fromServerJson(
              jsonDecode(round) as Map<String, dynamic>,
            );
            await _ref.read(correspondenceServiceProvider).onServerUpdateEvent(
                  fullId,
                  game,
                  fromBackground: fromBackground,
                );
          }

          if (fromBackground == false &&
              gameFullId != null &&
              notification != null) {
            await show(
              CorresGameUpdateNotification(
                GameFullId(gameFullId),
                notification.title!,
                notification.body!,
              ),
            );
          }

        // TODO: handle other notification types

        case ServerNotificationType.unhandled:
          _logger.warning(
            'Received unhandled FCM notification type: $messageType',
          );
      }
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
    final token = await FirebaseMessaging.instance.getToken();
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
      await _ref.withClient(
        (client) => client.post(Uri(path: '/mobile/unregister')),
      );
    } catch (e, st) {
      _logger.severe('could not unregister device; $e', e, st);
    }
  }

  Future<void> _registerToken(String token) async {
    final settings = await FirebaseMessaging.instance.getNotificationSettings();
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      return;
    }
    _logger.info('will register fcmToken: $token');
    final session = _ref.read(authSessionProvider);
    if (session == null) {
      return;
    }
    try {
      await _ref.withClient(
        (client) => client.post(Uri(path: '/mobile/register/firebase/$token')),
      );
    } catch (e, st) {
      _logger.severe('could not register device; $e', e, st);
    }
  }

  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    // create a new provider scope for the background isolate
    final ref = ProviderContainer();

    ref.listen(
      cachedDataProvider,
      (prev, now) async {
        if (!now.hasValue) return;

        try {
          await ref.read(notificationServiceProvider)._processFcmMessage(
                message,
                fromBackground: true,
              );

          ref.dispose();
        } catch (e) {
          _logger.severe('Error when processing an FCM background message: $e');
          ref.dispose();
        }
      },
    );

    ref.read(cachedDataProvider);
  }
}
