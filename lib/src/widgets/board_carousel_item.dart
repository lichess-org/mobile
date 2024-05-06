import 'package:chessground/chessground.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

class BoardCarouselItem extends ConsumerWidget {
  const BoardCarouselItem({
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
  Widget build(BuildContext context, WidgetRef ref) {
    final boardPrefs = ref.watch(boardPreferencesProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final boardSize = constraints.biggest.shortestSide - 16.0;
        final card = PlatformCard(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          margin: Theme.of(context).platform == TargetPlatform.iOS
              ? EdgeInsets.zero
              : const EdgeInsets.all(8.0),
          child: AdaptiveInkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: boardSize,
                  child: Board(
                    size: boardSize,
                    data: BoardData(
                      interactableSide: InteractableSide.none,
                      fen: fen,
                      orientation: orientation,
                      lastMove: lastMove,
                    ),
                    settings: BoardSettings(
                      enableCoordinates: false,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                      pieceAssets: boardPrefs.pieceSet.assets,
                      colorScheme: boardPrefs.boardTheme.colors,
                    ),
                  ),
                ),
                DefaultTextStyle.merge(
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  child: description,
                ),
              ],
            ),
          ),
        );

        return Theme.of(context).platform == TargetPlatform.iOS
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: card,
                ),
              )
            : card;
      },
    );
  }
}
