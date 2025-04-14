import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Platform agnostic button which is used for important actions.
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

/// Icon button with mandatory semantics.
class SemanticIconButton extends StatelessWidget {
  const SemanticIconButton({
    required this.icon,
    required this.onPressed,
    this.onLongPress,
    required this.semanticsLabel,
    this.color,
    this.iconSize,
    this.padding,
    super.key,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final String semanticsLabel;
  final Color? color;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: semanticsLabel,
      icon: icon,
      onPressed: onPressed,
      onLongPress: onLongPress,
      color: color,
      iconSize: iconSize,
      padding: padding,
    );
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
