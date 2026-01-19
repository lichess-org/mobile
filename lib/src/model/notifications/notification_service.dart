import 'dart:async';
import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/binding.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/localizations.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/notifications/notifications.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:logging/logging.dart';
import 'package:unifiedpush/unifiedpush.dart';

final _logger = Logger('NotificationService');

/// A provider instance of the [FlutterLocalNotificationsPlugin].
final notificationDisplayProvider = Provider<FlutterLocalNotificationsPlugin>(
  (Ref _) => FlutterLocalNotificationsPlugin(),
);

/// A provider instance of the [NotificationService].
final notificationServiceProvider = Provider<NotificationService>((Ref ref) {
  final service = NotificationService(ref);

  ref.onDispose(() => service._dispose());

  return service;
});

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
  Future<void> start() {
    return UnifiedPush.initialize(
      onNewEndpoint: onNewEndpoint,
      onRegistrationFailed: onRegistrationFailed,
      onUnregistered: onUnregistered,
      onMessage: onMessage,
    ).then((registered) {
      if (registered) {
        UnifiedPush.register(vapid: kLichessVapidPublicKey);
      }
    });
  }

  void onNewEndpoint(PushEndpoint endpoint, String instance) {
    if (endpoint.pubKeySet == null) {
      _logger.warning('no public key found');
      return;
    }

    final body = {
      'endpoint': endpoint.url,
      'keys': {'auth': endpoint.pubKeySet!.auth, 'p256dh': endpoint.pubKeySet!.pubKey},
    };

    _ref
        .withClient(
          (client) => client.post(
            Uri(path: '/push/subscribe'),
            body: jsonEncode(body),
            headers: {'Content-Type': 'application/json'},
          ),
        )
        .then((response) {
          final statusCode = response.statusCode;
          if (200 <= statusCode && statusCode < 300) {
            _logger.info('new endpoint sent succesfully');
          } else {
            _logger.warning('new endpoint sent but request failed with status code $statusCode');
          }
        })
        .catchError((Object err) {
          _logger.warning('sending new endpoint failed with error $err');
        });
  }

  void onRegistrationFailed(FailedReason reason, String instance) {
    _logger.warning('registration failed for reason: $reason');
  }

  void onUnregistered(String instance) {
    _logger.info('device unregistered');
  }

  void onMessage(PushMessage message, String instance) {
    final content = jsonDecode(utf8.decode(message.content)) as Map<String, dynamic>;
    final channel = content['tag'] as String;
    _notificationDisplay.show(
      0,
      content['title'] as String,
      content['body'] as String,
      NotificationDetails(android: AndroidNotificationDetails(channel, channel)),
    );
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
  Future<void> cancel(int id) {
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

  /// Register the device for push notifications.
  Future<void> registerDevice() {
    _logger.info('register device for the first time');
    return UnifiedPush.tryUseCurrentOrDefaultDistributor().then((success) {
      if (success) {
        UnifiedPush.register(vapid: kLichessVapidPublicKey);
      } else {
        _logger.info('could not find a distributor');
      }
    });
  }

  /// Unregister the device from push notifications.
  Future<void> unregister() {
    _logger.info('will unregister');
    return UnifiedPush.unregister();
  }
}
