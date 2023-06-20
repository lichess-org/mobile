import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:deep_pick/deep_pick.dart';

import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/utils/json.dart';

import 'player.dart';
import 'game_status.dart';
import 'material_diff.dart';

part 'game.freezed.dart';

abstract mixin class BaseGame {
  /// Game steps, cannot be empty.
  IList<GameStep> get steps;
}

/// A mixin that provides methods to access game data at a specific step.
mixin IndexableSteps on BaseGame {
  MaterialDiffSide? materialDiffAt(int cursor, Side side) =>
      steps[cursor].diff?.bySide(side);

  GameStep stepAt(int cursor) => steps[cursor];

  String fenAt(int cursor) => steps[cursor].position.fen;

  Move? moveAt(int cursor) {
    final uci = steps[cursor].uci;
    return uci != null ? Move.fromUci(uci) : null;
  }

  Position positionAt(int cursor) => steps[cursor].position;

  Duration? whiteClockAt(int cursor) => steps[cursor].whiteClock;

  Duration? blackClockAt(int cursor) => steps[cursor].blackClock;

  Move? get lastMove {
    final uci = steps.last.uci;
    return uci != null ? Move.fromUci(uci) : null;
  }

  Position get lastPosition => steps.last.position;
}

@freezed
class PlayableGame with _$PlayableGame, BaseGame, IndexableSteps {
  const PlayableGame._();

  @Assert('steps.isNotEmpty')
  factory PlayableGame({
    required PlayableGameData data,
    required IList<GameStep> steps,
    required Player white,
    required Player black,
    required int socketVersion,
    Side? youAre,
    PlayableClockData? clock,
  }) = _PlayableGame;

  factory PlayableGame.fromWebSocketJson(Map<String, dynamic> json) =>
      _playableGameFromPick(pick(json).required());
}

PlayableGame _playableGameFromPick(RequiredPick pick) {
  final data = _playableGameDataFromPick(pick('game').required());

  // assume lichess always send initialFen with fromPosition and chess960
  Position position =
      (data.variant == Variant.fromPosition || data.variant == Variant.chess960)
          ? Chess.fromSetup(Setup.parseFen(data.initialFen!))
          : data.variant.initialPosition;

  int ply = 0;
  final steps = [GameStep(ply: ply, position: position)];
  final pgn = pick('game', 'pgn').asStringOrNull();
  final moves = pgn != null && pgn != '' ? pgn.split(' ') : null;
  if (moves != null && moves.isNotEmpty) {
    for (final san in moves) {
      ply++;
      final move = position.parseSan(san);
      // assume lichess only sends correct moves
      position = position.playUnchecked(move!);
      steps.add(
        GameStep(
          ply: ply,
          san: san,
          uci: move.uci,
          position: position,
          diff: MaterialDiff.fromBoard(position.board),
        ),
      );
    }
  }

  return PlayableGame(
    data: data,
    steps: steps.toIList(),
    white: pick('white').letOrThrow(_playerFromUserGamePick),
    black: pick('black').letOrThrow(_playerFromUserGamePick),
    socketVersion: pick('socket').asIntOrThrow(),
    clock: pick('clock').letOrNull(_playableClockDataFromPick),
    youAre: pick('youAre').asSideOrNull(),
  );
}

PlayableGameData _playableGameDataFromPick(RequiredPick pick) {
  return PlayableGameData(
    id: pick('id').asGameIdOrThrow(),
    rated: pick('rated').asBoolOrThrow(),
    speed: pick('speed').asSpeedOrThrow(),
    perf: pick('perf').asPerfOrThrow(),
    status: pick('status').asGameStatusOrThrow(),
    variant: pick('variant').asVariantOrThrow(),
    initialFen: pick('initialFen').asStringOrNull(),
  );
}

Player _playerFromUserGamePick(RequiredPick pick) {
  return Player(
    id: pick('user', 'id').asUserIdOrNull(),
    name: pick('user', 'name').asStringOrNull() ?? 'Stockfish',
    patron: pick('user', 'patron').asBoolOrNull(),
    title: pick('user', 'title').asStringOrNull(),
    rating: pick('rating').asIntOrNull(),
    ratingDiff: pick('ratingDiff').asIntOrNull(),
    aiLevel: pick('aiLevel').asIntOrNull(),
  );
}

PlayableClockData _playableClockDataFromPick(RequiredPick pick) {
  return PlayableClockData(
    initial: pick('initial').asDurationFromSecondsOrThrow(),
    increment: pick('increment').asDurationFromSecondsOrThrow(),
    running: pick('running').asBoolOrThrow(),
    white: pick('white').asDurationFromSecondsOrThrow(),
    black: pick('black').asDurationFromSecondsOrThrow(),
    emergency: pick('emerg').asDurationFromSecondsOrNull(),
    moreTime: pick('moretime').asDurationFromSecondsOrNull(),
  );
}

@freezed
class PlayableGameData with _$PlayableGameData {
  const PlayableGameData._();

  const factory PlayableGameData({
    required GameId id,
    required bool rated,
    required Variant variant,
    required Speed speed,
    required Perf perf,
    String? initialFen,
    required GameStatus status,
  }) = _PlayableGameData;
}

@freezed
class PlayableClockData with _$PlayableClockData {
  const factory PlayableClockData({
    required Duration initial,
    required Duration increment,
    required bool running,
    required Duration white,
    required Duration black,

    /// Remaining time threshold to switch the clock to "emergency" mode.
    Duration? emergency,

    /// Time added to the clock by the "add more time" button.
    Duration? moreTime,
  }) = _PlayableClockData;
}

@freezed
class ArchivedGameData with _$ArchivedGameData {
  const factory ArchivedGameData({
    required GameId id,
    required bool rated,
    required Speed speed,
    required Perf perf,
    required DateTime createdAt,
    required DateTime lastMoveAt,
    required GameStatus status,
    required Player white,
    required Player black,
    required Variant variant,
    String? initialFen,
    String? lastFen,
    Side? winner,
  }) = _ArchivedGameData;
}

@freezed
class ArchivedGame with _$ArchivedGame, BaseGame, IndexableSteps {
  const ArchivedGame._();

  @Assert('steps.isNotEmpty')
  factory ArchivedGame({
    required ArchivedGameData data,
    required IList<GameStep> steps,
    // IList<MoveAnalysis>? analysis,
    ClockData? clock,
  }) = _ArchivedGame;
}

@freezed
class ClockData with _$ClockData {
  const factory ClockData({
    required Duration initial,
    required Duration increment,
  }) = _ClockData;
}

@freezed
class GameStep with _$GameStep {
  const factory GameStep({
    required int ply,
    required Position position,
    String? san,
    String? uci,
    MaterialDiff? diff,

    /// The remaining white clock time at this step. Only for archived game.
    Duration? whiteClock,

    /// The remaining black clock time at this step. Only for archived game.
    Duration? blackClock,
  }) = _GameStep;
}

@freezed
class PlayerAnalysis with _$PlayerAnalysis {
  const factory PlayerAnalysis({
    required int inaccuracy,
    required int mistake,
    required int blunder,
    int? acpl,
  }) = _PlayerAnalysis;
}

@freezed
class MoveAnalysis with _$MoveAnalysis {
  const factory MoveAnalysis({
    int? eval,
    UCIMove? best,
    String? variation,
    AnalysisJudgment? judgment,
  }) = _MoveAnalysis;
}

@freezed
class AnalysisJudgment with _$AnalysisJudgment {
  const factory AnalysisJudgment({
    required String name,
    required String comment,
  }) = _AnalysisJugdment;
}
