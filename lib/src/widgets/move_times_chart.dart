import 'dart:math' as math;

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/utils/duration.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';

typedef MoveTimesChartParams = ({
  /// Time spent on each move, in ply order, starting at the ply following [rootPly]
  IList<Duration> moveTimes,

  /// Clock remaining after each move, in ply order, starting at the ply following [rootPly]
  IList<Duration> clocks,

  /// SAN of each move, in ply order, starting at the ply following [rootPly]
  IList<String> sanMoves,

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

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.0,
              child: currentIndex != null
                  ? Text(_moveLabel(context, currentIndex), style: labelStyle, overflow: .ellipsis)
                  : null,
            ),
            AspectRatio(
              aspectRatio: 2.5,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  void jumpToOffset(Offset offset) {
                    final index = (offset.dx / constraints.maxWidth * params.moveTimes.length)
                        .floor()
                        .clamp(0, params.moveTimes.length - 1);
                    params.onJumpToNode(index);
                  }

                  return GestureDetector(
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
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                '${context.l10n.duration} ${total.toHoursMinutesSeconds()}',
                style: labelStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _moveLabel(BuildContext context, int index) {
    final ply = params.rootPly + index + 1;
    final isWhiteMove = ply.isOdd;
    final moveNumber = (ply + 1) ~/ 2;
    final san = params.sanMoves.elementAtOrNull(index) ?? '';
    final moveTime = params.moveTimes[index];
    // Below two seconds a tenth of a second is meaningful, above it is noise. This is the same
    // precision rule the web client uses. `nbSeconds` only takes whole seconds, so shorter times
    // fall back to an untranslated 'x.ys'.
    final timeLabel = moveTime.inMilliseconds >= 2000
        ? context.l10n.nbSeconds((moveTime.inMilliseconds / 1000).round())
        : '${(moveTime.inMilliseconds / 1000).toStringAsFixed(1)}s';

    // The remaining clock is already drawn as a line on the chart, so it is not repeated here.
    return '$moveNumber${isWhiteMove ? '.' : '...'} $san · $timeLabel';
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
    required this.divisionColor,
    required this.divisionLabelColor,
    required this.divisionLabels,
  });

  final MoveTimesChartParams params;
  final int? currentIndex;
  final Color whiteColor;
  final Color blackColor;
  final Color axisColor;

  /// Color of the remaining clock lines and of the current ply cursor.
  final Color lineColor;
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
        ..color = lineColor.withValues(alpha: 0.7)
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
  bool shouldRepaint(covariant _MoveTimesPainter oldDelegate) =>
      oldDelegate.params != params ||
      oldDelegate.currentIndex != currentIndex ||
      oldDelegate.whiteColor != whiteColor ||
      oldDelegate.blackColor != blackColor ||
      oldDelegate.axisColor != axisColor ||
      oldDelegate.lineColor != lineColor ||
      oldDelegate.divisionColor != divisionColor ||
      oldDelegate.divisionLabelColor != divisionLabelColor;
}
