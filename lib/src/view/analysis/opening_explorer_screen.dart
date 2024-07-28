import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/opening_explorer_repository.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

import 'analysis_board.dart';

class OpeningExplorerScreen extends StatelessWidget {
  const OpeningExplorerScreen({required this.pgn, required this.options});

  final String pgn;
  final AnalysisOptions options;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.openingExplorer),
      ),
      body: _Body(pgn: pgn, options: options),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Styles.cupertinoScaffoldColor.resolveFrom(context),
        border: null,
        middle: Text(context.l10n.openingExplorer),
      ),
      child: _Body(pgn: pgn, options: options),
    );
  }
}

class _Body extends ConsumerWidget {
  final String pgn;

  final AnalysisOptions options;
  const _Body({required this.pgn, required this.options});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Expanded(
          child: SafeArea(
            bottom: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final aspectRatio = constraints.biggest.aspectRatio;
                final defaultBoardSize = constraints.biggest.shortestSide;
                final isTablet = isTabletOrLarger(context);
                final remainingHeight =
                    constraints.maxHeight - defaultBoardSize;
                final isSmallScreen =
                    remainingHeight < kSmallRemainingHeightLeftBoardThreshold;
                final boardSize = isTablet || isSmallScreen
                    ? defaultBoardSize - kTabletBoardTableSidePadding * 2
                    : defaultBoardSize;

                return aspectRatio > 1
                    ? Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: kTabletBoardTableSidePadding,
                              top: kTabletBoardTableSidePadding,
                              bottom: kTabletBoardTableSidePadding,
                            ),
                            child: Row(
                              children: [
                                AnalysisBoard(
                                  pgn,
                                  options,
                                  boardSize,
                                  isTablet: isTablet,
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: PlatformCard(
                                    margin: const EdgeInsets.all(
                                      kTabletBoardTableSidePadding,
                                    ),
                                    semanticContainer: false,
                                    child: _OpeningExplorer(
                                      pgn: pgn,
                                      options: options,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isTablet)
                            Padding(
                              padding: const EdgeInsets.all(
                                kTabletBoardTableSidePadding,
                              ),
                              child: AnalysisBoard(
                                pgn,
                                options,
                                boardSize,
                                isTablet: isTablet,
                              ),
                            )
                          else
                            AnalysisBoard(pgn, options, boardSize, isTablet: isTablet),
                          Expanded(
                            child: _OpeningExplorer(pgn: pgn, options: options),
                          ),
                        ],
                      );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _OpeningExplorer extends ConsumerWidget {
  const _OpeningExplorer({
    required this.pgn,
    required this.options,
  });

  final String pgn;
  final AnalysisOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisControllerProvider(pgn, options);
    final position = ref.watch(ctrlProvider.select((value) => value.position));

    if (position.fullmoves > 24) {
      return const Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Max depth reached'),
          ],
        ),
      );
    }

    final masterDatabaseAsync =
        ref.watch(masterDatabaseProvider(fen: position.fen));

    return masterDatabaseAsync.when(
      data: (masterDatabase) {
        return masterDatabase.moves.isEmpty
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No game found'),
                ],
              )
            : Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    showCheckboxColumn: false,
                    columnSpacing: 5,
                    horizontalMargin: 0,
                    columns: const [
                      DataColumn(label: Text('Move')),
                      DataColumn(label: Text('Games')),
                      DataColumn(label: Text('White / Draw / Black')),
                    ],
                    rows: [
                      ...masterDatabase.moves.map(
                        (move) => DataRow(
                          onSelectChanged: (_) => ref
                              .read(ctrlProvider.notifier)
                              .onUserMove(Move.fromUci(move.uci)!),
                          cells: [
                            DataCell(Text(move.san)),
                            DataCell(
                              Text(
                                '${((move.games / masterDatabase.games) * 100).round()}% / ${formatNum(move.games)}',
                              ),
                            ),
                            DataCell(
                              _WinPercentageChart(
                                white: move.white,
                                draws: move.draws,
                                black: move.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DataRow(
                        cells: [
                          const DataCell(Icon(Icons.functions)),
                          DataCell(
                            Text(
                              '100% / ${formatNum(masterDatabase.games)}',
                            ),
                          ),
                          DataCell(
                            _WinPercentageChart(
                              white: masterDatabase.white,
                              draws: masterDatabase.draws,
                              black: masterDatabase.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: Text(error.toString()),
      ),
    );
  }

  String formatNum(int num) => NumberFormat.decimalPatternDigits().format(num);
}

class _WinPercentageChart extends StatelessWidget {
  final int white;

  final int draws;
  final int black;
  const _WinPercentageChart({
    required this.white,
    required this.draws,
    required this.black,
  });

  @override
  Widget build(BuildContext context) {
    int percentGames(int games) =>
        ((games / (white + draws + black)) * 100).round();

    final percentWhite = percentGames(white);
    final percentDraws = percentGames(draws);
    final percentBlack = percentGames(black);

    return Row(
      children: [
        if (percentWhite != 0)
          Expanded(
            child: ColoredBox(
              color: Colors.white,
              child: Text(
                percentWhite < 5 ? '' : '$percentWhite%',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        if (percentDraws != 0)
          Expanded(
            child: ColoredBox(
              color: Colors.grey,
              child: Text(
                percentDraws < 5 ? '' : '$percentDraws%',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        if (percentBlack != 0)
          Expanded(
            child: ColoredBox(
              color: Colors.black,
              child: Text(
                percentBlack < 5 ? '' : '$percentBlack%',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
