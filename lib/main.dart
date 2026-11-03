import 'package:lichess_mobile/src/binding/binding_play.dart';
import 'package:lichess_mobile/src/bootstrap.dart';
import 'package:lichess_mobile/src/service/notification_service/fcm_service.dart';

Future<void> main() async {
  await bootstrapApp(
    initializeBinding: PlayLichessBinding.ensureInitialized,
    notificationServiceFactory: FcmService.new,
  );
}
