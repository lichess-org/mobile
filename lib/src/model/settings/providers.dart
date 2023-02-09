import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lichess_mobile/src/common/shared_preferences.dart';

part 'providers.g.dart';

const kSettingsStorePrefix = 'settings';

final themeModeSettingProvider = createPrefProvider(
  prefKey: '$kSettingsStorePrefix.themeMode',
  defaultValue: ThemeMode.system,
  mapFrom: (string) {
    switch (string) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  },
  mapTo: (ThemeMode theme) => theme.name,
);

@Riverpod(keepAlive: true)
Brightness selectedBrigthness(SelectedBrigthnessRef ref) {
  final themeMode = ref.watch(themeModeSettingProvider);

  switch (themeMode) {
    case ThemeMode.dark:
      return Brightness.dark;
    case ThemeMode.light:
      return Brightness.light;
    case ThemeMode.system:
      return WidgetsBinding.instance.platformDispatcher.platformBrightness;
  }
}

final muteSoundSettingProvider = createBoolPrefProvider(
  prefKey: '$kSettingsStorePrefix.muteSound',
  defaultValue: false,
);
