import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/duration.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/user/perf_stats/perf_stats_common.dart';
import 'package:material_ui/material_ui.dart';

class const PerfStatsTimeSpentPlayingCard({required final UserPerfStats data})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PerfStatsCompactCard(
      icon: LichessIcons.clock,
      label: context.l10n.perfStatTimeSpentPlaying,
      value: data.timePlayed.toDaysHoursMinutes(AppLocalizations.of(context)),
    );
  }
}

class const PerfStatsPlayingHabitsCard({required final UserPerfStats data})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dividerColor = perfStatsDividerColor(context);

    return PerfStatsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PlayingHabitStreakRow(
            icon: Icons.repeat,
            title: context.l10n.perfStatGamesInARow,
            currentStreak: data.curPlayStreak,
            maxStreak: data.maxPlayStreak,
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: dividerColor),
          const SizedBox(height: 16),
          _PlayingHabitStreakRow(
            icon: Icons.timer,
            title: context.l10n.perfStatMaxTimePlaying,
            currentStreak: data.curTimeStreak,
            maxStreak: data.maxTimeStreak,
          ),
        ],
      ),
    );
  }
}

class const _PlayingHabitStreakRow({
  required final IconData icon,
  required final String title,
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
    final currentDates = formatPerfStatsStreakDates(current);
    final maxDates = formatPerfStatsStreakDates(best);
    final labelStyle = TextStyle(
      fontSize: perfStatsLabelFontSize,
      color: textShade(context, perfStatsSecondaryOpacity),
    );
    final smallStyle = TextStyle(fontSize: 11, color: textShade(context, 0.5));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 22, color: textShade(context, 0.7)),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: labelStyle)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.perfStatCurrentStreak('').replaceAll(':', ''),
                    style: smallStyle,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    currentValue,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  if (currentDates != null) ...[
                    const SizedBox(height: 2),
                    Text(currentDates, style: smallStyle),
                  ],
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    context.l10n.perfStatLongestStreak('').replaceAll(':', ''),
                    style: smallStyle,
                    textAlign: TextAlign.end,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    maxValue,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.end,
                  ),
                  if (maxDates != null) ...[
                    const SizedBox(height: 2),
                    Text(maxDates, style: smallStyle, textAlign: TextAlign.end),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
