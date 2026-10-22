import 'dart:io' show Platform;
import 'dart:math' as math;
import 'dart:ui' show ColorFilter, ImageFilter;

import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoColors, CupertinoDynamicColor, CupertinoIcons, CupertinoTheme;
import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter_riverpod/flutter_riverpod.dart' show ConsumerWidget, WidgetRef;
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/tab_navigation.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart'
    show NavigationSheetScope, showAdaptiveNavigationSheet;
import 'package:lichess_mobile/src/widgets/buttons.dart' show SemanticIconButton;
import 'package:lichess_mobile/src/widgets/platform_context_menu_button.dart'
    show
        ContextMenuIconButton,
        glassMenuItems,
        kDarkMenuGlassSettings,
        kGlassMenuWidth,
        kLightMenuGlassSettings;
import 'package:lichess_mobile/src/widgets/platform_search_bar.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart'
    show
        GlassAppBar,
        GlassBarItem,
        GlassBarItemBackground,
        GlassButton,
        GlassContainer,
        GlassPinnedBarChrome,
        GlassScaffold,
        GlassScrollEdgeEffect,
        LiquidGlassSettings,
        LiquidRoundedSuperellipse;
import 'package:material_ui/material_ui.dart';

/// Whether the iOS 26 liquid glass design is used: on iOS 26 and later.
///
/// Older iOS versions get the same layouts (large titles, scroll-aware bar tint, inset sheets...),
/// with plain controls and opaque surfaces instead of glass ones.
bool useLiquidGlass(BuildContext context) =>
    Theme.of(context).platform == TargetPlatform.iOS && _isLiquidGlassSupported;

/// Whether the device runs iOS 26 or later, unless turned off with
/// `--dart-define=NO_LIQUID_GLASS=true` (to check the older iOS design on an iOS 26 device).
///
/// Always true on other platforms, where the theme platform is iOS only in tests.
final bool _isLiquidGlassSupported =
    !const bool.fromEnvironment('NO_LIQUID_GLASS') && (!Platform.isIOS || _iosMajorVersion() >= 26);

/// Whether the [PlatformAppBar] buttons are pinned above the navigator, and morph into the next
/// route's buttons during a push or pop, like a UIKit navigation bar: on iOS 26 and later.
///
/// Each navigator is wrapped in a `GlassNavigationShell` (the root one in `app.dart`, the tab ones
/// in `tab_scaffold.dart`), which draws the pinned buttons. See [PlatformAppBar.actions].
bool usePinnedNavBar(BuildContext context) => useLiquidGlass(context);

/// Whether an icon button has a long press action, which a [GlassBarItem.icon] doesn't support.
bool _hasLongPress(Widget button) => switch (button) {
  IconButton(:final onLongPress) || SemanticIconButton(:final onLongPress) => onLongPress != null,
  _ => false,
};

/// A non-interactive item of a [PlatformAppBar], such as a status indicator, as its leading.
///
/// On iOS it has no glass capsule around it, since it is not a button. Elsewhere it is [child] as
/// is.
class const AppBarIndicator({required final Widget child, super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => child;
}

int _iosMajorVersion() {
  // For example "Version 18.2 (Build 22C150)".
  final match = RegExp(r'\d+').firstMatch(Platform.operatingSystemVersion);
  return match != null ? int.parse(match.group(0)!) : 26;
}

/// A simple widget that builds different things on different platforms.
class const PlatformWidget({
  super.key,
  required final WidgetBuilder androidBuilder,
  required final WidgetBuilder iosBuilder,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return iosBuilder(context);
    } else {
      return androidBuilder(context);
    }
  }
}

class const PlatformShareIcon({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: (_) => const Icon(Icons.share),
      iosBuilder: (_) => const Icon(Icons.ios_share),
    );
  }
}

/// A platform-aware circular loading indicator to be used in [AppBar.actions].
class const PlatformAppBarLoadingIndicator({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(right: 16),
      child: SizedBox(
        height: 24,
        width: 24,
        child: Center(child: CircularProgressIndicator.adaptive()),
      ),
    );
  }
}

/// The background of a bar over scrolling content on iOS: behind a [PlatformAppBar] with a title
/// while content is scrolled under it.
///
/// It is a translucent white in light mode and dark grey in dark mode, like the bars of the iOS
/// apps (the iOS default bar tint, a light grey, looks tinted over the content). With a background
/// image or color theme (transparent scaffold), it is the surface color with the same opacity, so
/// that the bar is not grey over the background.
Color cupertinoBarTint(BuildContext context, {double opacity = 0.8}) {
  if (_hasBackgroundTheme(context)) {
    return ColorScheme.of(context).surface.withValues(alpha: opacity);
  }
  return Theme.of(context).brightness == Brightness.light
      ? Colors.white.withValues(alpha: opacity)
      : const Color(0xFF1D1D1D).withValues(alpha: opacity);
}

/// Whether a background image or color theme is set: the scaffolds are transparent to show it.
bool _hasBackgroundTheme(BuildContext context) => Theme.of(context).scaffoldBackgroundColor.a == 0;

/// Height of the toolbar row of a [PlatformAppBar] on iOS, matching the iOS navigation bar.
const double _kGlassToolbarHeight = 44.0;

/// Height of the large title of a [PlatformAppBar] with [PlatformAppBar.largeTitle] on iOS, below
/// the toolbar, like the iOS navigation bar large title, with a gap above the title.
const double _kLargeTitleHeight = 52.0;

/// Strongest blur of the content scrolling under the status bar, at the top of the screen.
const double _kStatusBarBlurMaxSigma = 8.0;

/// Height of the tint of a [PlatformAppBar] below its buttons, when it has no bottom.
const double _kGlassBarTintBottomPadding = 8.0;

/// Space around a control (segmented control, chips) in the `bottom` of a [PlatformAppBar] on iOS:
/// a gap below the app bar buttons, and the body's side padding.
const EdgeInsets kGlassAppBarBottomPadding = EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0);

/// Height of a control (segmented control, chips) in the `bottom` of a [PlatformAppBar] on iOS.
const double kGlassAppBarBottomControlHeight = 36.0;

/// Glass settings tinted like the iOS tab bar, for glass controls over busy content (boards): opaque
/// enough that what is seen through the glass does not compete with the labels and icons.
///
/// In dark mode the tint is a theme surface color, so that the controls match the other surfaces
/// of the screen (search fields, cards) instead of a fixed grey.
LiquidGlassSettings tintedGlassSettings(BuildContext context) => LiquidGlassSettings(
  glassColor: Theme.of(context).brightness == Brightness.light
      ? const Color(0xBFFFFFFF)
      : ColorScheme.of(context).surfaceContainerHigh.withValues(alpha: 0.8),
);

/// The capsule background of an iOS control (segmented control, search field) that is liquid glass
/// in a bar floating over the content, and flat in the content, like the iOS controls there.
///
/// It is the same [child], glass or flat: the glass capsule behind it is hidden (its visibility
/// scales every glass effect) and the flat text field fill is shown instead. The capsule is a
/// background, not the control's parent: a glass container hides its child along with its glass.
/// Changes of [glass] are instant, like the iOS controls.
class const GlassControlBackground({
  super.key,

  /// Whether the background is liquid glass, or the flat text field fill. It is always flat before
  /// iOS 26 ([useLiquidGlass]).
  required final bool glass,

  /// The height of the control, which the capsule is rounded to.
  required final double height,

  /// The glass settings, or the default ones when null.
  final LiquidGlassSettings? settings,
  required final Widget child,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final borderRadius = height / 2;
    final glass = this.glass && useLiquidGlass(context);
    return SizedBox(
      height: height,
      // The capsule stays in the tree while flat, so that the child is never rebuilt (e.g. a
      // focused search field).
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: glass ? null : Theme.of(context).inputDecorationTheme.fillColor,
                borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              ),
            ),
          ),
          // A glass capsule like the app bar buttons, instead of the control's own background.
          Positioned.fill(
            child: GlassContainer(
              shape: LiquidRoundedSuperellipse(borderRadius: borderRadius),
              settings: glass
                  ? settings
                  : (settings ?? const LiquidGlassSettings()).copyWith(visibility: 0.0),
              // Outside of an app bar, there is no parent glass layer to share. In an app bar,
              // which is isolated, its glass gets its own layer anyway.
              useOwnLayer: true,
              child: const SizedBox.expand(),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

/// Whether the controls of the `bottom` of a [PlatformAppBar] with a large title are liquid glass:
/// while the large title is shown, the bottom is in the content, below it, and its controls are
/// flat; once it sticks below the app bar buttons, they are glass.
///
/// [PlatformTabBar] and [PlatformSearchBar] follow it, unless told otherwise.
class const AppBarBottomGlassScope({required final bool glass, required super.child})
    extends InheritedWidget {
  /// Whether the controls are glass, or null outside of the bottom of a large title app bar.
  static bool? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppBarBottomGlassScope>()?.glass;

  @override
  bool updateShouldNotify(AppBarBottomGlassScope oldWidget) => glass != oldWidget.glass;
}

/// Glass settings of the [PlatformAppBar] buttons in light mode: translucent white, a bit clearer
/// than the bottom bar buttons ([tintedGlassSettings]) yet standing out from the background, like
/// the iOS navigation bar buttons (the package's light glass is nearly clear).
///
/// The menus of the pinned bar buttons get the glass of the buttons (the package has no setting of
/// their own): the same blur and saturation as [kLightMenuGlassSettings], like an iOS menu.
const _kLightAppBarButtonSettings = LiquidGlassSettings(
  blur: 20,
  glassColor: Color(0xB3FFFFFF),
  saturation: 1.8,
);

/// [_kLightAppBarButtonSettings] for dark mode: the same tint, blur and saturation as
/// [kDarkMenuGlassSettings], for the menus of the pinned bar buttons.
const _kDarkAppBarButtonSettings = LiquidGlassSettings(
  blur: 20,
  glassColor: Color(0x14FFFFFF),
  saturation: 1.2,
);

/// The glass of the [PlatformAppBar] buttons, and of the glass controls of the app bar that are not
/// laid out inside it (the search field below a large title), so that they look the same.
///
/// With a background theme, or when [tinted] (`PlatformAppBar.tintedGlass`), it is
/// [tintedGlassSettings]: the barely tinted dark glass would show the image brightly. Otherwise,
/// the buttons are white in light mode and light grey in dark mode, like the iOS navigation bar
/// buttons.
LiquidGlassSettings appBarButtonGlassSettings(BuildContext context, {bool tinted = false}) =>
    tinted || _hasBackgroundTheme(context)
    ? tintedGlassSettings(context)
    : Theme.of(context).brightness == Brightness.light
    ? _kLightAppBarButtonSettings
    : _kDarkAppBarButtonSettings;

/// Height of the buttons of a [PlatformAppBar] with `compactButtons` on iOS.
const double _kGlassCompactButtonHeight = 36.0;

/// Gap below the buttons of a pinned [PlatformAppBar] with `compactButtons` and no `bottom`: its
/// buttons have the shell's full toolbar height (see [usePinnedNavBar]).
const double _kPinnedCompactButtonsGap = 6.0;

/// A wrapper around [Scaffold] that sets properties to handle app bar and bottom navigation bar
/// transparency on iOS.
///
/// On iOS the [Scaffold] is placed inside a [GlassScaffold], which draws the [appBar] as a liquid
/// glass navigation bar above the body. On the root screen of a tab the [appBar] is not sticky: it
/// scrolls away with the body, like the iOS 26 main tabs.
///
/// Limitations:
/// - It does not work with a [CustomScrollView] and [SliverAppBar] as the body.
class const PlatformScaffold({
  super.key,
  final Widget? body,
  final PlatformAppBar? appBar,
  final Widget? floatingActionButton,
  final List<Widget>? persistentFooterButtons,
  final Widget? drawer,
  final Widget? bottomSheet,
  final Widget? bottomNavigationBar,
  final bool? extendBody,

  /// Whether the body extends behind the glass [appBar] on iOS, so that it scrolls under it.
  ///
  /// Defaults to true. When false, the body is laid out below the [appBar], like in a [Scaffold]:
  /// for screens whose content does not scroll, like board screens.
  final bool extendBodyBehindAppBar = true,

  /// See [Scaffold.resizeToAvoidBottomInset].
  final bool? resizeToAvoidBottomInset,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Check if a parent Scaffold has extendBody set to true.
    // This is the case if this scaffold is built inside a root tab where the main scaffold holds
    // the bottom navigation bar.
    final hasExtendedBodyParentScaffold = MainTabScaffoldProperties.hasExtendedBody(context);
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    final scaffold = Scaffold(
      // On iOS the background is painted by the GlassScaffold, behind the glass app bar.
      backgroundColor: isIOS ? Colors.transparent : null,
      extendBody: extendBody ?? hasExtendedBodyParentScaffold,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: isIOS ? null : appBar,
      body: body,
      drawer: drawer,
      persistentFooterButtons: persistentFooterButtons,
      floatingActionButton: floatingActionButton,
      bottomSheet: bottomSheet,
      bottomNavigationBar:
          bottomNavigationBar ??
          (hasExtendedBodyParentScaffold
              ? Container(
                  color: Colors.transparent,
                  height: MediaQuery.paddingOf(context).bottom,
                  width: double.infinity,
                )
              : null),
    );

    if (!isIOS) return scaffold;

    final isTabRoot = hasExtendedBodyParentScaffold && (ModalRoute.of(context)?.isFirst ?? false);
    final stickyAppBar = appBar != null && !isTabRoot;
    // A sticky app bar with a title, over scrolling content, is tinted while content is scrolled
    // under it, like a UIKit navigation bar. A search field is glass, so it does not count as a
    // title. Before iOS 26, the buttons are not glass either: every sticky app bar is tinted.
    final title = appBar?.title;
    final hasTintedAppBar =
        stickyAppBar &&
        extendBodyBehindAppBar &&
        appBar!.scrolledUnderTint &&
        (!useLiquidGlass(context) ||
            (title != null && title is! SearchFieldHero && title is! PlatformSearchBar));
    final hasLargeTitle = hasTintedAppBar && title != null && appBar!.largeTitle;
    final largeTitleHeight = hasLargeTitle ? _kLargeTitleHeight : 0.0;
    final bottomHeight =
        appBar?.bottom?.preferredSize.height ??
        ((appBar?.compactButtons ?? false) && usePinnedNavBar(context)
            ? _kPinnedCompactButtonsGap
            : 0.0);
    // With a large title, the bottom of the app bar is below the large title, in the body.
    final appBarHeight = appBar != null
        ? _kGlassToolbarHeight + (hasLargeTitle ? 0.0 : bottomHeight)
        : 0.0;
    // GlassScaffold installs a CupertinoTheme that sets the icon color to its primary color: the
    // app icon theme is restored for the app bar and the body.
    final iconTheme = IconTheme.of(context);

    // The app bar is outside of the inner Scaffold: provide a Material for its text and actions.
    final glassScaffold = Material(
      type: MaterialType.transparency,
      child: GlassScaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // The background is a plain color, there is nothing worth sampling.
        enableBackgroundSampling: false,
        statusBarStyle: .auto,
        // The inner Scaffold already resizes for the keyboard.
        resizeToAvoidBottomInset: false,
        appBar: stickyAppBar
            ? PreferredSize(
                preferredSize: Size.fromHeight(appBarHeight),
                child: IconTheme(data: iconTheme, child: appBar!),
              )
            : null,
        // The status bar area is blurred below instead: the package fade also covers the app bar,
        // and is a fade to the background color, invisible in dark mode and with a background
        // theme.
        topEdgeFade: false,
        // GlassScaffold does not inset the body, so the app bar height is added to the top padding
        // like Scaffold.extendBodyBehindAppBar does.
        body: Builder(
          builder: (context) {
            final mediaQuery = MediaQuery.of(context);
            if (!extendBodyBehindAppBar && stickyAppBar) {
              return Padding(
                padding: EdgeInsets.only(top: mediaQuery.padding.top + appBarHeight),
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: IconTheme(data: iconTheme, child: scaffold),
                ),
              );
            }
            final appBarBottom = mediaQuery.padding.top + appBarHeight;
            final body = MediaQuery(
              data: mediaQuery.copyWith(
                padding: mediaQuery.padding.copyWith(
                  top: appBarBottom + largeTitleHeight + (hasLargeTitle ? bottomHeight : 0.0),
                ),
              ),
              child: IconTheme(
                data: iconTheme,
                child: appBar != null && !stickyAppBar
                    ? _ScrollAwayAppBar(
                        // The app bar insets itself with the top padding, without its own height.
                        appBar: MediaQuery(data: mediaQuery, child: appBar!),
                        child: scaffold,
                      )
                    : hasTintedAppBar
                    ? Stack(
                        children: [
                          _ScrollEdgeTint(
                            // Leaves a gap below the buttons, unless a bottom (e.g. tabs) is there,
                            // which a large title's bottom is once it sticks below the buttons.
                            height:
                                mediaQuery.padding.top +
                                _kGlassToolbarHeight +
                                (appBar!.bottom == null
                                    ? _kGlassBarTintBottomPadding
                                    : bottomHeight),
                            // A large title is not content: the bar is tinted once it is scrolled
                            // away.
                            scrolledUnderOffset: largeTitleHeight,
                            child: hasLargeTitle
                                ? Stack(
                                    children: [
                                      scaffold,
                                      _LargeTitle(top: appBarBottom, title: title),
                                    ],
                                  )
                                : scaffold,
                          ),
                          if (hasLargeTitle && appBar!.bottom != null)
                            _LargeTitleBottom(
                              top: appBarBottom + largeTitleHeight,
                              bottom: appBar!.bottom!,
                            ),
                        ],
                      )
                    : scaffold,
              ),
            );
            // Content scrolling under the status bar is blurred, like in iOS apps. A tinted app
            // bar has its own blur.
            return hasTintedAppBar || !extendBodyBehindAppBar
                ? body
                : GlassScrollEdgeEffect(
                    style: .blur,
                    maxSigma: _kStatusBarBlurMaxSigma,
                    topFadeHeight: mediaQuery.padding.top,
                    fadeBottom: false,
                    child: body,
                  );
          },
        ),
      ),
    );

    return hasLargeTitle ? _LargeTitleScrollScope(child: glassScaffold) : glassScaffold;
  }
}

/// The [bottom] of a [PlatformAppBar] with a large title, at [top], below the large title: it moves
/// up with the content until it sticks below the app bar buttons, once the large title is scrolled
/// away, like a UIKit navigation bar search field.
class const _LargeTitleBottom({required final double top, required final Widget bottom})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: 0,
      right: 0,
      child: ValueListenableBuilder(
        valueListenable: _LargeTitleScrollScope.maybeOf(context)!,
        // Not clamped below 0, so that it follows the content when it overscrolls.
        builder: (context, offset, child) => Transform.translate(
          offset: Offset(0, -math.min(offset, _kLargeTitleHeight)),
          // Its controls are flat in the content, and glass once it sticks to the app bar.
          child: AppBarBottomGlassScope(glass: offset >= _kLargeTitleHeight, child: child!),
        ),
        child: bottom,
      ),
    );
  }
}

/// Tracks the scroll offset of the main vertical scroll view of [child], for a [PlatformScaffold]
/// with a large title: the [_LargeTitle] scrolls with it, and the [PlatformAppBar] shows its title
/// once the large title is scrolled away.
class const _LargeTitleScrollScope({required final Widget child}) extends StatefulWidget {
  /// The scroll offset tracked by the closest [_LargeTitleScrollScope], if any.
  static ValueListenable<double>? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_LargeTitleScrollOffset>()?.offset;

  @override
  State<_LargeTitleScrollScope> createState() => _LargeTitleScrollScopeState();
}

class _LargeTitleScrollScopeState() extends State<_LargeTitleScrollScope> {
  final ValueNotifier<double> _offset = ValueNotifier(0);

  @override
  void dispose() {
    _offset.dispose();
    super.dispose();
  }

  bool _onScrollMetrics(int depth, ScrollMetrics metrics) {
    if (depth == 0 && metrics.axis == Axis.vertical) {
      _offset.value = metrics.pixels;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return _LargeTitleScrollOffset(
      offset: _offset,
      child: NotificationListener<ScrollMetricsNotification>(
        onNotification: (notification) =>
            _onScrollMetrics(notification.depth, notification.metrics),
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) =>
              _onScrollMetrics(notification.depth, notification.metrics),
          child: widget.child,
        ),
      ),
    );
  }
}

class const _LargeTitleScrollOffset({
  required final ValueNotifier<double> offset,
  required super.child,
}) extends InheritedWidget {
  @override
  bool updateShouldNotify(_LargeTitleScrollOffset oldWidget) => offset != oldWidget.offset;
}

/// The large title of a [PlatformAppBar] with [PlatformAppBar.largeTitle], below the app bar whose
/// bottom is at [top]: it moves with the content, which leaves room for it, as if it were part of
/// it. It is not clipped: it scrolls under the app bar buttons, until it is scrolled away and
/// collapses into the app bar title.
class const _LargeTitle({required final double top, required final Widget title})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final offset = _LargeTitleScrollScope.maybeOf(context)!;
    return Positioned(
      top: top,
      left: 0,
      right: 0,
      bottom: 0,
      child: IgnorePointer(
        child: ValueListenableBuilder(
          valueListenable: offset,
          // Not clamped below 0, so that the title follows the content when it overscrolls. Hidden
          // once collapsed into the app bar title, when the app bar tint would show it blurred.
          builder: (context, offset, child) => Opacity(
            opacity: offset >= _kLargeTitleHeight ? 0.0 : 1.0,
            child: Transform.translate(offset: Offset(0, -offset), child: child),
          ),
          child: Align(
            alignment: .topLeft,
            child: SizedBox(
              height: _kLargeTitleHeight,
              child: Padding(
                padding: Styles.horizontalBodyPadding.copyWith(bottom: 6.0),
                child: Align(
                  alignment: .bottomLeft,
                  child: Semantics(
                    header: true,
                    child: DefaultTextStyle.merge(
                      style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle
                          .copyWith(color: ColorScheme.of(context).onSurface),
                      maxLines: 1,
                      overflow: .ellipsis,
                      child: title,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Paints a [BlurredBarBackground] behind an app bar, over the top [height] of [child], while the
/// content of its vertical scroll view is scrolled under it.
class const _ScrollEdgeTint({
  required final double height,
  required final Widget child,

  /// How far the content scrolls before it is under the app bar.
  final double scrolledUnderOffset = 0.0,
}) extends StatefulWidget {
  @override
  State<_ScrollEdgeTint> createState() => _ScrollEdgeTintState();
}

class _ScrollEdgeTintState() extends State<_ScrollEdgeTint> {
  bool _isScrolledUnder = false;

  bool _onScrollMetrics(ScrollMetrics metrics) {
    if (metrics.axis != Axis.vertical) return false;
    // In a reversed scroll view (e.g. a chat), the content under the app bar is after the viewport.
    final isScrolledUnder = metrics.axisDirection == AxisDirection.down
        ? metrics.extentBefore > widget.scrolledUnderOffset
        : metrics.extentAfter > 0;
    if (isScrolledUnder != _isScrolledUnder) {
      setState(() => _isScrolledUnder = isScrolledUnder);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NotificationListener<ScrollMetricsNotification>(
          onNotification: (notification) => _onScrollMetrics(notification.metrics),
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) => _onScrollMetrics(notification.metrics),
            child: widget.child,
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: widget.height,
          child: IgnorePointer(
            child: AnimatedOpacity(
              opacity: _isScrolledUnder ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 150),
              child: const BlurredBarBackground(),
            ),
          ),
        ),
      ],
    );
  }
}

/// The background of an iOS bar over scrolling content: the bar tint ([cupertinoBarTint]) over a
/// blur of the content under it, like a UIKit bar, with a hairline on the edge facing the content.
///
/// Behind a [PlatformAppBar] while content is scrolled under it, and before iOS 26
/// ([useLiquidGlass]) behind the bottom bars, in place of their glass.
class const BlurredBarBackground({
  /// Whether the bar is at the bottom of the screen: the hairline is then on its top edge.
  final bool atBottom = false,
  final Widget? child,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // A hairline of one physical pixel, inside the box: a zero width border is centered on the
    // edge, and the clip would cut half of it.
    final hairline = BorderSide(
      color: CupertinoDynamicColor.resolve(CupertinoColors.separator, context),
      width: 1.0 / MediaQuery.devicePixelRatioOf(context),
    );
    final blur = BackdropFilter(
      filter: _barTintFilter(context),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: cupertinoBarTint(context, opacity: 0.4),
          border: atBottom ? Border(top: hairline) : Border(bottom: hairline),
        ),
        child: child,
      ),
    );
    // At the top of a navigation sheet, the blur gets the rounded corners of the sheet: the clip of
    // the sheet doesn't clip it, only the clip right around it does.
    final sheetCornerRadius = atBottom
        ? 0.0
        : NavigationSheetScope.maybeOf(context)?.topCornerRadius ?? 0.0;
    return sheetCornerRadius > 0
        ? ClipRSuperellipse(
            borderRadius: BorderRadius.vertical(top: Radius.circular(sheetCornerRadius)),
            child: blur,
          )
        : ClipRect(child: blur);
  }
}

/// The blur under the tint of a [BlurredBarBackground].
///
/// In light mode, the colors of the content are saturated, like a UIKit bar material, so that they
/// show through the white tint.
ImageFilter _barTintFilter(BuildContext context) {
  final blur = ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0);
  if (Theme.of(context).brightness != Brightness.light || _hasBackgroundTheme(context)) {
    return blur;
  }
  const s = 1.8;
  return ImageFilter.compose(
    outer: const ColorFilter.matrix([
      0.2126 + 0.7874 * s, 0.7152 - 0.7152 * s, 0.0722 - 0.0722 * s, 0, 0, //
      0.2126 - 0.2126 * s, 0.7152 + 0.2848 * s, 0.0722 - 0.0722 * s, 0, 0, //
      0.2126 - 0.2126 * s, 0.7152 - 0.7152 * s, 0.0722 + 0.9278 * s, 0, 0, //
      0, 0, 0, 1, 0,
    ]),
    inner: blur,
  );
}

/// Places [appBar] above [child], and moves it up as the main scroll view of [child] scrolls.
///
/// The [appBar] covers the top padding of the [MediaQuery], which must account for its height.
class const _ScrollAwayAppBar({required final Widget appBar, required final Widget child})
    extends StatefulWidget {
  @override
  State<_ScrollAwayAppBar> createState() => _ScrollAwayAppBarState();
}

class _ScrollAwayAppBarState() extends State<_ScrollAwayAppBar> {
  final ValueNotifier<double> _scrollOffset = ValueNotifier(0);

  @override
  void dispose() {
    _scrollOffset.dispose();
    super.dispose();
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0 && notification.metrics.axis == Axis.vertical) {
      _scrollOffset.value = notification.metrics.pixels;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.paddingOf(context).top;
    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: _onScrollNotification,
          child: widget.child,
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: height,
          child: ValueListenableBuilder(
            valueListenable: _scrollOffset,
            // Not clamped below 0, so that the app bar follows the content when it overscrolls.
            builder: (context, offset, child) =>
                Transform.translate(offset: Offset(0, -math.min(offset, height)), child: child),
            child: widget.appBar,
          ),
        ),
      ],
    );
  }
}

class const PlatformAppBar({
  super.key,
  final Widget? leading,

  /// Passed to [AppBar.leadingWidth] on Android, for a [leading] wider than an icon button. On iOS
  /// the leading capsule is as wide as its content.
  final double? leadingWidth,
  final Widget? title,
  final double? titleSpacing,
  final TextStyle? titleTextStyle,

  /// The buttons at the end of the bar: [IconButton]s, [SemanticIconButton]s and
  /// [ContextMenuIconButton]s created in the screen's build method, whose callbacks use the
  /// screen's context and ref.
  ///
  /// Use [actionsBuilder] instead when a button watches providers that the screen doesn't watch
  /// (only the app bar is rebuilt), or when a callback needs a ref that the screen doesn't have (a
  /// [StatelessWidget]). Don't wrap a button in a widget class of its own for that. A widget class
  /// that must be an action (e.g. a text button) takes its callbacks as parameters, created with
  /// the screen's context and ref, instead of navigating, presenting or reading providers with its
  /// own.
  ///
  /// Why: on iOS 26 and later, the buttons of a pushed screen (and its [leading]) are pinned above
  /// the navigator, and morph into the next screen's buttons (see [usePinnedNavBar]). The button
  /// types above become items of the shell, whose glyph morphs. Any other widget is a custom item,
  /// which only cross-fades: the shell builds it out of the screen's route, where its own context
  /// finds the wrong navigator, and disposes it while a sheet or a dialog is shown, so its own ref
  /// can't be used in a callback.
  final List<Widget>? actions,

  /// Builds the [actions], in place of [actions], with the context and the ref of the app bar,
  /// which belong to the screen: callbacks navigate, present and read providers with them.
  ///
  /// For buttons that watch providers the screen doesn't watch, or when the screen has no ref (see
  /// [actions]).
  final List<Widget> Function(BuildContext context, WidgetRef ref)? actionsBuilder,
  final PreferredSizeWidget? bottom,

  /// Whether the buttons are smaller than the toolbar on iOS, leaving a gap below them.
  ///
  /// For screens whose content starts right below the app bar, like the analysis board, which
  /// would otherwise touch the buttons.
  final bool compactButtons = false,
  final bool? centerTitle,
  final bool automaticallyImplyLeading = true,

  /// Whether the glass buttons are tinted on iOS ([tintedGlassSettings]), for a screen whose
  /// content scrolling under them is busy, like boards. They always are with a background theme.
  final bool tintedGlass = false,

  /// Whether the app bar is tinted on iOS while content is scrolled under it (see
  /// [PlatformScaffold]). False for a screen whose pinned header paints the bar background itself
  /// (e.g. pinned tabs before iOS 26).
  final bool scrolledUnderTint = true,

  /// Whether the [title] is an iOS large title, at the top of the body of a [PlatformScaffold], and
  /// shown in the app bar once it is scrolled away, like a UIKit navigation bar large title.
  ///
  /// iOS only, for a pushed screen whose body is a vertical scroll view. The body top padding of the
  /// [MediaQuery] leaves room for the large title. The [bottom] (e.g. a search field) is below the
  /// large title, and sticks below the app bar buttons once the large title is scrolled away.
  final bool largeTitle = false,
}) extends ConsumerWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => _PreferredAppBarSize(kToolbarHeight, bottom?.preferredSize.height);

  /// Whether the app bar has a close button that closes the navigation sheet it is in: on the first
  /// page of the sheet ([showAdaptiveNavigationSheet]), without a leading of its own.
  bool _impliesSheetClose(BuildContext context) =>
      automaticallyImplyLeading &&
      leading == null &&
      (ModalRoute.of(context)?.isFirst ?? false) &&
      NavigationSheetScope.maybeOf(context) != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    assert(this.actions == null || actionsBuilder == null);
    final actions = actionsBuilder?.call(context, ref) ?? this.actions;
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      // An iOS 26 liquid glass navigation bar, meant to be used by [PlatformScaffold]. Before iOS
      // 26, the same bar with plain buttons.
      final glass = useLiquidGlass(context);
      final colorScheme = ColorScheme.of(context);
      final buttonHeight = compactButtons ? _kGlassCompactButtonHeight : _kGlassToolbarHeight;
      final buttonSettings = appBarButtonGlassSettings(context, tinted: tintedGlass);
      // The app bar of the root screen of a tab has a large title, like the iOS 26 main tabs.
      final isTabRoot =
          MainTabScaffoldProperties.hasExtendedBody(context) &&
          (ModalRoute.of(context)?.isFirst ?? false);
      final defaultTitleStyle = isTabRoot
          ? CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle
          : AppBarTheme.of(context).titleTextStyle;
      final parentRoute = ModalRoute.of(context);
      final isFullscreenDialog = parentRoute is PageRoute && parentRoute.fullscreenDialog;
      final impliesLeading =
          automaticallyImplyLeading && (parentRoute?.impliesAppBarDismissal ?? false);
      final impliesSheetClose = _impliesSheetClose(context);
      final largeTitleOffset = largeTitle ? _LargeTitleScrollScope.maybeOf(context) : null;
      final inlineTitle = largeTitleOffset != null && title != null
          ? ValueListenableBuilder(
              valueListenable: largeTitleOffset,
              builder: (context, offset, child) => AnimatedOpacity(
                opacity: offset >= _kLargeTitleHeight ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 150),
                child: child,
              ),
              child: title,
            )
          : title;
      final appBarTitle = inlineTitle != null
          ? IconTheme.merge(
              // Like the Material AppBar, so that icons in the title are not given the primary
              // color.
              data: IconThemeData(color: colorScheme.onSurface),
              child: DefaultTextStyle.merge(
                style: TextStyle(color: colorScheme.onSurface)
                    .merge(titleTextStyle ?? defaultTitleStyle),
                // GlassAppBar leaves no gap between a centered title and the buttons around it,
                // unlike a leading aligned one: the same gap is added here.
                child: centerTitle ?? true
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: inlineTitle,
                      )
                    : inlineTitle,
              ),
            )
          : null;

      // The buttons are pinned above the navigator by its GlassNavigationShell, which morphs them
      // into the next route's buttons (see [usePinnedNavBar]). Not for a tab root, whose header
      // scrolls away. Compact buttons get the shell's size, with a gap below them instead.
      if (usePinnedNavBar(context) && !isTabRoot) {
        final foregroundColor = colorScheme.onSurface;
        // The shell builds the items in its own context: they get the themes of the screen and
        // the icon color of the bar.
        Widget captured(Widget child) => InheritedTheme.captureAll(
          context,
          IconTheme.merge(
            data: IconThemeData(color: foregroundColor),
            child: child,
          ),
        );
        // The glyph of an icon or menu item, sized by the shell (no captured icon theme).
        Widget glyph(Widget icon, Color? color) => IconTheme.merge(
          data: IconThemeData(color: color ?? foregroundColor),
          child: icon,
        );
        // Icon buttons and context menu buttons become the shell's own items, whose glyphs morph
        // and whose capsule morphs into the menu. Anything else is a custom item, which
        // cross-fades.
        //
        // Each item has an id, its slot counted from the edge the shell matches items from between
        // routes (for the actions, the end of the list, or its start in RTL): it matches them as
        // without an id, and an item built again keeps its identity.
        GlassBarItem barItem(Widget action, Object id) => switch (action) {
          IconButton(:final icon, :final onPressed, :final String? tooltip, :final color) ||
          SemanticIconButton(
            :final icon,
            :final onPressed,
            semanticsLabel: final String? tooltip,
            :final color,
          ) when !_hasLongPress(action) => GlassBarItem.icon(
            id: id,
            icon: glyph(icon, color),
            onTap: onPressed ?? () {},
            enabled: onPressed != null,
            label: tooltip,
          ),
          ContextMenuIconButton(:final icon, :final color, :final semanticsLabel, :final actions) =>
            GlassBarItem.menu(
              id: id,
              icon: glyph(icon, color),
              menuItems: glassMenuItems(context, actions),
              menuWidth: kGlassMenuWidth,
              label: semanticsLabel,
            ),
          AppBarIndicator() => GlassBarItem.custom(
            id: id,
            background: GlassBarItemBackground.none,
            child: captured(Center(child: action)),
          ),
          _ => GlassBarItem.custom(
            id: id,
            child: captured(
              IconButtonTheme(
                data: IconButtonThemeData(
                  style: IconButton.styleFrom(foregroundColor: foregroundColor),
                ),
                // Centered in the capsule, like the other items, whatever its height (e.g. text).
                child: Center(child: action),
              ),
            ),
          ),
        };
        // A back button with an action of its own is the shell's back button.
        final backButtonLeading = switch (leading) {
          final BackButton button when parentRoute?.impliesAppBarDismissal ?? false => button,
          _ => null,
        };
        return GlassPinnedBarChrome(
          leading: [
            if (leading != null && backButtonLeading == null)
              barItem(leading!, const ('leading', 0))
            else if (impliesLeading && isFullscreenDialog)
              GlassBarItem.icon(
                id: const ('leading', 0),
                icon: const Icon(Icons.close_rounded),
                label: MaterialLocalizations.of(context).closeButtonTooltip,
                onTap: () => Navigator.maybePop(context),
              )
            else if (impliesSheetClose)
              GlassBarItem.icon(
                id: const ('leading', 0),
                icon: const Icon(Icons.close_rounded),
                label: MaterialLocalizations.of(context).closeButtonTooltip,
                onTap: () => NavigationSheetScope.close(context),
              ),
          ],
          actions: [
            for (final (index, action) in (actions ?? const <Widget>[]).indexed)
              barItem(action, (
                'action',
                Directionality.of(context) == TextDirection.ltr
                    ? actions!.length - 1 - index
                    : index,
              )),
          ],
          backButton:
              backButtonLeading != null || (automaticallyImplyLeading && !isFullscreenDialog),
          onBack: backButtonLeading?.onPressed,
          buttonSettings: buttonSettings,
          horizontalInset: Styles.horizontalBodyPadding.left,
          builder: (context, chrome) => GlassAppBar(
            title: appBarTitle,
            centerTitle: centerTitle ?? true,
            leading: chrome.leading != null
                ? Row(mainAxisSize: .min, children: [chrome.leading!])
                : null,
            actions: chrome.actions.isNotEmpty ? chrome.actions : null,
            bottom: largeTitleOffset != null
                ? null
                : bottom ??
                      (compactButtons
                          ? const PreferredSize(
                              preferredSize: Size.fromHeight(_kPinnedCompactButtonsGap),
                              child: SizedBox.shrink(),
                            )
                          : null),
            buttonSettings: buttonSettings,
            toolbarHeight: _kGlassToolbarHeight,
            padding: Styles.horizontalBodyPadding,
          ),
        );
      }

      // A tab root on iOS 26, which has no implied leading (it is the first route), or any screen
      // before iOS 26. The implied back button has the pinned one's icon.
      return GlassAppBar(
        title: appBarTitle,
        centerTitle: centerTitle ?? true,
        leading: leading is AppBarIndicator
            // Only as wide as its content: GlassAppBar gives the leading slot the full bar width.
            ? Row(mainAxisSize: .min, children: [leading!])
            : leading != null
            ? _GlassBarCapsule(
                height: buttonHeight,
                glass: glass,
                settings: buttonSettings,
                children: [leading!],
              )
            : impliesLeading
            ? IconButton(
                icon: Icon(
                  isFullscreenDialog ? Icons.close_rounded : CupertinoIcons.back,
                  color: colorScheme.onSurface,
                ),
                tooltip: isFullscreenDialog
                    ? MaterialLocalizations.of(context).closeButtonTooltip
                    : MaterialLocalizations.of(context).backButtonTooltip,
                onPressed: () => Navigator.maybePop(context),
              )
            : impliesSheetClose
            ? IconButton(
                icon: Icon(Icons.close_rounded, color: colorScheme.onSurface),
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                onPressed: () => NavigationSheetScope.close(context),
              )
            : null,
        actions: actions != null && actions.isNotEmpty
            ? [
                _GlassBarCapsule(
                  height: buttonHeight,
                  glass: glass,
                  settings: buttonSettings,
                  children: actions,
                ),
              ]
            : null,
        // With a large title, the bottom is laid out by [PlatformScaffold], below the large title.
        bottom: largeTitleOffset != null ? null : bottom,
        // For the implied back button, the capsules are given the settings themselves.
        buttonSettings: glass ? buttonSettings : null,
        toolbarHeight: _kGlassToolbarHeight,
        // Aligned with the body content.
        padding: Styles.horizontalBodyPadding,
      );
    }

    return AppBar(
      titleSpacing: titleSpacing,
      title: title,
      titleTextStyle: titleTextStyle,
      leading:
          leading ??
          (_impliesSheetClose(context)
              ? IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  onPressed: () => NavigationSheetScope.close(context),
                )
              : null),
      leadingWidth: leadingWidth,
      actions: actions,
      bottom: bottom,
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      animateColor: true,
    );
  }
}

const double _kGlassFloatingButtonHeight = 48.0;

/// An extended floating action button, meant to be the [PlatformScaffold.floatingActionButton].
///
/// On iOS 26 and later it is a liquid glass capsule, otherwise a [FloatingActionButton.extended].
class const PlatformFloatingActionButton({
  super.key,
  required final String label,
  required final VoidCallback onPressed,
  final Widget? icon,
  final String? tooltip,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (useLiquidGlass(context)) {
      final colorScheme = ColorScheme.of(context);
      final fabTheme = FloatingActionButtonTheme.of(context);
      final foregroundColor = fabTheme.foregroundColor ?? colorScheme.onPrimaryContainer;
      return GlassButton.custom(
        onTap: onPressed,
        label: label,
        // Tinted to stand out over the content, like an iOS 26 prominent button, translucent enough
        // to let the content show through. The clear body mode keeps the exact color, with the
        // glass rim and specular highlights.
        settings: LiquidGlassSettings(
          glassColor: (fabTheme.backgroundColor ?? colorScheme.primaryContainer).withValues(
            alpha: 0.8,
          ),
          bodyMode: .clear,
        ),
        height: _kGlassFloatingButtonHeight,
        shape: const LiquidRoundedSuperellipse(borderRadius: _kGlassFloatingButtonHeight / 2),
        // Floats alone over the content, there is no parent glass layer to share.
        useOwnLayer: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: IconTheme.merge(
            data: IconThemeData(color: foregroundColor),
            child: Row(
              mainAxisSize: .min,
              spacing: 8.0,
              children: [
                ?icon,
                Text(
                  label,
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return FloatingActionButton.extended(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: icon,
      label: Text(label),
    );
  }
}

/// A liquid glass capsule grouping navigation bar items, like on iOS 26. Without [glass] (before
/// iOS 26), the same items without the capsule.
class const _GlassBarCapsule({
  required final double height,
  required final bool glass,
  required final LiquidGlassSettings? settings,
  required final List<Widget> children,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final foregroundColor = ColorScheme.of(context).onSurface;
    final items = IconTheme.merge(
      data: IconThemeData(color: foregroundColor),
      child: IconButtonTheme(
        data: IconButtonThemeData(style: IconButton.styleFrom(foregroundColor: foregroundColor)),
        child: Row(mainAxisSize: MainAxisSize.min, children: children),
      ),
    );
    if (!glass) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [SizedBox(height: height, child: items)],
      );
    }
    // GlassAppBar gives the leading slot the full bar width, which an aligned GlassContainer would
    // fill: the Row makes the capsule only as wide as its content.
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: height),
          child: GlassContainer(
            height: height,
            shape: LiquidRoundedSuperellipse(borderRadius: height / 2),
            settings: settings,
            // The app bar is isolated, so its glass gets its own layer anyway: this only states it,
            // for the package, which otherwise warns that per-widget settings are ignored.
            useOwnLayer: true,
            alignment: Alignment.center,
            child: items,
          ),
        ),
      ],
    );
  }
}

class const _PreferredAppBarSize(final double? toolbarHeight, final double? bottomHeight)
    extends Size {
  this : super.fromHeight((toolbarHeight ?? kToolbarHeight) + (bottomHeight ?? 0));
}
