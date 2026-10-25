import 'dart:math';

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:material_ui/material_ui.dart';

/// The rating history chart of a user, with the range buttons above it.
class const PerfStatsChart({
  required final AsyncValue<IList<UserRatingHistoryPerf>> ratingHistory,
  required final Perf perf,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    switch (ratingHistory) {
      case AsyncData(:final value):
        final perfData = value.firstWhereOrNull((element) => element.perf == perf);

        if (perfData == null || perfData.points.length <= 1) {
          return const SizedBox.shrink();
        }
        return Card(
          child: Padding(padding: const EdgeInsets.all(16.0), child: _RatingChart(perfData)),
        );
      case AsyncError(:final error, :final stackTrace):
        debugPrint(
          'SEVERE: [PerfStatsChart] could not load rating history data; $error\n$stackTrace',
        );
        return const Center(child: Text('Could not show rating chart'));
      case _:
        return const SizedBox.shrink();
    }
  }
}

class const _RatingChart(final UserRatingHistoryPerf value) extends StatefulWidget {
  @override
  State<_RatingChart> createState() => _RatingChartState();
}

class _RatingChartState() extends State<_RatingChart> {
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

  DateFormat get _axisDateFormat => switch (_selectedRange) {
    DateRange.oneWeek => DateFormat.MMMd(),
    DateRange.oneMonth => DateFormat.MMMd(),
    DateRange.threeMonths => DateFormat.yMMM(),
    DateRange.oneYear => DateFormat.yMMM(),
    DateRange.allTime => DateFormat.yMMM(),
  };

  String _formatAxisDate(double nbDays) =>
      _axisDateFormat.format(_firstDate.add(Duration(days: nbDays.toInt())));

  String _formatTooltipDate(double nbDays) =>
      DateFormat.yMMMd().format(_firstDate.add(Duration(days: nbDays.toInt())));

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
            _chartData(borderColor: borderColor, chartColor: chartColor),
            duration: Duration.zero,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  LineChartData _chartData({required Color borderColor, required Color chartColor}) {
    return LineChartData(
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
      lineTouchData: _touchData(chartColor),
      titlesData: FlTitlesData(
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 25,
            getTitlesWidget: (value, meta) {
              if (value == _minX || value == _maxX) return const SizedBox.shrink();
              return _AxisLabel(_formatAxisDate(value), meta: meta);
            },
            interval: (_maxX - _minX) / 3,
            // The placement of the bottom titles is not perfect
            // See the issue https://github.com/imaNNeo/fl_chart/issues/1605
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 35,
            getTitlesWidget: (value, meta) => _AxisLabel(value.toInt().toString(), meta: meta),
          ),
        ),
      ),
    );
  }

  LineTouchData _touchData(Color chartColor) {
    return LineTouchData(
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
                      text: _formatTooltipDate(touchedSpot.x),
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
    );
  }
}

class const _AxisLabel(final String text, {required final TitleMeta meta}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SideTitleWidget(
      meta: meta,
      child: Text(text, style: TextStyle(color: textShade(context, 0.6), fontSize: 10)),
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
