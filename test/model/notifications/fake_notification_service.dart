import 'package:lichess_mobile/src/model/notifications/notification_service.dart';
import 'package:lichess_mobile/src/model/notifications/notifications.dart';

class FakeNotificationService implements NotificationService {
  Map<int, LocalNotification> notifications = {};

  @override
  Future<void> start() async {}

  @override
  Future<void> registerDevice() async {}

  @override
  Future<void> unregister() async {}

  @override
  Future<void> cancel(int id) async {
    notifications.remove(id);
  }

  @override
  Future<int> show(LocalNotification notification) async {
    notifications[notification.id] = notification;
    return notification.id;
  }
}
