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
        child: _SelectedTabBuilder(
          controller: tabController,
          builder: (context, selectedIndex) => CupertinoSlidingSegmentedControl<int>(
            groupValue: selectedIndex,
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
        child: _SelectedTabBuilder(
          controller: tabController,
          builder: (context, selectedIndex) => GlassSegmentedControl(
            height: kGlassAppBarBottomControlHeight,
            backgroundColor: Colors.transparent,
            segments: [for (final label in tabs) GlassSegment(label: label)],
            selectedIndex: selectedIndex,
            onSegmentSelected: tabController.animateTo,
            // Its glass thumb is no longer inside the capsule's layer.
            useOwnLayer: true,
          ),
        ),
      ),
    );
  }
}

/// Builds a segmented control with the tab selected by [controller], following a swipe of its
/// [TabBarView].
///
/// The controller's index only changes when the swipe settles, so a control showing it lags behind
/// the page. While the user swipes, the selected tab is the one closest to the page offset, like
/// the indicator of a [TabBar] follows the page. During [TabController.animateTo] (e.g. a tap on a
/// segment) the index is already the target tab, so it is selected right away.
///
/// Rebuilds only when the selected tab changes, not on every frame of the swipe.
class const _SelectedTabBuilder({
  required final TabController controller,
  required final Widget Function(BuildContext context, int selectedIndex) builder,
}) extends StatefulWidget {
  @override
  State<_SelectedTabBuilder> createState() => _SelectedTabBuilderState();
}

class _SelectedTabBuilderState() extends State<_SelectedTabBuilder> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = _computeSelectedIndex();
    _listen(widget.controller);
  }

  @override
  void didUpdateWidget(_SelectedTabBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _unlisten(oldWidget.controller);
      _listen(widget.controller);
      _selectedIndex = _computeSelectedIndex();
    }
  }

  @override
  void dispose() {
    _unlisten(widget.controller);
    super.dispose();
  }

  void _listen(TabController controller) {
    controller.addListener(_onChanged);
    controller.animation?.addListener(_onChanged);
  }

  void _unlisten(TabController controller) {
    controller.removeListener(_onChanged);
    controller.animation?.removeListener(_onChanged);
  }

  int _computeSelectedIndex() {
    final controller = widget.controller;
    final animation = controller.animation;
    if (controller.indexIsChanging || animation == null) return controller.index;
    return animation.value.round().clamp(0, controller.length - 1);
  }

  void _onChanged() {
    final selectedIndex = _computeSelectedIndex();
    if (selectedIndex != _selectedIndex) {
      setState(() => _selectedIndex = selectedIndex);
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _selectedIndex);
}
