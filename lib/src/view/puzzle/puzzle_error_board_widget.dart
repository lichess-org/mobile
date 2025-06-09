import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/widgets/board.dart';

class PuzzleErrorBoardWidget extends ConsumerWidget {
  const PuzzleErrorBoardWidget({required this.errorMessage});

  final String errorMessage;

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

                  final defaultSettings = boardPreferences.toBoardSettings().copyWith(
                    borderRadius: isTablet ? Styles.boardBorderRadius : BorderRadius.zero,
                    boxShadow: isTablet ? boardShadows : const <BoxShadow>[],
                  );

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
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          BoardWidget(
                            size: boardSize,
                            fen: kEmptyBoardFEN,
                            orientation: Side.white,
                            gameData: null,
                            settings: defaultSettings,
                            error: errorMessage,
                          ),
                        ],
                      ),
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
                          child: BoardWidget(
                            size: boardSize,
                            fen: kEmptyBoardFEN,
                            orientation: Side.white,
                            gameData: null,
                            settings: defaultSettings,
                            error: errorMessage,
                          ),
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
