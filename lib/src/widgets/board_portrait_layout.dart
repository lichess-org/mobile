import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Vertical stack for a board and its surrounding chrome in portrait mode.
///
/// The [above] and [below] slots are laid out first at their intrinsic size
/// (via loose constraints), then the board is sized to
/// `min(maxBoardWidth, maxHeight - above.height - below.height)` so it always
/// fits within the available vertical space. Any remaining height is split
/// evenly above and below the stack.
///
/// Use this instead of a [Column] with a fixed-size [BoardWidget] sibling
/// whenever the board needs to shrink to fit near-square constraints (e.g.
/// foldable inner displays).
///
/// The board slot is provided via [boardBuilder] so the computed size can be
/// forwarded to widgets that require an explicit `size` parameter.
///
/// Children passed to [above] and [below] should size themselves to their
/// intrinsic height (e.g. a `Column` with `mainAxisSize: MainAxisSize.min`).
/// Avoid `Expanded` or anything that greedily fills vertical space inside
/// these slots — that breaks measurement.
class BoardPortraitLayout extends StatelessWidget {
  const BoardPortraitLayout({
    super.key,
    this.above,
    required this.boardBuilder,
    this.below,
    this.maxBoardWidth,
  });

  final Widget? above;
  final Widget? below;

  /// Builds the board with the computed side length. The builder receives a
  /// square size that fits the remaining vertical space and [maxBoardWidth].
  final Widget Function(BuildContext context, double boardSize) boardBuilder;

  /// Optional explicit cap on board width. Defaults to the parent's
  /// `constraints.maxWidth`. Useful when horizontal padding should shrink the
  /// board.
  final double? maxBoardWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomMultiChildLayout(
          delegate: _BoardPortraitDelegate(maxBoardWidth: maxBoardWidth ?? constraints.maxWidth),
          children: [
            if (above != null) LayoutId(id: _Slot.above, child: above!),
            LayoutId(
              id: _Slot.board,
              child: LayoutBuilder(builder: (ctx, c) => boardBuilder(ctx, c.maxWidth)),
            ),
            if (below != null) LayoutId(id: _Slot.below, child: below!),
          ],
        );
      },
    );
  }
}

enum _Slot { above, board, below }

class _BoardPortraitDelegate extends MultiChildLayoutDelegate {
  _BoardPortraitDelegate({required this.maxBoardWidth});

  final double maxBoardWidth;

  @override
  void performLayout(Size size) {
    final aboveSize = hasChild(_Slot.above)
        ? layoutChild(_Slot.above, BoxConstraints.loose(size))
        : Size.zero;
    final belowMaxHeight = math.max(0.0, size.height - aboveSize.height);
    final belowSize = hasChild(_Slot.below)
        ? layoutChild(_Slot.below, BoxConstraints.loose(Size(size.width, belowMaxHeight)))
        : Size.zero;

    final availableHeight = math.max(0.0, size.height - aboveSize.height - belowSize.height);
    final boardSide = math.max(0.0, math.min(math.min(size.width, maxBoardWidth), availableHeight));
    layoutChild(_Slot.board, BoxConstraints.tight(Size(boardSide, boardSide)));

    final usedHeight = aboveSize.height + boardSide + belowSize.height;
    final extra = math.max(0.0, size.height - usedHeight);
    var y = extra / 2;

    if (hasChild(_Slot.above)) {
      positionChild(_Slot.above, Offset((size.width - aboveSize.width) / 2, y));
      y += aboveSize.height;
    }
    positionChild(_Slot.board, Offset((size.width - boardSide) / 2, y));
    y += boardSide;
    if (hasChild(_Slot.below)) {
      positionChild(_Slot.below, Offset((size.width - belowSize.width) / 2, y));
    }
  }

  @override
  bool shouldRelayout(_BoardPortraitDelegate oldDelegate) =>
      maxBoardWidth != oldDelegate.maxBoardWidth;
}
