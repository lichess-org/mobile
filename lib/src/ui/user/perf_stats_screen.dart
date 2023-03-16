import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/common/lichess_colors.dart';
import 'package:lichess_mobile/src/common/lichess_icons.dart';
import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/common/styles.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/game/game_repository_providers.dart';
import 'package:lichess_mobile/src/ui/game/archived_game_screen.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/duration.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/player.dart';

final _dateFormatter = DateFormat.yMMMd(Intl.getCurrentLocale());

const _customOpacity = 0.6;
const _defaultStatFontSize = 12.0;
const _defaultValueFontSize = 18.0;
const _mainValueStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 30);

class PerfStatsScreen extends StatelessWidget {
  const PerfStatsScreen({
    required this.user,
    required this.perf,
    required this.loggedInUser,
    super.key,
  });

  final User user;
  final Perf perf;
  final User? loggedInUser;

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
      body: _Body(user: user, perf: perf, loggedInUser: loggedInUser),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: _Title(user: user, perf: perf),
      ),
      child: _Body(user: user, perf: perf, loggedInUser: loggedInUser),
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
          child: PlayerTitle(userName: user.username, title: user.title),
        ),
        Flexible(
          child: Text(
            ' ${context.l10n.perfStats(perf.title)}',
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
    required this.loggedInUser,
  });

  final User user;
  final Perf perf;
  final User? loggedInUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfStats = ref.watch(userPerfStatsProvider(id: user.id, perf: perf));

    const statGroupSpace = SizedBox(height: 15.0);
    const subStatSpace = SizedBox(height: 10);

    return perfStats.when(
      data: (data) {
        return SafeArea(
          child: ListView(
            padding: Styles.verticalBodyPadding,
            scrollDirection: Axis.vertical,
            children: [
              Padding(
                padding: Styles.horizontalBodyPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${context.l10n.rating} ',
                          style: Styles.sectionTitle,
                        ),
                        PlayerRating(
                          rating: data.rating,
                          deviation: data.deviation,
                          provisional: data.provisional,
                          style: _mainValueStyle,
                        ),
                      ],
                    ),
                    if (data.percentile != null)
                      Text(
                        (loggedInUser != null &&
                                loggedInUser!.username == user.username)
                            ? context.l10n
                                .youAreBetterThanPercentOfPerfTypePlayers(
                                '${data.percentile!.toStringAsFixed(2)}%',
                                perf.title,
                              )
                            : context.l10n
                                .userIsBetterThanPercentOfPerfTypePlayers(
                                user.username,
                                '${data.percentile!.toStringAsFixed(2)}%',
                                perf.title,
                              ),
                        style: TextStyle(color: textShade(context, 0.7)),
                      ),
                  ],
                ),
              ),
              subStatSpace,
              // The number '12' here is not arbitrary, since the API returns the progression for the last 12 games (as far as I know).
              _CustomPlatformCard(
                context.l10n.progressOverLastXGames('12').replaceAll(':', ''),
                padding: Styles.horizontalBodyPadding,
                child: _ProgressionWidget(data.progress),
              ),
              _CustomPlatformCardRow([
                _CustomPlatformCard(
                  context.l10n.rank,
                  value: data.rank == null
                      ? '?'
                      : NumberFormat.decimalPattern(Intl.getCurrentLocale())
                          .format(data.rank),
                ),
                _CustomPlatformCard(
                  context.l10n.ratingDeviation('').replaceAll(': .', ''),
                  value: data.deviation.toStringAsFixed(2),
                )
              ]),
              _CustomPlatformCardRow([
                _CustomPlatformCard(
                  context.l10n.highestRating('').replaceAll(':', ''),
                  child: _RatingWidget(
                    data.highestRating,
                    data.highestRatingGame,
                    LichessColors.good,
                  ),
                ),
                _CustomPlatformCard(
                  context.l10n.lowestRating('').replaceAll(':', ''),
                  child: _RatingWidget(
                    data.lowestRating,
                    data.lowestRatingGame,
                    LichessColors.red,
                  ),
                ),
              ]),
              statGroupSpace,
              Padding(
                padding: Styles.horizontalBodyPadding,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${context.l10n.totalGames} ',
                      style: Styles.sectionTitle,
                    ),
                    Text(data.totalGames.toString(), style: _mainValueStyle),
                  ],
                ),
              ),
              subStatSpace,
              _CustomPlatformCardRow([
                _CustomPlatformCard(
                  context.l10n.wins,
                  child: _PercentageValueWidget(
                    data.wonGames,
                    data.totalGames,
                    color: LichessColors.good,
                  ),
                ),
                _CustomPlatformCard(
                  context.l10n.draws,
                  child: _PercentageValueWidget(
                    data.drawnGames,
                    data.totalGames,
                    color: textShade(context, _customOpacity),
                    isShaded: true,
                  ),
                ),
                _CustomPlatformCard(
                  context.l10n.losses,
                  child: _PercentageValueWidget(
                    data.lostGames,
                    data.totalGames,
                    color: LichessColors.red,
                  ),
                ),
              ]),
              _CustomPlatformCardRow([
                _CustomPlatformCard(
                  context.l10n.rated,
                  child: _PercentageValueWidget(
                    data.ratedGames,
                    data.totalGames,
                  ),
                ),
                _CustomPlatformCard(
                  context.l10n.tournament,
                  child: _PercentageValueWidget(
                    data.tournamentGames,
                    data.totalGames,
                  ),
                ),
                _CustomPlatformCard(
                  context.l10n.berserkedGames
                      .replaceAll(' ${context.l10n.games.toLowerCase()}', ''),
                  child: _PercentageValueWidget(
                    data.berserkGames,
                    data.totalGames,
                  ),
                ),
                _CustomPlatformCard(
                  context.l10n.disconnections,
                  child: _PercentageValueWidget(
                    data.disconnections,
                    data.totalGames,
                  ),
                ),
              ]),
              _CustomPlatformCardRow([
                _CustomPlatformCard(
                  context.l10n.averageOpponent,
                  value: data.avgOpponent == null
                      ? '?'
                      : data.avgOpponent.toString(),
                ),
                _CustomPlatformCard(
                  context.l10n.timeSpentPlaying,
                  value: data.timePlayed
                      .toDaysHoursMinutes(AppLocalizations.of(context)),
                ),
              ]),
              _CustomPlatformCard(
                padding: Styles.horizontalBodyPadding,
                context.l10n.winningStreak,
                child: _StreakWidget(
                  data.maxWinStreak,
                  data.curWinStreak,
                  color: LichessColors.good,
                ),
              ),
              _CustomPlatformCard(
                padding: Styles.horizontalBodyPadding,
                context.l10n.losingStreak,
                child: _StreakWidget(
                  data.maxLossStreak,
                  data.curLossStreak,
                  color: LichessColors.red,
                ),
              ),
              _CustomPlatformCard(
                padding: Styles.horizontalBodyPadding,
                context.l10n.gamesInARow,
                child: _StreakWidget(data.maxPlayStreak, data.curPlayStreak),
              ),
              _CustomPlatformCard(
                padding: Styles.horizontalBodyPadding,
                context.l10n.maxTimePlaying,
                child: _StreakWidget(data.maxTimeStreak, data.curTimeStreak),
              ),
              if (data.bestWins != null && data.bestWins!.isNotEmpty) ...[
                statGroupSpace,
                _GameListWidget(
                  games: data.bestWins!,
                  perf: perf,
                  user: user,
                  header:
                      Text(context.l10n.bestRated, style: Styles.sectionTitle),
                ),
              ],
              if (data.worstLosses != null && data.worstLosses!.isNotEmpty) ...[
                statGroupSpace,
                _GameListWidget(
                  games: data.worstLosses!,
                  perf: perf,
                  user: user,
                  header:
                      Text(context.l10n.worstRated, style: Styles.sectionTitle),
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

class _CustomPlatformCard extends StatelessWidget {
  const _CustomPlatformCard(
    this.stat, {
    this.child,
    this.value,
    this.padding,
  });

  final String stat;
  final Widget? child;
  final String? value;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final defaultStatStyle = TextStyle(
      color: textShade(context, _customOpacity),
      fontSize: _defaultStatFontSize,
    );

    const defaultValueStyle = TextStyle(fontSize: _defaultValueFontSize);

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: PlatformCard(
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FittedBox(
                alignment: Alignment.center,
                fit: BoxFit.scaleDown,
                child: Text(
                  stat,
                  style: defaultStatStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              if (value != null)
                Text(
                  value!,
                  style: defaultValueStyle,
                  textAlign: TextAlign.center,
                )
              else if (child != null)
                child!
              else
                const Text('?', style: defaultValueStyle)
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomPlatformCardRow extends StatelessWidget {
  final List<_CustomPlatformCard> cards;

  const _CustomPlatformCardRow(this.cards);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Styles.horizontalBodyPadding,
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _divideRow(cards)
              .map((e) => Expanded(child: e))
              .toList(growable: false),
        ),
      ),
    );
  }
}

@allowedWidgetReturn
Iterable<Widget> _divideRow(Iterable<Widget> elements) {
  final list = elements.toList();

  if (list.isEmpty || list.length == 1) {
    return list;
  }

  Widget wrapElement(Widget el) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: el,
    );
  }

  return <Widget>[
    ...list.take(list.length - 1).map(wrapElement),
    list.last,
  ];
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
          )
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
              _UserGameWidget(game)
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
          value.toString(),
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
        )
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

    final longestStreakStr = context.l10n.longestStreak('').replaceAll(':', '');
    final currentStreakStr = context.l10n.currentStreak('').replaceAll(':', '');

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
              )
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
                  _UserGameWidget(streak.endGame)
                ],
              )
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
        )
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
      hasLeading: true,
      children: [
        for (final game in games)
          GameListTile(
            onTap: () {
              final gameIds = ISet(games.map((g) => g.gameId));
              ref.read(gamesByIdProvider(ids: gameIds).future).then((list) {
                final gameData =
                    list.firstWhereOrNull((g) => g.id == game.gameId);
                if (gameData != null) {
                  pushPlatformRoute(
                    context,
                    rootNavigator: true,
                    builder: (context) => ArchivedGameScreen(
                      gameData: gameData,
                      orientation: user.id == gameData.white.id
                          ? Side.white
                          : Side.black,
                    ),
                  );
                }
              });
            },
            icon: perf.icon,
            playerTitle: PlayerTitle(
              userName: game.opponentName ?? '?',
              title: game.opponentTitle,
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
