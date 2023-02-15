import 'dart:convert';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:result_extensions/result_extensions.dart';
import 'package:logging/logging.dart';
import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/common/errors.dart';
import 'package:lichess_mobile/src/common/api_client.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/utils/json.dart';

import 'game.dart';
import 'player.dart';

class GameRepository {
  const GameRepository(
    Logger log, {
    required this.apiClient,
  }) : _log = log;

  final ApiClient apiClient;
  final Logger _log;

  FutureResult<ArchivedGame> getGame(GameId id) {
    return apiClient.get(
      Uri.parse('$kLichessHost/game/export/$id'),
      headers: {'Accept': 'application/json'},
    ).flatMap((response) {
      return readJsonObject(
        response.body,
        mapper: _makeArchivedGameFromJson,
        logger: _log,
      );
    });
  }

  // TODO parameters
  FutureResult<IList<ArchivedGameData>> getUserGames(UserId userId) {
    return apiClient.get(
      Uri.parse(
        '$kLichessHost/api/games/user/$userId?max=10&moves=false&lastFen=true',
      ),
      headers: {'Accept': 'application/x-ndjson'},
    ).flatMap(_decodeNdJsonGames);
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
        .flatMap(_decodeNdJsonGames);
  }

  Result<IList<ArchivedGameData>> _decodeNdJsonGames(http.Response response) {
    return Result(() {
      final lines = response.body.split('\n');
      return IList(
        lines.where((e) => e.isNotEmpty && e != '\n').map((e) {
          final json = jsonDecode(e) as Map<String, dynamic>;
          return _makeArchivedGameDataFromJson(json);
        }),
      );
    }).mapError((error, _) {
      _log.severe('Could not read json object as ArchivedGame: $error');
      return DataFormatException();
    });
  }
}

// --

ArchivedGame _makeArchivedGameFromJson(Map<String, dynamic> json) =>
    _archivedGameFromPick(pick(json).required());

ArchivedGame _archivedGameFromPick(RequiredPick pick) {
  final data = _archivedGameDataFromPick(pick);
  final clockData = pick('clock').letOrNull(_clockDataFromPick);
  final clocks = pick('clocks').asListOrNull<Duration>(
    (p0) => Duration(milliseconds: p0.asIntOrThrow() * 10),
  );

  return ArchivedGame(
    data: data,
    steps: pick('moves').letOrThrow((it) {
      final moves = it.asStringOrThrow().split(' ');
      final List<GameStep> steps = [];
      // assume lichess always send initialFen with fromPosition
      Position position = data.variant == Variant.fromPosition
          ? Chess.fromSetup(Setup.parseFen(data.initialFen!))
          : data.variant.initialPosition;
      int ply = 0;
      Duration? clock = clockData?.initial;
      for (final san in moves) {
        final stepClock = clocks?[ply];
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
            whiteClock: ply.isOdd ? stepClock : clock,
            blackClock: ply.isEven ? stepClock : clock,
          ),
        );
        clock = stepClock;
      }
      return IList(steps);
    }),
    clock: clockData,
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
    name: pick('user', 'name').asStringOrNull() ?? 'Stockfish',
    patron: pick('user', 'patron').asBoolOrNull(),
    title: pick('user', 'title').asStringOrNull(),
    rating: pick('rating').asIntOrNull(),
    ratingDiff: pick('ratingDiff').asIntOrNull(),
    aiLevel: pick('aiLevel').asIntOrNull(),
  );
}

// Will be needed later

// PlayerAnalysis _playerAnalysisFromPick(RequiredPick pick) {
//   return PlayerAnalysis(
//     inaccuracy: pick('inaccuracy').asIntOrThrow(),
//     mistake: pick('mistake').asIntOrThrow(),
//     blunder: pick('blunder').asIntOrThrow(),
//     acpl: pick('acpl').asIntOrNull(),
//   );
// }

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
