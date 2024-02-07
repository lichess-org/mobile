import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

final _deviceInfoPlugin = DeviceInfoPlugin();

final immersiveModeService = ImmersiveModeService();

/// Immersive mode is a way to hide the system UI (status bar and navigation bar)
/// on Android 10 and above, and to force the device to stay awake.
///
/// Navigation gestures start with Android 10 (API 29).
/// They conflict with board game gestures, and we must set immersive mode
/// to disable them.
class ImmersiveModeService {
  Future<void> enable() async {
    WakelockPlus.enable();
    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidInfo = await _deviceInfoPlugin.androidInfo;
      if (androidInfo.version.sdkInt >= 29) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      }
    }
  }

  Future<void> disable() async {
    WakelockPlus.disable();
    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidInfo = await _deviceInfoPlugin.androidInfo;
      if (androidInfo.version.sdkInt >= 29) {
        SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.manual,
          overlays: [
            SystemUiOverlay.top,
            SystemUiOverlay.bottom,
          ],
        );
      }
    }
  }
}
