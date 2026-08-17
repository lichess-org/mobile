import 'dart:math' as math;

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
// Only these two: intl also exports a `TextDirection` that would shadow the one used when
// painting labels.
import 'package:intl/intl.dart' show Intl, NumberFormat;
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/utils/duration.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:material_ui/material_ui.dart';

typedef MoveTimesChartParams = ({
  /// Time spent on each move, in ply order, starting at the ply following [rootPly]
  IList<Duration> moveTimes,

  /// Clock remaining after each move, in ply order, starting at the ply following [rootPly]
  IList<Duration> clocks,

  /// Game phase division information (opening/middlegame/endgame boundaries)
  Division? division,

  /// The ply number at the root of the analysis tree
  int rootPly,

  /// The ply number of the current position being viewed
  int currentNodePly,

  /// Whether the current node is on the main line
  bool isOnMainline,

  /// Callback when user taps/drags to jump to a specific node
  void Function(int nodeIndex) onJumpToNode,
});

/// Everything above 20 minutes is flattened, as on the web client.
const _maxMoveTimeCentis = 120000;

final double _logThreeSquared = math.pow(math.log(3), 2).toDouble();

/// Scales a move time the way the web client's move-time chart does
/// (`ui/chart/src/movetime.ts`): a log scale, so that both very fast and very slow moves stay
/// readable on the same axis.
double scaleMoveTime(Duration moveTime) {
  final centis = math.min(moveTime.inMilliseconds / 10, _maxMoveTimeCentis.toDouble());
  final logged = math.log(0.005 * centis + 3);
  return logged * logged - _logThreeSquared;
}

/// A chart displaying the time spent on each move over the course of a game.
///
/// White's moves are drawn above the axis and black's below it, with the remaining clock of each
/// player overlaid as a line. Tapping the chart seeks the board to the matching ply.
class MoveTimesChart extends StatelessWidget {
  const MoveTimesChart({required this.params, super.key});

  final MoveTimesChartParams params;

  /// Index in the series of the currently viewed move, or null if the current node is not a move
  /// on the main line.
  int? get _currentIndex {
    if (!params.isOnMainline) return null;
    final index = params.currentNodePly - 1 - params.rootPly;
    return index >= 0 && index < params.moveTimes.length ? index : null;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    final labelStyle = Theme.of(context).textTheme.labelMedium;
    // The same colors as the eval chart: the lighter of the two greys stands for white in either
    // theme.
    final surface = colorScheme.surfaceContainerHighest;
    final outline = colorScheme.outline;
    final isLight = Theme.of(context).brightness == .light;
    final currentIndex = _currentIndex;
    final total = params.moveTimes.fold(Duration.zero, (sum, time) => sum + time);
    // The labels sit on top of the chart, so they are faded enough for the bars and lines to stay
    // readable underneath them.
    final overlayStyle = labelStyle?.copyWith(
      color: labelStyle.color?.withValues(alpha: 0.6) ?? colorScheme.onSurface,
    );

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AspectRatio(
          aspectRatio: 2.5,
          child: LayoutBuilder(
            builder: (context, constraints) {
              void jumpToOffset(Offset offset) {
                final index = (offset.dx / constraints.maxWidth * params.moveTimes.length)
                    .floor()
                    .clamp(0, params.moveTimes.length - 1);
                params.onJumpToNode(index);
              }

              return Stack(
                children: [
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: .opaque,
                      onTapDown: (details) => jumpToOffset(details.localPosition),
                      onHorizontalDragUpdate: (details) => jumpToOffset(details.localPosition),
                      child: CustomPaint(
                        size: Size.infinite,
                        painter: _MoveTimesPainter(
                          params: params,
                          currentIndex: currentIndex,
                          whiteColor: isLight ? surface : outline,
                          blackColor: isLight ? outline : surface,
                          axisColor: colorScheme.outlineVariant,
                          lineColor: colorScheme.secondary,
                          // The web client draws the remaining clocks in blue; the app's own
                          // blue keeps that reading while still belonging here, one shade either
                          // side of it so the line stays legible over the grey bars in both
                          // themes.
                          clockColor: isLight
                              ? LichessColors.primary.shade600
                              : LichessColors.primary.shade300,
                          divisionColor: const Color(0xFF707070),
                          divisionLabelColor:
                              labelStyle?.color?.withValues(alpha: 0.3) ?? colorScheme.outline,
                          divisionLabels: (
                            opening: context.l10n.opening,
                            middlegame: context.l10n.middlegame,
                            endgame: context.l10n.endgame,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // The time spent on the selected move, in the top corner.
                  if (currentIndex != null)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IgnorePointer(
                        child: Text(_moveTimeLabel(context, currentIndex), style: overlayStyle),
                      ),
                    ),
                  // The total time of the game, in the opposite corner.
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IgnorePointer(
                      child: Text(
                        '${context.l10n.duration}: ${total.toHoursMinutesSeconds()}',
                        style: overlayStyle,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// The time spent on the move at [index], as shown over the chart.
  String _moveTimeLabel(BuildContext context, int index) {
    final seconds = params.moveTimes[index].inMilliseconds / 1000;
    if (seconds == 1) return context.l10n.nbSeconds(1);
    // Move times come in centiseconds, so two decimals are exact. The decimal separator and any
    // grouping follow the locale, and trailing zeros are dropped, so a whole move time reads as
    // '4 seconds' rather than '4.00 seconds'.
    final formatted = (NumberFormat.decimalPattern(
      Intl.getCurrentLocale(),
    )..maximumFractionDigits = 2).format(seconds);
    // `nbSeconds` only takes a whole count, so the plural form is taken from a sample count and
    // the number swapped for the decimal one.
    return context.l10n.nbSeconds(2).replaceFirst('2', formatted);
  }
}

typedef _DivisionLabels = ({String opening, String middlegame, String endgame});

class _MoveTimesPainter extends CustomPainter {
  _MoveTimesPainter({
    required this.params,
    required this.currentIndex,
    required this.whiteColor,
    required this.blackColor,
    required this.axisColor,
    required this.lineColor,
    required this.clockColor,
    required this.divisionColor,
    required this.divisionLabelColor,
    required this.divisionLabels,
  });

  final MoveTimesChartParams params;
  final int? currentIndex;
  final Color whiteColor;
  final Color blackColor;
  final Color axisColor;

  /// Color of the current ply cursor.
  final Color lineColor;

  /// Color of the remaining clock lines.
  final Color clockColor;
  final Color divisionColor;
  final Color divisionLabelColor;
  final _DivisionLabels divisionLabels;

  /// Whether the move at [index] was played by white.
  bool _isWhiteMove(int index) => (params.rootPly + index + 1).isOdd;

  @override
  void paint(Canvas canvas, Size size) {
    final moveTimes = params.moveTimes;
    if (moveTimes.isEmpty || size.width <= 0 || size.height <= 0) return;

    final middle = size.height / 2;
    final columnWidth = size.width / moveTimes.length;

    final scaled = moveTimes.map(scaleMoveTime).toList(growable: false);
    // Both colors share the same scale, as on the web client, so that the two halves of the chart
    // are comparable.
    final maxScaled = scaled.reduce(math.max);
    final maxClock = params.clocks.isEmpty
        ? Duration.zero
        : params.clocks.reduce((a, b) => a > b ? a : b);

    // Bars: white above the axis, black below it.
    for (var i = 0; i < scaled.length; i++) {
      if (maxScaled <= 0) break;
      final barHeight = scaled[i] / maxScaled * middle;
      final isWhite = _isWhiteMove(i);
      final rect = Rect.fromLTRB(
        i * columnWidth,
        isWhite ? middle - barHeight : middle,
        (i + 1) * columnWidth,
        isWhite ? middle : middle + barHeight,
      );
      canvas.drawRect(rect, Paint()..color = isWhite ? whiteColor : blackColor);
    }

    // Remaining clock, one line per color, mirrored the same way as the bars.
    if (maxClock > Duration.zero) {
      // The same weight and alpha as the eval chart's line.
      final linePaint = Paint()
        ..color = clockColor.withValues(alpha: 0.7)
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;
      for (final isWhite in const [true, false]) {
        final path = Path();
        var started = false;
        for (var i = 0; i < params.clocks.length && i < moveTimes.length; i++) {
          if (_isWhiteMove(i) != isWhite) continue;
          final ratio = params.clocks[i].inMilliseconds / maxClock.inMilliseconds;
          final x = (i + 0.5) * columnWidth;
          final y = isWhite ? middle - ratio * middle : middle + ratio * middle;
          if (started) {
            path.lineTo(x, y);
          } else {
            path.moveTo(x, y);
            started = true;
          }
        }
        if (started) canvas.drawPath(path, linePaint);
      }
    }

    canvas.drawLine(
      Offset(0, middle),
      Offset(size.width, middle),
      Paint()
        ..color = axisColor
        ..strokeWidth = 0.5,
    );

    _paintDivisionLines(canvas, size, columnWidth);

    final index = currentIndex;
    if (index != null) {
      final x = (index + 0.5) * columnWidth;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        Paint()
          ..color = lineColor
          ..strokeWidth = 1.0,
      );
    }
  }

  void _paintDivisionLines(Canvas canvas, Size size, double columnWidth) {
    final division = params.division;
    if (division == null) return;

    void phaseLine(int index, String label) {
      final x = (index + 0.5) * columnWidth;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        Paint()
          ..color = divisionColor
          ..strokeWidth = 0.5,
      );
      // Rotated to read top-to-bottom on the right of the line, as the eval chart draws it.
      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(fontSize: 10, color: divisionLabelColor),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: size.height);
      canvas.save();
      canvas.translate(math.min(x + 1 + textPainter.height, size.width), 1);
      canvas.rotate(math.pi / 2);
      textPainter.paint(canvas, Offset.zero);
      canvas.restore();
    }

    if (division.middlegame != null) {
      if (division.middlegame! > 0) {
        phaseLine(0, divisionLabels.opening);
        phaseLine(division.middlegame! - 1, divisionLabels.middlegame);
      } else {
        phaseLine(0, divisionLabels.middlegame);
      }
    }

    if (division.endgame != null) {
      if (division.endgame! > 0) {
        phaseLine(division.endgame! - 1, divisionLabels.endgame);
      } else {
        phaseLine(0, divisionLabels.endgame);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MoveTimesPainter oldDelegate) {
    // Compare cheap scalar fields first to avoid deep equality on IList fields inside `params`.
    if (oldDelegate.currentIndex != currentIndex ||
        oldDelegate.whiteColor != whiteColor ||
        oldDelegate.blackColor != blackColor ||
        oldDelegate.axisColor != axisColor ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.clockColor != clockColor ||
        oldDelegate.divisionColor != divisionColor ||
        oldDelegate.divisionLabelColor != divisionLabelColor ||
        oldDelegate.params.rootPly != params.rootPly ||
        oldDelegate.params.currentNodePly != params.currentNodePly ||
        oldDelegate.params.isOnMainline != params.isOnMainline ||
        oldDelegate.params.division != params.division) {
      return true;
    }

    // Only fall back to list/function equality when all scalar inputs are unchanged.
    return oldDelegate.params.moveTimes != params.moveTimes ||
        oldDelegate.params.clocks != params.clocks ||
        oldDelegate.params.onJumpToNode != params.onJumpToNode;
  }
}
