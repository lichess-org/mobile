import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';

/// A button that toggles the sound on and off.
class ToggleSoundButton extends ConsumerWidget {
  const ToggleSoundButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSoundEnabled = ref.watch(
      generalPreferencesProvider.select((prefs) => prefs.isSoundEnabled),
    );

    return AppBarIconButton(
      // TODO: i18n
      semanticsLabel: 'Toggle sound',
      onPressed: () => ref.read(generalPreferencesProvider.notifier).toggleSoundEnabled(),
      icon: Icon(isSoundEnabled ? Icons.volume_up : Icons.volume_off),
    );
  }
}

/// A menu item button that toggles the sound on and off.
class ToggleSoundMenuItemButton extends ConsumerWidget {
  const ToggleSoundMenuItemButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSoundEnabled = ref.watch(
      generalPreferencesProvider.select((prefs) => prefs.isSoundEnabled),
    );

    return MenuItemButton(
      leadingIcon: Icon(isSoundEnabled ? Icons.volume_up : Icons.volume_off),
      semanticsLabel: context.l10n.sound,
      child: Text(context.l10n.sound),
      onPressed: () {
        ref.read(generalPreferencesProvider.notifier).toggleSoundEnabled();
      },
    );
  }
}
