import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Overscroll distance (logical pixels) at which the haptic fires — chosen to
// sit just below the RefreshIndicator's default arm/snap point so the haptic
// lands while the finger is still down, matching native iOS UIRefreshControl.
const double _kRefreshHapticThreshold = 120.0;

/// A wrapper widget over RefreshIndicator to provide haptic feedback on iOS.
class HapticRefreshIndicator extends StatefulWidget {
  const HapticRefreshIndicator({
    super.key,
    required this.child,
    this.edgeOffset = 0.0,
    required this.onRefresh,
  });

  final Widget child;
  final double edgeOffset;
  final RefreshCallback onRefresh;

  @override
  State<HapticRefreshIndicator> createState() => _HapticRefreshIndicatorState();
}

class _HapticRefreshIndicatorState extends State<HapticRefreshIndicator> {
  bool _hasFiredHaptic = false;

  bool _handleScrollNotification(ScrollNotification notification) {
    if (defaultTargetPlatform != TargetPlatform.iOS) return false;

    if (notification is ScrollEndNotification) {
      _hasFiredHaptic = false;
    } else if (notification is ScrollUpdateNotification &&
        !_hasFiredHaptic &&
        notification.metrics.pixels < -_kRefreshHapticThreshold) {
      _hasFiredHaptic = true;
      HapticFeedback.mediumImpact();
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: RefreshIndicator.adaptive(
        edgeOffset: widget.edgeOffset,
        onRefresh: widget.onRefresh,
        child: widget.child,
      ),
    );
  }
}
