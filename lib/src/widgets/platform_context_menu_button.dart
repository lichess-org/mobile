import 'package:lichess_mobile/src/widgets/platform.dart' show useLiquidGlass;
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart'
    show GlassDefaults, GlassMenu, GlassMenuItem, LiquidGlassSettings;
import 'package:material_ui/material_ui.dart';

/// The package's default menu glass (`glass_menu_internal.dart`), with a more opaque white tint.
///
/// The package default glass (white 12%) is too clear over light content: used by the glass menus
/// and popovers in light mode. Dark mode keeps the default.
const kLightMenuGlassSettings = LiquidGlassSettings(
  blur: 10,
  thickness: 10,
  glassColor: Color(0x99FFFFFF),
  lightAngle: GlassDefaults.lightAngle,
  lightIntensity: 0.7,
  ambientStrength: 0.4,
  saturation: 1.2,
  refractiveIndex: 0.7,
  chromaticAberration: 0.0,
);

/// A platform agnostic context menu icon button.
///
/// Typically used in the [AppBar] to show a context menu.
///
/// On iOS 26 and later, the menu is a liquid glass menu that morphs out of the button. Elsewhere it
/// is a Material menu.
class const ContextMenuIconButton({
  required final Widget icon,
  final Color? color,
  required final String semanticsLabel,
  required final List<ContextMenuAction> actions,

  /// Whether to consume taps outside the menu to close it (only on Android).
  final bool consumeOutsideTap = false,
  final bool isCompact = false,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget buildButton(VoidCallback onPressed) => IconButton(
      onPressed: onPressed,
      tooltip: semanticsLabel,
      color: color,
      icon: icon,
      iconSize: isCompact ? 20.0 : null,
      style: isCompact
          ? IconButton.styleFrom(
              visualDensity: VisualDensity.compact,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            )
          : null,
    );

    if (useLiquidGlass(context)) {
      return GlassMenu(
        menuWidth: 250.0,
        settings: Theme.of(context).brightness == Brightness.light ? kLightMenuGlassSettings : null,
        semanticLabel: semanticsLabel,
        // The button is not glass itself: it sits in the glass capsule of the app bar.
        triggerBuilder: (context, toggleMenu) => buildButton(toggleMenu),
        items: [
          for (final action in actions)
            GlassMenuItem(
              title: action.label,
              icon: action.icon != null ? Icon(action.icon) : null,
              enabled: action.onPressed != null,
              onTap: action.onPressed ?? () {},
            ),
        ],
      );
    }

    return MenuAnchor(
      crossAxisUnconstrained: false,
      consumeOutsideTap: consumeOutsideTap,
      style: MenuStyle(
        maximumSize: WidgetStatePropertyAll(
          Size(MediaQuery.widthOf(context) * 0.6, MediaQuery.heightOf(context) * 0.8),
        ),
      ),
      menuChildren: actions,
      builder: (BuildContext context, MenuController controller, Widget? child) {
        return buildButton(() {
          if (controller.isOpen) {
            controller.close();
          } else {
            controller.open();
          }
        });
      },
    );
  }
}

/// An action of a [ContextMenuIconButton].
///
/// On iOS 26 and later, it is turned into a [GlassMenuItem] by the [ContextMenuIconButton] and never
/// built.
class const ContextMenuAction({
  final IconData? icon,
  required final String label,
  required final VoidCallback? onPressed,

  /// Whether the menu should be closed when an action is pressed (only on Android: an iOS menu
  /// item always closes the menu).
  ///
  /// Default to true.
  final bool dismissOnPress = true,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MenuItemButton(
      closeOnActivate: dismissOnPress,
      leadingIcon: Icon(icon),
      semanticsLabel: label,
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
