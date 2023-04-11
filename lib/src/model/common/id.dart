import 'package:json_annotation/json_annotation.dart';

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
