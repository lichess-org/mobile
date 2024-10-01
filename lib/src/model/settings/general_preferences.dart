import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/preferences.dart' as pref;
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'general_preferences.g.dart';

@riverpod
class GeneralPreferences extends _$GeneralPreferences
    with PreferencesStorage<pref.General> {
  // ignore: avoid_public_notifier_properties
  @override
  pref.Category<pref.General> get categoryKey => pref.Category.general;

  @override
  pref.General build() {
    return fetch();
  }

  Future<void> setThemeMode(ThemeMode themeMode) {
    return save(state.copyWith(themeMode: themeMode));
  }

  Future<void> toggleSoundEnabled() {
    return save(state.copyWith(isSoundEnabled: !state.isSoundEnabled));
  }

  Future<void> setLocale(Locale? locale) {
    return save(state.copyWith(locale: locale));
  }

  Future<void> setSoundTheme(pref.SoundTheme soundTheme) {
    return save(state.copyWith(soundTheme: soundTheme));
  }

  Future<void> setMasterVolume(double volume) {
    return save(state.copyWith(masterVolume: volume));
  }

  Future<void> toggleSystemColors() async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return;
    }
    await save(state.copyWith(systemColors: !state.systemColors));
    if (state.systemColors == false) {
      final boardTheme = ref.read(boardPreferencesProvider).boardTheme;
      if (boardTheme == pref.BoardTheme.system) {
        await ref
            .read(boardPreferencesProvider.notifier)
            .setBoardTheme(pref.BoardTheme.brown);
      }
    } else {
      await ref
          .read(boardPreferencesProvider.notifier)
          .setBoardTheme(pref.BoardTheme.system);
    }
  }
}
