import 'package:patrol/patrol.dart';

/// Native interactions outside the app's own widgets.
final class System({required super.config}) extends PlatformAutomator {
  /// The dialog shows only while the permission is undecided, which on a hot restart it no longer
  /// is.
  Future<void> grantNotificationsPermission() async {
    if (await mobile.isPermissionDialogVisible(timeout: const Duration(seconds: 5))) {
      await mobile.grantPermissionWhenInUse();
    }
  }
}
