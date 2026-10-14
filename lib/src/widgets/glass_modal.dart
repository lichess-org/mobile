import 'package:liquid_glass_widgets/liquid_glass_widgets.dart'
    show GlassContainer, LiquidGlassSettings, LiquidRoundedSuperellipse;
import 'package:material_ui/material_ui.dart';

/// The rounded liquid glass card of an iOS modal (action sheet, alert dialog).
///
/// Its tint is opaque enough to read the modal over most content; raise [tintOpacity] over busy
/// content such as a board.
class const GlassModalCard({
  required final Widget child,
  final double tintOpacity = 0.65,
  final double borderRadius = 26.0,
  final EdgeInsetsGeometry? padding,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassContainer(
      // A modal floats alone over the content, there is no parent glass layer to share.
      useOwnLayer: true,
      shape: LiquidRoundedSuperellipse(borderRadius: borderRadius),
      clipBehavior: Clip.antiAlias,
      padding: padding,
      // The package action sheet's glass.
      settings: LiquidGlassSettings(
        thickness: 30,
        blur: 5,
        refractiveIndex: 1.15,
        saturation: 1.2,
        glassColor: (isDark ? Colors.black : Colors.white).withValues(alpha: tintOpacity),
      ),
      child: child,
    );
  }
}

/// The iOS frame of a dialog: a [GlassModalCard] centered on the screen.
///
/// Filled buttons in [child] are capsules, like the iOS 26 dialog buttons.
class const GlassDialogFrame({
  required final Widget child,

  /// See [GlassModalCard.tintOpacity].
  final double tintOpacity = 0.65,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: GlassModalCard(
              tintOpacity: tintOpacity,
              borderRadius: 34.0,
              padding: const EdgeInsets.all(20.0),
              // The content may hold Material widgets (list tiles, checkboxes, buttons...).
              child: Material(
                type: MaterialType.transparency,
                child: FilledButtonTheme(
                  data: FilledButtonThemeData(
                    style: FilledButton.styleFrom(shape: const StadiumBorder()),
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
