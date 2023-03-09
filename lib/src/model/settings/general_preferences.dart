import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:lichess_mobile/src/common/shared_preferences.dart';

part 'general_preferences.freezed.dart';
part 'general_preferences.g.dart';

const _prefKey = 'preferences.display';

@Freezed(fromJson: true, toJson: true)
class GeneralPreferences with _$GeneralPreferences {
  const factory GeneralPreferences({
    required ThemeMode themeMode,
    required bool isSoundEnabled,
  }) = _GeneralPreferences;

  factory GeneralPreferences.fromJson(Map<String, dynamic> json) =>
      _$GeneralPreferencesFromJson(json);
}

@Riverpod(keepAlive: true)
class GeneralPreferencesState extends _$GeneralPreferencesState {
  @override
  GeneralPreferences build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final stored = prefs.getString(_prefKey);
    return stored != null
        ? GeneralPreferences.fromJson(
            jsonDecode(stored) as Map<String, dynamic>,
          )
        : const GeneralPreferences(
            themeMode: ThemeMode.dark,
            isSoundEnabled: true,
          );
  }

  Future<void> setThemeMode(ThemeMode themeMode) {
    return _save(state.copyWith(themeMode: themeMode));
  }

  Future<void> toggleSoundEnabled() {
    return _save(state.copyWith(isSoundEnabled: !state.isSoundEnabled));
  }

  Future<void> _save(GeneralPreferences newState) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(
      _prefKey,
      jsonEncode(newState.toJson()),
    );
    state = newState;
  }
}

@Riverpod(keepAlive: true)
Brightness currentBrightness(CurrentBrightnessRef ref) {
  final themeMode = ref.watch(
    generalPreferencesStateProvider.select(
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
