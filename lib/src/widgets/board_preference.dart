import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';

import 'package:lichess_mobile/src/widgets/settings.dart';
import 'package:lichess_mobile/src/widgets/list.dart';

class BoardPreferenceModal extends ConsumerWidget {
  const BoardPreferenceModal();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSoundEnabled = ref.watch(
      generalPreferencesProvider.select(
        (prefs) => prefs.isSoundEnabled,
      ),
    );
    final boardPrefs = ref.watch(boardPreferencesProvider);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListSection(
            hasLeading: false,
            showDivider: false,
            children: [
              SwitchSettingTile(
                title: Text(context.l10n.sound),
                value: isSoundEnabled,
                onChanged: (value) {
                  ref
                      .read(generalPreferencesProvider.notifier)
                      .toggleSoundEnabled();
                },
              ),
              SwitchSettingTile(
                title: const Text('Haptic feedback'),
                value: boardPrefs.hapticFeedback,
                onChanged: (value) {
                  ref
                      .read(boardPreferencesProvider.notifier)
                      .toggleHapticFeedback();
                },
              ),
              SwitchSettingTile(
                title: Text(
                  context.l10n.preferencesPieceAnimation,
                  maxLines: 2,
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
        ],
      ),
    );
  }
}
