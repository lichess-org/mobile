import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';

/// A chart displaying average centipawn loss (ACPL) analysis over the course of a game.
///
/// This widget shows the evaluation curve for the chess game, with lines indicating
/// for game phases (opening, middlegame, endgame) and the current position.
class AcplChart extends StatelessWidget {
  const AcplChart({
    required this.acplChartData,
    required this.division,
    required this.rootPly,
    required this.currentNodePly,
    required this.isOnMainline,
    required this.onJumpToNode,
    super.key,
  });

  /// The evaluation data points to display on the chart
  final IList<ExternalEval> acplChartData;

  /// Game phase division information (opening/middlegame/endgame boundaries)
  final Division? division;

  /// The ply number at the root of the analysis tree
  final int rootPly;

  /// The ply number of the current position being viewed
  final int currentNodePly;

  /// Whether the current node is on the main line
  final bool isOnMainline;

  /// Callback when user taps/drags to jump to a specific node
  final void Function(int nodeIndex) onJumpToNode;

  @override
  Widget build(BuildContext context) {
    final mainLineColor = Theme.of(context).colorScheme.secondary;
    final brightness = Theme.of(context).brightness;
    final white = Theme.of(context).colorScheme.surfaceContainerHighest;
    final black = Theme.of(context).colorScheme.outline;
    // Note: below/above are inverted in fl_chart
    final belowLineColor = brightness == .light ? white : black;
    final aboveLineColor = brightness == .light ? black : white;

    final spots = acplChartData
        .mapIndexed((i, e) => FlSpot(i.toDouble(), e.winningChances(Side.white)))
        .toList(growable: false);

    final divisionLines = _buildDivisionLines(context, division);

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
                  if (event is FlTapUpEvent ||
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
                    onJumpToNode(closestNodeIndex);
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
                      x: (currentNodePly - 1 - rootPly).toDouble(),
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

  List<VerticalLine> _buildDivisionLines(BuildContext context, Division? division) {
    final divisionLines = <VerticalLine>[];

    VerticalLine phaseVerticalBar(double x, String label) => VerticalLine(
      x: x,
      color: const Color(0xFF707070),
      strokeWidth: 0.5,
      label: VerticalLineLabel(
        style: TextStyle(
          fontSize: 10,
          color: Theme.of(context).textTheme.labelMedium?.color?.withValues(alpha: 0.3),
        ),
        labelResolver: (line) => label,
        padding: const EdgeInsets.only(right: 1),
        alignment: .topRight,
        direction: .vertical,
        show: true,
      ),
    );

    if (division?.middlegame != null) {
      if (division!.middlegame! > 0) {
        divisionLines.add(phaseVerticalBar(0.0, context.l10n.opening));
        divisionLines.add(phaseVerticalBar(division.middlegame! - 1, context.l10n.middlegame));
      } else {
        divisionLines.add(phaseVerticalBar(0.0, context.l10n.middlegame));
      }
    }

    if (division?.endgame != null) {
      if (division!.endgame! > 0) {
        divisionLines.add(phaseVerticalBar(division.endgame! - 1, context.l10n.endgame));
      } else {
        divisionLines.add(phaseVerticalBar(0.0, context.l10n.endgame));
      }
    }

    return divisionLines;
  }
}
