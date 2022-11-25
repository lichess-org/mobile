import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/settings_repository.dart';

class ThemeModeController extends StateNotifier<ThemeMode> {
  ThemeModeController(this.ref, initialThemeMode) : super(initialThemeMode);

  final Ref ref;

  void changeTheme(ThemeMode theme) async {
    final repository = ref.read(settingsRepositoryProvider);
    final ok = await repository.setThemeMode(theme);
    if (ok) {
      state = theme;
    }
  }
}

final themeModeControllerProvider =
    StateNotifierProvider<ThemeModeController, ThemeMode>((ref) {
  final repository = ref.read(settingsRepositoryProvider);
  return ThemeModeController(ref, repository.getThemeMode());
});

final selectedBrigthnessProvider = Provider<Brightness>((ref) {
  final themeMode = ref.watch(themeModeControllerProvider);

  switch (themeMode) {
    case ThemeMode.dark:
      return Brightness.dark;
    case ThemeMode.light:
      return Brightness.light;
    case ThemeMode.system:
      return WidgetsBinding.instance.platformDispatcher.platformBrightness;
  }
});
