import 'package:lichess_mobile/src/widgets/glass_modal.dart';
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
/// The iOS sheet doesn't expand: it has no drag handle ([showDragHandle] is Android only), and its
/// minimum height is [kGlassBottomSheetMinHeightFraction] of the screen height, replacing the
/// minimum height of [constraints].
Future<T?> showAdaptiveBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isDismissible = true,
  bool isScrollControlled = false,
  bool useRootNavigator = false,
  bool showDragHandle = false,
  BoxConstraints? constraints,
}) {
  final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
  return showModalBottomSheet<T>(
    context: context,
    isDismissible: isDismissible,
    isScrollControlled: isScrollControlled,
    useRootNavigator: useRootNavigator,
    constraints: isIOS ? _glassSheetConstraints(context, constraints) : constraints,
    showDragHandle: !isIOS && showDragHandle,
    backgroundColor: isIOS ? Colors.transparent : null,
    elevation: isIOS ? 0 : null,
    builder: isIOS ? (context) => GlassBottomSheetFrame(child: builder(context)) : builder,
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
class const GlassBottomSheetFrame({required final Widget child, super.key})
    extends StatelessWidget {
  static const _margin = 8.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(_margin),
      child: GlassModalCard(
        // Concentric with the screen corners, at [_margin] from them.
        borderRadius: 38.0,
        // The card ends just above the home indicator: the content needs no bottom safe area.
        child: MediaQuery.removePadding(
          context: context,
          removeBottom: true,
          child: GlassSheetScope(
            child: Material(
              type: MaterialType.transparency,
              // At the sheet's minimum height, short content stays at the top.
              child: Align(alignment: Alignment.topCenter, heightFactor: 1.0, child: child),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tells the content of a sheet that it is laid out on a glass background, so that it can drop
/// its opaque backgrounds (see [ListSection]).
class const GlassSheetScope({required super.child, super.key}) extends InheritedWidget {
  /// Whether [context] is inside a glass sheet.
  static bool isIn(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<GlassSheetScope>() != null;

  @override
  bool updateShouldNotify(GlassSheetScope oldWidget) => false;
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
