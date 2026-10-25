import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/user/perf_stats/perf_stats_common.dart';
import 'package:material_ui/material_ui.dart';

class const PerfStatsStreakCard({
  required final String title,
  required final IconData icon,
  required final Color color,
  required final UserStreak? currentStreak,
  required final UserStreak? maxStreak,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final current = currentStreak;
    final best = maxStreak;
    final currentValue = current == null || current.isValueEmpty
        ? '-'
        : perfStatsStreakValueLabel(context, current);
    final maxValue = best == null || best.isValueEmpty
        ? '-'
        : perfStatsStreakValueLabel(context, best);
    final bestValue = perfStatsStreakValue(best);
    final progress = bestValue == 0
        ? 0.0
        : (perfStatsStreakValue(current) / bestValue).clamp(0.0, 1.0);
    final currentDates = formatPerfStatsStreakDates(current);
    final maxDates = formatPerfStatsStreakDates(best);
    final supportingStyle = TextStyle(
      fontSize: perfStatsSupportingFontSize,
      color: textShade(context, perfStatsSecondaryOpacity),
    );

    return PerfStatsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PerfStatsIconTile(icon, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text(
                      currentValue,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
                      semanticsLabel: currentValue == '-' ? context.l10n.none : null,
                    ),
                    Text(
                      context.l10n.perfStatCurrentStreak('').replaceAll(':', ''),
                      style: supportingStyle,
                    ),
                    if (currentDates != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        currentDates,
                        style: TextStyle(fontSize: 11, color: textShade(context, 0.5)),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Text(
                  context.l10n.perfStatLongestStreak('').replaceAll(':', ''),
                  style: supportingStyle,
                ),
              ),
              Text(
                maxValue,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: color),
                textAlign: TextAlign.end,
                semanticsLabel: maxValue == '-' ? context.l10n.none : null,
              ),
            ],
          ),
          if (maxDates != null) ...[
            const SizedBox(height: 2),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                maxDates,
                style: TextStyle(fontSize: 11, color: textShade(context, 0.5)),
                textAlign: TextAlign.end,
              ),
            ),
          ],
          const SizedBox(height: 14),
          ExcludeSemantics(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8.0,
                backgroundColor: color.withValues(alpha: 0.15),
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
