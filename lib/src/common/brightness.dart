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
    final window = WidgetsBinding.instance.window;
    window.onPlatformBrightnessChanged = () {
      WidgetsBinding.instance.handlePlatformBrightnessChanged();
      state = window.platformBrightness;
    };

    return themeMode == ThemeMode.system
        ? window.platformBrightness
        : themeMode == ThemeMode.dark
            ? Brightness.dark
            : Brightness.light;
  }
}
