import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:popover/popover.dart';

const Color _kBorderColor = CupertinoDynamicColor.withBrightness(
  color: Color(0xFFA9A9AF),
  darkColor: Color(0xFF57585A),
);

/// A platform agnostic context menu icon button.
///
/// Typically used in the [AppBar] to show a context menu.
class ContextMenuIconButton extends StatelessWidget {
  const ContextMenuIconButton({
    required this.icon,
    required this.semanticsLabel,
    required this.actions,
    this.consumeOutsideTap = false,
    super.key,
  });

  final Widget icon;
  final String semanticsLabel;
  final List<Widget> actions;

  /// Whether to consume taps outside the menu to close it (only on Android).
  final bool consumeOutsideTap;

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return SemanticIconButton(
        onPressed: () {
          showPopover(
            context: context,
            barrierColor: Colors.transparent,
            shadow: const [],
            bodyBuilder: (context) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.sizeOf(context).height * 0.8,
                    minWidth: MediaQuery.sizeOf(context).width * 0.4,
                    maxWidth: MediaQuery.sizeOf(context).width * 0.6,
                  ),
                  child: IntrinsicHeight(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(13.0)),
                      child: ColoredBox(
                        color:
                            MenuTheme.of(
                              context,
                            ).style?.backgroundColor?.resolve({WidgetState.focused}) ??
                            ColorScheme.of(context).surfaceContainer,
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                          child: CupertinoScrollbar(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  actions.first,
                                  for (final Widget action in actions.skip(1))
                                    DecoratedBox(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                            color: CupertinoDynamicColor.resolve(
                                              _kBorderColor,
                                              context,
                                            ),
                                            width: 0.4,
                                          ),
                                        ),
                                      ),
                                      position: DecorationPosition.foreground,
                                      child: action,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            arrowWidth: 0.0,
            arrowHeight: 0.0,
            direction: PopoverDirection.bottom,
            backgroundColor: Colors.transparent,
          );
        },
        semanticsLabel: semanticsLabel,
        icon: icon,
      );
    }

    return MenuAnchor(
      crossAxisUnconstrained: false,
      consumeOutsideTap: consumeOutsideTap,
      style: MenuStyle(
        maximumSize: WidgetStatePropertyAll(
          Size(MediaQuery.sizeOf(context).width * 0.6, MediaQuery.sizeOf(context).height * 0.8),
        ),
      ),
      menuChildren: actions,
      builder: (BuildContext context, MenuController controller, Widget? child) {
        return SemanticIconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          semanticsLabel: semanticsLabel,
          icon: icon,
        );
      },
    );
  }
}

class ContextMenuAction extends StatelessWidget {
  const ContextMenuAction({
    this.icon,
    required this.label,
    required this.onPressed,
    this.dismissOnPress = true,
  });

  final IconData? icon;
  final String label;
  final VoidCallback? onPressed;

  /// Whether the modal should be dismissed when an action is pressed.
  ///
  /// Default to true.
  final bool dismissOnPress;

  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS
        ? _CupertinoContextMenuAction(
            trailingIcon: icon,
            onPressed: () {
              if (dismissOnPress) {
                Navigator.of(context).pop();
              }
              onPressed?.call();
            },
            // trailingIcon: icon,
            child: Text(label),
          )
        : MenuItemButton(
            closeOnActivate: dismissOnPress,
            leadingIcon: Icon(icon),
            semanticsLabel: label,
            onPressed: onPressed,
            child: Text(label),
          );
  }
}

// --
// Copied from: https://github.com/flutter/flutter/blob/stable/packages/flutter/lib/src/cupertino/context_menu_action.dart
// and adapted to use with lichess colors.

/// A button in a _ContextMenuSheet.
///
/// A typical use case is to pass a [Text] as the [child] here, but be sure to
/// use [TextOverflow.ellipsis] for the [Text.overflow] field if the text may be
/// long, as without it the text will wrap to the next line.
class _CupertinoContextMenuAction extends StatefulWidget {
  /// Construct a _CupertinoContextMenuAction.
  const _CupertinoContextMenuAction({
    // ignore: unused_element_parameter
    super.key,
    required this.child,
    // ignore: unused_element_parameter
    this.isDefaultAction = false,
    // ignore: unused_element_parameter
    this.isDestructiveAction = false,
    this.onPressed,
    this.trailingIcon,
  });

  /// The widget that will be placed inside the action.
  final Widget child;

  /// Indicates whether this action should receive the style of an emphasized,
  /// default action.
  final bool isDefaultAction;

  /// Indicates whether this action should receive the style of a destructive
  /// action.
  final bool isDestructiveAction;

  /// Called when the action is pressed.
  final VoidCallback? onPressed;

  /// An optional icon to display to the right of the child.
  ///
  /// Will be colored in the same way as the [TextStyle] used for [child] (for
  /// example, if using [isDestructiveAction]).
  final IconData? trailingIcon;

  @override
  State<_CupertinoContextMenuAction> createState() => _CupertinoContextMenuActionState();
}

class _CupertinoContextMenuActionState extends State<_CupertinoContextMenuAction> {
  static const double _kButtonHeight = 43;
  static const TextStyle _kActionSheetActionStyle = TextStyle(
    fontFamily: 'CupertinoSystemText',
    inherit: false,
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: CupertinoColors.black,
    textBaseline: TextBaseline.alphabetic,
  );

  final GlobalKey _globalKey = GlobalKey();
  bool _isPressed = false;

  void onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
  }

  void onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  TextStyle get _textStyle {
    if (widget.isDefaultAction) {
      return _kActionSheetActionStyle.copyWith(
        color: CupertinoDynamicColor.resolve(CupertinoColors.label, context),
        fontWeight: FontWeight.w600,
      );
    }
    if (widget.isDestructiveAction) {
      return _kActionSheetActionStyle.copyWith(color: CupertinoColors.destructiveRed);
    }
    return _kActionSheetActionStyle.copyWith(
      color: CupertinoDynamicColor.resolve(CupertinoColors.label, context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _globalKey,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      onTap: widget.onPressed,
      behavior: HitTestBehavior.opaque,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: _kButtonHeight),
        child: Semantics(
          button: true,
          child: ColoredBox(
            color: _isPressed
                ? ColorScheme.of(context).surfaceContainerHighest
                : ColorScheme.of(context).surfaceContainer,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15.5, 8.0, 17.5, 8.0),
              child: DefaultTextStyle(
                style: _textStyle,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(child: widget.child),
                    if (widget.trailingIcon != null)
                      Icon(widget.trailingIcon, color: _textStyle.color, size: 21.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
