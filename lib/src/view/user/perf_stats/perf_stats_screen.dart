import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/game/game_filter.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/styles/icon_extensions.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/puzzle/dashboard_screen.dart';
import 'package:lichess_mobile/src/view/user/game_history_screen.dart';
import 'package:lichess_mobile/src/view/user/perf_stats/perf_stats_best_wins.dart';
import 'package:lichess_mobile/src/view/user/perf_stats/perf_stats_chart.dart';
import 'package:lichess_mobile/src/view/user/perf_stats/perf_stats_games_cards.dart';
import 'package:lichess_mobile/src/view/user/perf_stats/perf_stats_habits_card.dart';
import 'package:lichess_mobile/src/view/user/perf_stats/perf_stats_rating_card.dart';
import 'package:lichess_mobile/src/view/user/perf_stats/perf_stats_streak_cards.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/misc.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/platform_context_menu_button.dart';
import 'package:material_ui/material_ui.dart';

class const PerfStatsScreen({required final User user, required final Perf perf, super.key})
    extends StatelessWidget {
  static Route<dynamic> buildRoute({required User user, required Perf perf}) {
    return buildScreenRoute(
      screen: PerfStatsScreen(user: user, perf: perf),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: _Title(user: user, perf: perf),
      ),
      body: _Body(user: user, perf: perf),
    );
  }
}

class const _Title({required final User user, required final Perf perf}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final allPerfs = Perf.values
        .where((element) {
          if ([perf, Perf.storm, Perf.streak, Perf.fromPosition].contains(element)) {
            return false;
          }
          final p = user.perfs[element];
          return p != null &&
              p.games != null &&
              p.games! > 0 &&
              p.ratingDeviation < kClueLessDeviation;
        })
        .toList(growable: false);
    final title = Row(
      mainAxisSize: .min,
      spacing: 6.0,
      children: [
        Icon(perf.icon),
        Flexible(child: AppBarTitleText(context.l10n.perfStatPerfStats(perf.label(context.l10n)))),
      ],
    );
    if (allPerfs.isEmpty) return title;
    return ContextMenuTitleButton(
      semanticsLabel: context.l10n.perfStatPerfStats(perf.label(context.l10n)),
      title: title,
      actions: [
        for (final p in allPerfs)
          ContextMenuAction(
            icon: p.icon,
            label: context.l10n.perfStatPerfStats(p.label(context.l10n)),
            onPressed: () {
              Navigator.of(context)
                  .pushReplacement(PerfStatsScreen.buildRoute(user: user, perf: p));
            },
          ),
      ],
    );
  }
}

class const _Body({required final User user, required final Perf perf}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loggedInUser = ref.watch(authControllerProvider);
    final ratingHistory = ref.watch(userRatingHistoryProvider(user.id));
    const statGroupSpace = SizedBox(height: 16.0);

    // For puzzle perfs, only show the rating history chart
    if (perf == Perf.puzzle) {
      return ListView(
        padding: Styles.bodyPadding.add(MediaQuery.paddingOf(context)),
        children: [
          PerfStatsChart(ratingHistory: ratingHistory, perf: perf),
          // Show puzzle dashboard if viewing own puzzle perf
          if (user.id == loggedInUser?.user.id) ...[
            const SizedBox(height: 16),
            const PuzzleDashboardWidget(showDaysSelector: true),
          ],
        ],
      );
    }

    final perfStats = ref.watch(userPerfStatsProvider((user.id, perf)));

    return perfStats.when(
      data: (data) {
        return ListView(
          padding: Styles.bodyPadding.add(MediaQuery.paddingOf(context)),
          scrollDirection: Axis.vertical,
          children: [
            PerfStatsChart(ratingHistory: ratingHistory, perf: perf),
            statGroupSpace,
            PerfStatsRatingCard(
              data: data,
              perf: perf,
              user: user,
              isMe: loggedInUser?.user.id == user.id,
            ),
            statGroupSpace,
            PerfStatsTotalGamesCard(
              data: data,
              onViewGames: () {
                Navigator.of(context).push(
                  GameHistoryScreen.buildRoute(
                    user: user.lightUser,
                    isOnline: true,
                    gameFilter: GameFilterState(perfs: ISet({perf})),
                  ),
                );
              },
            ),
            statGroupSpace,
            PerfStatsGamesBreakdownCard(data: data),
            statGroupSpace,
            PerfStatsAverageOpponentCard(data: data),
            statGroupSpace,
            PerfStatsStreakCard(
              title: context.l10n.perfStatWinningStreak,
              icon: Icons.local_fire_department,
              color: context.lichessColors.good,
              currentStreak: data.curWinStreak,
              maxStreak: data.maxWinStreak,
            ),
            statGroupSpace,
            PerfStatsStreakCard(
              title: context.l10n.perfStatLosingStreak,
              icon: Icons.local_fire_department,
              color: context.lichessColors.error,
              currentStreak: data.curLossStreak,
              maxStreak: data.maxLossStreak,
            ),
            statGroupSpace,
            PerfStatsPlayingHabitsCard(data: data),
            if (data.bestWins != null && data.bestWins!.isNotEmpty) ...[
              statGroupSpace,
              PerfStatsBestWins(games: data.bestWins!, user: user),
            ],
          ],
        );
      },
      error: (error, stackTrace) {
        debugPrint('SEVERE: [PerfStatsScreen] could not load data; $error\n$stackTrace');
        return const Center(child: Text('Could not load user stats.'));
      },
      loading: () => const CenterLoadingIndicator(),
    );
  }
}
