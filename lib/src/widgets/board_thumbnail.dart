import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';

/// A board thumbnail widget
class BoardThumbnail extends ConsumerStatefulWidget {
  const BoardThumbnail({
    required this.size,
    required this.orientation,
    required this.fen,
    this.showEvaluationBar = false,
    this.whiteWinningChances,
    this.header,
    this.footer,
    this.lastMove,
    this.onTap,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  const BoardThumbnail.loading({
    required this.size,
    this.header,
    this.footer,
    this.showEvaluationBar = false,
  }) : whiteWinningChances = null,
       orientation = Side.white,
       fen = kInitialFEN,
       lastMove = null,
       animationDuration = const Duration(milliseconds: 200),
       onTap = null;

  /// Size of the board.
  final double size;

  /// Side by which the board is oriented.
  final Side orientation;

  /// FEN string describing the position of the board.
  final String fen;

  /// Whether the evaluation bar should be shown.
  final bool showEvaluationBar;

  /// Winning chances from the white pov for the given fen.
  final double? whiteWinningChances;

  /// Last move played, used to highlight corresponding squares.
  final Move? lastMove;

  /// Show a header above the board. Typically a [Text] widget.
  final Widget? header;

  /// Show a footer above the board. Typically a [Text] widget.
  final Widget? footer;

  final GestureTapCallback? onTap;

  /// Animate changes to the board by the specified duration.
  final Duration animationDuration;

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

    final board = StaticChessboard(
      size: widget.size,
      fen: widget.fen,
      orientation: widget.orientation,
      lastMove: widget.lastMove as NormalMove?,
      enableCoordinates: false,
      borderRadius:
          (widget.showEvaluationBar)
              ? Styles.boardBorderRadius.copyWith(topRight: Radius.zero, bottomRight: Radius.zero)
              : Styles.boardBorderRadius,
      boxShadow: (widget.showEvaluationBar) ? [] : boardShadows,
      pieceAssets: boardPrefs.pieceSet.assets,
      colorScheme: boardPrefs.boardTheme.colors,
      animationDuration: widget.animationDuration,
      hue: boardPrefs.hue,
      brightness: boardPrefs.brightness,
    );

    final boardWithMaybeEvalBar =
        widget.showEvaluationBar
            ? DecoratedBox(
              decoration: BoxDecoration(boxShadow: boardShadows),
              child: Row(
                children: [
                  board,
                  Expanded(
                    child:
                        (widget.whiteWinningChances != null)
                            ? _BoardThumbnailEvalGauge(
                              height: widget.size,
                              whiteWinnigChances: widget.whiteWinningChances!,
                            )
                            : Container(
                              height: widget.size,
                              decoration: BoxDecoration(
                                borderRadius: Styles.boardBorderRadius.copyWith(
                                  topLeft: Radius.zero,
                                  bottomLeft: Radius.zero,
                                ),
                                color: Colors.grey.withValues(alpha: 0.6),
                              ),
                            ),
                  ),
                ],
              ),
            )
            : board;

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
                child: boardWithMaybeEvalBar,
              ),
            )
            : boardWithMaybeEvalBar;

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

/// The aspect ratio of the eval gauge for board thumbnails
const boardThumbnailEvalGaugeAspectRatio = 1 / 20;

class _BoardThumbnailEvalGauge extends StatelessWidget {
  final double height;
  final double whiteWinnigChances;

  const _BoardThumbnailEvalGauge({required this.height, required this.whiteWinnigChances});

  @override
  Widget build(BuildContext context) {
    final whiteBarHeight = height * (whiteWinnigChances + 1) / 2;

    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: Styles.boardBorderRadius.copyWith(
            topLeft: Radius.zero,
            bottomLeft: Radius.zero,
          ),
          child: Column(
            children: [
              Container(
                height: height - whiteBarHeight,
                color: EngineGauge.backgroundColor(context),
              ),
              Container(height: whiteBarHeight, color: EngineGauge.valueColor(context)),
            ],
          ),
        ),
        Container(height: height / 100, color: darken(Colors.red)),
      ],
    );
  }
}
