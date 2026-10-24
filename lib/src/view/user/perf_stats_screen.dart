import 'dart:math';

import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/game/game_filter.dart';
import 'package:lichess_mobile/src/model/game/game_repository.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/styles/icon_extensions.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/tab_navigation.dart';
import 'package:lichess_mobile/src/utils/duration.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/string.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/puzzle/dashboard_screen.dart';
import 'package:lichess_mobile/src/view/user/game_history_screen.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/misc.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/platform_context_menu_button.dart';
import 'package:lichess_mobile/src/widgets/progression_widget.dart';
import 'package:lichess_mobile/src/widgets/rating.dart';
import 'package:lichess_mobile/src/widgets/result_meter.dart';
import 'package:lichess_mobile/src/widgets/user.dart';
import 'package:material_ui/material_ui.dart';

DateFormat get _dateFormatter => DateFormat.yMMMd();

String? _formatStreakDates(UserStreak? streak) {
  final start = streak?.startGame?.finishedAt;
  final end = streak?.endGame?.finishedAt;
  if (start == null || end == null) return null;
  if (start.year == end.year) {
    return '${DateFormat.MMMd().format(start)} – ${_dateFormatter.format(end)}';
  }
  return '${_dateFormatter.format(start)} – ${_dateFormatter.format(end)}';
}

int _streakValue(UserStreak? streak) => switch (streak) {
  null => 0,
  UserGameStreak(:final gamesPlayed) => gamesPlayed,
  UserTimeStreak(:final timePlayed) => timePlayed.inSeconds,
};

String _streakValueLabel(BuildContext context, UserStreak streak) => switch (streak) {
  UserGameStreak(:final gamesPlayed) => context.l10n.nbGames(gamesPlayed),
  UserTimeStreak(:final timePlayed) => timePlayed.toDaysHoursMinutes(AppLocalizations.of(context)),
};

const _customOpacity = 0.6;
const _labelFontSize = 14.0;
const _supportingFontSize = 12.0;
const _rowValueStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
const _mainValueStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 30);

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
    final ratingHistory = ref.watch(userRatingHistoryProvider(user.id));
    final loggedInUser = ref.watch(authControllerProvider);
    const statGroupSpace = SizedBox(height: 16.0);

    // For puzzle perfs, only show the rating history chart
    if (perf == Perf.puzzle) {
      return ListView(
        padding: Styles.bodyPadding.add(MediaQuery.paddingOf(context)),
        children: [
          ratingHistory.when(
            data: (ratingHistoryData) {
              final ratingHistoryPerfData = ratingHistoryData.firstWhereOrNull(
                (element) => element.perf == perf,
              );

              if (ratingHistoryPerfData == null || ratingHistoryPerfData.points.length <= 1) {
                return const SizedBox.shrink();
              }
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _EloChart(ratingHistoryPerfData),
                ),
              );
            },
            error: (error, stackTrace) {
              debugPrint(
                'SEVERE: [PerfStatsScreen] could not load rating history data; $error\n$stackTrace',
              );
              return const Center(child: Text('Could not show rating chart'));
            },
            loading: () => const CenterLoadingIndicator(),
          ),
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
            ratingHistory.when(
              data: (ratingHistoryData) {
                final ratingHistoryPerfData = ratingHistoryData.firstWhereOrNull(
                  (element) => element.perf == perf,
                );

                if (ratingHistoryPerfData == null || ratingHistoryPerfData.points.length <= 1) {
                  return const SizedBox.shrink();
                }
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _EloChart(ratingHistoryPerfData),
                  ),
                );
              },
              error: (error, stackTrace) {
                debugPrint(
                  'SEVERE: [PerfStatsScreen] could not load rating history data; $error\n$stackTrace',
                );
                return const Text('Could not show rating chart');
              },
              loading: () {
                return const SizedBox.shrink();
              },
            ),
            if (perf != Perf.puzzle) ...[
              statGroupSpace,
              _RatingCard(
                data: data,
                perf: perf,
                user: user,
                isMe: loggedInUser?.user.id == user.id,
              ),
              statGroupSpace,
              _TotalGamesCard(
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
              _GamesBreakdownCard(data: data),
              statGroupSpace,
              _AverageOpponentCard(data: data),
              statGroupSpace,
              _StreakCard(
                title: context.l10n.perfStatWinningStreak,
                icon: Icons.local_fire_department,
                color: context.lichessColors.good,
                currentStreak: data.curWinStreak,
                maxStreak: data.maxWinStreak,
              ),
              statGroupSpace,
              _StreakCard(
                title: context.l10n.perfStatLosingStreak,
                icon: Icons.local_fire_department,
                color: context.lichessColors.error,
                currentStreak: data.curLossStreak,
                maxStreak: data.maxLossStreak,
              ),
              statGroupSpace,
              _PlayingHabitsCard(data: data),
              if (data.bestWins != null && data.bestWins!.isNotEmpty) ...[
                statGroupSpace,
                _GameListWidget(
                  games: data.bestWins!,
                  perf: perf,
                  user: user,
                  header: Text(context.l10n.perfStatBestRated, style: Styles.sectionTitle),
                ),
              ],
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

class const _RatingCard({
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
    final dividerColor = ColorScheme.of(context).onSurface.withValues(alpha: 0.12);

    return _StatsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _IconTile(perf.icon),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.rating,
                      style: TextStyle(
                        fontSize: _labelFontSize,
                        color: textShade(context, _customOpacity),
                      ),
                    ),
                    RatingWidget(
                      rating: data.rating,
                      deviation: data.deviation,
                      provisional: data.provisional,
                      style: _mainValueStyle,
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
              style: TextStyle(fontSize: _supportingFontSize, color: textShade(context, 0.7)),
            ),
          ],
          const SizedBox(height: 16),
          // The number '12' here is not arbitrary, since the API returns the progression for the last 12 games (as far as I know).
          _StatRow(
            label: context.l10n.perfStatProgressOverLastXGames('12').replaceAll(':', ''),
            trailing: ProgressionWidget(data.progress, useTrendArrows: true),
          ),
          if (data.rank != null) ...[
            const SizedBox(height: 10),
            _StatRow(
              label: context.l10n.rank,
              value: NumberFormat.decimalPattern(Intl.getCurrentLocale()).format(data.rank),
            ),
          ],
          const SizedBox(height: 10),
          _StatRow(
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

class const _TotalGamesCard({
  required final UserPerfStats data,
  required final VoidCallback onViewGames,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dividerColor = ColorScheme.of(context).onSurface.withValues(alpha: 0.12);

    return _StatsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.perfStatTotalGames,
            style: TextStyle(fontSize: _labelFontSize, color: textShade(context, _customOpacity)),
          ),
          const SizedBox(height: 4),
          Text(data.totalGames.toString().localizeNumbers(), style: _mainValueStyle),
          const SizedBox(height: 16),
          ResultMeter(
            wins: data.wonGames,
            draws: data.drawnGames,
            losses: data.lostGames,
            height: 12,
          ),
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
              Container(
                width: 1,
                height: 64,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                color: dividerColor,
              ),
              Expanded(
                child: _ResultColumn(
                  label: context.l10n.draws,
                  value: data.drawnGames,
                  totalGames: data.totalGames,
                ),
              ),
              Container(
                width: 1,
                height: 64,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                color: dividerColor,
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
                        style: TextStyle(fontSize: _labelFontSize, color: textShade(context, 0.8)),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: textShade(context, _customOpacity),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: _labelFontSize, color: textShade(context, _customOpacity)),
        ),
        const SizedBox(height: 2),
        Text(
          value.toString().localizeNumbers(),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
        ),
        Text(
          percentFormat.format(fraction),
          style: TextStyle(fontSize: _labelFontSize, color: textShade(context, 0.7)),
        ),
      ],
    );
  }
}

class const _GamesBreakdownCard({required final UserPerfStats data}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final totalGames = data.totalGames;

    return _StatsCard(
      child: Column(
        spacing: 16.0,
        children: [
          _BreakdownRow(
            icon: Icons.verified,
            label: context.l10n.rated,
            value: data.ratedGames,
            totalGames: totalGames,
          ),
          _BreakdownRow(
            icon: LichessIcons.tournament_cup,
            label: context.l10n.tournament,
            value: data.tournamentGames,
            totalGames: totalGames,
          ),
          _BreakdownRow(
            icon: Icons.bolt,
            label: context.l10n.perfStatBerserkedGames.replaceAll(
              ' ${context.l10n.games.toLowerCase()}',
              '',
            ),
            value: data.berserkGames,
            totalGames: totalGames,
          ),
          _BreakdownRow(
            icon: Icons.link_off,
            label: context.l10n.perfStatDisconnections,
            value: data.disconnections,
            totalGames: totalGames,
          ),
        ],
      ),
    );
  }
}

class const _BreakdownRow({
  required final IconData icon,
  required final String label,
  required final int value,
  required final int totalGames,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fraction = totalGames == 0 ? 0.0 : value / totalGames;

    return Row(
      children: [
        Icon(icon, size: 22, color: textShade(context, 0.7)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: _labelFontSize, color: textShade(context, _customOpacity)),
          ),
        ),
        Text(
          value.toString().localizeNumbers(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 10),
        Text(
          NumberFormat.percentPattern().format(fraction),
          style: TextStyle(fontSize: 13, color: textShade(context, _customOpacity)),
        ),
      ],
    );
  }
}

class const _AverageOpponentCard({required final UserPerfStats data}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final avgOpponent = data.avgOpponent;

    return _StatsCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LichessIcons.target, size: 28, color: textShade(context, 0.7)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.averageOpponent,
                  style: TextStyle(
                    fontSize: _labelFontSize,
                    color: textShade(context, _customOpacity),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  avgOpponent == null ? '?' : avgOpponent.round().toString().localizeNumbers(),
                  style: _mainValueStyle,
                ),
                const SizedBox(height: 2),
                Text(
                  context.l10n.rating,
                  style: TextStyle(
                    fontSize: _supportingFontSize,
                    color: textShade(context, _customOpacity),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class const _StreakCard({
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
        : _streakValueLabel(context, current);
    final maxValue = best == null || best.isValueEmpty ? '-' : _streakValueLabel(context, best);
    final bestValue = _streakValue(best);
    final progress = bestValue == 0 ? 0.0 : (_streakValue(current) / bestValue).clamp(0.0, 1.0);
    final currentDates = _formatStreakDates(current);
    final maxDates = _formatStreakDates(best);
    final supportingStyle = TextStyle(
      fontSize: _supportingFontSize,
      color: textShade(context, _customOpacity),
    );

    return _StatsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _IconTile(icon, color: color),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
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
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      context.l10n.perfStatLongestStreak('').replaceAll(':', ''),
                      style: supportingStyle,
                      textAlign: TextAlign.end,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      maxValue,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: color),
                      textAlign: TextAlign.end,
                    ),
                    if (maxDates != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        maxDates,
                        style: TextStyle(fontSize: 11, color: textShade(context, 0.5)),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
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

class const _PlayingHabitsCard({required final UserPerfStats data}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dividerColor = ColorScheme.of(context).onSurface.withValues(alpha: 0.12);

    return _StatsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PlayingHabitRow(
            icon: LichessIcons.clock,
            label: context.l10n.perfStatTimeSpentPlaying,
            value: data.timePlayed.toDaysHoursMinutes(AppLocalizations.of(context)),
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: dividerColor),
          const SizedBox(height: 16),
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

class const _PlayingHabitRow({
  required final IconData icon,
  required final String label,
  required final String value,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 22, color: textShade(context, 0.7)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: _labelFontSize, color: textShade(context, _customOpacity)),
          ),
        ),
        const SizedBox(width: 12),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      ],
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
        : _streakValueLabel(context, current);
    final maxValue = best == null || best.isValueEmpty ? '-' : _streakValueLabel(context, best);
    final currentDates = _formatStreakDates(current);
    final maxDates = _formatStreakDates(best);
    final labelStyle = TextStyle(
      fontSize: _labelFontSize,
      color: textShade(context, _customOpacity),
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
            fontSize: _supportingFontSize,
            color: textShade(context, _customOpacity),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          rating?.toString() ?? '?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: rating == null ? textShade(context, _customOpacity) : color,
          ),
        ),
        if (game != null) ...[
          const SizedBox(height: 2),
          Text(
            _dateFormatter.format(game!.finishedAt),
            style: TextStyle(
              fontSize: _supportingFontSize,
              color: textShade(context, _customOpacity),
            ),
          ),
        ],
      ],
    );
  }
}

class const _StatsCard({required final Widget child}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(padding: const EdgeInsets.all(16.0), child: child),
    );
  }
}

class const _StatRow({required final String label, final String? value, final Widget? trailing})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: _labelFontSize, color: textShade(context, _customOpacity)),
          ),
        ),
        if (trailing != null) trailing! else Text(value ?? '', style: _rowValueStyle),
      ],
    );
  }
}

class const _IconTile(final IconData icon, {final Color? color}) extends StatelessWidget {
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

class const _GameListWidget({
  required final IList<UserPerfGame> games,
  required final Perf perf,
  required final User user,
  required final Widget header,
}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListSection(
      header: header,
      margin: const EdgeInsets.only(top: 10.0),
      hasLeading: false,
      children: [
        for (final game in games)
          _GameListTile(
            onTap: () async {
              final gameIds = ISet(games.map((g) => g.gameId));
              final list = await ref.read(gameRepositoryProvider).getGamesByIds(gameIds);
              final gameData = list.firstWhereOrNull((g) => g.id == game.gameId);
              if (context.mounted && gameData != null && gameData.variant.isReadSupported) {
                Navigator.of(context).pushHidingTabBar(
                  AnalysisScreen.buildRoute(
                    AnalysisOptions.archivedGame(
                      orientation: user.id == gameData.white.user?.id ? Side.white : Side.black,
                      gameId: gameData.id,
                      initialMoveCursor: 0,
                    ),
                  ),
                );
              } else if (context.mounted && gameData != null) {
                showSnackBar(context, 'This variant is not supported yet');
              }
            },
            playerTitle: UserFullNameWidget(user: game.opponent, rating: game.opponentRating),
            subtitle: Text(_dateFormatter.format(game.finishedAt)),
          ),
      ],
    );
  }
}

class const _GameListTile({
  required final Widget playerTitle,
  final Widget? subtitle,
  final GestureTapCallback? onTap,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: playerTitle,
      subtitle: subtitle != null
          ? DefaultTextStyle.merge(
              child: subtitle!,
              style: TextStyle(color: textShade(context, Styles.subtitleOpacity)),
            )
          : null,
    );
  }
}

class const _EloChart(final UserRatingHistoryPerf value) extends StatefulWidget {
  @override
  State<_EloChart> createState() => _EloChartState();
}

class _EloChartState() extends State<_EloChart> {
  late DateRange _selectedRange;

  late List<FlSpot> _allFlSpot;

  List<FlSpot> get _flSpot =>
      _allFlSpot.where((element) => element.x >= _minX && element.x <= _maxX).toList();

  IList<UserRatingHistoryPoint> get _points => widget.value.points;

  DateTime get _firstDate => _points.first.date;

  DateTime get _lastDate => _points.last.date;

  double get _minY => (_flSpot.map((e) => e.y).reduce(min) / 100).floorToDouble() * 100;

  double get _maxY => (_flSpot.map((e) => e.y).reduce(max) / 100).ceilToDouble() * 100;

  double get _minX => _startDate(_selectedRange).difference(_firstDate).inDays.toDouble();

  double get _maxX => _allFlSpot.last.x;

  DateTime _startDate(DateRange dateRange) => switch (dateRange) {
    DateRange.oneWeek => _lastDate.subtract(const Duration(days: 7)),
    DateRange.oneMonth => _lastDate.copyWith(month: _lastDate.month - 1),
    DateRange.threeMonths => _lastDate.copyWith(month: _lastDate.month - 3),
    DateRange.oneYear => _lastDate.copyWith(year: _lastDate.year - 1),
    DateRange.allTime => _firstDate,
  };

  bool _dateIsInRange(DateRange dateRange) =>
      _firstDate.isBefore(_startDate(dateRange)) ||
      _firstDate.isAtSameMomentAs(_startDate(dateRange));

  @override
  void initState() {
    super.initState();

    // We need to fill in the missing days in the rating history because rating should be constant for days where no games were played

    final List<UserRatingHistoryPoint> pointsHistoryRatingCompleted = [];
    final numberOfDays = _lastDate.difference(_firstDate).inDays + 1;

    int j = 0;
    for (int i = 0; i < numberOfDays; i++) {
      final currentDate = _firstDate.add(Duration(days: i));
      if (_points[j].date == currentDate) {
        pointsHistoryRatingCompleted.add(_points[j]);
        j += 1;
      } else {
        pointsHistoryRatingCompleted.add(
          UserRatingHistoryPoint(date: currentDate, elo: _points[j - 1].elo),
        );
      }
    }

    _allFlSpot = pointsHistoryRatingCompleted
        .map(
          (element) =>
              FlSpot(element.date.difference(_firstDate).inDays.toDouble(), element.elo.toDouble()),
        )
        .toList();

    if (_dateIsInRange(DateRange.threeMonths)) {
      _selectedRange = DateRange.threeMonths;
    } else if (_dateIsInRange(DateRange.oneMonth)) {
      _selectedRange = DateRange.oneMonth;
    } else if (_dateIsInRange(DateRange.oneWeek)) {
      _selectedRange = DateRange.oneWeek;
    } else {
      _selectedRange = DateRange.allTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = ColorScheme.of(context).onSurface.withValues(alpha: 0.5);
    final chartColor = Styles.chartColor(context);
    final chartDateFormatter = switch (_selectedRange) {
      DateRange.oneWeek => DateFormat.MMMd(),
      DateRange.oneMonth => DateFormat.MMMd(),
      DateRange.threeMonths => DateFormat.yMMM(),
      DateRange.oneYear => DateFormat.yMMM(),
      DateRange.allTime => DateFormat.yMMM(),
    };

    String formatDateFromTimestamp(double nbDays) =>
        chartDateFormatter.format(_firstDate.add(Duration(days: nbDays.toInt())));

    String formatDateFromTimestampForTooltip(double nbDays) =>
        DateFormat.yMMMd().format(_firstDate.add(Duration(days: nbDays.toInt())));

    Widget leftTitlesWidget(double value, TitleMeta meta) {
      return SideTitleWidget(
        meta: meta,
        child: Text(
          value.toInt().toString(),
          style: TextStyle(color: textShade(context, 0.6), fontSize: 10),
        ),
      );
    }

    Widget bottomTitlesWidget(double value, TitleMeta meta) {
      if (value == _minX || value == _maxX) return const SizedBox.shrink();

      return SideTitleWidget(
        meta: meta,
        child: Text(
          formatDateFromTimestamp(value),
          style: TextStyle(color: textShade(context, 0.6), fontSize: 10),
        ),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 25),
            ...DateRange.values
                .where((dateRange) => _dateIsInRange(dateRange))
                .map(
                  (dateRange) => _RangeButton(
                    text: dateRange.label(context.l10n),
                    onPressed: () {
                      setState(() {
                        _selectedRange = dateRange;
                      });
                    },
                    selected: _selectedRange == dateRange,
                  ),
                ),
          ],
        ),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: LineChart(
            duration: Duration.zero,
            LineChartData(
              minX: _minX,
              maxX: _maxX,
              minY: _minY,
              maxY: _maxY,
              lineBarsData: [
                LineChartBarData(
                  spots: _flSpot,
                  dotData: const FlDotData(show: false),
                  color: chartColor,
                  belowBarData: BarAreaData(color: chartColor.withValues(alpha: 0.3), show: true),
                  barWidth: 1.5,
                ),
              ],
              borderData: FlBorderData(
                show: true,
                border: Border(
                  bottom: BorderSide(color: borderColor),
                  left: BorderSide(color: borderColor),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) => FlLine(color: borderColor, strokeWidth: 0.5),
              ),
              lineTouchData: LineTouchData(
                touchSpotThreshold: double.infinity,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (_) => chartColor.withValues(alpha: 0.5),
                  fitInsideHorizontally: true,
                  fitInsideVertically: true,
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots
                        .map(
                          (LineBarSpot touchedSpot) => LineTooltipItem(
                            '${touchedSpot.y.toInt()}\n',
                            Styles.bold,
                            children: [
                              TextSpan(
                                text: formatDateFromTimestampForTooltip(touchedSpot.x),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                              ),
                            ],
                          ),
                        )
                        .toList();
                  },
                ),
                getTouchedSpotIndicator: (barData, spotIndexes) {
                  return spotIndexes.map((spotIndex) {
                    return TouchedSpotIndicatorData(
                      FlLine(color: chartColor, strokeWidth: 2),
                      FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(radius: 5, color: chartColor);
                        },
                      ),
                    );
                  }).toList();
                },
              ),
              titlesData: FlTitlesData(
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 25,
                    getTitlesWidget: bottomTitlesWidget,
                    interval: (_maxX - _minX) / 3,
                    // The placement of the bottom titles is not perfect
                    // See the issue https://github.com/imaNNeo/fl_chart/issues/1605
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 35,
                    getTitlesWidget: leftTitlesWidget,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class const _RangeButton({
  required final String text,
  required final VoidCallback onPressed,
  final bool selected = false,
}) extends StatelessWidget {
  static const _borderRadius = BorderRadius.all(Radius.circular(20.0));

  @override
  Widget build(BuildContext context) {
    final chartColor = Styles.chartColor(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: selected ? chartColor.withValues(alpha: 0.15) : Colors.transparent,
        borderRadius: _borderRadius,
      ),
      child: InkWell(
        borderRadius: _borderRadius,
        onTap: onPressed,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44.0, minWidth: 44.0),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected ? chartColor : textShade(context, 0.7),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum DateRange() {
  oneWeek,
  oneMonth,
  threeMonths,
  oneYear,
  allTime;

  String label(AppLocalizations _) => switch (this) {
    DateRange.oneWeek => '1W',
    DateRange.oneMonth => '1M',
    DateRange.threeMonths => '3M',
    DateRange.oneYear => '1Y',
    DateRange.allTime => 'ALL',
  };
}
