import 'package:deep_pick/deep_pick.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';

extension UciExtension on Pick {
  /// Matches a UciCharPair from a string.
  UciCharPair asUciCharPairOrThrow() {
    final value = required().asStringOrThrow();
    return UciCharPair.fromStringId(value);
  }

  /// Matches a UciPath from a string.
  UciPath asUciPathOrThrow() {
    final value = required().asStringOrThrow();
    return UciPath(value);
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
    throw PickException(
      "value $value at $debugParsingExit can't be casted to DateTime",
    );
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
    throw PickException(
      "value $value at $debugParsingExit can't be casted to Duration",
    );
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
    throw PickException(
      "value $value at $debugParsingExit can't be casted to Duration",
    );
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
    throw PickException(
      "value $value at $debugParsingExit can't be casted to Duration",
    );
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
