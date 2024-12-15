import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeNotificationDisplay extends Fake implements FlutterLocalNotificationsPlugin {
  final Map<int, ActiveNotification> _activeNotifications = {};

  @override
  Future<void> show(
    int id,
    String? title,
    String? body,
    NotificationDetails? notificationDetails, {
    String? payload,
  }) {
    _activeNotifications[id] = ActiveNotification(
      id: id,
      title: title,
      body: body,
      payload: payload,
    );
    return Future.value();
  }

  @override
  Future<void> cancel(int id, {String? tag}) {
    _activeNotifications.remove(id);
    return Future.value();
  }

  @override
  Future<List<ActiveNotification>> getActiveNotifications() {
    return Future.value(_activeNotifications.values.toList());
  }
}
