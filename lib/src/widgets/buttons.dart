import 'dart:async';

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

/// Icon button with mandatory semantics.
class const SemanticIconButton({
  required final Widget icon,
  required final VoidCallback? onPressed,
  final VoidCallback? onLongPress,
  required final String semanticsLabel,
  final Color? color,
  final double? iconSize,
  final EdgeInsetsGeometry? padding,
  super.key,
}) extends StatelessWidget {
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
class const OpacityButton({
  required final Widget child,
  required final VoidCallback? onPressed,
  final String? semanticsLabel,
  super.key,
}) extends StatefulWidget {
  @override
  State<OpacityButton> createState() => _OpacityButtonState();
}

class _OpacityButtonState() extends State<OpacityButton> {
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
        onTapDown: widget.onPressed != null
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
class const RepeatButton({
  /// function called on long press
  required final VoidCallback? onLongPress,
  required final Widget child,

  /// Delays between callbacks at the beginning. Leave default to get an acceleration effect.
  final List<Duration> triggerDelays = const [
    Duration(milliseconds: 200),
    Duration(milliseconds: 180),
    Duration(milliseconds: 100),
    Duration(milliseconds: 40),
  ],

  /// Delay between callbacks
  final Duration holdDelay = const Duration(milliseconds: 30),
}) extends StatefulWidget {
  @override
  _RepeatButtonState createState() => _RepeatButtonState();
}

class _RepeatButtonState() extends State<RepeatButton> {
  bool _isPressed = false;
  Timer? _holdTimer;

  @override
  void didUpdateWidget(RepeatButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the button becomes disabled mid-press stop the press
    if (oldWidget.onLongPress != null && widget.onLongPress == null) {
      _onPressEnd();
    }
  }

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
    return MergeSemantics(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPress: widget.onLongPress != null ? _onLongPress : null,
        onLongPressCancel: widget.onLongPress != null ? _onPressEnd : null,
        onLongPressUp: widget.onLongPress != null ? _onPressEnd : null,
        child: widget.child,
      ),
    );
  }
}

class const LoadingButtonBuilder<T>({
  required final Widget Function(
    BuildContext context,
    bool isLoading,
    Future<T> Function() fetchData,
  )
  builder,
  required final Future<T> Function() fetchData,
  final Future<T>? initialFuture,
  super.key,
}) extends StatefulWidget {
  @override
  State<LoadingButtonBuilder<T>> createState() => _LoadingButtonBuilderState();
}

class _LoadingButtonBuilderState<T>() extends State<LoadingButtonBuilder<T>> {
  Future<T>? _future;

  @override
  void initState() {
    super.initState();
    _future = widget.initialFuture;
  }

  @override
  void didUpdateWidget(LoadingButtonBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialFuture != widget.initialFuture) {
      _future = widget.initialFuture;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _future,
      builder: (context, snapshot) {
        return widget.builder(
          context,
          snapshot.connectionState == ConnectionState.waiting,
          () async {
            final future = widget.fetchData();
            setState(() {
              _future = future;
            });
            try {
              await future;
            } finally {
              _future = null;
            }
            return await future;
          },
        );
      },
    );
  }
}
