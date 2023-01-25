import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:logging/logging.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/common/errors.dart';
import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/features/game/model/game.dart';
import 'package:lichess_mobile/src/features/game/model/game_status.dart';

extension Dartchess on Pick {
  Move asUciMoveOrThrow() {
    final value = required().value;
    if (value is Move) {
      return value;
    }
    if (value is String) {
      final move = Move.fromUci(value);
      if (move != null) {
        return move;
      } else {
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

extension GameExtension on Pick {
  Speed asSpeedOrThrow() {
    final value = required().value;
    if (value is Speed) {
      return value;
    }
    if (value is String) {
      return Speed.values
          .firstWhere((v) => v.name == value, orElse: () => Speed.blitz);
    }
    throw PickException(
        "value $value at $debugParsingExit can't be casted to Speed");
  }

  Speed? asSpeedOrNull() {
    if (value == null) return null;
    try {
      return asSpeedOrThrow();
    } catch (_) {
      return null;
    }
  }

  Perf asPerfOrThrow() {
    final value = required().value;
    if (value is Perf) {
      return value;
    }
    if (value is String) {
      return Perf.values
          .firstWhere((v) => v.name == value, orElse: () => Perf.blitz);
    }
    throw PickException(
        "value $value at $debugParsingExit can't be casted to Perf");
  }

  Perf? asPerfOrNull() {
    if (value == null) return null;
    try {
      return asPerfOrThrow();
    } catch (_) {
      return null;
    }
  }

  GameStatus asGameStatusOrThrow() {
    final value = required().value;
    if (value is GameStatus) {
      return value;
    }
    if (value is String) {
      return GameStatus.values
          .firstWhere((e) => e.name == value, orElse: () => GameStatus.unknown);
    }
    throw PickException(
        "value $value at $debugParsingExit can't be casted to GameStatus");
  }

  GameStatus? asGameStatusOrNull() {
    if (value == null) return null;
    try {
      return asGameStatusOrThrow();
    } catch (_) {
      return null;
    }
  }

  Variant asVariantOrThrow() {
    final value = required().value;
    if (value is Variant) {
      return value;
    }
    if (value is String) {
      return Variant.values
          .firstWhere((e) => e.name == value, orElse: () => Variant.standard);
    }
    throw PickException(
        "value $value at $debugParsingExit can't be casted to GameStatus");
  }

  Variant? asVariantOrNull() {
    if (value == null) return null;
    try {
      return asVariantOrNull();
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
    throw PickException(
        "value $value at $debugParsingExit can't be casted to DateTime");
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
    }
    throw PickException(
        "value $value at $debugParsingExit can't be casted to Duration");
  }

  /// Matches a DateTime from milliseconds since unix epoch.
  Duration? asDurationFromSecondsOrNull() {
    if (value == null) return null;
    try {
      return asDurationFromSecondsOrThrow();
    } catch (_) {
      return null;
    }
  }
}

extension ModelsPick on Pick {
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

  PuzzleId asPuzzleIdOrThrow() {
    final value = required().value;
    if (value is PuzzleId) {
      return value;
    }
    if (value is String) {
      return PuzzleId(value);
    }
    throw PickException(
        "value $value at $debugParsingExit can't be casted to PuzzleId");
  }

  PuzzleId? asPuzzleIdOrNull() {
    if (value == null) return null;
    try {
      return asPuzzleIdOrThrow();
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
      if (obj is! Map<String, dynamic>) {
        throw const FormatException('Expected an object');
      }
      return mapper(obj);
    }, (error, stackTrace) {
      logger?.severe('Could not read json object as $T: $error');
      return DataFormatError(stackTrace);
    });

Either<IOError, List<T>> readJsonListOfObjects<T>(String json,
        {required Mapper<T> mapper, Logger? logger}) =>
    Either.tryCatch(() {
      final dynamic list = jsonDecode(json);
      if (list is! List<dynamic>) {
        throw const FormatException('Expected a list');
      }
      return list.map((e) {
        if (e is! Map<String, dynamic>) {
          throw const FormatException('Expected an object');
        }
        return mapper(e);
      }).toList();
    }, (error, stackTrace) {
      if (error is FormatException) {
        logger?.severe('Received json is not a list');
      }
      logger?.severe('Could not read json object as $T: $error');
      return DataFormatError(stackTrace);
    });
