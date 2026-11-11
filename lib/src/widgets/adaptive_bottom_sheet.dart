import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoColors;
import 'package:lichess_mobile/src/tab_navigation.dart'
    show TabBarHidingNavigator, TabRoutePage, isTabBarHiddenAt;
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/glass_modal.dart';
import 'package:lichess_mobile/src/widgets/platform.dart'
    show PlatformAppBar, PlatformScaffold, usePinnedNavBar;
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' show GlassNavigationShell;
import 'package:material_ui/material_ui.dart';

/// The minimum height of an iOS bottom sheet that doesn't expand ([showAdaptiveBottomSheet]), as a
/// fraction of the screen height.
///
/// The same for every sheet, so that short sheets (menus, filters, settings) open at the same
/// height whatever their content.
const kBottomSheetMinHeightFraction = 0.45;

/// Shows a modal bottom sheet: a Material bottom sheet on Android, an inset card on iOS.
///
/// The iOS sheet is still a Material modal bottom sheet (drag to dismiss, keyboard, constraints
/// work as usual), with a transparent background and the content in a card that floats inset from
/// the screen edges, like an iOS 26 sheet at a partial height.
///
/// The card is opaque and flat ([OpaqueBottomSheetFrame]), with opaque content.
///
/// The iOS sheet doesn't expand: it has no drag handle ([showDragHandle] is Android only), its
/// minimum height is [kBottomSheetMinHeightFraction] of the screen height, replacing the minimum
/// height of [constraints], and it stays below the status bar.
///
/// For sheets that expand, use [showAdaptiveDraggableBottomSheet].
Future<T?> showAdaptiveBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isDismissible = true,
  bool isScrollControlled = false,
  bool useRootNavigator = false,
  bool showDragHandle = false,
  bool useSafeArea = false,
  BoxConstraints? constraints,
}) {
  final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
  return showModalBottomSheet<T>(
    context: context,
    isDismissible: isDismissible,
    isScrollControlled: isScrollControlled,
    // The root navigator is only needed to cover the tab bar: a screen hiding it presents its
    // sheets on its own navigator, so that the screens they push stay in its stack.
    useRootNavigator: useRootNavigator && !isTabBarHiddenAt(context),
    // A floating card must not grow under the status bar.
    useSafeArea: isIOS || useSafeArea,
    constraints: isIOS ? _iosSheetConstraints(context, constraints) : constraints,
    showDragHandle: !isIOS && showDragHandle,
    backgroundColor: isIOS ? Colors.transparent : null,
    elevation: isIOS ? 0 : null,
    builder: isIOS
        ? (context) => OpaqueBottomSheetFrame(layout: .fixed, child: builder(context))
        : builder,
  );
}

/// Shows a modal bottom sheet that expands: a [DraggableScrollableSheet] that the user drags
/// between [minChildSize] and [maxChildSize], and that is dismissed by dragging it down.
///
/// [builder] gets the sheet's scroll controller, to give to the scroll view of the content.
///
/// It always has a drag handle. On iOS the sheet is inset like the other sheets
/// ([showAdaptiveBottomSheet]), an opaque, flat card ([OpaqueBottomSheetFrame]).
Future<T?> showAdaptiveDraggableBottomSheet<T>({
  required BuildContext context,
  required ScrollableWidgetBuilder builder,
  double initialChildSize = 0.5,
  double minChildSize = 0.25,
  double maxChildSize = 1.0,
  bool snap = false,
  bool useRootNavigator = false,
  BoxConstraints? constraints,
}) {
  final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    // The root navigator is only needed to cover the tab bar: a screen hiding it presents its
    // sheets on its own navigator, so that the screens they push stay in its stack.
    useRootNavigator: useRootNavigator && !isTabBarHiddenAt(context),
    // A floating card must not grow under the status bar.
    useSafeArea: isIOS,
    constraints: constraints,
    // The iOS frame draws its own handle.
    showDragHandle: !isIOS,
    backgroundColor: isIOS ? Colors.transparent : null,
    elevation: isIOS ? 0 : null,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      snap: snap,
      expand: false,
      builder: isIOS
          ? (context, scrollController) => OpaqueBottomSheetFrame(
              layout: .draggable,
              child: builder(context, scrollController),
            )
          : builder,
    ),
  );
}

/// Shows a modal bottom sheet that always opens at the full height of the screen, with a navigator
/// of its own, like an iOS sheet with a navigation stack: [builder] builds its first page, and the
/// screens pushed from a page with `Navigator.of(context)` are shown in the sheet.
///
/// The pages are screens ([PlatformScaffold] with a [PlatformAppBar], in routes built by
/// [buildScreenRoute]), shown unchanged: their app bar is the header of the sheet. The app bar of
/// the first page has a close button, the others a back button. A screen that covers the whole
/// screen, pushed with [TabBarHidingNavigator.pushHidingTabBar] (e.g. a board screen), is pushed
/// above the sheet instead.
///
/// The sheet is dismissed by dragging it down, from any page: the main vertical scroll view of a
/// page drags the sheet once scrolled to its top, unless it has a controller of its own (it gets the
/// sheet's as its primary scroll controller, see [TabRoutePage]). Elsewhere, the app bar drags it.
/// Like any screen, a page lays out its content below the app bar with the media query padding
/// (see [PlatformScaffold]), which also has the bottom safe area: the sheet goes down to the bottom
/// of the screen.
///
/// Content that loads should switch from its loading state with [WhenRouteSettled], so that it does
/// not change while the sheet is opening, or while the page is pushed.
///
/// The pages are painted with the opaque color of the sheet, without the background theme. On iOS
/// the sheet is like an iOS 26 sheet at its large detent: an opaque, flat card, edge to edge
/// ([OpaqueBottomSheetFrame]), with glass bar buttons.
Future<T?> showAdaptiveNavigationSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool useRootNavigator = false,
}) {
  final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    // The root navigator is only needed to cover the tab bar: a screen hiding it presents its
    // sheets on its own navigator, so that the screens they push stay in its stack.
    useRootNavigator: useRootNavigator && !isTabBarHiddenAt(context),
    // The sheet stops below the status bar.
    useSafeArea: true,
    // The pages are opaque, so that a page being pushed covers the one below it.
    backgroundColor: isIOS ? Colors.transparent : opaqueModalColor(context),
    elevation: isIOS ? 0 : null,
    // The opaque pages are clipped to the rounded corners of the Material sheet.
    clipBehavior: isIOS ? null : Clip.antiAlias,
    // Snaps back to the full height, or down to nothing: the modal sheet is dismissed once the
    // sheet reaches its minimum size.
    builder: (sheetContext) => LayoutBuilder(
      builder: (context, constraints) => DraggableScrollableSheet(
        initialChildSize: 1.0,
        minChildSize: 0.0,
        snap: true,
        expand: false,
        builder: (context, scrollController) {
          // Dragged down, the sheet gets shorter: its content keeps the full height and is cut at
          // the bottom of the screen, so that the sheet looks moved down, not squeezed.
          final content = ClipRect(
            child: OverflowBox(
              alignment: Alignment.topCenter,
              minHeight: constraints.maxHeight,
              maxHeight: constraints.maxHeight,
              child: _SheetNavigator(
                scrollController: scrollController,
                sheetNavigator: Navigator.of(sheetContext),
                sheetRoute: ModalRoute.of(sheetContext)!,
                builder: builder,
              ),
            ),
          );
          return isIOS ? OpaqueBottomSheetFrame(layout: .fullHeight, child: content) : content;
        },
      ),
    ),
  );
}

/// Space above the app bar of the pages of a [showAdaptiveNavigationSheet] sheet on iOS.
const _kNavigationSheetTopInset = 16.0;

/// The sheet of [showAdaptiveNavigationSheet] that a page is shown in.
class const NavigationSheetScope({
  /// The scroll controller of the sheet, which drags it once scrolled to the top.
  required final ScrollController scrollController,

  /// The navigator that the sheet is presented on.
  required final NavigatorState sheetNavigator,

  /// The animation of the sheet's route.
  required final Animation<double> sheetAnimation,

  /// The radius of the top corners of the sheet on iOS (0 elsewhere).
  required final double topCornerRadius,
  required super.child,
  super.key,
}) extends InheritedWidget {
  static NavigationSheetScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NavigationSheetScope>();
  }

  /// Closes the navigation sheet that [context] is in, if any.
  static void close(BuildContext context) {
    context.getInheritedWidgetOfExactType<NavigationSheetScope>()?.sheetNavigator.pop();
  }

  @override
  bool updateShouldNotify(NavigationSheetScope oldWidget) {
    return scrollController != oldWidget.scrollController ||
        sheetNavigator != oldWidget.sheetNavigator ||
        sheetAnimation != oldWidget.sheetAnimation ||
        topCornerRadius != oldWidget.topCornerRadius;
  }
}

/// The observer of the navigator of a [showAdaptiveNavigationSheet] sheet, which marks it as such:
/// [TabBarHidingNavigator.pushHidingTabBar] closes the sheet and pushes on [sheetNavigator] instead.
class NavigationSheetObserver(
  /// The navigator that the sheet is presented on.
  final NavigatorState sheetNavigator,

  /// The route of the sheet, on [sheetNavigator].
  final ModalRoute<dynamic> sheetRoute,
) extends NavigatorObserver;

/// The navigator of a [showAdaptiveNavigationSheet] sheet, with [builder] as its first page.
class const _SheetNavigator({
  required final ScrollController scrollController,
  required final NavigatorState sheetNavigator,
  required final ModalRoute<dynamic> sheetRoute,
  required final WidgetBuilder builder,
}) extends StatefulWidget {
  @override
  State<_SheetNavigator> createState() => _SheetNavigatorState();
}

class _SheetNavigatorState() extends State<_SheetNavigator> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final _heroController = MaterialApp.createMaterialHeroController();
  late final _observer = NavigationSheetObserver(widget.sheetNavigator, widget.sheetRoute);

  @override
  void dispose() {
    _heroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = opaqueModalColor(context);
    final mediaQuery = MediaQuery.of(context);
    return NavigationSheetScope(
      scrollController: widget.scrollController,
      sheetNavigator: widget.sheetNavigator,
      sheetAnimation: widget.sheetRoute.animation!,
      topCornerRadius: theme.platform == TargetPlatform.iOS
          ? _sheetCornerRadius(context, inset: 0)
          : 0,
      child: Theme(
        // The pages are painted with the color of the sheet.
        data: theme.copyWith(
          scaffoldBackgroundColor: color,
          appBarTheme: theme.appBarTheme.copyWith(backgroundColor: color),
        ),
        child: MediaQuery(
          // The app bar of the pages insets itself with the top padding, like below the status bar.
          data: theme.platform == TargetPlatform.iOS
              ? mediaQuery.copyWith(
                  padding: mediaQuery.padding.copyWith(top: _kNavigationSheetTopInset),
                )
              : mediaQuery,
          // One shell per navigator: the app bar buttons of the pages are pinned above the sheet's
          // navigator, and morph between its pages.
          child: GlassNavigationShell(
            enabled: usePinnedNavBar(context),
            // The system back pops the pages before the sheet.
            child: NavigatorPopHandler(
              onPopWithResult: (_) => _navigatorKey.currentState?.maybePop(),
              child: Navigator(
                key: _navigatorKey,
                observers: [_heroController, _observer],
                onGenerateInitialRoutes: (_, _) => [
                  buildScreenRoute<void>(screen: Builder(builder: widget.builder)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Shows [placeholder] until [ready], and never switches to the content while the enclosing route
/// (e.g. a bottom sheet, or a page of a [showAdaptiveNavigationSheet] sheet, or the sheet itself)
/// is animating in: building new content during the transition makes it stutter.
///
/// Content that is [ready] when this widget is first built is shown at once, during the transition.
/// Content that becomes ready during the transition is shown once it is over.
class const WhenRouteSettled({
  required final bool ready,
  required final WidgetBuilder builder,
  required final Widget placeholder,
  super.key,
}) extends StatefulWidget {
  @override
  State<WhenRouteSettled> createState() => _WhenRouteSettledState();
}

class _WhenRouteSettledState() extends State<WhenRouteSettled> {
  late final bool _readyAtStart;
  Animation<double>? _routeAnimation;
  Animation<double>? _sheetAnimation;

  @override
  void initState() {
    super.initState();
    _readyAtStart = widget.ready;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final animation = ModalRoute.of(context)?.animation;
    if (animation != _routeAnimation) {
      _routeAnimation?.removeStatusListener(_onRouteAnimationStatus);
      _routeAnimation = animation?..addStatusListener(_onRouteAnimationStatus);
    }
    // In a navigation sheet, the first page is not animated: the sheet is.
    final sheetAnimation = NavigationSheetScope.maybeOf(context)?.sheetAnimation;
    if (sheetAnimation != _sheetAnimation) {
      _sheetAnimation?.removeStatusListener(_onRouteAnimationStatus);
      _sheetAnimation = sheetAnimation?..addStatusListener(_onRouteAnimationStatus);
    }
  }

  @override
  void dispose() {
    _routeAnimation?.removeStatusListener(_onRouteAnimationStatus);
    _sheetAnimation?.removeStatusListener(_onRouteAnimationStatus);
    super.dispose();
  }

  void _onRouteAnimationStatus(AnimationStatus status) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isOpening =
        _routeAnimation?.status == AnimationStatus.forward ||
        _sheetAnimation?.status == AnimationStatus.forward;
    return widget.ready && (_readyAtStart || !isOpening)
        ? widget.builder(context)
        : widget.placeholder;
  }
}

BoxConstraints _iosSheetConstraints(BuildContext context, BoxConstraints? constraints) {
  // Without constraints, the Material sheet falls back to the theme's, then to a 640 max width.
  final base =
      constraints ??
      Theme.of(context).bottomSheetTheme.constraints ??
      const BoxConstraints(maxWidth: 640);
  final minHeight = MediaQuery.heightOf(context) * kBottomSheetMinHeightFraction;
  return base.copyWith(
    minHeight: minHeight,
    maxHeight: base.maxHeight < minHeight ? minHeight : null,
  );
}

/// Inset of the iOS sheet cards from the screen edges.
const _kSheetMargin = 8.0;

/// Corner radius of the iOS sheets on a screen with square corners (a home button).
const _kSquareScreenSheetRadius = 12.0;

/// The corner radius of an iOS sheet [inset] from the screen edges: concentric with the screen
/// corners, like the iOS 26 sheets, so that every sheet has the same corners on a given device.
///
/// The inset cards are [_kSheetMargin] from the edges; an edge to edge sheet (full height) has the
/// radius of the screen corners. On a screen with square corners, a fixed radius.
double _sheetCornerRadius(BuildContext context, {double inset = _kSheetMargin}) {
  final screenRadius = _screenCornerRadius(context);
  return screenRadius == 0 ? _kSquareScreenSheetRadius : screenRadius - inset;
}

/// The corner radius of the iOS screen, which Flutter can't read: guessed from the screen size,
/// like the liquid glass package does for its own sheets
/// (`GlassThemeHelpers.resolveAdaptiveRadius`, not exported).
///
/// Read from the view, not the media query, whose padding a sheet may have removed.
double _screenCornerRadius(BuildContext context) {
  final view = View.of(context);
  // A screen with a home button has no bottom safe area, and square corners.
  if (view.viewPadding.bottom == 0) return 0;
  final size = view.physicalSize / view.devicePixelRatio;
  // Pro Max and Plus iPhones (932 or 926 points), then the other Face ID iPhones.
  return size.longestSide >= 900 ? 54.0 : 46.0;
}

/// How an [OpaqueBottomSheetFrame] lays out its sheet.
enum OpaqueSheetLayout() {
  /// A sheet that doesn't expand ([showAdaptiveBottomSheet]): inset from the screen edges, without
  /// a drag handle, short content at the top.
  fixed,

  /// A sheet that expands ([showAdaptiveDraggableBottomSheet]): inset from the screen edges, with a
  /// drag handle, the content filling the card.
  draggable,

  /// A sheet at the full height of the screen ([showAdaptiveNavigationSheet]): edge to edge,
  /// down to the bottom of the screen, without a drag handle, the content filling the card.
  fullHeight,
}

/// The iOS frame of a bottom sheet: an opaque, flat card, with corners concentric with the screen
/// corners, like the iOS 26 sheets.
class const OpaqueBottomSheetFrame({
  required final Widget child,
  required final OpaqueSheetLayout layout,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fullHeight = layout == .fullHeight;
    return Padding(
      padding: fullHeight ? EdgeInsets.zero : const EdgeInsets.all(_kSheetMargin),
      child: Material(
        color: opaqueModalColor(context),
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(_sheetCornerRadius(context, inset: fullHeight ? 0 : _kSheetMargin)),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        // An inset card ends just above the home indicator: the content needs no bottom safe area.
        // A full height card goes down to the bottom of the screen.
        child: MediaQuery.removePadding(
          context: context,
          removeBottom: !fullHeight,
          child: switch (layout) {
            // At the sheet's minimum height, short content stays at the top.
            .fixed => Align(alignment: Alignment.topCenter, heightFactor: 1.0, child: child),
            .draggable => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Container(
                    width: 36,
                    height: 5,
                    decoration: BoxDecoration(
                      color: CupertinoColors.tertiaryLabel.resolveFrom(context),
                      borderRadius: const BorderRadius.all(Radius.circular(2.5)),
                    ),
                  ),
                ),
                Expanded(child: child),
              ],
            ),
            .fullHeight => child,
          },
        ),
      ),
    );
  }
}

/// A modal bottom sheet container that adapts to the content size.
///
/// This is typically used with [showModalBottomSheet] to display a
/// context menu.
///
/// This is meant for content that mostly fits on the screen, not for long lists.
class const BottomSheetScrollableContainer({
  required final List<Widget> children,
  final EdgeInsetsGeometry? padding = const EdgeInsets.symmetric(vertical: 16.0),
  final ScrollController? scrollController,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // The safe area is in the scroll view's padding, so that the content scrolls under it.
    return SingleChildScrollView(
      controller: scrollController,
      padding: (padding ?? EdgeInsets.zero).add(MediaQuery.paddingOf(context)),
      child: ListBody(children: children),
    );
  }
}

class const BottomSheetContextMenuAction({
  required final Widget child,
  final IconData? icon,
  final VoidCallback? onPressed,
  final bool closeOnPressed = true,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: child,
      onTap: () {
        if (closeOnPressed) {
          Navigator.of(context).pop();
        }
        onPressed?.call();
      },
    );
  }
}
