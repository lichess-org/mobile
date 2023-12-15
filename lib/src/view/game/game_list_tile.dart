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
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game_repository_providers.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_context_menu.dart';
import 'package:lichess_mobile/src/widgets/board_thumbnail.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:share_plus/share_plus.dart';

/// A list tile that shows game info.
class GameListTile extends ConsumerWidget {
  const GameListTile({
    required this.gameId,
    required this.playerTitle,
    this.variant,
    this.serverAnalysis,
    this.icon,
    this.subtitle,
    this.trailing,
    this.fen,
    this.orientation,
    this.lastMove,
    this.onTap,
  });

  final GameId gameId;
  final Variant? variant;
  final ({PlayerAnalysis white, PlayerAnalysis black})? serverAnalysis;

  final IconData? icon;
  final Widget playerTitle;
  final Widget? subtitle;
  final Widget? trailing;
  final GestureTapCallback? onTap;

  final String? fen;
  final Side? orientation;
  final Move? lastMove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardTheme = ref.watch(boardPreferencesProvider).boardTheme;
    final pieceTheme = ref.watch(boardPreferencesProvider).pieceSet;

    final tile = PlatformListTile(
      onTap: onTap,
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

    return AdaptiveContextMenu.builder(
      enableHapticFeedback: true,
      builder: (context, animation) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (fen != null &&
                animation.value > AdaptiveContextMenu.animationOpensAt)
              BoardThumbnail(
                size: MediaQuery.of(context).size.width - 96.0,
                fen: fen!,
                orientation: (orientation ?? Side.white).cg,
                lastMove: lastMove?.cg,
              ),
            if (animation.value > AdaptiveContextMenu.animationOpensAt)
              PlatformCard(
                margin: const EdgeInsets.symmetric(horizontal: 48.0),
                borderRadius: BorderRadius.zero,
                child: tile,
              )
            else if (animation.value > 0)
              PlatformCard(margin: EdgeInsets.zero, elevation: 1, child: tile)
            else
              tile,
          ],
        );
      },
      actions: [
        if (variant != null)
          Builder(
            builder: (context) {
              Future<void>? pgnFuture;
              return StatefulBuilder(
                builder: (context, setState) {
                  return FutureBuilder(
                    future: pgnFuture,
                    builder: (context, snapshot) {
                      return CupertinoContextMenuAction(
                        trailingIcon: Icons.biotech,
                        onPressed: snapshot.connectionState ==
                                ConnectionState.waiting
                            ? null
                            : () async {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                final future = ref.read(
                                  gameAnalysisPgnProvider(id: gameId).future,
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
                                        variant: variant!,
                                        pgn: pgn,
                                        orientation: orientation ?? Side.white,
                                        id: gameId,
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
        CupertinoContextMenuAction(
          onPressed: () async {
            Navigator.of(context, rootNavigator: true).pop();
            await Clipboard.setData(
              ClipboardData(text: '$kLichessHost/$gameId'),
            );
          },
          trailingIcon: CupertinoIcons.link,
          child: const Text('Copy game URL'),
        ),
        if (orientation != null)
          CupertinoContextMenuAction(
            trailingIcon: Icons.gif,
            child: Text(context.l10n.gameAsGIF),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              try {
                final resp = await ref
                    .read(httpClientProvider)
                    .get(
                      Uri.parse(
                        '$kLichessCDNHost/game/export/gif/${orientation!.name}/$gameId.gif?theme=${boardTheme.name}&piece=${pieceTheme.name}',
                      ),
                    )
                    .timeout(const Duration(seconds: 1));

                if (resp.statusCode != 200) {
                  throw Exception('Failed to get GIF');
                }
                final gif =
                    XFile.fromData(resp.bodyBytes, mimeType: 'image/gif');
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
        CupertinoContextMenuAction(
          trailingIcon: CupertinoIcons.share,
          child: Text('PGN: ${context.l10n.downloadAnnotated}'),
          onPressed: () async {
            Navigator.of(context, rootNavigator: true).pop();
            try {
              final resp = await ref
                  .read(httpClientProvider)
                  .get(
                    Uri.parse(
                      '$kLichessHost/game/export/$gameId?literate=1',
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
        CupertinoContextMenuAction(
          trailingIcon: CupertinoIcons.share,
          child: Text('PGN: ${context.l10n.downloadRaw}'),
          onPressed: () async {
            Navigator.of(context, rootNavigator: true).pop();
            try {
              final resp = await ref
                  .read(httpClientProvider)
                  .get(
                    Uri.parse(
                      '$kLichessHost/game/export/$gameId?evals=0&clocks=0',
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
      ],
    );
  }
}
