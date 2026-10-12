import 'package:lichess_mobile/src/tab_navigation.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart'
    show GlassAppBar, GlassContainer, GlassIconButton, GlassScaffold, LiquidRoundedSuperellipse;
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

/// Height of the toolbar row of a [PlatformAppBar] on iOS, matching the iOS navigation bar.
const double _kGlassToolbarHeight = 44.0;

/// A wrapper around [Scaffold] that sets properties to handle app bar and bottom navigation bar
/// transparency on iOS.
///
/// On iOS the [Scaffold] is placed inside a [GlassScaffold], which draws the [appBar] as a liquid
/// glass navigation bar above the body.
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
        // A progressive blur works over any background, including the user's background image.
        edgeStyle: .blur,
        appBar: appBar != null
            ? PreferredSize(preferredSize: Size.fromHeight(appBarHeight), child: appBar!)
            : null,
        // GlassScaffold does not inset the body, so the app bar height is added to the top padding
        // like Scaffold.extendBodyBehindAppBar does.
        body: Builder(
          builder: (context) {
            final mediaQuery = MediaQuery.of(context);
            return MediaQuery(
              data: mediaQuery.copyWith(
                padding: mediaQuery.padding.copyWith(top: mediaQuery.padding.top + appBarHeight),
              ),
              child: scaffold,
            );
          },
        ),
      ),
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
      final parentRoute = ModalRoute.of(context);
      final impliedLeading =
          automaticallyImplyLeading && (parentRoute?.impliesAppBarDismissal ?? false)
          ? GlassIconButton(
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
            ? DefaultTextStyle.merge(
                style: TextStyle(color: colorScheme.onSurface)
                    .merge(titleTextStyle ?? AppBarTheme.of(context).titleTextStyle),
                child: title!,
              )
            : null,
        centerTitle: centerTitle ?? true,
        leading: leading != null ? _GlassBarCapsule(children: [leading!]) : impliedLeading,
        actions: actions != null && actions!.isNotEmpty
            ? [_GlassBarCapsule(children: actions!)]
            : null,
        bottom: bottom,
        toolbarHeight: _kGlassToolbarHeight,
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

/// A liquid glass capsule grouping navigation bar items, like on iOS 26.
class const _GlassBarCapsule({required final List<Widget> children}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final foregroundColor = ColorScheme.of(context).onSurface;
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: _kGlassToolbarHeight),
      child: GlassContainer(
        height: _kGlassToolbarHeight,
        shape: const LiquidRoundedSuperellipse(borderRadius: _kGlassToolbarHeight / 2),
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
