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
      Uri.parse('$kLichessHost/game/export/$id'),
      headers: {'Accept': 'application/json'},
    ).flatMap((response) {
      return readJsonObject(
        response,
        mapper: _makeArchivedGameFromJson,
        logger: _log,
      );
    });
  }

  // TODO parameters
  FutureResult<IList<ArchivedGameData>> getUserGames(UserId userId) {
    return apiClient.get(
      Uri.parse(
        '$kLichessHost/api/games/user/$userId?max=10&moves=false&lastFen=true&accuracy=true',
      ),
      headers: {'Accept': 'application/x-ndjson'},
    ).flatMap(
      (r) => readNdJsonList(
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
          (r) => readNdJsonList(
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

  return ArchivedGame(
    data: data,
    steps: pick('moves').letOrThrow((it) {
      final moves = it.asStringOrThrow().split(' ');
      // assume lichess always send initialFen with fromPosition and chess960
      Position position = (data.variant == Variant.fromPosition ||
              data.variant == Variant.chess960)
          ? Chess.fromSetup(Setup.parseFen(data.initialFen!))
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
    initialFen: pick('initialFen').asStringOrNull(),
    lastFen: pick('lastFen').asStringOrNull(),
    clock: pick('clock').letOrNull(_clockDataFromPick),
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
    inaccuracy: pick('inaccuracy').asIntOrThrow(),
    mistake: pick('mistake').asIntOrThrow(),
    blunder: pick('blunder').asIntOrThrow(),
    acpl: pick('acpl').asIntOrNull(),
    accuracy: pick('accuracy').asIntOrNull(),
  );
}

// Will be needed later

// MoveAnalysis _moveAnalysisFromPick(RequiredPick pick) {
//   return MoveAnalysis(
//     eval: pick('eval').asIntOrNull(),
//     best: pick('best').asStringOrNull(),
//     variation: pick('variant').asStringOrNull(),
//     judgment: pick('judgment').letOrNull(_analysisJudgmentFromPick),
//   );
// }

// AnalysisJudgment _analysisJudgmentFromPick(RequiredPick pick) {
//   return AnalysisJudgment(
//     name: pick('name').asStringOrThrow(),
//     comment: pick('comment').asStringOrThrow(),
//   );
// }
