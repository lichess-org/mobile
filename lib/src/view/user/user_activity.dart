import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/account/rating_pref_aware.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/rating.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';

final _dateFormatter = DateFormat.yMMMd();

class UserActivityWidget extends ConsumerWidget {
  const UserActivityWidget({this.user, super.key});

  final User? user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activity =
        user != null
            ? ref.watch(userActivityProvider(id: user!.id))
            : ref.watch(accountActivityProvider);

    return activity.when(
      data: (data) {
        final nonEmptyActivities = data.where((entry) => entry.isNotEmpty);
        if (nonEmptyActivities.isEmpty) {
          return const SizedBox.shrink();
        }
        return ListSection(
          header: Text(context.l10n.activityActivity, style: Styles.sectionTitle),
          hasLeading: true,
          children:
              nonEmptyActivities.take(10).map((entry) => UserActivityEntry(entry: entry)).toList(),
        );
      },
      error: (error, stackTrace) {
        debugPrint('SEVERE: [UserScreen] could not load user activity; $error\n$stackTrace');
        return const Text('Could not load user activity');
      },
      loading:
          () => Shimmer(
            child: ShimmerLoading(
              isLoading: true,
              child: ListSection.loading(itemsNumber: 10, header: true, hasLeading: true),
            ),
          ),
    );
  }
}

class UserActivityEntry extends ConsumerWidget {
  const UserActivityEntry({required this.entry, super.key});

  final UserActivity entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final leadingIconSize = theme.platform == TargetPlatform.iOS ? 26.0 : 36.0;
    final emptySubtitle = theme.platform == TargetPlatform.iOS ? const SizedBox.shrink() : null;

    final redColor = theme.extension<CustomColors>()?.error;
    final greenColor = theme.extension<CustomColors>()?.good;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 14.0, top: 16.0, right: 14.0, bottom: 4.0),
          child: Text(
            _dateFormatter.format(entry.startTime),
            style: TextStyle(color: context.lichessColors.brag, fontWeight: FontWeight.bold),
          ),
        ),
        if (entry.games != null)
          for (final gameEntry in entry.games!.entries)
            _UserActivityListTile(
              leading: Icon(gameEntry.key.icon, size: leadingIconSize),
              title: context.l10n.activityPlayedNbGames(
                gameEntry.value.win + gameEntry.value.draw + gameEntry.value.loss,
                gameEntry.key.title,
              ),
              subtitle: RatingPrefAware(
                child: Row(
                  children: [
                    RatingWidget(deviation: 0, rating: gameEntry.value.ratingAfter),
                    const SizedBox(width: 3),
                    if (gameEntry.value.ratingAfter - gameEntry.value.ratingBefore != 0) ...[
                      Icon(
                        gameEntry.value.ratingAfter - gameEntry.value.ratingBefore > 0
                            ? LichessIcons.arrow_full_upperright
                            : LichessIcons.arrow_full_lowerright,
                        color:
                            gameEntry.value.ratingAfter - gameEntry.value.ratingBefore > 0
                                ? greenColor
                                : redColor,
                        size: 12,
                      ),
                      Text(
                        (gameEntry.value.ratingAfter - gameEntry.value.ratingBefore)
                            .abs()
                            .toString(),
                        style: TextStyle(
                          color:
                              gameEntry.value.ratingAfter - gameEntry.value.ratingBefore > 0
                                  ? greenColor
                                  : redColor,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              trailing: BriefGameResultBox(
                win: gameEntry.value.win,
                draw: gameEntry.value.draw,
                loss: gameEntry.value.loss,
              ),
            ),
        if (entry.puzzles != null)
          _UserActivityListTile(
            leading: Icon(LichessIcons.target, size: leadingIconSize),
            title: context.l10n.activitySolvedNbPuzzles(entry.puzzles!.win + entry.puzzles!.loss),
            subtitle: RatingPrefAware(
              child: Row(
                children: [
                  RatingWidget(deviation: 0, rating: entry.puzzles!.ratingAfter),
                  const SizedBox(width: 3),
                  if (entry.puzzles!.ratingAfter - entry.puzzles!.ratingBefore != 0) ...[
                    Icon(
                      entry.puzzles!.ratingAfter - entry.puzzles!.ratingBefore > 0
                          ? LichessIcons.arrow_full_upperright
                          : LichessIcons.arrow_full_lowerright,
                      color:
                          entry.puzzles!.ratingAfter - entry.puzzles!.ratingBefore > 0
                              ? greenColor
                              : redColor,
                      size: 12,
                    ),
                    Text(
                      (entry.puzzles!.ratingAfter - entry.puzzles!.ratingBefore).abs().toString(),
                      style: TextStyle(
                        color:
                            entry.puzzles!.ratingAfter - entry.puzzles!.ratingBefore > 0
                                ? greenColor
                                : redColor,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            trailing: BriefGameResultBox(
              win: entry.puzzles!.win,
              draw: 0,
              loss: entry.puzzles!.loss,
            ),
          ),
        if (entry.streak != null)
          _UserActivityListTile(
            leading: Icon(LichessIcons.streak, size: leadingIconSize),
            title: context.l10n.stormPlayedNbRunsOfPuzzleStorm(entry.streak!.runs, 'Puzzle Streak'),
            subtitle: emptySubtitle,
            trailing: BriefGameResultBox(win: entry.streak!.score, draw: 0, loss: 0),
          ),
        if (entry.storm != null)
          _UserActivityListTile(
            leading: Icon(LichessIcons.storm, size: leadingIconSize),
            title: context.l10n.stormPlayedNbRunsOfPuzzleStorm(entry.storm!.runs, 'Puzzle Storm'),
            subtitle: emptySubtitle,
            trailing: BriefGameResultBox(win: entry.storm!.score, draw: 0, loss: 0),
          ),
        if (entry.correspondenceEnds != null)
          _UserActivityListTile(
            leading: Icon(LichessIcons.correspondence, size: leadingIconSize),
            title: context.l10n.activityCompletedNbGames(
              entry.correspondenceEnds!.win +
                  entry.correspondenceEnds!.draw +
                  entry.correspondenceEnds!.loss,
            ),
            subtitle: emptySubtitle,
            trailing: BriefGameResultBox(
              win: entry.correspondenceEnds!.win,
              draw: entry.correspondenceEnds!.draw,
              loss: entry.correspondenceEnds!.loss,
            ),
          ),
        if (entry.correspondenceMovesNb != null && entry.correspondenceGamesNb != null)
          _UserActivityListTile(
            leading: Icon(LichessIcons.correspondence, size: leadingIconSize),
            title: context.l10n.activityPlayedNbMoves(entry.correspondenceMovesNb!),
            subtitle: Text(
              context.l10n.activityInNbCorrespondenceGames(entry.correspondenceGamesNb!),
            ),
          ),
        if (entry.tournamentNb != null)
          _UserActivityListTile(
            leading: Icon(Icons.emoji_events, size: leadingIconSize),
            title: context.l10n.activityCompetedInNbTournaments(entry.tournamentNb!),
            subtitle:
                entry.bestTournament != null
                    ? Text(
                      context.l10n.activityRankedInTournament(
                        entry.bestTournament!.rank,
                        entry.bestTournament!.rankPercent.toString(),
                        entry.bestTournament!.nbGames.toString(),
                        entry.bestTournament!.name,
                      ),
                      maxLines: 2,
                    )
                    : emptySubtitle,
          ),
        if (entry.followInNb != null)
          _UserActivityListTile(
            leading: Icon(Icons.thumb_up, size: leadingIconSize),
            title: context.l10n.activityGainedNbFollowers(entry.followInNb!),
            subtitle: emptySubtitle,
          ),
      ],
    );
  }
}

class _UserActivityListTile extends StatelessWidget {
  const _UserActivityListTile({required this.title, this.subtitle, this.trailing, this.leading});

  final String title;
  final Widget? subtitle;
  final Widget? trailing;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return PlatformListTile(
      leading: leading,
      title: Text(title, maxLines: 2),
      subtitle: subtitle,
      trailing: trailing,
    );
  }
}

const _boxSize = 20.0;
const _spaceWidth = 3.0;

const _gameStatsFontStyle = TextStyle(
  color: Colors.white,
  fontSize: 11,
  fontWeight: FontWeight.bold,
);

class _ResultBox extends StatelessWidget {
  const _ResultBox({required this.number, required this.color});

  final int number;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _boxSize,
      width: _boxSize,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(3.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text(number.toString(), style: _gameStatsFontStyle),
        ),
      ),
    );
  }
}

class BriefGameResultBox extends StatelessWidget {
  const BriefGameResultBox({required this.win, required this.draw, required this.loss});

  final int win;
  final int draw;
  final int loss;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: SizedBox(
        height: 20,
        width:
            (win != 0 ? 1 : 0) * _boxSize +
            (draw != 0 ? 1 : 0) * _boxSize +
            (loss != 0 ? 1 : 0) * _boxSize +
            ((win != 0 ? 1 : 0) + (draw != 0 ? 1 : 0) + (loss != 0 ? 1 : 0) - 1) * _spaceWidth,
        child: Row(
          children: [
            if (win != 0)
              _ResultBox(
                number: win,
                color: Theme.of(context).extension<CustomColors>()?.good ?? LichessColors.green,
              ),
            if (win != 0 && draw != 0) const SizedBox(width: _spaceWidth),
            if (draw != 0) _ResultBox(number: draw, color: context.lichessColors.brag),
            if ((draw != 0 && loss != 0) || (win != 0 && loss != 0))
              const SizedBox(width: _spaceWidth),
            if (loss != 0)
              _ResultBox(
                number: loss,
                color:
                    Theme.of(context).extension<CustomColors>()?.error ??
                    context.lichessColors.error,
              ),
          ],
        ),
      ),
    );
  }
}
