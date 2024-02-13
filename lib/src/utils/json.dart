import 'dart:convert';
import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:http/http.dart';
import 'package:lichess_mobile/src/model/common/errors.dart';
import 'package:logging/logging.dart';
import 'package:result_extensions/result_extensions.dart';

typedef Mapper<T> = T Function(Map<String, dynamic>);

/// Reads a [T] object from a JSON object.
Result<T> readJsonObject<T>(
  Map<String, dynamic> obj, {
  required Mapper<T> mapper,
  Logger? logger,
}) {
  final result = Result(() => mapper(obj));
  result.match(
    onError: (error, st) {
      logger?.severe('Could not read json object as $T: $error\n$st');
    },
  );
  return result;
}

T readJsonObjectFromBytes<T>(
  Uint8List bytes, {
  required Mapper<T> mapper,
  Logger? logger,
}) {
  final json = jsonDecode(utf8.decode(bytes));
  if (json is! Map<String, dynamic>) {
    logger?.severe('Could not read json object as $T: expected an object.');
    throw DataFormatException();
  }
  return mapper(json);
}

/// Reads a [T] object from a [Response] returning a JSON object.
Result<T> readJsonObjectFromResponse<T>(
  Response response, {
  required Mapper<T> mapper,
  Logger? logger,
}) {
  final json = jsonDecode(utf8.decode(response.bodyBytes));
  if (json is! Map<String, dynamic>) {
    logger?.severe('Could not read json object as $T: expected an object.');
    throw DataFormatException();
  }
  return readJsonObject(json, mapper: mapper, logger: logger);
}

/// Reads a list of [T] objects from a JSON array.
Result<IList<T>> readJsonListOfObjects<T>(
  List<dynamic> list, {
  required Mapper<T> mapper,
  Logger? logger,
}) {
  final result = Result(() {
    return IList(
      list.map((e) {
        if (e is! Map<String, dynamic>) {
          logger?.severe('Could not read json object as $T');
          throw DataFormatException();
        }
        return mapper(e);
      }),
    );
  });
  result.match(
    onError: (error, st) {
      logger?.severe('Could not read json as list of $T: $error\n$st');
    },
  );
  return result;
}

/// Reads a list of [T] objects from a [Response] returning a JSON array.
Result<IList<T>> readJsonListOfObjectsFromResponse<T>(
  Response response, {
  required Mapper<T> mapper,
  Logger? logger,
}) {
  return Result(() {
    final dynamic list = jsonDecode(utf8.decode(response.bodyBytes));
    if (list is! List<dynamic>) {
      logger?.severe('Received json is not a list');
      throw DataFormatException();
    }
    return list;
  }).flatMap(
    (list) => readJsonListOfObjects(
      list,
      mapper: mapper,
      logger: logger,
    ),
  );
}

/// Reads a list of [T] objects from a newline-delimited json [Response].
Result<IList<T>> readNdJsonListFromResponse<T>(
  Response response, {
  required Mapper<T> mapper,
  Logger? logger,
}) {
  final result = Result(() {
    final utf8Body = utf8.decode(response.bodyBytes);
    final lines = utf8Body.split('\n');
    return IList(
      lines.where((e) => e.isNotEmpty && e != '\n').map((e) {
        final json = jsonDecode(e);
        if (json is! Map<String, dynamic>) {
          logger
              ?.severe('Could not read json object as $T: expected an object.');
          throw DataFormatException();
        }
        return mapper(json);
      }),
    );
  });
  result.match(
    onError: (error, st) =>
        logger?.severe('Could not read ndjson as list of $T: $error\n$st'),
  );
  return result;
}

extension TimeExtension on Pick {
  /// Matches a DateTime from milliseconds since unix epoch.
  DateTime asDateTimeFromMillisecondsOrThrow() {
    final value = required().value;
    if (value is DateTime) {
      return value;
    }
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);
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
