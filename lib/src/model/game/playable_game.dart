import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/account/account_preferences.dart';
import 'package:lichess_mobile/src/model/chat/chat.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/game/exported_game.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/material_diff.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/json.dart';

part 'playable_game.freezed.dart';

/// A game that can be played or watched.
///
/// The [youAre] field is null if the game is being watched as a spectator, and
/// represents the side that the current player is playing as otherwise.
///
/// Typically used for a game in progress, or a finished game that is owned by
/// the current logged in player.
///
/// See also:
/// - [ExportedGame] for a game that is finished and not owned by the current user.
@freezed
sealed class PlayableGame with _$PlayableGame, BaseGame, IndexableSteps implements BaseGame {
  const PlayableGame._();

  @Assert('steps.isNotEmpty')
  factory PlayableGame({
    required GameId id,
    required GameMeta meta,
    required GameSource source,
    required IList<GameStep> steps,
    String? initialFen,
    required GameStatus status,
    Side? winner,
    required Player white,
    required Player black,
    required bool moretimeable,
    required bool takebackable,
    IList<ExternalEval>? evals,
    IList<Duration>? clocks,

    /// The side that the current player is playing as. This is null if viewing
    /// the game as a spectator.
    Side? youAre,
    bool? bookmarked,
    ServerGamePrefs? prefs,
    PlayableClockData? clock,
    CorrespondenceClockData? correspondenceClock,
    bool? boosted,
    bool? isThreefoldRepetition,
    ({Duration idle, Duration timeToMove, DateTime movedAt})? expiration,
    ChatData? chat,

    /// The game id of the next game if a rematch has been accepted.
    GameId? rematch,
  }) = _PlayableGame;

  /// Create a playable game from the lichess api json.
  ///
  /// Currently, those endpoints are supported:
  /// - GET /api/mobile/my-games
  /// - player game socket (/play/:gameFullId/v6) 'full' event
  /// - watcher game socket (/watch/:gameId/:side/v6) 'full' event
  factory PlayableGame.fromServerJson(Map<String, dynamic> json) {
    return _playableGameFromPick(pick(json).required());
  }

  Side get sideToMove => lastPosition.turn;

  Duration? clockOf(Side side) {
    return clock != null
        ? side == Side.white
            ? clock!.white
            : clock!.black
        : null;
  }

  bool get hasAI => white.isAI || black.isAI;

  bool get imported => source == GameSource.import;

  /// Whether it is the current player's turn.
  bool get isMyTurn => lastPosition.turn == youAre;

  bool get abortable =>
      playable &&
      lastPosition.fullmoves <= 1 &&
      (meta.rules == null || !meta.rules!.contains(GameRule.noAbort));
  bool get resignable => playable && !abortable;
  bool get drawable =>
      playable && lastPosition.fullmoves >= 2 && !(me?.offeringDraw == true) && !hasAI;
  bool get rematchable =>
      meta.tournament == null && (meta.rules == null || !meta.rules!.contains(GameRule.noRematch));
  bool get canTakeback =>
      takebackable &&
      playable &&
      lastPosition.fullmoves >= 2 &&
      !(me?.proposingTakeback == true) &&
      !(opponent?.proposingTakeback == true);
  bool get canGiveTime => moretimeable && playable && clock != null;

  bool get canClaimWin =>
      opponent?.isGone == true &&
      !isMyTurn &&
      resignable &&
      (meta.rules == null || !meta.rules!.contains(GameRule.noClaimWin));

  bool get userAnalysable =>
      finished && steps.length > 4 || (playable && (clock == null || youAre == null));

  ExportedGame toExportedGame({required DateTime finishedAt}) {
    return ExportedGame(
      id: id,
      meta: meta,
      source: source,
      data: LightExportedGame(
        id: id,
        variant: meta.variant,
        lastMoveAt: finishedAt,
        lastFen: lastPosition.fen,
        lastMove: lastMove,
        createdAt: meta.createdAt,
        perf: meta.perf,
        speed: meta.speed,
        rated: meta.rated,
        winner: winner,
        status: status,
        white: white,
        black: black,
        clock:
            meta.clock != null
                ? (initial: meta.clock!.initial, increment: meta.clock!.increment)
                : null,
        opening: meta.opening,
      ),
      initialFen: initialFen,
      steps: steps,
      status: status,
      winner: winner,
      isThreefoldRepetition: isThreefoldRepetition,
      white: white,
      black: black,
      youAre: youAre,
      evals: evals,
      clocks: clocks,
    );
  }
}

@freezed
sealed class PlayableClockData with _$PlayableClockData {
  const PlayableClockData._();

  const factory PlayableClockData({
    required bool running,
    required Duration white,
    required Duration black,

    /// The network lag of the clock.
    ///
    /// Will be sent along with move events.
    required Duration? lag,

    /// The time when the clock event was received.
    required DateTime at,
  }) = _PlayableClockData;

  Duration forSide(Side side) => side == Side.white ? white : black;
}

PlayableGame _playableGameFromPick(RequiredPick pick) {
  final requiredGamePick = pick('game').required();
  final meta = _playableGameMetaFromPick(pick);
  final initialFen = requiredGamePick('initialFen').asStringOrNull();

  // assume lichess always send initialFen with fromPosition and chess960
  Position position =
      (meta.variant == Variant.fromPosition || meta.variant == Variant.chess960)
          ? Chess.fromSetup(Setup.parseFen(initialFen!))
          : meta.variant.initialPosition;

  final steps = [GameStep(position: position)];
  final pgn = pick('game', 'pgn').asStringOrNull();
  final moves = pgn != null && pgn != '' ? pgn.split(' ') : null;
  if (moves != null && moves.isNotEmpty) {
    for (final san in moves) {
      final move = position.parseSan(san);
      // assume lichess only sends correct moves
      position = position.playUnchecked(move!);
      steps.add(
        GameStep(
          sanMove: SanMove(san, move),
          position: position,
          diff: MaterialDiff.fromBoard(position.board),
        ),
      );
    }
  }

  return PlayableGame(
    id: requiredGamePick('id').asGameIdOrThrow(),
    meta: meta,
    source: requiredGamePick(
      'source',
    ).letOrThrow((pick) => GameSource.nameMap[pick.asStringOrThrow()] ?? GameSource.unknown),
    initialFen: initialFen,
    steps: steps.toIList(),
    white: pick('white').letOrThrow(_playerFromUserGamePick),
    black: pick('black').letOrThrow(_playerFromUserGamePick),
    clock: pick('clock').letOrNull(_playableClockDataFromPick),
    correspondenceClock: pick('correspondence').letOrNull(_correspondenceClockDataFromPick),
    status: pick('game', 'status').asGameStatusOrThrow(),
    winner: pick('game', 'winner').asSideOrNull(),
    boosted: pick('game', 'boosted').asBoolOrNull(),
    isThreefoldRepetition: pick('game', 'threefold').asBoolOrNull(),
    moretimeable: pick('moretimeable').asBoolOrFalse(),
    takebackable: pick('takebackable').asBoolOrFalse(),
    youAre: pick('youAre').asSideOrNull(),
    prefs: pick('prefs').letOrNull(_gamePrefsFromPick),
    bookmarked: pick('bookmarked').asBoolOrNull(),
    expiration: pick('expiration').letOrNull((it) {
      final idle = it('idleMillis').asDurationFromMilliSecondsOrThrow();
      return (
        idle: idle,
        timeToMove: it('millisToMove').asDurationFromMilliSecondsOrThrow(),
        movedAt: DateTime.now().subtract(idle),
      );
    }),
    chat: pick('chat').letOrNull((p) => chatDataFromPick(p)),
    rematch: pick('game', 'rematch').asGameIdOrNull(),
  );
}

GameMeta _playableGameMetaFromPick(RequiredPick pick) {
  return GameMeta(
    createdAt: pick('game', 'createdAt').asDateTimeFromMillisecondsOrThrow(),
    rated: pick('game', 'rated').asBoolOrThrow(),
    speed: pick('game', 'speed').asSpeedOrThrow(),
    perf: pick('game', 'perf').asPerfOrThrow(),
    variant: pick('game', 'variant').asVariantOrThrow(),
    clock: pick('clock').letOrNull(
      (cPick) => (
        initial: cPick('initial').asDurationFromSecondsOrThrow(),
        increment: cPick('increment').asDurationFromSecondsOrThrow(),
        emergency: cPick('emerg').asDurationFromSecondsOrNull(),
        moreTime: cPick('moretime').asDurationFromSecondsOrNull(),
      ),
    ),
    daysPerTurn: pick('correspondence').letOrNull((ccPick) => ccPick('daysPerTurn').asIntOrThrow()),
    startedAtTurn: pick('game', 'startedAtTurn').asIntOrNull(),
    rules: pick('game', 'rules').letOrNull(
      (it) => ISet(
        pick.asListOrThrow((e) => GameRule.nameMap[e.asStringOrThrow()] ?? GameRule.unknown),
      ),
    ),
    division: pick('division').letOrNull(_divisionFromPick),
    tournament: pick('tournament').letOrNull(_playableGameTournamentDataFromPick),
  );
}

TournamentMeta? _playableGameTournamentDataFromPick(RequiredPick pick) => TournamentMeta(
  id: pick('id').asTournamentIdOrThrow(),
  name: pick('name').asStringOrThrow(),
  clock: (timeLeft: Duration(seconds: pick('secondsLeft').asIntOrThrow()), at: DateTime.now()),
  berserkable: pick('berserkable').asBoolOrFalse(),
  ranks: pick(
    'ranks',
  ).letOrNull((p) => (white: p('white').asIntOrThrow(), black: p('black').asIntOrThrow())),
);

ServerGamePrefs _gamePrefsFromPick(RequiredPick pick) {
  return ServerGamePrefs(
    showRatings: pick('showRatings').asBoolOrFalse(),
    enablePremove: pick('enablePremove').asBoolOrFalse(),
    autoQueen: AutoQueen.fromInt(pick('autoQueen').asIntOrThrow()),
    confirmResign: pick('confirmResign').asBoolOrFalse(),
    submitMove: pick('submitMove').asBoolOrFalse(),
    zenMode: Zen.fromInt(pick('zen').asIntOrThrow()),
  );
}

Player _playerFromUserGamePick(RequiredPick pick) {
  return Player(
    user: pick('user').asLightUserOrNull(),
    rating: pick('rating').asIntOrNull(),
    provisional: pick('provisional').asBoolOrNull(),
    ratingDiff: pick('ratingDiff').asIntOrNull(),
    aiLevel: pick('aiLevel').asIntOrNull(),
    onGame: pick('onGame').asBoolOrNull(),
    isGone: pick('isGone').asBoolOrNull(),
    offeringDraw: pick('offeringDraw').asBoolOrNull(),
    offeringRematch: pick('offeringRematch').asBoolOrNull(),
    proposingTakeback: pick('proposingTakeback').asBoolOrNull(),
  );
}

PlayableClockData _playableClockDataFromPick(RequiredPick pick) {
  return PlayableClockData(
    running: pick('running').asBoolOrThrow(),
    white: pick('white').asDurationFromSecondsOrThrow(),
    black: pick('black').asDurationFromSecondsOrThrow(),
    lag: pick('lag').letOrNull((it) => Duration(milliseconds: it.asIntOrThrow() * 10)),
    at: DateTime.now(),
  );
}

CorrespondenceClockData _correspondenceClockDataFromPick(RequiredPick pick) {
  return CorrespondenceClockData(
    white: pick('white').asDurationFromSecondsOrThrow(),
    black: pick('black').asDurationFromSecondsOrThrow(),
  );
}

Division _divisionFromPick(RequiredPick pick) {
  return Division(
    middlegame: pick('middle').asDoubleOrNull(),
    endgame: pick('end').asDoubleOrNull(),
  );
}
