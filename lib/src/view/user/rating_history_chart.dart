import 'dart:math';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/icon_extensions.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/platform_segmented_control.dart';
import 'package:material_ui/material_ui.dart';

/// The rating history of one perf, drawn with [color] and [lineStyle] in a [RatingHistoryChart].
@immutable
class const RatingHistorySeries({
  required final Perf perf,
  required final IList<UserRatingHistoryPoint> points,
  required final Color color,
  final RatingHistoryLineStyle lineStyle = .solid,
});

/// The stroke pattern of a [RatingHistorySeries] line, which tells series apart, even when their
/// colors are hard to distinguish.
enum RatingHistoryLineStyle() {
  solid,
  dashed,
  dotted,
  dashDotted;

  /// The lengths of the dashes and gaps, alternately, before the round caps add a stroke width to
  /// each dash.
  List<int>? get dashArray => switch (this) {
    solid => null,
    dashed => const [8, 6],
    dotted => const [1, 6],
    dashDotted => const [12, 5, 1, 5],
  };
}

/// A line chart of the rating history of one or more perfs over a selectable date range.
///
/// With a single series, the header shows the rating change over the range and the area below the
/// line is filled. With several, or if [alwaysShowLegend] is true, the header is a legend giving
/// each perf's rating and change.
///
/// Every series must have at least one point.
class const RatingHistoryChart(
  final IList<RatingHistorySeries> series, {
  final bool alwaysShowLegend = false,
  super.key,
}) extends StatefulWidget {
  @override
  State<RatingHistoryChart> createState() => _RatingHistoryChartState();
}

class _RatingHistoryChartState() extends State<RatingHistoryChart> {
  late DateRange _selectedRange;

  /// The first date of all series, day 0 of the x axis.
  late DateTime _firstDate;

  /// The last date of all series.
  late DateTime _lastDate;

  /// One spot per day for each series, from its first point to [_lastDate]: the rating stays
  /// constant on days without games.
  late List<List<FlSpot>> _allSpots;

  /// The side of the touch line the tooltip is on, away from the closest edge of the chart so that
  /// it never has to shift over the line to fit.
  FLHorizontalAlignment _tooltipAlignment = .right;

  double get _minX => max(0, _startDate(_selectedRange).difference(_firstDate).inDays.toDouble());

  double get _maxX => _lastDate.difference(_firstDate).inDays.toDouble();

  DateTime _startDate(DateRange dateRange) => switch (dateRange) {
    DateRange.oneWeek => _lastDate.subtract(const Duration(days: 7)),
    DateRange.oneMonth => _lastDate.copyWith(month: _lastDate.month - 1),
    DateRange.threeMonths => _lastDate.copyWith(month: _lastDate.month - 3),
    DateRange.oneYear => _lastDate.copyWith(year: _lastDate.year - 1),
    DateRange.allTime => _firstDate,
  };

  bool _dateIsInRange(DateRange dateRange) => !_firstDate.isAfter(_startDate(dateRange));

  @override
  void initState() {
    super.initState();
    _computeSpots();
    _selectedRange = [
      DateRange.threeMonths,
      DateRange.oneMonth,
      DateRange.oneWeek,
    ].firstWhere(_dateIsInRange, orElse: () => DateRange.allTime);
  }

  @override
  void didUpdateWidget(RatingHistoryChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.series != widget.series) {
      _computeSpots();
      if (!_dateIsInRange(_selectedRange)) _selectedRange = DateRange.allTime;
    }
  }

  void _computeSpots() {
    _firstDate = widget.series
        .map((s) => s.points.first.date)
        .reduce((a, b) => a.isBefore(b) ? a : b);
    _lastDate = widget.series.map((s) => s.points.last.date).reduce((a, b) => a.isAfter(b) ? a : b);
    final lastDay = _lastDate.difference(_firstDate).inDays;
    _allSpots = [
      for (final s in widget.series)
        () {
          final ratingByDay = {
            for (final point in s.points) point.date.difference(_firstDate).inDays: point.elo,
          };
          final firstDay = s.points.first.date.difference(_firstDate).inDays;
          final spots = <FlSpot>[];
          int rating = s.points.first.elo;
          for (int day = firstDay; day <= lastDay; day++) {
            rating = ratingByDay[day] ?? rating;
            spots.add(FlSpot(day.toDouble(), rating.toDouble()));
          }
          return spots;
        }(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    final gridColor = colorScheme.onSurface.withValues(alpha: 0.08);
    final axisLabelStyle = TextStyle(color: textShade(context, 0.5), fontSize: 10);
    final isSingle = !widget.alwaysShowLegend && widget.series.length == 1;
    final chartDateFormatter = switch (_selectedRange) {
      DateRange.oneWeek || DateRange.oneMonth => DateFormat.MMMd(),
      DateRange.threeMonths || DateRange.oneYear || DateRange.allTime => DateFormat.yMMM(),
    };
    final minX = _minX;
    final maxX = _maxX;
    final visibleSpots = [
      for (final spots in _allSpots)
        spots.where((spot) => spot.x >= minX && spot.x <= maxX).toList(growable: false),
    ];
    final allVisibleRatings = visibleSpots.expand((spots) => spots.map((spot) => spot.y));
    final minY = (allVisibleRatings.reduce(min) / 100).floorToDouble() * 100;
    final maxY = (allVisibleRatings.reduce(max) / 100).ceilToDouble() * 100;
    final ranges = DateRange.values.where(_dateIsInRange).toList(growable: false);

    /// The rating change of the series at [index] over the selected range, null if it has no
    /// rating in the range.
    int? ratingChange(int index) {
      final spots = visibleSpots[index];
      return spots.isEmpty ? null : (spots.last.y - spots.first.y).round();
    }

    String formatDate(double nbDays, DateFormat format) =>
        format.format(_firstDate.add(Duration(days: nbDays.toInt())));

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        if (isSingle)
          _RatingChange(change: ratingChange(0) ?? 0, range: _selectedRange)
        else
          // Two entries per line, in columns.
          Column(
            spacing: 8.0,
            children: [
              for (var row = 0; row < widget.series.length; row += 2)
                Row(
                  spacing: 12.0,
                  children: [
                    for (final index in [row, row + 1])
                      Expanded(
                        child: index < widget.series.length
                            ? _LegendEntry(
                                series: widget.series[index],
                                rating: visibleSpots[index].lastOrNull?.y.toInt(),
                                change: ratingChange(index),
                              )
                            : const SizedBox.shrink(),
                      ),
                  ],
                ),
            ],
          ),
        const SizedBox(height: 16.0),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: LineChart(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            LineChartData(
              minX: minX,
              maxX: maxX,
              minY: minY,
              maxY: maxY,
              clipData: const FlClipData.all(),
              lineBarsData: [
                for (final (index, s) in widget.series.indexed)
                  LineChartBarData(
                    spots: visibleSpots[index],
                    isCurved: true,
                    preventCurveOverShooting: true,
                    isStrokeCapRound: true,
                    isStrokeJoinRound: true,
                    dotData: const FlDotData(show: false),
                    color: s.color,
                    barWidth: isSingle ? 2.5 : 2.0,
                    dashArray: s.lineStyle.dashArray,
                    belowBarData: BarAreaData(
                      show: isSingle,
                      gradient: LinearGradient(
                        begin: .topCenter,
                        end: .bottomCenter,
                        colors: [s.color.withValues(alpha: 0.3), s.color.withValues(alpha: 0.0)],
                      ),
                    ),
                  ),
              ],
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) =>
                    FlLine(color: gridColor, strokeWidth: 1, dashArray: const [4, 4]),
              ),
              lineTouchData: LineTouchData(
                touchSpotThreshold: double.infinity,
                touchCallback: (_, response) {
                  final x = response?.lineBarSpots?.firstOrNull?.x;
                  if (x == null) return;
                  final alignment = x > (minX + maxX) / 2
                      ? FLHorizontalAlignment.left
                      : FLHorizontalAlignment.right;
                  if (alignment != _tooltipAlignment) {
                    setState(() => _tooltipAlignment = alignment);
                  }
                },
                getTouchLineEnd: (_, _) => double.infinity,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (_) => colorScheme.surfaceContainerHighest,
                  tooltipBorderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  tooltipPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  showOnTopOfTheChartBoxArea: true,
                  tooltipHorizontalAlignment: _tooltipAlignment,
                  tooltipHorizontalOffset: _tooltipAlignment == .left ? -8.0 : 8.0,
                  fitInsideHorizontally: true,
                  fitInsideVertically: true,
                  getTooltipItems: (touchedSpots) {
                    final ratingStyle = TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    );
                    final perfLabelStyle = TextStyle(
                      fontWeight: FontWeight.normal,
                      color: colorScheme.onSurfaceVariant,
                    );
                    final dateStyle = TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 11,
                      color: colorScheme.onSurfaceVariant,
                    );
                    final series = [for (final spot in touchedSpots) widget.series[spot.barIndex]];
                    return [
                      for (final (index, touchedSpot) in touchedSpots.indexed)
                        LineTooltipItem(
                          '',
                          ratingStyle,
                          children: [
                            if (!isSingle) ...[
                              // The perf icon, in the color of its line, as a glyph of its icon
                              // font.
                              TextSpan(
                                text: String.fromCharCode(series[index].perf.icon.codePoint),
                                style: perfLabelStyle.copyWith(
                                  color: series[index].color,
                                  fontFamily: series[index].perf.icon.fontFamily,
                                  package: series[index].perf.icon.fontPackage,
                                ),
                              ),
                              TextSpan(
                                text: ' ${series[index].perf.shortLabel(context.l10n)} ',
                                style: perfLabelStyle,
                              ),
                            ],
                            TextSpan(text: touchedSpot.y.toInt().toString()),
                            // the date, once, below the last rating
                            if (index == touchedSpots.length - 1)
                              TextSpan(
                                text: '\n${formatDate(touchedSpot.x, DateFormat.yMMMd())}',
                                style: dateStyle,
                              ),
                          ],
                        ),
                    ];
                  },
                ),
                getTouchedSpotIndicator: (barData, spotIndexes) {
                  final color = barData.color ?? Styles.chartColor(context);
                  return spotIndexes.map((spotIndex) {
                    return TouchedSpotIndicatorData(
                      FlLine(
                        color: textShade(context, 0.3) ?? color,
                        strokeWidth: 1,
                        dashArray: const [3, 3],
                      ),
                      FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 5,
                            color: color,
                            strokeWidth: 2,
                            strokeColor: colorScheme.surface,
                          );
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
                    interval: max(1, (maxX - minX) / 3),
                    // The placement of the bottom titles is not perfect
                    // See the issue https://github.com/imaNNeo/fl_chart/issues/1605
                    getTitlesWidget: (value, meta) {
                      if (value == minX || value == maxX) return const SizedBox.shrink();
                      return SideTitleWidget(
                        meta: meta,
                        child: Text(formatDate(value, chartDateFormatter), style: axisLabelStyle),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 35,
                    getTitlesWidget: (value, meta) => SideTitleWidget(
                      meta: meta,
                      child: Text(value.toInt().toString(), style: axisLabelStyle),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (ranges.length > 1) ...[
          const SizedBox(height: 12.0),
          PlatformSegmentedControl<DateRange>(
            segments: [for (final range in ranges) (range, range.label(context.l10n))],
            selected: _selectedRange,
            showSelectedIcon: false,
            expandedInsets: EdgeInsets.zero,
            onChanged: (range) => setState(() => _selectedRange = range),
          ),
        ],
      ],
    );
  }
}

/// The color of a rating change: good when it goes up, error when it goes down.
Color? _changeColor(BuildContext context, int change) => change > 0
    ? context.lichessColors.green
    : change < 0
    ? context.lichessColors.red
    : textShade(context, 0.5);

String _formatChange(int change) => change > 0 ? '+$change' : '$change';

class const _RatingChange({required final int change, required final DateRange range})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final color = _changeColor(context, change);
    return Row(
      spacing: 6.0,
      children: [
        Icon(
          change > 0
              ? Icons.trending_up
              : change < 0
              ? Icons.trending_down
              : Icons.trending_flat,
          color: color,
        ),
        Text(
          _formatChange(change),
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: color),
        ),
        Text(range.label(context.l10n), style: TextStyle(color: textShade(context, 0.5))),
      ],
    );
  }
}

class const _LegendEntry({
  required final RatingHistorySeries series,
  required final int? rating,
  required final int? change,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4.0,
      children: [
        CustomPaint(
          size: const Size(20.0, 4.0),
          painter: _LegendLinePainter(color: series.color, lineStyle: series.lineStyle),
        ),
        Flexible(
          child: Text(
            series.perf.shortLabel(context.l10n),
            maxLines: 1,
            overflow: .ellipsis,
            style: TextStyle(color: textShade(context, 0.7)),
          ),
        ),
        Text(rating?.toString() ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
        if (change != null && change != 0)
          Text(
            _formatChange(change!),
            style: TextStyle(fontSize: 12.0, color: _changeColor(context, change!)),
          ),
      ],
    );
  }
}

/// A short horizontal line in the color and stroke pattern of a series.
class const _LegendLinePainter({
  required final Color color,
  required final RatingHistoryLineStyle lineStyle,
}) extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.height * 0.6
      ..strokeCap = .round;
    final y = size.height / 2;
    // Inset by the round caps, which extend past both ends of each dash.
    final start = paint.strokeWidth / 2;
    final end = size.width - paint.strokeWidth / 2;
    final dashArray = lineStyle.dashArray;
    if (dashArray == null) {
      canvas.drawLine(Offset(start, y), Offset(end, y), paint);
      return;
    }
    // Dashes and gaps alternate, cycling through the array.
    var index = 0;
    for (double x = start; x <= end; index = (index + 2) % dashArray.length) {
      canvas.drawLine(Offset(x, y), Offset(min(x + dashArray[index], end), y), paint);
      x += dashArray[index] + dashArray[index + 1];
    }
  }

  @override
  bool shouldRepaint(_LegendLinePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.lineStyle != lineStyle;
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
