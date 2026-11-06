import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/duration.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/account/rating_pref_aware.dart';
import 'package:lichess_mobile/src/view/user/game_history_screen.dart';
import 'package:lichess_mobile/src/view/user/rating_history_chart.dart';
import 'package:lichess_mobile/src/view/user/user_stat_cards.dart';
import 'package:material_ui/material_ui.dart';

/// Maximum number of perfs drawn in the rating history chart.
const _kMaxChartPerfs = 3;

/// The colors of the rating history chart series, in order, for the light and dark themes.
const _kLightSeriesColors = [Color(0xFF2A78D6), Color(0xFFEB6834), Color(0xFF1BAF7A)];
const _kDarkSeriesColors = [Color(0xFF3987E5), Color(0xFFD95926), Color(0xFF199E70)];

/// The stats of a user over all perfs: the rating history of the most played perfs, the game
/// results and the time spent playing.
class const UserStatsSection({required final User user, required final bool isMe, super.key})
    extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = user.count;
    final playTime = user.playTime;
    const cardSpacing = 12.0;

    final hasGames = count != null && count.all > 0;
    final theme = Theme.of(context);

    return Theme(
      // The section's padding and spacing lay out the cards.
      data: theme.copyWith(cardTheme: theme.cardTheme.copyWith(margin: EdgeInsets.zero)),
      child: Padding(
        padding: Styles.horizontalBodyPadding,
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            RatingPrefAware(child: _RatingHistoryCard(user: user)),
            if (hasGames)
              GameResultsCard(
                total: count.all,
                won: count.win,
                drawn: count.draw,
                lost: count.loss,
                onTap: () {
                  Navigator.of(context).push(
                    GameHistoryScreen.buildRoute(
                      user: isMe ? null : user.lightUser,
                      isOnline: ref.read(isDeviceOnlineProvider),
                    ),
                  );
                },
              ),
            if (playTime != null) ...[
              const SizedBox(height: cardSpacing),
              IconStatCard(
                icon: Icons.schedule,
                label: context.l10n.perfStatTimeSpentPlaying,
                value: playTime.total.toDaysHoursMinutes(AppLocalizations.of(context)),
                caption: playTime.tv > Duration.zero
                    ? context.l10n.tpTimeSpentOnTV(
                        playTime.tv.toDaysHoursMinutes(AppLocalizations.of(context)),
                      )
                    : null,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// The rating history of the user's most played perfs, in one chart.
///
/// Shows nothing while loading, on error, or if no perf has enough history to draw.
class const _RatingHistoryCard({required final User user}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(userRatingHistoryProvider(user.id)).value;
    if (history == null) return const SizedBox.shrink();

    final historyByPerf = {
      for (final perfHistory in history)
        if (perfHistory.points.length > 1) perfHistory.perf: perfHistory.points,
    };
    final mostPlayedPerfs =
        Perf.values
            .where((perf) {
              if (perf == Perf.puzzle || perf == Perf.storm || perf == Perf.streak) return false;
              final userPerf = user.perfs[perf];
              return userPerf != null &&
                  userPerf.numberOfGamesOrRuns > 0 &&
                  userPerf.ratingDeviation < kClueLessDeviation &&
                  historyByPerf.containsKey(perf);
            })
            .toList(growable: false)
          ..sort(
            (a, b) =>
                user.perfs[b]!.numberOfGamesOrRuns.compareTo(user.perfs[a]!.numberOfGamesOrRuns),
          );
    if (mostPlayedPerfs.isEmpty) return const SizedBox.shrink();

    final colors = Theme.of(context).brightness == Brightness.dark
        ? _kDarkSeriesColors
        : _kLightSeriesColors;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: RatingHistoryChart(
            IList([
              for (final (index, perf) in mostPlayedPerfs.take(_kMaxChartPerfs).indexed)
                RatingHistorySeries(perf: perf, points: historyByPerf[perf]!, color: colors[index]),
            ]),
          ),
        ),
      ),
    );
  }
}
