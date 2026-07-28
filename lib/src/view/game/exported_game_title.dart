import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/utils/duration.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/clock.dart';
import 'package:lichess_mobile/src/widgets/misc.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';

/// App bar title for a standalone game (an existing/archived game), derived from
/// its [GameMeta].
///
/// Shows the game's speed/variant icon, the time control and rated/casual mode,
/// and optionally the date of the last move. Used both by the game screen and
/// the analysis screen so their app bar titles stay consistent.
class ExportedGameTitle extends StatelessWidget {
  const ExportedGameTitle({
    required this.meta,
    this.lastMoveAt,
    this.isImport = false,
    this.importDate,
    super.key,
  });

  final GameMeta meta;

  /// The date of the last move played in the game. When set, the title shows the
  /// relative date and a tooltip with the full date.
  final DateTime? lastMoveAt;

  /// Whether the game was imported on lichess, and thus not played on the site.
  final bool isImport;

  /// The raw PGN date of an imported game, shown in place of [lastMoveAt], which is the date of
  /// the import itself.
  final String? importDate;

  static final _tooltipFormatter = DateFormat.yMMMMd().add_jm();

  @override
  Widget build(BuildContext context) {
    if (meta.tournament?.isOngoing == true) {
      return _TournamentGameTitle(meta.tournament!);
    }

    final title = meta.clock != null
        ? TimeIncrement(meta.clock!.initial.inSeconds, meta.clock!.increment.inSeconds).display
        : meta.daysPerTurn != null
        ? context.l10n.nbDays(meta.daysPerTurn!)
        : meta.perf.label(context.l10n);

    final mode = meta.rated ? ' • ${context.l10n.rated}' : ' • ${context.l10n.casual}';

    // An imported game was not played on lichess: the time control and the rated status are
    // meaningless, so only show that it is an import, and the date of the game if we have it.
    final subtitle = isImport && importDate != null
        ? formatPgnDate(importDate!, shortDate: false)
        : lastMoveAt != null
        ? relativeDate(context.l10n, lastMoveAt!, shortDate: false)
        : null;

    final titleRow = Row(
      mainAxisSize: .min,
      children: [
        Icon(
          isImport ? Icons.cloud_upload_outlined : meta.perf.icon,
          color: DefaultTextStyle.of(context).style.color,
        ),
        const SizedBox(width: 8.0),
        Flexible(
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .start,
            children: [
              AppBarTitleText(isImport ? 'IMPORT' : '$title$mode', maxLines: 1, maxFontSize: 18.0),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ],
    );

    return lastMoveAt != null
        ? Tooltip(message: _tooltipFormatter.format(lastMoveAt!), child: titleRow)
        : titleRow;
  }
}

/// Shimmer placeholder shown in the app bar while the game data backing a
/// [ExportedGameTitle] is still loading.
class ExportedGameTitleLoading extends StatelessWidget {
  const ExportedGameTitleLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ShimmerLoading(
        isLoading: true,
        child: SizedBox(
          height: 34.0,
          width: 150.0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }
}

class _TournamentGameTitle extends StatelessWidget {
  const _TournamentGameTitle(this.tournament);

  final TournamentMeta tournament;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: .min,
      children: [
        Flexible(child: AppBarTitleText(tournament.name)),
        const SizedBox(width: 4.0),
        CountdownClockBuilder(
          timeLeft: tournament.clock.timeLeft,
          clockUpdatedAt: tournament.clock.at,
          active: true,
          tickInterval: const Duration(seconds: 1),
          builder: (BuildContext context, Duration timeLeft) => Center(
            child: Text(
              '${timeLeft.toHoursMinutesSeconds()} ',
              style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
            ),
          ),
        ),
      ],
    );
  }
}
