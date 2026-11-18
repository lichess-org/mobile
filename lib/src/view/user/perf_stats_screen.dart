import 'dart:math';

import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
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
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/tab_navigation.dart';
import 'package:lichess_mobile/src/utils/duration.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/puzzle/dashboard_screen.dart';
import 'package:lichess_mobile/src/view/user/game_history_screen.dart';
import 'package:lichess_mobile/src/view/user/rating_history_chart.dart';
import 'package:lichess_mobile/src/view/user/user_stat_cards.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/misc.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/platform_context_menu_button.dart';
import 'package:lichess_mobile/src/widgets/progression_widget.dart';
import 'package:lichess_mobile/src/widgets/rating.dart';
import 'package:lichess_mobile/src/widgets/stat_card.dart';
import 'package:lichess_mobile/src/widgets/user.dart';
import 'package:material_ui/material_ui.dart';

DateFormat get _dateFormatter => DateFormat.yMMMd();

const _customOpacity = 0.6;
const _defaultStatFontSize = 12.0;
const _defaultValueFontSize = 18.0;
const _mainValueStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 30);
const _secondaryValueStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 22);

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
    const cardSpacing = 12.0;
    const cardSpace = SizedBox(height: cardSpacing);
    final labelStyle = TextStyle(color: textShade(context, _customOpacity));

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
                  child: RatingHistoryChart(
                    IList([
                      RatingHistorySeries(
                        perf: perf,
                        points: ratingHistoryPerfData.points,
                        color: Styles.chartColor(context),
                      ),
                    ]),
                  ),
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
            _ExpandableCard(
              header: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(context.l10n.rating, style: labelStyle),
                  RatingWidget(
                    rating: data.rating,
                    deviation: data.deviation,
                    provisional: data.provisional,
                    style: _mainValueStyle,
                  ),
                  if (data.percentile != null && data.percentile! > 0.0)
                    Text(
                      (loggedInUser != null && loggedInUser.user.id == user.id)
                          ? context.l10n.youAreBetterThanPercentOfPerfTypePlayers(
                              '${data.percentile!.toStringAsFixed(2)}%',
                              perf.label(context.l10n),
                            )
                          : context.l10n.userIsBetterThanPercentOfPerfTypePlayers(
                              user.username,
                              '${data.percentile!.toStringAsFixed(2)}%',
                              perf.label(context.l10n),
                            ),
                      style: labelStyle,
                    ),
                  ratingHistory.when(
                    data: (ratingHistoryData) {
                      final ratingHistoryPerfData = ratingHistoryData.firstWhereOrNull(
                        (element) => element.perf == perf,
                      );

                      if (ratingHistoryPerfData == null ||
                          ratingHistoryPerfData.points.length <= 1) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: RatingHistoryChart(
                          IList([
                            RatingHistorySeries(
                              perf: perf,
                              points: ratingHistoryPerfData.points,
                              color: Styles.chartColor(context),
                            ),
                          ]),
                        ),
                      );
                    },
                    error: (error, stackTrace) {
                      debugPrint(
                        'SEVERE: [PerfStatsScreen] could not load rating history data; $error\n$stackTrace',
                      );
                      return const Text('Could not show chart elo chart');
                    },
                    loading: () {
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
              details: Column(
                children: [
                  // The API returns the progression over the last 12 games.
                  StatCard(
                    context.l10n.perfStatProgressOverLastXGames('12').replaceAll(':', ''),
                    child: ProgressionWidget(data.progress),
                  ),
                  StatCardRow([
                    if (data.rank != null)
                      StatCard(context.l10n.rank, value: _formatNumber(data.rank!)),
                    StatCard(
                      context.l10n.perfStatRatingDeviation('').replaceAll(': .', ''),
                      value: data.deviation.toStringAsFixed(2),
                    ),
                  ]),
                  StatCardRow([
                    StatCard(
                      context.l10n.perfStatHighestRating('').replaceAll(':', ''),
                      child: _RatingWidget(
                        data.highestRating,
                        data.highestRatingGame,
                        context.lichessColors.green,
                      ),
                    ),
                    StatCard(
                      context.l10n.perfStatLowestRating('').replaceAll(':', ''),
                      child: _RatingWidget(
                        data.lowestRating,
                        data.lowestRatingGame,
                        context.lichessColors.red,
                      ),
                    ),
                  ]),
                ],
              ),
            ),
            statGroupSpace,
            GameResultsCard(
              total: data.totalGames,
              won: data.wonGames,
              drawn: data.drawnGames,
              lost: data.lostGames,
              onTap: () {
                Navigator.of(context).push(
                  GameHistoryScreen.buildRoute(
                    user: user.lightUser,
                    isOnline: true,
                    gameFilter: GameFilterState(perfs: ISet({perf})),
                  ),
                );
              },
            ),
            cardSpace,
            IconStatCard(
              icon: Icons.people_outline,
              label: context.l10n.averageOpponent,
              value: data.avgOpponent == null ? '?' : _formatNumber(data.avgOpponent!.round()),
            ),
            cardSpace,
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: .stretch,
                spacing: cardSpacing,
                children: [
                  Expanded(
                    child: IconStatCard(
                      icon: Icons.leaderboard_outlined,
                      label: context.l10n.rated,
                      value: _formatNumber(data.ratedGames),
                      caption: _formatPercentage(data.ratedGames, data.totalGames),
                    ),
                  ),
                  Expanded(
                    child: IconStatCard(
                      icon: Icons.emoji_events_outlined,
                      label: context.l10n.tournament,
                      value: _formatNumber(data.tournamentGames),
                      caption: _formatPercentage(data.tournamentGames, data.totalGames),
                    ),
                  ),
                ],
              ),
            ),
            cardSpace,
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: .stretch,
                spacing: cardSpacing,
                children: [
                  Expanded(
                    child: IconStatCard(
                      icon: Icons.bolt_outlined,
                      label: context.l10n.perfStatBerserkedGames.replaceAll(
                        ' ${context.l10n.games.toLowerCase()}',
                        '',
                      ),
                      value: _formatNumber(data.berserkGames),
                      caption: _formatPercentage(data.berserkGames, data.totalGames),
                    ),
                  ),
                  Expanded(
                    child: IconStatCard(
                      icon: Icons.wifi_off_outlined,
                      label: context.l10n.perfStatDisconnections,
                      value: _formatNumber(data.disconnections),
                      caption: _formatPercentage(data.disconnections, data.totalGames),
                    ),
                  ),
                ],
              ),
            ),
            cardSpace,
            _ResultStreakCard(
              title: context.l10n.perfStatWinningStreak,
              icon: Icons.trending_up,
              current: data.curWinStreak,
              longest: data.maxWinStreak,
              color: context.lichessColors.green,
            ),
            cardSpace,
            _ResultStreakCard(
              title: context.l10n.perfStatLosingStreak,
              icon: Icons.trending_down,
              current: data.curLossStreak,
              longest: data.maxLossStreak,
              color: context.lichessColors.red,
            ),
            cardSpace,
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Column(
                  children: [
                    IconStatRow(
                      icon: Icons.schedule,
                      label: context.l10n.perfStatTimeSpentPlaying,
                      value: data.timePlayed.toDaysHoursMinutes(AppLocalizations.of(context)),
                    ),
                    const Divider(height: 1.0),
                    IconStatRow(
                      icon: Icons.calendar_month_outlined,
                      label: context.l10n.perfStatGamesInARow,
                      value: _streakValue(context, data.maxPlayStreak),
                      subtitle: _StreakDates(data.maxPlayStreak),
                      valueCaption: _currentStreakCaption(context, data.curPlayStreak),
                    ),
                    const Divider(height: 1.0),
                    IconStatRow(
                      icon: Icons.timer_outlined,
                      label: context.l10n.perfStatMaxTimePlaying,
                      value: _streakValue(context, data.maxTimeStreak),
                      subtitle: _StreakDates(data.maxTimeStreak),
                      valueCaption: _currentStreakCaption(context, data.curTimeStreak),
                    ),
                  ],
                ),
              ),
            ),
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

class const _UserGameWidget(final UserPerfGame? game) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Implement functionality to view game on tap.
    // (Return a button? Wrap with InkWell?)
    const defaultDateFontSize = 16.0;
    const defaultDateStyle = TextStyle(fontSize: defaultDateFontSize);

    return game == null
        ? const Text('?', style: defaultDateStyle)
        : Text(_dateFormatter.format(game!.finishedAt), style: defaultDateStyle);
  }
}

class const _RatingWidget(final int? rating, final UserPerfGame? game, final Color color)
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (rating == null)
        ? const Text('?', style: TextStyle(fontSize: _defaultValueFontSize))
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                rating.toString(),
                style: TextStyle(fontSize: _defaultValueFontSize, color: color),
              ),
              _UserGameWidget(game),
            ],
          );
  }
}

String _formatNumber(int value) =>
    NumberFormat.decimalPattern(Intl.getCurrentLocale()).format(value);

String _formatPercentage(int value, int total) =>
    NumberFormat.percentPattern().format(total == 0 ? 0 : value / total);

/// The value of a streak, or '-' when there is none.
String _streakValue(BuildContext context, UserStreak? streak) => switch (streak) {
  null => '-',
  _ when streak.isValueEmpty => '-',
  UserTimeStreak(:final timePlayed) => timePlayed.toDaysHoursMinutes(AppLocalizations.of(context)),
  UserGameStreak(:final gamesPlayed) => context.l10n.nbGames(gamesPlayed),
};

/// The current streak, below the longest one, or null when there is none.
String? _currentStreakCaption(BuildContext context, UserStreak? current) =>
    current == null || current.isValueEmpty
    ? null
    : context.l10n.perfStatCurrentStreak(_streakValue(context, current));

/// A card showing [header], with a button to show or hide [details] below it.
class const _ExpandableCard({required final Widget header, required final Widget details})
    extends StatefulWidget {
  @override
  State<_ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState() extends State<_ExpandableCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 4.0),
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            widget.header,
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              alignment: .topCenter,
              child: _expanded
                  ? Padding(padding: const EdgeInsets.only(top: 10.0), child: widget.details)
                  : const SizedBox(width: double.infinity),
            ),
            Center(
              child: TextButton.icon(
                onPressed: () => setState(() => _expanded = !_expanded),
                iconAlignment: .end,
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                label: Text(_expanded ? context.l10n.less : context.l10n.more),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The start and end dates of a streak, if any.
class const _StreakDates(final UserStreak? streak, {final WrapAlignment alignment = .start})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (streak == null || streak!.isValueEmpty) return const SizedBox.shrink();
    if (streak!.startGame == null || streak!.endGame == null) return const SizedBox.shrink();
    final style = TextStyle(fontSize: _defaultStatFontSize, color: textShade(context, 0.5));
    return Wrap(
      alignment: alignment,
      spacing: 4.0,
      children: [
        Text(_dateFormatter.format(streak!.startGame!.finishedAt), style: style),
        Text('–', style: style),
        Text(_dateFormatter.format(streak!.endGame!.finishedAt), style: style),
      ],
    );
  }
}

class const _ResultStreakCard({
  required final String title,
  required final IconData icon,
  required final UserStreak? current,
  required final UserStreak? longest,
  required final Color color,
}) extends StatelessWidget {
  /// Longest streak up to which the progress bar has one segment per game; above it, the bar is
  /// continuous.
  static const _maxSegments = 15;

  int _gamesOf(UserStreak? streak) => switch (streak) {
    UserGameStreak(:final gamesPlayed, isValueEmpty: false) => gamesPlayed,
    _ => 0,
  };

  @override
  Widget build(BuildContext context) {
    final shadedStyle = TextStyle(color: textShade(context, _customOpacity));
    final currentGames = _gamesOf(current);
    final longestGames = _gamesOf(longest);
    final emptyColor = textShade(context, 0.15);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              crossAxisAlignment: .start,
              spacing: 12.0,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(icon, color: color),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(title, style: Styles.bold),
                      Text(_streakValue(context, current), style: _secondaryValueStyle),
                      Text(
                        context.l10n.perfStatCurrentStreak('').replaceAll(':', '').trim(),
                        style: shadedStyle,
                      ),
                      _StreakDates(current),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .end,
                    children: [
                      Text(
                        context.l10n.perfStatLongestStreak('').replaceAll(':', '').trim(),
                        style: shadedStyle,
                        textAlign: .end,
                      ),
                      Text(
                        _streakValue(context, longest),
                        style: _secondaryValueStyle.copyWith(color: color),
                        textAlign: .end,
                      ),
                      _StreakDates(longest, alignment: .end),
                    ],
                  ),
                ),
              ],
            ),
            if (longestGames > 0) ...[
              const SizedBox(height: 16.0),
              ExcludeSemantics(
                child: SizedBox(
                  height: 6.0,
                  child: Row(
                    crossAxisAlignment: .stretch,
                    spacing: 4.0,
                    children: longestGames <= _maxSegments
                        ? [
                            for (int i = 0; i < longestGames; i++)
                              Expanded(
                                child: StatBarSegment(i < currentGames ? color : emptyColor),
                              ),
                          ]
                        : [
                            Expanded(
                              child: Stack(
                                fit: .expand,
                                children: [
                                  StatBarSegment(emptyColor),
                                  FractionallySizedBox(
                                    alignment: .centerLeft,
                                    widthFactor: min(currentGames / longestGames, 1.0),
                                    child: StatBarSegment(color),
                                  ),
                                ],
                              ),
                            ),
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
