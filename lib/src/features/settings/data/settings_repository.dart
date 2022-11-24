import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const prefix = 'SettingsRepository';

class SettingsRepository {
  const SettingsRepository({
    required this.prefs,
  });

  final SharedPreferences prefs;

  // Theme
  Future<bool> setThemeMode(ThemeMode mode) async {
    return await prefs.setString(backgroundModeKey, mode.name);
  }

  ThemeMode getThemeMode() {
    final str = prefs.getString(backgroundModeKey) ?? 'system';
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
    return await prefs.setBool(soundMutedKey, !isSoundMuted());
  }

  bool isSoundMuted() {
    return prefs.getBool(soundMutedKey) ?? false;
  }

  // --

  static const backgroundModeKey = '$prefix.backgroundMode';
  static const soundMutedKey = '$prefix.soundMuted';
}

// see lib/src/main.dart for initialization
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final sharedPrefs = ref.watch(sharedPreferencesProvider);
  return SettingsRepository(prefs: sharedPrefs);
});
