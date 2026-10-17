import 'package:lichess_mobile/src/binding/binding_fdroid.dart';
import 'package:lichess_mobile/src/bootstrap.dart';
import 'package:lichess_mobile/src/service/notification_service/unifiedpush_service.dart';

void main() {
  bootstrapApp(
    FdroidLichessBinding.ensureInitialized,
    notificationServiceFactory: UnifiedPushService.new,
  );
}
