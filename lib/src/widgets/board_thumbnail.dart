import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';

/// A board thumbnail widget
class BoardThumbnail extends ConsumerStatefulWidget {
  const BoardThumbnail({
    required this.size,
    required this.orientation,
    required this.fen,
    this.header,
    this.footer,
    this.lastMove,
    this.onTap,
    this.animationDuration,
  });

  const BoardThumbnail.loading({required this.size, this.header, this.footer})
    : orientation = Side.white,
      fen = kInitialFEN,
      lastMove = null,
      onTap = null,
      animationDuration = null;

  /// Size of the board.
  final double size;

  /// Side by which the board is oriented.
  final Side orientation;

  /// FEN string describing the position of the board.
  final String fen;

  /// Last move played, used to highlight corresponding squares.
  final Move? lastMove;

  /// Show a header above the board. Typically a [Text] widget.
  final Widget? header;

  /// Show a footer above the board. Typically a [Text] widget.
  final Widget? footer;

  final GestureTapCallback? onTap;

  /// Optionally animate changes to the board by the specified duration.
  final Duration? animationDuration;

  @override
  _BoardThumbnailState createState() => _BoardThumbnailState();
}

class _BoardThumbnailState extends ConsumerState<BoardThumbnail> {
  double scale = 1.0;

  void _onTapDown() {
    if (widget.onTap == null) return;
    setState(() => scale = 0.98);
  }

  void _onTapCancel() {
    if (widget.onTap == null) return;
    setState(() => scale = 1.00);
  }

  @override
  Widget build(BuildContext context) {
    final boardPrefs = ref.watch(boardPreferencesProvider);

    final board =
        widget.animationDuration != null
            ? Chessboard.fixed(
              size: widget.size,
              fen: widget.fen,
              orientation: widget.orientation,
              lastMove: widget.lastMove as NormalMove?,
              settings: ChessboardSettings(
                enableCoordinates: false,
                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                boxShadow: boardShadows,
                animationDuration: widget.animationDuration!,
                pieceAssets: boardPrefs.pieceSet.assets,
                colorScheme: boardPrefs.boardTheme.colors,
                hue: boardPrefs.hue,
                brightness: boardPrefs.brightness,
              ),
            )
            : StaticChessboard(
              size: widget.size,
              fen: widget.fen,
              orientation: widget.orientation,
              lastMove: widget.lastMove as NormalMove?,
              enableCoordinates: false,
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              boxShadow: boardShadows,
              pieceAssets: boardPrefs.pieceSet.assets,
              colorScheme: boardPrefs.boardTheme.colors,
              hue: boardPrefs.hue,
              brightness: boardPrefs.brightness,
            );

    final maybeTappableBoard =
        widget.onTap != null
            ? GestureDetector(
              onTap: widget.onTap,
              onTapDown: (_) => _onTapDown(),
              onTapCancel: _onTapCancel,
              onTapUp: (_) => _onTapCancel(),
              child: AnimatedScale(
                scale: scale,
                duration: const Duration(milliseconds: 100),
                child: board,
              ),
            )
            : board;

    return widget.header != null || widget.footer != null
        ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.header != null) widget.header!,
            maybeTappableBoard,
            if (widget.footer != null) widget.footer!,
          ],
        )
        : maybeTappableBoard;
  }
}
