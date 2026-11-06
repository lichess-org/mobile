import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/icon_extensions.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/user/perf_stats/perf_stats_common.dart';
import 'package:lichess_mobile/src/widgets/progression_widget.dart';
import 'package:lichess_mobile/src/widgets/rating.dart';
import 'package:material_ui/material_ui.dart';

class const PerfStatsRatingCard({
  required final UserPerfStats data,
  required final Perf perf,
  required final User user,
  required final bool isMe,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final percentile = data.percentile;
    final percentileText = percentile != null && percentile > 0.0
        ? (isMe
              ? context.l10n.youAreBetterThanPercentOfPerfTypePlayers(
                  '${percentile.toStringAsFixed(2)}%',
                  perf.label(context.l10n),
                )
              : context.l10n.userIsBetterThanPercentOfPerfTypePlayers(
                  user.username,
                  '${percentile.toStringAsFixed(2)}%',
                  perf.label(context.l10n),
                ))
        : null;
    final dividerColor = perfStatsDividerColor(context);

    return PerfStatsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PerfStatsIconTile(perf.icon),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.rating,
                      style: TextStyle(
                        fontSize: perfStatsLabelFontSize,
                        color: textShade(context, perfStatsSecondaryOpacity),
                      ),
                    ),
                    RatingWidget(
                      rating: data.rating,
                      deviation: data.deviation,
                      provisional: data.provisional,
                      style: perfStatsMainValueStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (percentileText != null) ...[
            const SizedBox(height: 12),
            Text(
              percentileText,
              style: TextStyle(
                fontSize: perfStatsSupportingFontSize,
                color: textShade(context, 0.7),
              ),
            ),
          ],
          const SizedBox(height: 16),
          // The number '12' here is not arbitrary, since the API returns the progression for the last 12 games (as far as I know).
          PerfStatsRow(
            label: context.l10n.perfStatProgressOverLastXGames('12').replaceAll(':', ''),
            trailing: ProgressionWidget(data.progress, useTrendArrows: true),
          ),
          if (data.rank != null) ...[
            const SizedBox(height: 10),
            PerfStatsRow(
              label: context.l10n.rank,
              value: NumberFormat.decimalPattern(Intl.getCurrentLocale()).format(data.rank),
            ),
          ],
          const SizedBox(height: 10),
          PerfStatsRow(
            label: context.l10n.perfStatRatingDeviation('').replaceAll(': .', ''),
            value: data.deviation.toStringAsFixed(2),
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: dividerColor),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _RatingRecord(
                  label: context.l10n.perfStatHighestRating('').replaceAll(':', ''),
                  rating: data.highestRating,
                  game: data.highestRatingGame,
                  color: context.lichessColors.good,
                ),
              ),
              Container(
                width: 1,
                height: 48,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                color: dividerColor,
              ),
              Expanded(
                child: _RatingRecord(
                  label: context.l10n.perfStatLowestRating('').replaceAll(':', ''),
                  rating: data.lowestRating,
                  game: data.lowestRatingGame,
                  color: context.lichessColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class const _RatingRecord({
  required final String label,
  required final int? rating,
  required final UserPerfGame? game,
  required final Color color,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: perfStatsSupportingFontSize,
            color: textShade(context, perfStatsSecondaryOpacity),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          rating?.toString() ?? '?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: rating == null ? textShade(context, perfStatsSecondaryOpacity) : color,
          ),
        ),
        if (game != null) ...[
          const SizedBox(height: 2),
          Text(
            perfStatsDateFormat.format(game!.finishedAt),
            style: TextStyle(
              fontSize: perfStatsSupportingFontSize,
              color: textShade(context, perfStatsSecondaryOpacity),
            ),
          ),
        ],
      ],
    );
  }
}
