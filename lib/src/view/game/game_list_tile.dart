import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/archived_game.dart';
import 'package:lichess_mobile/src/model/game/game_share_service.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/game/archived_game_screen.dart';
import 'package:lichess_mobile/src/view/game/game_screen.dart';
import 'package:lichess_mobile/src/view/game/status_l10n.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/board_thumbnail.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';
import 'package:timeago/timeago.dart' as timeago;

final _dateFormatter = DateFormat.yMMMd().add_Hm();

/// A list tile that shows game info.
class GameListTile extends StatelessWidget {
  const GameListTile({
    required this.game,
    required this.mySide,
    required this.opponentTitle,
    this.icon,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.padding,
  });

  final LightArchivedGame game;
  final Side mySide;

  final IconData? icon;
  final Widget opponentTitle;
  final Widget? subtitle;
  final Widget? trailing;
  final GestureTapCallback? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return PlatformListTile(
      onTap: onTap,
      onLongPress: () {
        showAdaptiveBottomSheet<void>(
          context: context,
          useRootNavigator: true,
          isDismissible: true,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (context) => _ContextMenu(
            game: game,
            mySide: mySide,
            oppponentTitle: opponentTitle,
            icon: icon,
            subtitle: subtitle,
            trailing: trailing,
          ),
        );
      },
      leading: icon != null ? Icon(icon) : null,
      title: opponentTitle,
      subtitle: subtitle != null
          ? DefaultTextStyle.merge(
              child: subtitle!,
              style: TextStyle(
                color: textShade(context, Styles.subtitleOpacity),
              ),
            )
          : null,
      trailing: trailing,
      padding: padding,
    );
  }
}

class _ContextMenu extends ConsumerWidget {
  const _ContextMenu({
    required this.game,
    required this.mySide,
    required this.oppponentTitle,
    this.icon,
    this.subtitle,
    this.trailing,
  });

  final LightArchivedGame game;
  final Side mySide;

  final IconData? icon;
  final Widget oppponentTitle;
  final Widget? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = mySide;

    final customColors = Theme.of(context).extension<CustomColors>();

    return BottomSheetScrollableContainer(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0).add(
            const EdgeInsets.only(bottom: 8.0),
          ),
          child: Text(
            context.l10n.resVsX(
              game.white.fullName(context),
              game.black.fullName(context),
            ),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0).add(
            const EdgeInsets.only(bottom: 8.0),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return IntrinsicHeight(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if (game.lastFen != null)
                      BoardThumbnail(
                        size: constraints.maxWidth -
                            (constraints.maxWidth / 1.618),
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
                                  '${game.clockDisplay} • ${game.rated ? context.l10n.rated : context.l10n.casual}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  _dateFormatter.format(game.lastMoveAt),
                                  style: TextStyle(
                                    color: textShade(
                                      context,
                                      Styles.subtitleOpacity,
                                    ),
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
                                      ? customColors?.brag
                                      : game.winner == mySide
                                          ? customColors?.good
                                          : customColors?.error,
                                ),
                              ),
                            if (game.opening != null)
                              Text(
                                game.opening!.name,
                                maxLines: 2,
                                style: TextStyle(
                                  color: textShade(
                                    context,
                                    Styles.subtitleOpacity,
                                  ),
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
        BottomSheetContextMenuAction(
          icon: Icons.biotech,
          onPressed: game.variant.isReadSupported
              ? () {
                  pushPlatformRoute(
                    context,
                    builder: (context) => AnalysisScreen(
                      options: AnalysisOptions(
                        orientation: orientation,
                        gameId: game.id,
                      ),
                    ),
                  );
                }
              : () {
                  showPlatformSnackbar(
                    context,
                    'This variant is not supported yet.',
                    type: SnackBarType.info,
                  );
                },
          child: Text(context.l10n.gameAnalysis),
        ),
        BottomSheetContextMenuAction(
          onPressed: () {
            launchShareDialog(
              context,
              uri: lichessUri('/${game.id}'),
            );
          },
          icon: CupertinoIcons.link,
          closeOnPressed: false,
          child: Text(context.l10n.mobileShareGameURL),
        ),
        // Builder is used to retrieve the context immediately surrounding the
        // BottomSheetContextMenuAction
        // This is necessary to get the correct context for the iPad share dialog
        // which needs the position of the action to display the share dialog
        Builder(
          builder: (context) {
            return BottomSheetContextMenuAction(
              icon: Icons.gif,
              closeOnPressed: false, // needed for the share dialog on iPad
              child: Text(context.l10n.gameAsGIF),
              onPressed: () async {
                try {
                  final gif = await ref
                      .read(gameShareServiceProvider)
                      .gameGif(game.id, orientation);
                  if (context.mounted) {
                    launchShareDialog(
                      context,
                      files: [gif],
                      subject: '${game.perf.title} • ${context.l10n.resVsX(
                        game.white.fullName(context),
                        game.black.fullName(context),
                      )}',
                    );
                  }
                } catch (e) {
                  debugPrint(e.toString());
                  if (context.mounted) {
                    showPlatformSnackbar(
                      context,
                      'Failed to get GIF',
                      type: SnackBarType.error,
                    );
                  }
                }
              },
            );
          },
        ),
        if (game.lastFen != null)
          // Builder is used to retrieve the context immediately surrounding the
          // BottomSheetContextMenuAction
          // This is necessary to get the correct context for the iPad share dialog
          // which needs the position of the action to display the share dialog
          Builder(
            builder: (context) {
              return BottomSheetContextMenuAction(
                icon: Icons.image,
                closeOnPressed: false, // needed for the share dialog on iPad
                child: Text(context.l10n.screenshotCurrentPosition),
                onPressed: () async {
                  try {
                    final image = await ref
                        .read(gameShareServiceProvider)
                        .screenshotPosition(
                          game.id,
                          orientation,
                          game.lastFen!,
                          game.lastMove,
                        );
                    if (context.mounted) {
                      launchShareDialog(
                        context,
                        files: [image],
                        subject: context.l10n.puzzleFromGameLink(
                          lichessUri('/${game.id}').toString(),
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      showPlatformSnackbar(
                        context,
                        'Failed to get GIF',
                        type: SnackBarType.error,
                      );
                    }
                  }
                },
              );
            },
          ),
        // Builder is used to retrieve the context immediately surrounding the
        // BottomSheetContextMenuAction
        // This is necessary to get the correct context for the iPad share dialog
        // which needs the position of the action to display the share dialog
        Builder(
          builder: (context) {
            return BottomSheetContextMenuAction(
              icon: Icons.text_snippet,
              closeOnPressed: false, // needed for the share dialog on iPad
              child: Text('PGN: ${context.l10n.downloadAnnotated}'),
              onPressed: () async {
                try {
                  final pgn = await ref
                      .read(gameShareServiceProvider)
                      .annotatedPgn(game.id);
                  if (context.mounted) {
                    launchShareDialog(
                      context,
                      text: pgn,
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    showPlatformSnackbar(
                      context,
                      'Failed to get PGN',
                      type: SnackBarType.error,
                    );
                  }
                }
              },
            );
          },
        ),
        // Builder is used to retrieve the context immediately surrounding the
        // BottomSheetContextMenuAction
        // This is necessary to get the correct context for the iPad share dialog
        // which needs the position of the action to display the share dialog
        Builder(
          builder: (context) {
            return BottomSheetContextMenuAction(
              icon: Icons.text_snippet,
              closeOnPressed: false, // needed for the share dialog on iPad
              // TODO improve translation
              child: Text('PGN: ${context.l10n.downloadRaw}'),
              onPressed: () async {
                try {
                  final pgn =
                      await ref.read(gameShareServiceProvider).rawPgn(game.id);
                  if (context.mounted) {
                    launchShareDialog(
                      context,
                      text: pgn,
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    showPlatformSnackbar(
                      context,
                      'Failed to get PGN',
                      type: SnackBarType.error,
                    );
                  }
                }
              },
            );
          },
        ),
      ],
    );
  }
}

/// A list tile that shows extended game info including a result icon and analysis icon.
class ExtendedGameListTile extends StatelessWidget {
  const ExtendedGameListTile({
    required this.item,
    this.userId,
    this.padding,
  });

  final LightArchivedGameWithPov item;
  final UserId? userId;

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final (game: game, pov: youAre) = item;
    final me = youAre == Side.white ? game.white : game.black;
    final opponent = youAre == Side.white ? game.black : game.white;

    Widget getResultIcon(LightArchivedGame game, Side mySide) {
      if (game.status == GameStatus.aborted ||
          game.status == GameStatus.noStart) {
        return const Icon(
          CupertinoIcons.xmark_square_fill,
          color: LichessColors.grey,
        );
      } else {
        return game.winner == null
            ? Icon(
                CupertinoIcons.equal_square_fill,
                color: context.lichessColors.brag,
              )
            : game.winner == mySide
                ? Icon(
                    CupertinoIcons.plus_square_fill,
                    color: context.lichessColors.good,
                  )
                : Icon(
                    CupertinoIcons.minus_square_fill,
                    color: context.lichessColors.error,
                  );
      }
    }

    return GameListTile(
      game: game,
      mySide: youAre,
      padding: padding,
      onTap: game.variant.isReadSupported
          ? () {
              pushPlatformRoute(
                context,
                rootNavigator: true,
                builder: (context) => game.fullId != null
                    ? GameScreen(
                        initialGameId: game.fullId,
                        loadingFen: game.lastFen,
                        loadingLastMove: game.lastMove,
                        loadingOrientation: youAre,
                        lastMoveAt: game.lastMoveAt,
                      )
                    : ArchivedGameScreen(
                        gameData: game,
                        orientation: youAre,
                      ),
              );
            }
          : () {
              showPlatformSnackbar(
                context,
                'This variant is not supported yet.',
                type: SnackBarType.info,
              );
            },
      icon: game.perf.icon,
      opponentTitle: UserFullNameWidget.player(
        user: opponent.user,
        aiLevel: opponent.aiLevel,
        rating: opponent.rating,
      ),
      subtitle: Text(timeago.format(game.lastMoveAt)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (me.analysis != null) ...[
            Icon(
              CupertinoIcons.chart_bar_alt_fill,
              color: textShade(context, 0.5),
            ),
            const SizedBox(width: 5),
          ],
          getResultIcon(game, youAre),
        ],
      ),
    );
  }
}
