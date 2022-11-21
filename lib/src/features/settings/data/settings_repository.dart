import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsRepository {
  const SettingsRepository({
    required this.prefs,
  });

  final SharedPreferences prefs;
  final prefix = 'SettingsRepository';

  Future<bool> setThemeMode(ThemeMode mode) async {
    return await prefs.setString(_key('backgroundMode'), mode.name);
  }

  ThemeMode getThemeMode() {
    final str = prefs.getString(_key('backgroundMode')) ?? 'system';
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

  String _key(String key) => '$prefix.$key';
}

// see lib/src/main.dart for initialization
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final sharedPrefs = ref.watch(sharedPreferencesProvider);
  return SettingsRepository(prefs: sharedPrefs);
});
