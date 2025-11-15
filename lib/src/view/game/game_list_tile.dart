import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/game/exported_game.dart';
import 'package:lichess_mobile/src/model/game/game_share_service.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/game/game_common_widgets.dart';
import 'package:lichess_mobile/src/view/game/status_l10n.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/board_thumbnail.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/user.dart';
import 'package:share_plus/share_plus.dart';

final _dateFormatter = DateFormat.yMMMd().add_Hm();

/// A list tile for a game in a game list.
class GameListTile extends StatelessWidget {
  const GameListTile({required this.item, this.padding, this.onPressedBookmark});

  final LightExportedGameWithPov item;
  final EdgeInsetsGeometry? padding;
  final Future<void> Function(BuildContext context)? onPressedBookmark;

  @override
  Widget build(BuildContext context) {
    final (game: game, pov: youAre) = item;
    final me = youAre == Side.white ? game.white : game.black;
    final opponent = youAre == Side.white ? game.black : game.white;

    Widget getResultIcon(LightExportedGame game, Side mySide) {
      if (game.status == GameStatus.aborted || game.status == GameStatus.noStart) {
        return const Icon(CupertinoIcons.xmark_square_fill, color: LichessColors.grey);
      } else {
        return game.winner == null
            ? Icon(CupertinoIcons.equal_square_fill, color: context.lichessColors.brag)
            : game.winner == mySide
            ? Icon(CupertinoIcons.plus_square_fill, color: context.lichessColors.good)
            : Icon(CupertinoIcons.minus_square_fill, color: context.lichessColors.error);
      }
    }

    final opponentTitle = UserFullNameWidget.player(
      user: opponent.user,
      aiLevel: opponent.aiLevel,
      rating: opponent.rating,
    );

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
        showModalBottomSheet<void>(
          context: context,
          useRootNavigator: true,
          isDismissible: true,
          isScrollControlled: true,
          builder: (context) => GameContextMenu(
            game: game,
            mySide: youAre,
            opponentTitle: opponentTitle,
            onPressedBookmark: onPressedBookmark,
          ),
        );
      },
      leading: Icon(game.perf.icon),
      title: opponentTitle,
      subtitle: Text(relativeDate(context.l10n, game.lastMoveAt, shortDate: false)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (me.analysis != null) ...[
            Icon(CupertinoIcons.chart_bar_alt_fill, color: textShade(context, 0.5)),
            const SizedBox(width: 5),
          ],
          getResultIcon(game, youAre),
        ],
      ),
    );
  }
}

class GameContextMenu extends ConsumerWidget {
  const GameContextMenu({
    required this.game,
    required this.mySide,
    required this.opponentTitle,
    required this.onPressedBookmark,
  });

  final LightExportedGame game;
  final Side mySide;
  final Widget opponentTitle;
  final Future<void> Function(BuildContext context)? onPressedBookmark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = mySide;

    final isLoggedIn = ref.watch(isLoggedInProvider);

    return BottomSheetScrollableContainer(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ).add(const EdgeInsets.only(bottom: 4.0)),
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
                                  _dateFormatter.format(game.lastMoveAt),
                                  style: TextStyle(
                                    color: textShade(context, Styles.subtitleOpacity),
                                    fontSize: 12,
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
                                      ? context.lichessColors.brag
                                      : game.winner == mySide
                                      ? context.lichessColors.good
                                      : context.lichessColors.error,
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
                          context,
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
                    ShareParams(uri: lichessUri('/${game.id}/${orientation.name}')),
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
                onPressed: () async {
                  try {
                    final (gif, _) = await ref
                        .read(gameShareServiceProvider)
                        .gameGif(game.id, orientation);
                    if (context.mounted) {
                      launchShareDialog(
                        context,
                        ShareParams(
                          files: [gif],
                          fileNameOverrides: ['${game.id}.gif'],
                          subject:
                              '${game.perf.title} • ${context.l10n.resVsX(game.white.fullName(context.l10n), game.black.fullName(context.l10n))}',
                        ),
                      );
                    }
                  } catch (e) {
                    debugPrint(e.toString());
                    if (context.mounted) {
                      showSnackBar(context, 'Failed to get GIF', type: SnackBarType.error);
                    }
                  }
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
