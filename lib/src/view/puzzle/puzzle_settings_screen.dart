import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_preferences.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

class PuzzleSettingsScreen extends ConsumerWidget {
  const PuzzleSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authSessionProvider)?.user.id;

    final autoNext = ref.watch(
      PuzzlePreferencesProvider(userId).select((value) => value.autoNext),
    );
    final boardPrefs = ref.watch(boardPreferencesProvider);

    return DraggableScrollableSheet(
      initialChildSize: .4,
      expand: false,
      snap: true,
      snapSizes: const [.4, .7],
      builder: (context, scrollController) => ListView(
        controller: scrollController,
        children: [
          PlatformListTile(
            title:
                Text(context.l10n.settingsSettings, style: Styles.sectionTitle),
            subtitle: const SizedBox.shrink(),
          ),
          const SizedBox(height: 8.0),
          SwitchSettingTile(
            title: Text(context.l10n.puzzleJumpToNextPuzzleImmediately),
            value: autoNext,
            onChanged: (value) {
              ref
                  .read(puzzlePreferencesProvider(userId).notifier)
                  .setAutoNext(value);
            },
          ),
          SwitchSettingTile(
            title: Text(
              context.l10n.preferencesPieceAnimation,
            ),
            value: boardPrefs.pieceAnimation,
            onChanged: (value) {
              ref
                  .read(boardPreferencesProvider.notifier)
                  .togglePieceAnimation();
            },
          ),
        ],
      ),
    );
  }
}
