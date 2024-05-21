import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lichess_mobile/src/utils/focus_detector.dart';

final _deviceInfoPlugin = DeviceInfoPlugin();

/// A widget that enables board gestures exclusion on android 10+ when focused.
///
/// Navigation gestures start with Android 10 (API 29).
/// They conflict with board game gestures, and we must set immersive mode
/// to disable them.
class AndroidGesturesExclusionWidget extends StatelessWidget {
  const AndroidGesturesExclusionWidget({
    required this.child,
    required this.boardKey,
    this.shouldExcludeGesturesOnFocusGained,
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
  final bool Function()? shouldExcludeGesturesOnFocusGained;

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        if (shouldExcludeGesturesOnFocusGained?.call() ?? true) {
          setAndroidBoardGesturesExclusion(boardKey);
        }
      },
      onFocusLost: () {
        clearAndroidBoardGesturesExclusion();
      },
      child: child,
    );
  }
}

/// Set immersive mode to hide the system UI and set gestures exclusion over the
/// board widget. Only works on Android 10+.
Future<void> setAndroidBoardGesturesExclusion(GlobalKey boardKey) async {
  final context = boardKey.currentContext;
  if (context == null) {
    return;
  }
  if (defaultTargetPlatform != TargetPlatform.android) {
    return;
  }
  final androidInfo = await _deviceInfoPlugin.androidInfo;
  if (androidInfo.version.sdkInt >= 29) {
    if (context.mounted) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
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
  static const _channel =
      MethodChannel('mobile.lichess.org/gestures_exclusion');

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
      await _channel.invokeMethod<void>(
        'setSystemGestureExclusionRects',
        rectsAsMaps,
      );
    } on PlatformException catch (e) {
      debugPrint('Failed to set rects: ${e.message}');
    }
  }

  Future<void> clearRects() async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return;
    }

    try {
      await _channel
          .invokeMethod<void>('setSystemGestureExclusionRects', <Rect>[]);
    } on PlatformException catch (e) {
      debugPrint('Failed to clear rects: ${e.message}');
    }
  }
}
