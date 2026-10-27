import 'package:intl/intl.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/duration.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:material_ui/material_ui.dart';

const perfStatsSecondaryOpacity = 0.6;

const perfStatsLabelFontSize = 14.0;
const perfStatsSupportingFontSize = 12.0;
const perfStatsRowValueStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
const perfStatsMainValueStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 30);

DateFormat get perfStatsDateFormat => DateFormat.yMMMd();

Color perfStatsDividerColor(BuildContext context) =>
    ColorScheme.of(context).onSurface.withValues(alpha: 0.12);

String? formatPerfStatsStreakDates(UserStreak? streak) {
  final start = streak?.startGame?.finishedAt;
  final end = streak?.endGame?.finishedAt;
  if (start == null || end == null) return null;
  if (start.year == end.year && start.month == end.month && start.day == end.day) {
    return perfStatsDateFormat.format(start);
  }
  if (start.year == end.year) {
    return '${DateFormat.MMMd().format(start)} – ${perfStatsDateFormat.format(end)}';
  }
  return '${perfStatsDateFormat.format(start)} – ${perfStatsDateFormat.format(end)}';
}

int perfStatsStreakValue(UserStreak? streak) => switch (streak) {
  null => 0,
  UserGameStreak(:final gamesPlayed) => gamesPlayed,
  UserTimeStreak(:final timePlayed) => timePlayed.inSeconds,
};

String perfStatsStreakValueLabel(BuildContext context, UserStreak streak) => switch (streak) {
  UserGameStreak(:final gamesPlayed) => context.l10n.nbGames(gamesPlayed),
  UserTimeStreak(:final timePlayed) => timePlayed.toDaysHoursMinutes(AppLocalizations.of(context)),
};

class const PerfStatsCard({required final Widget child}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(padding: const EdgeInsets.all(16.0), child: child),
    );
  }
}

class const PerfStatsRow({required final String label, final String? value, final Widget? trailing})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: perfStatsLabelFontSize,
              color: textShade(context, perfStatsSecondaryOpacity),
            ),
          ),
        ),
        if (trailing != null) trailing! else Text(value ?? '', style: perfStatsRowValueStyle),
      ],
    );
  }
}

class const PerfStatsCompactCard({
  required final IconData icon,
  required final String label,
  required final String value,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final iconColor = Styles.chartColor(context);

    return PerfStatsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20, color: iconColor),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: perfStatsSupportingFontSize,
                    color: textShade(context, perfStatsSecondaryOpacity),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class const PerfStatsIconTile(final IconData icon, {final Color? color}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tileColor = color ?? Styles.chartColor(context);

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: tileColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Icon(icon, size: 22, color: tileColor),
    );
  }
}
