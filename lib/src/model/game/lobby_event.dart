import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/game/game.dart';

part 'lobby_event.freezed.dart';

enum GameEventLifecycle { start, finish }

/// Represents a lobby stream event, that is related to game creation and challenges.
///
/// Different types of events are possible.
/// See: https://lichess.org/api#tag/Board/operation/apiStreamEvent
///
/// For now we support here only `gameStart` and `gameFinish`.
@freezed
class LobbyEvent with _$LobbyEvent {
  const factory LobbyEvent.gameStartOrFinish({
    required GameEventLifecycle type,
    required GameId gameId,
    required GameFullId fullId,
    required Side side,
    required String fen,
    Move? lastMove,
    required Opponent opponent,
    required bool rated,
    required Perf perf,
    required Speed speed,
    required GameStatus status,
  }) = GameStartEvent;

  factory LobbyEvent.fromJson(Map<String, dynamic> json) {
    return LobbyEvent.fromPick(pick(json).required());
  }

  factory LobbyEvent.fromPick(RequiredPick pick) {
    final type = pick('type').asStringOrThrow();
    switch (type) {
      case 'gameStart':
      case 'gameFinish':
        return pick('game').letOrThrow(
          (gamePick) => LobbyEvent.gameStartOrFinish(
            type: type == 'gameStart'
                ? GameEventLifecycle.start
                : GameEventLifecycle.finish,
            gameId: gamePick('gameId').asGameIdOrThrow(),
            fullId: gamePick('fullId').asGameFullIdOrThrow(),
            side: gamePick('color').asSideOrThrow(),
            fen: gamePick('fen').asStringOrThrow(),
            lastMove: gamePick('lastMove').asUciMoveOrNull(),
            opponent: gamePick('opponent').letOrThrow(Opponent.fromPick),
            rated: gamePick('rated').asBoolOrThrow(),
            perf: gamePick('perf').asPerfOrThrow(),
            status: gamePick('status').asGameStatusOrThrow(),
            speed: gamePick('speed').asSpeedOrThrow(),
          ),
        );
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
