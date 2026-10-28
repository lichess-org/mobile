import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:material_ui/material_ui.dart';

/// An app bar button that toggles the sound on and off, for `PlatformAppBar.actionsBuilder`, with
/// its ref.
///
/// A function rather than a widget class: the app bar turns a [SemanticIconButton] into a pinned
/// item whose glyph morphs on iOS 26, which it can't do for a widget wrapping one.
SemanticIconButton soundToggleButton(WidgetRef ref) {
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
