import 'dart:math' as math;
import 'dart:ui' show ColorFilter, ImageFilter;

import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoColors, CupertinoDynamicColor, CupertinoTheme;
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/tab_navigation.dart';
import 'package:lichess_mobile/src/widgets/platform_search_bar.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart'
    show
        GlassAppBar,
        GlassButton,
        GlassContainer,
        GlassIconButton,
        GlassScaffold,
        GlassScrollEdgeEffect,
        LiquidGlassSettings,
        LiquidRoundedSuperellipse;
import 'package:material_ui/material_ui.dart';

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
LiquidGlassSettings tintedGlassSettings(BuildContext context) => LiquidGlassSettings(
  glassColor: Theme.of(context).brightness == Brightness.light
      ? const Color(0xBFFFFFFF)
      : const Color(0xCC2C2C2E),
);

/// Glass settings of the [PlatformAppBar] buttons in light mode: translucent white, like the iOS
/// navigation bar buttons (the package's light glass is nearly clear).
const _kLightAppBarButtonSettings = LiquidGlassSettings(glassColor: Color(0x80FFFFFF));

/// Height of the buttons of a [PlatformAppBar] with `compactButtons` on iOS.
const double _kGlassCompactButtonHeight = 36.0;

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

    final appBarHeight = appBar != null
        ? _kGlassToolbarHeight + (appBar!.bottom?.preferredSize.height ?? 0)
        : 0.0;
    final isTabRoot = hasExtendedBodyParentScaffold && (ModalRoute.of(context)?.isFirst ?? false);
    final stickyAppBar = appBar != null && !isTabRoot;
    // A sticky app bar with a title, over scrolling content, is tinted while content is scrolled
    // under it, like a UIKit navigation bar. A search field is glass, so it does not count as a
    // title.
    final title = appBar?.title;
    final hasTintedAppBar =
        stickyAppBar &&
        extendBodyBehindAppBar &&
        title != null &&
        title is! SearchFieldHero &&
        title is! PlatformSearchBar;
    // GlassScaffold installs a CupertinoTheme that sets the icon color to its primary color: the
    // app icon theme is restored for the app bar and the body.
    final iconTheme = IconTheme.of(context);

    // The app bar is outside of the inner Scaffold: provide a Material for its text and actions.
    return Material(
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
            final body = MediaQuery(
              data: mediaQuery.copyWith(
                padding: mediaQuery.padding.copyWith(top: mediaQuery.padding.top + appBarHeight),
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
                    ? _ScrollEdgeTint(
                        // Leaves a gap below the buttons, unless a bottom (e.g. tabs) is there.
                        height:
                            mediaQuery.padding.top +
                            appBarHeight +
                            (appBar!.bottom == null ? _kGlassBarTintBottomPadding : 0.0),
                        child: scaffold,
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
  }
}

/// Paints the iOS bar tint ([cupertinoBarTint]) over a blur, and a hairline behind a glass app bar, over the top
/// [height] of [child], while the content of its vertical scroll view is scrolled under it.
class const _ScrollEdgeTint({required final double height, required final Widget child})
    extends StatefulWidget {
  @override
  State<_ScrollEdgeTint> createState() => _ScrollEdgeTintState();
}

class _ScrollEdgeTintState() extends State<_ScrollEdgeTint> {
  bool _isScrolledUnder = false;

  bool _onScrollMetrics(ScrollMetrics metrics) {
    if (metrics.axis != Axis.vertical) return false;
    // In a reversed scroll view (e.g. a chat), the content under the app bar is after the viewport.
    final isScrolledUnder = metrics.axisDirection == AxisDirection.down
        ? metrics.extentBefore > 0
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
              // The content under the translucent tint is blurred, like a UIKit navigation bar.
              child: ClipRect(
                child: BackdropFilter(
                  filter: _barTintFilter(context),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: cupertinoBarTint(context, opacity: 0.4),
                      // A hairline of one physical pixel, inside the box: a zero width border is
                      // centered on the edge, and the clip would cut half of it.
                      border: Border(
                        bottom: BorderSide(
                          color: CupertinoDynamicColor.resolve(CupertinoColors.separator, context),
                          width: 1.0 / MediaQuery.devicePixelRatioOf(context),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// The blur under the scroll tint of a [PlatformAppBar].
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
  final List<Widget>? actions,
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
}) extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => _PreferredAppBarSize(kToolbarHeight, bottom?.preferredSize.height);

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      // An iOS 26 liquid glass navigation bar, meant to be used by [PlatformScaffold].
      final colorScheme = ColorScheme.of(context);
      final buttonHeight = compactButtons ? _kGlassCompactButtonHeight : _kGlassToolbarHeight;
      // With a background theme, the barely tinted dark glass would show the image brightly. In
      // light mode, the buttons are white like the iOS navigation bar buttons.
      final buttonSettings = tintedGlass || _hasBackgroundTheme(context)
          ? tintedGlassSettings(context)
          : Theme.of(context).brightness == Brightness.light
          ? _kLightAppBarButtonSettings
          : null;
      // The app bar of the root screen of a tab has a large title, like the iOS 26 main tabs.
      final isTabRoot =
          MainTabScaffoldProperties.hasExtendedBody(context) &&
          (ModalRoute.of(context)?.isFirst ?? false);
      final defaultTitleStyle = isTabRoot
          ? CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle
          : AppBarTheme.of(context).titleTextStyle;
      final parentRoute = ModalRoute.of(context);
      final impliedLeading =
          automaticallyImplyLeading && (parentRoute?.impliesAppBarDismissal ?? false)
          ? GlassIconButton(
              size: buttonHeight,
              icon: Icon(
                parentRoute is PageRoute && parentRoute.fullscreenDialog
                    ? Icons.close_rounded
                    : Icons.arrow_back_ios_new_rounded,
                color: colorScheme.onSurface,
              ),
              semanticLabel: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: () => Navigator.maybePop(context),
            )
          : null;

      return GlassAppBar(
        title: title != null
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
                      ? Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0), child: title)
                      : title!,
                ),
              )
            : null,
        centerTitle: centerTitle ?? true,
        leading: leading != null
            ? _GlassBarCapsule(height: buttonHeight, settings: buttonSettings, children: [leading!])
            : impliedLeading,
        actions: actions != null && actions!.isNotEmpty
            ? [_GlassBarCapsule(height: buttonHeight, settings: buttonSettings, children: actions!)]
            : null,
        bottom: bottom,
        // For the implied back button, the capsules are given the settings themselves.
        buttonSettings: buttonSettings,
        toolbarHeight: _kGlassToolbarHeight,
        // Aligned with the body content.
        padding: Styles.horizontalBodyPadding,
      );
    }

    return AppBar(
      titleSpacing: titleSpacing,
      title: title,
      titleTextStyle: titleTextStyle,
      leading: leading,
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
/// On iOS it is a liquid glass capsule, otherwise a [FloatingActionButton.extended].
class const PlatformFloatingActionButton({
  super.key,
  required final String label,
  required final VoidCallback onPressed,
  final Widget? icon,
  final String? tooltip,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
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

/// A liquid glass capsule grouping navigation bar items, like on iOS 26.
class const _GlassBarCapsule({
  required final double height,
  required final LiquidGlassSettings? settings,
  required final List<Widget> children,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final foregroundColor = ColorScheme.of(context).onSurface;
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
            child: IconTheme.merge(
              data: IconThemeData(color: foregroundColor),
              child: IconButtonTheme(
                data: IconButtonThemeData(
                  style: IconButton.styleFrom(foregroundColor: foregroundColor),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: children),
              ),
            ),
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
