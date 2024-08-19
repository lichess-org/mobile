import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/over_the_board/over_the_board_screen.dart';
import 'package:lichess_mobile/src/view/play/create_custom_game_screen.dart';
import 'package:lichess_mobile/src/view/play/online_bots_screen.dart';
import 'package:lichess_mobile/src/widgets/list.dart';

class CreateGameOptions extends ConsumerWidget {
  const CreateGameOptions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttons = [
      _CreateGamePlatformButton(
        onTap: () {
          ref.invalidate(accountProvider);
          pushPlatformRoute(
            context,
            title: context.l10n.custom,
            builder: (_) => const CreateCustomGameScreen(),
          );
        },
        icon: Icons.tune,
        label: context.l10n.custom,
      ),
      _CreateGamePlatformButton(
        onTap: () {
          pushPlatformRoute(
            context,
            title: context.l10n.onlineBots,
            builder: (_) => const OnlineBotsScreen(),
          );
        },
        icon: Icons.computer,
        label: context.l10n.onlineBots,
      ),
      _CreateGamePlatformButton(
        onTap: () {
          pushPlatformRoute(
            context,
            title: 'Over the Board',
            rootNavigator: true,
            builder: (_) => const OverTheBoardScreen(),
          );
        },
        icon: LichessIcons.chess_board,
        label: 'Over the board',
      ),
    ];

    return Theme.of(context).platform == TargetPlatform.iOS
        ? ListSection(
            hasLeading: true,
            children: buttons,
          )
        : Padding(
            padding: Styles.bodySectionPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buttons,
            ),
          );
  }
}

class _CreateGamePlatformButton extends StatelessWidget {
  const _CreateGamePlatformButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;

  final String label;

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS
        ? PlatformListTile(
            leading: Icon(
              icon,
              size: 28,
            ),
            trailing: const CupertinoListTileChevron(),
            title: Text(label, style: Styles.mainListTileTitle),
            onTap: onTap,
          )
        : ElevatedButton.icon(
            onPressed: onTap,
            icon: Icon(icon),
            label: Text(label),
          );
  }
}
