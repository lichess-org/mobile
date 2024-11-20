import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import '../settings/board_clock_position_screen.dart';
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
        PlatformListTile(
          // TODO translate
          title: const Text('Board settings'),
          trailing: const Icon(CupertinoIcons.chevron_right),
          onTap: () {
            pushPlatformRoute(
              context,
              screen: const BoardSettingsScreen(),
            );
          },
        ),
        SettingsListTile(
          //TODO Add l10n
          settingsLabel: const Text('Clock position'),
          settingsValue: BoardClockPositionScreen.position(
            context,
            boardPrefs.clockPosition,
          ),
          onTap: () {
            if (Theme.of(context).platform == TargetPlatform.android) {
              showChoicePicker(
                context,
                choices: ClockPosition.values,
                selectedItem: boardPrefs.clockPosition,
                labelBuilder: (t) =>
                    Text(BoardClockPositionScreen.position(context, t)),
                onSelectedItemChanged: (ClockPosition? value) => ref
                    .read(boardPreferencesProvider.notifier)
                    .setClockPosition(value ?? ClockPosition.right),
              );
            } else {
              pushPlatformRoute(
                context,
                title: 'Clock position',
                builder: (context) => const BoardClockPositionScreen(),
              );
            }
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
      ],
    );
  }
}
