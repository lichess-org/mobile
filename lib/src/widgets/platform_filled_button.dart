import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart'
    show GlassButton, LiquidGlassSettings, LiquidRoundedSuperellipse;
import 'package:material_ui/material_ui.dart';

const double _kGlassButtonHeight = 50.0;

/// The main action of a sheet: a [FilledButton], or on a glass sheet on iOS a liquid glass capsule
/// tinted with the primary color, like an iOS 26 prominent button.
///
/// The glass capsule takes the full width, as a [FilledButton] does in a list or a stretched
/// column: give it a bounded width.
class const PlatformFilledButton({
  required final VoidCallback? onPressed,
  required final Widget child,

  /// An icon before [child].
  final Widget? icon,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform != TargetPlatform.iOS || !GlassSheetScope.isIn(context)) {
      return icon != null
          ? FilledButton.icon(onPressed: onPressed, icon: icon, label: child)
          : FilledButton(onPressed: onPressed, child: child);
    }

    final colorScheme = ColorScheme.of(context);
    final enabled = onPressed != null;
    return Semantics(
      button: true,
      enabled: enabled,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.5,
        child: GlassButton.custom(
          onTap: onPressed ?? () {},
          enabled: enabled,
          // Tinted like the iOS floating action button (`PlatformFloatingActionButton`): the clear
          // body mode keeps the exact color, with the glass rim and specular highlights.
          settings: LiquidGlassSettings(
            glassColor: colorScheme.primary.withValues(alpha: 0.8),
            bodyMode: .clear,
          ),
          width: double.infinity,
          height: _kGlassButtonHeight,
          shape: const LiquidRoundedSuperellipse(borderRadius: _kGlassButtonHeight / 2),
          // On the sheet's glass there is no parent glass layer to share.
          useOwnLayer: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: DefaultTextStyle.merge(
              style: TextStyle(
                color: colorScheme.onPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
              child: IconTheme.merge(
                data: IconThemeData(color: colorScheme.onPrimary),
                child: icon != null
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 8.0,
                        children: [
                          icon!,
                          Flexible(child: child),
                        ],
                      )
                    : child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
