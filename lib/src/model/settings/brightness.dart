import 'package:flutter/foundation.dart' show Brightness;
import 'package:flutter/widgets.dart' show WidgetsBinding;
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'brightness.g.dart';

@riverpod
class CurrentBrightness extends _$CurrentBrightness {
  @override
  Brightness build() {
    final themeMode = ref.watch(
      generalPreferencesProvider.select((state) => state.themeMode),
    );

    WidgetsBinding
        .instance
        .platformDispatcher
        .onPlatformBrightnessChanged = () {
      WidgetsBinding.instance.handlePlatformBrightnessChanged();
      if (themeMode == BackgroundThemeMode.system) {
        state = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      }
    };

    switch (themeMode) {
      case BackgroundThemeMode.dark:
        return Brightness.dark;
      case BackgroundThemeMode.light:
        return Brightness.light;
      case BackgroundThemeMode.system:
        return WidgetsBinding.instance.platformDispatcher.platformBrightness;
    }
  }
}
