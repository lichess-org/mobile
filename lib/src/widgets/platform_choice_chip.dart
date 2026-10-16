import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoColors, CupertinoDynamicColor;
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/platform.dart' show useLiquidGlass;
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart'
    show GlassButton, GlassQuality, LiquidGlassSettings, LiquidRoundedRectangle;
import 'package:material_ui/material_ui.dart';

/// A chip that can be selected: a Material [ChoiceChip] (or [FilterChip] when [multiple]) on
/// Android, a liquid glass pill on iOS.
///
/// The glass pill is a control floating on its own layer, for chips placed on a glass surface (a
/// glass sheet, an app bar). Its selected state is a light primary tint with a primary label (the
/// package `GlassChip` default selection is barely visible in light mode). Before iOS 26
/// ([useLiquidGlass]), it is the same pill, flat, on the control fill.
class const PlatformChoiceChip({
  required final Widget label,
  required final bool selected,

  /// Called with the new selection state when the chip is tapped; the chip is disabled when null.
  required final ValueChanged<bool>? onSelected,

  /// Whether several chips of a group can be selected at once (a [FilterChip] on Android).
  final bool multiple = false,

  /// Whether the Material chip shows a checkmark when selected. The glass chip never does.
  final bool showCheckmark = true,
  final String? tooltip,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform != TargetPlatform.iOS) {
      return multiple
          ? FilterChip(
              label: label,
              selected: selected,
              onSelected: onSelected,
              showCheckmark: showCheckmark,
              tooltip: tooltip,
            )
          : ChoiceChip(
              label: label,
              selected: selected,
              onSelected: onSelected,
              showCheckmark: showCheckmark,
              tooltip: tooltip,
            );
    }

    final colorScheme = ColorScheme.of(context);
    final enabled = onSelected != null;
    final glass = useLiquidGlass(context);
    final isOnGlassSheet = GlassSheetScope.isIn(context);
    final pill = DecoratedBox(
      decoration: BoxDecoration(
        color: selected
            ? colorScheme.primary.withValues(alpha: 0.18)
            // Without a shadow, a chip on a glass sheet needs a fill to stand out from it, like an
            // iOS control in grouped content. A flat chip always does.
            : isOnGlassSheet || !glass
            ? CupertinoDynamicColor.resolve(CupertinoColors.tertiarySystemFill, context)
            : null,
        borderRadius: const BorderRadius.all(Radius.circular(100)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: DefaultTextStyle.merge(
          style: TextStyle(
            fontSize: 14,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? colorScheme.primary : colorScheme.onSurface,
          ),
          child: label,
        ),
      ),
    );
    final chip = Semantics(
      selected: selected,
      enabled: enabled,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.4,
        child: glass
            ? IntrinsicWidth(
                child: IntrinsicHeight(
                  // The package `GlassChip` takes a `String` label: build the same pill around any
                  // label.
                  child: GlassButton.custom(
                    onTap: () => onSelected?.call(!selected),
                    enabled: enabled,
                    shape: const LiquidRoundedRectangle(borderRadius: 100),
                    // On a glass surface there is no parent glass layer to share.
                    useOwnLayer: true,
                    // The package default glass, without the light mode drop shadow on a glass
                    // sheet: the chip sits on the sheet, it does not float above it.
                    settings: isOnGlassSheet
                        ? const LiquidGlassSettings(shadowElevation: 0.0)
                        : null,
                    quality: GlassQuality.standard,
                    interactionScale: 1.03,
                    stretch: 0.3,
                    glowRadius: 0.8,
                    width: double.infinity,
                    height: double.infinity,
                    child: pill,
                  ),
                ),
              )
            : GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: enabled ? () => onSelected!(!selected) : null,
                child: pill,
              ),
      ),
    );
    return tooltip != null ? Tooltip(message: tooltip, child: chip) : chip;
  }
}
