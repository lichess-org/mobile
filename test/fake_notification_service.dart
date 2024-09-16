import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lichess_mobile/src/model/notifications/push_notification_service.dart';

class FakeNotificationService implements PushNotificationService {
  @override
  Future<void> processDataMessage(RemoteMessage message) async {}

  @override
  PushNotificationServiceRef get ref => throw UnimplementedError();

  @override
  Future<void> registerToken(String token) async {}

  @override
  Future<void> registerDevice() async {}

  @override
  Future<void> unregister() async {}
}
