import 'dart:ui' show Locale;

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:lichess_mobile/src/utils/color_palette.dart';
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

  Future<void> setAppTheme(AppTheme appTheme) {
    return save(state.copyWith(appTheme: appTheme));
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

    @JsonKey(unknownEnumValue: AppTheme.gold, defaultValue: AppTheme.gold)
    required AppTheme appTheme,

    /// App theme seed
    @Deprecated('Use appTheme instead')
    @JsonKey(unknownEnumValue: AppThemeSeed.board, defaultValue: AppThemeSeed.board)
    required AppThemeSeed appThemeSeed,

    /// Locale to use in the app, use system locale if null
    @LocaleConverter() Locale? locale,
  }) = _GeneralPrefs;

  static const defaults = GeneralPrefs(
    themeMode: BackgroundThemeMode.system,
    isSoundEnabled: true,
    soundTheme: SoundTheme.standard,
    masterVolume: 0.8,
    appThemeSeed: AppThemeSeed.board,
    appTheme: AppTheme.gold,
  );

  factory GeneralPrefs.fromJson(Map<String, dynamic> json) {
    return _$GeneralPrefsFromJson(json);
  }
}

enum AppThemeSeed {
  /// The app theme is based on the user's system theme (only available on Android 10+).
  system,

  /// The app theme is based on the chessboard.
  board,
}

enum AppTheme {
  /// The app theme is based on the user's system theme (only available on Android 10+).
  system,

  /// The app theme is based on the chess board
  board,

  /// Below values from [FlexScheme]
  blue,
  indigo,
  hippieBlue,
  aquaBlue,
  brandBlue,
  deepBlue,
  sakura,
  mandyRed,
  red,
  redWine,
  purpleBrown,
  green,
  money,
  jungle,
  greyLaw,
  wasabi,
  gold,
  mango,
  amber,
  vesuviusBurn,
  deepPurple,
  ebonyClay,
  barossa,
  shark,
  bigStone,
  damask,
  bahamaBlue,
  mallardGreen,
  espresso,
  outerSpace,
  blueWhale,
  sanJuanBlue,
  rosewood,
  blumineBlue,
  flutterDash,
  materialBaseline,
  verdunHemlock,
  dellGenoa,
  redM3,
  pinkM3,
  purpleM3,
  indigoM3,
  blueM3,
  cyanM3,
  tealM3,
  greenM3,
  limeM3,
  yellowM3,
  orangeM3,
  deepOrangeM3,
  blackWhite,
  greys,
  sepia;

  static final _flexSchemesNameMap = FlexScheme.values.asNameMap();

  FlexSchemeData getFlexScheme(BoardTheme boardTheme) =>
      this == AppTheme.system
          ? getSystemScheme()!
          : this == AppTheme.board
          ? boardTheme.flexScheme
          : _flexSchemesNameMap[name]!.data;
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
