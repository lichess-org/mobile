import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lichess_mobile/src/model/settings/general_preferences.dart';

part 'brightness.g.dart';

@Riverpod(keepAlive: true)
class CurrentBrightness extends _$CurrentBrightness {
  @override
  Brightness build() {
    final themeMode = ref.watch(
      generalPreferencesProvider.select(
        (state) => state.themeMode,
      ),
    );

    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
        () {
      WidgetsBinding.instance.handlePlatformBrightnessChanged();
      if (themeMode == ThemeMode.system) {
        state = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      }
    };

    switch (themeMode) {
      case ThemeMode.dark:
        return Brightness.dark;
      case ThemeMode.light:
        return Brightness.light;
      case ThemeMode.system:
        return WidgetsBinding.instance.platformDispatcher.platformBrightness;
    }
  }
}
