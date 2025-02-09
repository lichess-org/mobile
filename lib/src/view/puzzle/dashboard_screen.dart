import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' show ClientException;
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_providers.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/utils/string.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:lichess_mobile/src/widgets/stat_card.dart';

final daysProvider = StateProvider<Days>((ref) => Days.month);

class PuzzleDashboardScreen extends StatelessWidget {
  const PuzzleDashboardScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(
      context,
      title: context.l10n.puzzlePuzzleDashboard,
      screen: const PuzzleDashboardScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const PlatformScaffold(
      body: _Body(),
      appBar: PlatformAppBar(title: SizedBox.shrink(), actions: [DaysSelector()]),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(children: [PuzzleDashboardWidget()]);
  }
}

class PuzzleDashboardWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puzzleDashboard = ref.watch(puzzleDashboardProvider(ref.watch(daysProvider).days));
    final cardColor = Theme.of(context).platform == TargetPlatform.iOS ? Colors.transparent : null;

    return puzzleDashboard.when(
      data: (dashboard) {
        if (dashboard == null) {
          return const SizedBox.shrink();
        }
        final chartData = dashboard.themes.take(9).sortedBy((e) => e.theme.name).toList();
        return ListSection(
          header: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.l10n.puzzlePuzzleDashboard),
              Text(
                context.l10n.puzzlePuzzleDashboardDescription,
                style: Styles.subtitle.copyWith(color: textShade(context, Styles.subtitleOpacity)),
              ),
            ],
          ),
          // hack to make the divider take full length or row
          cupertinoAdditionalDividerMargin: -14,
          children: [
            StatCardRow([
              StatCard(
                context.l10n.performance,
                value: dashboard.global.performance.toString(),
                backgroundColor: cardColor,
                elevation: 0,
              ),
              StatCard(
                context.l10n
                    .puzzleNbPlayed(dashboard.global.nb)
                    .replaceAll(RegExp(r'\d+'), '')
                    .trim()
                    .capitalize(),
                value: dashboard.global.nb.toString().localizeNumbers(),
                backgroundColor: cardColor,
                elevation: 0,
              ),
              StatCard(
                context.l10n.puzzleSolved.capitalize(),
                value: '${((dashboard.global.firstWins / dashboard.global.nb) * 100).round()}%',
                backgroundColor: cardColor,
                elevation: 0,
              ),
            ]),
            if (chartData.length >= 3) PuzzleChart(chartData),
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

class PuzzleChart extends StatelessWidget {
  const PuzzleChart(this.puzzleData);

  final List<PuzzleDashboardData> puzzleData;

  @override
  Widget build(BuildContext context) {
    final radarColor = ColorScheme.of(context).onSurface.withValues(alpha: 0.5);
    final chartColor = ColorScheme.of(context).secondary;
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
                dataEntries:
                    puzzleData
                        .map((theme) => RadarEntry(value: theme.performance.toDouble()))
                        .toList(),
              ),
            ],
            getTitle:
                (index, angle) =>
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
    final session = ref.watch(authSessionProvider);
    final day = ref.watch(daysProvider);
    return session != null
        ? AppBarTextButton(
          onPressed:
              () => showChoicePicker(
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
