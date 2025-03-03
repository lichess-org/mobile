import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/analysis/server_analysis_service.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/string.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';

class ServerAnalysisSummary extends ConsumerWidget {
  const ServerAnalysisSummary(this.options);

  final AnalysisOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisPrefs = ref.watch(analysisPreferencesProvider);
    final ctrlProvider = analysisControllerProvider(options);
    final playersAnalysis = ref.watch(
      ctrlProvider.select((value) => value.requireValue.playersAnalysis),
    );
    final canShowGameSummary = ref.watch(
      ctrlProvider.select((value) => value.requireValue.canShowGameSummary),
    );
    final pgnHeaders = ref.watch(ctrlProvider.select((value) => value.requireValue.pgnHeaders));
    final currentGameAnalysis = ref.watch(currentAnalysisProvider);

    if (analysisPrefs.enableComputerAnalysis == false || !canShowGameSummary) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Spacer(),
              Text(context.l10n.computerAnalysisDisabled),
              if (canShowGameSummary)
                SecondaryButton(
                  onPressed: () {
                    ref.read(ctrlProvider.notifier).toggleComputerAnalysis();
                  },
                  semanticsLabel: context.l10n.enable,
                  child: Text(context.l10n.enable),
                ),
              const Spacer(),
            ],
          ),
        ),
      );
    }

    return playersAnalysis != null
        ? ListView(
          children: [
            if (currentGameAnalysis == options.gameId)
              const Padding(padding: EdgeInsets.only(top: 16.0), child: WaitingForServerAnalysis()),
            AcplChart(options),
            Center(
              child: SizedBox(
                width: math.min(MediaQuery.sizeOf(context).width, 500),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(1),
                    },
                    children: [
                      TableRow(
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey)),
                        ),
                        children: [
                          _SummaryPlayerName(Side.white, pgnHeaders),
                          Center(
                            child: Text(
                              pgnHeaders.get('Result') ?? '',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          _SummaryPlayerName(Side.black, pgnHeaders),
                        ],
                      ),
                      if (playersAnalysis.white.accuracy != null &&
                          playersAnalysis.black.accuracy != null)
                        TableRow(
                          children: [
                            _SummaryNumber('${playersAnalysis.white.accuracy}%'),
                            Center(
                              heightFactor: 1.8,
                              child: Text(context.l10n.accuracy, softWrap: true),
                            ),
                            _SummaryNumber('${playersAnalysis.black.accuracy}%'),
                          ],
                        ),
                      for (final item in [
                        (
                          playersAnalysis.white.inaccuracies.toString(),
                          context.l10n.nbInaccuracies(2).replaceAll('2', '').trim().capitalize(),
                          playersAnalysis.black.inaccuracies.toString(),
                          LichessColors.cyan,
                        ),
                        (
                          playersAnalysis.white.mistakes.toString(),
                          context.l10n.nbMistakes(2).replaceAll('2', '').trim().capitalize(),
                          playersAnalysis.black.mistakes.toString(),
                          LichessColors.mistake,
                        ),
                        (
                          playersAnalysis.white.blunders.toString(),
                          context.l10n.nbBlunders(2).replaceAll('2', '').trim().capitalize(),
                          playersAnalysis.black.blunders.toString(),
                          LichessColors.blunder,
                        ),
                      ])
                        TableRow(
                          children: [
                            _SummaryNumber(item.$1, item.$4),
                            Center(
                              heightFactor: 1.2,
                              child: Text(
                                item.$2,
                                softWrap: true,
                                style: TextStyle(color: item.$4),
                              ),
                            ),
                            _SummaryNumber(item.$3, item.$4),
                          ],
                        ),
                      if (playersAnalysis.white.acpl != null && playersAnalysis.black.acpl != null)
                        TableRow(
                          children: [
                            _SummaryNumber(playersAnalysis.white.acpl.toString()),
                            Center(
                              heightFactor: 1.5,
                              child: Text(
                                context.l10n.averageCentipawnLoss,
                                softWrap: true,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            _SummaryNumber(playersAnalysis.black.acpl.toString()),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
        : Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            if (currentGameAnalysis == options.gameId)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: WaitingForServerAnalysis(),
                ),
              )
            else
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Builder(
                    builder: (context) {
                      Future<void>? pendingRequest;
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return FutureBuilder<void>(
                            future: pendingRequest,
                            builder: (context, snapshot) {
                              return SecondaryButton(
                                semanticsLabel: context.l10n.requestAComputerAnalysis,
                                onPressed:
                                    ref.watch(authSessionProvider) == null
                                        ? () {
                                          showPlatformSnackbar(
                                            context,
                                            context.l10n.youNeedAnAccountToDoThat,
                                          );
                                        }
                                        : snapshot.connectionState == ConnectionState.waiting
                                        ? null
                                        : () {
                                          setState(() {
                                            pendingRequest = ref
                                                .read(ctrlProvider.notifier)
                                                .requestServerAnalysis()
                                                .catchError((Object e) {
                                                  if (context.mounted) {
                                                    showPlatformSnackbar(
                                                      context,
                                                      e.toString(),
                                                      type: SnackBarType.error,
                                                    );
                                                  }
                                                });
                                          });
                                        },
                                child: Text(context.l10n.requestAComputerAnalysis),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            const Spacer(),
          ],
        );
  }
}

class WaitingForServerAnalysis extends StatelessWidget {
  const WaitingForServerAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Image.asset('assets/images/stockfish/icon.png', width: 30, height: 30),
        const SizedBox(width: 8.0),
        Text(context.l10n.waitingForAnalysis),
        const SizedBox(width: 8.0),
        const CircularProgressIndicator.adaptive(),
      ],
    );
  }
}

class _SummaryNumber extends StatelessWidget {
  const _SummaryNumber(this.data, [this.color]);
  final String data;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (color == null) {
      return Center(child: Text(data, softWrap: true));
    }
    return Center(child: Text(data, softWrap: true, style: TextStyle(color: color)));
  }
}

class _SummaryPlayerName extends StatelessWidget {
  const _SummaryPlayerName(this.side, this.pgnHeaders);
  final Side side;
  final IMap<String, String> pgnHeaders;

  @override
  Widget build(BuildContext context) {
    final playerTitle =
        side == Side.white ? pgnHeaders.get('WhiteTitle') : pgnHeaders.get('BlackTitle');
    final playerName =
        side == Side.white
            ? pgnHeaders.get('White') ?? context.l10n.white
            : pgnHeaders.get('Black') ?? context.l10n.black;

    final brightness = Theme.of(context).brightness;

    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.top,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Column(
            children: [
              Icon(
                side == Side.white
                    ? brightness == Brightness.light
                        ? CupertinoIcons.circle
                        : CupertinoIcons.circle_filled
                    : brightness == Brightness.light
                    ? CupertinoIcons.circle_filled
                    : CupertinoIcons.circle,
                size: 14,
              ),
              Text(
                '${playerTitle != null ? '$playerTitle ' : ''}$playerName',
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AcplChart extends ConsumerWidget {
  const AcplChart(this.options);

  final AnalysisOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainLineColor = ColorScheme.of(context).secondary;
    // yes it looks like below/above are inverted in fl_chart
    final brightness = Theme.of(context).brightness;
    final white = ColorScheme.of(context).surfaceContainerHighest;
    final black = ColorScheme.of(context).outline;
    // yes it looks like below/above are inverted in fl_chart
    final belowLineColor = brightness == Brightness.light ? white : black;
    final aboveLineColor = brightness == Brightness.light ? black : white;

    VerticalLine phaseVerticalBar(double x, String label) => VerticalLine(
      x: x,
      color: const Color(0xFF707070),
      strokeWidth: 0.5,
      label: VerticalLineLabel(
        style: TextStyle(
          fontSize: 10,
          color: TextTheme.of(context).labelMedium?.color?.withValues(alpha: 0.3),
        ),
        labelResolver: (line) => label,
        padding: const EdgeInsets.only(right: 1),
        alignment: Alignment.topRight,
        direction: LabelDirection.vertical,
        show: true,
      ),
    );

    final state = ref.watch(analysisControllerProvider(options)).requireValue;
    final data = state.acplChartData;
    final rootPly = state.root.position.ply;
    final currentNode = state.currentNode;
    final isOnMainline = state.isOnMainline;

    if (data == null) {
      return const SizedBox.shrink();
    }

    final spots = data
        .mapIndexed((i, e) => FlSpot(i.toDouble(), e.winningChances(Side.white)))
        .toList(growable: false);

    final divisionLines = <VerticalLine>[];

    if (state.division?.middlegame != null) {
      if (state.division!.middlegame! > 0) {
        divisionLines.add(phaseVerticalBar(0.0, context.l10n.opening));
        divisionLines.add(
          phaseVerticalBar(state.division!.middlegame! - 1, context.l10n.middlegame),
        );
      } else {
        divisionLines.add(phaseVerticalBar(0.0, context.l10n.middlegame));
      }
    }

    if (state.division?.endgame != null) {
      if (state.division!.endgame! > 0) {
        divisionLines.add(phaseVerticalBar(state.division!.endgame! - 1, context.l10n.endgame));
      } else {
        divisionLines.add(phaseVerticalBar(0.0, context.l10n.endgame));
      }
    }
    return Center(
      child: AspectRatio(
        aspectRatio: 2.5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(
                enabled: false,
                touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
                  if (event is FlTapDownEvent ||
                      event is FlPanUpdateEvent ||
                      event is FlLongPressMoveUpdate) {
                    final touchX = event.localPosition!.dx;
                    final chartWidth =
                        context.size!.width - 32; // Insets on both sides of the chart of 16
                    final minX = spots.first.x;
                    final maxX = spots.last.x;
                    final touchXDataValue = minX + (touchX / chartWidth) * (maxX - minX);
                    final closestSpot = spots.reduce(
                      (a, b) =>
                          (a.x - touchXDataValue).abs() < (b.x - touchXDataValue).abs() ? a : b,
                    );
                    final closestNodeIndex = closestSpot.x.round();
                    ref
                        .read(analysisControllerProvider(options).notifier)
                        .jumpToNthNodeOnMainline(closestNodeIndex);
                  }
                },
              ),
              minY: -1.0,
              maxY: 1.0,
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: false,
                  barWidth: 1,
                  color: mainLineColor.withValues(alpha: 0.7),
                  aboveBarData: BarAreaData(show: true, color: aboveLineColor, applyCutOffY: true),
                  belowBarData: BarAreaData(show: true, color: belowLineColor, applyCutOffY: true),
                  dotData: const FlDotData(show: false),
                ),
              ],
              extraLinesData: ExtraLinesData(
                verticalLines: [
                  if (isOnMainline)
                    VerticalLine(
                      x: (currentNode.position.ply - 1 - rootPly).toDouble(),
                      color: mainLineColor,
                      strokeWidth: 1.0,
                    ),
                  ...divisionLines,
                ],
              ),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: const FlTitlesData(show: false),
            ),
          ),
        ),
      ),
    );
  }
}
