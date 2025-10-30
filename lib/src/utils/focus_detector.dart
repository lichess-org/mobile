import 'package:flutter/widgets.dart';
import 'package:visibility_detector/visibility_detector.dart';

// code taken and adapted from
// https://github.com/EdsonBueno/focus_detector

/// Fires callbacks every time the widget appears or disappears from the screen.
class FocusDetector extends StatefulWidget {
  const FocusDetector({
    required this.child,
    this.onFocusGained,
    this.onFocusRegained,
    this.onFocusLost,
    this.onVisibilityGained,
    this.onVisibilityRegained,
    this.onVisibilityLost,
    this.onForegroundGained,
    this.onForegroundLost,
    super.key,
  });

  /// Called when the widget becomes visible or enters foreground while visible.
  final VoidCallback? onFocusGained;

  /// Called when the widget gains focus again (same as onFocusGained but does
  /// not fires the first time).
  final VoidCallback? onFocusRegained;

  /// Called when the widget becomes invisible or enters background while visible.
  final VoidCallback? onFocusLost;

  /// Called when the widget becomes visible.
  final VoidCallback? onVisibilityGained;

  /// Called when the widget become visible again (same as onVisibilityGained but
  /// does not fires the first time).
  final VoidCallback? onVisibilityRegained;

  /// Called when the widget becomes invisible.
  final VoidCallback? onVisibilityLost;

  /// Called when the app entered the foreground while the widget is visible.
  final VoidCallback? onForegroundGained;

  /// Called when the app is sent to background while the widget was visible.
  final VoidCallback? onForegroundLost;

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  _FocusDetectorState createState() => _FocusDetectorState();
}

class _FocusDetectorState extends State<FocusDetector> with WidgetsBindingObserver {
  final _visibilityDetectorKey = UniqueKey();

  /// Counter to keep track of the visibility changes.
  int _visibilityCounter = 0;

  /// Whether this widget is currently visible within the app.
  bool _isWidgetVisible = false;

  /// Whether the app is in the foreground.
  bool _isAppInForeground = true;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _notifyPlaneTransition(state);
  }

  /// Notifies app's transitions to/from the foreground.
  void _notifyPlaneTransition(AppLifecycleState state) {
    if (!_isWidgetVisible) {
      return;
    }

    final isAppResumed = state == AppLifecycleState.resumed;
    final wasResumed = _isAppInForeground;
    if (isAppResumed && !wasResumed) {
      _isAppInForeground = true;
      _notifyFocusGain();
      _notifyForegroundGain();
      return;
    }

    final isAppPaused = state == AppLifecycleState.paused;
    if (isAppPaused && wasResumed) {
      _isAppInForeground = false;
      _notifyFocusLoss();
      _notifyForegroundLoss();
    }
  }

  @override
  Widget build(BuildContext context) => VisibilityDetector(
    key: _visibilityDetectorKey,
    onVisibilityChanged: (visibilityInfo) {
      final visibleFraction = visibilityInfo.visibleFraction;
      _notifyVisibilityStatusChange(visibleFraction);
    },
    child: widget.child,
  );

  /// Notifies changes in the widget's visibility.
  void _notifyVisibilityStatusChange(double newVisibleFraction) {
    if (!_isAppInForeground) {
      return;
    }

    final wasFullyVisible = _isWidgetVisible;
    final isFullyVisible = newVisibleFraction == 1;
    if (!wasFullyVisible && isFullyVisible) {
      _isWidgetVisible = true;
      _notifyFocusGain();
      _notifyVisibilityGain();
      _visibilityCounter++;
    }

    final isFullyInvisible = newVisibleFraction == 0;
    if (wasFullyVisible && isFullyInvisible) {
      _isWidgetVisible = false;
      _notifyFocusLoss();
      _notifyVisibilityLoss();
    }
  }

  void _notifyFocusGain() {
    widget.onFocusGained?.call();
    if (_visibilityCounter > 0) {
      widget.onFocusRegained?.call();
    }
  }

  void _notifyFocusLoss() {
    widget.onFocusLost?.call();
  }

  void _notifyVisibilityGain() {
    widget.onVisibilityGained?.call();
    if (_visibilityCounter > 0) {
      widget.onVisibilityRegained?.call();
    }
  }

  void _notifyVisibilityLoss() {
    widget.onVisibilityLost?.call();
  }

  void _notifyForegroundGain() {
    final onForegroundGained = widget.onForegroundGained;
    if (onForegroundGained != null) {
      onForegroundGained();
    }
  }

  void _notifyForegroundLoss() {
    final onForegroundLost = widget.onForegroundLost;
    if (onForegroundLost != null) {
      onForegroundLost();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
