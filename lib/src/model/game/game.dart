import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';

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
    return steps[cursor].sanMove?.move;
  }

  Position positionAt(int cursor) => steps[cursor].position;

  Duration? whiteClockAt(int cursor) => steps[cursor].whiteClock;

  Duration? blackClockAt(int cursor) => steps[cursor].blackClock;

  Move? get lastMove {
    return steps.last.sanMove?.move;
  }

  Position get initialPosition => steps.first.position;
  int get initialPly => steps.first.ply;

  Position get lastPosition => steps.last.position;

  int get lastPly => steps.last.ply;

  MaterialDiffSide? lastMaterialDiffAt(Side side) =>
      steps.last.diff?.bySide(side);
}

@freezed
class PlayableGame with _$PlayableGame, BaseGame, IndexableSteps {
  const PlayableGame._();

  @Assert('steps.isNotEmpty')
  factory PlayableGame({
    required PlayableGameMeta meta,
    required IList<GameStep> steps,
    required Player white,
    required Player black,
    required GameStatus status,
    required bool moretimeable,
    required bool takebackable,

    /// The side that the current player is playing as. This is null if viewing
    /// the game as a spectator.
    Side? youAre,
    GamePrefs? prefs,
    PlayableClockData? clock,
    bool? boosted,
    bool? isThreefoldRepetition,
    Side? winner,
    ({Duration idle, Duration timeToMove, DateTime movedAt})? expiration,

    /// The game id of the next game if a rematch has been accepted.
    GameId? rematch,
  }) = _PlayableGame;

  /// The side that the current player is playing as. Null if spectating.
  Player? get player => youAre == Side.white ? white : black;

  /// The side that the current player is playing against. Null if spectating.
  Player? get opponent => youAre == Side.white ? black : white;

  bool get hasAI => white.isAI || black.isAI;

  bool get isPlayerTurn => lastPosition.turn == youAre;
  bool get playing => status.value > GameStatus.started.value;
  bool get finished => status.value >= GameStatus.mate.value;
  bool get aborted => status == GameStatus.aborted;

  bool get playable => status.value < GameStatus.aborted.value;
  bool get abortable =>
      playable &&
      lastPosition.fullmoves <= 1 &&
      (meta.rules == null || !meta.rules!.contains(GameRule.noAbort));
  bool get resignable => playable && !abortable;
  bool get drawable =>
      playable &&
      lastPosition.fullmoves >= 2 &&
      !(player?.offeringDraw == true) &&
      !hasAI;
  bool get rematchable =>
      meta.rules == null || !meta.rules!.contains(GameRule.noRematch);
  bool get canTakeback =>
      takebackable &&
      playable &&
      lastPosition.fullmoves >= 2 &&
      !(player?.proposingTakeback == true) &&
      !(opponent?.proposingTakeback == true);
  bool get canGiveTime => moretimeable && playable && clock != null;

  bool get canClaimWin =>
      opponent?.isGone == true &&
      !isPlayerTurn &&
      resignable &&
      (meta.rules == null || !meta.rules!.contains(GameRule.noClaimWin));
}

typedef GamePrefs = ({
  bool showRatings,
  bool enablePremove,
  AutoQueen autoQueen,
  bool confirmResign,
  bool submitMove,
  Zen zenMode,
});

enum GameSource {
  lobby,
  friend,
  ai,
  api,
  arena,
  position,
  import,
  importLive,
  simul,
  relay,
  pool,
  swiss,
  unknown;

  static final nameMap = IMap(GameSource.values.asNameMap());
}

enum GameRule {
  noAbort,
  noRematch,
  noClaimWin,
  unknown;

  static final nameMap = IMap(GameRule.values.asNameMap());
}

@freezed
class PlayableGameMeta with _$PlayableGameMeta {
  const PlayableGameMeta._();

  const factory PlayableGameMeta({
    required GameId id,
    required bool rated,
    required Variant variant,
    required Speed speed,
    required Perf perf,
    required GameSource source,
    String? initialFen,
    int? startedAtTurn,
    ISet<GameRule>? rules,
  }) = _PlayableGameMeta;
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
  const ArchivedGameData._();

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
    LightOpening? opening,
    String? initialFen,
    String? lastFen,
    Side? winner,
    ClockData? clock,
  }) = _ArchivedGameData;

  String get clockDisplay {
    return TimeIncrement(
      clock?.initial.inSeconds ?? 0,
      clock?.increment.inSeconds ?? 0,
    ).display;
  }
}

@freezed
class ArchivedGame with _$ArchivedGame, BaseGame, IndexableSteps {
  const ArchivedGame._();

  @Assert('steps.isNotEmpty')
  factory ArchivedGame({
    required ArchivedGameData data,
    required IList<GameStep> steps,
    // IList<MoveAnalysis>? analysis,
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
    SanMove? sanMove,
    MaterialDiff? diff,

    /// The remaining white clock time at this step. Only for archived game.
    Duration? whiteClock,

    /// The remaining black clock time at this step. Only for archived game.
    Duration? blackClock,
  }) = _GameStep;
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
