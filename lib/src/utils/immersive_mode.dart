import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lichess_mobile/src/utils/focus_detector.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

final _deviceInfoPlugin = DeviceInfoPlugin();

/// A widget that enables immersive mode when focused.
class ImmersiveModeWidget extends StatelessWidget {
  const ImmersiveModeWidget({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onVisibilityGained: () => ImmersiveMode.instance.enable(),
      onVisibilityLost: () => ImmersiveMode.instance.disable(),
      child: child,
    );
  }
}

/// Immersive mode is a way to hide the system UI (status bar and navigation bar)
/// on Android 10 and above, and to force the device to stay awake.
///
/// Navigation gestures start with Android 10 (API 29).
/// They conflict with board game gestures, and we must set immersive mode
/// to disable them.
class ImmersiveMode {
  const ImmersiveMode._();

  static const instance = ImmersiveMode._();

  /// Enable immersive mode.
  ///
  /// This hides the system UI (status bar and navigation bar) and forces the
  /// device to stay awake.
  Future<void> enable() async {
    WakelockPlus.enable();
    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidInfo = await _deviceInfoPlugin.androidInfo;
      if (androidInfo.version.sdkInt >= 29) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      }
    }
  }

  /// Disable immersive mode.
  ///
  /// This shows the system UI (status bar and navigation bar) and allows the
  /// device to sleep.
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
