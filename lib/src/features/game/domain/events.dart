import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartchess/dartchess.dart';

import './game.dart';

part 'events.freezed.dart';
part 'events.g.dart';

@Freezed(toJson: false)
class GameStartEvent with _$GameStartEvent {
  factory GameStartEvent({
    @JsonKey(name: 'gameId') required String id,
    required bool rated,
    required Speed speed,
    @JsonKey(name: 'fen') required String initialFen,
    @JsonKey(name: 'color') required Side side,
  }) = _GameStartEvent;

  factory GameStartEvent.fromJson(Map<String, dynamic> json) =>
      _$GameStartEventFromJson(json);
}
