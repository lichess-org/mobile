import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart' as dc;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';

/// A board preview with a description.
class SmallBoardPreview extends ConsumerStatefulWidget {
  const SmallBoardPreview({
    required this.orientation,
    required this.fen,
    required this.description,
    this.padding,
    this.lastMove,
    this.onTap,
  });

  /// Side by which the board is oriented.
  final dc.Side orientation;

  /// FEN string describing the position of the board.
  final String fen;

  /// Last move played, used to highlight corresponding squares.
  final Move? lastMove;

  final Widget description;

  final GestureTapCallback? onTap;

  final EdgeInsetsGeometry? padding;

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
        final boardSize = constraints.biggest.shortestSide -
            (constraints.biggest.shortestSide / 1.618);
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
            padding: widget.padding ??
                Styles.horizontalBodyPadding
                    .add(const EdgeInsets.symmetric(vertical: 8.0)),
            child: SizedBox(
              height: boardSize,
              child: Row(
                children: [
                  Chessboard(
                    size: boardSize,
                    state: ChessboardState(
                      interactableSide: InteractableSide.none,
                      fen: widget.fen,
                      orientation: widget.orientation,
                      lastMove: widget.lastMove,
                    ),
                    settings: ChessboardSettings(
                      enableCoordinates: false,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4.0)),
                      boxShadow: boardShadows,
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
        ? Theme.of(context).platform == TargetPlatform.iOS
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
