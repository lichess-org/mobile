import 'dart:convert';

import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/http_client.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_repository_providers.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/game/status_l10n.dart';
import 'package:lichess_mobile/src/widgets/adaptive_context_menu.dart';
import 'package:lichess_mobile/src/widgets/board_thumbnail.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;

/// A list tile that shows game info.
class GameListTile extends ConsumerWidget {
  const GameListTile({
    required this.game,
    required this.mySide,
    required this.playerTitle,
    this.icon,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final ArchivedGameData game;
  final Side mySide;

  final IconData? icon;
  final Widget playerTitle;
  final Widget? subtitle;
  final Widget? trailing;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardTheme = ref.watch(boardPreferencesProvider).boardTheme;
    final pieceTheme = ref.watch(boardPreferencesProvider).pieceSet;
    final orientation = mySide;

    final serverAnalysis =
        game.white.analysis != null && game.black.analysis != null
            ? (white: game.white.analysis!, black: game.black.analysis!)
            : null;

    final expandedWidget = IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (game.lastFen != null)
            BoardThumbnail(
              size: 150,
              fen: game.lastFen!,
              orientation: mySide.cg,
              // lastMove: game.lastMove?.cg,
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PlatformListTile(
                    padding: EdgeInsets.zero,
                    leading: Icon(game.perf.icon),
                    title: Text(
                      '${game.clockDisplay} • ${game.rated ? context.l10n.rated : context.l10n.casual}',
                    ),
                    subtitle: Text(
                      timeago.format(game.lastMoveAt),
                    ),
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
                            ? LichessColors.brag
                            : game.winner == mySide
                                ? LichessColors.good
                                : LichessColors.red,
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

    final actions = [
      Builder(
        builder: (context) {
          Future<void>? pgnFuture;
          return StatefulBuilder(
            builder: (context, setState) {
              return FutureBuilder(
                future: pgnFuture,
                builder: (context, snapshot) {
                  return AdaptiveContextMenuAction(
                    icon: Icons.biotech,
                    onPressed: snapshot.connectionState ==
                            ConnectionState.waiting
                        ? null
                        : () async {
                            Navigator.of(context, rootNavigator: true).pop();
                            final future = ref.read(
                              gameAnalysisPgnProvider(id: game.id).future,
                            );
                            setState(() {
                              pgnFuture = future;
                            });
                            final pgn = await future;
                            if (context.mounted) {
                              pushPlatformRoute(
                                context,
                                builder: (context) => AnalysisScreen(
                                  title: context.l10n.gameAnalysis,
                                  options: AnalysisOptions(
                                    isLocalEvaluationAllowed: true,
                                    variant: game.variant,
                                    pgn: pgn,
                                    orientation: orientation,
                                    id: game.id,
                                    serverAnalysis: serverAnalysis,
                                  ),
                                ),
                              );
                            }
                          },
                    child: Text(context.l10n.gameAnalysis),
                  );
                },
              );
            },
          );
        },
      ),
      AdaptiveContextMenuAction(
        onPressed: () async {
          Navigator.of(context, rootNavigator: true).pop();
          await Clipboard.setData(
            ClipboardData(text: '$kLichessHost/${game.id}'),
          );
        },
        icon: CupertinoIcons.link,
        child: const Text('Copy game URL'),
      ),
      AdaptiveContextMenuAction(
        icon: Icons.gif,
        child: Text(context.l10n.gameAsGIF),
        onPressed: () async {
          Navigator.of(context, rootNavigator: true).pop();
          try {
            final resp = await ref
                .read(httpClientProvider)
                .get(
                  Uri.parse(
                    '$kLichessCDNHost/game/export/gif/${orientation.name}/${game.id}.gif?theme=${boardTheme.name}&piece=${pieceTheme.name}',
                  ),
                )
                .timeout(const Duration(seconds: 1));

            if (resp.statusCode != 200) {
              throw Exception('Failed to get GIF');
            }
            final gif = XFile.fromData(resp.bodyBytes, mimeType: 'image/gif');
            Share.shareXFiles([gif]);
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
      ),
      AdaptiveContextMenuAction(
        icon: CupertinoIcons.share,
        child: Text('PGN: ${context.l10n.downloadAnnotated}'),
        onPressed: () async {
          Navigator.of(context, rootNavigator: true).pop();
          try {
            final resp = await ref
                .read(httpClientProvider)
                .get(
                  Uri.parse(
                    '$kLichessHost/game/export/${game.id}?literate=1',
                  ),
                )
                .timeout(const Duration(seconds: 1));
            if (resp.statusCode != 200) {
              throw Exception('Failed to get PGN');
            }
            Share.share(utf8.decode(resp.bodyBytes));
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
      ),
      AdaptiveContextMenuAction(
        icon: CupertinoIcons.share,
        child: Text('PGN: ${context.l10n.downloadRaw}'),
        onPressed: () async {
          Navigator.of(context, rootNavigator: true).pop();
          try {
            final resp = await ref
                .read(httpClientProvider)
                .get(
                  Uri.parse(
                    '$kLichessHost/game/export/${game.id}?evals=0&clocks=0',
                  ),
                )
                .timeout(const Duration(seconds: 1));
            if (resp.statusCode != 200) {
              throw Exception('Failed to get PGN');
            }
            Share.share(utf8.decode(resp.bodyBytes));
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
      ),
    ];

    final tile = PlatformListTile(
      onTap: onTap,
      onLongPress: () {
        showModalBottomSheet<void>(
          context: context,
          isDismissible: true,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (context) => DraggableScrollableSheet(
            initialChildSize: 0.6,
            maxChildSize: 0.95,
            minChildSize: 0.3,
            expand: false,
            snap: true,
            builder: (context, scrollController) => SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: expandedWidget,
                    ),
                    const Divider(height: 24.0),
                    ...actions,
                  ],
                ),
              ),
            ),
          ),
        );
      },
      leading: icon != null
          ? Icon(
              icon,
              size: defaultTargetPlatform == TargetPlatform.iOS ? 26.0 : 36.0,
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

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return LichessCupertinoContextMenu.builder(
        enableHapticFeedback: true,
        builder: (context, animation) {
          return (animation.value >
                          LichessCupertinoContextMenu.animationOpensAt &&
                      animation.status == AnimationStatus.forward) ||
                  animation.value == 1
              ? SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PlatformCard(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: expandedWidget,
                      ),
                    ],
                  ),
                )
              : animation.value > 0
                  ? SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PlatformCard(
                            margin: EdgeInsets.zero,
                            elevation: 1,
                            child: tile,
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          tile,
                        ],
                      ),
                    );
        },
        actions: actions,
      );
    } else {
      return tile;
    }
  }
}
