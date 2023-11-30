import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game_controller.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/model/lobby/lobby_providers.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

import 'game_screen_providers.dart';

/// Common settings widget for the [LobbyGameScreen] and [StandaloneGameScreen].
class GameSettings extends ConsumerWidget {
  const GameSettings({this.id, this.seek, super.key})
      : assert(
          (seek != null || id != null) && !(seek != null && id != null),
          'Either seek or id must be provided, but not both.',
        );

  final GameSeek? seek;
  final GameFullId? id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSoundEnabled = ref.watch(
      generalPreferencesProvider.select(
        (prefs) => prefs.isSoundEnabled,
      ),
    );
    final boardPrefs = ref.watch(boardPreferencesProvider);
    final gameIdAsync = seek != null
        ? ref.watch(lobbyGameProvider(seek!))
        : AsyncValue.data((id!, fromRematch: false));

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
          ...gameIdAsync.maybeWhen(
            data: (data) {
              final (gameId, fromRematch: _) = data;
              final ctrlProvider = gameControllerProvider(gameId);
              final prefsAsync = ref.watch(gamePrefsProvider(gameId));
              return prefsAsync.maybeWhen(
                data: (data) {
                  return [
                    if (data.prefs?.submitMove == true)
                      SwitchSettingTile(
                        title: Text(
                          context.l10n.preferencesMoveConfirmation,
                        ),
                        value: data.shouldConfirmMove,
                        onChanged: (value) {
                          ref
                              .read(ctrlProvider.notifier)
                              .toggleMoveConfirmation();
                        },
                      ),
                    if (data.prefs?.zenMode == Zen.gameAuto)
                      SwitchSettingTile(
                        title: Text(
                          context.l10n.preferencesZenMode,
                        ),
                        value: data.isZenModeEnabled,
                        onChanged: (value) {
                          ref.read(ctrlProvider.notifier).toggleZenMode();
                        },
                      ),
                  ];
                },
                orElse: () => [],
              );
            },
            orElse: () => const [SizedBox.shrink()],
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
