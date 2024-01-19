import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/playable_game.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import 'package:lichess_mobile/src/utils/json.dart';

part 'game_socket_events.freezed.dart';

@freezed
class GameFullEvent with _$GameFullEvent {
  const factory GameFullEvent({
    required PlayableGame game,
    required int socketEventVersion,
  }) = _GameFullEvent;

  factory GameFullEvent.fromJson(Map<String, dynamic> json) {
    return GameFullEvent(
      game: PlayableGame.fromServerJson(json),
      socketEventVersion: json['socket'] as int,
    );
  }
}

@freezed
class MoveEvent with _$MoveEvent {
  const MoveEvent._();

  const factory MoveEvent({
    required int ply,
    required String uci,
    required String san,
    bool? threefold,
    bool? whiteOfferingDraw,
    bool? blackOfferingDraw,
    GameStatus? status,
    Side? winner,
    ({Duration white, Duration black, Duration? lag})? clock,
  }) = _MoveEvent;

  factory MoveEvent.fromJson(Map<String, dynamic> json) =>
      _socketMoveEventFromPick(pick(json).required());
}

MoveEvent _socketMoveEventFromPick(RequiredPick pick) {
  String uci = pick('uci').asStringOrThrow();

  final promotion = pick('promotion', 'pieceClass').asStringOrNull();
  switch (promotion) {
    case 'queen':
      uci += 'q';
    case 'rook':
      uci += 'r';
    case 'bishop':
      uci += 'b';
    case 'knight':
      uci += 'n';
    // variants support
    case 'pawn':
      uci += 'p';
    case 'king':
      uci += 'k';
  }

  return MoveEvent(
    ply: pick('ply').asIntOrThrow(),
    uci: uci,
    san: pick('san').asStringOrThrow(),
    status: pick('status').asGameStatusOrNull(),
    winner: pick('winner').asSideOrNull(),
    threefold: pick('threefold').asBoolOrNull(),
    whiteOfferingDraw: pick('wDraw').asBoolOrNull(),
    blackOfferingDraw: pick('bDraw').asBoolOrNull(),
    clock: pick('clock').letOrNull(
      (it) => (
        white: it('white').asDurationFromSecondsOrThrow(),
        black: it('black').asDurationFromSecondsOrThrow(),
        lag: it('lag')
            .letOrNull((it) => Duration(milliseconds: it.asIntOrThrow() * 10)),
      ),
    ),
  );
}

@freezed
class GameEndEvent with _$GameEndEvent {
  const GameEndEvent._();

  const factory GameEndEvent({
    required GameStatus status,
    Side? winner,
    ({int white, int black})? ratingDiff,
    bool? boosted,
    ({Duration white, Duration black})? clock,
  }) = _GameEndEvent;

  factory GameEndEvent.fromJson(Map<String, dynamic> json) =>
      _gameEndEventFromPick(pick(json).required());
}

GameEndEvent _gameEndEventFromPick(RequiredPick pick) {
  return GameEndEvent(
    status: pick('status').asGameStatusOrThrow(),
    winner: pick('winner').asSideOrNull(),
    ratingDiff: pick('ratingDiff').letOrNull(
      (it) => (
        white: it('white').asIntOrThrow(),
        black: it('black').asIntOrThrow(),
      ),
    ),
    boosted: pick('boosted').asBoolOrNull(),
    clock: pick('clock').letOrNull(
      (it) => (
        white: Duration(milliseconds: it('wc').asIntOrThrow() * 10),
        black: Duration(milliseconds: it('bc').asIntOrThrow() * 10),
      ),
    ),
  );
}

@freezed
class ServerEvalEvent with _$ServerEvalEvent {
  const ServerEvalEvent._();

  const factory ServerEvalEvent({
    // only pick the mainline evals for now
    // TODO consider adding support for merging the JSON tree into our [Node] tree
    required IList<ExternalEval> evals,
    ServerAnalysis? analysis,
    GameDivision? division,
  }) = _ServerEvalEvent;

  bool get isAnalysisIncomplete =>
      evals.any((e) => e.cp == null || e.mate != null);

  factory ServerEvalEvent.fromJson(Map<String, dynamic> json) =>
      _serverEvalEventFromPick(pick(json).required());
}

ServerEvalEvent _serverEvalEventFromPick(RequiredPick pick) {
  Map<String, dynamic> node = pick('tree').asMapOrThrow<String, dynamic>();
  final eval = node['eval'] as Map<String, dynamic>?;

  final List<ExternalEval> evals = [
    ExternalEval(
      cp: eval?['cp'] as int?,
      mate: eval?['mate'] as int?,
      bestMove: eval?['best'] as String?,
    ),
  ];

  while ((node['children'] as List<dynamic>).isNotEmpty) {
    final children = node['children'] as List<dynamic>;
    final firstChild = children.first as Map<String, dynamic>;
    final eval = firstChild['eval'] as Map<String, dynamic>?;
    evals.add(
      ExternalEval(
        cp: eval?['cp'] as int?,
        mate: eval?['mate'] as int?,
        bestMove: eval?['best'] as String?,
      ),
    );
    node = firstChild;
  }

  return ServerEvalEvent(
    evals: evals.lock,
    analysis: pick('analysis').letOrNull(
      (it) => (
        id: GameId(it('id').asStringOrThrow()),
        white: it('white').letOrThrow(
          (pa) => PlayerAnalysis(
            inaccuracies: pa('inaccuracy').asIntOrThrow(),
            mistakes: pa('mistake').asIntOrThrow(),
            blunders: pa('blunder').asIntOrThrow(),
            acpl: pa('acpl').asIntOrNull(),
            accuracy: pa('accuracy').asIntOrNull(),
          ),
        ),
        black: it('black').letOrThrow(
          (pa) => PlayerAnalysis(
            inaccuracies: pa('inaccuracy').asIntOrThrow(),
            mistakes: pa('mistake').asIntOrThrow(),
            blunders: pa('blunder').asIntOrThrow(),
            acpl: pa('acpl').asIntOrNull(),
            accuracy: pa('accuracy').asIntOrNull(),
          ),
        ),
      ),
    ),
    division: pick('division').letOrNull(
      (it) => (
        middle: it('middle').asIntOrNull(),
        end: it('end').asIntOrNull(),
      ),
    ),
  );
}

typedef ServerAnalysis = ({
  GameId id,
  PlayerAnalysis white,
  PlayerAnalysis black,
});

typedef GameDivision = ({
  int? middle,
  int? end,
});
