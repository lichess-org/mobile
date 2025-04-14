import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      child: FilledButton(onPressed: onPressed, child: child),
    );
  }
}

/// Platform agnostic button meant for medium importance actions.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    required this.semanticsLabel,
    required this.child,
    required this.onPressed,
    this.textStyle,
    super.key,
  });

  final String semanticsLabel;
  final VoidCallback? onPressed;
  final Widget child;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      enabled: true,
      button: true,
      label: semanticsLabel,
      excludeSemantics: true,
      child: FilledButton.tonal(onPressed: onPressed, child: child),
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
    return TextButton(onPressed: onPressed, child: child);
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
    return IconButton(tooltip: semanticsLabel, icon: icon, onPressed: onPressed);
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
      icon: Badge.count(count: count, isLabelVisible: count > 0, child: icon),
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
    return TextButton(onPressed: onPressed, child: child);
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
    return TextButton(
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
    final inkWell = InkWell(
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

    return platform == TargetPlatform.iOS
        ? Material(color: Colors.transparent, child: inkWell)
        : inkWell;
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
      Duration(milliseconds: 200),
      Duration(milliseconds: 180),
      Duration(milliseconds: 100),
      Duration(milliseconds: 40),
    ],
    this.holdDelay = const Duration(milliseconds: 30),
  });

  final Widget child;

  /// function called on long press
  final VoidCallback? onLongPress;

  /// Delays between callbacks at the beginning. Leave default to get an acceleration effect.
  final List<Duration> triggerDelays;

  /// Delay between callbacks
  final Duration holdDelay;

  @override
  _RepeatButtonState createState() => _RepeatButtonState();
}

class _RepeatButtonState extends State<RepeatButton> {
  bool _isPressed = false;
  Timer? _holdTimer;

  @override
  void dispose() {
    _holdTimer?.cancel();
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

    _holdTimer = Timer.periodic(widget.holdDelay, (_) {
      if (_isPressed) {
        widget.onLongPress?.call();
      }
    });
  }

  void _onPressEnd() {
    _isPressed = false;
    _holdTimer?.cancel();
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

/// Platform agnostic icon button.
///
/// Optionally provide a bool to highlight the button
class PlatformIconButton extends StatelessWidget {
  const PlatformIconButton({
    required this.icon,
    required this.semanticsLabel,
    required this.onPressed,
    this.onLongPress,
    this.highlighted = false,
    this.color,
    this.iconSize,
    this.padding,
  }) : assert(color == null || !highlighted, 'Cannot provide both color and highlighted');

  final IconData icon;
  final String semanticsLabel;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final bool highlighted;
  final Color? color;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Theme(
      data: themeData,
      child: IconButton(
        onPressed: onPressed,
        onLongPress: onLongPress,
        icon: Icon(icon),
        tooltip: semanticsLabel,
        color: highlighted ? themeData.colorScheme.primary : color,
        iconSize: iconSize,
        padding: padding,
      ),
    );
  }
}
