import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart'
    show BoardPrefs, BoardTheme, boardPreferencesProvider;
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:lichess_mobile/src/theme.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'general_preferences.freezed.dart';
part 'general_preferences.g.dart';

@Riverpod(keepAlive: true)
class GeneralPreferences extends _$GeneralPreferences with PreferencesStorage<GeneralPrefs> {
  @override
  @protected
  final prefCategory = PrefCategory.general;

  @override
  @protected
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

  Future<void> toggleSystemColors() {
    final newState = state.copyWith(systemColors: !state.systemColors);
    return Future.wait([
      save(newState),
      ref
          .read(boardPreferencesProvider.notifier)
          .setBoardTheme(
            newState.systemColors ? BoardTheme.system : BoardPrefs.defaults.boardTheme,
          ),
    ]).then((_) => {});
  }

  Future<void> setBackground({
    (BackgroundColor, bool)? backgroundColor,
    BackgroundImage? backgroundImage,
  }) {
    assert(
      !(backgroundColor != null && backgroundImage != null),
      'Only one of backgroundColor or backgroundImage should be set',
    );
    return save(state.copyWith(backgroundColor: backgroundColor, backgroundImage: backgroundImage));
  }
}

@Freezed(fromJson: true, toJson: true)
sealed class GeneralPrefs with _$GeneralPrefs implements Serializable {
  const GeneralPrefs._();

  @Assert('masterVolume >= 0 && masterVolume <= 1')
  const factory GeneralPrefs({
    @JsonKey(unknownEnumValue: BackgroundThemeMode.system, defaultValue: BackgroundThemeMode.system)
    required BackgroundThemeMode themeMode,
    required bool isSoundEnabled,
    @JsonKey(unknownEnumValue: SoundTheme.standard) required SoundTheme soundTheme,
    @JsonKey(defaultValue: 0.8) required double masterVolume,

    /// Whether to use system colors on android 10+.
    @JsonKey(defaultValue: true) required bool systemColors,

    /// App theme seed
    @Deprecated('Use systemColors instead')
    @JsonKey(unknownEnumValue: AppThemeSeed.board, defaultValue: AppThemeSeed.board)
    required AppThemeSeed appThemeSeed,

    /// Locale to use in the app, use system locale if null
    @LocaleConverter() Locale? locale,

    /// Background color theme (boolean value is not used)
    (BackgroundColor, bool)? backgroundColor,
    @BackgroundImageConverter() BackgroundImage? backgroundImage,
  }) = _GeneralPrefs;

  static const defaults = GeneralPrefs(
    themeMode: BackgroundThemeMode.system,
    isSoundEnabled: true,
    soundTheme: SoundTheme.standard,
    masterVolume: 0.8,
    systemColors: true,
    appThemeSeed: AppThemeSeed.board,
  );

  factory GeneralPrefs.fromJson(Map<String, dynamic> json) {
    return _$GeneralPrefsFromJson(json);
  }

  bool get isForcedDarkMode => backgroundColor != null || backgroundImage != null;
}

enum AppThemeSeed {
  /// The app theme is based on the user's system theme (only available on Android 10+).
  system,

  /// The app theme is based on the chessboard.
  board,
}

/// Describes the background theme of the app.
enum BackgroundThemeMode {
  /// Use either the light or dark theme based on what the user has selected in
  /// the system settings.
  system,

  /// Always use the light mode regardless of system preference.
  light,

  /// Always use the dark mode (if available) regardless of system preference.
  dark;

  String title(AppLocalizations l10n) {
    switch (this) {
      case BackgroundThemeMode.system:
        return l10n.deviceTheme;
      case BackgroundThemeMode.dark:
        return l10n.dark;
      case BackgroundThemeMode.light:
        return l10n.light;
    }
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

enum BackgroundColor {
  blue(Color(0xff435665), 'Blue'),
  indigo(Color(0xff42455c), 'Indigo'),
  green(Color(0xff344d3c), 'Green'),
  brown(Color(0xff4a3d3f), 'Brown'),
  gold(Color(0xff675139), 'Gold'),
  red(Color(0xff5f353b), 'Red'),
  purple(Color(0xff624865), 'Purple'),
  lime(Color(0xff4f5530), 'Lime'),
  sepia(Color(0xff5f5d57), 'Sepia');

  final Color color;
  final String _label;

  const BackgroundColor(this.color, this._label);

  String get label => _label;

  /// The base theme for the background color.
  ThemeData get baseTheme => BackgroundImage.getTheme(color);

  /// Darker version of the color by 30%.
  Color get darker => Color.lerp(color, Colors.black, 0.3)!;
}

@freezed
sealed class BackgroundImage with _$BackgroundImage {
  const BackgroundImage._();

  const factory BackgroundImage({
    /// The path to the image asset relative to the document directory returned by [getApplicationDocumentsDirectory]
    required String path,
    required Matrix4 transform,
    required bool isBlurred,
    required Color seedColor,
    required double meanLuminance,
    required double width,
    required double height,
    required double viewportWidth,
    required double viewportHeight,
  }) = _BackgroundImage;

  static Color getFilterColor(Color surfaceColor, double meanLuminance) => surfaceColor.withValues(
    alpha: switch (meanLuminance) {
      < 0.2 => 0,
      < 0.4 => 0.25,
      < 0.6 => 0.5,
      _ => 0.8,
    },
  );

  /// Generate a base [ThemeData] from the seed color.
  static ThemeData getTheme(Color seedColor) => ThemeData.from(
    colorScheme: ColorScheme.fromSeed(seedColor: seedColor, brightness: Brightness.dark),
    textTheme: defaultTargetPlatform == TargetPlatform.iOS ? kCupertinoDefaultTextTheme : null,
  );

  /// The base theme for the background image.
  ThemeData get baseTheme => getTheme(seedColor);
}

class BackgroundImageConverter implements JsonConverter<BackgroundImage?, Map<String, dynamic>?> {
  const BackgroundImageConverter();

  @override
  BackgroundImage? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }

    final transform = json['transform'] as List<dynamic>;

    return BackgroundImage(
      path: json['path'] as String,
      transform: Matrix4.fromList(transform.map((e) => (e as num).toDouble()).toList()),
      isBlurred: json['isBlurred'] as bool,
      seedColor: Color(json['seedColor'] as int),
      meanLuminance: json['meanLuminance'] as double,
      width: json['width'] as double,
      height: json['height'] as double,
      viewportWidth: json['viewportWidth'] as double,
      viewportHeight: json['viewportHeight'] as double,
    );
  }

  @override
  Map<String, dynamic>? toJson(BackgroundImage? object) {
    if (object == null) {
      return null;
    }

    return {
      'path': object.path,
      'transform': object.transform.storage,
      'isBlurred': object.isBlurred,
      'seedColor': object.seedColor.toARGB32(),
      'meanLuminance': object.meanLuminance,
      'width': object.width,
      'height': object.height,
      'viewportWidth': object.viewportWidth,
      'viewportHeight': object.viewportHeight,
    };
  }
}
