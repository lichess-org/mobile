import 'dart:ui' show Color, Locale;

import 'package:deep_pick/deep_pick.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';

class LocaleConverter implements JsonConverter<Locale?, Map<String, dynamic>?> {
  const LocaleConverter();

  @override
  Locale? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return Locale.fromSubtags(
      languageCode: json['languageCode'] as String,
      countryCode: json['countryCode'] as String?,
      scriptCode: json['scriptCode'] as String?,
    );
  }

  @override
  Map<String, dynamic>? toJson(Locale? locale) {
    return locale != null
        ? {
            'languageCode': locale.languageCode,
            'countryCode': locale.countryCode,
            'scriptCode': locale.scriptCode,
          }
        : null;
  }
}

class ColorConverter implements JsonConverter<Color?, Map<String, dynamic>?> {
  const ColorConverter();

  @override
  Color? fromJson(Map<String, dynamic>? json) {
    return json != null
        ? Color.from(
            alpha: json['a'] as double,
            red: json['r'] as double,
            green: json['g'] as double,
            blue: json['b'] as double,
          )
        : null;
  }

  @override
  Map<String, dynamic>? toJson(Color? color) {
    return color != null ? {'a': color.a, 'r': color.r, 'g': color.g, 'b': color.b} : null;
  }
}

extension UciExtension on Pick {
  /// Matches a UciCharPair from a string.
  UciCharPair asUciCharPairOrThrow() {
    final value = required().asStringOrThrow();
    return UciCharPair.fromStringId(value);
  }

  UciCharPair? asUciCharPairOrNull() {
    if (value == null) return null;
    try {
      return asUciCharPairOrThrow();
    } catch (_) {
      return null;
    }
  }

  /// Matches a UciPath from a string.
  UciPath asUciPathOrThrow() {
    final value = required().asStringOrThrow();
    return UciPath(value);
  }

  UciPath? asUciPathOrNull() {
    if (value == null) return null;
    try {
      return asUciPathOrThrow();
    } catch (_) {
      return null;
    }
  }
}

extension TimeExtension on Pick {
  /// Matches a DateTime from milliseconds since unix epoch.
  DateTime asDateTimeFromMillisecondsOrThrow() {
    final value = required().value;
    if (value is DateTime) {
      return value;
    }
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    throw PickException("value $value at $debugParsingExit can't be casted to DateTime");
  }

  /// Matches a DateTime from milliseconds since unix epoch.
  DateTime? asDateTimeFromMillisecondsOrNull() {
    if (value == null) return null;
    try {
      return asDateTimeFromMillisecondsOrThrow();
    } catch (_) {
      return null;
    }
  }

  /// Matches a Duration from minutes.
  Duration asDurationFromMinutesOrThrow() {
    final value = required().value;
    if (value is Duration) {
      return value;
    }
    if (value is int) {
      return Duration(minutes: value);
    }
    throw PickException("value $value at $debugParsingExit can't be casted to Duration");
  }

  Duration? asDurationFromMinutesOrNull() {
    if (value == null) return null;
    try {
      return asDurationFromMinutesOrThrow();
    } catch (_) {
      return null;
    }
  }

  /// Matches a Duration from seconds
  Duration asDurationFromSecondsOrThrow() {
    final value = required().value;
    if (value is Duration) {
      return value;
    }
    if (value is int) {
      return Duration(seconds: value);
    } else if (value is double) {
      return Duration(milliseconds: (value * 1000).toInt());
    }
    throw PickException("value $value at $debugParsingExit can't be casted to Duration");
  }

  /// Matches a Duration from seconds
  Duration? asDurationFromSecondsOrNull() {
    if (value == null) return null;
    try {
      return asDurationFromSecondsOrThrow();
    } catch (_) {
      return null;
    }
  }

  /// Matches a Duration from centiseconds
  Duration asDurationFromCentiSecondsOrThrow() {
    final value = required().value;
    if (value is Duration) {
      return value;
    }
    if (value is int) {
      return Duration(milliseconds: value * 10);
    }
    throw PickException("value $value at $debugParsingExit can't be casted to Duration");
  }

  Duration? asDurationFromCentiSecondsOrNull() {
    if (value == null) return null;
    try {
      return asDurationFromCentiSecondsOrThrow();
    } catch (_) {
      return null;
    }
  }

  /// Matches a Duration from milliseconds
  Duration asDurationFromMilliSecondsOrThrow() {
    final value = required().value;
    if (value is Duration) {
      return value;
    }
    if (value is int) {
      return Duration(milliseconds: value);
    }
    throw PickException("value $value at $debugParsingExit can't be casted to Duration");
  }

  Duration? asDurationFromMilliSecondsOrNull() {
    if (value == null) return null;
    try {
      return asDurationFromMilliSecondsOrThrow();
    } catch (_) {
      return null;
    }
  }
}
