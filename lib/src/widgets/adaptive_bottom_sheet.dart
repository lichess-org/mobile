import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoColors;
import 'package:lichess_mobile/src/widgets/glass_modal.dart';
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
/// It always has a drag handle. On iOS the sheet has the frame of the glass sheets
/// ([showAdaptiveBottomSheet]), but is opaque: a long list that fills the screen stays readable.
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
                GlassBottomSheetFrame(expandable: true, child: builder(context, scrollController))
          : builder,
    ),
  );
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

/// The iOS frame of a bottom sheet: a glass card inset from the screen edges.
class const GlassBottomSheetFrame({
  required final Widget child,

  /// Whether the sheet expands ([showAdaptiveDraggableBottomSheet]): the card is then opaque, has a
  /// drag handle, and [child] fills it.
  final bool expandable = false,
  super.key,
}) extends StatelessWidget {
  static const _margin = 8.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(_margin),
      child: GlassModalCard(
        // Opaque, in the color of the Material sheets.
        color: expandable
            ? Theme.of(context).bottomSheetTheme.backgroundColor?.withValues(alpha: 1.0) ??
                  ColorScheme.of(context).surfaceContainerLow
            : null,
        // Concentric with the screen corners, at [_margin] from them.
        borderRadius: 38.0,
        // The card ends just above the home indicator: the content needs no bottom safe area.
        child: MediaQuery.removePadding(
          context: context,
          removeBottom: true,
          child: GlassSheetScope(
            child: Theme(
              // Translucent cards, like the grouped cells of an iOS 26 sheet.
              data: Theme.of(context).copyWith(
                cardTheme: Theme.of(context).cardTheme
                    .copyWith(color: GlassSheetScope.fillColor(context)),
              ),
              child: Material(
                type: MaterialType.transparency,
                child: expandable
                    ? Column(
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
                      )
                    // At the sheet's minimum height, short content stays at the top.
                    : Align(alignment: Alignment.topCenter, heightFactor: 1.0, child: child),
              ),
            ),
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
/// sheet.
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
    return GlassIconButton(
      icon: Icon(switch (action) {
        .close => Icons.close_rounded,
        .back => Icons.arrow_back_ios_new_rounded,
      }, color: ColorScheme.of(context).onSurface),
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
