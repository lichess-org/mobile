import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' show ClientException;
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/utils/string.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/widgets/stat_card.dart';

final daysProvider = StateProvider<Days>((ref) => Days.month);

class PuzzleDashboardScreen extends StatelessWidget {
  const PuzzleDashboardScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const PuzzleDashboardScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const SizedBox.shrink(), actions: const [DaysSelector()]),
      body: const _Body(),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(children: const [PuzzleDashboardWidget()]);
  }
}

class PuzzleDashboardWidget extends ConsumerWidget {
  final bool showDaysSelector;
  const PuzzleDashboardWidget({this.showDaysSelector = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puzzleDashboard = ref.watch(puzzleDashboardProvider(ref.watch(daysProvider).days));

    return puzzleDashboard.when(
      data: (dashboard) {
        if (dashboard == null) return const SizedBox.shrink();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ChartSection(dashboard: dashboard, showDaysSelector: showDaysSelector),
            _PerformanceSection(dashboard: dashboard, metric: Metric.improvementArea),
            _PerformanceSection(dashboard: dashboard, metric: Metric.strength),
          ],
        );
      },
      error: (e, s) {
        debugPrint('SEVERE: [PuzzleDashboardWidget] could not load puzzle dashboard; $e\n$s');
        return Padding(
          padding: Styles.bodySectionPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.l10n.puzzlePuzzleDashboard, style: Styles.sectionTitle),
              if (e is ClientException && e.message.contains('404'))
                Text(context.l10n.puzzleNoPuzzlesToShow)
              else
                const Text('Could not load dashboard.'),
            ],
          ),
        );
      },
      loading: () {
        final loaderHeight = MediaQuery.sizeOf(context).width;
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

class _ChartSection extends StatelessWidget {
  const _ChartSection({required this.dashboard, required this.showDaysSelector});

  final PuzzleDashboard dashboard;
  final bool showDaysSelector;

  @override
  Widget build(BuildContext context) {
    final chartData = dashboard.themes.take(9).sortedBy((e) => e.theme.name).toList();
    return ListSection(
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.l10n.puzzlePuzzleDashboard),
                    Text(
                      context.l10n.puzzlePuzzleDashboardDescription,
                      style: Styles.subtitle.copyWith(
                        color: textShade(context, Styles.subtitleOpacity),
                      ),
                    ),
                  ],
                ),
              ),
              if (showDaysSelector) const DaysSelector(),
            ],
          ),
        ],
      ),
      children: [
        StatCardRow([
          StatCard(context.l10n.performance, value: dashboard.global.performance.toString()),
          StatCard(
            context.l10n
                .puzzleNbPlayed(dashboard.global.nb)
                .replaceAll(RegExp(r'\d+'), '')
                .trim()
                .capitalize(),
            value: dashboard.global.nb.toString().localizeNumbers(),
          ),
          StatCard(
            context.l10n.puzzleSolved.capitalize(),
            value: '${((dashboard.global.firstWins / dashboard.global.nb) * 100).round()}%',
          ),
        ]),
        if (chartData.length >= 3) PuzzleChart(chartData),
      ],
    );
  }
}

class _PerformanceSection extends StatelessWidget {
  const _PerformanceSection({required this.dashboard, required this.metric});

  final PuzzleDashboard dashboard;
  final Metric metric;

  @override
  Widget build(BuildContext context) {
    final themes = metric.sort(dashboard.themes);
    return ListSection(
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(metric.title(context.l10n)), // #4: logic on enum
                    Text(
                      metric.subtitle(context.l10n), // #4: logic on enum
                      style: Styles.subtitle.copyWith(
                        color: textShade(context, Styles.subtitleOpacity),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      children: [for (final item in themes) PuzzleThemeRow(data: item)],
    );
  }
}

class PuzzleChart extends StatelessWidget {
  const PuzzleChart(this.puzzleData);
  final List<PuzzleDashboardData> puzzleData;

  @override
  Widget build(BuildContext context) {
    final radarColor = ColorScheme.of(context).onSurface.withValues(alpha: 0.5);
    final chartColor = Styles.chartColor(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: AspectRatio(
        aspectRatio: MediaQuery.sizeOf(context).width > FormFactor.desktop ? 2.8 : 1.2,
        child: RadarChart(
          RadarChartData(
            radarBorderData: BorderSide(width: 0.5, color: radarColor),
            gridBorderData: BorderSide(width: 0.5, color: radarColor),
            tickBorderData: BorderSide(width: 0.5, color: radarColor),
            radarShape: RadarShape.polygon,
            dataSets: [
              RadarDataSet(
                fillColor: chartColor.withValues(alpha: 0.2),
                borderColor: chartColor,
                dataEntries: puzzleData
                    .map((theme) => RadarEntry(value: theme.performance.toDouble()))
                    .toList(),
              ),
            ],
            getTitle: (index, angle) =>
                RadarChartTitle(text: puzzleData[index].theme.l10n(context.l10n).name),
            titleTextStyle: const TextStyle(fontSize: 10),
            titlePositionPercentageOffset: 0.09,
            tickCount: 3,
            ticksTextStyle: const TextStyle(fontSize: 8),
          ),
        ),
      ),
    );
  }
}

class DaysSelector extends ConsumerWidget {
  const DaysSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUser = ref.watch(authControllerProvider);
    final day = ref.watch(daysProvider);
    return authUser != null
        ? TextButton(
            onPressed: () => showChoicePicker(
              context,
              choices: Days.values,
              selectedItem: day,
              labelBuilder: (t) => Text(_daysL10n(context, t)),
              onSelectedItemChanged: (newDay) {
                ref.read(daysProvider.notifier).state = newDay;
              },
            ),
            child: Text(_daysL10n(context, day)),
          )
        : const SizedBox.shrink();
  }
}

enum Metric {
  strength,
  improvementArea;

  static const _itemsToShow = 3;

  List<PuzzleDashboardData> sort(IList<PuzzleDashboardData> themes) => switch (this) {
    strength =>
      themes
          .sortedByCompare((e) => e.performance, (a, b) => b.compareTo(a))
          .take(_itemsToShow)
          .toList(),
    improvementArea => themes.sortedBy((e) => e.performance).take(_itemsToShow).toList(),
  };

  String title(AppLocalizations l10n) => switch (this) {
    strength => l10n.puzzleStrengths,
    improvementArea => l10n.puzzleImprovementAreas,
  };

  String subtitle(AppLocalizations l10n) => switch (this) {
    strength => l10n.puzzleStrengthDescription,
    improvementArea => l10n.puzzleImprovementAreasDescription,
  };
}

enum Days {
  oneday(1),
  twodays(2),
  week(7),
  twoweeks(14),
  month(30),
  twomonths(60),
  threemonths(90);

  const Days(this.days);
  final int days;
}

String _daysL10n(BuildContext context, Days day) {
  switch (day) {
    case Days.oneday:
      return context.l10n.nbDays(1);
    case Days.twodays:
      return context.l10n.nbDays(2);
    case Days.week:
      return context.l10n.nbDays(7);
    case Days.twoweeks:
      return context.l10n.nbDays(14);
    case Days.month:
      return context.l10n.nbDays(30);
    case Days.twomonths:
      return context.l10n.nbDays(60);
    case Days.threemonths:
      return context.l10n.nbDays(90);
  }
}

class PuzzleThemeRow extends ConsumerWidget {
  final PuzzleDashboardData data;
  const PuzzleThemeRow({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeInfo = data.theme.l10n(context.l10n);
    final solvePercentage = data.nb > 0 ? (data.firstWins / data.nb * 100).toInt() : 0;

    return InkWell(
      onTap: () {
        Navigator.of(
          context,
          rootNavigator: true,
        ).push(PuzzleScreen.buildRoute(context, angle: PuzzleTheme(data.theme)));
        ref.invalidate(puzzleDashboardProvider);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(themeInfo.name, style: Styles.boardPreviewTitle),
            const SizedBox(height: 4),
            Text(
              themeInfo.description,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: Styles.formDescription,
            ),
            StatCardRow([
              StatCard(context.l10n.performance, value: data.performance.toString()),
              StatCard(context.l10n.puzzleSolved.capitalize(), value: '$solvePercentage%'),
              StatCard(
                context.l10n
                    .puzzleNbPlayed(data.nb)
                    .replaceAll(RegExp(r'\d+'), '')
                    .trim()
                    .capitalize(),
                value: data.nb.toString().localizeNumbers(),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
