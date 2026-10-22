import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart'
    show GlassContainer, LiquidGlassSettings, LiquidRoundedSuperellipse;
import 'package:material_ui/material_ui.dart';

/// The color of the opaque iOS modals: the color of the Material sheets, without their
/// translucency.
Color opaqueModalColor(BuildContext context) =>
    Theme.of(context).bottomSheetTheme.backgroundColor?.withValues(alpha: 1.0) ??
    ColorScheme.of(context).surfaceContainerLow;

/// The glass of the iOS modals (the package action sheet's), tinted black or white at
/// [tintOpacity] in dark or light mode, or with [color]: opaque enough to read the modal over most
/// content.
LiquidGlassSettings glassModalSettings(
  BuildContext context, {
  double tintOpacity = 0.65,
  Color? color,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return LiquidGlassSettings(
    thickness: 30,
    blur: 5,
    refractiveIndex: 1.15,
    saturation: 1.2,
    glassColor: color ?? (isDark ? Colors.black : Colors.white).withValues(alpha: tintOpacity),
  );
}

/// The rounded liquid glass card of an iOS modal (action sheet, alert dialog, bottom sheet).
///
/// Its tint is opaque enough to read the modal over most content; raise [tintOpacity] over busy
/// content such as a board.
///
/// Before iOS 26 ([useLiquidGlass]), it is an opaque card ([opaqueModalColor]) of the same shape.
class const GlassModalCard({
  required final Widget child,
  final double tintOpacity = 0.65,

  /// The tint of the glass, in place of black or white at [tintOpacity].
  final Color? color,
  final double borderRadius = 26.0,
  final EdgeInsetsGeometry? padding,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (!useLiquidGlass(context)) {
      return Material(
        color: opaqueModalColor(context),
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
        clipBehavior: Clip.antiAlias,
        child: padding != null ? Padding(padding: padding!, child: child) : child,
      );
    }

    return GlassContainer(
      // A modal floats alone over the content, there is no parent glass layer to share.
      useOwnLayer: true,
      shape: LiquidRoundedSuperellipse(borderRadius: borderRadius),
      clipBehavior: Clip.antiAlias,
      padding: padding,
      settings: glassModalSettings(context, tintOpacity: tintOpacity, color: color),
      child: child,
    );
  }
}

/// The iOS frame of a dialog: a [GlassModalCard] centered on the screen.
class const GlassDialogFrame({
  required final Widget child,

  /// See [GlassModalCard.tintOpacity].
  final double tintOpacity = 0.65,

  /// The width of an alert dialog by default.
  final double maxWidth = 300.0,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: GlassModalCard(
              tintOpacity: tintOpacity,
              borderRadius: 34.0,
              padding: const EdgeInsets.all(20.0),
              // The content may hold Material widgets (list tiles, checkboxes, buttons...).
              child: Material(type: MaterialType.transparency, child: child),
            ),
          ),
        ),
      ),
    );
  }
}
