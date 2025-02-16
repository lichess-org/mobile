import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lichess_mobile/src/utils/focus_detector.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// A widget that enables immersive mode when focused.
///
/// Immersive mode will hide the system UI (status bar and navigation bar) and
/// force the device to stay awake.
class ImmersiveModeWidget extends StatelessWidget {
  /// Create a new immersive mode widget, that enables immersive mode when focused.
  const ImmersiveModeWidget({required this.child, this.shouldEnableOnFocusGained, super.key});

  final Widget child;

  final bool Function()? shouldEnableOnFocusGained;

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        if (shouldEnableOnFocusGained?.call() ?? true) {
          ImmersiveMode.instance.enable();
        }
      },
      onFocusLost: () {
        ImmersiveMode.instance.disable();
      },
      child: child,
    );
  }
}

/// A widget that enables wakelock when focused.
class WakelockWidget extends StatelessWidget {
  /// Create a new wakelock widget, that enables wakelock when focused.
  const WakelockWidget({required this.child, this.shouldEnableOnFocusGained, super.key});

  final Widget child;

  final bool Function()? shouldEnableOnFocusGained;

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        if (shouldEnableOnFocusGained?.call() ?? true) {
          WakelockPlus.enable();
        }
      },
      onFocusLost: () {
        WakelockPlus.disable();
      },
      child: child,
    );
  }
}

/// Immersive mode is a way to hide the system UI (status bar and navigation bar)
/// and to force the device to stay awake.
class ImmersiveMode {
  const ImmersiveMode._();

  static const instance = ImmersiveMode._();

  /// Enable immersive mode.
  ///
  /// This hides the system UI (status bar and navigation bar) and forces the
  /// device to stay awake.
  Future<void> enable() async {
    return Future.wait([
      WakelockPlus.enable(),
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky),
    ]).then((_) {});
  }

  /// Disable immersive mode.
  ///
  /// This shows the system UI (status bar and navigation bar) and allows the
  /// device to sleep.
  Future<void> disable() async {
    final wakeFuture = WakelockPlus.disable();

    final androidInfo =
        defaultTargetPlatform == TargetPlatform.android
            ? await DeviceInfoPlugin().androidInfo
            : null;

    final setUiModeFuture =
        androidInfo == null || androidInfo.version.sdkInt >= 29
            ? SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge)
            : SystemChrome.setEnabledSystemUIMode(
              SystemUiMode.manual,
              overlays: SystemUiOverlay.values,
            );

    return Future.wait([wakeFuture, setUiModeFuture]).then((_) {});
  }
}
