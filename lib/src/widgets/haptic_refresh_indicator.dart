import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

/// A wrapper widget over RefreshIndicator to provide haptic feedback on iOS
class const HapticRefreshIndicator({
  super.key,
  required final Widget child,
  final double edgeOffset = 0.0,
  required final RefreshCallback onRefresh,
}) extends StatelessWidget {
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
