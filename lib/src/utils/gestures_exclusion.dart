import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

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
