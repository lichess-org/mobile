import 'package:patrol/patrol.dart';

/// Native interactions outside the app's own widgets.
final class System({required super.config}) extends PlatformAutomator {
  Future<void> grantNotificationsPermission() async {
    if (await mobile.isPermissionDialogVisible()) {
      await mobile.grantPermissionWhenInUse();
    }
  }
}
