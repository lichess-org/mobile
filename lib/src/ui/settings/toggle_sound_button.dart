import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';

class ToggleSoundButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSoundEnabled = ref.watch(
      generalPreferencesProvider.select(
        (prefs) => prefs.isSoundEnabled,
      ),
    );

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return IconButton(
          // TODO translate
          tooltip: 'Toggle sound',
          icon: isSoundEnabled
              ? const Icon(Icons.volume_up)
              : const Icon(Icons.volume_off),
          onPressed: () => ref
              .read(generalPreferencesProvider.notifier)
              .toggleSoundEnabled(),
        );
      case TargetPlatform.iOS:
        return CupertinoIconButton(
          semanticsLabel: 'Toggle sound',
          icon: isSoundEnabled
              ? const Icon(CupertinoIcons.volume_up)
              : const Icon(CupertinoIcons.volume_off),
          onPressed: () => ref
              .read(generalPreferencesProvider.notifier)
              .toggleSoundEnabled(),
        );
      default:
        assert(false, 'Unexpected platform $defaultTargetPlatform');
        return const SizedBox.shrink();
    }
  }
}
