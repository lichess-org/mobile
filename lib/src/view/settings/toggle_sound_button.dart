import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';

/// A button that toggles the sound on and off.
class ToggleSoundButton extends ConsumerWidget {
  const ToggleSoundButton({this.iconSize, super.key});

  final double? iconSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSoundEnabled = ref.watch(
      generalPreferencesProvider.select(
        (prefs) => prefs.isSoundEnabled,
      ),
    );

    return PlatformIconButton(
      iconSize: iconSize,
      // TODO: translate
      semanticsLabel: 'Toggle sound',
      onTap: () =>
          ref.read(generalPreferencesProvider.notifier).toggleSoundEnabled(),
      icon: isSoundEnabled ? Icons.volume_up : Icons.volume_off,
    );
  }
}
