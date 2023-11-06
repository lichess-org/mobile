import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';

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
      padding: const EdgeInsetsDirectional.only(end: 16.0),
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
