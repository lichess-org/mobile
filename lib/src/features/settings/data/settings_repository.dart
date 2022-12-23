import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/common/shared_preferences.dart';

const prefix = 'SettingsRepository';

class SettingsRepository {
  const SettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  // Theme
  Future<bool> setThemeMode(ThemeMode mode) async {
    return await _prefs.setString(backgroundModeKey, mode.name);
  }

  ThemeMode getThemeMode() {
    final str = _prefs.getString(backgroundModeKey) ?? 'system';
    switch (str) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }

  // Sound
  Future<bool> toggleSound() async {
    return await _prefs.setBool(soundMutedKey, !isSoundMuted());
  }

  bool isSoundMuted() {
    return _prefs.getBool(soundMutedKey) ?? false;
  }

  // --

  static const backgroundModeKey = '$prefix.backgroundMode';
  static const soundMutedKey = '$prefix.soundMuted';
}

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final sharedPrefs = ref.watch(sharedPreferencesProvider);
  return SettingsRepository(sharedPrefs);
});
