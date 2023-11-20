import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/http_client.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:share_plus/share_plus.dart';

import 'ping_rating.dart';
import 'game_screen_providers.dart';
import 'game_settings.dart';

class GameAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const GameAppBar({this.id, this.seek, super.key})
      : assert(
          (seek != null || id != null) && !(seek != null && id != null),
          'Either seek or id must be provided, but not both.',
        );

  final GameSeek? seek;
  final GameFullId? id;

  static const pingRating = Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
    child: PingRating(size: 24.0),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPlayableProvider = id != null
        ? gameIsPlayableProvider(id!)
        : lobbyGameIsPlayableProvider(seek!);
    final isPlayableAsync = ref.watch(isPlayableProvider);

    return AppBar(
      leading: isPlayableAsync.maybeWhen<Widget?>(
        data: (isPlayable) => isPlayable ? pingRating : null,
        orElse: () => pingRating,
      ),
      title: seek != null
          ? _LobbyGameTitle(seek: seek!)
          : _StandaloneGameTitle(id: id!),
      actions: [
        SettingsButton(
          onPressed: () => showAdaptiveBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (_) => GameSettings(seek: seek, id: id),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class GameCupertinoNavBar extends ConsumerWidget
    implements ObstructingPreferredSizeWidget {
  const GameCupertinoNavBar({this.id, this.seek, super.key})
      : assert(
          (seek != null || id != null) && !(seek != null && id != null),
          'Either seek or id must be provided, but not both.',
        );

  final GameSeek? seek;
  final GameFullId? id;

  static const pingRating = Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    child: PingRating(size: 24.0),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPlayableProvider = id != null
        ? gameIsPlayableProvider(id!)
        : lobbyGameIsPlayableProvider(seek!);
    final isPlayableAsync = ref.watch(isPlayableProvider);
    return CupertinoNavigationBar(
      padding: EdgeInsetsDirectional.zero,
      leading: isPlayableAsync.maybeWhen<Widget?>(
        data: (isPlayable) => isPlayable ? pingRating : null,
        orElse: () => pingRating,
      ),
      middle: seek != null
          ? _LobbyGameTitle(seek: seek!)
          : _StandaloneGameTitle(id: id!),
      trailing: SettingsButton(
        onPressed: () => showAdaptiveBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (_) => GameSettings(seek: seek, id: id),
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kMinInteractiveDimensionCupertino);

  /// True if the navigation bar's background color has no transparency.
  @override
  bool shouldFullyObstruct(BuildContext context) {
    final Color backgroundColor = CupertinoTheme.of(context).barBackgroundColor;
    return backgroundColor.alpha == 0xFF;
  }
}

List<BottomSheetAction> makeFinishedGameShareActions(
  BaseGame game, {
  required Position currentGamePosition,
  required Side orientation,
  Move? lastMove,
  required BuildContext context,
  required WidgetRef ref,
}) {
  final boardTheme = ref.read(boardPreferencesProvider).boardTheme;
  final pieceTheme = ref.read(boardPreferencesProvider).pieceSet;
  return [
    BottomSheetAction(
      label: const Text('Share game URL'),
      onPressed: (context) {
        Share.shareUri(
          Uri.parse('$kLichessHost/${game.id}'),
        );
      },
    ),
    BottomSheetAction(
      label: Text(context.l10n.gameAsGIF),
      onPressed: (context) async {
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
            showPlatformErrorSnackbar(
              context,
              'Failed to get GIF',
            );
          }
        }
      },
    ),
    if (lastMove != null)
      BottomSheetAction(
        label: Text(context.l10n.screenshotCurrentPosition),
        onPressed: (context) async {
          try {
            final resp = await ref
                .read(httpClientProvider)
                .get(
                  Uri.parse(
                    '$kLichessCDNHost/export/fen.gif?fen=${Uri.encodeComponent(currentGamePosition.fen)}&color=${orientation.name}&lastMove=${lastMove.uci}&theme=${boardTheme.name}&piece=${pieceTheme.name}',
                  ),
                )
                .timeout(const Duration(seconds: 1));
            if (resp.statusCode != 200) {
              throw Exception('Failed to get GIF');
            }
            Share.shareXFiles(
              [XFile.fromData(resp.bodyBytes, mimeType: 'image/gif')],
            );
          } catch (e) {
            if (context.mounted) {
              showPlatformErrorSnackbar(
                context,
                'Failed to get GIF',
              );
            }
          }
        },
      ),
    BottomSheetAction(
      label: Text('PGN: ${context.l10n.downloadAnnotated}'),
      onPressed: (context) async {
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
            showPlatformErrorSnackbar(
              context,
              'Failed to get PGN',
            );
          }
        }
      },
    ),
    BottomSheetAction(
      label: Text('PGN: ${context.l10n.downloadRaw}'),
      onPressed: (context) async {
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
            showPlatformErrorSnackbar(
              context,
              'Failed to get PGN',
            );
          }
        }
      },
    ),
  ];
}

class _LobbyGameTitle extends ConsumerWidget {
  const _LobbyGameTitle({
    required this.seek,
  });

  final GameSeek seek;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode =
        seek.rated ? ' • ${context.l10n.rated}' : ' • ${context.l10n.casual}';
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          seek.perf.icon,
          color: DefaultTextStyle.of(context).style.color,
        ),
        const SizedBox(width: 4.0),
        Text('${seek.timeIncrement.display}$mode'),
      ],
    );
  }
}

class _StandaloneGameTitle extends ConsumerWidget {
  const _StandaloneGameTitle({
    required this.id,
  });

  final GameFullId id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metaAsync = ref.watch(gameMetaProvider(id));
    return metaAsync.maybeWhen<Widget>(
      data: (data) {
        final (meta, clock) = data;

        final mode = meta.rated
            ? ' • ${context.l10n.rated}'
            : ' • ${context.l10n.casual}';
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              meta.perf.icon,
              color: DefaultTextStyle.of(context).style.color,
            ),
            const SizedBox(width: 4.0),
            if (clock != null)
              Text(
                '${TimeIncrement(clock.initial.inSeconds, clock.increment.inSeconds).display}$mode',
              )
            else
              Text('${meta.perf.title}$mode'),
          ],
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
