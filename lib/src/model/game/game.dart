import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';

import 'game_status.dart';
import 'material_diff.dart';
import 'player.dart';

part 'game.freezed.dart';
part 'game.g.dart';

/// Common interface for playable and archived games.
abstract mixin class BaseGame {
  GameId get id;

  /// Game steps, cannot be empty.
  IList<GameStep> get steps;

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
    if (white.user?.id == id) {
      return Side.white;
    } else if (black.user?.id == id) {
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
    final fenHeader = initialFen != null ? '[FEN "$initialFen"]' : '';

    return '$fenHeader\n$sanMoves';
  }

  String get sanMoves => steps
      .where((e) => e.sanMove != null)
      .map((e) => e.sanMove!.san)
      .join(' ');

  MaterialDiffSide? materialDiffAt(int cursor, Side side) =>
      steps[cursor].diff?.bySide(side);

  GameStep stepAt(int cursor) => steps[cursor];

  String fenAt(int cursor) => steps[cursor].position.fen;

  Move? moveAt(int cursor) {
    return steps[cursor].sanMove?.move;
  }

  Position positionAt(int cursor) => steps[cursor].position;

  Duration? archivedWhiteClockAt(int cursor) =>
      steps[cursor].archivedWhiteClock;

  Duration? archivedBlackClockAt(int cursor) =>
      steps[cursor].archivedBlackClock;

  Move? get lastMove {
    return steps.last.sanMove?.move;
  }

  Position get initialPosition => steps.first.position;
  int get initialPly => steps.first.position.ply;

  @override
  Position get lastPosition => steps.last.position;

  int get lastPly => steps.last.position.ply;

  MaterialDiffSide? lastMaterialDiffAt(Side side) =>
      steps.last.diff?.bySide(side);
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

  @Assert('!(clock != null && daysPerTurn != null)')
  const factory PlayableGameMeta({
    required bool rated,
    required Variant variant,
    required Speed speed,
    required Perf perf,
    required GameSource source,
    ({
      Duration initial,
      Duration increment,

      /// Remaining time threshold to switch the clock to "emergency" mode.
      Duration? emergency,

      /// Time added to the clock by the "add more time" button.
      Duration? moreTime,
    })? clock,
    int? daysPerTurn,
    int? startedAtTurn,
    ISet<GameRule>? rules,
    LightOpening? opening,
  }) = _PlayableGameMeta;
}

@freezed
class PlayableClockData with _$PlayableClockData {
  const factory PlayableClockData({
    required bool running,
    required Duration white,
    required Duration black,
  }) = _PlayableClockData;
}

@Freezed(fromJson: true, toJson: true)
class CorrespondenceClockData with _$CorrespondenceClockData {
  const factory CorrespondenceClockData({
    required Duration white,
    required Duration black,
  }) = _CorrespondenceClockData;

  factory CorrespondenceClockData.fromJson(Map<String, dynamic> json) =>
      _$CorrespondenceClockDataFromJson(json);
}

@freezed
class ArchivedGameData with _$ArchivedGameData {
  const ArchivedGameData._();

  const factory ArchivedGameData({
    required GameId id,

    /// If the full game id is available, it means this is a game owned by the
    /// current logged in user.
    GameFullId? fullId,
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
    Move? lastMove,
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
    IList<ExternalEval>? evals,
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
    required Position position,
    SanMove? sanMove,
    MaterialDiff? diff,

    /// The remaining white clock time at this step. Only available when the
    /// game is finished.
    Duration? archivedWhiteClock,

    /// The remaining black clock time at this step. Only available when the
    /// game is finished.
    Duration? archivedBlackClock,
  }) = _GameStep;
}

@freezed
class PostGameData with _$PostGameData {
  const factory PostGameData({
    IList<Duration>? clocks,
    ({PlayerAnalysis white, PlayerAnalysis black})? analysis,
    LightOpening? opening,
    IList<ExternalEval>? evals,
  }) = _PostGameData;
}
