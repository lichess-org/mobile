import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:popover/popover.dart';

/// Platform agnostic button which is used for important actions.
///
/// Will use an [FilledButton] on Android and a [CupertinoButton.tinted] on iOS.
class FatButton extends StatelessWidget {
  const FatButton({
    required this.semanticsLabel,
    required this.child,
    required this.onPressed,
    super.key,
  });

  final String semanticsLabel;
  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      enabled: true,
      button: true,
      label: semanticsLabel,
      excludeSemantics: true,
      child:
          Theme.of(context).platform == TargetPlatform.iOS
              ? CupertinoButton.tinted(onPressed: onPressed, child: child)
              : FilledButton(onPressed: onPressed, child: child),
    );
  }
}

/// Platform agnostic button meant for medium importance actions.
class SecondaryButton extends StatefulWidget {
  const SecondaryButton({
    required this.semanticsLabel,
    required this.child,
    required this.onPressed,
    this.textStyle,
    this.glowing = false,
    super.key,
  });

  final String semanticsLabel;
  final VoidCallback? onPressed;
  final Widget child;
  final TextStyle? textStyle;
  final bool glowing;

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _animation = (defaultTargetPlatform == TargetPlatform.iOS
          ? Tween<double>(begin: 0.5, end: 1.0)
          : Tween<double>(begin: 0.0, end: 0.3))
      .animate(_controller)..addListener(() {
      setState(() {});
    });

    if (widget.glowing) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(SecondaryButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.glowing != oldWidget.glowing) {
      if (widget.glowing) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      enabled: true,
      button: true,
      label: widget.semanticsLabel,
      excludeSemantics: true,
      child:
          Theme.of(context).platform == TargetPlatform.iOS
              ? CupertinoButton(
                color:
                    widget.glowing
                        ? CupertinoTheme.of(
                          context,
                        ).primaryColor.withValues(alpha: _animation.value)
                        : null,
                onPressed: widget.onPressed,
                child: widget.child,
              )
              : OutlinedButton(
                onPressed: widget.onPressed,
                style: OutlinedButton.styleFrom(
                  textStyle: widget.textStyle,
                  backgroundColor:
                      widget.glowing
                          ? Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: _animation.value)
                          : null,
                ),
                child: widget.child,
              ),
    );
  }
}

/// Platform agnostic text button to appear in the app bar.
class AppBarTextButton extends StatelessWidget {
  const AppBarTextButton({required this.child, required this.onPressed, super.key});

  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS
        ? CupertinoButton(padding: EdgeInsets.zero, onPressed: onPressed, child: child)
        : TextButton(onPressed: onPressed, child: child);
  }
}

/// Platform agnostic icon button to appear in the app bar.
class AppBarIconButton extends StatelessWidget {
  const AppBarIconButton({
    required this.icon,
    required this.onPressed,
    required this.semanticsLabel,
    super.key,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS
        ? CupertinoIconButton(
          padding: EdgeInsets.zero,
          semanticsLabel: semanticsLabel,
          onPressed: onPressed,
          icon: icon,
        )
        : IconButton(tooltip: semanticsLabel, icon: icon, onPressed: onPressed);
  }
}

/// Platform agnostic icon button to appear in the app bar, that has a notification bubble.
class AppBarNotificationIconButton extends StatelessWidget {
  const AppBarNotificationIconButton({
    required this.icon,
    required this.onPressed,
    required this.semanticsLabel,
    required this.count,
    this.color,
    super.key,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final String semanticsLabel;
  final Color? color;
  final int count;

  @override
  Widget build(BuildContext context) {
    return AppBarIconButton(
      icon: Badge.count(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        textStyle: TextStyle(
          color: Theme.of(context).colorScheme.onTertiary,
          fontWeight: FontWeight.bold,
        ),
        count: count,
        isLabelVisible: count > 0,
        child: icon,
      ),
      onPressed: onPressed,
      semanticsLabel: semanticsLabel,
    );
  }
}

class AdaptiveTextButton extends StatelessWidget {
  const AdaptiveTextButton({required this.child, required this.onPressed, super.key});

  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS
        ? CupertinoButton(onPressed: onPressed, child: child)
        : TextButton(onPressed: onPressed, child: child);
  }
}

/// Button that explicitly reduce padding, thus does not conform to accessibility
/// guidelines. So use sparingly.
class NoPaddingTextButton extends StatelessWidget {
  const NoPaddingTextButton({required this.child, required this.onPressed, super.key});

  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS
        ? CupertinoButton(padding: EdgeInsets.zero, onPressed: onPressed, minSize: 23, child: child)
        : TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: child,
        );
  }
}

/// Cupertino icon button with mandatory semantics label
class CupertinoIconButton extends StatelessWidget {
  const CupertinoIconButton({
    required this.onPressed,
    required this.semanticsLabel,
    required this.icon,
    this.padding,
    super.key,
  });
  final VoidCallback? onPressed;
  final Widget icon;
  final String semanticsLabel;

  /// The amount of space to surround the child inside the bounds of the button.
  ///
  /// Defaults to 16.0 pixels.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      enabled: true,
      button: true,
      label: semanticsLabel,
      excludeSemantics: true,
      child: CupertinoButton(
        padding: padding,
        onPressed: onPressed,
        child: IconTheme.merge(data: const IconThemeData(size: 24.0), child: icon),
      ),
    );
  }
}

/// InkWell that adapts to the iOS platform.
///
/// Used to create a button that shows a ripple on Android and a highlight on iOS.
class AdaptiveInkWell extends StatelessWidget {
  const AdaptiveInkWell({
    required this.child,
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onLongPress,
    this.borderRadius,
    this.splashColor,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCancelCallback? onTapCancel;
  final VoidCallback? onLongPress;
  final BorderRadius? borderRadius;
  final Color? splashColor;

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    return InkWell(
      onTap: onTap,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      onLongPress: onLongPress,
      borderRadius: borderRadius,
      splashColor:
          platform == TargetPlatform.iOS
              ? splashColor ?? CupertinoColors.systemGrey5.resolveFrom(context)
              : splashColor,
      splashFactory: platform == TargetPlatform.iOS ? NoSplash.splashFactory : null,
      child: child,
    );
  }
}

/// Button to repeatedly call a funtion, triggered after a long press.
///
/// This widget is just a wrapper, the visuals are delegated to the child widget.
///
/// ### Notes
/// Child widgets with a `tooltip` already have an `onLongPress` callback that will
/// conflict.
/// `onTap` callback should be handled by the child widget.
class RepeatButton extends StatefulWidget {
  const RepeatButton({
    required this.onLongPress,
    required this.child,
    this.triggerDelays = const [
      Duration(milliseconds: 500),
      Duration(milliseconds: 300),
      Duration(milliseconds: 250),
      Duration(milliseconds: 150),
    ],
    this.holdDelay = const Duration(milliseconds: 30),
  });

  final Widget child;

  /// function called on long press
  final VoidCallback? onLongPress;

  /// Delays between callbacks at the beginning. Leave default to get an acceleration effect.
  /// The maximum length of the list is 3
  final List<Duration> triggerDelays;

  /// Delay between callbacks
  final Duration holdDelay;

  @override
  _RepeatButtonState createState() => _RepeatButtonState();
}

class _RepeatButtonState extends State<RepeatButton> {
  bool _isPressed = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _onLongPress() async {
    _isPressed = true;

    HapticFeedback.selectionClick();

    widget.onLongPress?.call();

    for (final time in widget.triggerDelays) {
      await Future.delayed(time, () {});
      if (!_isPressed) return;
      widget.onLongPress?.call();
    }

    _timer = Timer.periodic(widget.holdDelay, (_) {
      if (_isPressed) {
        widget.onLongPress?.call();
      }
    });
  }

  void _onPressEnd() {
    _isPressed = false;
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: _onLongPress,
      onLongPressCancel: _onPressEnd,
      onLongPressUp: _onPressEnd,
      child: widget.child,
    );
  }
}

/// Platform agnostic icon button
///
/// Optionally provide a bool to highlight the button
/// Will use [IconButton] on Android and [CupertinoIconButton] on iOS.
class PlatformIconButton extends StatelessWidget {
  const PlatformIconButton({
    required this.icon,
    required this.semanticsLabel,
    required this.onTap,
    this.highlighted = false,
    this.color,
    this.iconSize,
    this.padding,
  }) : assert(color == null || !highlighted, 'Cannot provide both color and highlighted');

  final IconData icon;
  final String semanticsLabel;
  final VoidCallback? onTap;
  final bool highlighted;
  final Color? color;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
        final themeData = Theme.of(context);
        return Theme(
          data: themeData,
          child: IconButton(
            onPressed: onTap,
            icon: Icon(icon),
            tooltip: semanticsLabel,
            color: highlighted ? themeData.colorScheme.primary : color,
            iconSize: iconSize,
            padding: padding,
          ),
        );
      case TargetPlatform.iOS:
        final themeData = CupertinoTheme.of(context);
        return CupertinoTheme(
          data: themeData.copyWith(primaryColor: themeData.textTheme.textStyle.color),
          child: CupertinoIconButton(
            onPressed: onTap,
            semanticsLabel: semanticsLabel,
            padding: padding,
            icon: Icon(icon, color: highlighted ? themeData.primaryColor : color, size: iconSize),
          ),
        );
      default:
        assert(false, 'Unexpected Platform ${Theme.of(context).platform}');
        return const SizedBox.shrink();
    }
  }
}

const _kMenuWidth = 250.0;
const Color _kBorderColor = CupertinoDynamicColor.withBrightness(
  color: Color(0xFFA9A9AF),
  darkColor: Color(0xFF57585A),
);

/// A platform agnostic menu button for the app bar.
class PlatformAppBarMenuButton extends StatelessWidget {
  const PlatformAppBarMenuButton({
    required this.icon,
    required this.semanticsLabel,
    required this.actions,
    super.key,
  });

  final Widget icon;
  final String semanticsLabel;
  final List<AppBarMenuAction> actions;

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      final menuActions =
          actions.map((action) {
            return CupertinoContextMenuAction(
              onPressed: () {
                if (action.dismissOnPress) {
                  Navigator.of(context).pop();
                }
                action.onPressed();
              },
              trailingIcon: action.icon,
              child: Text(action.label),
            );
          }).toList();
      return AppBarIconButton(
        onPressed: () {
          showPopover(
            context: context,
            bodyBuilder: (context) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: _kMenuWidth,
                  child: IntrinsicHeight(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(13.0)),
                      child: ColoredBox(
                        color: CupertinoDynamicColor.resolve(
                          CupertinoContextMenu.kBackgroundColor,
                          context,
                        ),
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                          child: CupertinoScrollbar(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  menuActions.first,
                                  for (final Widget action in menuActions.skip(1))
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
            direction: PopoverDirection.top,
            width: _kMenuWidth,
            backgroundColor: Colors.transparent,
          );
        },
        semanticsLabel: semanticsLabel,
        icon: icon,
      );
    }

    return MenuAnchor(
      menuChildren:
          actions.map((action) {
            return MenuItemButton(
              leadingIcon: Icon(action.icon),
              semanticsLabel: action.label,
              closeOnActivate: action.dismissOnPress,
              onPressed: action.onPressed,
              child: Text(action.label),
            );
          }).toList(),
      builder: (BuildContext context, MenuController controller, Widget? child) {
        return AppBarIconButton(
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

class AppBarMenuAction {
  const AppBarMenuAction({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.dismissOnPress = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  /// Whether the modal should be dismissed when an action is pressed.
  ///
  /// Default to true.
  final bool dismissOnPress;
}
