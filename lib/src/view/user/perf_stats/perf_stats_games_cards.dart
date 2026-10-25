import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/string.dart';
import 'package:lichess_mobile/src/view/user/perf_stats/perf_stats_common.dart';
import 'package:lichess_mobile/src/widgets/result_meter.dart';
import 'package:material_ui/material_ui.dart';

class const PerfStatsTotalGamesCard({
  required final UserPerfStats data,
  required final VoidCallback onViewGames,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dividerColor = perfStatsDividerColor(context);

    return PerfStatsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.perfStatTotalGames,
            style: TextStyle(
              fontSize: perfStatsLabelFontSize,
              color: textShade(context, perfStatsSecondaryOpacity),
            ),
          ),
          const SizedBox(height: 4),
          Text(data.totalGames.toString().localizeNumbers(), style: perfStatsMainValueStyle),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _ResultColumn(
                  label: context.l10n.wins,
                  value: data.wonGames,
                  totalGames: data.totalGames,
                  color: context.lichessColors.good,
                ),
              ),
              Expanded(
                child: _ResultColumn(
                  label: context.l10n.draws,
                  value: data.drawnGames,
                  totalGames: data.totalGames,
                ),
              ),
              Expanded(
                child: _ResultColumn(
                  label: context.l10n.losses,
                  value: data.lostGames,
                  totalGames: data.totalGames,
                  color: context.lichessColors.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ResultMeter(
            wins: data.wonGames,
            draws: data.drawnGames,
            losses: data.lostGames,
            height: 12,
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: dividerColor),
          Tooltip(
            excludeFromSemantics: true,
            message: context.l10n.perfStatViewTheGames,
            child: InkWell(
              borderRadius: Styles.cardBorderRadius,
              onTap: onViewGames,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        context.l10n.perfStatViewTheGames,
                        style: TextStyle(
                          fontSize: perfStatsLabelFontSize,
                          color: textShade(context, 0.8),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: textShade(context, perfStatsSecondaryOpacity),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class const _ResultColumn({
  required final String label,
  required final int value,
  required final int totalGames,
  final Color? color,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fraction = totalGames == 0 ? 0.0 : value / totalGames;
    final percentFormat = NumberFormat.percentPattern()
      ..minimumFractionDigits = 1
      ..maximumFractionDigits = 1;

    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: perfStatsLabelFontSize,
            color: textShade(context, perfStatsSecondaryOpacity),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value.toString().localizeNumbers(),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
        ),
        Text(
          percentFormat.format(fraction),
          style: TextStyle(
            fontSize: perfStatsLabelFontSize,
            color: color ?? textShade(context, 0.7),
          ),
        ),
      ],
    );
  }
}

class const PerfStatsGamesBreakdownCard({required final UserPerfStats data})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final totalGames = data.totalGames;

    return PerfStatsCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _BreakdownColumn(
              icon: Icons.verified,
              label: context.l10n.rated,
              value: data.ratedGames,
              totalGames: totalGames,
            ),
          ),
          Expanded(
            child: _BreakdownColumn(
              icon: LichessIcons.tournament_cup,
              label: context.l10n.tournament,
              value: data.tournamentGames,
              totalGames: totalGames,
            ),
          ),
          Expanded(
            child: _BreakdownColumn(
              icon: Icons.bolt,
              label: context.l10n.perfStatBerserkedGames.replaceAll(
                ' ${context.l10n.games.toLowerCase()}',
                '',
              ),
              value: data.berserkGames,
              totalGames: totalGames,
            ),
          ),
          Expanded(
            child: _BreakdownColumn(
              icon: Icons.link_off,
              label: context.l10n.perfStatDisconnections,
              value: data.disconnections,
              totalGames: totalGames,
            ),
          ),
        ],
      ),
    );
  }
}

class const _BreakdownColumn({
  required final IconData icon,
  required final String label,
  required final int value,
  required final int totalGames,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fraction = totalGames == 0 ? 0.0 : value / totalGames;

    return Column(
      children: [
        Icon(icon, size: 22, color: textShade(context, 0.7)),
        const SizedBox(height: 8),
        Text(
          label,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: perfStatsSupportingFontSize,
            color: textShade(context, perfStatsSecondaryOpacity),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value.toString().localizeNumbers(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        Text(
          NumberFormat.percentPattern().format(fraction),
          style: TextStyle(
            fontSize: perfStatsSupportingFontSize,
            color: textShade(context, perfStatsSecondaryOpacity),
          ),
        ),
      ],
    );
  }
}

class const PerfStatsAverageOpponentCard({required final UserPerfStats data})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final avgOpponent = data.avgOpponent;

    return PerfStatsCompactCard(
      icon: LichessIcons.target,
      label: context.l10n.averageOpponent,
      value: avgOpponent == null ? '?' : avgOpponent.round().toString().localizeNumbers(),
    );
  }
}
