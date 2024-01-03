import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lichess_mobile/src/notification_service.dart';

class FakeNotificationService implements NotificationService {
  @override
  Future<void> processDataMessage(RemoteMessage message) async {}

  @override
  NotificationServiceRef get ref => throw UnimplementedError();

  @override
  Future<void> registerToken(String token) async {}

  @override
  Future<void> registerDevice() async {}

  @override
  Future<void> unregister() async {}
}
