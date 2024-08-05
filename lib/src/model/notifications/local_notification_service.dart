import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_notification_service.g.dart';

@riverpod
LocalNotificationService localNotificationService(
  LocalNotificationServiceRef ref,
) {
  return LocalNotificationService.instance;
}

class LocalNotificationService {
  static final instance = LocalNotificationService();

  final _notificationPlugin = FlutterLocalNotificationsPlugin();
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

  Future<int> showActionNotification(
    String title,
    ActionNotification notification, {
    String? body,
  }) async {
    final id = currentId++;
    await _notificationPlugin.show(
      id,
      title,
      body,
      notification.notificationDetails,
      payload: notification.payload,
    );
    return id;
  }

  Future<int> show(
    String title, {
    String? body,
  }) async {
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'info',
        'Information',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );
    final id = currentId++;
    await _notificationPlugin.show(
      id,
      title,
      body,
      notificationDetails,
    );
    return id;
  }

  Future<void> cancel(int id) async {
    return _notificationPlugin.cancel(id);
  }

  @pragma('vm:entry-point')
  static void _notificationRespsonse(NotificationResponse response) {
    final splits = response.payload?.split(':');
    if (splits == null) return;

    final id = splits[0];
    final payload = splits[1];
    switch (id) {}
  }
}

abstract class ActionNotification {
  void callback(String? actionId);
  String? get payload;
  NotificationDetails get notificationDetails;
  DarwinNotificationCategory get darwinNotificationCategory;
}
