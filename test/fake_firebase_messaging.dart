import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lichess_mobile/src/firebase_messaging.dart';

class FakeFirebaseMessagingService implements FirebaseMessagingService {
  @override
  Future<void> processDataMessage(RemoteMessage message) async {}

  @override
  FirebaseMessagingServiceRef get ref => throw UnimplementedError();

  @override
  Future<void> registerDevice(String token) async {}

  @override
  Future<void> registerToken() async {}

  @override
  Future<void> unregister() async {}
}
