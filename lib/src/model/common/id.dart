import 'package:json_annotation/json_annotation.dart';
import 'package:deep_pick/deep_pick.dart';

part 'id.g.dart';

abstract class ID {
  const ID(this.value);

  final String value;

  @override
  String toString() => value;

  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ID && runtimeType == other.runtimeType && value == other.value;

  @override
  int get hashCode => value.hashCode;
}

@JsonSerializable()
class GameAnyId extends ID {
  const GameAnyId(super.value);

  GameId get gameId => GameId(value.substring(0, 8));
  bool get isFullId => value.length == 12;
  GameFullId? get gameFullId => isFullId ? GameFullId(value) : null;

  factory GameAnyId.fromJson(Map<String, dynamic> json) =>
      _$GameAnyIdFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GameAnyIdToJson(this);
}

@JsonSerializable()
class GameId extends ID {
  const GameId(super.value) : assert(value.length == 8);

  factory GameId.fromJson(Map<String, dynamic> json) => _$GameIdFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GameIdToJson(this);
}

@JsonSerializable()
class GameFullId extends ID {
  const GameFullId(super.value) : assert(value.length == 12);

  factory GameFullId.fromJson(Map<String, dynamic> json) =>
      _$GameFullIdFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GameFullIdToJson(this);
}

@JsonSerializable()
class GamePlayerId extends ID {
  const GamePlayerId(super.value) : assert(value.length == 4);

  factory GamePlayerId.fromJson(Map<String, dynamic> json) =>
      _$GamePlayerIdFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GamePlayerIdToJson(this);
}

@JsonSerializable()
class PuzzleId extends ID {
  const PuzzleId(super.value);

  factory PuzzleId.fromJson(Map<String, dynamic> json) =>
      _$PuzzleIdFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PuzzleIdToJson(this);
}

@JsonSerializable()
class UserId extends ID {
  const UserId(super.value);

  factory UserId.fromUserName(String userName) =>
      UserId(userName.toLowerCase());

  factory UserId.fromJson(Map<String, dynamic> json) => _$UserIdFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserIdToJson(this);
}

extension IDPick on Pick {
  UserId asUserIdOrThrow() {
    final value = required().value;
    if (value is UserId) {
      return value;
    }
    if (value is String) {
      return UserId(value);
    }
    throw PickException(
      "value $value at $debugParsingExit can't be casted to UserId",
    );
  }

  UserId? asUserIdOrNull() {
    if (value == null) return null;
    try {
      return asUserIdOrThrow();
    } catch (_) {
      return null;
    }
  }

  GameId asGameIdOrThrow() {
    final value = required().value;
    if (value is GameId) {
      return value;
    }
    if (value is String) {
      return GameId(value);
    }
    throw PickException(
      "value $value at $debugParsingExit can't be casted to GameId",
    );
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
      "value $value at $debugParsingExit can't be casted to GameId",
    );
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
      "value $value at $debugParsingExit can't be casted to PuzzleId",
    );
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
