import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game_controller.dart';
import 'package:lichess_mobile/src/model/game/game_preferences.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/settings/board_settings_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

import '../../widgets/adaptive_choice_picker.dart';
import 'game_screen_providers.dart';

class GameSettings extends ConsumerWidget {
  const GameSettings({required this.id, super.key});

  final GameFullId id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamePrefs = ref.watch(gamePreferencesProvider);
    final userPrefsAsync = ref.watch(userGamePrefsProvider(id));
    final boardPrefs = ref.watch(boardPreferencesProvider);

    return BottomSheetScrollableContainer(
      children: [
        ...userPrefsAsync.maybeWhen(
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
                        .read(gameControllerProvider(id).notifier)
                        .toggleMoveConfirmation();
                  },
                ),
              if (data.prefs?.autoQueen == AutoQueen.always)
                SwitchSettingTile(
                  title: Text(
                    context.l10n.preferencesPromoteToQueenAutomatically,
                  ),
                  value: data.canAutoQueen,
                  onChanged: (value) {
                    ref
                        .read(gameControllerProvider(id).notifier)
                        .toggleAutoQueen();
                  },
                ),
              SwitchSettingTile(
                title: Text(
                  context.l10n.preferencesZenMode,
                ),
                value: data.isZenModeEnabled,
                onChanged: (value) {
                  ref.read(gameControllerProvider(id).notifier).toggleZenMode();
                },
              ),
            ];
          },
          orElse: () => [],
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
        PlatformListTile(
          // TODO translate
          title: const Text('Board settings'),
          trailing: const Icon(CupertinoIcons.chevron_right),
          onTap: () {
            pushPlatformRoute(
              context,
              fullscreenDialog: true,
              screen: const BoardSettingsScreen(),
            );
          },
        ),
        SwitchSettingTile(
          title: Text(
            context.l10n.toggleTheChat,
          ),
          value: gamePrefs.enableChat ?? false,
          onChanged: (value) {
            ref.read(gamePreferencesProvider.notifier).toggleChat();
            ref.read(gameControllerProvider(id).notifier).onToggleChat(value);
          },
        ),
        SwitchSettingTile(
          title: Text(context.l10n.mobileBlindfoldMode),
          value: gamePrefs.blindfoldMode ?? false,
          onChanged: (value) {
            ref.read(gamePreferencesProvider.notifier).toggleBlindfoldMode();
          },
        ),
        SettingsListTile(
          settingsLabel: const Text('Material'), //TODO: l10n
          settingsValue: boardPrefs.materialDifferenceFormat
              .l10n(AppLocalizations.of(context)),
          onTap: () {
            showChoicePicker(
              context,
              choices: MaterialDifferenceFormat.values,
              selectedItem: boardPrefs.materialDifferenceFormat,
              labelBuilder: (t) => Text(t.l10n(AppLocalizations.of(context))),
              onSelectedItemChanged: (MaterialDifferenceFormat? value) => ref
                  .read(boardPreferencesProvider.notifier)
                  .setMaterialDifferenceFormat(
                    value ?? MaterialDifferenceFormat.materialDifference,
                  ),
            );
          },
        ),
      ],
    );
  }
}
