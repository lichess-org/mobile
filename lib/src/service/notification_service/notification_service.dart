import 'dart:async';
import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/localizations.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/notifications/notifications.dart';
import 'package:lichess_mobile/src/utils/badge_service.dart';
import 'package:meta/meta.dart';

/// A provider instance of the [FlutterLocalNotificationsPlugin].
final notificationDisplayProvider = Provider<FlutterLocalNotificationsPlugin>(
  (Ref _) => FlutterLocalNotificationsPlugin(),
);

/// A provider instance of the [NotificationPresenter].
final notificationPresenterProvider = Provider<NotificationPresenter>(
  (ref) => NotificationPresenter(ref),
);

/// A class to handle display of local notifications
class NotificationPresenter(final Ref _ref) {
  FlutterLocalNotificationsPlugin get _display => _ref.read(notificationDisplayProvider);
  AppLocalizations get _l10n => _ref.read(localizationsProvider).strings;

  /// Shows a notification.
  Future<int> show(LocalNotification notification) async {
    final id = notification.id;
    final payload = jsonEncode(notification.payload);

    final title = notification.title(_l10n);
    final body = notification.body(_l10n);

    await _display.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notification.details(_l10n),
      payload: payload,
    );
    notificationLogger.info(
      'Show local notification: ($id | $title) $body (Payload: ${notification.payload})',
    );

    return id;
  }

  /// Cancels/removes a notification.
  Future<void> cancel(int id) {
    notificationLogger.info('canceled notification id: [$id]');
    return _display.cancel(id: id);
  }
}

typedef NotificationServiceFactory = NotificationService Function(Ref ref);

/// Factory provider to create the push service implementation
/// Must be overridden in the root [ProviderScope].
final notificationServiceFactoryProvider = Provider<NotificationServiceFactory>(
  (ref) => throw UnimplementedError('notificationServiceFactoryProvider must be overridden'),
);

/// A provider instance of the [NotificationService].
final notificationServiceProvider = Provider<NotificationService>((Ref ref) {
  final service = ref.watch(notificationServiceFactoryProvider)(ref);

  ref.onDispose(() => service.dispose());

  return service;
});

/// Received push message and whether it was from the background.
typedef ReceivedPushMessage = ({ParsedPushMessage message, bool fromBackground});

/// A [NotificationResponse] and the associated [LocalNotification].
typedef ParsedLocalNotification = (NotificationResponse response, LocalNotification notification);

/// Abstract base service for handling push notifications.
///
/// This service is responsible for handling incoming messages from either FCM or UnifiedPush and
/// showing notifications.
///
/// Parsed messages are broadcast via [pushMessageStream], and notification tap responses
/// are dispatched via [responseStream].
abstract class NotificationService(final Ref ref) {
  /// The stream controller for notification responses.
  @protected
  static final StreamController<ParsedLocalNotification> responseStreamController =
      StreamController.broadcast();

  /// The stream of notification responses.
  ///
  /// A notification response is dispatched when a notification has been interacted with.
  static Stream<ParsedLocalNotification> get responseStream => responseStreamController.stream;

  /// The stream controller for push messages.
  static final StreamController<ReceivedPushMessage> _pushMessageStreamController =
      StreamController.broadcast();

  /// The stream of push messages.
  ///
  /// A push message is dispatched when a message is received.
  static Stream<ReceivedPushMessage> get pushMessageStream => _pushMessageStreamController.stream;

  /// The stream subscription for authentication events.
  StreamSubscription<AuthEvent>? _authEventsSubscription;

  /// Starts the notification service.
  Future<void> start();

  /// Register the device for push notifications.
  ///
  /// Returns true if the device was successfully registered, false otherwise.
  @protected
  Future<bool> register();

  /// Unregister the device from push notifications.
  @protected
  Future<void> unregister();

  @protected
  Future<void> startAuthEventListener() async {
    await _authEventsSubscription?.cancel();
    _authEventsSubscription = authEventsStream.listen((event) {
      switch (event) {
        case AuthEvent.signIn:
          unawaited(
            register().catchError((Object e, StackTrace st) {
              notificationLogger.severe('Could not register device after sign-in:', e, st);
              return false;
            }),
          );
        case AuthEvent.signOut:
          unawaited(
            unregister().catchError((Object e, StackTrace st) {
              notificationLogger.severe('Could not unregister device after sign-out:', e, st);
            }),
          );
      }
    });
  }

  /// Whether a received message must be displayed as a local notification by the app.
  ///
  /// Challenge requests received in foreground are handled by the socket, which shows a
  /// [ChallengeNotification] with accept/decline actions instead.
  @protected
  bool shouldShow(ParsedPushMessage message, {required bool fromBackground});

  @protected
  Future<void> processPushMessage(PushMessage message, {required bool fromBackground}) async {
    notificationLogger.fine(
      'Processing a push message from ${fromBackground ? 'background' : 'foreground'}: ${message.data}',
    );

    final parsedMessage = ParsedPushMessage.fromPushMessage(message);

    _pushMessageStreamController.add((message: parsedMessage, fromBackground: fromBackground));

    final localNotification = parsedMessage.toLocalNotification();

    if (localNotification == null) {
      logUnsupportedMessage(parsedMessage);
    } else if (shouldShow(parsedMessage, fromBackground: fromBackground)) {
      await ref.read(notificationPresenterProvider).show(localNotification);
    }

    // update badge
    final badge = message.data['lichess.iosBadge'] as String?;
    if (badge != null) {
      try {
        await BadgeService.instance.setBadge(int.parse(badge));
      } catch (e, st) {
        notificationLogger.severe('Could not parse badge: $badge', e, st);
      }
    }
  }

  /// Logs a push message that has no local notification representation.
  @protected
  void logUnsupportedMessage(ParsedPushMessage message) {
    switch (message) {
      case UnhandledPushMessage(:final data):
        notificationLogger.warning('Received unhandled push message type: ${data['lichess.type']}');
      case MalformedPushMessage(:final data):
        notificationLogger.severe('Received malformed push message: $data');
      default:
    }
  }

  @protected
  void dispose() {
    _authEventsSubscription?.cancel();
  }
}

/// Function called by the notification plugin when a notification has been tapped on.
void onDidReceiveNotificationResponse(NotificationResponse response) {
  notificationLogger.fine('received local notification ${response.id} response in foreground.');

  final rawPayload = response.payload;

  if (rawPayload == null) {
    notificationLogger.warning('Received a notification response with no payload.');
    return;
  }

  final json = jsonDecode(rawPayload) as Map<String, dynamic>;
  final notification = LocalNotification.fromJson(json);

  NotificationService.responseStreamController.add((response, notification));
}
