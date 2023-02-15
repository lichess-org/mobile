import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:deep_pick/deep_pick.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/utils/json.dart';

import 'package:lichess_mobile/src/model/game/game.dart';

part 'board_event.freezed.dart';

/// Represents a game event from lichess API.
///
/// Different types of events are possible.
/// See: https://lichess.org/api#tag/Board/operation/boardGameStream
///
/// We supports here only `gameFull` and `gameState`.
@freezed
class BoardEvent with _$BoardEvent {
  const factory BoardEvent.gameState({
    required String moves,
    required int whiteTime,
    required int blackTime,
    required GameStatus status,
  }) = GameStateEvent;

  const factory BoardEvent.gameFull({
    required GameId id,
    required String initialFen,
    required GameStateEvent state,
  }) = GameFullEvent;

  factory BoardEvent.fromJson(Map<String, dynamic> json) {
    return BoardEvent.fromPick(pick(json).required());
  }

  factory BoardEvent.fromPick(RequiredPick pick) {
    final type = pick('type').asStringOrThrow();
    switch (type) {
      case 'gameFull':
        return BoardEvent.gameFull(
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
