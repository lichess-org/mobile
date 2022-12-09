import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:logging/logging.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/common/errors.dart';
import 'package:lichess_mobile/src/common/models.dart';

extension Dartchess on Pick {
  Move asUciMoveOrThrow() {
    final value = required().value;
    if (value is Move) {
      return value;
    }
    if (value is String) {
      try {
        return Move.fromUci(value);
      } catch (_) {
        throw PickException(
            "value $value at $debugParsingExit can't be casted to Move: invalid UCI string.");
      }
    }
    throw PickException(
        "value $value at $debugParsingExit can't be casted to Move");
  }

  Move? asUciMoveOrNull() {
    if (value == null) return null;
    try {
      return asUciMoveOrThrow();
    } catch (_) {
      return null;
    }
  }

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
  /// Matches a DateTime from milliseconds since unix epoch.
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

  /// Matches a DateTime from milliseconds since unix epoch.
  DateTime? asDateTimeFromIntOrNull() {
    if (value == null) return null;
    try {
      return asDateTimeFromIntOrThrow();
    } catch (_) {
      return null;
    }
  }
}

extension GameIdModelsPick on Pick {
  GameId asGameIdOrThrow() {
    final value = required().value;
    if (value is GameId) {
      return value;
    }
    if (value is String) {
      return GameId(value);
    }
    throw PickException(
        "value $value at $debugParsingExit can't be casted to GameId");
  }

  GameId? asGameIdOrNull() {
    if (value == null) return null;
    try {
      return asGameIdOrThrow();
    } catch (_) {
      return null;
    }
  }

  GameFullId asGameFullIdOrThrow() {
    final value = required().value;
    if (value is GameFullId) {
      return value;
    }
    if (value is String) {
      return GameFullId(value);
    }
    throw PickException(
        "value $value at $debugParsingExit can't be casted to GameId");
  }

  GameFullId? asGameFullIdOrNull() {
    if (value == null) return null;
    try {
      return asGameFullIdOrThrow();
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
