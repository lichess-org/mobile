import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:material_ui/material_ui.dart';

/// A button that toggles the sound on and off.
class const ToggleSoundButton({super.key}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSoundEnabled = ref.watch(
      generalPreferencesProvider.select((prefs) => prefs.isSoundEnabled),
    );

    return SemanticIconButton(
      // TODO: i18n
      semanticsLabel: 'Toggle sound',
      onPressed: () => ref.read(generalPreferencesProvider.notifier).toggleSoundEnabled(),
      icon: Icon(isSoundEnabled ? Icons.volume_up : Icons.volume_off),
    );
  }
}
