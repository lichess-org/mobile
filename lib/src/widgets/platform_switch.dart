import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' show GlassSwitch;
import 'package:material_ui/material_ui.dart';

/// An adaptive switch ([Switch.adaptive]), which on a glass sheet on iOS is the iOS 26 switch with
/// its glass thumb.
class const PlatformSwitch({
  required final bool value,

  /// Called when the user toggles the switch; the switch is disabled when null.
  required final ValueChanged<bool>? onChanged,
  final EdgeInsetsGeometry? padding,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform != TargetPlatform.iOS || !GlassSheetScope.isIn(context)) {
      return Switch.adaptive(value: value, onChanged: onChanged, padding: padding);
    }
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Opacity(
        opacity: onChanged != null ? 1.0 : 0.5,
        child: IgnorePointer(
          ignoring: onChanged == null,
          child: GlassSwitch(
            value: value,
            onChanged: onChanged ?? (_) {},
            // Like the adaptive switch, which uses the theme primary color instead of the iOS green
            // (the app Cupertino theme applies to all widgets).
            activeColor: ColorScheme.of(context).primary,
            // On the sheet's glass there is no parent glass layer to share.
            useOwnLayer: true,
          ),
        ),
      ),
    );
  }
}
