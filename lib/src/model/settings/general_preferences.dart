import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:lichess_mobile/src/common/shared_preferences.dart';

part 'general_preferences.freezed.dart';
part 'general_preferences.g.dart';

const _prefKey = 'preferences.general';

@Riverpod(keepAlive: true)
class GeneralPreferences extends _$GeneralPreferences {
  @override
  GeneralPrefsState build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final stored = prefs.getString(_prefKey);
    return stored != null
        ? GeneralPrefsState.fromJson(
            jsonDecode(stored) as Map<String, dynamic>,
          )
        : const GeneralPrefsState(
            themeMode: ThemeMode.system,
            isSoundEnabled: true,
          );
  }

  Future<void> setThemeMode(ThemeMode themeMode) {
    return _save(state.copyWith(themeMode: themeMode));
  }

  Future<void> toggleSoundEnabled() {
    return _save(state.copyWith(isSoundEnabled: !state.isSoundEnabled));
  }

  Future<void> _save(GeneralPrefsState newState) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(
      _prefKey,
      jsonEncode(newState.toJson()),
    );
    state = newState;
  }
}

@Freezed(fromJson: true, toJson: true)
class GeneralPrefsState with _$GeneralPrefsState {
  const factory GeneralPrefsState({
    required ThemeMode themeMode,
    required bool isSoundEnabled,
  }) = _GeneralPrefsState;

  factory GeneralPrefsState.fromJson(Map<String, dynamic> json) =>
      _$GeneralPrefsStateFromJson(json);
}
