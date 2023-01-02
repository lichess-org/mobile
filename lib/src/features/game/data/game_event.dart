import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:deep_pick/deep_pick.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import '../model/game_status.dart';

part 'game_event.freezed.dart';

/// Represents a game event from lichess API.
///
/// Different types of events are possible.
/// See: https://lichess.org/api#tag/Board/operation/boardGameStream
///
/// We supports here only `gameFull` and `gameState`.
@freezed
class GameEvent with _$GameEvent {
  const factory GameEvent.gameState({
    required String moves,
    required int whiteTime,
    required int blackTime,
    required GameStatus status,
  }) = GameStateEvent;

  const factory GameEvent.gameFull({
    required GameId id,
    required String initialFen,
    required GameStateEvent state,
  }) = GameFullEvent;

  factory GameEvent.fromJson(Map<String, dynamic> json) {
    return GameEvent.fromPick(pick(json).required());
  }

  factory GameEvent.fromPick(RequiredPick pick) {
    final type = pick('type').asStringOrThrow();
    switch (type) {
      case 'gameFull':
        return GameEvent.gameFull(
          id: pick('id').asGameIdOrThrow(),
          initialFen: pick('initialFen').asStringOrThrow(),
          state: pick('state').letOrThrow((it) => _gameStateEventfromPick(it)),
        );
      case 'gameState':
        return _gameStateEventfromPick(pick);
      default:
        throw UnsupportedError('Unsupported event type $type');
    }
  }

  // ignore: prefer_constructors_over_static_methods
  static GameStateEvent _gameStateEventfromPick(RequiredPick pick) {
    return GameStateEvent(
      moves: pick('moves').asStringOrThrow(),
      whiteTime: pick('wtime').asIntOrThrow(),
      blackTime: pick('btime').asIntOrThrow(),
      status: pick('status').asGameStatusOrThrow(),
    );
  }
}
