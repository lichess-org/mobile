import 'package:flutter/gestures.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lichess_mobile/src/widgets/platform.dart' show useLiquidGlass;
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart'
    show GlassSwipeAction, GlassSwipeActionScope, GlassSwipeActionStyle, GlassSwipeActions;
import 'package:material_ui/material_ui.dart';

/// An action of [SwipeActions], revealed by swiping its row.
class const SwipeAction({
  required final IconData icon,
  required final String label,
  required final VoidCallback onPressed,
  required final Color backgroundColor,

  /// The color of the icon and label.
  ///
  /// Defaults to white on iOS 26 and later, and to a color contrasting with [backgroundColor]
  /// elsewhere.
  final Color? foregroundColor,
});

/// A row that reveals [startActions] and [endActions] when swiped horizontally.
///
/// On iOS 26 and later, it is a [GlassSwipeActions] with circular buttons; elsewhere, a
/// [Slidable]. Put the rows of a list in a [SwipeActionsScope] so that only one of them is open at
/// a time.
class const SwipeActions({
  required final Widget child,

  /// The actions revealed by swiping from the start edge, from the edge inwards.
  final List<SwipeAction> startActions = const [],

  /// The actions revealed by swiping from the end edge, from the edge inwards.
  final List<SwipeAction> endActions = const [],

  /// Whether swiping the row far enough runs its outermost action, the first one of
  /// [startActions] or [endActions] (only on iOS 26 and later).
  ///
  /// Turn it off when that action cannot be undone. Defaults to true.
  final bool allowsFullSwipe = true,

  /// The part of the row width taken by each open pane of actions (only before iOS 26).
  ///
  /// Defaults to 0.5.
  final double extentRatio = 0.5,

  /// Whether to show the label of the actions under their icon (only on iOS 26 and later). Hidden
  /// labels stay available to screen readers.
  final bool showLabels = true,

  /// Only claim drags that reveal or close the end actions, leaving other horizontal drags to an
  /// enclosing page view (only before iOS 26).
  ///
  /// Has no effect unless [startActions] is empty and [endActions] is not. Defaults to false.
  final bool restrictSwipeToEndActions = false,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (startActions.isEmpty && endActions.isEmpty) {
      return child;
    }

    if (!useLiquidGlass(context)) {
      SlidableAction slidableAction(SwipeAction action) => SlidableAction(
        icon: action.icon,
        label: action.label,
        onPressed: (_) => action.onPressed(),
        backgroundColor: action.backgroundColor,
        foregroundColor: action.foregroundColor,
      );

      final startPane = startActions.isNotEmpty
          ? ActionPane(
              motion: const StretchMotion(),
              extentRatio: extentRatio,
              children: startActions.map(slidableAction).toList(),
            )
          : null;
      // A pane lays out its actions from left to right: the outermost end action comes last.
      final endPane = endActions.isNotEmpty
          ? ActionPane(
              motion: const StretchMotion(),
              extentRatio: extentRatio,
              children: endActions.reversed.map(slidableAction).toList(),
            )
          : null;

      if (restrictSwipeToEndActions && startPane == null && endPane != null) {
        return _EndActionsOnlySlidable(endActionPane: endPane, child: child);
      }

      return Slidable(
        dragStartBehavior: DragStartBehavior.start,
        startActionPane: startPane,
        endActionPane: endPane,
        child: child,
      );
    }

    GlassSwipeAction glassAction(SwipeAction action) => GlassSwipeAction(
      icon: Icon(action.icon),
      label: showLabels ? Text(action.label) : null,
      semanticLabel: action.label,
      onTap: action.onPressed,
      backgroundColor: action.backgroundColor,
      foregroundColor: action.foregroundColor ?? Colors.white,
    );

    return GlassSwipeActions(
      style: GlassSwipeActionStyle.solidVibrancy,
      allowsFullSwipe: allowsFullSwipe,
      leadingActions: startActions.map(glassAction).toList(),
      trailingActions: endActions.map(glassAction).toList(),
      child: child,
    );
  }
}

/// Closes the open [SwipeActions] row of a list when another one is swiped, the list is scrolled
/// or something else is tapped.
///
/// On iOS 26 and later, it is a [GlassSwipeActionScope]; elsewhere it does nothing.
class const SwipeActionsScope({required final Widget child, super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return useLiquidGlass(context) ? GlassSwipeActionScope(child: child) : child;
  }
}

/// A [Slidable] that only claims gestures which reveal or close its end actions.
///
/// The recognizer ignores rightward drags while the pane is closed so an enclosing page view can
/// use them. It mirrors [Slidable]'s own gesture detector, which claims every horizontal drag.
class const _EndActionsOnlySlidable({
  required final ActionPane endActionPane,
  required final Widget child,
}) extends StatefulWidget {
  @override
  State<_EndActionsOnlySlidable> createState() => _EndActionsOnlySlidableState();
}

class _EndActionsOnlySlidableState()
    extends State<_EndActionsOnlySlidable>
    with TickerProviderStateMixin {
  late final SlidableController _controller = SlidableController(this);
  double _dragExtent = 0;
  double _rowWidth = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory>{
        _EndActionsDragGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<_EndActionsDragGestureRecognizer>(
              () => _EndActionsDragGestureRecognizer(
                isPaneOpen: () => _controller.ratio < 0,
                debugOwner: this,
              ),
              (recognizer) {
                recognizer
                  ..onStart = _handleDragStart
                  ..onUpdate = _handleDragUpdate
                  ..onEnd = _handleDragEnd
                  ..dragStartBehavior = DragStartBehavior.start
                  ..gestureSettings = MediaQuery.maybeGestureSettingsOf(context);
              },
            ),
      },
      behavior: HitTestBehavior.opaque,
      child: Slidable(
        enabled: false,
        controller: _controller,
        endActionPane: widget.endActionPane,
        child: widget.child,
      ),
    );
  }

  void _handleDragStart(DragStartDetails details) {
    _rowWidth = context.size?.width ?? 0;
    _dragExtent = _rowWidth * _controller.ratio;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _dragExtent += details.primaryDelta ?? 0;
    if (_rowWidth > 0) {
      _controller.ratio = _dragExtent / _rowWidth;
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    final openThreshold = widget.endActionPane.extentRatio / 2;
    final shouldOpen = velocity < 0 || (velocity == 0 && _controller.ratio.abs() >= openThreshold);
    if (shouldOpen) {
      _controller.openEndActionPane();
    } else {
      _controller.close();
    }
  }
}

/// A horizontal drag recognizer that only accepts drags revealing the end actions, or closing an
/// already open pane. Movement predominantly along the vertical axis is left to the scrollable.
class _EndActionsDragGestureRecognizer({
  required final bool Function() isPaneOpen,
  super.debugOwner,
}) extends HorizontalDragGestureRecognizer {
  Offset _globalOffset = Offset.zero;

  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerMoveEvent) {
      _globalOffset += event.delta;
    } else if (event is PointerPanZoomUpdateEvent) {
      _globalOffset += event.panDelta;
    }
    super.handleEvent(event);
  }

  @override
  void didStopTrackingLastPointer(int pointer) {
    _globalOffset = Offset.zero;
    super.didStopTrackingLastPointer(pointer);
  }

  @override
  bool hasSufficientGlobalDistanceToAccept(
    PointerDeviceKind pointerDeviceKind,
    double? deviceTouchSlop,
  ) {
    final isDominantHorizontal = _globalOffset.dx.abs() > _globalOffset.dy.abs();
    final claimsDrag = _globalOffset.dx < 0 || isPaneOpen();
    return isDominantHorizontal &&
        claimsDrag &&
        super.hasSufficientGlobalDistanceToAccept(pointerDeviceKind, deviceTouchSlop);
  }
}
