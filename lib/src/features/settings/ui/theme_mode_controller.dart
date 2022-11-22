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
    StateNotifierProvider.autoDispose<ThemeModeController, ThemeMode>((ref) {
  final repository = ref.read(settingsRepositoryProvider);
  return ThemeModeController(ref, repository.getThemeMode());
});
