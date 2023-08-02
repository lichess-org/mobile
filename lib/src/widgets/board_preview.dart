import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:chessground/chessground.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';

class SmallBoardPreview extends ConsumerStatefulWidget {
  const SmallBoardPreview({
    required this.orientation,
    required this.fen,
    required this.description,
    this.lastMove,
    this.onTap,
  });

  /// Side by which the board is oriented.
  final Side orientation;

  /// FEN string describing the position of the board.
  final String fen;

  /// Last move played, used to highlight corresponding squares.
  final Move? lastMove;

  final Widget description;

  final GestureTapCallback? onTap;

  @override
  ConsumerState<SmallBoardPreview> createState() => _SmallBoardPreviewState();
}

class _SmallBoardPreviewState extends ConsumerState<SmallBoardPreview> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final boardPrefs = ref.watch(boardPreferencesProvider);

    final content = LayoutBuilder(
      builder: (context, constraints) {
        final boardSize = constraints.biggest.shortestSide * 0.40;
        return Container(
          decoration: BoxDecoration(
            color: _isPressed
                ? CupertinoDynamicColor.resolve(
                    CupertinoColors.systemGrey5,
                    context,
                  )
                : null,
          ),
          child: Padding(
            padding: Styles.bodySectionPadding,
            child: SizedBox(
              height: boardSize,
              child: Row(
                children: [
                  Board(
                    size: boardSize,
                    data: BoardData(
                      interactableSide: InteractableSide.none,
                      fen: widget.fen,
                      orientation: widget.orientation,
                      lastMove: widget.lastMove,
                    ),
                    settings: BoardSettings(
                      enableCoordinates: false,
                      animationDuration: const Duration(milliseconds: 150),
                      pieceAssets: boardPrefs.pieceSet.assets,
                      colorScheme: boardPrefs.boardTheme.colors,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(child: widget.description),
                ],
              ),
            ),
          ),
        );
      },
    );

    return widget.onTap != null
        ? defaultTargetPlatform == TargetPlatform.iOS
            ? GestureDetector(
                onTapDown: (_) => setState(() => _isPressed = true),
                onTapUp: (_) => setState(() => _isPressed = false),
                onTapCancel: () => setState(() => _isPressed = false),
                onTap: widget.onTap,
                child: content,
              )
            : InkWell(
                onTap: widget.onTap,
                child: content,
              )
        : content;
  }
}
