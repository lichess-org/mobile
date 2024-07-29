import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/opening_explorer_repository.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/model/game/game_share_service.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_share_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar_button.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

import 'analysis_widgets.dart';

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
                            AnalysisBoard(
                              pgn,
                              options,
                              boardSize,
                              isTablet: isTablet,
                            ),
                          Expanded(
                            child: _OpeningExplorer(pgn: pgn, options: options),
                          ),
                        ],
                      );
              },
            ),
          ),
        ),
        _BottomBar(pgn: pgn, options: options),
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

class _BottomBar extends ConsumerWidget {
  const _BottomBar({
    required this.pgn,
    required this.options,
  });

  final String pgn;
  final AnalysisOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisControllerProvider(pgn, options);
    final canGoBack =
        ref.watch(ctrlProvider.select((value) => value.canGoBack));
    final canGoNext =
        ref.watch(ctrlProvider.select((value) => value.canGoNext));

    return Container(
      color: Theme.of(context).platform == TargetPlatform.iOS
          ? CupertinoTheme.of(context).barBackgroundColor
          : Theme.of(context).bottomAppBarTheme.color,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: kBottomBarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: BottomBarButton(
                  label: context.l10n.menu,
                  onTap: () {
                    _showAnalysisMenu(context, ref);
                  },
                  icon: Icons.menu,
                ),
              ),
              Expanded(
                child: BottomBarButton(
                  label: context.l10n.analysis,
                  onTap: () => pushReplacementPlatformRoute(
                    context,
                    builder: (_) => AnalysisScreen(
                      pgnOrId: pgn,
                      options: options,
                    ),
                  ),
                  icon: Icons.biotech,
                ),
              ),
              Expanded(
                child: RepeatButton(
                  onLongPress: canGoBack ? () => _moveBackward(ref) : null,
                  child: BottomBarButton(
                    key: const ValueKey('goto-previous'),
                    onTap: canGoBack ? () => _moveBackward(ref) : null,
                    label: 'Previous',
                    icon: CupertinoIcons.chevron_back,
                    showTooltip: false,
                  ),
                ),
              ),
              Expanded(
                child: RepeatButton(
                  onLongPress: canGoNext ? () => _moveForward(ref) : null,
                  child: BottomBarButton(
                    key: const ValueKey('goto-next'),
                    icon: CupertinoIcons.chevron_forward,
                    label: context.l10n.next,
                    onTap: canGoNext ? () => _moveForward(ref) : null,
                    showTooltip: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _moveForward(WidgetRef ref) =>
      ref.read(analysisControllerProvider(pgn, options).notifier).userNext();
  void _moveBackward(WidgetRef ref) => ref
      .read(analysisControllerProvider(pgn, options).notifier)
      .userPrevious();

  Future<void> _showAnalysisMenu(BuildContext context, WidgetRef ref) {
    return showAdaptiveActionSheet(
      context: context,
      actions: [
        BottomSheetAction(
          makeLabel: (context) => Text(context.l10n.flipBoard),
          onPressed: (context) {
            ref
                .read(analysisControllerProvider(pgn, options).notifier)
                .toggleBoard();
          },
        ),
        BottomSheetAction(
          makeLabel: (context) => Text(context.l10n.mobileShareGamePGN),
          onPressed: (_) {
            pushPlatformRoute(
              context,
              title: context.l10n.studyShareAndExport,
              builder: (_) => AnalysisShareScreen(pgn: pgn, options: options),
            );
          },
        ),
        BottomSheetAction(
          makeLabel: (context) => Text(context.l10n.mobileSharePositionAsFEN),
          onPressed: (_) {
            launchShareDialog(
              context,
              text: ref
                  .read(analysisControllerProvider(pgn, options))
                  .position
                  .fen,
            );
          },
        ),
        if (options.gameAnyId != null)
          BottomSheetAction(
            makeLabel: (context) =>
                Text(context.l10n.screenshotCurrentPosition),
            onPressed: (_) async {
              final gameId = options.gameAnyId!.gameId;
              final state = ref.read(analysisControllerProvider(pgn, options));
              try {
                final image =
                    await ref.read(gameShareServiceProvider).screenshotPosition(
                          gameId,
                          options.orientation,
                          state.position.fen,
                          state.lastMove,
                        );
                if (context.mounted) {
                  launchShareDialog(
                    context,
                    files: [image],
                    subject: context.l10n.puzzleFromGameLink(
                      lichessUri('/$gameId').toString(),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  showPlatformSnackbar(
                    context,
                    'Failed to get GIF',
                    type: SnackBarType.error,
                  );
                }
              }
            },
          ),
      ],
    );
  }
}
