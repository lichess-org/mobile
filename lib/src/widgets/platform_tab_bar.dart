import 'package:flutter/foundation.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart'
    show GlassContainer, GlassSegment, GlassSegmentedControl, LiquidRoundedSuperellipse;
import 'package:material_ui/material_ui.dart';

/// Text tabs for the bottom of an app bar.
///
/// On iOS, 2 tabs are a liquid glass segmented control, like a UIKit navigation bar. Otherwise, and
/// on Android, it is a Material [TabBar].
///
/// The selected tab is driven by [controller], or the [DefaultTabController] when it is null, like
/// [TabBar].
class const PlatformTabBar({
  super.key,

  /// The label of each tab.
  required final List<String> tabs,
  final TabController? controller,
}) extends StatelessWidget implements PreferredSizeWidget {
  // The app's theme platform is the default target platform.
  bool get _isSegmentedControl => defaultTargetPlatform == TargetPlatform.iOS && tabs.length == 2;

  @override
  Size get preferredSize => Size.fromHeight(
    _isSegmentedControl
        ? kGlassAppBarBottomControlHeight + kGlassAppBarBottomPadding.vertical
        : kTextTabBarHeight,
  );

  @override
  Widget build(BuildContext context) {
    if (!_isSegmentedControl) {
      return TabBar(
        controller: controller,
        tabs: [for (final label in tabs) Tab(text: label)],
      );
    }

    final tabController = controller ?? DefaultTabController.of(context);
    return Padding(
      padding: kGlassAppBarBottomPadding,
      // A glass capsule like the app bar buttons, in the app bar's glass layer, instead of the
      // control's own flat track.
      child: GlassContainer(
        height: kGlassAppBarBottomControlHeight,
        shape: const LiquidRoundedSuperellipse(borderRadius: kGlassAppBarBottomControlHeight / 2),
        child: ListenableBuilder(
          listenable: tabController,
          builder: (context, _) => GlassSegmentedControl(
            height: kGlassAppBarBottomControlHeight,
            backgroundColor: Colors.transparent,
            segments: [for (final label in tabs) GlassSegment(label: label)],
            selectedIndex: tabController.index,
            onSegmentSelected: tabController.animateTo,
          ),
        ),
      ),
    );
  }
}
