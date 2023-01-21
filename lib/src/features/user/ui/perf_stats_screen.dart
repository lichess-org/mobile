import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/features/game/data/api_event.dart';
import 'package:lichess_mobile/src/utils/duration.dart';
import 'package:lichess_mobile/src/utils/style.dart';
import 'package:lichess_mobile/src/common/lichess_colors.dart';
import 'package:lichess_mobile/src/common/lichess_icons.dart';
import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/features/user/data/user_repository.dart';
import 'package:lichess_mobile/src/features/user/model/user.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

final perfStatsProvider = FutureProvider.autoDispose
    .family<UserPerfStats, UserPerfStatsParameters>((ref, perfParams) async {
      final userRepo = ref.watch(userRepositoryProvider);
      final either = await userRepo.getUserPerfStatsTask(
        perfParams.username,
        perfParams.perf,
      ).run();

      return either.match((error) => throw error, (data)  {
        ref.keepAlive();
        return data;
      });      
    });


const _customOpacity = 0.6;
const _defaultStatFontSize = 12.0;
const _defaultValueFontSize = 18.0;

class PerfStatsScreen extends ConsumerWidget {
  const PerfStatsScreen({
    required this.username,
    required this.perf,
    super.key});

  final String username;
  final Perf perf;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConsumerPlatformWidget(
      ref: ref,
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder);
  }

  Widget _androidBuilder(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(perf.icon),
            const SizedBox(width: 10),
            Text(context.l10n.perfStatsTitle(username, perf.name)),
          ],
        ),
      ),
      body: _buildBody(context, ref)
    );
  }

  Widget _iosBuilder(BuildContext context, WidgetRef ref) {
    // TODO: Add perf icon to title.
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: _buildBody(context, ref)
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref) {
    final perfStats = ref.watch(perfStatsProvider(
      UserPerfStatsParameters(username: username, perf: perf)
    ));

    const tableCellVerticalAlignment = TableCellVerticalAlignment.middle;
    const sectionTitleSeparation = 10.0;
    const sectionSeparation = 20.0;
    const sectionTitleStyle = TextStyle(
      color: LichessColors.primary,
      fontWeight: FontWeight.bold,
      fontSize: 20
    );

    const mainValueStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 30
    );

    const rowSpacer = TableRow(children: [
      Divider(color: LichessColors.accent, thickness: 0.0),
      Divider(color: LichessColors.primary, thickness: 0.0,)
    ]);

    const statGroupDivider = Divider(thickness: 2.0);

    return perfStats.when(
      data: (data) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5.0),
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                _customPlatformCard(context, context.l10n.userRating,
                 value: '${data.rating.toStringAsFixed(2)}${data.provisional == true || data.deviation > kProvisionalDeviation ? '?' : ''}',
                 styleValue: mainValueStyle
                ),
                _rowFromCards([
                  _customPlatformCard(context, context.l10n.progression,
                    widgets: [
                      _progressionWidget(context, data.progress)
                    ]
                  ),
                  _customPlatformCard(context, context.l10n.ratingDeviation, value: data.deviation.toStringAsFixed(2))
                ]),
                _rowFromCards([
                  _customPlatformCard(context, context.l10n.rank, value: data.rank == null ? '?' : data.rank.toString()),
                  _customPlatformCard(context, context.l10n.percentile, value: data.percentile == null ? '?' : data.percentile!.toStringAsFixed(2)),
                ]),
                _rowFromCards([
                  _customPlatformCard(context, context.l10n.highestRating,
                    widgets: _ratingWidget(context, data.highestRating, data.highestRatingGame, LichessColors.good)
                  ),
                  _customPlatformCard(context, context.l10n.lowestRating,
                    widgets: _ratingWidget(context, data.lowestRating, data.lowestRatingGame, LichessColors.red)
                  ),
                ]),
                statGroupDivider,
                _customPlatformCard(context, context.l10n.totalGames, 
                  value: data.numberOfGames.toString(),
                  styleValue: mainValueStyle),
                _rowFromCards([
                  _customPlatformCard(context, context.l10n.wins,
                    widgets: [_percentageValueWidget(context, data.wonGames, data.numberOfGames, color: LichessColors.good)]),
                  _customPlatformCard(context, context.l10n.draws,
                    widgets: [_percentageValueWidget(context, data.drawnGames, data.numberOfGames, color: textShade(context, _customOpacity), isShaded: true)]),
                  _customPlatformCard(context, context.l10n.losses,
                    widgets: [_percentageValueWidget(context, data.lostGames, data.numberOfGames, color: LichessColors.red)]),
                ]),
                _rowFromCards([
                  _customPlatformCard(context, context.l10n.rated,
                    widgets: [_percentageValueWidget(context, data.ratedGames, data.numberOfGames)]),
                  _customPlatformCard(context, context.l10n.tournament,
                    widgets: [_percentageValueWidget(context, data.tournamentGames, data.numberOfGames)]),
                  _customPlatformCard(context, context.l10n.berserked,
                    widgets: [_percentageValueWidget(context, data.berserkGames, data.numberOfGames)]),
                ]),
                _rowFromCards([
                  _customPlatformCard(context, context.l10n.averageOpponent, value: data.avgOpponent.toString()),
                  _customPlatformCard(context, context.l10n.timeSpentPlaying, value: data.timePlayed.toDaysHoursMinutes(context)),
                ]),
                statGroupDivider,
                _rowFromCards([
                  _customPlatformCard(context, context.l10n.maxWinningStreak, widgets: 
                    _streakWidget(context,data.maxWinStreak, color: LichessColors.good),
                  ),
                  _customPlatformCard(context, context.l10n.curWinningStreak, widgets: 
                    _streakWidget(context, data.curWinStreak, color: LichessColors.good),
                  )
                ]),
                _rowFromCards([
                  _customPlatformCard(context, context.l10n.maxLosingStreak, widgets: 
                    _streakWidget(context, data.maxLossStreak, color: LichessColors.red),
                  ),
                  _customPlatformCard(context, context.l10n.curLosingStreak, widgets: 
                    _streakWidget(context, data.curLossStreak, color: LichessColors.red),
                  )
                ]),
                _rowFromCards([
                  _customPlatformCard(context, context.l10n.maxPlayStreak, widgets: 
                    _streakWidget(context, data.maxPlayStreak),
                  ),
                  _customPlatformCard(context, context.l10n.curPlayStreak, widgets: 
                    _streakWidget(context, data.curPlayStreak),
                  )
                ]),
                _rowFromCards([
                  _customPlatformCard(context, context.l10n.maxTimeStreak, widgets: 
                    _streakWidget(context, data.maxTimeStreak, isTimeStreak: true),
                  ),
                  _customPlatformCard(context, context.l10n.curTimeStreak, widgets: 
                    _streakWidget(context, data.curTimeStreak, isTimeStreak: true),
                  )
                ]),
                statGroupDivider,
                _customPlatformCard(context, context.l10n.bestRatedVictories, widgets: _gameListWidget(context, data.bestWins)),
                _customPlatformCard(context, context.l10n.worstRatedDefeats, widgets: _gameListWidget(context, data.worstLosses))
                ]
            ),
          )
        );
      },
      error: (error, stackTrace) {
        debugPrint(
          'SEVERE: [PerfStatsScreen] could not load user games; ${error.toString()}\n$stackTrace');
          return const Center(child: Text('Could not load user stats.'));
      },
      loading: () => const CenterLoadingIndicator(),
    );
  }

  String _getPercentageString(num numerator, num denominator) {
    return '${((numerator / denominator) * 100).round().toString()}%';
  }

  PlatformCard _customPlatformCard(BuildContext context, String stat, {
    List<Widget>? widgets,
    String? value,
    TextStyle? styleStat,
    TextStyle? styleValue,}) {

    final defaultStatStyle = TextStyle(
      color: textShade(context, _customOpacity),
      fontSize: _defaultStatFontSize,
    );

    const defaultValueStyle = TextStyle(
      fontSize: _defaultValueFontSize
    );

    final TextStyle trueStatStyle = styleStat ?? defaultStatStyle;
    final TextStyle trueValueStyle = styleValue ?? defaultValueStyle;

    return PlatformCard(child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(stat, style: trueStatStyle, textAlign: TextAlign.center),
          if (value != null)
            Text(value, style: trueValueStyle, textAlign: TextAlign.center)
          else if (widgets != null)
            ...widgets
          else
            const Text('sample text')
        ],
      ),
    ));
  }

  IntrinsicHeight _rowFromCards(List<PlatformCard> cards) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final card in cards) Expanded(child: card)
        ]),
    );
  }

  Row _progressionWidget(BuildContext context, int progress) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      if (progress != 0) ...[
        Icon(progress > 0
            ? LichessIcons.arrow_full_upperright
            : LichessIcons.arrow_full_lowerright,
          color: progress > 0
            ? LichessColors.good
            : LichessColors.red,
        ),
        Text(progress.abs().toString(),
          style: TextStyle(
            color: progress > 0
              ? LichessColors.good
              : LichessColors.red,
            fontSize: _defaultValueFontSize
            )),
      ] else 
        Text('0', style: TextStyle(
          color: textShade(context, _customOpacity),
          fontSize: _defaultValueFontSize
        )
      )
    ]);
  }

  Text _userGameWidget(BuildContext context, UserGame? game, {
    TextStyle? styleDate
    }) {
    // TODO: Implement functionality to view game on tap.
    // (Return a button? Wrap with InkWell?)
    const defaultDateFontSize = 16.0;
    

    const defaultDateStyle = TextStyle(
      color: LichessColors.primary,
      fontSize: defaultDateFontSize
    );

    final TextStyle trueDateStyle = styleDate ?? defaultDateStyle;

    final dateFormatter = DateFormat('d MMM y');

    return game == null 
      ? Text('?', style: defaultDateStyle)
      : Text(dateFormatter.format(game.finishedAt), style: trueDateStyle);
  }

  List<Widget> _ratingWidget(BuildContext context, int? rating, UserGame? game, Color color) {
    return (rating == null)
      ? [const Text('?', style: TextStyle(fontSize: _defaultValueFontSize))]
      : [
        Text(rating.toStringAsFixed(2),
          style: TextStyle(
            fontSize: _defaultValueFontSize,
            color: color
          )
        ),
        _userGameWidget(context, game)
    ];
  }

  Column _percentageValueWidget(
    BuildContext context,
    int value,
    int denominator, {
      Color? color,
      bool isShaded = false
    }) {
      final trueColor = color ?? DefaultTextStyle.of(context).style.color;

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text(value.toString(), style: 
          TextStyle(fontSize: _defaultValueFontSize, color: trueColor)
        ),
        Text(_getPercentageString(value, denominator), style: 
          TextStyle(fontSize: _defaultValueFontSize, 
          color: isShaded ? trueColor!.withOpacity(_customOpacity / 2) : trueColor!.withOpacity(_customOpacity))
        )
      ]);
    }

  List<Widget> _streakWidget(
    BuildContext context,
    UserStreak? streak, {
      bool isTimeStreak = false,
      Color? color
    }) {
      final trueColor = color ?? DefaultTextStyle.of(context).style.color;
      final valueStyle = TextStyle(
        color: trueColor,
        fontSize: _defaultValueFontSize
      );

      return streak == null || streak.value == 0
        ? [const Text('-', style: TextStyle(fontSize: _defaultValueFontSize),)]
        : [Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isTimeStreak)
                Text(Duration(seconds: streak.value).toDaysHoursMinutes(context), style: valueStyle, textAlign: TextAlign.center)
              else 
                Text(context.l10n.nbGames(streak.value), style: valueStyle, textAlign: TextAlign.center),
              if (!(streak.startGame == null && streak.endGame == null))
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 5.0),
                    _userGameWidget(context, streak.startGame),
                    Icon(Icons.arrow_downward_rounded, color: textShade(context, _customOpacity)),
                    _userGameWidget(context, streak.endGame)
                  ],
                )
          ])
        ];
  }

  List<Widget> _gameListWidget(BuildContext context, List<UserGame>? games) {
    final List<Widget> gameWidgets = List.empty(growable: true);

    const _gameWidgetSeparation = 5.0;

    if (games == null || games.isEmpty) {
      gameWidgets.add(const Text('?'));
    } else {
      for (final game in games) {
        gameWidgets.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(game.opponentName ?? '?', maxLines: 1, overflow: TextOverflow.ellipsis)
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(game.opponentRating == null ? '?' : game.opponentRating.toString(), textAlign: TextAlign.center)
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: _userGameWidget(context, game)
              ),
            )
        ]));
        gameWidgets.add(const SizedBox(height: _gameWidgetSeparation));
      }
    }

    return gameWidgets;
  }
}
