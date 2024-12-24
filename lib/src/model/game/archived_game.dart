import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/material_diff.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/json.dart';

part 'archived_game.freezed.dart';
part 'archived_game.g.dart';

typedef ClockData = ({Duration initial, Duration increment});

/// A lichess game exported from the API.
///
/// This represents a game that is finished and can be viewed by anyone, or accessed
/// offline.
///
/// See also [PlayableGame] for a game owned by the current user and that can be
/// played unless finished.
@Freezed(fromJson: true, toJson: true)
class ArchivedGame with _$ArchivedGame, BaseGame, IndexableSteps implements BaseGame {
  const ArchivedGame._();

  @Assert('steps.isNotEmpty')
  factory ArchivedGame({
    required GameId id,
    required GameMeta meta,
    // TODO refactor to not include this field
    required LightArchivedGame data,
    @JsonKey(fromJson: stepsFromJson, toJson: stepsToJson) required IList<GameStep> steps,
    String? initialFen,
    required GameStatus status,
    @JsonKey(defaultValue: GameSource.unknown, unknownEnumValue: GameSource.unknown)
    required GameSource source,
    Side? winner,

    /// The point of view of the current player or null if spectating.
    Side? youAre,
    bool? isThreefoldRepetition,
    required Player white,
    required Player black,
    IList<ExternalEval>? evals,
    IList<Duration>? clocks,
  }) = _ArchivedGame;

  /// Create an archived game from the lichess api.
  ///
  /// Currently, those endpoints are supported:
  /// - GET /game/export/\<id\>
  factory ArchivedGame.fromServerJson(Map<String, dynamic> json) {
    return _archivedGameFromPick(pick(json).required());
  }

  /// Create an archived game from a local storage JSON.
  factory ArchivedGame.fromJson(Map<String, dynamic> json) => _$ArchivedGameFromJson(json);

  /// Player point of view. Null if spectating.
  Player? get me =>
      youAre == null
          ? null
          : youAre == Side.white
          ? white
          : black;

  /// Opponent point of view. Null if spectating.
  Player? get opponent =>
      youAre == null
          ? null
          : youAre == Side.white
          ? black
          : white;
}

/// A [LightArchivedGame] associated with a point of view of a player.
typedef LightArchivedGameWithPov = ({LightArchivedGame game, Side pov});

/// A lichess game exported from the API, with less data than [ArchivedGame].
///
/// This is commonly used to display a list of games.
/// Lichess endpoints that return this data:
/// - GET /api/games/user/\<userId\>
/// - GET /api/games/export/_ids
@Freezed(fromJson: true, toJson: true)
class LightArchivedGame with _$LightArchivedGame {
  const LightArchivedGame._();

  const factory LightArchivedGame({
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
    GameSource? source,
    LightOpening? opening,
    String? lastFen,
    @MoveConverter() Move? lastMove,
    Side? winner,
    ClockData? clock,
  }) = _ArchivedGameData;

  factory LightArchivedGame.fromServerJson(Map<String, dynamic> json) {
    return _lightArchivedGameFromPick(pick(json).required());
  }

  factory LightArchivedGame.fromJson(Map<String, dynamic> json) =>
      _$LightArchivedGameFromJson(json);

  String get clockDisplay {
    return TimeIncrement(clock?.initial.inSeconds ?? 0, clock?.increment.inSeconds ?? 0).display;
  }
}

IList<ExternalEval>? gameEvalsFromPick(RequiredPick pick) {
  return pick('analysis')
      .asListOrNull<ExternalEval>(
        (p0) => ExternalEval(
          cp: p0('eval').asIntOrNull(),
          mate: p0('mate').asIntOrNull(),
          bestMove: p0('best').asStringOrNull(),
          variation: p0('variation').asStringOrNull(),
          judgment: p0('judgment').letOrNull(
            (j) => (name: j('name').asStringOrThrow(), comment: j('comment').asStringOrThrow()),
          ),
        ),
      )
      ?.lock;
}

ArchivedGame _archivedGameFromPick(RequiredPick pick) {
  final data = _lightArchivedGameFromPick(pick);
  final clocks = pick(
    'clocks',
  ).asListOrNull<Duration>((p0) => Duration(milliseconds: p0.asIntOrThrow() * 10));
  final division = pick('division').letOrNull(_divisionFromPick);

  final initialFen = pick('initialFen').asStringOrNull();

  return ArchivedGame(
    id: data.id,
    meta: GameMeta(
      createdAt: data.createdAt,
      variant: data.variant,
      speed: data.speed,
      perf: data.perf,
      rated: data.rated,
      clock:
          data.clock != null
              ? (
                initial: data.clock!.initial,
                increment: data.clock!.increment,
                emergency: null,
                moreTime: null,
              )
              : null,
      opening: data.opening,
      division: division,
    ),
    source: pick(
      'source',
    ).letOrThrow((pick) => GameSource.nameMap[pick.asStringOrThrow()] ?? GameSource.unknown),
    data: data,
    status: data.status,
    winner: data.winner,
    initialFen: initialFen,
    isThreefoldRepetition: pick('threefold').asBoolOrNull(),
    white: data.white,
    black: data.black,
    steps: pick('moves').letOrThrow((it) {
      final moves = it.asStringOrThrow().split(' ');
      // assume lichess always send initialFen with fromPosition and chess960
      Position position =
          (data.variant == Variant.fromPosition || data.variant == Variant.chess960)
              ? Chess.fromSetup(Setup.parseFen(initialFen!))
              : data.variant.initialPosition;
      int index = 0;
      final List<GameStep> steps = [GameStep(position: position)];
      Duration? clock = data.clock?.initial;
      for (final san in moves) {
        final stepClock = clocks?[index];
        index++;
        final move = position.parseSan(san);
        // assume lichess only sends correct moves
        position = position.playUnchecked(move!);
        steps.add(
          GameStep(
            sanMove: SanMove(san, move),
            position: position,
            diff: MaterialDiff.fromBoard(position.board),
            archivedWhiteClock: index.isOdd ? stepClock : clock,
            archivedBlackClock: index.isEven ? stepClock : clock,
          ),
        );
        clock = stepClock;
      }
      return IList(steps);
    }),
    clocks: IList(clocks ?? []),
    evals: gameEvalsFromPick(pick),
  );
}

LightArchivedGame _lightArchivedGameFromPick(RequiredPick pick) {
  return LightArchivedGame(
    id: pick('id').asGameIdOrThrow(),
    fullId: pick('fullId').asGameFullIdOrNull(),
    source: pick(
      'source',
    ).letOrNull((pick) => GameSource.nameMap[pick.asStringOrThrow()] ?? GameSource.unknown),
    rated: pick('rated').asBoolOrThrow(),
    speed: pick('speed').asSpeedOrThrow(),
    perf: pick('perf').asPerfOrThrow(),
    createdAt: pick('createdAt').asDateTimeFromMillisecondsOrThrow(),
    lastMoveAt: pick('lastMoveAt').asDateTimeFromMillisecondsOrThrow(),
    status: pick('status').asGameStatusOrThrow(),
    white: pick('players', 'white').letOrThrow(_playerFromUserGamePick),
    black: pick('players', 'black').letOrThrow(_playerFromUserGamePick),
    winner: pick('winner').asSideOrNull(),
    variant: pick('variant').asVariantOrThrow(),
    lastFen: pick('lastFen').asStringOrNull(),
    lastMove: pick('lastMove').asUciMoveOrNull(),
    clock: pick('clock').letOrNull(_clockDataFromPick),
    opening: pick('opening').letOrNull(_openingFromPick),
  );
}

LightOpening _openingFromPick(RequiredPick pick) {
  return LightOpening(eco: pick('eco').asStringOrThrow(), name: pick('name').asStringOrThrow());
}

ClockData _clockDataFromPick(RequiredPick pick) {
  return (
    initial: pick('initial').asDurationFromSecondsOrThrow(),
    increment: pick('increment').asDurationFromSecondsOrThrow(),
  );
}

Player _playerFromUserGamePick(RequiredPick pick) {
  final originalName = pick('name').asStringOrNull();
  return Player(
    user: pick('user').asLightUserOrNull(),
    name: _removeRatingFromName(originalName),
    rating: pick('rating').asIntOrNull() ?? _extractRatingFromName(originalName),
    ratingDiff: pick('ratingDiff').asIntOrNull(),
    aiLevel: pick('aiLevel').asIntOrNull(),
    analysis: pick('analysis').letOrNull(_playerAnalysisFromPick),
  );
}

int? _extractRatingFromName(String? name) {
  if (name == null) return null;
  final regex = RegExp(r'\((\d+)\)');
  final match = regex.firstMatch(name);
  if (match != null) {
    return int.tryParse(match.group(1)!);
  }
  return null;
}

String? _removeRatingFromName(String? name) {
  if (name == null) return null;
  final regex = RegExp(r'\s*\(\d+\)\s*');
  return name.replaceAll(regex, '');
}

PlayerAnalysis _playerAnalysisFromPick(RequiredPick pick) {
  return PlayerAnalysis(
    inaccuracies: pick('inaccuracy').asIntOrThrow(),
    mistakes: pick('mistake').asIntOrThrow(),
    blunders: pick('blunder').asIntOrThrow(),
    acpl: pick('acpl').asIntOrNull(),
    accuracy: pick('accuracy').asIntOrNull(),
  );
}

Division _divisionFromPick(RequiredPick pick) {
  return Division(
    middlegame: pick('middle').asDoubleOrNull(),
    endgame: pick('end').asDoubleOrNull(),
  );
}
