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

      return Slidable(
        dragStartBehavior: DragStartBehavior.start,
        startActionPane: startActions.isNotEmpty
            ? ActionPane(
                motion: const StretchMotion(),
                extentRatio: extentRatio,
                children: startActions.map(slidableAction).toList(),
              )
            : null,
        // A pane lays out its actions from left to right: the outermost end action comes last.
        endActionPane: endActions.isNotEmpty
            ? ActionPane(
                motion: const StretchMotion(),
                extentRatio: extentRatio,
                children: endActions.reversed.map(slidableAction).toList(),
              )
            : null,
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
