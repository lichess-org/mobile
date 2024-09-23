import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_service.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'challenge_notification.dart';

part 'local_notification.g.dart';
part 'local_notification.freezed.dart';

final _logger = Logger('LocalNotification');

final _notificationPlugin = FlutterLocalNotificationsPlugin();

/// A notification response and its id and payload.
typedef ParsedNotificationResponse = (
  int,
  NotificationResponse,
  NotificationPayload
);

final StreamController<ParsedNotificationResponse> _responseStreamController =
    StreamController.broadcast();

/// Stream of locale notification responses (when the user interacts with a notification).
final Stream<ParsedNotificationResponse> localNotificationResponseStream =
    _responseStreamController.stream;

enum NotificationType {
  info,
  challenge,
}

/// A service that manages local notifications.
class LocalNotificationService {
  const LocalNotificationService._(this._log);

  static final instance =
      LocalNotificationService._(Logger('LocalNotificationService'));

  final Logger _log;

  static Future<void> initialize(Locale locale) async {
    final l10n = await AppLocalizations.delegate.load(locale);
    await _notificationPlugin.initialize(
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

  /// Function called by the flutter_local_notifications plugin when a notification is received in the foreground.
  static void _onDidReceiveNotificationResponse(NotificationResponse response) {
    _logger.info('processing response in foreground. id [${response.id}]');

    if (response.id == null || response.payload == null) return;

    try {
      final payload = NotificationPayload.fromJson(
        jsonDecode(response.payload!) as Map<String, dynamic>,
      );
      _responseStreamController.add((response.id!, response, payload));
    } catch (e) {
      _logger.warning('Failed to parse notification payload: $e');
    }
  }

  /// Show a local notification.
  Future<int> show(LocalNotification notification) async {
    final id = notification.id;
    final payload = notification.payload != null
        ? jsonEncode(notification.payload!.toJson())
        : null;

    await _notificationPlugin.show(
      id,
      notification.title,
      notification.body,
      notification.details,
      payload: payload,
    );
    _log.info(
      'Sent notification: ($id | ${notification.title}) ${notification.body} (Payload: ${notification.payload})',
    );

    return id;
  }

  /// Cancel a local notification.
  Future<void> cancel(int id) async {
    _log.info('canceled notification id: [$id]');
    return _notificationPlugin.cancel(id);
  }
}

/// A service that dispatches user interaction responses from local notifications to the appropriate handlers.
class LocalNotificationDispatcher {
  LocalNotificationDispatcher(this.ref);

  final LocalNotificationDispatcherRef ref;

  StreamSubscription<ParsedNotificationResponse>? _responseSubscription;

  /// Start listening for notification responses.
  void initialize() {
    _responseSubscription = localNotificationResponseStream.listen(
      (data) {
        final (notifId, response, payload) = data;
        switch (payload.type) {
          case NotificationType.challenge:
            ref.read(challengeServiceProvider).onNotificationResponse(
                  notifId,
                  response.actionId,
                  payload,
                );
          case NotificationType.info:
            break;
        }
      },
    );
  }

  void onDispose() {
    _responseSubscription?.cancel();
  }
}

@Riverpod(keepAlive: true)
LocalNotificationDispatcher localNotificationDispatcher(
  LocalNotificationDispatcherRef ref,
) {
  final service = LocalNotificationDispatcher(ref);
  ref.onDispose(service.onDispose);
  return service;
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
