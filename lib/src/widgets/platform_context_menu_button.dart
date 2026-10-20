import 'package:flutter/services.dart';
import 'package:lichess_mobile/src/widgets/platform.dart' show useLiquidGlass;
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart'
    show GlassDefaults, GlassMenu, GlassMenuController, GlassMenuItem, LiquidGlassSettings;
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

/// Width of the liquid glass context menus.
const _kGlassMenuWidth = 250.0;

/// The glass of the liquid glass context menus.
LiquidGlassSettings? _glassMenuSettings(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light ? kLightMenuGlassSettings : null;

/// The items of a liquid glass context menu, one per action.
List<GlassMenuItem> _glassMenuItems(List<ContextMenuAction> actions) => [
  for (final action in actions)
    GlassMenuItem(
      title: action.label,
      icon: action.icon != null ? Icon(action.icon) : null,
      enabled: action.onPressed != null,
      onTap: action.onPressed ?? () {},
    ),
];

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
        menuWidth: _kGlassMenuWidth,
        settings: _glassMenuSettings(context),
        semanticLabel: semanticsLabel,
        // The button is not glass itself: it sits in the glass capsule of the app bar.
        triggerBuilder: (context, toggleMenu) => buildButton(toggleMenu),
        items: _glassMenuItems(actions),
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

/// A widget that opens a context menu where it is long pressed, such as a chat message.
///
/// On iOS 26 and later, the liquid glass menu of [ContextMenuIconButton] blooms from the press
/// point, and the finger can slide onto an action and lift to select it, like an iOS context menu.
/// Elsewhere it is a Material menu opened at the press point.
class const ContextMenuRegion({
  required final List<ContextMenuAction> actions,
  required final Widget child,
  super.key,
}) extends StatefulWidget {
  @override
  State<ContextMenuRegion> createState() => _ContextMenuRegionState();
}

class _ContextMenuRegionState() extends State<ContextMenuRegion> {
  final _glassMenuController = GlassMenuController();
  final _menuController = MenuController();

  /// Where the glass menu blooms from: the last long press point, in local coordinates.
  Offset? _glassMenuPosition;

  void _onLongPressStart(LongPressStartDetails details) {
    HapticFeedback.mediumImpact();
    if (!useLiquidGlass(context)) {
      _menuController.open(position: details.localPosition);
      return;
    }
    // The glass menu blooms from its invisible trigger: move it under the finger, then open it once
    // it is laid out there.
    setState(() => _glassMenuPosition = details.localPosition);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _glassMenuController.open();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!useLiquidGlass(context)) {
      return MenuAnchor(
        controller: _menuController,
        menuChildren: widget.actions,
        child: GestureDetector(onLongPressStart: _onLongPressStart, child: widget.child),
      );
    }

    return Stack(
      clipBehavior: .none,
      children: [
        GestureDetector(
          onLongPressStart: _onLongPressStart,
          // The finger that opened the menu selects an action by sliding onto it and lifting.
          onLongPressMoveUpdate: (details) => _glassMenuController.glideTo(details.globalPosition),
          onLongPressEnd: (_) => _glassMenuController.endGlide(),
          child: widget.child,
        ),
        if (_glassMenuPosition case final position?)
          Positioned(
            left: position.dx,
            top: position.dy,
            child: GlassMenu(
              controller: _glassMenuController,
              trigger: const SizedBox.shrink(),
              morphFromZero: true,
              autoAdjustToScreen: true,
              menuWidth: _kGlassMenuWidth,
              settings: _glassMenuSettings(context),
              items: _glassMenuItems(widget.actions),
            ),
          ),
      ],
    );
  }
}

/// An action of a [ContextMenuIconButton] or a [ContextMenuRegion].
///
/// On iOS 26 and later, it is turned into a [GlassMenuItem] by the menu and never built.
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
