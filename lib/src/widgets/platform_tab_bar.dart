import 'package:flutter/foundation.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart'
    show
        GlassContainer,
        GlassSegment,
        GlassSegmentedControl,
        LiquidGlassSettings,
        LiquidRoundedSuperellipse;
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

  /// Whether the iOS segmented control is liquid glass, as a control of a bar floating over the
  /// content. A segmented control in the content (e.g. a header that is not pinned yet) is flat,
  /// like the iOS controls in content: the same control without its glass, on the text field fill.
  /// Changes of this value are animated.
  final bool glass = true,
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
    final glassSettings = tintedGlass ? tintedGlassSettings(context) : null;
    // A flat control has the fill of the text fields, like the search field often next to it.
    final flatFill = Theme.of(context).inputDecorationTheme.fillColor ?? Colors.transparent;
    return Padding(
      padding: kGlassAppBarBottomPadding,
      // The same control, glass or flat: the glass capsule behind it fades out (its visibility
      // scales every glass effect) as the flat fill fades in. The capsule is a background, not the
      // control's parent: a glass container hides its child along with its glass.
      child: SizedBox(
        height: kGlassAppBarBottomControlHeight,
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: glass ? 1.0 : 0.0),
          duration: const Duration(milliseconds: 200),
          builder: (context, visibility, child) => Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: flatFill.withValues(alpha: flatFill.a * (1.0 - visibility)),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(kGlassAppBarBottomControlHeight / 2),
                    ),
                  ),
                ),
              ),
              // A glass capsule like the app bar buttons, instead of the control's own flat track.
              Positioned.fill(
                child: GlassContainer(
                  shape: const LiquidRoundedSuperellipse(
                    borderRadius: kGlassAppBarBottomControlHeight / 2,
                  ),
                  settings: visibility == 1.0
                      ? glassSettings
                      : (glassSettings ?? const LiquidGlassSettings()).copyWith(
                          visibility: visibility,
                        ),
                  // Outside of an app bar, there is no parent glass layer to share. In an app bar,
                  // which is isolated, its glass gets its own layer anyway.
                  useOwnLayer: true,
                  child: const SizedBox.expand(),
                ),
              ),
              child!,
            ],
          ),
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
      ),
    );
  }
}
