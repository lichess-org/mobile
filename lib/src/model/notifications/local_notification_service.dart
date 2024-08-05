import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/notifications/challenge_notification.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_notification_service.g.dart';
part 'local_notification_service.freezed.dart';

@Riverpod(keepAlive: true)
LocalNotificationService localNotificationService(
  LocalNotificationServiceRef ref,
) {
  return LocalNotificationService.instance;
}

class LocalNotificationService {
  LocalNotificationService(this._log);
  static final instance =
      LocalNotificationService(Logger('LocalNotificationService'));

  final _notificationPlugin = FlutterLocalNotificationsPlugin();
  final Logger _log;
  int currentId = 0;

  Future<void> init() async {
    await _notificationPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('logo_black'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          notificationCategories: <DarwinNotificationCategory>[],
        ),
      ),
      onDidReceiveNotificationResponse: _notificationRespsonse,
      onDidReceiveBackgroundNotificationResponse: _notificationRespsonse,
    );
  }

  Future<int> show(LocalNotification notification) async {
    final id = currentId++;
    await _notificationPlugin.show(
      id,
      notification.title,
      notification.body,
      notification.notificationDetails,
      payload: notification.payload,
    );
    return id;
  }

  Future<void> cancel(int id) async {
    return _notificationPlugin.cancel(id);
  }

  @pragma('vm:entry-point')
  static void _notificationRespsonse(NotificationResponse response) {
    if (response.payload == null) return;

    try {
      final splits = response.payload!.split(':');

      final id = splits[0];
      final payload = splits[1];
      switch (id) {
        case 'challenge-notification':
          final notification = ChallengeNotification(ChallengeId(payload));
          notification.callback(response.actionId);
      }
    } catch (error) {
      LocalNotificationService.instance._log.warning(
        'Malformed notification payload: [ID: ${response.id}] ${response.payload}',
      );
    }
  }
}

@freezed
class LocalNotification with _$LocalNotification {
  factory LocalNotification({
    required String title,
    String? body,
    String? payload,
    required NotificationDetails notificationDetails,
  }) = _LocalNotification;
}
