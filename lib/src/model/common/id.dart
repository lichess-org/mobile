import 'package:deep_pick/deep_pick.dart';

extension type const StringId(String id) {
  StringId.fromJson(dynamic json) : this(json as String);
  String toJson() => id;

  int get length => id.length;
  bool startsWith(String prefix) => id.startsWith(prefix);
}

extension type const GameAnyId._(String id) implements StringId {
  GameAnyId(this.id) : assert(id.length == 8 || id.length == 12);
  GameId get gameId => GameId(id.substring(0, 8));
  bool get isFullId => id.length == 12;
  GameFullId? get gameFullId => isFullId ? GameFullId(id) : null;

  GameAnyId.fromJson(dynamic json) : this(json as String);
}

extension type const GameId._(String id) implements StringId {
  const GameId(this.id) : assert(id.length == 8);

  GameId.fromJson(dynamic json) : this(json as String);
}

extension type const GameFullId._(String id) implements StringId {
  const GameFullId(this.id) : assert(id.length == 12);

  GameFullId.fromJson(dynamic json) : this(json as String);

  GameId get gameId => GameId(id.substring(0, 8));
}

extension type const GamePlayerId._(String id) implements StringId {
  const GamePlayerId(this.id) : assert(id.length == 4);

  GamePlayerId.fromJson(dynamic json) : this(json as String);
}

extension type const PuzzleId(String id) implements StringId {
  PuzzleId.fromJson(dynamic json) : this(json as String);
}

extension type const UserId(String id) implements StringId {
  UserId.fromUserName(String userName) : this(userName.toLowerCase());
  UserId.fromJson(dynamic json) : this(json as String);
}

extension IDPick on Pick {
  UserId asUserIdOrThrow() {
    final value = required().value;
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
