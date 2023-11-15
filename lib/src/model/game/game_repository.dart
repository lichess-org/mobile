import 'dart:convert';
import 'package:result_extensions/result_extensions.dart';
import 'package:logging/logging.dart';
import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/auth/auth_client.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/utils/json.dart';

import 'game.dart';
import 'game_status.dart';
import 'player.dart';
import 'material_diff.dart';

class GameRepository {
  const GameRepository(
    Logger log, {
    required this.apiClient,
  }) : _log = log;

  final AuthClient apiClient;
  final Logger _log;

  FutureResult<ArchivedGame> getGame(GameId id) {
    return apiClient.get(
      Uri.parse('$kLichessHost/game/export/$id?accuracy=1&clocks=1'),
      headers: {'Accept': 'application/json'},
    ).flatMap((response) {
      return readJsonObjectFromResponse(
        response,
        mapper: _makeArchivedGameFromJson,
        logger: _log,
      );
    });
  }

  FutureResult<String> getGameAnalysisPgn(GameId id) {
    return apiClient.get(
      Uri.parse('$kLichessHost/game/export/$id?literate=1&clocks=0'),
      headers: {'Accept': 'application/x-chess-pgn'},
    ).map((r) => utf8.decode(r.bodyBytes));
  }

  // TODO parameters
  FutureResult<IList<ArchivedGameData>> getUserGames(UserId userId) {
    return apiClient.get(
      Uri.parse(
        '$kLichessHost/api/games/user/$userId?max=10&moves=false&lastFen=true&accuracy=true&opening=true',
      ),
      headers: {'Accept': 'application/x-ndjson'},
    ).flatMap(
      (r) => readNdJsonListFromResponse(
        r,
        mapper: _makeArchivedGameDataFromJson,
        logger: _log,
      ),
    );
  }

  FutureResult<IList<ArchivedGameData>> getGamesByIds(ISet<GameId> ids) {
    return apiClient
        .post(
          Uri.parse(
            '$kLichessHost/api/games/export/_ids?moves=false&lastFen=true',
          ),
          headers: {'Accept': 'application/x-ndjson'},
          body: ids.join(','),
        )
        .flatMap(
          (r) => readNdJsonListFromResponse(
            r,
            mapper: _makeArchivedGameDataFromJson,
            logger: _log,
          ),
        );
  }
}

// --

ArchivedGame _makeArchivedGameFromJson(Map<String, dynamic> json) =>
    _archivedGameFromPick(pick(json).required());

ArchivedGame _archivedGameFromPick(RequiredPick pick) {
  final data = _archivedGameDataFromPick(pick);
  final clocks = pick('clocks').asListOrNull<Duration>(
    (p0) => Duration(milliseconds: p0.asIntOrThrow() * 10),
  );

  final initialFen = pick('initialFen').asStringOrNull();

  return ArchivedGame(
    data: data,
    perf: data.perf,
    speed: data.speed,
    status: data.status,
    winner: data.winner,
    variant: data.variant,
    initialFen: initialFen,
    isThreefoldRepetition: pick('threefold').asBoolOrNull(),
    white: data.white,
    black: data.black,
    steps: pick('moves').letOrThrow((it) {
      final moves = it.asStringOrThrow().split(' ');
      // assume lichess always send initialFen with fromPosition and chess960
      Position position = (data.variant == Variant.fromPosition ||
              data.variant == Variant.chess960)
          ? Chess.fromSetup(Setup.parseFen(initialFen!))
          : data.variant.initialPosition;
      int index = 0;
      final List<GameStep> steps = [GameStep(ply: index, position: position)];
      Duration? clock = data.clock?.initial;
      for (final san in moves) {
        final stepClock = clocks?[index];
        index++;
        final move = position.parseSan(san);
        // assume lichess only sends correct moves
        position = position.playUnchecked(move!);
        steps.add(
          GameStep(
            ply: index,
            sanMove: SanMove(san, move),
            position: position,
            diff: MaterialDiff.fromBoard(position.board),
            whiteClock: index.isOdd ? stepClock : clock,
            blackClock: index.isEven ? stepClock : clock,
          ),
        );
        clock = stepClock;
      }
      return IList(steps);
    }),
  );
}

ArchivedGameData _makeArchivedGameDataFromJson(Map<String, dynamic> json) =>
    _archivedGameDataFromPick(pick(json).required());

ArchivedGameData _archivedGameDataFromPick(RequiredPick pick) {
  return ArchivedGameData(
    id: pick('id').asGameIdOrThrow(),
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
    clock: pick('clock').letOrNull(_clockDataFromPick),
    opening: pick('opening').letOrNull(_openingFromPick),
  );
}

LightOpening _openingFromPick(RequiredPick pick) {
  return LightOpening(
    eco: pick('eco').asStringOrThrow(),
    name: pick('name').asStringOrThrow(),
  );
}

ClockData _clockDataFromPick(RequiredPick pick) {
  return ClockData(
    initial: pick('initial').asDurationFromSecondsOrThrow(),
    increment: pick('increment').asDurationFromSecondsOrThrow(),
  );
}

Player _playerFromUserGamePick(RequiredPick pick) {
  return Player(
    id: pick('user', 'id').asUserIdOrNull(),
    name: pick('user', 'name').asStringOrNull(),
    patron: pick('user', 'patron').asBoolOrNull(),
    title: pick('user', 'title').asStringOrNull(),
    rating: pick('rating').asIntOrNull(),
    ratingDiff: pick('ratingDiff').asIntOrNull(),
    aiLevel: pick('aiLevel').asIntOrNull(),
    analysis: pick('analysis').letOrNull(_playerAnalysisFromPick),
  );
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
