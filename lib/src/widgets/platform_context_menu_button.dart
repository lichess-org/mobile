import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoColors, CupertinoIcons, CupertinoTheme;
import 'package:flutter/services.dart';
import 'package:lichess_mobile/src/widgets/platform.dart' show ios27GlassSettings, useLiquidGlass;
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart'
    show
        GlassButton,
        GlassMenu,
        GlassMenuController,
        GlassMenuDivider,
        GlassMenuItem,
        GlassMenuLabel,
        LiquidRoundedSuperellipse;
import 'package:material_ui/material_ui.dart';

/// Width of the liquid glass context menus.
const kGlassMenuWidth = 250.0;

/// The items of a liquid glass context menu: one per action, with the [ContextMenuSection]s set
/// apart by separators.
///
/// In a menu with check marks (one of the actions is [ContextMenuAction.selected], or a
/// [ContextMenuAction.toggled] action), the check marks are on the leading edge, like in an iOS
/// menu: a checked action shows its check mark in place of its icon, and the labels of the actions
/// without an icon stay aligned with the checked ones. A toggle shows a checked circle when it is
/// on and an empty circle when it is off, like a radio button, so that it can't be mistaken for a
/// selected choice.
///
/// A title too long for one line wraps to two, like in an iOS menu.
List<Widget> glassMenuItems(BuildContext context, List<ContextMenuEntry> entries) {
  final isCheckMenu = _actionsOf(entries).any((action) => action._hasCheckMark);
  // The package's title style (the theme text color at 90%), with the line height the menu sizes
  // the items with (1.2, the app's is taller): the titles are measured with it.
  final textColor = (CupertinoTheme.of(context).textTheme.textStyle.color ?? CupertinoColors.label)
      .withValues(alpha: 0.9);
  final titleStyle = DefaultTextStyle.of(context).style
      .merge(TextStyle(color: textColor, fontSize: 17, fontWeight: FontWeight.w400, height: 1.2));
  // An iOS menu section title: footnote, in the secondary label color.
  final sectionTitleStyle = DefaultTextStyle.of(context).style.merge(
    TextStyle(color: textColor.withValues(alpha: 0.6), fontSize: 13, fontWeight: FontWeight.w400),
  );
  // The menu sizes itself from the items' max lines, not from their layout: only a title that
  // doesn't fit on one line gets two.
  int maxLines(String title, {required bool hasLeading, required bool hasChevron}) {
    // The menu's (12pt) and the item's (16pt) horizontal padding, the 20pt icon or check mark with
    // its 12pt gap, and the 16pt chevron of a submenu.
    final width =
        kGlassMenuWidth -
        2 * 12.0 -
        2 * 16.0 -
        (hasLeading ? 20.0 + 12.0 : 0.0) -
        (hasChevron ? 16.0 : 0.0);
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

  GlassMenuItem item(ContextMenuAction action) {
    final icon = action.icon;
    return GlassMenuItem(
      title: action.label,
      titleStyle: titleStyle,
      subtitle: action.subtitle,
      maxLines: maxLines(
        action.label,
        hasLeading: isCheckMenu || icon != null,
        hasChevron: action.submenu != null,
      ),
      icon: switch (action.toggled) {
        true => const Icon(CupertinoIcons.checkmark_circle_fill),
        false => const Icon(CupertinoIcons.circle),
        null when action.selected => const Icon(Icons.check),
        null =>
          icon != null
              ? Icon(icon)
              : isCheckMenu
              ? const Icon(Icons.check, color: Colors.transparent)
              : null,
      },
      enabled: action.onPressed != null || action.submenu != null,
      onTap: action.onPressed ?? () {},
      submenu: action.submenu != null ? glassMenuItems(context, action.submenu!) : null,
    );
  }

  return [
    for (final (index, entry) in entries.indexed)
      ...switch (entry) {
        final ContextMenuAction action => [
          if (index > 0 && entries[index - 1] is ContextMenuSection) const GlassMenuDivider(),
          item(action),
        ],
        ContextMenuSection(:final title, :final actions) => [
          if (index > 0) const GlassMenuDivider(),
          if (title != null)
            GlassMenuLabel(
              alignment: AlignmentDirectional.centerStart,
              child: Text(title, style: sectionTitleStyle, maxLines: 1, overflow: .ellipsis),
            ),
          for (final action in actions) item(action),
        ],
      },
  ];
}

/// The actions of the [entries] of a menu, those of its sections included.
Iterable<ContextMenuAction> _actionsOf(List<ContextMenuEntry> entries) => entries.expand(
  (entry) => switch (entry) {
    final ContextMenuAction action => [action],
    ContextMenuSection(:final actions) => actions,
  },
);

/// The items of a Material context menu: one per action, with the [ContextMenuSection]s set apart
/// by dividers.
///
/// In a group of choices (one of its actions is [ContextMenuAction.selected]), every action has a
/// leading space for the check mark, before its icon. A group is a [ContextMenuSection], or the
/// actions outside of the sections.
List<Widget> _materialMenuItems(BuildContext context, List<ContextMenuEntry> entries) {
  bool isChoiceGroup(Iterable<ContextMenuAction> actions) => actions.any((a) => a.selected);
  final isTopLevelChoiceGroup = isChoiceGroup(entries.whereType<ContextMenuAction>());
  return [
    for (final (index, entry) in entries.indexed)
      ...switch (entry) {
        final ContextMenuAction action => [
          if (index > 0 && entries[index - 1] is ContextMenuSection) const Divider(),
          _MaterialMenuAction(action: action, hasCheckMarkSpace: isTopLevelChoiceGroup),
        ],
        ContextMenuSection(:final title, :final actions) => [
          if (index > 0) const Divider(),
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 4.0),
              child: Text(
                title,
                style: TextTheme.of(context).labelMedium
                    ?.copyWith(color: ColorScheme.of(context).onSurfaceVariant),
              ),
            ),
          for (final action in actions)
            _MaterialMenuAction(action: action, hasCheckMarkSpace: isChoiceGroup(actions)),
        ],
      },
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
  required final List<ContextMenuEntry> actions,

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
        settings: ios27GlassSettings(context),
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
      menuChildren: _materialMenuItems(context, actions),
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

/// Height of a [ContextMenuTitleButton] on iOS 26 and later: the height of the app bar buttons.
const double _kGlassTitleButtonHeight = 44.0;

/// An app bar title that opens a context menu, such as a menu to switch to a sibling screen.
///
/// On iOS 26 and later, a liquid glass capsule with the [title] and a chevron, out of which the
/// menu morphs. Elsewhere, the [title] and a drop down arrow, opening a Material menu.
class const ContextMenuTitleButton({
  required final Widget title,
  required final String semanticsLabel,
  required final List<ContextMenuEntry> actions,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (useLiquidGlass(context)) {
      final foregroundColor = ColorScheme.of(context).onSurface;
      return GlassMenu(
        menuWidth: kGlassMenuWidth,
        settings: ios27GlassSettings(context),
        triggerBuilder: (context, toggleMenu) => Semantics(
          button: true,
          label: semanticsLabel,
          child: GlassButton.custom(
            onTap: toggleMenu,
            label: semanticsLabel,
            // The glass of the app bar buttons next to it.
            settings: ios27GlassSettings(context),
            height: _kGlassTitleButtonHeight,
            shape: const LiquidRoundedSuperellipse(borderRadius: _kGlassTitleButtonHeight / 2),
            // The app bar is isolated, there is no parent glass layer to share.
            useOwnLayer: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: IconTheme.merge(
                data: IconThemeData(color: foregroundColor),
                child: Row(
                  mainAxisSize: .min,
                  spacing: 6.0,
                  children: [
                    Flexible(child: title),
                    const Icon(CupertinoIcons.chevron_down, size: 14.0),
                  ],
                ),
              ),
            ),
          ),
        ),
        items: glassMenuItems(context, actions),
      );
    }

    return MenuAnchor(
      crossAxisUnconstrained: false,
      style: MenuStyle(
        maximumSize: WidgetStatePropertyAll(
          Size(MediaQuery.widthOf(context) * 0.8, MediaQuery.heightOf(context) * 0.8),
        ),
      ),
      menuChildren: _materialMenuItems(context, actions),
      builder: (BuildContext context, MenuController controller, Widget? child) => Semantics(
        button: true,
        label: semanticsLabel,
        child: InkWell(
          onTap: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisSize: .min,
              children: [
                Flexible(child: title),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A widget that opens a context menu where it is long pressed, such as a chat message.
///
/// On iOS 26 and later, the liquid glass menu of [ContextMenuIconButton] blooms from the press
/// point, and the finger can slide onto an action and lift to select it, like an iOS context menu.
/// Elsewhere it is a Material menu opened at the press point.
class const ContextMenuRegion({
  required final List<ContextMenuEntry> actions,
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
        menuChildren: _materialMenuItems(context, widget.actions),
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
              settings: ios27GlassSettings(context),
              items: glassMenuItems(context, widget.actions),
            ),
          ),
      ],
    );
  }
}

/// An entry of a [ContextMenuIconButton] or a [ContextMenuRegion] menu: a [ContextMenuAction] or a
/// [ContextMenuSection].
sealed class const ContextMenuEntry();

/// A group of actions of a context menu, set apart from the other entries by separators, with an
/// optional title, like an inline section of an iOS menu.
class const ContextMenuSection({
  final String? title,
  required final List<ContextMenuAction> actions,
}) implements ContextMenuEntry;

/// An action of a [ContextMenuIconButton] or a [ContextMenuRegion].
///
/// On iOS 26 and later, it is turned into a [GlassMenuItem] by the menu and never built.
class const ContextMenuAction({
  final IconData? icon,
  required final String label,

  /// A line below the label, such as the current choice of a [submenu].
  final String? subtitle,
  required final VoidCallback? onPressed,

  /// Whether the menu should be closed when an action is pressed (only on Android: an iOS menu
  /// item always closes the menu).
  ///
  /// Default to true.
  final bool dismissOnPress = true,

  /// Whether this is the current choice of a menu of choices, shown with a check mark before the
  /// label: in place of the [icon] in an iOS 26 menu ([glassMenuItems]), before it in a Material
  /// menu.
  final bool selected = false,

  /// Whether this action toggles a setting, and whether it is on, or null when it is not a toggle.
  ///
  /// On iOS 26 and later, the action has a checked circle before the label when it is on, and an
  /// empty circle when it is off, in place of its [icon]. Elsewhere it is a checkbox menu item.
  final bool? toggled,

  /// The entries of a submenu opened by this action, in place of [onPressed].
  ///
  /// On iOS 26 and later, a card that opens over the menu. Elsewhere a cascading Material menu.
  final List<ContextMenuEntry>? submenu,
}) extends StatelessWidget implements ContextMenuEntry {
  /// Whether this action shows its state with a check mark in an iOS 26 menu.
  bool get _hasCheckMark => selected || toggled != null;

  @override
  Widget build(BuildContext context) =>
      _MaterialMenuAction(action: this, hasCheckMarkSpace: selected);
}

/// A [ContextMenuAction] in a Material menu.
class const _MaterialMenuAction({
  required final ContextMenuAction action,

  /// Whether the action has a leading space for a check mark, before its icon, as in a menu of
  /// choices.
  required final bool hasCheckMarkSpace,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ContextMenuAction(:label, :subtitle, :icon, :selected) = action;
    final child = subtitle != null
        ? Column(
            crossAxisAlignment: .start,
            mainAxisSize: .min,
            children: [
              Text(label),
              Text(
                subtitle,
                style: TextTheme.of(context).bodySmall
                    ?.copyWith(color: ColorScheme.of(context).onSurfaceVariant),
              ),
            ],
          )
        : Text(label);
    if (action.toggled case final toggled?) {
      return CheckboxMenuButton(
        value: toggled,
        closeOnActivate: action.dismissOnPress,
        onChanged: action.onPressed != null ? (_) => action.onPressed!() : null,
        child: icon != null
            ? Row(
                mainAxisSize: .min,
                spacing: 12.0,
                children: [
                  Icon(icon),
                  Flexible(child: child),
                ],
              )
            : child,
      );
    }
    // The check mark before the icon. Without a check mark space, the icon or an empty space of the
    // same size.
    final leadingIcon = hasCheckMarkSpace
        ? Row(
            mainAxisSize: .min,
            spacing: 12.0,
            children: [
              Icon(Icons.check, color: selected ? null : Colors.transparent),
              if (icon != null) Icon(icon),
            ],
          )
        : Icon(icon);
    if (action.submenu case final submenu?) {
      return SubmenuButton(
        leadingIcon: leadingIcon,
        menuChildren: _materialMenuItems(context, submenu),
        child: child,
      );
    }
    return Semantics(
      selected: selected,
      child: MenuItemButton(
        closeOnActivate: action.dismissOnPress,
        leadingIcon: leadingIcon,
        semanticsLabel: label,
        onPressed: action.onPressed,
        child: child,
      ),
    );
  }
}
