import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A wrapper widget over RefreshIndicator to provide haptic feedback on iOS
class HapticRefreshIndicator extends StatelessWidget {
  final Widget child;
  final double edgeOffset;
  final RefreshCallback onRefresh;

  const HapticRefreshIndicator({
    super.key,
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
      edgeOffset: edgeOffset,
      onRefresh: _onRefreshWithHaptics,
      child: child,
    );
  }
}
