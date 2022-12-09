import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:logging/logging.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/common/errors.dart';
import 'package:lichess_mobile/src/common/models.dart';

extension SideFromStringPick on Pick {
  Side asSideOrThrow() {
    final value = required().value;
    if (value is Side) {
      return value;
    }
    if (value is String) {
      return value == 'white' ? Side.white : Side.black;
    }
    throw PickException(
        "value $value at $debugParsingExit can't be casted to Side");
  }

  Side? asSideOrNull() {
    if (value == null) return null;
    try {
      return asSideOrThrow();
    } catch (_) {
      return null;
    }
  }
}

extension DateTimeFromIntPick on Pick {
  DateTime asDateTimeFromIntOrThrow() {
    final value = required().value;
    if (value is DateTime) {
      return value;
    }
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    throw PickException(
        "value $value at $debugParsingExit can't be casted to DateTime");
  }

  DateTime? asDateTimeFromIntOrNull() {
    if (value == null) return null;
    try {
      return asDateTimeFromIntOrThrow();
    } catch (_) {
      return null;
    }
  }
}

extension GameIdFromStringPick on Pick {
  GameId asGameIdOrThrow() {
    final value = required().value;
    if (value is GameId) {
      return value;
    }
    if (value is String) {
      return GameId(value);
    }
    throw PickException(
        "value $value at $debugParsingExit can't be casted to DateTime");
  }

  GameId? asGameIdOrNull() {
    if (value == null) return null;
    try {
      return asGameIdOrThrow();
    } catch (_) {
      return null;
    }
  }
}

typedef Mapper<T> = T Function(Map<String, dynamic>);

Either<IOError, T> readJsonObject<T>(String json,
        {required Mapper<T> mapper, Logger? logger}) =>
    Either.tryCatch(() {
      final dynamic obj = jsonDecode(json);
      if (obj is! Map<String, dynamic>) throw const FormatException();
      return mapper(obj);
    }, (error, stackTrace) {
      logger?.severe('Could not read json object as ${T.toString()}: $error');
      return DataFormatError(stackTrace);
    });

Either<IOError, List<T>> readJsonListOfObjects<T>(String json,
        {required Mapper<T> mapper, Logger? logger}) =>
    Either.tryCatch(() {
      final dynamic list = jsonDecode(json);
      if (list is! List<dynamic>) throw const FormatException();
      return list.map((e) {
        if (e is! Map<String, dynamic>) throw const FormatException();
        return mapper(e);
      }).toList();
    }, (error, stackTrace) {
      logger?.severe('Could not read json object as ${T.toString()}: $error');
      return DataFormatError(stackTrace);
    });
