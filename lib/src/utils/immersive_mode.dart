import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';

final RouteObserver<Route<void>> immersiveModeRouteObserver =
    RouteObserver<Route<void>>();

/// State mixin that sets immersive mode on Android 10 and above.
///
/// Navigation gestures start with Android 10 (API 29).
/// They conflict with board game gestures, and we must set immersive mode
/// to disable them.
mixin AndroidImmersiveMode<T extends StatefulWidget> on State<T>
    implements RouteAware {
  final _deviceInfoPlugin = DeviceInfoPlugin();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null) {
      immersiveModeRouteObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    immersiveModeRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _setImmersiveMode();
  }

  @override
  void didPush() {
    _setImmersiveMode();
  }

  @override
  void didPop() {
    _disableImmersiveMode();
  }

  @override
  void didPushNext() {
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
