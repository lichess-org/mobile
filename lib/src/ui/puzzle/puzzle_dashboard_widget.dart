import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/stat_card.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/ui/puzzle/puzzle_dashboard_screen.dart';

class PuzzleDashboardWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(daysProvider);
    final puzzleDashboard = ref.watch(puzzleDashboardProvider(day.days));

    return puzzleDashboard.when(
      data: (data) {
        return ListSection(
          header: Text(context.l10n.puzzleDashboard),
          children: [
            StatCardRow([
              StatCard(
                context.l10n.performance,
                value: data.global.performance.toString(),
              ),
              StatCard(
                context.l10n.played,
                value: data.global.nb.toString(),
              ),
              StatCard(
                context.l10n.solved,
                value:
                    '${((data.global.firstWins / data.global.nb) * 100).toInt()}%',
              ),
            ]),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 1.2,
                  child: PuzzleChart(data.themes.take(7).toIList()),
                ),
                const SizedBox(height: 30),
              ],
            )
          ],
        );
      },
      error: (e, s) {
        debugPrint(
          'SEVERE: [PuzzleDashboardWidget] could not load puzzle dashboard; $e\n$s',
        );
        return const Text('Error! Could not load Dashboard');
      },
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class PuzzleChart extends StatelessWidget {
  const PuzzleChart(this.puzzleData);

  final IList<PuzzleDashboardData> puzzleData;

  @override
  Widget build(BuildContext context) {
    return RadarChart(
      RadarChartData(
        radarBorderData: const BorderSide(width: 0.5),
        gridBorderData: const BorderSide(width: 0.5),
        tickBorderData: const BorderSide(width: 0.5),
        radarShape: RadarShape.polygon,
        dataSets: [
          RadarDataSet(
            dataEntries: puzzleData
                .map((theme) => RadarEntry(value: theme.performance.toDouble()))
                .toList(),
          ),
        ],
        getTitle: (index, angle) =>
            RadarChartTitle(text: puzzleData[index].theme!),
        titleTextStyle: const TextStyle(fontSize: 10),
        titlePositionPercentageOffset: 0.09,
        tickCount: 3,
        ticksTextStyle: const TextStyle(fontSize: 8),
      ),
    );
  }
}
