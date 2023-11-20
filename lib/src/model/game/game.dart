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

/// Common interface for playable and archived games.
abstract mixin class BaseGame {
  GameId get id;

  /// Game steps, cannot be empty.
  IList<GameStep> get steps;

  Side? get youAre;

  String? get initialFen;

  GameStatus get status;
  Side? get winner;

  bool? get isThreefoldRepetition;

  Variant get variant;
  Speed get speed;
  Perf get perf;

  Player get white;
  Player get black;

  Position get lastPosition;

  Side? playerSideOf(UserId id) {
    if (white.id == id) {
      return Side.white;
    } else if (black.id == id) {
      return Side.black;
    } else {
      return null;
    }
  }

  Player playerOf(Side side) {
    return side == Side.white ? white : black;
  }

  ({PlayerAnalysis white, PlayerAnalysis black})? get serverAnalysis =>
      white.analysis != null && black.analysis != null
          ? (white: white.analysis!, black: black.analysis!)
          : null;
}

/// A mixin that provides methods to access game data at a specific step.
mixin IndexableSteps on BaseGame {
  /// Internal PGN representation of the game.
  ///
  /// Contains the initial FEN if available. This is not meant to be used for
  /// exporting the game.
  String get pgn {
    final moves = steps
        .where((e) => e.sanMove != null)
        .map((e) => e.sanMove!.san)
        .join(' ');

    final fenHeader = initialFen != null ? '[FEN "$initialFen"]' : '';

    return '$fenHeader\n$moves';
  }

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

  @override
  Position get lastPosition => steps.last.position;

  int get lastPly => steps.last.ply;

  MaterialDiffSide? lastMaterialDiffAt(Side side) =>
      steps.last.diff?.bySide(side);
}

@freezed
class PlayableGame
    with _$PlayableGame, BaseGame, IndexableSteps
    implements BaseGame {
  const PlayableGame._();

  @Assert('steps.isNotEmpty')
  factory PlayableGame({
    required GameId id,
    required PlayableGameMeta meta,
    required IList<GameStep> steps,
    String? initialFen,
    required GameStatus status,
    Side? winner,
    required Variant variant,
    required Speed speed,
    required Perf perf,
    required Player white,
    required Player black,
    required bool moretimeable,
    required bool takebackable,

    /// The side that the current player is playing as. This is null if viewing
    /// the game as a spectator.
    Side? youAre,
    GamePrefs? prefs,
    PlayableClockData? clock,
    bool? boosted,
    bool? isThreefoldRepetition,
    ({Duration idle, Duration timeToMove, DateTime movedAt})? expiration,

    /// The game id of the next game if a rematch has been accepted.
    GameId? rematch,
  }) = _PlayableGame;

  /// Player of the playing point of view. Null if spectating.
  Player? get me => youAre == Side.white ? white : black;

  /// Opponent from the playing point of view. Null if spectating.
  Player? get opponent => youAre == Side.white ? black : white;

  Side get sideToMove => lastPosition.turn;

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
      !(me?.offeringDraw == true) &&
      !hasAI;
  bool get rematchable =>
      meta.rules == null || !meta.rules!.contains(GameRule.noRematch);
  bool get canTakeback =>
      takebackable &&
      playable &&
      lastPosition.fullmoves >= 2 &&
      !(me?.proposingTakeback == true) &&
      !(opponent?.proposingTakeback == true);
  bool get canGiveTime => moretimeable && playable && clock != null;

  bool get canClaimWin =>
      opponent?.isGone == true &&
      !isPlayerTurn &&
      resignable &&
      (meta.rules == null || !meta.rules!.contains(GameRule.noClaimWin));
}

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
class GamePrefs with _$GamePrefs {
  const GamePrefs._();

  const factory GamePrefs({
    required bool showRatings,
    required bool enablePremove,
    required AutoQueen autoQueen,
    required bool confirmResign,
    required bool submitMove,
    required Zen zenMode,
  }) = _GamePrefs;
}

@freezed
class PlayableGameMeta with _$PlayableGameMeta {
  const PlayableGameMeta._();

  const factory PlayableGameMeta({
    required bool rated,
    required Variant variant,
    required Speed speed,
    required Perf perf,
    required GameSource source,
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
class ArchivedGame
    with _$ArchivedGame, BaseGame, IndexableSteps
    implements BaseGame {
  const ArchivedGame._();

  @Assert('steps.isNotEmpty')
  factory ArchivedGame({
    required GameId id,
    required ArchivedGameData data,
    required IList<GameStep> steps,
    String? initialFen,
    required GameStatus status,
    Side? winner,
    bool? isThreefoldRepetition,
    required Variant variant,
    required Speed speed,
    required Perf perf,
    required Player white,
    required Player black,
    Side? youAre,
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
