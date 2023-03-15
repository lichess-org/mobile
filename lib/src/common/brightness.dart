import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lichess_mobile/src/model/settings/general_preferences.dart';

part 'brightness.g.dart';

@Riverpod(keepAlive: true)
Brightness currentBrightness(CurrentBrightnessRef ref) {
  final themeMode = ref.watch(
    generalPreferencesProvider.select(
      (state) => state.themeMode,
    ),
  );

  switch (themeMode) {
    case ThemeMode.dark:
      return Brightness.dark;
    case ThemeMode.light:
      return Brightness.light;
    case ThemeMode.system:
      return WidgetsBinding.instance.platformDispatcher.platformBrightness;
  }
}
