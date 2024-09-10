import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_preferences.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

class PuzzleSettingsScreen extends ConsumerWidget {
  const PuzzleSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authSessionProvider)?.user.id;

    final isSoundEnabled = ref.watch(
      generalPreferencesProvider.select((pref) => pref.isSoundEnabled),
    );
    final autoNext = ref.watch(
      PuzzlePreferencesProvider(userId).select((value) => value.autoNext),
    );
    final boardPrefs = ref.watch(boardPreferencesProvider);

    return ListView(
      shrinkWrap: true,
      children: [
        SwitchSettingTile(
          title: Text(context.l10n.sound),
          value: isSoundEnabled,
          onChanged: (value) {
            ref.read(generalPreferencesProvider.notifier).toggleSoundEnabled();
          },
        ),
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
          // TODO: Add l10n
          title: const Text('Shape drawing'),
          subtitle: const Text(
            'Draw shapes using two fingers.',
            maxLines: 5,
            textAlign: TextAlign.justify,
          ),
          value: boardPrefs.enableShapeDrawings,
          onChanged: (value) {
            ref
                .read(boardPreferencesProvider.notifier)
                .toggleEnableShapeDrawings();
          },
        ),
        SwitchSettingTile(
          title: Text(
            context.l10n.preferencesPieceAnimation,
          ),
          value: boardPrefs.pieceAnimation,
          onChanged: (value) {
            ref.read(boardPreferencesProvider.notifier).togglePieceAnimation();
          },
        ),
      ],
    );
  }
}
