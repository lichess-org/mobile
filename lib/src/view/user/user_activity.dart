import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/icon_extensions.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/account/rating_pref_aware.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_history_screen.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/rating.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:material_ui/material_ui.dart';

DateFormat get _dateFormatter => DateFormat.yMMMd();

class const UserActivityWidget({
  required final AsyncValue<IList<UserActivity>> activity,
  required final LightUser user,
  super.key,
}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return activity.when(
      data: (data) {
        final nonEmptyActivities = data.where((entry) => entry.isNotEmpty);
        if (nonEmptyActivities.isEmpty) {
          return const SizedBox.shrink();
        }
        return ListSection(
          header: Text(context.l10n.activityActivity, style: Styles.sectionTitle),
          hasLeading: true,
          children: nonEmptyActivities
              .take(10)
              .map((entry) => UserActivityEntry(entry: entry, user: user))
              .toList(),
        );
      },
      error: (error, stackTrace) {
        debugPrint('SEVERE: [UserScreen] could not load user activity; $error\n$stackTrace');
        return const Text('Could not load user activity');
      },
      loading: () => Shimmer(
        child: ShimmerLoading(
          isLoading: true,
          child: ListSection.loading(itemsNumber: 10, header: true, hasLeading: true),
        ),
      ),
    );
  }
}

class const UserActivityEntry({
  required final UserActivity entry,
  required final LightUser user,
  super.key,
}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final emptySubtitle = theme.platform == TargetPlatform.iOS ? const SizedBox.shrink() : null;

    final redColor = context.lichessColors.red;
    final greenColor = context.lichessColors.green;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 14.0, top: 16.0, right: 14.0, bottom: 4.0),
          child: Text(
            _dateFormatter.format(entry.startTime),
            style: TextStyle(color: textShade(context, 0.7)),
          ),
        ),
        if (entry.games != null)
          for (final gameEntry in entry.games!.entries)
            _UserActivityListTile(
              icon: gameEntry.key.icon,
              title: context.l10n.activityPlayedNbGames(
                gameEntry.value.win + gameEntry.value.draw + gameEntry.value.loss,
                gameEntry.key.label(context.l10n),
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
                        color: gameEntry.value.ratingAfter - gameEntry.value.ratingBefore > 0
                            ? greenColor
                            : redColor,
                        size: 12,
                      ),
                      Text(
                        (gameEntry.value.ratingAfter - gameEntry.value.ratingBefore)
                            .abs()
                            .toString(),
                        style: TextStyle(
                          color: gameEntry.value.ratingAfter - gameEntry.value.ratingBefore > 0
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
            icon: Perf.puzzle.icon,
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
                      color: entry.puzzles!.ratingAfter - entry.puzzles!.ratingBefore > 0
                          ? greenColor
                          : redColor,
                      size: 12,
                    ),
                    Text(
                      (entry.puzzles!.ratingAfter - entry.puzzles!.ratingBefore).abs().toString(),
                      style: TextStyle(
                        color: entry.puzzles!.ratingAfter - entry.puzzles!.ratingBefore > 0
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
            onTap: () => Navigator.of(context).push(PuzzleHistoryScreen.buildRoute()),
          ),
        if (entry.streak != null)
          _UserActivityListTile(
            icon: Perf.streak.icon,
            title: context.l10n.stormPlayedNbRunsOfPuzzleStorm(entry.streak!.runs, 'Puzzle Streak'),
            subtitle: emptySubtitle,
            trailing: BriefGameResultBox(win: entry.streak!.score, draw: 0, loss: 0),
          ),
        if (entry.storm != null)
          _UserActivityListTile(
            icon: Perf.storm.icon,
            title: context.l10n.stormPlayedNbRunsOfPuzzleStorm(entry.storm!.runs, 'Puzzle Storm'),
            subtitle: emptySubtitle,
            trailing: BriefGameResultBox(win: entry.storm!.score, draw: 0, loss: 0),
          ),
        if (entry.correspondenceEnds != null)
          for (final corresEndEntry in entry.correspondenceEnds!.entries)
            _UserActivityListTile(
              icon: corresEndEntry.key.icon,
              title: corresEndEntry.key == Perf.correspondence
                  ? context.l10n.activityCompletedNbGames(
                      corresEndEntry.value.win +
                          corresEndEntry.value.draw +
                          corresEndEntry.value.loss,
                    )
                  : context.l10n.activityCompletedNbVariantGames(
                      corresEndEntry.value.win +
                          corresEndEntry.value.draw +
                          corresEndEntry.value.loss,
                      corresEndEntry.key.label(context.l10n),
                    ),
              subtitle: emptySubtitle,
              trailing: BriefGameResultBox(
                win: corresEndEntry.value.win,
                draw: corresEndEntry.value.draw,
                loss: corresEndEntry.value.loss,
              ),
            ),
        if (entry.correspondenceMovesNb != null && entry.correspondenceGamesNb != null)
          _UserActivityListTile(
            icon: Perf.correspondence.icon,
            title: context.l10n.activityPlayedNbMoves(entry.correspondenceMovesNb!),
            subtitle: Text(
              context.l10n.activityInNbCorrespondenceGames(entry.correspondenceGamesNb!),
            ),
          ),
        if (entry.tournamentNb != null)
          _UserActivityListTile(
            icon: Icons.emoji_events,
            title: context.l10n.activityCompetedInNbTournaments(entry.tournamentNb!),
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
          _UserActivityListTile(
            icon: Icons.thumb_up,
            title: context.l10n.activityGainedNbFollowers(entry.followInNb!),
            subtitle: emptySubtitle,
          ),
      ],
    );
  }
}

const _leadingIconSize = 26.0;

/// The opacity of the timeline lines, lower than the perf icons so they stand out less.
const _timelineOpacity = 0.5;

/// An activity list tile, with a timeline line drawn above and below its leading icon, which joins
/// the lines of the tiles above and below.
class const _UserActivityListTile({
  required final IconData icon,
  required final String title,
  final Widget? subtitle,
  final Widget? trailing,
  final VoidCallback? onTap,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context);
    // The color of the perf icons, as in the perf cards and the game list.
    final color = perfIconColor(context);
    final contentPadding =
        ListTileTheme.of(context).contentPadding?.resolve(textDirection) ??
        const EdgeInsets.symmetric(horizontal: 16.0);
    return CustomPaint(
      painter: _TimelinePainter(
        color: textShade(context, _timelineOpacity) ?? color,
        lineStart: textDirection == .ltr ? contentPadding.left + _leadingIconSize / 2 : null,
        lineEnd: textDirection == .rtl ? contentPadding.right + _leadingIconSize / 2 : null,
      ),
      child: ListTile(
        leading: Icon(icon, size: _leadingIconSize, color: color),
        title: Text(title, maxLines: 2),
        subtitle: subtitle,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}

/// Paints a vertical line through the tile, interrupted around its vertically centered leading
/// icon. The line is at [lineStart] from the left edge, or at [lineEnd] from the right edge.
class const _TimelinePainter({
  required final Color color,
  final double? lineStart,
  final double? lineEnd,
}) extends CustomPainter {
  static const _lineWidth = 2.0;
  static const _iconGap = 4.0;

  @override
  void paint(Canvas canvas, Size size) {
    final x = lineStart ?? size.width - lineEnd!;
    final paint = Paint()
      ..color = color
      ..strokeWidth = _lineWidth;
    const iconHalfExtent = _leadingIconSize / 2 + _iconGap;
    final centerY = size.height / 2;
    canvas.drawLine(Offset(x, 0), Offset(x, centerY - iconHalfExtent), paint);
    canvas.drawLine(Offset(x, centerY + iconHalfExtent), Offset(x, size.height), paint);
  }

  @override
  bool shouldRepaint(_TimelinePainter oldDelegate) =>
      color != oldDelegate.color ||
      lineStart != oldDelegate.lineStart ||
      lineEnd != oldDelegate.lineEnd;
}

const _boxSize = 20.0;
const _spaceWidth = 3.0;

const _gameStatsFontStyle = TextStyle(fontSize: 11, fontWeight: FontWeight.bold);

class const _ResultBox({required final int number, required final Color color})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: _boxSize,
      width: _boxSize,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.35),
        borderRadius: const BorderRadius.all(Radius.circular(3.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text(number.toString(), style: _gameStatsFontStyle.copyWith(color: color)),
        ),
      ),
    );
  }
}

class const BriefGameResultBox({
  required final int win,
  required final int draw,
  required final int loss,
}) extends StatelessWidget {
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
            if (win != 0) _ResultBox(number: win, color: context.lichessColors.green),
            if (win != 0 && draw != 0) const SizedBox(width: _spaceWidth),
            if (draw != 0) _ResultBox(number: draw, color: Colors.grey),
            if ((draw != 0 && loss != 0) || (win != 0 && loss != 0))
              const SizedBox(width: _spaceWidth),
            if (loss != 0) _ResultBox(number: loss, color: context.lichessColors.red),
          ],
        ),
      ),
    );
  }
}
