import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/model/game/game_controller.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';

class GameSettings extends ConsumerWidget {
  const GameSettings(this.ctrlProvider, {super.key});

  final GameControllerProvider? ctrlProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSoundEnabled = ref.watch(
      generalPreferencesProvider.select(
        (prefs) => prefs.isSoundEnabled,
      ),
    );
    final boardPrefs = ref.watch(boardPreferencesProvider);
    final gameState = ctrlProvider != null
        ? ref.watch(ctrlProvider!)
        : const AsyncValue<GameState>.loading();

    return ModalSheetScaffold(
      title: Text(context.l10n.settingsSettings),
      child: ListView(
        shrinkWrap: true,
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
            ),
            value: boardPrefs.pieceAnimation,
            onChanged: (value) {
              ref
                  .read(boardPreferencesProvider.notifier)
                  .togglePieceAnimation();
            },
          ),
          ...gameState.when(
            data: (data) {
              return [
                if (data.game.prefs?.submitMove == true)
                  SwitchSettingTile(
                    title: Text(
                      context.l10n.preferencesMoveConfirmation,
                    ),
                    value: data.shouldConfirmMove,
                    onChanged: (value) {
                      ref.read(ctrlProvider!.notifier).toggleMoveConfirmation();
                    },
                  ),
                if (data.game.prefs?.zenMode == Zen.gameAuto)
                  SwitchSettingTile(
                    title: Text(
                      context.l10n.preferencesZenMode,
                    ),
                    value: data.isZenModeEnabled,
                    onChanged: (value) {
                      ref.read(ctrlProvider!.notifier).toggleZenMode();
                    },
                  ),
              ];
            },
            loading: () => [const SizedBox.shrink()],
            error: (e, s) => [const SizedBox.shrink()],
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
