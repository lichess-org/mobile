import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/player.dart';

final _dateFormatter = DateFormat.yMMMd(Intl.getCurrentLocale());

class UserActivityEntry extends ConsumerWidget {
  const UserActivityEntry({required this.entry, super.key});

  final UserActivity entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leadingIconSize =
        defaultTargetPlatform == TargetPlatform.iOS ? 26.0 : 36.0;
    final emptySubtitle = defaultTargetPlatform == TargetPlatform.iOS
        ? const SizedBox.shrink()
        : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 14.0,
            top: 16.0,
            right: 14.0,
            bottom: 4.0,
          ),
          child: Text(
            _dateFormatter.format(entry.startTime),
            style: const TextStyle(
              color: LichessColors.brag,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (entry.games != null)
          for (final gameEntry in entry.games!.entries)
            PlatformListTile(
              leading: Icon(
                gameEntry.key.icon,
                size: leadingIconSize,
              ),
              title: Text(
                context.l10n.activityPlayedNbGames(
                  gameEntry.value.win +
                      gameEntry.value.draw +
                      gameEntry.value.loss,
                  gameEntry.key.title,
                ),
              ),
              subtitle: Row(
                children: [
                  PlayerRating(
                    deviation: 0,
                    rating: gameEntry.value.ratingAfter,
                  ),
                  const SizedBox(width: 3),
                  if (gameEntry.value.ratingAfter -
                          gameEntry.value.ratingBefore !=
                      0) ...[
                    Icon(
                      gameEntry.value.ratingAfter -
                                  gameEntry.value.ratingBefore >
                              0
                          ? LichessIcons.arrow_full_upperright
                          : LichessIcons.arrow_full_lowerright,
                      color: gameEntry.value.ratingAfter -
                                  gameEntry.value.ratingBefore >
                              0
                          ? LichessColors.good
                          : LichessColors.red,
                      size: 12,
                    ),
                    Text(
                      (gameEntry.value.ratingAfter -
                              gameEntry.value.ratingBefore)
                          .abs()
                          .toString(),
                      style: TextStyle(
                        color: gameEntry.value.ratingAfter -
                                    gameEntry.value.ratingBefore >
                                0
                            ? LichessColors.good
                            : LichessColors.red,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ],
              ),
              trailing: BriefGameResultBox(
                win: gameEntry.value.win,
                draw: gameEntry.value.draw,
                loss: gameEntry.value.loss,
              ),
            ),
        if (entry.puzzles != null)
          PlatformListTile(
            leading: Icon(
              LichessIcons.target,
              size: leadingIconSize,
            ),
            title: Text(
              context.l10n.activitySolvedNbPuzzles(
                entry.puzzles!.win + entry.puzzles!.loss,
              ),
            ),
            subtitle: Row(
              children: [
                PlayerRating(
                  deviation: 0,
                  rating: entry.puzzles!.ratingAfter,
                ),
                const SizedBox(width: 3),
                if (entry.puzzles!.ratingAfter - entry.puzzles!.ratingBefore !=
                    0) ...[
                  Icon(
                    entry.puzzles!.ratingAfter - entry.puzzles!.ratingBefore > 0
                        ? LichessIcons.arrow_full_upperright
                        : LichessIcons.arrow_full_lowerright,
                    color: entry.puzzles!.ratingAfter -
                                entry.puzzles!.ratingBefore >
                            0
                        ? LichessColors.good
                        : LichessColors.red,
                    size: 12,
                  ),
                  Text(
                    (entry.puzzles!.ratingAfter - entry.puzzles!.ratingBefore)
                        .abs()
                        .toString(),
                    style: TextStyle(
                      color: entry.puzzles!.ratingAfter -
                                  entry.puzzles!.ratingBefore >
                              0
                          ? LichessColors.good
                          : LichessColors.red,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
            trailing: BriefGameResultBox(
              win: entry.puzzles!.win,
              draw: 0,
              loss: entry.puzzles!.loss,
            ),
          ),
        if (entry.streak != null)
          PlatformListTile(
            leading: Icon(
              LichessIcons.streak,
              size: leadingIconSize,
            ),
            title: Text(
              context.l10n.stormPlayedNbRunsOfPuzzleStorm(
                entry.streak!.runs,
                'Puzzle Streak',
              ),
            ),
            subtitle: emptySubtitle,
            trailing: BriefGameResultBox(
              win: entry.streak!.score,
              draw: 0,
              loss: 0,
            ),
          ),
        if (entry.correspondenceEnds != null)
          PlatformListTile(
            leading: Icon(
              LichessIcons.correspondence,
              size: leadingIconSize,
            ),
            title: Text(
              context.l10n.activityCompletedNbGames(
                entry.correspondenceEnds!.win +
                    entry.correspondenceEnds!.draw +
                    entry.correspondenceEnds!.loss,
              ),
            ),
            subtitle: emptySubtitle,
            trailing: BriefGameResultBox(
              win: entry.correspondenceEnds!.win,
              draw: entry.correspondenceEnds!.draw,
              loss: entry.correspondenceEnds!.loss,
            ),
          ),
        if (entry.correspondenceMovesNb != null &&
            entry.correspondenceGamesNb != null)
          PlatformListTile(
            leading: Icon(
              LichessIcons.correspondence,
              size: leadingIconSize,
            ),
            title: Text(
              context.l10n.activityPlayedNbMoves(
                entry.correspondenceMovesNb!,
              ),
            ),
            subtitle: Text(
              context.l10n.activityInNbCorrespondenceGames(
                entry.correspondenceGamesNb!,
              ),
            ),
          ),
        if (entry.tournamentNb != null)
          PlatformListTile(
            leading: Icon(
              Icons.emoji_events,
              size: leadingIconSize,
            ),
            title: Text(
              context.l10n.activityCompetedInNbTournaments(
                entry.tournamentNb!,
              ),
            ),
            subtitle: entry.bestTournament != null
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
          PlatformListTile(
            leading: Icon(
              Icons.thumb_up,
              size: leadingIconSize,
            ),
            title: Text(
              context.l10n.activityGainedNbFollowers(entry.followInNb!),
            ),
            subtitle: emptySubtitle,
          ),
      ],
    );
  }
}

class BriefGameResultBox extends StatelessWidget {
  const BriefGameResultBox({
    required this.win,
    required this.draw,
    required this.loss,
  });

  final int win;
  final int draw;
  final int loss;

  static const gameStatsFontStyle = TextStyle(
    color: Colors.white,
    fontSize: 11,
    fontWeight: FontWeight.bold,
  );

  static const _boxSize = 20.0;
  static const _spaceWidth = 3.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: SizedBox(
        height: 20,
        width: (win != 0 ? 1 : 0) * _boxSize +
            (draw != 0 ? 1 : 0) * _boxSize +
            (loss != 0 ? 1 : 0) * _boxSize +
            ((win != 0 ? 1 : 0) +
                    (draw != 0 ? 1 : 0) +
                    (loss != 0 ? 1 : 0) -
                    1) *
                _spaceWidth,
        child: Row(
          children: [
            if (win != 0)
              SizedBox(
                height: _boxSize,
                width: _boxSize,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: LichessColors.good,
                    borderRadius: BorderRadius.all(Radius.circular(3.0)),
                  ),
                  child: Center(
                    child: Text(
                      win.toString(),
                      style: gameStatsFontStyle,
                    ),
                  ),
                ),
              ),
            if (win != 0 && draw != 0)
              const SizedBox(
                width: _spaceWidth,
              ),
            if (draw != 0)
              SizedBox(
                height: _boxSize,
                width: _boxSize,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: LichessColors.brag,
                    borderRadius: BorderRadius.all(Radius.circular(3.0)),
                  ),
                  child: Center(
                    child: Text(
                      draw.toString(),
                      style: gameStatsFontStyle,
                    ),
                  ),
                ),
              ),
            if ((draw != 0 && loss != 0) || (win != 0 && loss != 0))
              const SizedBox(
                width: _spaceWidth,
              ),
            if (loss != 0)
              SizedBox(
                height: _boxSize,
                width: _boxSize,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: LichessColors.red,
                    borderRadius: BorderRadius.all(Radius.circular(3.0)),
                  ),
                  child: Center(
                    child: Text(
                      loss.toString(),
                      style: gameStatsFontStyle,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
