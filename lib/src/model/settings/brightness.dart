import 'package:flutter/foundation.dart' show Brightness;
import 'package:flutter/widgets.dart' show WidgetsBinding;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';

final currentBrightnessProvider = NotifierProvider<CurrentBrightness, Brightness>(
  CurrentBrightness.new,
  name: 'CurrentBrightnessProvider',
);

class CurrentBrightness extends Notifier<Brightness> {
  @override
  Brightness build() {
    final themeMode = ref.watch(generalPreferencesProvider.select((state) => state.themeMode));

    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged = () {
      WidgetsBinding.instance.handlePlatformBrightnessChanged();
      if (themeMode == BackgroundThemeMode.system) {
        state = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      }
    };

    return switch (themeMode) {
      BackgroundThemeMode.dark || BackgroundThemeMode.amoled => Brightness.dark,
      BackgroundThemeMode.light => Brightness.light,
      BackgroundThemeMode.system => WidgetsBinding.instance.platformDispatcher.platformBrightness,
    };
  }
}
