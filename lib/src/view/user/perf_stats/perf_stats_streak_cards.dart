import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/user/perf_stats/perf_stats_common.dart';
import 'package:material_ui/material_ui.dart';

class const PerfStatsStreakCard({
  required final String title,
  required final Color color,
  required final UserStreak? currentStreak,
  required final UserStreak? maxStreak,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final current = currentStreak == null || currentStreak!.isValueEmpty
        ? 0
        : perfStatsStreakValue(currentStreak);
    final best = maxStreak == null || maxStreak!.isValueEmpty ? 0 : perfStatsStreakValue(maxStreak);
    final dotCount = (best > current ? best : current).clamp(0, 16);
    final filledDots = best == 0
        ? dotCount
        : current == 0
        ? 0
        : (current / best * dotCount).ceil().clamp(0, dotCount);

    return PerfStatsCard(
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              PerfStatsIconTile(Icons.local_fire_department, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: .w600)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: .start,
            children: [
              Expanded(
                child: _StreakDetails(
                  label: context.l10n.perfStatCurrentStreak('').replaceAll(':', ''),
                  streak: currentStreak,
                  color: color,
                  isCurrent: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _StreakDetails(
                  label: context.l10n.perfStatLongestStreak('').replaceAll(':', ''),
                  streak: maxStreak,
                  color: color,
                  isCurrent: false,
                ),
              ),
            ],
          ),
          if (dotCount > 0) ...[
            const SizedBox(height: 16),
            ExcludeSemantics(
              child: Row(
                spacing: 6,
                children: [
                  for (var i = 0; i < dotCount; i++)
                    Expanded(
                      child: Align(
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: i < filledDots ? color : color.withValues(alpha: 0.18),
                            shape: .circle,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class const _StreakDetails({
  required final String label,
  required final UserStreak? streak,
  required final Color color,
  required final bool isCurrent,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final value = streak;
    final isEmpty = value == null || value.isValueEmpty;
    final dates = isEmpty ? null : formatPerfStatsStreakDates(value);

    return Column(
      crossAxisAlignment: isCurrent ? .start : .end,
      children: [
        Text(
          isEmpty ? '-' : perfStatsStreakValueLabel(context, value),
          style: TextStyle(fontSize: 26, fontWeight: .bold, color: color),
          textAlign: isCurrent ? .start : .end,
          semanticsLabel: isEmpty ? context.l10n.none : null,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: perfStatsSupportingFontSize, color: textShade(context, 0.7)),
          textAlign: isCurrent ? .start : .end,
        ),
        if (dates != null) ...[
          const SizedBox(height: 6),
          Text(
            dates,
            style: TextStyle(fontSize: perfStatsLabelFontSize, color: textShade(context, 0.85)),
            textAlign: isCurrent ? .start : .end,
          ),
        ],
      ],
    );
  }
}
