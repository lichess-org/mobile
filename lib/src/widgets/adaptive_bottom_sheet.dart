import 'dart:math' as math;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoColors, CupertinoTheme;
import 'package:lichess_mobile/src/tab_navigation.dart' show isTabBarHiddenAt;
import 'package:lichess_mobile/src/widgets/glass_modal.dart';
import 'package:lichess_mobile/src/widgets/platform.dart' show useLiquidGlass;
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart'
    show
        GlassIconButton,
        GlassModalSheet,
        GlassModalSheetStateProvider,
        GlassMorphAnchor,
        GlassSheetDetent,
        ScrollControllerProvider;
import 'package:material_ui/material_ui.dart';

/// The minimum height of an iOS bottom sheet that doesn't expand ([showAdaptiveBottomSheet]), as a
/// fraction of the screen height.
///
/// The same for every sheet, so that short sheets (menus, filters, settings) open at the same
/// height whatever their content.
const kGlassBottomSheetMinHeightFraction = 0.45;

/// Shows a modal bottom sheet: a Material bottom sheet on Android, an inset card on iOS.
///
/// The iOS sheet is still a Material modal bottom sheet (drag to dismiss, keyboard, constraints
/// work as usual), with a transparent background and the content in a card that floats inset from
/// the screen edges, like an iOS 26 sheet at a partial height.
///
/// Glass is for navigation and controls, never for content: the card is opaque and flat
/// ([OpaqueBottomSheetFrame]), with opaque content, unless [glass]. Only a sheet made of navigation
/// items and actions alone (a menu), or of a few settings or filters, is [glass]: its content is
/// then in a [GlassSheetScope], on a glass background, where [ListSection]s get translucent section
/// cards, and setting switches and [NonLinearSlider]s become glass controls.
///
/// On iOS 26 a [glass] sheet is a [GlassModalSheet] at half height, which morphs out of
/// [morphFrom] when given (the anchor of a [SheetIconButton]). Before iOS 26 it is in a
/// [GlassBottomSheetFrame].
///
/// The iOS sheet doesn't expand: it has no drag handle ([showDragHandle] is Android only), its
/// minimum height is [kGlassBottomSheetMinHeightFraction] of the screen height, replacing the
/// minimum height of [constraints], and it stays below the status bar.
///
/// For sheets that expand, use [showAdaptiveDraggableBottomSheet].
Future<T?> showAdaptiveBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,

  /// Whether the iOS sheet is glass: only for a sheet of navigation items and actions alone, or of
  /// a few settings or filters.
  bool glass = false,

  /// The control the iOS 26 [glass] sheet morphs out of (see [SheetIconButton]).
  GlassMorphAnchor? morphFrom,
  bool isDismissible = true,
  bool isScrollControlled = false,
  bool useRootNavigator = false,
  bool showDragHandle = false,
  bool useSafeArea = false,
  BoxConstraints? constraints,
}) {
  if (glass && useLiquidGlass(context)) {
    return _showGlassModalSheet(
      context: context,
      detents: const {GlassSheetDetent.medium},
      isDismissible: isDismissible,
      useRootNavigator: useRootNavigator,
      morphFrom: morphFrom,
      builder: (context) => _GlassSheetContent(child: builder(context)),
    );
  }
  final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
  return showModalBottomSheet<T>(
    context: context,
    isDismissible: isDismissible,
    isScrollControlled: isScrollControlled,
    // The root navigator is only needed to cover the tab bar: a screen hiding it presents its
    // sheets on its own navigator, so that the screens they push stay in its stack.
    useRootNavigator: useRootNavigator && !isTabBarHiddenAt(context),
    // A floating glass card must not grow under the status bar.
    useSafeArea: isIOS || useSafeArea,
    constraints: isIOS ? _glassSheetConstraints(context, constraints) : constraints,
    showDragHandle: !isIOS && showDragHandle,
    backgroundColor: isIOS ? Colors.transparent : null,
    elevation: isIOS ? 0 : null,
    builder: isIOS
        ? (context) => glass
              ? GlassBottomSheetFrame(child: builder(context))
              : OpaqueBottomSheetFrame(layout: .fixed, child: builder(context))
        : builder,
  );
}

/// Shows a modal bottom sheet that expands: a [DraggableScrollableSheet] that the user drags
/// between [minChildSize] and [maxChildSize], and that is dismissed by dragging it down.
///
/// [builder] gets the sheet's scroll controller, to give to the scroll view of the content.
///
/// It always has a drag handle. On iOS 26 it is a [GlassModalSheet], like a native iOS 26 sheet:
/// glass at half height ([initialChildSize]), opaque once expanded to the full height. Its content
/// is opaque (not in a [GlassSheetScope]), being on an opaque sheet once expanded. The other sizes
/// are not used: it is dismissed by dragging it down from half height. The content gets the sheet's
/// padding through the media query: its scroll view must apply it (see
/// [BottomSheetScrollableContainer]).
///
/// Before iOS 26 the sheet is inset like the other sheets ([showAdaptiveBottomSheet]), an opaque,
/// flat card ([OpaqueBottomSheetFrame]).
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
  if (useLiquidGlass(context)) {
    return _showGlassModalSheet(
      context: context,
      detents: const {GlassSheetDetent.medium, GlassSheetDetent.large},
      halfSize: initialChildSize,
      useRootNavigator: useRootNavigator,
      // The sheet installs its physics on the scroll views inside it: dragged up, the content
      // expands the sheet first, then scrolls.
      builder: (context) => builder(context, ScrollControllerProvider.of(context)!.controller),
    );
  }
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

/// Shows a modal bottom sheet that always opens at the full height of the screen, with a header
/// made of a close button and a [title], above the content: for information that may be long.
///
/// [builder] builds the content below the header, which fills the rest of the sheet: a scroll view
/// using the scroll controller it gets, which needs no bottom padding of its own (the sheet goes
/// down to the bottom of the screen, its media query padding is applied). The content scrolls while
/// it can; dragged down from its top, or when it has nothing to scroll, it drags the sheet, which
/// is dismissed past half of its height, like an iOS sheet.
///
/// Content that loads should switch from its loading state with [WhenRouteSettled], so that it does
/// not change while the sheet is opening.
///
/// On iOS the sheet is like an iOS 26 sheet at its large detent: an opaque, flat card, edge to edge
/// ([OpaqueBottomSheetFrame]), with a glass close button and a centered title. On Android
/// it is a Material sheet with a close button and a title, like a full screen dialog.
Future<T?> showAdaptiveFullHeightBottomSheet<T>({
  required BuildContext context,
  required Widget title,
  required ScrollableWidgetBuilder builder,
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
    backgroundColor: isIOS ? Colors.transparent : null,
    elevation: isIOS ? 0 : null,
    // Snaps back to the full height, or down to nothing: the modal sheet is dismissed once the
    // sheet reaches its minimum size.
    builder: (context) => LayoutBuilder(
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
              child: Column(
                children: [
                  _FullHeightSheetHeader(title: title),
                  Expanded(child: builder(context, scrollController)),
                ],
              ),
            ),
          );
          return isIOS ? OpaqueBottomSheetFrame(layout: .fullHeight, child: content) : content;
        },
      ),
    ),
  );
}

/// Shows [placeholder] until [ready], and never switches to the content while the enclosing route
/// (e.g. a bottom sheet) is animating in: building new content during the transition makes it
/// stutter.
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
  }

  @override
  void dispose() {
    _routeAnimation?.removeStatusListener(_onRouteAnimationStatus);
    super.dispose();
  }

  void _onRouteAnimationStatus(AnimationStatus status) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isOpening = _routeAnimation?.status == AnimationStatus.forward;
    return widget.ready && (_readyAtStart || !isOpening)
        ? widget.builder(context)
        : widget.placeholder;
  }
}

/// The header of a [showAdaptiveFullHeightBottomSheet] sheet: a close button and a title, centered
/// on iOS.
class const _FullHeightSheetHeader({required final Widget title}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return Padding(
      padding: isIOS
          ? const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0)
          : const EdgeInsets.fromLTRB(4.0, 4.0, 16.0, 0.0),
      child: SizedBox(
        height: isIOS ? 44.0 : kToolbarHeight,
        child: NavigationToolbar(
          leading: SheetHeaderButton(action: .close, onPressed: () => Navigator.of(context).pop()),
          middle: Semantics(
            header: true,
            child: DefaultTextStyle.merge(
              style: isIOS
                  ? CupertinoTheme.of(context).textTheme.navTitleTextStyle
                        .copyWith(color: ColorScheme.of(context).onSurface)
                  : TextTheme.of(context).titleLarge,
              maxLines: 1,
              overflow: .ellipsis,
              child: title,
            ),
          ),
          centerMiddle: isIOS,
        ),
      ),
    );
  }
}

/// Shows a [GlassModalSheet] resting at [detents]: glass at half height ([halfSize] of the screen
/// height), opaque at full height.
Future<T?> _showGlassModalSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  required Set<GlassSheetDetent> detents,
  double halfSize = kGlassBottomSheetMinHeightFraction,
  bool isDismissible = true,
  bool useRootNavigator = false,
  GlassMorphAnchor? morphFrom,
}) {
  return GlassModalSheet.show<T>(
    context: context,
    detents: detents,
    halfSize: halfSize,
    isDismissible: isDismissible,
    dismissible: isDismissible,
    // The root navigator is only needed to cover the tab bar: a screen hiding it presents its
    // sheets on its own navigator, so that the screens they push stay in its stack, and its
    // navigation shell sees the sheet morph out of its bar button.
    useRootNavigator: useRootNavigator && !isTabBarHiddenAt(context),
    morphFrom: morphFrom,
    // Only a sheet that expands has a drag handle, like the iOS sheets.
    showDragIndicator: detents.length > 1,
    // The package's sheet glass is nearly clear: the glass of the other modals, more opaque in light
    // mode, where a sheet is often over a board.
    settings: glassModalSettings(
      context,
      tintOpacity: Theme.of(context).brightness == Brightness.light
          ? _kLightGlassSheetTintOpacity
          : _kGlassSheetTintOpacity,
    ),
    expandedColor: opaqueModalColor(context),
    // The corners of the other sheets: concentric with the screen corners, inset at half height,
    // edge to edge at full height.
    horizontalMargin: _kSheetMargin,
    bottomMargin: _kSheetMargin,
    topBorderRadius: _sheetCornerRadius(context),
    bottomBorderRadius: _sheetCornerRadius(context),
    fullTopBorderRadius: _sheetCornerRadius(context, inset: 0),
    fullBottomBorderRadius: _sheetCornerRadius(context, inset: 0),
    // A dialog route, out of any Material ancestor: like the other sheets, the content gets one.
    builder: (context) => Material(
      type: MaterialType.transparency,
      child: _GlassModalSheetPadding(child: Builder(builder: builder)),
    ),
  );
}

/// The tint opacity of a [GlassModalSheet] in dark mode: the other modals' ([glassModalSettings]).
const _kGlassSheetTintOpacity = 0.65;

/// The tint opacity of a [GlassModalSheet] in light mode, higher than the other modals', to keep
/// the content readable over a board.
const _kLightGlassSheetTintOpacity = 0.8;

/// Space above the content of a [GlassModalSheet], below its drag handle (8 + 4 + 8), the same
/// whether it has one or not.
const _kGlassModalSheetTopPadding = 20.0;

/// Lays the content of a [GlassModalSheet] out in the sheet.
///
/// The sheet gives its content its whole height, from its top edge, where the drag handle is drawn
/// over it, to its bottom edge, which is not the bottom of what is seen.
///
/// At the top, the content starts [_kGlassModalSheetTopPadding] below the edge, whatever the
/// content and even scrolled, so that every sheet has the same space above its content: the top
/// padding of [BottomSheetScrollableContainer] is dropped in it.
///
/// At the bottom, the padding is given to the content through the media query, for its scroll view
/// (or [SafeArea]) to apply: the sheet rests [_kSheetMargin] above the bottom of the screen at half
/// height, over the home indicator, and expanded, it goes below the bottom of the screen
/// ([SheetStateInfo.submergedBottom]). The bottom padding is what is out of the screen, plus the
/// home indicator area. The route's media query is the screen's: its top padding (the status bar)
/// is not the sheet's.
class const _GlassModalSheetPadding({required final Widget child}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final submergedBottom = GlassModalSheetStateProvider.of(context)?.submergedBottom ?? 0.0;
    // The distance from the bottom of the screen to the bottom of the sheet.
    final sheetBottom = submergedBottom > 0 ? -submergedBottom : _kSheetMargin;
    final padding = mediaQuery.padding.copyWith(
      top: 0.0,
      bottom: math.max(0.0, mediaQuery.padding.bottom - sheetBottom),
    );
    return _InGlassModalSheet(
      child: Padding(
        padding: const EdgeInsets.only(top: _kGlassModalSheetTopPadding),
        child: MediaQuery(
          data: mediaQuery.copyWith(padding: padding, viewPadding: padding),
          child: child,
        ),
      ),
    );
  }
}

/// Marks the content of a [GlassModalSheet], whose top padding is the sheet's
/// ([_GlassModalSheetPadding]).
class const _InGlassModalSheet({required super.child}) extends InheritedWidget {
  static bool isIn(BuildContext context) =>
      context.getInheritedWidgetOfExactType<_InGlassModalSheet>() != null;

  @override
  bool updateShouldNotify(_InGlassModalSheet oldWidget) => false;
}

/// The content of a glass sheet: in a [GlassSheetScope], with translucent cards, like the grouped
/// cells of an iOS 26 sheet.
class const _GlassSheetContent({required final Widget child}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlassSheetScope(
      child: Theme(
        data: Theme.of(context).copyWith(
          cardTheme: Theme.of(context).cardTheme
              .copyWith(color: GlassSheetScope.fillColor(context)),
        ),
        child: child,
      ),
    );
  }
}

BoxConstraints _glassSheetConstraints(BuildContext context, BoxConstraints? constraints) {
  // Without constraints, the Material sheet falls back to the theme's, then to a 640 max width.
  final base =
      constraints ??
      Theme.of(context).bottomSheetTheme.constraints ??
      const BoxConstraints(maxWidth: 640);
  final minHeight = MediaQuery.heightOf(context) * kGlassBottomSheetMinHeightFraction;
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
/// like the package does for its own sheets (`GlassThemeHelpers.resolveAdaptiveRadius`, not
/// exported).
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

/// The iOS frame of a glass bottom sheet ([showAdaptiveBottomSheet] with `glass`): a glass card
/// inset from the screen edges.
///
/// Before iOS 26 ([useLiquidGlass]), the card is opaque, and so is its content: it is not in a
/// [GlassSheetScope].
class const GlassBottomSheetFrame({required final Widget child, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // At the sheet's minimum height, short content stays at the top.
    final content = Material(
      type: MaterialType.transparency,
      child: Align(alignment: Alignment.topCenter, heightFactor: 1.0, child: child),
    );
    return Padding(
      padding: const EdgeInsets.all(_kSheetMargin),
      child: GlassModalCard(
        borderRadius: _sheetCornerRadius(context),
        // The card ends just above the home indicator: the content needs no bottom safe area.
        child: MediaQuery.removePadding(
          context: context,
          removeBottom: true,
          child: useLiquidGlass(context) ? _GlassSheetContent(child: content) : content,
        ),
      ),
    );
  }
}

/// How an [OpaqueBottomSheetFrame] lays out its sheet.
enum OpaqueSheetLayout() {
  /// A sheet that doesn't expand ([showAdaptiveBottomSheet]): inset from the screen edges, without
  /// a drag handle, short content at the top.
  fixed,

  /// A sheet that expands ([showAdaptiveDraggableBottomSheet]): inset from the screen edges, with a
  /// drag handle, the content filling the card.
  draggable,

  /// A sheet at the full height of the screen ([showAdaptiveFullHeightBottomSheet]): edge to edge,
  /// down to the bottom of the screen, without a drag handle, the content filling the card.
  fullHeight,
}

/// The iOS frame of an opaque bottom sheet: an opaque, flat card, with the corners of the glass
/// sheets. Its content is opaque too: it is not in a [GlassSheetScope].
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

/// Tells the content of a sheet that it is laid out on a glass background, so that it can drop
/// its opaque backgrounds ([fillColor]) and use glass controls.
class const GlassSheetScope({required super.child, super.key}) extends InheritedWidget {
  /// Whether [context] is inside a glass sheet.
  static bool isIn(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<GlassSheetScope>() != null;

  /// The translucent fill of the cards and other surfaces of a glass sheet, in place of their
  /// opaque surface colors.
  static Color fillColor(BuildContext context) => Theme.of(context).brightness == Brightness.dark
      ? const Color(0x14FFFFFF)
      : const Color(0x80FFFFFF);

  @override
  bool updateShouldNotify(GlassSheetScope oldWidget) => false;
}

/// The action of a [SheetHeaderButton].
enum SheetHeaderAction() {
  close,
  back,
}

/// A button in the header of a bottom sheet, that closes the sheet or goes back in it: an
/// [IconButton] on Android, a round liquid glass button on iOS, like the buttons of an iOS 26
/// sheet (a flat one before iOS 26).
class const SheetHeaderButton({
  required final SheetHeaderAction action,
  required final VoidCallback onPressed,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final tooltip = switch (action) {
      .close => localizations.closeButtonTooltip,
      .back => localizations.backButtonTooltip,
    };
    if (Theme.of(context).platform != TargetPlatform.iOS) {
      return IconButton(
        icon: Icon(switch (action) {
          .close => Icons.close,
          .back => Icons.arrow_back,
        }),
        tooltip: tooltip,
        onPressed: onPressed,
      );
    }
    final icon = Icon(switch (action) {
      .close => Icons.close_rounded,
      .back => Icons.arrow_back_ios_new_rounded,
    }, color: ColorScheme.of(context).onSurface);
    if (!useLiquidGlass(context)) {
      // A round button on the control fill, like the buttons of an iOS 18 sheet.
      return IconButton(
        icon: icon,
        tooltip: tooltip,
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: CupertinoColors.tertiarySystemFill.resolveFrom(context),
        ),
      );
    }
    return GlassIconButton(
      icon: icon,
      semanticLabel: tooltip,
      onPressed: onPressed,
      // The sheet has no glass layer to share.
      useOwnLayer: true,
    );
  }
}

/// A modal bottom sheet container that adapts to the content size.
///
/// This is typically used with [showModalBottomSheet] to display a
/// context menu.
///
/// This is meant for content that mostly fits on the screen, not for long lists.
///
/// In an iOS 26 sheet ([GlassModalSheet]), the space above the content is the sheet's, the same in
/// every sheet: the top of [padding] is not applied.
class const BottomSheetScrollableContainer({
  required final List<Widget> children,
  final EdgeInsetsGeometry? padding = const EdgeInsets.symmetric(vertical: 16.0),
  final ScrollController? scrollController,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ownPadding = (padding ?? EdgeInsets.zero).resolve(Directionality.of(context));
    // The safe area is in the scroll view's padding, so that the content scrolls under it.
    return SingleChildScrollView(
      controller: scrollController,
      padding: (_InGlassModalSheet.isIn(context) ? ownPadding.copyWith(top: 0.0) : ownPadding).add(
        MediaQuery.paddingOf(context),
      ),
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
