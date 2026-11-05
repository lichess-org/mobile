import 'dart:math' as math;

import 'package:dynamic_system_colors/dynamic_system_colors.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/styles/icon_extensions.dart';
import 'package:lichess_mobile/src/styles/perf_colors.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/move_times_chart.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:material_ui/material_ui.dart';

/// Temporary screen to review the perf icon colors.
class const PerfColorsDebugScreen({super.key}) extends StatelessWidget {
  static Route<dynamic> buildRoute() {
    return buildScreenRoute(screen: const PerfColorsDebugScreen());
  }

  @override
  Widget build(BuildContext context) {
    final lichessColors = context.lichessColors;
    return PlatformScaffold(
      appBar: const PlatformAppBar(title: Text('Perf colors')),
      body: ListView(
        children: [
          ListSection(
            header: const Text('HCT hues: time controls'),
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  height: 130,
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: _HueStripPainter(
                      brightness: Theme.of(context).brightness,
                      schemePrimary: ColorScheme.of(context).primary,
                      labelColor: DefaultTextStyle.of(context).style.color!,
                    ),
                  ),
                ),
              ),
            ],
          ),
          ListSection(
            header: const Text('Scheme primary (was lichess blue)'),
            children: [
              Container(
                height: 35,
                width: double.infinity,
                color: ColorScheme.of(context).primary,
                child: Center(
                  child: Text(
                    'Pairings are now closed.',
                    style: TextStyle(color: ColorScheme.of(context).onPrimary),
                  ),
                ),
              ),
              Container(
                height: 35,
                width: double.infinity,
                color: lichessColors.good,
                child: const Center(
                  child: Text('Stand by veloce', style: TextStyle(color: Colors.white)),
                ),
              ),
              ListTile(
                title: Text(
                  'View all 12 teams',
                  textAlign: .center,
                  style: TextStyle(color: ColorScheme.of(context).primary),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SizedBox(
                  height: 150,
                  child: MoveTimesChart(
                    params: (
                      moveTimes: _fakeMoveTimes,
                      clocks: _fakeClocks,
                      division: null,
                      rootPly: 0,
                      currentNodePly: 20,
                      isOnMainline: true,
                      onJumpToNode: (_) {},
                    ),
                  ),
                ),
              ),
            ],
          ),
          ListSection(
            header: const Text('Perfs'),
            hasLeading: true,
            children: [
              for (final perf in Perf.values)
                ListTile(
                  leading: Icon(perf.icon, color: perf.color(context)),
                  title: Text(perf.label(context.l10n)),
                  subtitle: Text(
                    '#${perf.color(context).toARGB32().toRadixString(16).substring(2).toUpperCase()}',
                  ),
                ),
            ],
          ),
          ListSection(
            header: const Text('Lichess colors (to avoid)'),
            hasLeading: true,
            children: [
              for (final (name, color) in [
                ('good', lichessColors.good),
                ('error', lichessColors.error),
                ('brag', lichessColors.brag),
                ('fancy', lichessColors.fancy),
                ('purple', lichessColors.purple),
                ('cyan', lichessColors.cyan),
                ('scheme primary', ColorScheme.of(context).primary),
              ])
                ListTile(
                  leading: Icon(Icons.circle, color: color),
                  title: Text(name),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

const _fakePlies = 60;

/// Pseudo random move times between 1 and 20 seconds.
final _fakeMoveTimes = IList([
  for (var i = 0; i < _fakePlies; i++)
    Duration(milliseconds: 1000 + ((math.sin(i * 1.7) + 1) * 9500).round()),
]);

/// Remaining clocks of a 10+0 game with the [_fakeMoveTimes].
final _fakeClocks = IList([
  for (var i = 0; i < _fakePlies; i++)
    const Duration(minutes: 10) -
        [for (var j = i % 2; j <= i; j += 2) _fakeMoveTimes[j]]
            .fold(Duration.zero, (a, b) => a + b),
]);

/// Time controls marked on the hue strip, with a short label.
const _timeControls = [
  (Perf.ultraBullet, 'UB'),
  (Perf.bullet, 'Bu'),
  (Perf.blitz, 'Bl'),
  (Perf.rapid, 'Ra'),
  (Perf.classical, 'Cl'),
  (Perf.correspondence, 'Co'),
];

/// HCT hues of the lichess colors the perf colors avoid.
const _avoidedHues = [(23.0, 'red'), (73.0, 'gold'), (133.0, 'green')];

/// Paints the HCT hue wheel unrolled, at the perf colors chroma and tone: raw on the top row,
/// harmonized with the scheme primary on the bottom row, with the avoided lichess hues above and
/// the time controls below.
class const _HueStripPainter({
  required final Brightness brightness,
  required final Color schemePrimary,
  required final Color labelColor,
}) extends CustomPainter {
  static const _labelsHeight = 22.0;
  static const _rowHeight = 32.0;

  @override
  void paint(Canvas canvas, Size size) {
    final tone = perfColorTone(brightness);
    const top = _labelsHeight;
    const harmonizedTop = top + _rowHeight + 2;
    double xOf(double hue) => hue / 360 * size.width;

    for (var x = 0.0; x < size.width; x++) {
      final hue = x / size.width * 360;
      final color = Color(Hct.from(hue, kPerfColorChroma, tone).toInt());
      canvas.drawRect(Rect.fromLTWH(x, top, 1.5, _rowHeight), Paint()..color = color);
      canvas.drawRect(
        Rect.fromLTWH(x, harmonizedTop, 1.5, _rowHeight),
        Paint()..color = color.harmonizeWith(schemePrimary),
      );
    }

    void label(String text, double x, double y, {bool bold = false}) {
      final painter = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: labelColor,
            fontSize: 11,
            fontWeight: bold ? FontWeight.bold : null,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(canvas, Offset(x - painter.width / 2, y));
    }

    final linePaint = Paint()
      ..color = labelColor
      ..strokeWidth = 1.5;

    for (final (hue, name) in _avoidedHues) {
      final x = xOf(hue);
      canvas.drawLine(Offset(x, top - 4), Offset(x, top + _rowHeight), linePaint);
      label(name, x, 0);
    }

    const bottom = harmonizedTop + _rowHeight;
    for (final (perf, name) in _timeControls) {
      final x = xOf(perf.colorHue);
      canvas.drawLine(Offset(x, top), Offset(x, bottom + 4), linePaint);
      label(name, x, bottom + 6, bold: true);
    }

    label('raw', 14, top + _rowHeight / 2 - 7);
    label('harmonized', 32, harmonizedTop + _rowHeight / 2 - 7);
  }

  @override
  bool shouldRepaint(_HueStripPainter oldDelegate) =>
      oldDelegate.brightness != brightness ||
      oldDelegate.schemePrimary != schemePrimary ||
      oldDelegate.labelColor != labelColor;
}
