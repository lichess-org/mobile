import 'dart:async';
import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lichess_mobile/src/model/challenge/challenge_service.dart';
import 'package:lichess_mobile/src/model/notifications/local_notification.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_notification_service.g.dart';

final _notificationPlugin = FlutterLocalNotificationsPlugin();

/// A service that manages local notifications.
class LocalNotificationService {
  const LocalNotificationService._(this._log);

  static final instance =
      LocalNotificationService._(Logger('LocalNotificationService'));

  final Logger _log;

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
