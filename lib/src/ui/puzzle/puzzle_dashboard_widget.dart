import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/string.dart';
import 'package:lichess_mobile/src/model/common/errors.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/stat_card.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/ui/puzzle/puzzle_dashboard_screen.dart';

class PuzzleDashboardWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(daysProvider);
    final puzzleDashboard = ref.watch(puzzleDashboardProvider(day.days));

    return puzzleDashboard.when(
      data: (data) {
        return ListSection(
          header: Text(context.l10n.puzzlePuzzleDashboard),
          // hack to make the divider take full length or row
          cupertinoAdditionalDividerMargin: -14,
          children: [
            StatCardRow([
              StatCard(
                context.l10n.performance,
                value: data.global.performance.toString(),
              ),
              StatCard(
                context.l10n
                    .puzzleNbPlayed(data.global.nb)
                    .replaceAll(RegExp(r'\d+'), '')
                    .trim()
                    .capitalize(),
                value: data.global.nb.toString(),
              ),
              StatCard(
                context.l10n.puzzleSolved.capitalize(),
                value:
                    '${((data.global.firstWins / data.global.nb) * 100).round()}%',
              ),
            ]),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 1.2,
                  child: PuzzleChart(
                    data.themes.take(9).sortedBy((e) => e.theme.name).toList(),
                  ),
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
        return Padding(
          padding: Styles.bodySectionPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.puzzlePuzzleDashboard,
                style: Styles.sectionTitle,
              ),
              if (e is NotFoundException)
                Text(context.l10n.puzzleNoPuzzlesToShow)
              else
                const Text('Could not load dashboard.'),
            ],
          ),
        );
      },
      loading: () {
        final loaderHeight = MediaQuery.of(context).size.width;
        return Shimmer(
          child: ShimmerLoading(
            isLoading: true,
            child: Padding(
              padding: Styles.bodySectionBottomPadding,
              child: Column(
                children: [
                  // ignore: avoid-wrapping-in-padding
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      width: double.infinity,
                      height: 25,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                  ),
                  // ignore: avoid-wrapping-in-padding
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      width: double.infinity,
                      height: loaderHeight,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class PuzzleChart extends StatelessWidget {
  const PuzzleChart(this.puzzleData);

  final List<PuzzleDashboardData> puzzleData;

  @override
  Widget build(BuildContext context) {
    final radarColor =
        Theme.of(context).colorScheme.onBackground.withOpacity(0.5);
    final chartColor = Theme.of(context).colorScheme.primary;
    return RadarChart(
      RadarChartData(
        radarBorderData: BorderSide(width: 0.5, color: radarColor),
        gridBorderData: BorderSide(width: 0.5, color: radarColor),
        tickBorderData: BorderSide(width: 0.5, color: radarColor),
        radarShape: RadarShape.polygon,
        dataSets: [
          RadarDataSet(
            fillColor: defaultTargetPlatform == TargetPlatform.iOS
                ? null
                : chartColor.withOpacity(0.2),
            borderColor:
                defaultTargetPlatform == TargetPlatform.iOS ? null : chartColor,
            dataEntries: puzzleData
                .map((theme) => RadarEntry(value: theme.performance.toDouble()))
                .toList(),
          ),
        ],
        getTitle: (index, angle) => RadarChartTitle(
          text: puzzleThemeL10n(context, puzzleData[index].theme).name,
        ),
        titleTextStyle: const TextStyle(fontSize: 10),
        titlePositionPercentageOffset: 0.09,
        tickCount: 3,
        ticksTextStyle: const TextStyle(fontSize: 8),
      ),
    );
  }
}
