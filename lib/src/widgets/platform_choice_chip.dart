import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoColors, CupertinoDynamicColor;
import 'package:lichess_mobile/src/widgets/platform.dart' show useLiquidGlass;
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart'
    show GlassButton, GlassQuality, LiquidRoundedRectangle;
import 'package:material_ui/material_ui.dart';

/// A chip that can be selected: a Material [ChoiceChip] (or [FilterChip] when [multiple]) on
/// Android, a pill on iOS.
///
/// The iOS pill is liquid glass in an app bar ([inAppBar]), as a control floating on its own layer.
/// Anywhere else, such as in a sheet, it is the same pill, flat, on the control fill, like the iOS
/// controls in content; and always before iOS 26
/// ([useLiquidGlass]). Its selected state is a light primary tint with a primary label (the package
/// `GlassChip` default selection is barely visible in light mode).
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

  /// Whether the chip is a control of an app bar, which makes it glass on iOS.
  final bool inAppBar = false,
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
    final glass = useLiquidGlass(context) && inAppBar;
    final pill = DecoratedBox(
      decoration: BoxDecoration(
        color: selected
            ? colorScheme.primary.withValues(alpha: 0.18)
            // A flat chip needs a fill, like an iOS control in content.
            : !glass
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
                    // In an app bar there is no parent glass layer to share.
                    useOwnLayer: true,
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
