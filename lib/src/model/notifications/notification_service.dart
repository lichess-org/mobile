import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/firebase_options.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/init.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_service.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/correspondence/correspondence_service.dart';
import 'package:lichess_mobile/src/model/game/playable_game.dart';
import 'package:lichess_mobile/src/model/notifications/challenge_notification.dart';
import 'package:lichess_mobile/src/utils/badge_service.dart';
import 'package:lichess_mobile/src/utils/connectivity.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_service.g.dart';
part 'notification_service.freezed.dart';

final _localNotificationPlugin = FlutterLocalNotificationsPlugin();
final _logger = Logger('NotificationService');

/// A notification response with its ID and payload.
typedef NotificationResponseData = ({
  /// The notification id.
  int id,

  /// The id of the action that was triggered.
  String? actionId,

  /// The value of the input field if the notification action had an input
  /// field.
  String? input,

  /// The parsed notification payload.
  NotificationPayload? payload,
});

enum NotificationType {
  corresGameUpdate,
  challenge,
}

@Freezed(fromJson: true, toJson: true)
class NotificationPayload with _$NotificationPayload {
  factory NotificationPayload({
    required NotificationType type,
    required Map<String, dynamic> data,
  }) = _NotificationPayload;

  factory NotificationPayload.fromJson(Map<String, dynamic> json) =>
      _$NotificationPayloadFromJson(json);
}

/// A local notification that can be shown to the user.
abstract class LocalNotification {
  int get id;
  String get title;
  String? get body;
  NotificationPayload? get payload;
  NotificationDetails get details;
}

@Riverpod(keepAlive: true)
NotificationService notificationService(NotificationServiceRef ref) {
  final service = NotificationService(ref);

  ref.onDispose(() => service._dispose());

  return service;
}

/// A service that manages notifications.
///
/// This service is responsible for handling incoming messages from the Firebase
/// Cloud Messaging service and updating the application state accordingly.
class NotificationService {
  NotificationService(this._ref);

  final NotificationServiceRef _ref;

  StreamSubscription<String>? _fcmTokenRefreshSubscription;
  ProviderSubscription<AsyncValue<ConnectivityStatus>>?
      _connectivitySubscription;

  static final StreamController<NotificationResponseData>
      _responseStreamController = StreamController.broadcast();

  /// Stream of locale notification responses (when the user interacts with a notification).
  static final Stream<NotificationResponseData> responseStream =
      _responseStreamController.stream;

  StreamSubscription<NotificationResponseData>? _responseStreamSubscription;

  bool _registeredDevice = false;

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

  /// Starts the remote notification service.
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
          debugPrint('Could not setup push notifications; $e\n$st');
        }
      }
    });

    // Listen for incoming messages while the app is in the foreground.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _logger.fine('processing FCM message received in foreground: $message');
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
    _responseStreamSubscription = responseStream.listen(
      (data) => _dispatchNotificationResponse(data),
    );
  }

  /// Shows a notification.
  Future<int> show(LocalNotification notification) async {
    final id = notification.id;
    final payload = notification.payload != null
        ? jsonEncode(notification.payload!.toJson())
        : null;

    await _localNotificationPlugin.show(
      id,
      notification.title,
      notification.body,
      notification.details,
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

  void _dispatchNotificationResponse(NotificationResponseData data) {
    final (id: id, payload: payload, actionId: actionId, input: _) = data;

    if (payload == null) return;

    switch (payload.type) {
      case NotificationType.challenge:
        _ref.read(challengeServiceProvider).onNotificationResponse(
              id,
              actionId,
              payload,
            );
      case NotificationType.corresGameUpdate:
        // TODO handle corres game update notifs
        break;
    }
  }

  /// Function called by the flutter_local_notifications plugin when the user interacts with a notification that causes the app to open.
  static void _onDidReceiveNotificationResponse(NotificationResponse response) {
    _logger.info('processing response in foreground. id [${response.id}]');

    if (response.id == null) return;

    try {
      final payload = response.payload != null
          ? NotificationPayload.fromJson(
              jsonDecode(response.payload!) as Map<String, dynamic>,
            )
          : null;
      _responseStreamController.add(
        (
          id: response.id!,
          actionId: response.actionId,
          input: response.input,
          payload: payload,
        ),
      );
    } catch (e) {
      _logger.warning('Failed to parse notification payload: $e');
    }
  }

  /// Handle an FCM message that caused the application to open
  void _handleFcmMessageOpenedApp(RemoteMessage message) {
    switch (message.data['lichess.type']) {
      // correspondence game message types
      // TODO: handle other message types
      case 'corresAlarm':
      case 'gameTakebackOffer':
      case 'gameDrawOffer':
      case 'gameMove':
      case 'gameFinish':
        final gameFullId = message.data['lichess.fullId'] as String?;
        if (gameFullId != null) {
          _ref.read(correspondenceServiceProvider).onNotificationResponse(
                GameFullId(gameFullId),
              );
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

  /// Process a message received from the Firebase Cloud Messaging service.
  Future<void> _processFcmMessage(
    RemoteMessage message, {
    required bool fromBackground,
  }) async {
    final gameFullId = message.data['lichess.fullId'] as String?;
    final round = message.data['lichess.round'] as String?;

    // update correspondence game
    if (gameFullId != null && round != null) {
      final fullId = GameFullId(gameFullId);
      final game = PlayableGame.fromServerJson(
        jsonDecode(round) as Map<String, dynamic>,
      );
      _ref.read(correspondenceServiceProvider).updateGame(fullId, game);

      if (!fromBackground) {
        // opponent just played, invalidate ongoing games
        if (game.sideToMove == game.youAre) {
          _ref.invalidate(ongoingGamesProvider);
        }
      }
    }

    // update badge
    final badge = message.data['lichess.iosBadge'] as String?;
    if (badge != null) {
      try {
        BadgeService.instance.setBadge(int.parse(badge));
      } catch (e) {
        _logger.severe('Could not parse badge: $badge');
      }
    }
  }

  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    debugPrint('Handling a FCM background message: ${message.data}');

    // create a new provider scope for the background isolate
    final ref = ProviderContainer();

    ref.listen(
      cachedDataProvider,
      (prev, now) {
        if (!now.hasValue) return;

        try {
          ref.read(notificationServiceProvider)._processFcmMessage(
                message,
                fromBackground: true,
              );

          ref.dispose();
        } catch (e) {
          debugPrint('Error when processing an FCM background message: $e');
          ref.dispose();
        }
      },
    );

    ref.read(cachedDataProvider);
  }
}
