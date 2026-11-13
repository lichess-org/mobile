import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
import 'package:lichess_mobile/src/model/game/exported_game.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/service/game_share_service.dart';
import 'package:lichess_mobile/src/styles/icon_extensions.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/game/game_common_widgets.dart';
import 'package:lichess_mobile/src/view/game/gif_export.dart';
import 'package:lichess_mobile/src/view/game/gif_export_dialog.dart';
import 'package:lichess_mobile/src/view/game/status_l10n.dart';
import 'package:lichess_mobile/src/view/tournament/tournament_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/board_thumbnail.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/user.dart';
import 'package:material_ui/material_ui.dart';
import 'package:share_plus/share_plus.dart';

DateFormat get _dateFormatter => DateFormat.yMMMd();

/// A list tile for a game in a game list.
class const GameListTile({
  required final LightExportedGameWithPov item,
  final EdgeInsetsGeometry? padding,
  final Future<void> Function(BuildContext context)? onPressedBookmark,

  /// Whether to show only the time of day the game started instead of its date, in a list grouped
  /// by day.
  final bool timeOnly = false,
}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (:game, pov: youAre) = item;
    final me = youAre == Side.white ? game.white : game.black;
    final opponent = youAre == Side.white ? game.black : game.white;

    // An imported game is not tied to a lichess account: the point of view is arbitrary, so show
    // both players and no result.
    final title = game.isImported
        ? Text(
            context.l10n.resVsX(
              game.white.fullName(context.l10n),
              game.black.fullName(context.l10n),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        : UserFullNameWidget.player(
            user: opponent.user,
            name: opponent.name,
            aiLevel: opponent.aiLevel,
            rating: opponent.rating,
            provisional: opponent.provisional,
          );

    // Like the website, show when the game started. For an imported game that's the import date, so
    // prefer the PGN date if we have it.
    final date = game.importDate != null
        ? formatPgnDate(game.importDate!, shortDate: false)
        : timeOnly
        ? formatTimeOfDay(context, game.createdAt)
        : relativeDate(context.l10n, game.createdAt, shortDate: false);

    final showRatings = switch (ref.watch(showRatingsPrefProvider)) {
      AsyncData(:final value) => value != ShowRatings.no,
      _ => false,
    };
    final ratingDiff = showRatings ? me.ratingDiff : null;

    final isTournament = game.arenaTournamentId != null;

    final isAborted = game.status == GameStatus.aborted || game.status == GameStatus.noStart;
    final resultColor = isAborted
        ? LichessColors.grey
        : game.winner == null
        ? textShade(context, Styles.subtitleOpacity)
        : game.winner == youAre
        ? context.lichessColors.green
        : context.lichessColors.red;

    // The rating change when there is one, else a symbol of the result.
    final result = ratingDiff != null && !isAborted
        ? ratingDiff > 0
              ? '+$ratingDiff'
              : ratingDiff == 0
              ? '±0'
              : '$ratingDiff'
        : isAborted
        ? '✕'
        : game.winner == null
        ? '½'
        : game.winner == youAre
        ? '▲'
        : '▼';

    return ListTile(
      onTap: () => openGameScreen(
        context,
        game: item.game,
        orientation: item.pov,
        loadingFen: game.lastFen,
        loadingLastMove: game.lastMove,
        lastMoveAt: game.lastMoveAt,
      ),
      onLongPress: () {
        showAdaptiveBottomSheet<void>(
          context: context,
          useRootNavigator: true,
          isScrollControlled: true,
          builder: (context) =>
              GameContextMenu(game: game, mySide: youAre, onPressedBookmark: onPressedBookmark),
        );
      },
      leading: Icon(
        game.isImported
            ? Icons.cloud_upload_outlined
            : isTournament
            ? LichessIcons.tournament_cup
            : game.perf.icon,
        color: perfIconColor(context),
      ),
      title: title,
      subtitle: Text.rich(
        TextSpan(
          children: [
            // The leading icon shows the tournament, so show the speed next to the date.
            if (isTournament) ...[
              WidgetSpan(
                alignment: .middle,
                child: Icon(
                  game.perf.icon,
                  size: 14,
                  color: textShade(context, Styles.subtitleOpacity),
                ),
              ),
              const TextSpan(text: ' '),
            ],
            TextSpan(text: date),
            if (!game.isImported) ...[
              const TextSpan(text: '  '),
              TextSpan(
                text: result,
                style: TextStyle(color: resultColor, fontWeight: FontWeight.w600),
              ),
            ],
          ],
        ),
      ),
      trailing: me.analysis != null
          ? Icon(CupertinoIcons.chart_bar_alt_fill, color: textShade(context, 0.3))
          : null,
    );
  }
}

class const GameContextMenu({
  required final LightExportedGame game,
  required final Side mySide,
  required final Future<void> Function(BuildContext context)? onPressedBookmark,
}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = mySide;

    final isLoggedIn = ref.watch(isLoggedInProvider);

    return BottomSheetScrollableContainer(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0)
              .add(const EdgeInsets.only(bottom: 4.0)),
          child: Text(
            context.l10n.resVsX(
              game.white.fullName(context.l10n),
              game.black.fullName(context.l10n),
            ),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -0.5),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return IntrinsicHeight(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if (game.lastFen != null)
                      BoardThumbnail(
                        size: constraints.maxWidth - (constraints.maxWidth / 1.618),
                        fen: game.lastFen!,
                        orientation: mySide,
                        lastMove: game.lastMove,
                      ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${game.clockDisplay(context.l10n)} • ${game.rated ? context.l10n.rated : context.l10n.casual}',
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  '${_dateFormatter.format(game.createdAt)} ${formatTimeOfDay(context, game.createdAt)}',
                                  style: TextStyle(
                                    color: textShade(context, Styles.subtitleOpacity),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            if (game.arenaTournamentId != null)
                              Row(
                                children: [
                                  Icon(
                                    LichessIcons.tournament_cup,
                                    size: 13,
                                    color: textShade(context, Styles.subtitleOpacity),
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      game.arenaTournamentName ?? context.l10n.tournament,
                                      maxLines: 2,
                                      overflow: .ellipsis,
                                      style: TextStyle(
                                        color: textShade(context, Styles.subtitleOpacity),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (game.lastFen != null)
                              Text(
                                gameStatusL10n(
                                  context,
                                  variant: game.variant,
                                  status: game.status,
                                  lastPosition: Position.setupPosition(
                                    game.variant.rule,
                                    Setup.parseFen(game.lastFen!),
                                  ),
                                  winner: game.winner,
                                ),
                                style: TextStyle(
                                  color: game.winner == null
                                      ? textShade(context, Styles.subtitleOpacity)
                                      : game.winner == mySide
                                      ? context.lichessColors.green
                                      : context.lichessColors.red,
                                ),
                              ),
                            if (game.opening != null)
                              Text(
                                game.opening!.name,
                                maxLines: 2,
                                style: TextStyle(
                                  color: textShade(context, Styles.subtitleOpacity),
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        ListSection(
          children: [
            BottomSheetContextMenuAction(
              icon: Icons.biotech,
              onPressed: game.variant.isReadSupported
                  ? () {
                      Navigator.of(context).push(
                        AnalysisScreen.buildRoute(
                          AnalysisOptions.archivedGame(orientation: orientation, gameId: game.id),
                        ),
                      );
                    }
                  : () {
                      showSnackBar(
                        context,
                        'This variant is not supported yet.',
                        type: SnackBarType.info,
                      );
                    },
              child: Text(context.l10n.analysis),
            ),
            if (game.arenaTournamentId != null)
              BottomSheetContextMenuAction(
                icon: LichessIcons.tournament_cup,
                onPressed: () {
                  Navigator.of(context).push(TournamentScreen.buildRoute(game.arenaTournamentId!));
                },
                child: Text(context.l10n.viewTournament),
              ),
            if (isLoggedIn && onPressedBookmark != null)
              BottomSheetContextMenuAction(
                onPressed: () => onPressedBookmark?.call(context),
                icon: game.isBookmarked
                    ? Icons.bookmark_remove_outlined
                    : Icons.bookmark_add_outlined,
                closeOnPressed: true,
                child: Text(
                  game.isBookmarked
                      ? context.l10n.mobileRemoveBookmark
                      : context.l10n.bookmarkThisGame,
                ),
              ),
            if (!isTabletOrLarger(context)) ...[
              BottomSheetContextMenuAction(
                onPressed: () {
                  launchShareDialog(
                    context,
                    ShareParams(uri: lichessGameUri(game.id, orientation: orientation)),
                  );
                },
                icon: Theme.of(context).platform == TargetPlatform.iOS
                    ? Icons.ios_share
                    : Icons.share,
                child: Text(context.l10n.mobileShareGameURL),
              ),
              BottomSheetContextMenuAction(
                icon: Icons.gif,
                child: Text(context.l10n.gameAsGIF),
                onPressed: () {
                  showAdaptiveBottomSheet<GifExportOptions>(
                    context: context,
                    builder: (_) => GifExport(gameId: game.id, orientation: orientation),
                  );
                },
              ),
              BottomSheetContextMenuAction(
                icon: Icons.text_snippet,
                child: Text('PGN: ${context.l10n.downloadAnnotated}'),
                onPressed: () async {
                  try {
                    final pgn = await ref.read(gameShareServiceProvider).annotatedPgn(game.id);
                    if (context.mounted) {
                      launchShareDialog(context, ShareParams(text: pgn));
                    }
                  } catch (e) {
                    if (context.mounted) {
                      showSnackBar(context, 'Failed to get PGN', type: SnackBarType.error);
                    }
                  }
                },
              ),
              BottomSheetContextMenuAction(
                icon: Icons.text_snippet,
                // TODO improve translation
                child: Text('PGN: ${context.l10n.downloadRaw}'),
                onPressed: () async {
                  try {
                    final pgn = await ref.read(gameShareServiceProvider).rawPgn(game.id);
                    if (context.mounted) {
                      launchShareDialog(context, ShareParams(text: pgn));
                    }
                  } catch (e) {
                    if (context.mounted) {
                      showSnackBar(context, 'Failed to get PGN', type: SnackBarType.error);
                    }
                  }
                },
              ),
            ],
          ],
        ),
      ],
    );
  }
}
