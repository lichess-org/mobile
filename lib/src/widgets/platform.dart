import 'dart:math' as math;

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
/// while content is scrolled under it, and a [BottomBar].
///
/// It is the iOS default bar tint, or with a background image or color theme (transparent
/// scaffold), the surface color with the same opacity, so that the bar is not grey over the
/// background.
Color cupertinoBarTint(BuildContext context) {
  // A material based Cupertino theme does not resolve the default dynamic color.
  final barTint = CupertinoDynamicColor.resolve(
    CupertinoTheme.of(context).barBackgroundColor,
    context,
  );
  return Theme.of(context).scaffoldBackgroundColor.a == 0
      ? ColorScheme.of(context).surface.withValues(alpha: barTint.a)
      : barTint;
}

/// Height of the toolbar row of a [PlatformAppBar] on iOS, matching the iOS navigation bar.
const double _kGlassToolbarHeight = 44.0;

/// Height of the tint of a [PlatformAppBar] below its buttons, when it has no bottom.
const double _kGlassBarTintBottomPadding = 8.0;

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
        // Keeps the status bar area blurred when the app bar is part of the body. Nothing scrolls
        // under a body laid out below the app bar, whose top would be faded. A tinted app bar
        // replaces the fade.
        topEdgeFade: extendBodyBehindAppBar && !hasTintedAppBar,
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
            return MediaQuery(
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
          },
        ),
      ),
    );
  }
}

/// Paints the iOS bar tint ([cupertinoBarTint]) and a hairline behind a glass app bar, over the top
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
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: cupertinoBarTint(context),
                  border: Border(
                    bottom: BorderSide(
                      color: CupertinoDynamicColor.resolve(CupertinoColors.separator, context),
                      width: 0.0,
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
}) extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => _PreferredAppBarSize(kToolbarHeight, bottom?.preferredSize.height);

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      // An iOS 26 liquid glass navigation bar, meant to be used by [PlatformScaffold].
      final colorScheme = ColorScheme.of(context);
      final buttonHeight = compactButtons ? _kGlassCompactButtonHeight : _kGlassToolbarHeight;
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
                      .merge(titleTextStyle ?? AppBarTheme.of(context).titleTextStyle),
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
            ? _GlassBarCapsule(height: buttonHeight, children: [leading!])
            : impliedLeading,
        actions: actions != null && actions!.isNotEmpty
            ? [_GlassBarCapsule(height: buttonHeight, children: actions!)]
            : null,
        bottom: bottom,
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
        // Tinted to stand out over the content, like an iOS 26 prominent button. The clear body
        // mode keeps the exact color, with the glass rim and specular highlights.
        settings: LiquidGlassSettings(
          glassColor: fabTheme.backgroundColor ?? colorScheme.primaryContainer,
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
class const _GlassBarCapsule({required final double height, required final List<Widget> children})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final foregroundColor = ColorScheme.of(context).onSurface;
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: height),
      child: GlassContainer(
        height: height,
        shape: LiquidRoundedSuperellipse(borderRadius: height / 2),
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
    );
  }
}

class const _PreferredAppBarSize(final double? toolbarHeight, final double? bottomHeight)
    extends Size {
  this : super.fromHeight((toolbarHeight ?? kToolbarHeight) + (bottomHeight ?? 0));
}
