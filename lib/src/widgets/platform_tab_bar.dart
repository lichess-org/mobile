import 'package:flutter/foundation.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart'
    show GlassContainer, GlassSegment, GlassSegmentedControl, LiquidRoundedSuperellipse;
import 'package:material_ui/material_ui.dart';

/// Text tabs for the bottom of an app bar, or for a header pinned over scrolling content.
///
/// On iOS, 2 or 3 tabs are a liquid glass segmented control, like a UIKit navigation bar: more
/// labels would be cramped in an app bar. Outside of an app bar ([inAppBar] false), any number of
/// tabs is a segmented control on iOS. Otherwise, and on Android, it is a Material [TabBar].
///
/// The selected tab is driven by [controller], or the [DefaultTabController] when it is null, like
/// [TabBar].
class const PlatformTabBar({
  super.key,

  /// The label of each tab.
  required final List<String> tabs,
  final TabController? controller,

  /// Whether the tabs are the bottom of an app bar, in its glass layer.
  final bool inAppBar = true,

  /// Whether the glass segmented control is tinted on iOS ([tintedGlassSettings]), for busy content
  /// scrolling under it, like boards.
  final bool tintedGlass = false,
}) extends StatelessWidget implements PreferredSizeWidget {
  // The app's theme platform is the default target platform.
  bool get _isSegmentedControl =>
      defaultTargetPlatform == TargetPlatform.iOS && (tabs.length <= 3 || !inAppBar);

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
        settings: tintedGlass ? tintedGlassSettings(context) : null,
        // Outside of an app bar, there is no parent glass layer to share. In an app bar, which is
        // isolated, its glass gets its own layer anyway.
        useOwnLayer: true,
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
