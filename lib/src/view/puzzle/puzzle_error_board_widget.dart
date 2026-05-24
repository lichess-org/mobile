import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/screen.dart';

class PuzzleErrorBoardWidget extends ConsumerWidget {
  const PuzzleErrorBoardWidget({this.errorMessage});

  final String? errorMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardPreferences = ref.watch(boardPreferencesProvider);

    return Column(
      children: [
        Expanded(
          child: Center(
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final orientation = constraints.maxWidth > constraints.maxHeight
                      ? Orientation.landscape
                      : Orientation.portrait;
                  final isTablet = isTabletOrLarger(context);

                  final defaultSettings = boardPreferences
                      .toBoardSettings(Variant.standard)
                      .copyWith(
                        borderRadius: isTablet ? Styles.boardBorderRadius : BorderRadius.zero,
                        boxShadow: isTablet ? boardShadows : const <BoxShadow>[],
                      );

                  Widget board(double size) {
                    final chessboard = StaticChessboard(
                      size: size,
                      fen: kEmptyBoardFEN,
                      orientation: Side.white,
                      settings: StaticChessboardSettings.fromBoardSettings(defaultSettings),
                    );
                    if (errorMessage == null) return chessboard;
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        chessboard,
                        Positioned(
                          left: 16.0,
                          right: 16.0,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: OverflowBox(
                              maxHeight: double.infinity,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                ),
                                padding: const EdgeInsets.all(10.0),
                                child: Text(errorMessage!),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  if (orientation == Orientation.landscape) {
                    final defaultBoardSize =
                        constraints.biggest.shortestSide - (kTabletBoardTableSidePadding * 2);
                    final sideWidth = constraints.biggest.longestSide - defaultBoardSize;
                    final boardSize = sideWidth >= 250
                        ? defaultBoardSize
                        : constraints.biggest.longestSide / kGoldenRatio -
                              (kTabletBoardTableSidePadding * 2);
                    return Padding(
                      padding: const EdgeInsets.all(kTabletBoardTableSidePadding),
                      child: Row(mainAxisSize: MainAxisSize.max, children: [board(boardSize)]),
                    );
                  } else {
                    final defaultBoardSize = constraints.biggest.shortestSide;
                    final double boardSize = isTablet
                        ? defaultBoardSize - kTabletBoardTableSidePadding * 2
                        : defaultBoardSize;

                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: isTablet
                              ? const EdgeInsets.symmetric(horizontal: kTabletBoardTableSidePadding)
                              : EdgeInsets.zero,
                          child: board(boardSize),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
