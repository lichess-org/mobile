import 'package:clock/clock.dart';
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
sealed class GameFullEvent with _$GameFullEvent {
  const factory GameFullEvent({required PlayableGame game, required int socketEventVersion}) =
      _GameFullEvent;

  factory GameFullEvent.fromJson(Map<String, dynamic> json) {
    return GameFullEvent(
      game: PlayableGame.fromServerJson(json),
      socketEventVersion: json['socket'] as int,
    );
  }
}

@freezed
sealed class MoveEvent with _$MoveEvent {
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
    ({Duration white, Duration black, Duration? lag, DateTime at})? clock,
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
        at: clock.now(),
        white: it('white').asDurationFromSecondsOrThrow(),
        black: it('black').asDurationFromSecondsOrThrow(),
        lag: it('lag').letOrNull((it) => Duration(milliseconds: it.asIntOrThrow() * 10)),
      ),
    ),
  );
}

@freezed
sealed class GameEndEvent with _$GameEndEvent {
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
    ratingDiff: pick(
      'ratingDiff',
    ).letOrNull((it) => (white: it('white').asIntOrThrow(), black: it('black').asIntOrThrow())),
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
sealed class ServerEvalEvent with _$ServerEvalEvent {
  const ServerEvalEvent._();

  const factory ServerEvalEvent({
    required IList<ExternalEval> evals,
    required Map<String, dynamic> tree,
    ServerAnalysis? analysis,
    GameDivision? division,
    required bool isAnalysisComplete,
  }) = _ServerEvalEvent;

  factory ServerEvalEvent.fromJson(Map<String, dynamic> json) =>
      _serverEvalEventFromPick(pick(json).required());
}

ServerEvalEvent _serverEvalEventFromPick(RequiredPick pick) {
  final tree = pick('tree').asMapOrThrow<String, dynamic>();
  Map<String, dynamic>? node = tree;
  final List<ExternalEval> evals = [];

  bool isAnalysisIncomplete = false;

  String? nextVariation;

  while (node != null) {
    final ply = node['ply'] as int;
    final san = node['san'] as String?;
    final children = node['children'] as List<dynamic>?;
    final firstChild = children?.firstOrNull as Map<String, dynamic>?;
    final eval = node['eval'] as Map<String, dynamic>?;

    if (eval == null && firstChild != null && ply <= 300 && ply > 0) {
      isAnalysisIncomplete = true;
    }

    final glyphs = node['glyphs'] as List<dynamic>?;
    final glyph = glyphs?.first as Map<String, dynamic>?;
    final comments = node['comments'] as List<dynamic>?;
    final comment = comments?.first as Map<String, dynamic>?;
    final judgment =
        glyph != null && comment != null
            ? (name: _nagToJugdmentName(glyph['id'] as int), comment: comment['text'] as String)
            : null;

    final variation = nextVariation;

    final buffer = StringBuffer();
    if (children != null && children.length > 1) {
      Map<String, dynamic>? variationNode = children[1] as Map<String, dynamic>;
      while (variationNode != null) {
        final san = variationNode['san'] as String;
        if (buffer.isEmpty) {
          buffer.write(san);
        } else {
          buffer.write(' $san');
        }
        final nestedChildren = variationNode['children'] as List<dynamic>?;
        if (nestedChildren != null && nestedChildren.isNotEmpty) {
          variationNode = nestedChildren.first as Map<String, dynamic>;
        } else {
          break;
        }
      }
    }
    nextVariation = buffer.isEmpty ? null : buffer.toString();
    // make it compatible with lichess API GET /game/export which doesn't return
    // an eval of the starting position
    // also make sure to not add an empty eval for checkmate (or stalemate) which
    // would be the leaf node with no eval
    if (san != null && (eval != null || firstChild != null)) {
      evals.add(
        ExternalEval(
          cp: eval?['cp'] as int?,
          mate: eval?['mate'] as int?,
          bestMove: eval?['best'] as String?,
          judgment: judgment,
          variation: variation,
        ),
      );
    }
    node = firstChild;
  }

  return ServerEvalEvent(
    tree: tree,
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
    isAnalysisComplete: !isAnalysisIncomplete,
    division: pick(
      'division',
    ).letOrNull((it) => (middle: it('middle').asIntOrNull(), end: it('end').asIntOrNull())),
  );
}

String _nagToJugdmentName(int nag) => switch (nag) {
  6 => 'Inaccuracy',
  2 => 'Mistake',
  4 => 'Blunder',
  int() => '',
};

typedef ServerAnalysis = ({GameId id, PlayerAnalysis white, PlayerAnalysis black});

typedef GameDivision = ({int? middle, int? end});
