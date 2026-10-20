import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoColors, CupertinoTheme;
import 'package:flutter/services.dart';
import 'package:lichess_mobile/src/widgets/platform.dart' show useLiquidGlass;
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart'
    show GlassDefaults, GlassMenu, GlassMenuController, GlassMenuItem, LiquidGlassSettings;
import 'package:material_ui/material_ui.dart';

/// The package's default menu glass (`glass_menu_internal.dart`), with a more opaque white tint, a
/// stronger blur and more saturation: like an iOS menu, the colors of the content show through.
///
/// The package default glass (white 12%) is too clear over light content: used by the glass menus
/// and popovers in light mode ([menuGlassSettings]).
const kLightMenuGlassSettings = LiquidGlassSettings(
  blur: 20,
  thickness: 10,
  glassColor: Color(0x66FFFFFF),
  lightAngle: GlassDefaults.lightAngle,
  lightIntensity: 0.7,
  ambientStrength: 0.4,
  saturation: 1.8,
  refractiveIndex: 0.7,
  chromaticAberration: 0.0,
);

/// [kLightMenuGlassSettings] for dark mode: a fainter tint than the package default (white 8%
/// instead of 12%), its saturation, and the same stronger blur (with the package default blur, the
/// content shows through sharply).
const kDarkMenuGlassSettings = LiquidGlassSettings(
  blur: 20,
  thickness: 10,
  glassColor: Color(0x14FFFFFF),
  lightAngle: GlassDefaults.lightAngle,
  lightIntensity: 0.7,
  ambientStrength: 0.4,
  saturation: 1.2,
  refractiveIndex: 0.7,
  chromaticAberration: 0.0,
);

/// The glass of the liquid glass context menus and popovers.
LiquidGlassSettings menuGlassSettings(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
    ? kLightMenuGlassSettings
    : kDarkMenuGlassSettings;

/// Width of the liquid glass context menus.
const kGlassMenuWidth = 250.0;

/// The items of a liquid glass context menu, one per action.
///
/// In a menu of choices (one of the actions is [ContextMenuAction.selected]), the current choice
/// has a check mark on the leading edge, like an iOS menu, and the action icons are not shown.
///
/// The titles are a little smaller than the package's (17pt), and a title too long for one line
/// wraps to two, like in an iOS menu.
List<GlassMenuItem> glassMenuItems(BuildContext context, List<ContextMenuAction> actions) {
  final isChoiceMenu = actions.any((action) => action.selected);
  // The package's title color: the theme text color at 90%.
  final textColor = (CupertinoTheme.of(context).textTheme.textStyle.color ?? CupertinoColors.label)
      .withValues(alpha: 0.9);
  final titleStyle = TextStyle(color: textColor, fontSize: 15, fontWeight: FontWeight.w400);
  // The menu sizes itself from the items' max lines, not from their layout: only a title that
  // doesn't fit on one line gets two.
  int maxLines(String title, {required bool hasIcon}) {
    // The menu's (12pt) and the item's (16pt) horizontal padding, and the icon with its 12pt gap.
    final width = kGlassMenuWidth - 2 * 12.0 - 2 * 16.0 - (hasIcon ? 20.0 + 12.0 : 0.0);
    final painter = TextPainter(
      text: TextSpan(text: title, style: titleStyle),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: 1,
    )..layout(maxWidth: width);
    final exceeds = painter.didExceedMaxLines;
    painter.dispose();
    return exceeds ? 2 : 1;
  }

  return [
    for (final action in actions)
      GlassMenuItem(
        title: action.label,
        titleStyle: titleStyle,
        maxLines: maxLines(action.label, hasIcon: isChoiceMenu || action.icon != null),
        icon: isChoiceMenu
            ? Icon(Icons.check, color: action.selected ? null : Colors.transparent)
            : action.icon != null
            ? Icon(action.icon)
            : null,
        enabled: action.onPressed != null,
        onTap: action.onPressed ?? () {},
      ),
  ];
}

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
        menuWidth: kGlassMenuWidth,
        settings: menuGlassSettings(context),
        semanticLabel: semanticsLabel,
        // The button is not glass itself: it sits in the glass capsule of the app bar.
        triggerBuilder: (context, toggleMenu) => buildButton(toggleMenu),
        items: glassMenuItems(context, actions),
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
              menuWidth: kGlassMenuWidth,
              settings: menuGlassSettings(context),
              items: glassMenuItems(context, widget.actions),
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

  /// Whether this is the current choice of a menu of choices, shown with a check mark: before the
  /// label in an iOS 26 menu ([glassMenuItems]), after it in a Material menu.
  final bool selected = false,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      child: MenuItemButton(
        closeOnActivate: dismissOnPress,
        leadingIcon: Icon(icon),
        trailingIcon: selected ? const Icon(Icons.check) : null,
        semanticsLabel: label,
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
