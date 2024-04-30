import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/play/create_custom_game_screen.dart';
import 'package:lichess_mobile/src/widgets/list.dart';

class CreateGameOptions extends ConsumerWidget {
  const CreateGameOptions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Theme.of(context).platform == TargetPlatform.iOS
        ? ListSection(
            hasLeading: true,
            children: [
              PlatformListTile(
                leading: const Icon(
                  Icons.tune,
                  size: 28,
                ),
                trailing: Theme.of(context).platform == TargetPlatform.iOS
                    ? const CupertinoListTileChevron()
                    : null,
                title:
                    Text(context.l10n.custom, style: Styles.mainListTileTitle),
                onTap: () {
                  ref.invalidate(accountProvider);
                  pushPlatformRoute(
                    context,
                    title: context.l10n.custom,
                    builder: (_) => const CreateCustomGameScreen(),
                  );
                },
              ),
            ],
          )
        : Padding(
            padding: Styles.bodySectionPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    ref.invalidate(accountProvider);
                    pushPlatformRoute(
                      context,
                      title: context.l10n.custom,
                      builder: (_) => const CreateCustomGameScreen(),
                    );
                  },
                  icon: const Icon(Icons.tune),
                  label: Text(context.l10n.custom),
                ),
              ],
            ),
          );
  }
}
