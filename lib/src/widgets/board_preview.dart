import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';

/// A board preview with a description.
class SmallBoardPreview extends ConsumerWidget {
  const SmallBoardPreview({
    required this.orientation,
    required this.fen,
    required this.description,
    this.padding,
    this.lastMove,
    this.onTap,
  }) : _showLoadingPlaceholder = false;

  const SmallBoardPreview.loading({this.padding})
    : orientation = Side.white,
      fen = kEmptyFEN,
      lastMove = null,
      description = const SizedBox.shrink(),
      onTap = null,
      _showLoadingPlaceholder = true;

  /// Side by which the board is oriented.
  final Side orientation;

  /// FEN string describing the position of the board.
  final String fen;

  /// Last move played, used to highlight corresponding squares.
  final Move? lastMove;

  final Widget description;

  final GestureTapCallback? onTap;

  final EdgeInsetsGeometry? padding;

  final bool _showLoadingPlaceholder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardPrefs = ref.watch(boardPreferencesProvider);

    final content = LayoutBuilder(
      builder: (context, constraints) {
        final boardSize =
            constraints.biggest.shortestSide -
            (constraints.biggest.shortestSide / 1.518);
        return Padding(
          padding:
              padding ??
              Styles.horizontalBodyPadding.add(
                const EdgeInsets.symmetric(vertical: 8.0),
              ),
          child: SizedBox(
            height: boardSize,
            child: Row(
              children: [
                if (_showLoadingPlaceholder)
                  Container(
                    width: boardSize,
                    height: boardSize,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: Styles.boardBorderRadius,
                    ),
                  )
                else
                  StaticChessboard(
                    size: boardSize,
                    fen: fen,
                    orientation: orientation,
                    lastMove: lastMove as NormalMove?,
                    pieceAssets: boardPrefs.pieceSet.assets,
                    colorScheme: boardPrefs.boardTheme.colors,
                    brightness: boardPrefs.brightness,
                    hue: boardPrefs.hue,
                    enableCoordinates: false,
                    borderRadius: Styles.boardBorderRadius,
                    boxShadow: boardShadows,
                    animationDuration: const Duration(milliseconds: 150),
                  ),
                const SizedBox(width: 10.0),
                if (_showLoadingPlaceholder)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 16.0,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                borderRadius: Styles.boardBorderRadius,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Container(
                              height: 16.0,
                              width: MediaQuery.sizeOf(context).width / 3,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                borderRadius: Styles.boardBorderRadius,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 44.0,
                          width: 44.0,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: Styles.boardBorderRadius,
                          ),
                        ),
                        Container(
                          height: 16.0,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: Styles.boardBorderRadius,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Expanded(child: description),
              ],
            ),
          ),
        );
      },
    );

    return onTap != null ? InkWell(onTap: onTap, child: content) : content;
  }
}
