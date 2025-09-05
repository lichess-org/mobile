import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HapticRefreshIndicator extends StatelessWidget {
  final Key? refreshIndicatorKey;
  final Widget child;
  final double edgeOffset;
  final RefreshCallback onRefresh;

  const HapticRefreshIndicator({
    this.refreshIndicatorKey,
    required this.child,
    this.edgeOffset = 0.0,
    required this.onRefresh,
  });

  Future<void> _onRefreshWithHaptics() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      HapticFeedback.lightImpact();
    }

    await onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      key: refreshIndicatorKey,
      edgeOffset: edgeOffset,
      onRefresh: _onRefreshWithHaptics,
      child: child,
    );
  }
}
