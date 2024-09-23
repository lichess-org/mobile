import 'package:lichess_mobile/src/model/notifications/push_notification_service.dart';

class FakeNotificationService implements PushNotificationService {
  @override
  Future<void> start() async {}

  @override
  PushNotificationServiceRef get ref => throw UnimplementedError();

  @override
  Future<void> registerDevice() async {}

  @override
  Future<void> unregister() async {}
}
