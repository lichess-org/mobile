import 'package:lichess_mobile/src/binding/binding_fdroid.dart';
import 'package:lichess_mobile/src/bootstrap.dart';
import 'package:lichess_mobile/src/build_info.dart';
import 'package:lichess_mobile/src/service/notification_service/unifiedpush_service.dart';

void main(List<String> args) {
  isFdroidBuild = true;
  bootstrapApp(
    FdroidLichessBinding.ensureInitialized,
    notificationServiceFactory: UnifiedPushService.new,
    args: args,
  );
}
