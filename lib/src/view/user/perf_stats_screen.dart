import 'dart:math';

import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/game/game_filter.dart';
import 'package:lichess_mobile/src/model/game/game_repository.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/duration.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/string.dart';
import 'package:lichess_mobile/src/view/game/archived_game_screen.dart';
import 'package:lichess_mobile/src/view/user/game_history_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/progression_widget.dart';
import 'package:lichess_mobile/src/widgets/rating.dart';
import 'package:lichess_mobile/src/widgets/stat_card.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';

final _dateFormatter = DateFormat.yMMMd();

const _customOpacity = 0.6;
const _defaultStatFontSize = 12.0;
const _defaultValueFontSize = 18.0;
const _mainValueStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 30);

class PerfStatsScreen extends StatelessWidget {
  const PerfStatsScreen({required this.user, required this.perf, super.key});

  final User user;
  final Perf perf;

  static Route<dynamic> buildRoute(BuildContext context, {required User user, required Perf perf}) {
    return buildScreenRoute(context, screen: PerfStatsScreen(user: user, perf: perf));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: _Title(user: user, perf: perf)),
      body: _Body(user: user, perf: perf),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({required this.user, required this.perf});

  final Perf perf;
  final User user;

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
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(perf.icon),
            Text(' ${context.l10n.perfStatPerfStats(perf.title)}', overflow: TextOverflow.ellipsis),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
      onTap: () {
        showAdaptiveActionSheet<void>(
          context: context,
          actions: allPerfs
              .map((p) {
                return BottomSheetAction(
                  makeLabel:
                      (context) => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(p.icon),
                          const SizedBox(width: 6),
                          Text(
                            context.l10n.perfStatPerfStats(p.title),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pushReplacement(PerfStatsScreen.buildRoute(context, user: user, perf: p));
                  },
                );
              })
              .toList(growable: false),
        );
      },
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.user, required this.perf});

  final User user;
  final Perf perf;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfStats = ref.watch(userPerfStatsProvider(id: user.id, perf: perf));
    final ratingHistory = ref.watch(userRatingHistoryProvider(id: user.id));
    final loggedInUser = ref.watch(authSessionProvider);
    const statGroupSpace = SizedBox(height: 16.0);
    const subStatSpace = SizedBox(height: 10);

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
                return const Text('Could not show chart elo chart');
              },
              loading: () {
                return const SizedBox.shrink();
              },
            ),
            statGroupSpace,
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text('${context.l10n.rating} ', style: Styles.sectionTitle),
                RatingWidget(
                  rating: data.rating,
                  deviation: data.deviation,
                  provisional: data.provisional,
                  style: _mainValueStyle,
                ),
              ],
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    if (data.percentile != null && data.percentile! > 0.0)
                      Text(
                        (loggedInUser != null && loggedInUser.user.id == user.id)
                            ? context.l10n.youAreBetterThanPercentOfPerfTypePlayers(
                              '${data.percentile!.toStringAsFixed(2)}%',
                              perf.title,
                            )
                            : context.l10n.userIsBetterThanPercentOfPerfTypePlayers(
                              user.username,
                              '${data.percentile!.toStringAsFixed(2)}%',
                              perf.title,
                            ),
                        style: TextStyle(color: textShade(context, 0.7)),
                      ),
                    subStatSpace,
                    // The number '12' here is not arbitrary, since the API returns the progression for the last 12 games (as far as I know).
                    StatCard(
                      context.l10n.perfStatProgressOverLastXGames('12').replaceAll(':', ''),
                      child: ProgressionWidget(data.progress),
                    ),
                    StatCardRow([
                      if (data.rank != null)
                        StatCard(
                          context.l10n.rank,
                          value:
                              data.rank == null
                                  ? '?'
                                  : NumberFormat.decimalPattern(
                                    Intl.getCurrentLocale(),
                                  ).format(data.rank),
                        ),
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
                          context.lichessColors.good,
                        ),
                      ),
                      StatCard(
                        context.l10n.perfStatLowestRating('').replaceAll(':', ''),
                        child: _RatingWidget(
                          data.lowestRating,
                          data.lowestRatingGame,
                          context.lichessColors.error,
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
            statGroupSpace,
            Semantics(
              container: true,
              enabled: true,
              button: true,
              label: context.l10n.perfStatViewTheGames,
              child: Tooltip(
                excludeFromSemantics: true,
                message: context.l10n.perfStatViewTheGames,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      GameHistoryScreen.buildRoute(
                        context,
                        user: user.lightUser,
                        isOnline: true,
                        gameFilter: GameFilterState(perfs: ISet({perf})),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${context.l10n.perfStatTotalGames} '.localizeNumbers(),
                          style: Styles.sectionTitle,
                        ),
                        Text(data.totalGames.toString().localizeNumbers(), style: _mainValueStyle),
                        Text(
                          String.fromCharCode(Icons.arrow_forward_ios.codePoint),
                          style: Styles.sectionTitle.copyWith(fontFamily: 'MaterialIcons'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    StatCardRow([
                      StatCard(
                        context.l10n.wins,
                        child: _PercentageValueWidget(
                          data.wonGames,
                          data.totalGames,
                          color: context.lichessColors.good,
                        ),
                      ),
                      StatCard(
                        context.l10n.draws,
                        child: _PercentageValueWidget(
                          data.drawnGames,
                          data.totalGames,
                          color: textShade(context, _customOpacity),
                          isShaded: true,
                        ),
                      ),
                      StatCard(
                        context.l10n.losses,
                        child: _PercentageValueWidget(
                          data.lostGames,
                          data.totalGames,
                          color: context.lichessColors.error,
                        ),
                      ),
                    ]),
                    StatCardRow([
                      StatCard(
                        context.l10n.rated,
                        child: _PercentageValueWidget(data.ratedGames, data.totalGames),
                      ),
                      StatCard(
                        context.l10n.tournament,
                        child: _PercentageValueWidget(data.tournamentGames, data.totalGames),
                      ),
                      StatCard(
                        context.l10n.perfStatBerserkedGames.replaceAll(
                          ' ${context.l10n.games.toLowerCase()}',
                          '',
                        ),
                        child: _PercentageValueWidget(data.berserkGames, data.totalGames),
                      ),
                      StatCard(
                        context.l10n.perfStatDisconnections,
                        child: _PercentageValueWidget(data.disconnections, data.totalGames),
                      ),
                    ]),
                    StatCardRow([
                      StatCard(
                        context.l10n.averageOpponent,
                        value: data.avgOpponent == null ? '?' : data.avgOpponent.toString(),
                      ),
                      StatCard(
                        context.l10n.perfStatTimeSpentPlaying,
                        value: data.timePlayed.toDaysHoursMinutes(AppLocalizations.of(context)),
                      ),
                    ]),
                    _StatGroup(
                      title: context.l10n.perfStatWinningStreak,
                      children: [
                        _StreakWidget(
                          data.maxWinStreak,
                          data.curWinStreak,
                          color: context.lichessColors.good,
                        ),
                      ],
                    ),
                    _StatGroup(
                      title: context.l10n.perfStatLosingStreak,
                      children: [
                        _StreakWidget(
                          data.maxLossStreak,
                          data.curLossStreak,
                          color: context.lichessColors.error,
                        ),
                      ],
                    ),
                    _StatGroup(
                      title: context.l10n.perfStatGamesInARow,
                      children: [_StreakWidget(data.maxPlayStreak, data.curPlayStreak)],
                    ),
                    _StatGroup(
                      title: context.l10n.perfStatMaxTimePlaying,
                      children: [_StreakWidget(data.maxTimeStreak, data.curTimeStreak)],
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

class _StatGroup extends StatelessWidget {
  const _StatGroup({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const SizedBox(height: 5),
          for (final child in children) ...[child, const SizedBox(height: 10)],
        ],
      ),
    );
  }
}

class _UserGameWidget extends StatelessWidget {
  final UserPerfGame? game;

  const _UserGameWidget(this.game);

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

class _RatingWidget extends StatelessWidget {
  final int? rating;
  final UserPerfGame? game;
  final Color color;

  const _RatingWidget(this.rating, this.game, this.color);

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

class _PercentageValueWidget extends StatelessWidget {
  final int value;
  final int denominator;
  final Color? color;
  final bool isShaded;

  const _PercentageValueWidget(this.value, this.denominator, {this.color, this.isShaded = false});

  String _getPercentageString(num numerator, num denominator) {
    return '${((numerator / denominator) * 100).round()}%';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value.toString().localizeNumbers(),
          style: TextStyle(fontSize: _defaultValueFontSize, color: color),
        ),
        Text(
          _getPercentageString(value, denominator),
          style: TextStyle(
            fontSize: _defaultValueFontSize,
            color:
                color == null
                    ? isShaded
                        ? textShade(context, _customOpacity / 2)
                        : textShade(context, _customOpacity)
                    : isShaded
                    ? color!.withValues(alpha: _customOpacity / 2)
                    : color!.withValues(alpha: _customOpacity),
          ),
        ),
      ],
    );
  }
}

class _StreakWidget extends StatelessWidget {
  final UserStreak? maxStreak;
  final UserStreak? curStreak;
  final Color? color;

  const _StreakWidget(this.maxStreak, this.curStreak, {this.color});

  @override
  Widget build(BuildContext context) {
    final valueStyle = TextStyle(fontSize: _defaultValueFontSize, color: color);

    final streakTitleStyle = TextStyle(
      fontSize: _defaultStatFontSize,
      color: textShade(context, _customOpacity),
    );

    final longestStreakStr = context.l10n.perfStatLongestStreak('').replaceAll(':', '');
    final currentStreakStr = context.l10n.perfStatCurrentStreak('').replaceAll(':', '');

    final List<Widget> streakWidgets = [maxStreak, curStreak]
        .mapIndexed((index, streak) {
          final streakTitle = Text(
            index == 0 ? longestStreakStr : currentStreakStr,
            style: streakTitleStyle,
          );

          if (streak == null || streak.isValueEmpty) {
            return Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  streakTitle,
                  Text(
                    '-',
                    style: const TextStyle(fontSize: _defaultValueFontSize),
                    semanticsLabel: context.l10n.none,
                  ),
                ],
              ),
            );
          }

          final valueText = switch (streak) {
            UserTimeStreak(:final timePlayed) => Text(
              timePlayed.toDaysHoursMinutes(AppLocalizations.of(context)),
              style: valueStyle,
              textAlign: TextAlign.center,
            ),
            UserGameStreak(:final gamesPlayed) => Text(
              context.l10n.nbGames(gamesPlayed),
              style: valueStyle,
              textAlign: TextAlign.center,
            ),
          };

          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                streakTitle,
                valueText,
                if (streak.startGame != null && streak.endGame != null)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 5.0),
                      _UserGameWidget(streak.startGame),
                      Icon(Icons.arrow_downward_rounded, color: textShade(context, _customOpacity)),
                      _UserGameWidget(streak.endGame),
                    ],
                  ),
              ],
            ),
          );
        })
        .toList(growable: false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 5.0),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: streakWidgets),
      ],
    );
  }
}

class _GameListWidget extends ConsumerWidget {
  const _GameListWidget({
    required this.games,
    required this.perf,
    required this.user,
    required this.header,
  });

  final IList<UserPerfGame> games;
  final Perf perf;
  final User user;
  final Widget header;

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
              final list = await ref.withClient(
                (client) => GameRepository(client).getGamesByIds(gameIds),
              );
              final gameData = list.firstWhereOrNull((g) => g.id == game.gameId);
              if (context.mounted && gameData != null && gameData.variant.isReadSupported) {
                Navigator.of(context, rootNavigator: true).push(
                  ArchivedGameScreen.buildRoute(
                    context,
                    gameData: gameData,
                    orientation: user.id == gameData.white.user?.id ? Side.white : Side.black,
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

class _GameListTile extends StatelessWidget {
  const _GameListTile({required this.playerTitle, this.subtitle, this.onTap});

  final Widget playerTitle;
  final Widget? subtitle;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: playerTitle,
      subtitle:
          subtitle != null
              ? DefaultTextStyle.merge(
                child: subtitle!,
                style: TextStyle(color: textShade(context, Styles.subtitleOpacity)),
              )
              : null,
    );
  }
}

class _EloChart extends StatefulWidget {
  final UserRatingHistoryPerf value;

  const _EloChart(this.value);

  @override
  State<_EloChart> createState() => _EloChartState();
}

class _EloChartState extends State<_EloChart> {
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

    _allFlSpot =
        pointsHistoryRatingCompleted
            .map(
              (element) => FlSpot(
                element.date.difference(_firstDate).inDays.toDouble(),
                element.elo.toDouble(),
              ),
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
                    text: dateRange.toString(),
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

class _RangeButton extends StatelessWidget {
  const _RangeButton({required this.text, required this.onPressed, this.selected = false});

  final String text;
  final VoidCallback onPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final chartColor = Styles.chartColor(context);

    return Card(
      color: selected ? chartColor.withValues(alpha: 0.2) : null,
      shadowColor: selected ? Colors.transparent : null,
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        onTap: onPressed,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            child: Text(text),
          ),
        ),
      ),
    );
  }
}

enum DateRange {
  oneWeek,
  oneMonth,
  threeMonths,
  oneYear,
  allTime;

  @override
  String toString() => switch (this) {
    DateRange.oneWeek => '1W',
    DateRange.oneMonth => '1M',
    DateRange.threeMonths => '3M',
    DateRange.oneYear => '1Y',
    DateRange.allTime => 'ALL',
  };
}
