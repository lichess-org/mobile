import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/utils/focus_detector.dart';
import 'package:lichess_mobile/src/utils/gestures_exclusion.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// A widget that provides an interactive board screen.
class InteractiveBoardScreen<T> extends StatelessWidget {
  const InteractiveBoardScreen({
    required this.child,
    required this.boardKey,
    required this.isInteractive,
    required this.shouldSetImmersiveMode,
    this.onFocusRegained,
    this.canPop,
    this.onPopInvokedWithResult,
    super.key,
  });

  /// The child widget to display.
  final Widget child;

  /// Whether the chessboard is currently interactive.
  final bool isInteractive;

  /// Whether the screen can be popped.
  final bool? canPop;

  final PopInvokedWithResultCallback<T>? onPopInvokedWithResult;

  /// Whether to enable immersive mode on Android while playing.
  final bool shouldSetImmersiveMode;

  /// Global key of the board widget. This is needed to exclude system gestures on Android.
  final GlobalKey boardKey;

  final VoidCallback? onFocusRegained;

  @override
  Widget build(BuildContext context) {
    final content = PopScope(
      canPop: canPop ?? !isInteractive,
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: SafeArea(
        // view padding can change on Android when immersive mode is enabled, so to prevent any
        // board vertical shift, we set `maintainBottomViewPadding` to true.
        maintainBottomViewPadding: true,
        child: FocusDetector(
          onFocusRegained: onFocusRegained,
          onFocusGained: () {
            if (isInteractive) {
              WakelockPlus.enable();
            }
          },
          onFocusLost: () {
            WakelockPlus.disable();
          },
          child: child,
        ),
      ),
    );

    return Theme.of(context).platform == TargetPlatform.android
        ? AndroidGesturesExclusionWidget(
            boardKey: boardKey,
            shouldExcludeGesturesOnFocusGained: isInteractive,
            shouldSetImmersiveMode: shouldSetImmersiveMode,
            child: content,
          )
        : content;
  }
}
