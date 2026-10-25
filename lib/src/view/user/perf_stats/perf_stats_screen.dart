import 'dart:math';

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/game/game_filter.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/styles/icon_extensions.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/puzzle/dashboard_screen.dart';
import 'package:lichess_mobile/src/view/user/game_history_screen.dart';
import 'package:lichess_mobile/src/view/user/perf_stats/perf_stats_best_wins.dart';
import 'package:lichess_mobile/src/view/user/perf_stats/perf_stats_games_cards.dart';
import 'package:lichess_mobile/src/view/user/perf_stats/perf_stats_habits_card.dart';
import 'package:lichess_mobile/src/view/user/perf_stats/perf_stats_rating_card.dart';
import 'package:lichess_mobile/src/view/user/perf_stats/perf_stats_streak_cards.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/misc.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/platform_context_menu_button.dart';
import 'package:material_ui/material_ui.dart';

class const PerfStatsScreen({required final User user, required final Perf perf, super.key})
    extends StatelessWidget {
  static Route<dynamic> buildRoute({required User user, required Perf perf}) {
    return buildScreenRoute(
      screen: PerfStatsScreen(user: user, perf: perf),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: _Title(user: user, perf: perf),
      ),
      body: _Body(user: user, perf: perf),
    );
  }
}

class const _Title({required final User user, required final Perf perf}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final allPerfs = Perf.values
        .where((element) {
          if ([perf, Perf.storm, Perf.streak, Perf.fromPosition].contains(element)) {
            return false;
          }
          final p = user.perfs[element];
          return p != null &&
              p.games != null &&
              p.games! > 0 &&
              p.ratingDeviation < kClueLessDeviation;
        })
        .toList(growable: false);
    final title = Row(
      mainAxisSize: .min,
      spacing: 6.0,
      children: [
        Icon(perf.icon),
        Flexible(child: AppBarTitleText(context.l10n.perfStatPerfStats(perf.label(context.l10n)))),
      ],
    );
    if (allPerfs.isEmpty) return title;
    return ContextMenuTitleButton(
      semanticsLabel: context.l10n.perfStatPerfStats(perf.label(context.l10n)),
      title: title,
      actions: [
        for (final p in allPerfs)
          ContextMenuAction(
            icon: p.icon,
            label: context.l10n.perfStatPerfStats(p.label(context.l10n)),
            onPressed: () {
              Navigator.of(context)
                  .pushReplacement(PerfStatsScreen.buildRoute(user: user, perf: p));
            },
          ),
      ],
    );
  }
}

class const _Body({required final User user, required final Perf perf}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ratingHistory = ref.watch(userRatingHistoryProvider(user.id));
    final loggedInUser = ref.watch(authControllerProvider);
    const statGroupSpace = SizedBox(height: 16.0);

    // For puzzle perfs, only show the rating history chart
    if (perf == Perf.puzzle) {
      return ListView(
        padding: Styles.bodyPadding.add(MediaQuery.paddingOf(context)),
        children: [
          ratingHistory.when(
            data: (ratingHistoryData) {
              final ratingHistoryPerfData = ratingHistoryData.firstWhereOrNull(
                (element) => element.perf == perf,
              );

              if (ratingHistoryPerfData == null || ratingHistoryPerfData.points.length <= 1) {
                return const SizedBox.shrink();
              }
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _EloChart(ratingHistoryPerfData),
                ),
              );
            },
            error: (error, stackTrace) {
              debugPrint(
                'SEVERE: [PerfStatsScreen] could not load rating history data; $error\n$stackTrace',
              );
              return const Center(child: Text('Could not show rating chart'));
            },
            loading: () => const CenterLoadingIndicator(),
          ),
          // Show puzzle dashboard if viewing own puzzle perf
          if (user.id == loggedInUser?.user.id) ...[
            const SizedBox(height: 16),
            const PuzzleDashboardWidget(showDaysSelector: true),
          ],
        ],
      );
    }

    final perfStats = ref.watch(userPerfStatsProvider((user.id, perf)));

    return perfStats.when(
      data: (data) {
        return ListView(
          padding: Styles.bodyPadding.add(MediaQuery.paddingOf(context)),
          scrollDirection: Axis.vertical,
          children: [
            ratingHistory.when(
              data: (ratingHistoryData) {
                final ratingHistoryPerfData = ratingHistoryData.firstWhereOrNull(
                  (element) => element.perf == perf,
                );

                if (ratingHistoryPerfData == null || ratingHistoryPerfData.points.length <= 1) {
                  return const SizedBox.shrink();
                }
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _EloChart(ratingHistoryPerfData),
                  ),
                );
              },
              error: (error, stackTrace) {
                debugPrint(
                  'SEVERE: [PerfStatsScreen] could not load rating history data; $error\n$stackTrace',
                );
                return const Text('Could not show rating chart');
              },
              loading: () {
                return const SizedBox.shrink();
              },
            ),
            if (perf != Perf.puzzle) ...[
              statGroupSpace,
              PerfStatsRatingCard(
                data: data,
                perf: perf,
                user: user,
                isMe: loggedInUser?.user.id == user.id,
              ),
              statGroupSpace,
              PerfStatsTotalGamesCard(
                data: data,
                onViewGames: () {
                  Navigator.of(context).push(
                    GameHistoryScreen.buildRoute(
                      user: user.lightUser,
                      isOnline: true,
                      gameFilter: GameFilterState(perfs: ISet({perf})),
                    ),
                  );
                },
              ),
              statGroupSpace,
              PerfStatsGamesBreakdownCard(data: data),
              statGroupSpace,
              PerfStatsAverageOpponentCard(data: data),
              statGroupSpace,
              PerfStatsStreakCard(
                title: context.l10n.perfStatWinningStreak,
                icon: Icons.local_fire_department,
                color: context.lichessColors.good,
                currentStreak: data.curWinStreak,
                maxStreak: data.maxWinStreak,
              ),
              statGroupSpace,
              PerfStatsStreakCard(
                title: context.l10n.perfStatLosingStreak,
                icon: Icons.local_fire_department,
                color: context.lichessColors.error,
                currentStreak: data.curLossStreak,
                maxStreak: data.maxLossStreak,
              ),
              statGroupSpace,
              PerfStatsPlayingHabitsCard(data: data),
              if (data.bestWins != null && data.bestWins!.isNotEmpty) ...[
                statGroupSpace,
                PerfStatsBestWins(games: data.bestWins!, user: user),
              ],
            ],
          ],
        );
      },
      error: (error, stackTrace) {
        debugPrint('SEVERE: [PerfStatsScreen] could not load data; $error\n$stackTrace');
        return const Center(child: Text('Could not load user stats.'));
      },
      loading: () => const CenterLoadingIndicator(),
    );
  }
}

class const _EloChart(final UserRatingHistoryPerf value) extends StatefulWidget {
  @override
  State<_EloChart> createState() => _EloChartState();
}

class _EloChartState() extends State<_EloChart> {
  late DateRange _selectedRange;

  late List<FlSpot> _allFlSpot;

  List<FlSpot> get _flSpot =>
      _allFlSpot.where((element) => element.x >= _minX && element.x <= _maxX).toList();

  IList<UserRatingHistoryPoint> get _points => widget.value.points;

  DateTime get _firstDate => _points.first.date;

  DateTime get _lastDate => _points.last.date;

  double get _minY => (_flSpot.map((e) => e.y).reduce(min) / 100).floorToDouble() * 100;

  double get _maxY => (_flSpot.map((e) => e.y).reduce(max) / 100).ceilToDouble() * 100;

  double get _minX => _startDate(_selectedRange).difference(_firstDate).inDays.toDouble();

  double get _maxX => _allFlSpot.last.x;

  DateTime _startDate(DateRange dateRange) => switch (dateRange) {
    DateRange.oneWeek => _lastDate.subtract(const Duration(days: 7)),
    DateRange.oneMonth => _lastDate.copyWith(month: _lastDate.month - 1),
    DateRange.threeMonths => _lastDate.copyWith(month: _lastDate.month - 3),
    DateRange.oneYear => _lastDate.copyWith(year: _lastDate.year - 1),
    DateRange.allTime => _firstDate,
  };

  bool _dateIsInRange(DateRange dateRange) =>
      _firstDate.isBefore(_startDate(dateRange)) ||
      _firstDate.isAtSameMomentAs(_startDate(dateRange));

  @override
  void initState() {
    super.initState();

    // We need to fill in the missing days in the rating history because rating should be constant for days where no games were played

    final List<UserRatingHistoryPoint> pointsHistoryRatingCompleted = [];
    final numberOfDays = _lastDate.difference(_firstDate).inDays + 1;

    int j = 0;
    for (int i = 0; i < numberOfDays; i++) {
      final currentDate = _firstDate.add(Duration(days: i));
      if (_points[j].date == currentDate) {
        pointsHistoryRatingCompleted.add(_points[j]);
        j += 1;
      } else {
        pointsHistoryRatingCompleted.add(
          UserRatingHistoryPoint(date: currentDate, elo: _points[j - 1].elo),
        );
      }
    }

    _allFlSpot = pointsHistoryRatingCompleted
        .map(
          (element) =>
              FlSpot(element.date.difference(_firstDate).inDays.toDouble(), element.elo.toDouble()),
        )
        .toList();

    if (_dateIsInRange(DateRange.threeMonths)) {
      _selectedRange = DateRange.threeMonths;
    } else if (_dateIsInRange(DateRange.oneMonth)) {
      _selectedRange = DateRange.oneMonth;
    } else if (_dateIsInRange(DateRange.oneWeek)) {
      _selectedRange = DateRange.oneWeek;
    } else {
      _selectedRange = DateRange.allTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = ColorScheme.of(context).onSurface.withValues(alpha: 0.5);
    final chartColor = Styles.chartColor(context);
    final chartDateFormatter = switch (_selectedRange) {
      DateRange.oneWeek => DateFormat.MMMd(),
      DateRange.oneMonth => DateFormat.MMMd(),
      DateRange.threeMonths => DateFormat.yMMM(),
      DateRange.oneYear => DateFormat.yMMM(),
      DateRange.allTime => DateFormat.yMMM(),
    };

    String formatDateFromTimestamp(double nbDays) =>
        chartDateFormatter.format(_firstDate.add(Duration(days: nbDays.toInt())));

    String formatDateFromTimestampForTooltip(double nbDays) =>
        DateFormat.yMMMd().format(_firstDate.add(Duration(days: nbDays.toInt())));

    Widget leftTitlesWidget(double value, TitleMeta meta) {
      return SideTitleWidget(
        meta: meta,
        child: Text(
          value.toInt().toString(),
          style: TextStyle(color: textShade(context, 0.6), fontSize: 10),
        ),
      );
    }

    Widget bottomTitlesWidget(double value, TitleMeta meta) {
      if (value == _minX || value == _maxX) return const SizedBox.shrink();

      return SideTitleWidget(
        meta: meta,
        child: Text(
          formatDateFromTimestamp(value),
          style: TextStyle(color: textShade(context, 0.6), fontSize: 10),
        ),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 25),
            ...DateRange.values
                .where((dateRange) => _dateIsInRange(dateRange))
                .map(
                  (dateRange) => _RangeButton(
                    text: dateRange.label(context.l10n),
                    onPressed: () {
                      setState(() {
                        _selectedRange = dateRange;
                      });
                    },
                    selected: _selectedRange == dateRange,
                  ),
                ),
          ],
        ),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: LineChart(
            duration: Duration.zero,
            LineChartData(
              minX: _minX,
              maxX: _maxX,
              minY: _minY,
              maxY: _maxY,
              lineBarsData: [
                LineChartBarData(
                  spots: _flSpot,
                  dotData: const FlDotData(show: false),
                  color: chartColor,
                  belowBarData: BarAreaData(color: chartColor.withValues(alpha: 0.3), show: true),
                  barWidth: 1.5,
                ),
              ],
              borderData: FlBorderData(
                show: true,
                border: Border(
                  bottom: BorderSide(color: borderColor),
                  left: BorderSide(color: borderColor),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) => FlLine(color: borderColor, strokeWidth: 0.5),
              ),
              lineTouchData: LineTouchData(
                touchSpotThreshold: double.infinity,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (_) => chartColor.withValues(alpha: 0.5),
                  fitInsideHorizontally: true,
                  fitInsideVertically: true,
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots
                        .map(
                          (LineBarSpot touchedSpot) => LineTooltipItem(
                            '${touchedSpot.y.toInt()}\n',
                            Styles.bold,
                            children: [
                              TextSpan(
                                text: formatDateFromTimestampForTooltip(touchedSpot.x),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                              ),
                            ],
                          ),
                        )
                        .toList();
                  },
                ),
                getTouchedSpotIndicator: (barData, spotIndexes) {
                  return spotIndexes.map((spotIndex) {
                    return TouchedSpotIndicatorData(
                      FlLine(color: chartColor, strokeWidth: 2),
                      FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(radius: 5, color: chartColor);
                        },
                      ),
                    );
                  }).toList();
                },
              ),
              titlesData: FlTitlesData(
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 25,
                    getTitlesWidget: bottomTitlesWidget,
                    interval: (_maxX - _minX) / 3,
                    // The placement of the bottom titles is not perfect
                    // See the issue https://github.com/imaNNeo/fl_chart/issues/1605
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 35,
                    getTitlesWidget: leftTitlesWidget,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class const _RangeButton({
  required final String text,
  required final VoidCallback onPressed,
  final bool selected = false,
}) extends StatelessWidget {
  static const _borderRadius = BorderRadius.all(Radius.circular(20.0));

  @override
  Widget build(BuildContext context) {
    final chartColor = Styles.chartColor(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: selected ? chartColor.withValues(alpha: 0.15) : Colors.transparent,
        borderRadius: _borderRadius,
      ),
      child: InkWell(
        borderRadius: _borderRadius,
        onTap: onPressed,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44.0, minWidth: 44.0),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected ? chartColor : textShade(context, 0.7),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum DateRange() {
  oneWeek,
  oneMonth,
  threeMonths,
  oneYear,
  allTime;

  String label(AppLocalizations _) => switch (this) {
    DateRange.oneWeek => '1W',
    DateRange.oneMonth => '1M',
    DateRange.threeMonths => '3M',
    DateRange.oneYear => '1Y',
    DateRange.allTime => 'ALL',
  };
}
