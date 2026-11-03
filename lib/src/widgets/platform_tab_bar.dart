import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoSlidingSegmentedControl;
import 'package:flutter/foundation.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart'
    show GlassSegment, GlassSegmentedControl;
import 'package:material_ui/material_ui.dart';

/// Text tabs for the bottom of an app bar, or for a header pinned over scrolling content.
///
/// On iOS, 2 or 3 tabs are a liquid glass segmented control (a plain one before iOS 26), like a UIKit
/// navigation bar: more labels would be cramped in an app bar. Outside of an app bar ([inAppBar] false), any number of
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

  /// Whether the iOS segmented control is liquid glass, as a control of a bar floating over the
  /// content. A segmented control in the content (e.g. in a header that scrolls away) is flat,
  /// like the iOS controls in content: the same control without its glass, on the text field fill
  /// ([GlassControlBackground]).
  ///
  /// Defaults to the [AppBarBottomGlassScope], and to glass outside of it.
  final bool? glass,
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
    final isGlass = glass ?? AppBarBottomGlassScope.maybeOf(context) ?? true;
    if (!useLiquidGlass(context)) {
      final control = SizedBox(
        height: kGlassAppBarBottomControlHeight,
        width: double.infinity,
        child: ListenableBuilder(
          listenable: tabController,
          builder: (context, _) => CupertinoSlidingSegmentedControl<int>(
            groupValue: tabController.index,
            children: {
              for (final (index, label) in tabs.indexed)
                index: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
            },
            onValueChanged: (index) {
              if (index != null) tabController.animateTo(index);
            },
          ),
        ),
      );
      return Padding(padding: kGlassAppBarBottomPadding, child: control);
    }

    return Padding(
      padding: kGlassAppBarBottomPadding,
      child: GlassControlBackground(
        glass: isGlass,
        height: kGlassAppBarBottomControlHeight,
        child: ListenableBuilder(
          listenable: tabController,
          builder: (context, _) => GlassSegmentedControl(
            height: kGlassAppBarBottomControlHeight,
            backgroundColor: Colors.transparent,
            segments: [for (final label in tabs) GlassSegment(label: label)],
            selectedIndex: tabController.index,
            onSegmentSelected: tabController.animateTo,
            // Its glass thumb is no longer inside the capsule's layer.
            useOwnLayer: true,
          ),
        ),
      ),
    );
  }
}
