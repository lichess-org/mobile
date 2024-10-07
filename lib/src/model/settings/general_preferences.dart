import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/preferences.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'general_preferences.freezed.dart';
part 'general_preferences.g.dart';

@riverpod
class GeneralPreferences extends _$GeneralPreferences
    with PreferencesStorage<GeneralPrefs> {
  // ignore: avoid_public_notifier_properties
  @override
  final prefCategory = PrefCategory.general;

  @override
  GeneralPrefs build() {
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

  Future<void> setSoundTheme(SoundTheme soundTheme) {
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

@Freezed(fromJson: true, toJson: true)
class GeneralPrefs with _$GeneralPrefs implements SerializablePreferences {
  const factory GeneralPrefs({
    @JsonKey(unknownEnumValue: ThemeMode.system, defaultValue: ThemeMode.system)
    required ThemeMode themeMode,
    required bool isSoundEnabled,
    @JsonKey(unknownEnumValue: SoundTheme.standard)
    required SoundTheme soundTheme,
    @JsonKey(defaultValue: 0.8) required double masterVolume,

    /// Should enable system color palette (android 12+ only)
    required bool systemColors,

    /// Locale to use in the app, use system locale if null
    @JsonKey(toJson: _localeToJson, fromJson: _localeFromJson) Locale? locale,
  }) = _GeneralPrefs;

  static const defaults = GeneralPrefs(
    themeMode: ThemeMode.system,
    isSoundEnabled: true,
    soundTheme: SoundTheme.standard,
    masterVolume: 0.8,
    systemColors: true,
  );

  factory GeneralPrefs.fromJson(Map<String, dynamic> json) {
    return _$GeneralPrefsFromJson(json);
  }
}

enum SoundTheme {
  standard('Standard'),
  piano('Piano'),
  nes('NES'),
  sfx('SFX'),
  futuristic('Futuristic'),
  lisp('Lisp');

  final String label;

  const SoundTheme(this.label);
}
