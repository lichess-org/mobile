import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/common/lichess_colors.dart';
import 'package:lichess_mobile/src/common/lichess_icons.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/player.dart';

const List<String> _monthName = [
  '',
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec'
];

class UserActivityGameEntry {
  const UserActivityGameEntry({
    required this.icon,
    required this.variant,
    required this.win,
    required this.draw,
    required this.loss,
    required this.cnt,
    required this.ratingBefore,
    required this.ratingAfter,
  });

  final IconData icon;
  final String variant;
  final int win;
  final int draw;
  final int loss;
  final int cnt;
  final int ratingBefore;
  final int ratingAfter;
}

class UserActivityEntry extends ConsumerWidget {
  const UserActivityEntry({required this.entry, super.key});

  final UserActivity entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final games = entry.games!.mapTo((key, value) {
      return UserActivityGameEntry(
        icon: key.icon,
        variant: key.title,
        win: value.win,
        draw: value.draw,
        loss: value.loss,
        cnt: value.win + value.draw + value.loss,
        ratingBefore: value.ratingBefore,
        ratingAfter: value.ratingAfter,
      );
    });

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
            "${_monthName[entry.startTime.month].toUpperCase()} ${entry.startTime.day}, ${entry.startTime.year}",
            style: const TextStyle(
              color: LichessColors.brag,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        for (final e in games)
          PlatformListTile(
            visualDensity: const VisualDensity(vertical: -2.5),
            dense: true,
            leading: Icon(
              e.icon,
              color: LichessColors.brag,
            ),
            title: Row(
              children: [
                Text(
                  context.l10n.activityPlayedNbGames(
                    e.cnt,
                    e.variant,
                  ),
                ),
              ],
            ),
            subtitle: Row(
              children: [
                PlayerRating(
                  deviation: 0,
                  rating: e.ratingAfter,
                ),
                const SizedBox(width: 3),
                if (e.ratingAfter - e.ratingBefore != 0) ...[
                  Icon(
                    e.ratingAfter - e.ratingBefore > 0
                        ? LichessIcons.arrow_full_upperright
                        : LichessIcons.arrow_full_lowerright,
                    color: e.ratingAfter - e.ratingBefore > 0
                        ? LichessColors.good
                        : LichessColors.red,
                    size: 12,
                  ),
                  Text(
                    (e.ratingAfter - e.ratingBefore).abs().toString(),
                    style: TextStyle(
                      color: e.ratingAfter - e.ratingBefore > 0
                          ? LichessColors.good
                          : LichessColors.red,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
            trailing: BriefGameResultBox(
              win: e.win,
              draw: e.draw,
              loss: e.loss,
            ),
          ),
        if (entry.puzzles != null)
          PlatformListTile(
            leading: const Icon(
              LichessIcons.target,
              color: LichessColors.brag,
            ),
            title: Text(
              context.l10n.activitySolvedNbPuzzles(
                entry.puzzles!.win + entry.puzzles!.loss,
              ),
            ),
            visualDensity: const VisualDensity(vertical: -2.5),
            dense: true,
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
            leading: const Icon(
              LichessIcons.streak,
              color: LichessColors.brag,
            ),
            title: Text(
              context.l10n.stormPlayedNbRunsOfPuzzleStorm(
                entry.streak!.runs,
                'Puzzle Streak',
              ),
            ),
            subtitle: const SizedBox.shrink(),
            visualDensity: const VisualDensity(vertical: -2.5),
            dense: true,
            trailing: BriefGameResultBox(
              win: entry.streak!.score,
              draw: 0,
              loss: 0,
            ),
          ),
        if (entry.correspondenceEnds != null)
          PlatformListTile(
            leading: const Icon(
              LichessIcons.correspondence,
              color: LichessColors.brag,
            ),
            title: Text(
              context.l10n.activityCompletedNbGames(
                entry.correspondenceEnds!.win +
                    entry.correspondenceEnds!.draw +
                    entry.correspondenceEnds!.loss,
              ),
            ),
            trailing: BriefGameResultBox(
              win: entry.correspondenceEnds!.win,
              draw: entry.correspondenceEnds!.draw,
              loss: entry.correspondenceEnds!.loss,
            ),
            visualDensity: const VisualDensity(vertical: -2.5),
            dense: true,
          ),
        if (entry.correspondenceMovesNb != null)
          PlatformListTile(
            leading: const Icon(
              LichessIcons.correspondence,
              color: LichessColors.brag,
            ),
            title: Text(
              context.l10n.activityInNbCorrespondenceGames(
                entry.correspondenceMovesNb!,
              ),
            ),
            visualDensity: const VisualDensity(vertical: -2.5),
            dense: true,
          ),
        if (entry.tournamentNb != null)
          PlatformListTile(
            leading: const Icon(
              Icons.emoji_events,
              color: LichessColors.brag,
            ),
            title: Text(
              context.l10n.activityCompetedInNbTournaments(
                entry.tournamentNb!,
              ),
            ),
            visualDensity: const VisualDensity(vertical: -2.5),
            dense: true,
          ),
        if (entry.followInNb != null)
          PlatformListTile(
            leading: const Icon(
              Icons.thumb_up,
              color: LichessColors.brag,
            ),
            title: Text(
              context.l10n.activityFollowedNbPlayers(entry.followInNb!),
            ),
            visualDensity: const VisualDensity(vertical: -2.5),
            dense: true,
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
    fontSize: 10,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: (win != 0 ? 1 : 0) * 18 +
          (draw != 0 ? 1 : 0) * 18 +
          (loss != 0 ? 1 : 0) * 18 +
          ((win != 0 ? 1 : 0) + (draw != 0 ? 1 : 0) + (loss != 0 ? 1 : 0) - 1) *
              3,
      child: Row(
        children: [
          if (win != 0)
            SizedBox(
              height: 18,
              width: 18,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: LichessColors.good,
                  borderRadius: BorderRadius.circular(3.0),
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
              width: 3,
            ),
          if (draw != 0)
            SizedBox(
              height: 18,
              width: 18,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: LichessColors.brag,
                  borderRadius: BorderRadius.circular(3.0),
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
              width: 3,
            ),
          if (loss != 0)
            SizedBox(
              height: 18,
              width: 18,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: LichessColors.red,
                  borderRadius: BorderRadius.circular(3.0),
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
    );
  }
}
