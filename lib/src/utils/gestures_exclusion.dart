import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lichess_mobile/src/utils/focus_detector.dart';
import 'package:lichess_mobile/src/utils/screen.dart';

final _deviceInfoPlugin = DeviceInfoPlugin();

/// A widget that enables board gestures exclusion on android 10+ when focused.
///
/// Navigation gestures start with Android 10 (API 29).
/// They conflict with board game gestures, and we must set immersive mode
/// to disable them.
///
/// This widget will keep the initial [MediaQueryData.viewPadding] whether immersive mode is set or
/// not. This works in conjunction with the [SafeArea.maintainBottomViewPadding] property. This is
/// the responsibility of the parent widget to set the [SafeArea] with the correct value.
class AndroidGesturesExclusionWidget extends StatefulWidget {
  const AndroidGesturesExclusionWidget({
    required this.child,
    required this.boardKey,
    this.shouldExcludeGesturesOnFocusGained,
    this.shouldSetImmersiveMode = false,
    super.key,
  });

  final Widget child;

  /// Global key of the board widget.
  final GlobalKey boardKey;

  /// Optional callback called when focus is gained, to check whether
  /// to exclude gestures or not.
  ///
  /// If provided, the widget will call this callback when focus is gained,
  /// and will not exclude gestures if the callback returns false.
  /// If not provided, the widget will enable immersive mode by default.
  final bool? shouldExcludeGesturesOnFocusGained;

  /// Whether to set immersive mode with the gestures exclusion.
  ///
  /// False by default.
  final bool shouldSetImmersiveMode;

  @override
  State<AndroidGesturesExclusionWidget> createState() => _AndroidGesturesExclusionWidgetState();
}

class _AndroidGesturesExclusionWidgetState extends State<AndroidGesturesExclusionWidget> {
  EdgeInsets? initialViewPadding;

  @override
  Widget build(BuildContext context) {
    initialViewPadding ??= MediaQuery.of(context).viewPadding;

    return MediaQuery(
      // Always set the view padding to the initial value to avoid an UI shift when immersive mode
      // is enabled.
      data: MediaQuery.of(context).copyWith(viewPadding: initialViewPadding),
      child: FocusDetector(
        onFocusGained: () {
          if (widget.shouldExcludeGesturesOnFocusGained ?? true) {
            setAndroidBoardGesturesExclusion(
              widget.boardKey,
              withImmersiveMode: widget.shouldSetImmersiveMode,
            );
          }
        },
        onFocusLost: () {
          clearAndroidBoardGesturesExclusion();
        },
        child: widget.child,
      ),
    );
  }
}

/// Set immersive mode to hide the system UI and set gestures exclusion over the
/// board widget. Only works on Android 10+.
Future<void> setAndroidBoardGesturesExclusion(
  GlobalKey boardKey, {
  bool withImmersiveMode = false,
}) async {
  final context = boardKey.currentContext;
  if (context == null) {
    return;
  }
  if (defaultTargetPlatform != TargetPlatform.android) {
    return;
  }
  if (isTabletOrLarger(context)) {
    return;
  }
  final androidInfo = await _deviceInfoPlugin.androidInfo;
  if (androidInfo.version.sdkInt < 29) {
    return;
  }

  if (context.mounted) {
    if (withImmersiveMode) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
    final box = context.findRenderObject();
    if (box != null && box is RenderBox) {
      final position = box.localToGlobal(Offset.zero);
      final ratio = MediaQuery.devicePixelRatioOf(context);
      final verticalThreshold = 10 * ratio;
      final left = position.dx * ratio;
      final top = position.dy * ratio;
      final right = left + box.size.width * ratio;
      final height = box.size.height * ratio;
      final squareSize = height / 8;
      final leftRect = Rect.fromLTWH(
        left,
        top - verticalThreshold,
        squareSize,
        height + verticalThreshold,
      );
      final rightRect = Rect.fromLTWH(
        right - squareSize,
        top - verticalThreshold,
        squareSize,
        height + verticalThreshold,
      );
      GesturesExclusion.instance.setRects([leftRect, rightRect]);
    }
  }
}

/// Clear gestures exclusion over the board widget and remove immersive mode.
/// Only works on Android 10+.
Future<void> clearAndroidBoardGesturesExclusion() async {
  if (defaultTargetPlatform == TargetPlatform.android) {
    final androidInfo = await _deviceInfoPlugin.androidInfo;
    if (androidInfo.version.sdkInt >= 29) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      GesturesExclusion.instance.clearRects();
    }
  }
}

class GesturesExclusion {
  static const _channel = MethodChannel('mobile.lichess.org/gestures_exclusion');

  const GesturesExclusion._();

  static const instance = GesturesExclusion._();

  Future<void> setRects(List<Rect> rects) async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return;
    }

    final rectsAsMaps = rects
        .map(
          (r) => r.hasNaN || r.isInfinite
              ? null
              : {
                  'left': r.left.floor(),
                  'top': r.top.floor(),
                  'right': r.right.floor(),
                  'bottom': r.bottom.floor(),
                },
        )
        .toList();

    try {
      await _channel.invokeMethod<void>('setSystemGestureExclusionRects', rectsAsMaps);
    } on PlatformException catch (e) {
      debugPrint('Failed to set rects: ${e.message}');
    }
  }

  Future<void> clearRects() async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return;
    }

    try {
      await _channel.invokeMethod<void>('setSystemGestureExclusionRects', <Rect>[]);
    } on PlatformException catch (e) {
      debugPrint('Failed to clear rects: ${e.message}');
    }
  }
}
