import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';

/// State mixin that sets immersive mode on Android 10 and above.
///
/// Navigation gestures start with Android 10 (API 29).
/// They conflict with board game gestures, and we must set immersive mode
/// to disable them.
mixin AndroidImmersiveMode<T extends StatefulWidget> on State<T> {
  final _deviceInfoPlugin = DeviceInfoPlugin();

  @override
  void initState() {
    super.initState();
    _setImmersiveMode();
  }

  @override
  void dispose() {
    super.dispose();
    _disableImmersiveMode();
  }

  Future<void> _setImmersiveMode() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidInfo = await _deviceInfoPlugin.androidInfo;
      if (androidInfo.version.sdkInt >= 29) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      }
    }
  }

  Future<void> _disableImmersiveMode() async {
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
