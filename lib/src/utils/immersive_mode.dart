import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lichess_mobile/src/utils/focus_detector.dart';
import 'package:lichess_mobile/src/utils/gestures_exclusion.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

final _deviceInfoPlugin = DeviceInfoPlugin();

/// A widget that enables immersive mode when focused.
class ImmersiveModeWidget extends StatelessWidget {
  /// Create a new immersive mode widget, that enables immersive mode when focused.
  const ImmersiveModeWidget({
    required this.child,
    this.boardKey,
    this.onFocusGained,
    super.key,
  });

  final Widget child;

  /// Optional key of the board widget.
  ///
  /// If provided, the widget will set gestures exclusion on android.
  final GlobalKey? boardKey;

  /// Optional callback called when visibility is gained.
  ///
  /// If provided, the widget will call this callback when focus is gained,
  /// instead of enabling immersive mode directly. This allows the parent to
  /// control when immersive mode is enabled.
  /// If the callback is null, the widget will enable immersive mode directly.
  final VoidCallback? onFocusGained;

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        onFocusGained?.call();
        if (onFocusGained == null) {
          ImmersiveMode.instance.enable();
        }
        if (boardKey != null) {
          _setAndroidGesturesExclusion();
        }
      },
      onFocusLost: () {
        ImmersiveMode.instance.disable();
        if (boardKey != null) {
          _clearAndroidGesturesExclusion();
        }
      },
      child: child,
    );
  }

  void _setAndroidGesturesExclusion() {
    final context = boardKey?.currentContext;
    if (context == null) {
      return;
    }
    final box = context.findRenderObject();
    if (box != null && box is RenderBox) {
      final position = box.localToGlobal(Offset.zero);
      final ratio = MediaQuery.devicePixelRatioOf(context);
      final verticalThreshold = 10 * ratio;
      final left = position.dx * ratio;
      final top = position.dy * ratio;
      final right = left + box.size.width * ratio;
      final bottom = top + box.size.height * ratio;
      final rect = Rect.fromLTRB(
        left,
        top - verticalThreshold,
        right,
        bottom + verticalThreshold,
      );
      GesturesExclusion.instance.setRects([rect]);
    }
  }

  void _clearAndroidGesturesExclusion() {
    GesturesExclusion.instance.clearRects();
  }
}

/// A widget that enables wakelock when focused.
class WakelockWidget extends StatelessWidget {
  /// Create a new wakelock widget, that enables wakelock when focused.
  const WakelockWidget({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        WakelockPlus.enable();
      },
      onFocusLost: () {
        WakelockPlus.disable();
      },
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
