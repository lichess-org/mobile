import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

/// A wrapper widget over RefreshIndicator to provide haptic feedback on iOS.
///
/// On iOS the indicator appears below the glass app bar: the body extends behind it, and its top
/// padding, which the scroll view below applies too, includes the bar height.
class const HapticRefreshIndicator({
  super.key,
  required final Widget child,
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
      edgeOffset: Theme.of(context).platform == TargetPlatform.iOS
          ? MediaQuery.paddingOf(context).top
          : 0.0,
      onRefresh: _onRefreshWithHaptics,
      child: child,
    );
  }
}
