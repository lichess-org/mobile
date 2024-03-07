import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_share_service.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';

import 'game_screen_providers.dart';
import 'game_settings.dart';
import 'ping_rating.dart';

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
    final shouldPreventGoingBackAsync = id != null
        ? ref.watch(shouldPreventGoingBackProvider(id!))
        : const AsyncValue.data(true);

    return AppBar(
      leading: shouldPreventGoingBackAsync.maybeWhen<Widget?>(
        data: (prevent) => prevent ? pingRating : null,
        orElse: () => pingRating,
      ),
      title: seek != null
          ? _LobbyGameTitle(seek: seek!)
          : StandaloneGameTitle(id: id!),
      actions: [
        if (id != null)
          SettingsButton(
            onPressed: () => pushPlatformRoute(
              context,
              fullscreenDialog: true,
              builder: (_) => GameSettings(id: id!),
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
    final shouldPreventGoingBackAsync = id != null
        ? ref.watch(shouldPreventGoingBackProvider(id!))
        : const AsyncValue.data(true);

    return CupertinoNavigationBar(
      padding: Styles.cupertinoAppBarTrailingWidgetPadding,
      leading: shouldPreventGoingBackAsync.maybeWhen<Widget?>(
        data: (prevent) => prevent ? pingRating : null,
        orElse: () => pingRating,
      ),
      middle: seek != null
          ? _LobbyGameTitle(seek: seek!)
          : StandaloneGameTitle(id: id!),
      trailing: id != null
          ? SettingsButton(
              onPressed: () => pushPlatformRoute(
                context,
                fullscreenDialog: true,
                title: context.l10n.settingsSettings,
                builder: (_) => GameSettings(id: id!),
              ),
            )
          : null,
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
  return [
    BottomSheetAction(
      label: const Text('Share game URL'),
      dismissOnPress: false,
      onPressed: (context) {
        launchShareDialog(
          context,
          uri: Uri.parse('$kLichessHost/${game.id}'),
        );
      },
    ),
    BottomSheetAction(
      label: Text(context.l10n.gameAsGIF),
      dismissOnPress: false,
      onPressed: (context) async {
        try {
          final gif = await ref
              .read(gameShareServiceProvider)
              .gameGif(game.id, orientation);
          if (context.mounted) {
            launchShareDialog(
              context,
              files: [gif],
              subject: context.l10n.resVsX(
                game.white.fullName(context),
                game.black.fullName(context),
              ),
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
    ),
    if (lastMove != null)
      BottomSheetAction(
        label: Text(context.l10n.screenshotCurrentPosition),
        dismissOnPress: false,
        onPressed: (context) async {
          try {
            final image =
                await ref.read(gameShareServiceProvider).screenshotPosition(
                      game.id,
                      orientation,
                      currentGamePosition.fen,
                      lastMove,
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
      ),
    BottomSheetAction(
      label: Text('PGN: ${context.l10n.downloadAnnotated}'),
      dismissOnPress: false,
      onPressed: (context) async {
        try {
          final pgn =
              await ref.read(gameShareServiceProvider).annotatedPgn(game.id);
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
    ),
    BottomSheetAction(
      label: Text('PGN: ${context.l10n.downloadRaw}'),
      dismissOnPress: false,
      onPressed: (context) async {
        try {
          final pgn = await ref.read(gameShareServiceProvider).rawPgn(game.id);
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
        Text('${seek.timeIncrement?.display}$mode'),
      ],
    );
  }
}

class StandaloneGameTitle extends ConsumerWidget {
  const StandaloneGameTitle({
    required this.id,
  });

  final GameFullId id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metaAsync = ref.watch(gameMetaProvider(id));
    return metaAsync.maybeWhen<Widget>(
      data: (meta) {
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
            if (meta.clock != null)
              Text(
                '${TimeIncrement(meta.clock!.initial.inSeconds, meta.clock!.increment.inSeconds).display}$mode',
              )
            else if (meta.daysPerTurn != null)
              Text(
                '${context.l10n.nbDays(meta.daysPerTurn!)}$mode',
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
