import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:lichess_mobile/src/db/shared_preferences.dart';
import 'package:lichess_mobile/src/model/settings/sound.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';

part 'general_preferences.freezed.dart';
part 'general_preferences.g.dart';

const _prefKey = 'preferences.general';

@Riverpod(keepAlive: true)
class GeneralPreferences extends _$GeneralPreferences {
  @override
  GeneralPrefsState build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    String? stored = prefs.getString(_prefKey);

    if (stored != null) {
      final jsonResponse = jsonDecode(stored) as Map<String, dynamic>;
      if (jsonResponse.containsKey("soundTheme") != true) {
        jsonResponse['soundTheme'] = SoundTheme.normal.name;
        stored = jsonEncode(jsonResponse);
      }
    }

    final generalPrefState = stored != null
        ? GeneralPrefsState.fromJson(
            jsonDecode(stored) as Map<String, dynamic>,
          )
        : const GeneralPrefsState(
            themeMode: ThemeMode.system,
            isSoundEnabled: true,
            soundTheme: SoundTheme.normal,
          );

    ref.read(soundServiceProvider).changeTheme(generalPrefState.soundTheme);

    return generalPrefState;
  }

  Future<void> setThemeMode(ThemeMode themeMode) {
    return _save(state.copyWith(themeMode: themeMode));
  }

  Future<void> toggleSoundEnabled() {
    return _save(state.copyWith(isSoundEnabled: !state.isSoundEnabled));
  }

  Future<void> setSoundTheme(SoundTheme soundTheme) {
    return _save(state.copyWith(soundTheme: soundTheme));
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
    required SoundTheme soundTheme,
  }) = _GeneralPrefsState;

  factory GeneralPrefsState.fromJson(Map<String, dynamic> json) =>
      _$GeneralPrefsStateFromJson(json);
}
