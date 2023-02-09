import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'settings_repository.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
class ThemeModeSetting extends _$ThemeModeSetting {
  @override
  ThemeMode build() {
    final repository = ref.watch(settingsRepositoryProvider);
    return repository.getThemeMode();
  }

  Future<void> changeTheme(ThemeMode theme) async {
    final repository = ref.read(settingsRepositoryProvider);
    final ok = await repository.setThemeMode(theme);
    if (ok) {
      state = theme;
    }
  }
}

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

@Riverpod(keepAlive: true)
class MuteSoundSetting extends _$MuteSoundSetting {
  @override
  bool build() {
    final repository = ref.watch(settingsRepositoryProvider);
    return repository.isSoundMuted();
  }

  Future<void> toggleSound() async {
    final repository = ref.read(settingsRepositoryProvider);
    final ok = await repository.toggleSound();
    if (ok) {
      state = repository.isSoundMuted();
    }
  }
}
