import 'dart:math';

import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/game/game_repository.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/duration.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/string.dart';
import 'package:lichess_mobile/src/view/game/archived_game_screen.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/rating.dart';
import 'package:lichess_mobile/src/widgets/stat_card.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';

final _currentLocale = Intl.getCurrentLocale();
final _dateFormatter = DateFormat.yMMMd(_currentLocale);

const _customOpacity = 0.6;
const _defaultStatFontSize = 12.0;
const _defaultValueFontSize = 18.0;
const _mainValueStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 30);

class PerfStatsScreen extends StatelessWidget {
  const PerfStatsScreen({
    required this.user,
    required this.perf,
    super.key,
  });

  final User user;
  final Perf perf;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: _Title(user: user, perf: perf),
      ),
      body: _Body(user: user, perf: perf),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: _Title(user: user, perf: perf),
      ),
      child: _Body(user: user, perf: perf),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({required this.user, required this.perf});

  final User user;
  final Perf perf;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: UserFullNameWidget(user: user.lightUser),
        ),
        Flexible(
          child: Text(
            ' ${context.l10n.perfStatPerfStats(perf.title)}',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({
    required this.user,
    required this.perf,
  });

  final User user;
  final Perf perf;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfStats = ref.watch(userPerfStatsProvider(id: user.id, perf: perf));
    final ratingHistory = ref.watch(userRatingHistoryProvider(id: user.id));
    final loggedInUser = ref.watch(authSessionProvider);
    const statGroupSpace = SizedBox(height: 15.0);
    const subStatSpace = SizedBox(height: 10);

    return perfStats.when(
      data: (data) {
        return SafeArea(
          child: ListView(
            padding: Styles.horizontalBodyPadding,
            scrollDirection: Axis.vertical,
            children: [
              ratingHistory.when(
                data: (ratingHistoryData) {
                  final ratingHistoryPerfData = ratingHistoryData
                      .where((element) => element.perf == perf.title)
                      .first;

                  if (ratingHistoryPerfData.points.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return _EloChart(ratingHistoryPerfData);
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '${context.l10n.rating} ',
                    style: Styles.sectionTitle,
                  ),
                  RatingWidget(
                    rating: data.rating,
                    deviation: data.deviation,
                    provisional: data.provisional,
                    style: _mainValueStyle,
                  ),
                ],
              ),
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
                context.l10n
                    .perfStatProgressOverLastXGames('12')
                    .replaceAll(':', ''),
                child: _ProgressionWidget(data.progress),
              ),
              StatCardRow([
                if (data.rank != null)
                  StatCard(
                    context.l10n.rank,
                    value: data.rank == null
                        ? '?'
                        : NumberFormat.decimalPattern(
                            Intl.getCurrentLocale(),
                          ).format(data.rank),
                  ),
                StatCard(
                  context.l10n
                      .perfStatRatingDeviation('')
                      .replaceAll(': .', ''),
                  value: data.deviation.toStringAsFixed(2),
                ),
              ]),
              StatCardRow([
                StatCard(
                  context.l10n.perfStatHighestRating('').replaceAll(':', ''),
                  child: _RatingWidget(
                    data.highestRating,
                    data.highestRatingGame,
                    LichessColors.good,
                  ),
                ),
                StatCard(
                  context.l10n.perfStatLowestRating('').replaceAll(':', ''),
                  child: _RatingWidget(
                    data.lowestRating,
                    data.lowestRatingGame,
                    LichessColors.red,
                  ),
                ),
              ]),
              statGroupSpace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '${context.l10n.perfStatTotalGames} '.localizeNumbers(),
                    style: Styles.sectionTitle,
                  ),
                  Text(
                    data.totalGames.toString().localizeNumbers(),
                    style: _mainValueStyle,
                  ),
                ],
              ),
              subStatSpace,
              StatCardRow([
                StatCard(
                  context.l10n.wins,
                  child: _PercentageValueWidget(
                    data.wonGames,
                    data.totalGames,
                    color: LichessColors.good,
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
                    color: LichessColors.red,
                  ),
                ),
              ]),
              StatCardRow([
                StatCard(
                  context.l10n.rated,
                  child: _PercentageValueWidget(
                    data.ratedGames,
                    data.totalGames,
                  ),
                ),
                StatCard(
                  context.l10n.tournament,
                  child: _PercentageValueWidget(
                    data.tournamentGames,
                    data.totalGames,
                  ),
                ),
                StatCard(
                  context.l10n.perfStatBerserkedGames.replaceAll(
                    ' ${context.l10n.games.toLowerCase()}',
                    '',
                  ),
                  child: _PercentageValueWidget(
                    data.berserkGames,
                    data.totalGames,
                  ),
                ),
                StatCard(
                  context.l10n.perfStatDisconnections,
                  child: _PercentageValueWidget(
                    data.disconnections,
                    data.totalGames,
                  ),
                ),
              ]),
              StatCardRow([
                StatCard(
                  context.l10n.averageOpponent,
                  value: data.avgOpponent == null
                      ? '?'
                      : data.avgOpponent.toString(),
                ),
                StatCard(
                  context.l10n.perfStatTimeSpentPlaying,
                  value: data.timePlayed
                      .toDaysHoursMinutes(AppLocalizations.of(context)),
                ),
              ]),
              StatCard(
                context.l10n.perfStatWinningStreak,
                child: _StreakWidget(
                  data.maxWinStreak,
                  data.curWinStreak,
                  color: LichessColors.good,
                ),
              ),
              StatCard(
                context.l10n.perfStatLosingStreak,
                child: _StreakWidget(
                  data.maxLossStreak,
                  data.curLossStreak,
                  color: LichessColors.red,
                ),
              ),
              StatCard(
                context.l10n.perfStatGamesInARow,
                child: _StreakWidget(data.maxPlayStreak, data.curPlayStreak),
              ),
              StatCard(
                context.l10n.perfStatMaxTimePlaying,
                child: _StreakWidget(data.maxTimeStreak, data.curTimeStreak),
              ),
              if (data.bestWins != null && data.bestWins!.isNotEmpty) ...[
                statGroupSpace,
                _GameListWidget(
                  games: data.bestWins!,
                  perf: perf,
                  user: user,
                  header: Text(
                    context.l10n.perfStatBestRated,
                    style: Styles.sectionTitle,
                  ),
                ),
              ],
            ],
          ),
        );
      },
      error: (error, stackTrace) {
        debugPrint(
          'SEVERE: [PerfStatsScreen] could not load data; $error\n$stackTrace',
        );
        return const Center(child: Text('Could not load user stats.'));
      },
      loading: () => const CenterLoadingIndicator(),
    );
  }
}

class _ProgressionWidget extends StatelessWidget {
  final int progress;

  const _ProgressionWidget(this.progress);

  @override
  Widget build(BuildContext context) {
    const progressionFontSize = 20.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (progress != 0) ...[
          Icon(
            progress > 0
                ? LichessIcons.arrow_full_upperright
                : LichessIcons.arrow_full_lowerright,
            color: progress > 0 ? LichessColors.good : LichessColors.red,
          ),
          Text(
            progress.abs().toString(),
            style: TextStyle(
              color: progress > 0 ? LichessColors.good : LichessColors.red,
              fontSize: progressionFontSize,
            ),
          ),
        ] else
          Text(
            '0',
            style: TextStyle(
              color: textShade(context, _customOpacity),
              fontSize: progressionFontSize,
            ),
          ),
      ],
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
    const defaultDateStyle =
        TextStyle(color: LichessColors.primary, fontSize: defaultDateFontSize);

    return game == null
        ? const Text('?', style: defaultDateStyle)
        : Text(
            _dateFormatter.format(game!.finishedAt),
            style: defaultDateStyle,
          );
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

  const _PercentageValueWidget(
    this.value,
    this.denominator, {
    this.color,
    this.isShaded = false,
  });

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
          style: const TextStyle(fontSize: _defaultValueFontSize),
        ),
        Text(
          _getPercentageString(value, denominator),
          style: TextStyle(
            fontSize: _defaultValueFontSize,
            color: isShaded
                ? textShade(context, _customOpacity / 2)
                : textShade(context, _customOpacity),
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
    const valueStyle = TextStyle(fontSize: _defaultValueFontSize);

    final streakTitleStyle = TextStyle(
      fontSize: _defaultStatFontSize,
      color: textShade(context, _customOpacity),
    );

    final longestStreakStr =
        context.l10n.perfStatLongestStreak('').replaceAll(':', '');
    final currentStreakStr =
        context.l10n.perfStatCurrentStreak('').replaceAll(':', '');

    final List<Widget> streakWidgets =
        [maxStreak, curStreak].mapIndexed((index, streak) {
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

      final Text valueText = streak.map(
        timeStreak: (UserTimeStreak streak) {
          return Text(
            streak.timePlayed.toDaysHoursMinutes(AppLocalizations.of(context)),
            style: valueStyle,
            textAlign: TextAlign.center,
          );
        },
        gameStreak: (UserGameStreak streak) {
          return Text(
            context.l10n.nbGames(streak.gamesPlayed),
            style: valueStyle,
            textAlign: TextAlign.center,
          );
        },
      );

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
                  Icon(
                    Icons.arrow_downward_rounded,
                    color: textShade(context, _customOpacity),
                  ),
                  _UserGameWidget(streak.endGame),
                ],
              ),
          ],
        ),
      );
    }).toList(growable: false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 5.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: streakWidgets,
        ),
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
      hasLeading: false,
      children: [
        for (final game in games)
          _GameListTile(
            onTap: () {
              final gameIds = ISet(games.map((g) => g.gameId));
              ref
                  .withClient(
                (client) => GameRepository(client).getGamesByIds(gameIds),
              )
                  .then((list) {
                final gameData =
                    list.firstWhereOrNull((g) => g.id == game.gameId);
                if (gameData != null && gameData.variant.isSupported) {
                  pushPlatformRoute(
                    context,
                    rootNavigator: true,
                    builder: (context) => ArchivedGameScreen(
                      gameData: gameData,
                      orientation: user.id == gameData.white.user?.id
                          ? Side.white
                          : Side.black,
                    ),
                  );
                }
              });
            },
            playerTitle: UserFullNameWidget(
              user: game.opponent,
              rating: game.opponentRating,
            ),
            subtitle: Text(
              _dateFormatter.format(game.finishedAt),
            ),
          ),
      ],
    );
  }
}

class _GameListTile extends StatelessWidget {
  const _GameListTile({
    required this.playerTitle,
    this.subtitle,
    this.onTap,
  });

  final Widget playerTitle;
  final Widget? subtitle;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return PlatformListTile(
      onTap: onTap,
      title: playerTitle,
      subtitle: subtitle != null
          ? DefaultTextStyle.merge(
              child: subtitle!,
              style: TextStyle(
                color: textShade(context, Styles.subtitleOpacity),
              ),
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
  DateRange _selectedRange = DateRange.threeMonths;

  late List<FlSpot> _allPoints;
  late double _startDate;
  late double _endDate;

  List<FlSpot> get _points => _allPoints
      .where(
        (element) => element.x >= _startDate && element.x <= _endDate,
      )
      .toList();

  double get _minY =>
      (_points.map((e) => e.y).reduce(min) / 100).floorToDouble() * 100;

  double get _maxY =>
      (_points.map((e) => e.y).reduce(max) / 100).ceilToDouble() * 100;

  @override
  void initState() {
    super.initState();

    // We need to fill in the missing days in the rating history

    final List<UserRatingHistoryPoint> pointsHistoryRatingCompleted = [];
    final pointsHistoryRating = widget.value.points;
    final numberOfDays = pointsHistoryRating.last.date
            .difference(pointsHistoryRating.first.date)
            .inDays +
        1;

    int j = 0;
    for (int i = 0; i < numberOfDays; i++) {
      final currentDate = pointsHistoryRating.first.date.add(Duration(days: i));
      if (pointsHistoryRating[j].date == currentDate) {
        pointsHistoryRatingCompleted.add(pointsHistoryRating[j]);
        j += 1;
      } else {
        pointsHistoryRatingCompleted.add(
          UserRatingHistoryPoint(
            date: currentDate,
            elo: pointsHistoryRating[j - 1].elo,
          ),
        );
      }
    }

    _allPoints = pointsHistoryRatingCompleted
        .map(
          (element) => FlSpot(
            element.date.millisecondsSinceEpoch.toDouble(),
            element.elo.toDouble(),
          ),
        )
        .toList();
    _startDate = widget.value.points.last.date
        .copyWith(month: widget.value.points.last.date.month - 3)
        .millisecondsSinceEpoch
        .toDouble();
    _endDate = _allPoints.last.x;
  }

  @override
  Widget build(BuildContext context) {
    final borderColor =
        Theme.of(context).colorScheme.onBackground.withOpacity(0.5);
    final chartColor = Theme.of(context).colorScheme.tertiary;
    final chartDateFormatter = switch (_selectedRange) {
      DateRange.oneWeek => DateFormat.MMMd(_currentLocale),
      DateRange.oneMonth => DateFormat.MMMd(_currentLocale),
      DateRange.threeMonths => DateFormat.yMMM(_currentLocale),
      DateRange.oneYear => DateFormat.yMMM(_currentLocale),
      DateRange.allTime => DateFormat.yMMM(_currentLocale),
    };

    String formatDateFromTimestamp(double timestamp) =>
        chartDateFormatter.format(
          DateTime.fromMillisecondsSinceEpoch(timestamp.toInt()),
        );

    String formatDateFromTimestampForTooltip(double timestamp) =>
        DateFormat.yMMMd(_currentLocale).format(
          DateTime.fromMillisecondsSinceEpoch(timestamp.toInt()),
        );

    void onPressed(DateRange dateRange) {
      switch (dateRange) {
        case DateRange.oneWeek:
          setState(() {
            _startDate = widget.value.points.last.date
                .subtract(const Duration(days: 7))
                .millisecondsSinceEpoch
                .toDouble();
          });
        case DateRange.oneMonth:
          setState(() {
            _startDate = widget.value.points.last.date
                .copyWith(month: widget.value.points.last.date.month - 1)
                .millisecondsSinceEpoch
                .toDouble();
          });
        case DateRange.threeMonths:
          setState(() {
            _startDate = widget.value.points.last.date
                .copyWith(month: widget.value.points.last.date.month - 3)
                .millisecondsSinceEpoch
                .toDouble();
          });
        case DateRange.oneYear:
          setState(() {
            _startDate = widget.value.points.last.date
                .copyWith(year: widget.value.points.last.date.year - 1)
                .millisecondsSinceEpoch
                .toDouble();
          });
        case DateRange.allTime:
          setState(() {
            _startDate = _allPoints.first.x;
          });
      }
      _selectedRange = dateRange;
    }

    Widget leftTitlesWidget(double value, TitleMeta meta) {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: Text(
          value.toInt().toString(),
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 10,
          ),
        ),
      );
    }

    Widget bottomTitlesWidget(double value, TitleMeta meta) {
      if (value == meta.min || value == meta.max) {
        return const SizedBox.shrink();
      }

      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: Text(
          formatDateFromTimestamp(value),
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 10,
          ),
        ),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(
              width: 25,
            ),
            ...DateRange.values.map(
              (dateRange) => _RangeButton(
                text: dateRange.toString(),
                onPressed: () => onPressed(dateRange),
                selected: _selectedRange == dateRange,
              ),
            ),
          ],
        ),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: LineChart(
            LineChartData(
              minY: _minY,
              maxY: _maxY,
              lineBarsData: [
                LineChartBarData(
                  spots: _points,
                  dotData: const FlDotData(show: false),
                  color: Theme.of(context).platform == TargetPlatform.iOS
                      ? null
                      : chartColor,
                  belowBarData: BarAreaData(
                    color: chartColor.withOpacity(0.2),
                    show: true,
                  ),
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
                getDrawingHorizontalLine: (value) => FlLine(
                  color: borderColor,
                  strokeWidth: 0.5,
                ),
              ),
              lineTouchData: LineTouchData(
                touchSpotThreshold: double.infinity,
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor:
                      Theme.of(context).platform == TargetPlatform.iOS
                          ? const Color.fromRGBO(96, 125, 139, 1)
                          : chartColor.withOpacity(0.2),
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
                                text: formatDateFromTimestampForTooltip(
                                  touchedSpot.x,
                                ),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
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
                      FlLine(
                        color: chartColor,
                        strokeWidth: 2,
                      ),
                      FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 5,
                            color: chartColor,
                          );
                        },
                      ),
                    );
                  }).toList();
                },
              ),
              titlesData: FlTitlesData(
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 25,
                    getTitlesWidget: bottomTitlesWidget,
                    interval: (_endDate - _startDate) / 3,
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
  const _RangeButton({
    required this.text,
    required this.onPressed,
    this.selected = false,
  });

  final String text;
  final VoidCallback onPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final chartColor = Theme.of(context).colorScheme.tertiary;

    return PlatformCard(
      color: selected ? chartColor.withOpacity(0.2) : null,
      surfaceTintColor: selected ? Colors.transparent : null,
      shadowColor: selected ? Colors.transparent : null,
      child: AdaptiveInkWell(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        onTap: onPressed,
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
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
  String toString() {
    return switch (this) {
      DateRange.oneWeek => '1W',
      DateRange.oneMonth => '1M',
      DateRange.threeMonths => '3M',
      DateRange.oneYear => '1Y',
      DateRange.allTime => 'ALL',
    };
  }
}
