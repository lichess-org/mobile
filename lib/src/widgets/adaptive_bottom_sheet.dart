import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoColors, CupertinoTheme;
import 'package:lichess_mobile/src/widgets/glass_modal.dart';
import 'package:lichess_mobile/src/widgets/platform.dart' show useLiquidGlass;
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' show GlassIconButton;
import 'package:material_ui/material_ui.dart';

/// The minimum height of a glass bottom sheet, as a fraction of the screen height.
///
/// The same for every sheet, so that short sheets (menus, filters, settings) open at the same
/// height whatever their content.
const kGlassBottomSheetMinHeightFraction = 0.45;

/// Shows a modal bottom sheet: a Material bottom sheet on Android, a liquid glass sheet on iOS.
///
/// The iOS sheet is still a Material modal bottom sheet (drag to dismiss, keyboard, constraints
/// work as usual), with a transparent background and the content in a [GlassBottomSheetFrame]:
/// like an iOS 26 sheet at a partial height, it floats inset from the screen edges on a glass
/// background. Through the [GlassSheetScope] the frame sets, [ListSection]s get translucent
/// section cards, and setting switches and [NonLinearSlider]s become glass controls.
///
/// The iOS sheet doesn't expand: it has no drag handle ([showDragHandle] is Android only), its
/// minimum height is [kGlassBottomSheetMinHeightFraction] of the screen height, replacing the
/// minimum height of [constraints], and it stays below the status bar.
///
/// Sheets that expand are opaque: use [showAdaptiveDraggableBottomSheet] for them.
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
    useRootNavigator: useRootNavigator,
    // A floating glass card must not grow under the status bar.
    useSafeArea: isIOS || useSafeArea,
    constraints: isIOS ? _glassSheetConstraints(context, constraints) : constraints,
    showDragHandle: !isIOS && showDragHandle,
    backgroundColor: isIOS ? Colors.transparent : null,
    elevation: isIOS ? 0 : null,
    builder: isIOS ? (context) => GlassBottomSheetFrame(child: builder(context)) : builder,
  );
}

/// Shows a modal bottom sheet that expands: a [DraggableScrollableSheet] that the user drags
/// between [minChildSize] and [maxChildSize], and that is dismissed by dragging it down.
///
/// [builder] gets the sheet's scroll controller, to give to the scroll view of the content.
///
/// It always has a drag handle. On iOS the sheet is inset like the glass sheets
/// ([showAdaptiveBottomSheet]), but is an opaque, flat card ([OpaqueBottomSheetFrame]): a long list
/// that fills the screen stays readable.
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
    useRootNavigator: useRootNavigator,
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
          ? (context, scrollController) =>
                OpaqueBottomSheetFrame(child: builder(context, scrollController))
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
    useRootNavigator: useRootNavigator,
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
          return isIOS ? OpaqueBottomSheetFrame(fullHeight: true, child: content) : content;
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

/// Corner radius of the iOS sheets: concentric with the screen corners, at the inset of the cards
/// from them.
const _kSheetBorderRadius = 38.0;

/// Inset of the iOS sheet cards from the screen edges.
const _kSheetMargin = 8.0;

/// The iOS frame of a bottom sheet ([showAdaptiveBottomSheet]): a glass card inset from the screen
/// edges.
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
        borderRadius: _kSheetBorderRadius,
        // The card ends just above the home indicator: the content needs no bottom safe area.
        child: MediaQuery.removePadding(
          context: context,
          removeBottom: true,
          child: useLiquidGlass(context)
              ? GlassSheetScope(
                  child: Theme(
                    // Translucent cards, like the grouped cells of an iOS 26 sheet.
                    data: Theme.of(context).copyWith(
                      cardTheme: Theme.of(context).cardTheme
                          .copyWith(color: GlassSheetScope.fillColor(context)),
                    ),
                    child: content,
                  ),
                )
              : content,
        ),
      ),
    );
  }
}

/// The iOS frame of a sheet that expands ([showAdaptiveDraggableBottomSheet]) or fills the screen
/// ([showAdaptiveFullHeightBottomSheet]): an opaque, flat card, like the iOS sheets at their large
/// detent, with the corners of the glass sheets. Its content is opaque too: it is not in a
/// [GlassSheetScope].
class const OpaqueBottomSheetFrame({
  required final Widget child,

  /// Whether the sheet is at the full height of the screen: the card is then edge to edge, down to
  /// the bottom of the screen, without a drag handle. Otherwise it is inset from the screen edges,
  /// like the glass sheets, with a drag handle. [child] fills the card.
  final bool fullHeight = false,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: fullHeight ? EdgeInsets.zero : const EdgeInsets.all(_kSheetMargin),
      child: Material(
        color: opaqueModalColor(context),
        shape: const RoundedSuperellipseBorder(
          borderRadius: BorderRadius.all(Radius.circular(_kSheetBorderRadius)),
        ),
        clipBehavior: Clip.antiAlias,
        // An inset card ends just above the home indicator: the content needs no bottom safe area.
        // A full height card goes down to the bottom of the screen.
        child: MediaQuery.removePadding(
          context: context,
          removeBottom: !fullHeight,
          child: fullHeight
              ? child
              : Column(
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
class const BottomSheetScrollableContainer({
  required final List<Widget> children,
  final EdgeInsetsGeometry? padding = const EdgeInsets.symmetric(vertical: 16.0),
  final ScrollController? scrollController,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        controller: scrollController,
        padding: padding,
        child: ListBody(children: children),
      ),
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
          Navigator.of(context, rootNavigator: true).pop();
        }
        onPressed?.call();
      },
    );
  }
}
