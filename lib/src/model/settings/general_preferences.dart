import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/db/shared_preferences.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/sound_theme.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'general_preferences.freezed.dart';
part 'general_preferences.g.dart';

const _prefKey = 'preferences.general';

@Riverpod(keepAlive: true)
class GeneralPreferences extends _$GeneralPreferences {
  static GeneralPrefsState fetchFromStorage(SharedPreferences prefs) {
    final stored = prefs.getString(_prefKey);
    return stored != null
        ? GeneralPrefsState.fromJson(
            jsonDecode(stored) as Map<String, dynamic>,
          )
        : GeneralPrefsState.defaults;
  }

  @override
  GeneralPrefsState build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return fetchFromStorage(prefs);
  }

  Future<void> setThemeMode(ThemeMode themeMode) {
    return _save(state.copyWith(themeMode: themeMode));
  }

  Future<void> toggleSoundEnabled() {
    return _save(state.copyWith(isSoundEnabled: !state.isSoundEnabled));
  }

  Future<void> setLocale(Locale? locale) {
    return _save(state.copyWith(locale: locale));
  }

  Future<void> setSoundTheme(SoundTheme soundTheme) {
    return _save(state.copyWith(soundTheme: soundTheme));
  }

  Future<void> setMasterVolume(double volume) {
    return _save(state.copyWith(masterVolume: volume));
  }

  Future<void> toggleSystemColors() async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return;
    }
    await _save(state.copyWith(systemColors: !state.systemColors));
    if (state.systemColors == false) {
      final boardTheme = ref.read(boardPreferencesProvider).boardTheme;
      if (boardTheme == BoardTheme.system) {
        await ref
            .read(boardPreferencesProvider.notifier)
            .setBoardTheme(BoardTheme.brown);
      }
    } else {
      await ref
          .read(boardPreferencesProvider.notifier)
          .setBoardTheme(BoardTheme.system);
    }
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
    /// Background theme mode to use in the app
    @JsonKey(unknownEnumValue: ThemeMode.system) required ThemeMode themeMode,
    required bool isSoundEnabled,
    @JsonKey(unknownEnumValue: SoundTheme.standard)
    required SoundTheme soundTheme,
    @JsonKey(defaultValue: 0.8) required double masterVolume,

    /// Should enable system color palette (android 12+ only)
    required bool systemColors,

    /// Locale to use in the app, use system locale if null
    @JsonKey(toJson: _localeToJson, fromJson: _localeFromJson) Locale? locale,
  }) = _GeneralPrefsState;

  static const defaults = GeneralPrefsState(
    themeMode: ThemeMode.system,
    isSoundEnabled: true,
    soundTheme: SoundTheme.standard,
    masterVolume: 0.8,
    systemColors: true,
  );

  factory GeneralPrefsState.fromJson(Map<String, dynamic> json) {
    try {
      return _$GeneralPrefsStateFromJson(json);
    } catch (e) {
      debugPrint('Error parsing GeneralPrefsState: $e');
      return defaults;
    }
  }
}

Map<String, dynamic>? _localeToJson(Locale? locale) {
  return locale != null
      ? {
          'languageCode': locale.languageCode,
          'countryCode': locale.countryCode,
          'scriptCode': locale.scriptCode,
        }
      : null;
}

Locale? _localeFromJson(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return Locale.fromSubtags(
    languageCode: json['languageCode'] as String,
    countryCode: json['countryCode'] as String?,
    scriptCode: json['scriptCode'] as String?,
  );
}
