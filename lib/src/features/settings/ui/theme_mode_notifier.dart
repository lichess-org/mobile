import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/settings_repository.dart';

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this.ref, ThemeMode initialThemeMode)
      : super(initialThemeMode);

  final Ref ref;

  void changeTheme(ThemeMode theme) async {
    final repository = ref.read(settingsRepositoryProvider);
    final ok = await repository.setThemeMode(theme);
    if (ok) {
      state = theme;
    }
  }
}

// keep this always available by not using autoDispose
final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return ThemeModeNotifier(ref, repository.getThemeMode());
});

final selectedBrigthnessProvider = Provider<Brightness>((ref) {
  final themeMode = ref.watch(themeModeProvider);

  switch (themeMode) {
    case ThemeMode.dark:
      return Brightness.dark;
    case ThemeMode.light:
      return Brightness.light;
    case ThemeMode.system:
      return WidgetsBinding.instance.platformDispatcher.platformBrightness;
  }
});
