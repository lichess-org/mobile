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

/// Wrapper that changes child's opacity when pressed.
class OpacityButton extends StatefulWidget {
  const OpacityButton({
    required this.child,
    required this.onPressed,
    this.semanticsLabel,
    super.key,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final String? semanticsLabel;

  @override
  State<OpacityButton> createState() => _OpacityButtonState();
}

class _OpacityButtonState extends State<OpacityButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      enabled: widget.onPressed != null,
      button: true,
      label: widget.semanticsLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown:
            widget.onPressed != null
                ? (_) {
                  setState(() => _isPressed = true);
                }
                : null,
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onPressed?.call();
        },
        onTapCancel: () {
          setState(() => _isPressed = false);
        },
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 100),
          opacity: _isPressed ? 0.5 : 1.0,
          child: widget.child,
        ),
      ),
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

class LoadingButtonBuilder<T> extends StatefulWidget {
  const LoadingButtonBuilder({required this.builder, required this.fetchData, super.key});

  final Future<T> Function() fetchData;

  final Widget Function(
    BuildContext context,
    AsyncSnapshot<T> snapshot,
    Future<T> Function() fetchData,
  )
  builder;

  @override
  State<LoadingButtonBuilder<T>> createState() => _LoadingButtonBuilderState();
}

class _LoadingButtonBuilderState<T> extends State<LoadingButtonBuilder<T>> {
  Future<T>? _future;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _future,
      builder: (context, snapshot) {
        return widget.builder(context, snapshot, () async {
          final future = widget.fetchData();
          setState(() {
            _future = future;
          });
          try {
            await future;
          } finally {
            _future = null;
          }
          return future;
        });
      },
    );
  }
}
