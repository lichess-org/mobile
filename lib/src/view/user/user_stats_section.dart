import 'package:collection/collection.dart';
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
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:material_ui/material_ui.dart';

/// Maximum number of perfs drawn in the rating history chart: one per line style, which tell the
/// lines apart on top of their colors.
final _kMaxChartPerfs = RatingHistoryLineStyle.values.length;

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
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: Column(
                    children: [
                      IconStatRow(
                        icon: Icons.schedule,
                        label: context.l10n.perfStatTimeSpentPlaying,
                        value: playTime.total.toDaysHoursMinutes(AppLocalizations.of(context)),
                      ),
                      if (playTime.tv > Duration.zero) ...[
                        const Divider(height: 1.0),
                        IconStatRow(
                          icon: Icons.live_tv_outlined,
                          // The translation ends with the time: "Time featured on TV: {param}".
                          label: context.l10n
                              .tpTimeSpentOnTV('')
                              .replaceFirst(RegExp(r'[\s:：]+$'), ''),
                          value: playTime.tv.toDaysHoursMinutes(AppLocalizations.of(context)),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// The rating history of the user's most played perfs, then puzzles, in one chart.
///
/// Shows nothing while loading, on error, or if no perf has enough history to draw.
class const _RatingHistoryCard({required final User user}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isRated(Perf perf) {
      final userPerf = user.perfs[perf];
      return userPerf != null &&
          userPerf.numberOfGamesOrRuns > 0 &&
          userPerf.ratingDeviation < kClueLessDeviation;
    }

    final asyncHistory = ref.watch(userRatingHistoryProvider(user.id));
    final history = asyncHistory.value;
    if (history == null) {
      // A skeleton of the chart while it loads, if the user has a perf it may draw.
      final mayHaveChart = Perf.values.any(
        (perf) => perf != .storm && perf != .streak && isRated(perf),
      );
      return asyncHistory.isLoading && mayHaveChart
          ? const Padding(
              padding: EdgeInsets.only(bottom: 12.0),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Shimmer(
                    child: ShimmerLoading(
                      isLoading: true,
                      child: Column(
                        crossAxisAlignment: .stretch,
                        children: [
                          // the legend
                          FractionallySizedBox(
                            alignment: .centerLeft,
                            widthFactor: 0.7,
                            child: _SkeletonBox(height: 20.0),
                          ),
                          SizedBox(height: 16.0),
                          AspectRatio(aspectRatio: 16 / 9, child: _SkeletonBox()),
                          SizedBox(height: 12.0),
                          // the date range control
                          _SkeletonBox(height: 36.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          : const SizedBox.shrink();
    }

    final historyByPerf = {
      for (final perfHistory in history)
        if (perfHistory.points.length > 1) perfHistory.perf: perfHistory.points,
    };
    bool hasChartableHistory(Perf perf) => isRated(perf) && historyByPerf.containsKey(perf);

    // The most played game perfs, then puzzles if there is room left.
    final chartPerfs = [
      ...Perf.values
          .where((perf) => perf != .puzzle && perf != .storm && perf != .streak)
          .where(hasChartableHistory)
          .sortedByCompare(
            (perf) => user.perfs[perf]!.numberOfGamesOrRuns,
            (a, b) => b.compareTo(a),
          ),
      if (hasChartableHistory(.puzzle)) Perf.puzzle,
    ];
    if (chartPerfs.isEmpty) return const SizedBox.shrink();

    final drawnPerfs = chartPerfs.take(_kMaxChartPerfs).toList();
    final colors = Styles.chartColors(context, drawnPerfs.length);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: RatingHistoryChart(
            IList([
              for (final (index, perf) in drawnPerfs.indexed)
                RatingHistorySeries(
                  perf: perf,
                  points: historyByPerf[perf]!,
                  color: colors[index],
                  lineStyle: RatingHistoryLineStyle.values[index],
                ),
            ]),
            alwaysShowLegend: true,
          ),
        ),
      ),
    );
  }
}

/// A rounded placeholder shape, painted by an enclosing [ShimmerLoading].
class const _SkeletonBox({final double? height}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: const DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
    );
  }
}
