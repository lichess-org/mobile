import 'dart:ui' show Color, Locale;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'general_preferences.freezed.dart';
part 'general_preferences.g.dart';

@riverpod
class GeneralPreferences extends _$GeneralPreferences with PreferencesStorage<GeneralPrefs> {
  // ignore: avoid_public_notifier_properties
  @override
  final prefCategory = PrefCategory.general;

  // ignore: avoid_public_notifier_properties
  @override
  GeneralPrefs get defaults => GeneralPrefs.defaults;

  @override
  GeneralPrefs fromJson(Map<String, dynamic> json) => GeneralPrefs.fromJson(json);

  @override
  GeneralPrefs build() {
    return fetch();
  }

  Future<void> setBackgroundThemeMode(BackgroundThemeMode themeMode) {
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

  Future<void> toggleCustomTheme() async {
    await save(state.copyWith(customThemeEnabled: !state.customThemeEnabled));
    if (state.customThemeEnabled == false) {
      final boardTheme = ref.read(boardPreferencesProvider).boardTheme;
      if (boardTheme == BoardTheme.system) {
        await ref.read(boardPreferencesProvider.notifier).setBoardTheme(BoardTheme.brown);
      }
    } else {
      await ref.read(boardPreferencesProvider.notifier).setBoardTheme(BoardTheme.system);
    }
  }

  Future<void> setCustomThemeSeed(Color? color) {
    return save(state.copyWith(customThemeSeed: color));
  }
}

@Freezed(fromJson: true, toJson: true)
class GeneralPrefs with _$GeneralPrefs implements Serializable {
  const factory GeneralPrefs({
    @JsonKey(unknownEnumValue: BackgroundThemeMode.system, defaultValue: BackgroundThemeMode.system)
    required BackgroundThemeMode themeMode,
    required bool isSoundEnabled,
    @JsonKey(unknownEnumValue: SoundTheme.standard) required SoundTheme soundTheme,
    @JsonKey(defaultValue: 0.8) required double masterVolume,

    /// Should enable custom theme
    @JsonKey(defaultValue: false) required bool customThemeEnabled,

    /// Custom theme seed color
    @ColorConverter() Color? customThemeSeed,

    /// Locale to use in the app, use system locale if null
    @LocaleConverter() Locale? locale,
  }) = _GeneralPrefs;

  static const defaults = GeneralPrefs(
    themeMode: BackgroundThemeMode.system,
    isSoundEnabled: true,
    soundTheme: SoundTheme.standard,
    masterVolume: 0.8,
    customThemeEnabled: true,
  );

  factory GeneralPrefs.fromJson(Map<String, dynamic> json) {
    return _$GeneralPrefsFromJson(json);
  }
}

/// Describes the background theme of the app.
enum BackgroundThemeMode {
  /// Use either the light or dark theme based on what the user has selected in
  /// the system settings.
  system,

  /// Always use the light mode regardless of system preference.
  light,

  /// Always use the dark mode (if available) regardless of system preference.
  dark,
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
