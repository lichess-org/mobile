import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/game/archived_game.dart';
import 'package:lichess_mobile/src/model/game/game_share_service.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/game/status_l10n.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/board_thumbnail.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';

/// A list tile that shows game info.
class GameListTile extends StatelessWidget {
  const GameListTile({
    required this.game,
    required this.mySide,
    required this.playerTitle,
    this.icon,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final LightArchivedGame game;
  final Side mySide;

  final IconData? icon;
  final Widget playerTitle;
  final Widget? subtitle;
  final Widget? trailing;
  final GestureTapCallback? onTap;

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
            playerTitle: playerTitle,
            icon: icon,
            subtitle: subtitle,
            trailing: trailing,
          ),
        );
      },
      leading: icon != null
          ? Icon(
              icon,
              size: Theme.of(context).platform == TargetPlatform.iOS
                  ? 26.0
                  : 36.0,
            )
          : null,
      title: playerTitle,
      subtitle: subtitle != null
          ? DefaultTextStyle.merge(
              child: subtitle!,
              style: TextStyle(
                color: textShade(context, Styles.subtitleOpacity),
              ),
            )
          : null,
      trailing: trailing,
    );
  }
}

class _ContextMenu extends ConsumerWidget {
  const _ContextMenu({
    required this.game,
    required this.mySide,
    required this.playerTitle,
    this.icon,
    this.subtitle,
    this.trailing,
  });

  final LightArchivedGame game;
  final Side mySide;

  final IconData? icon;
  final Widget playerTitle;
  final Widget? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = mySide;

    final customColors = Theme.of(context).extension<CustomColors>();

    final actions = [
      BottomSheetContextMenuAction(
        icon: Icons.biotech,
        onPressed: () {
          pushPlatformRoute(
            context,
            builder: (context) => AnalysisScreen(
              title: context.l10n.gameAnalysis,
              pgnOrId: game.id.value,
              options: AnalysisOptions(
                isLocalEvaluationAllowed: true,
                variant: game.variant,
                orientation: orientation,
                id: game.id,
              ),
            ),
          );
        },
        child: Text(context.l10n.gameAnalysis),
      ),
      BottomSheetContextMenuAction(
        onPressed: () {
          launchShareDialog(
            context,
            uri: Uri.parse('$kLichessHost/${game.id}'),
          );
        },
        icon: CupertinoIcons.link,
        closeOnPressed: false,
        child: const Text('Share game URL'),
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
      if (game.lastFen != null && game.lastMove != null)
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
                        game.lastMove!,
                      );
                  if (context.mounted) {
                    launchShareDialog(
                      context,
                      files: [image],
                      subject: context.l10n.puzzleFromGameLink(
                        '$kLichessHost/${game.id}',
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
            icon: CupertinoIcons.share,
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
            icon: CupertinoIcons.share,
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
    ];

    return DraggableScrollableSheet(
      initialChildSize: .5,
      expand: false,
      snap: true,
      snapSizes: const [.5, .7],
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                              orientation: mySide.cg,
                              lastMove: game.lastMove?.cg,
                            ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        context.l10n.resVsX(
                                          game.white.fullName(context),
                                          game.black.fullName(context),
                                        ),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 2.0),
                                      Text(
                                        '${game.clockDisplay} • ${game.rated ? context.l10n.rated : context.l10n.casual}',
                                        style: TextStyle(
                                          color: textShade(
                                            context,
                                            Styles.subtitleOpacity,
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
              ...actions,
            ],
          ),
        ),
      ),
    );
  }
}
