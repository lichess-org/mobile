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
    return PerfStatsCard(
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: .w600)),
          const SizedBox(height: 20),
          _StreakDetails(
            label: context.l10n.perfStatCurrentStreak('').replaceAll(':', ''),
            streak: currentStreak,
            color: color,
          ),
          const SizedBox(height: 24),
          _StreakDetails(
            label: context.l10n.perfStatLongestStreak('').replaceAll(':', ''),
            streak: maxStreak,
            color: color,
          ),
        ],
      ),
    );
  }
}

class const _StreakDetails({
  required final String label,
  required final UserStreak? streak,
  required final Color color,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final value = streak;
    final isEmpty = value == null || value.isValueEmpty;
    final count = isEmpty ? 0 : perfStatsStreakValue(value);
    final dates = isEmpty ? null : formatPerfStatsStreakDates(value);
    final visibleDots = count.clamp(0, 16);

    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontSize: perfStatsLabelFontSize, color: textShade(context, 0.7)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isEmpty ? '-' : perfStatsStreakValueLabel(context, value),
                style: TextStyle(fontSize: 20, fontWeight: .w600, color: color),
                textAlign: .end,
                semanticsLabel: isEmpty ? context.l10n.none : null,
              ),
            ),
          ],
        ),
        if (count > 0) ...[
          const SizedBox(height: 10),
          ExcludeSemantics(
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              crossAxisAlignment: .center,
              children: [
                for (var i = 0; i < visibleDots; i++)
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(color: color, shape: .circle),
                  ),
                if (count > visibleDots)
                  Text(
                    '+${context.l10n.nbGames(count - visibleDots)}',
                    style: TextStyle(fontSize: perfStatsSupportingFontSize, color: color),
                  ),
              ],
            ),
          ),
        ],
        if (dates != null) ...[
          const SizedBox(height: 10),
          Text(
            dates,
            style: TextStyle(fontSize: perfStatsLabelFontSize, color: textShade(context, 0.85)),
          ),
        ],
      ],
    );
  }
}
