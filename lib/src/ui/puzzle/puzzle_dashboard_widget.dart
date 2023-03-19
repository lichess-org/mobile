import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform_card.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';

class PuzzleDashboardWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puzzleDashboard = ref.watch(puzzleDashboardProvider);

    return puzzleDashboard.when(
      data: (data) {
        return ListSection(
          header: const Text('Puzzle Dashboard'),
          children: [
            CustomPlatformCardRow([
              CustomPlatformCard(
                'Performance',
                value: data.global.performance.toString(),
              ),
              CustomPlatformCard(
                'Played',
                value: data.global.nb.toString(),
              ),
              CustomPlatformCard(
                'First Wins',
                value: data.global.firstWins.toString(),
              ),
              CustomPlatformCard(
                'Replay Wins',
                value: data.global.replayWins.toString(),
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
