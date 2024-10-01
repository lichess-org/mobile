import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/settings/sound_theme.dart';

part 'preferences.freezed.dart';
part 'preferences.g.dart';

/// Interface for serializable preferences.
abstract class SerializablePreferences {
  Map<String, dynamic> toJson();

  static SerializablePreferences fromJson(
    Category key,
    Map<String, dynamic> json,
  ) {
    switch (key) {
      case Category.general:
        return General.fromJson(json);
      case Category.home:
        return Home.fromJson(json);
    }
  }
}

/// A preference category type with its storage key and default values.
enum Category<T extends SerializablePreferences> {
  general('preferences.general', General.defaults),
  home('preferences.home', Home.defaults);

  const Category(this.storageKey, this.defaults);

  final String storageKey;
  final T defaults;
}

/// General preferences for the app.
@Freezed(fromJson: true, toJson: true)
class General with _$General implements SerializablePreferences {
  const factory General({
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
  }) = _General;

  static const defaults = General(
    themeMode: ThemeMode.system,
    isSoundEnabled: true,
    soundTheme: SoundTheme.standard,
    masterVolume: 0.8,
    systemColors: true,
  );

  factory General.fromJson(Map<String, dynamic> json) {
    return _$GeneralFromJson(json);
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

enum EnabledWidget {
  hello,
  perfCards,
  quickPairing,
}

@Freezed(fromJson: true, toJson: true)
class Home with _$Home implements SerializablePreferences {
  const factory Home({
    required Set<EnabledWidget> enabledWidgets,
  }) = _Home;

  static const defaults = Home(
    enabledWidgets: {
      EnabledWidget.hello,
      EnabledWidget.perfCards,
      EnabledWidget.quickPairing,
    },
  );

  factory Home.fromJson(Map<String, dynamic> json) {
    try {
      return _$HomeFromJson(json);
    } catch (_) {
      return defaults;
    }
  }
}
