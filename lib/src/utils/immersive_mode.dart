import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

final _deviceInfoPlugin = DeviceInfoPlugin();

/// State mixin that sets immersive mode for board screens.
///
/// Mixin user must subscribe to the [NavigatorObserver] and call `super`.
///
/// Immersive mode is a way to hide the system UI (status bar and navigation bar)
/// on Android 10 and above, and to force the device to stay awake.
///
/// Navigation gestures start with Android 10 (API 29).
/// They conflict with board game gestures, and we must set immersive mode
/// to disable them.
mixin ImmersiveMode<T extends StatefulWidget> on State<T>
    implements RouteAware {
  @override
  void didPopNext() {
    _setImmersiveMode();
    WakelockPlus.enable();
  }

  @override
  void didPush() {
    _setImmersiveMode();
    WakelockPlus.enable();
  }

  @override
  void didPop() {
    _disableImmersiveMode();
    WakelockPlus.disable();
  }

  @override
  void didPushNext() {
    _disableImmersiveMode();
    WakelockPlus.disable();
  }

  Future<void> _setImmersiveMode() async {
    if (Theme.of(context).platform == TargetPlatform.android) {
      final androidInfo = await _deviceInfoPlugin.androidInfo;
      if (androidInfo.version.sdkInt >= 29) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      }
    }
  }

  Future<void> _disableImmersiveMode() async {
    if (Theme.of(context).platform == TargetPlatform.android) {
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
