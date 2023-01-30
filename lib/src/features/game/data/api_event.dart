import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import '../model/game.dart';

part 'api_event.freezed.dart';

enum GameEventLifecycle { start, finish }

/// Represents a lichess API stream event.
///
/// Different types of events are possible.
/// See: https://lichess.org/api#tag/Board/operation/apiStreamEvent
///
/// We supports here only `gameStart` and `gameFinish`.
@freezed
class ApiEvent with _$ApiEvent {
  const factory ApiEvent.gameStartOrFinish({
    required GameEventLifecycle type,
    required GameId gameId,
    required GameFullId fullId,
    required Side side,
    required String fen,
    required bool hasMoved,
    required bool isMyTurn,
    Move? lastMove,
    required Opponent opponent,
    required bool rated,
    required Perf perf,
    required Speed speed,
    required bool botCompat,
    required bool boardCompat,
  }) = GameStartEvent;

  factory ApiEvent.fromJson(Map<String, dynamic> json) {
    return ApiEvent.fromPick(pick(json).required());
  }

  factory ApiEvent.fromPick(RequiredPick pick) {
    final type = pick('type').asStringOrThrow();
    switch (type) {
      case 'gameStart':
      case 'gameFinish':
        return pick('game').letOrThrow((gamePick) => ApiEvent.gameStartOrFinish(
              type: type == 'gameStart'
                  ? GameEventLifecycle.start
                  : GameEventLifecycle.finish,
              gameId: gamePick('gameId').asGameIdOrThrow(),
              fullId: gamePick('fullId').asGameFullIdOrThrow(),
              side: gamePick('color').asSideOrThrow(),
              fen: gamePick('fen').asStringOrThrow(),
              hasMoved: gamePick('hasMoved').asBoolOrThrow(),
              isMyTurn: gamePick('isMyTurn').asBoolOrThrow(),
              lastMove: gamePick('lastMove').asUciMoveOrNull(),
              opponent: gamePick('opponent').letOrThrow(Opponent.fromPick),
              rated: gamePick('rated').asBoolOrThrow(),
              perf: gamePick('perf').asPerfOrThrow(),
              speed: gamePick('speed').asSpeedOrThrow(),
              botCompat: gamePick('compat', 'bot').asBoolOrThrow(),
              boardCompat: gamePick('compat', 'board').asBoolOrThrow(),
            ));
      default:
        throw UnsupportedError('Unsupported event type $type');
    }
  }
}

@freezed
class Opponent with _$Opponent {
  const factory Opponent({
    UserId? id,
    required String username,
    int? rating,
    int? aiLevel,
  }) = _Opponent;

  factory Opponent.fromPick(RequiredPick pick) {
    return Opponent(
      id: pick('id').asUserIdOrNull(),
      username: pick('username').asStringOrThrow(),
      rating: pick('rating').asIntOrNull(),
      aiLevel: pick('ai').asIntOrNull(),
    );
  }
}
