import 'dart:convert';

import 'package:async/async.dart';
import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/auth/auth_client.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/errors.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/game/playable_game.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'package:logging/logging.dart';
import 'package:result_extensions/result_extensions.dart';

import 'game.dart';
import 'game_status.dart';
import 'material_diff.dart';
import 'player.dart';

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

  /// TODO consider having a separate endpoint to get only the data we need
  /// or having it directly in the websocket message
  FutureResult<PostGameData> getPostGameData(GameId id) {
    return apiClient.get(
      Uri.parse('$kLichessHost/game/export/$id?accuracy=1&clocks=1'),
      headers: {'Accept': 'application/json'},
    ).flatMap((response) {
      return readJsonObjectFromResponse(
        response,
        mapper: _getPostGameDataFromJson,
        logger: _log,
      );
    });
  }

  FutureResult<void> requestServerAnalysis(GameId id) {
    return apiClient.post(
      Uri.parse('$kLichessHost/$id/request-analysis'),
    );
  }

  FutureResult<IList<ArchivedGameData>> getRecentGames(UserId userId) {
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

  /// Returns the games of the current user, given a list of ids.
  FutureResult<IList<PlayableGame>> getMyGamesByIds(ISet<GameId> ids) {
    if (ids.isEmpty) {
      return Future.value(Result.value(IList<PlayableGame>()));
    }
    return apiClient
        .get(
          Uri.parse(
            '$kLichessHost/api/mobile/my-games?ids=${ids.join(',')}',
          ),
        )
        .flatMap(
          (resp) => Result(() {
            final dynamic list = jsonDecode(utf8.decode(resp.bodyBytes));
            if (list is! List<dynamic>) {
              _log.severe(
                'Could not read games from response: ${resp.body}',
              );
              throw DataFormatException();
            }
            return list;
          }).flatMap(
            (list) => readJsonListOfObjects(
              list,
              mapper: PlayableGame.fromServerJson,
              logger: _log,
            ),
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

PostGameData _getPostGameDataFromJson(Map<String, dynamic> json) {
  final pick = Pick(json).required();
  final clocks = pick('clocks').asListOrNull<Duration>(
    (p0) => Duration(milliseconds: p0.asIntOrThrow() * 10),
  );
  final whiteAnalysis = pick('players', 'white', 'analysis').letOrNull(
    (p0) => _playerAnalysisFromPick(p0.required()),
  );
  final blackAnalysis = pick('players', 'black', 'analysis').letOrNull(
    (p0) => _playerAnalysisFromPick(p0.required()),
  );
  return PostGameData(
    clocks: IList(clocks ?? []),
    opening: pick('opening').letOrNull(_openingFromPick),
    evals: _evalsFromPick(pick),
    analysis: whiteAnalysis != null && blackAnalysis != null
        ? (
            white: whiteAnalysis,
            black: blackAnalysis,
          )
        : null,
  );
}

ArchivedGame _makeArchivedGameFromJson(Map<String, dynamic> json) =>
    _archivedGameFromPick(pick(json).required());

ArchivedGame _archivedGameFromPick(RequiredPick pick) {
  final data = _archivedGameDataFromPick(pick);
  final clocks = pick('clocks').asListOrNull<Duration>(
    (p0) => Duration(milliseconds: p0.asIntOrThrow() * 10),
  );

  final initialFen = pick('initialFen').asStringOrNull();

  return ArchivedGame(
    id: data.id,
    meta: GameMeta(
      variant: data.variant,
      speed: data.speed,
      perf: data.perf,
      rated: data.rated,
      clock: data.clock != null
          ? (
              initial: data.clock!.initial,
              increment: data.clock!.increment,
              emergency: null,
              moreTime: null
            )
          : null,
    ),
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
      Position position = (data.variant == Variant.fromPosition ||
              data.variant == Variant.chess960)
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
    evals: _evalsFromPick(pick),
  );
}

IList<ExternalEval>? _evalsFromPick(RequiredPick pick) {
  return pick('analysis')
      .asListOrNull<ExternalEval>(
        (p0) => ExternalEval(
          cp: p0('eval').asIntOrNull(),
          mate: p0('mate').asIntOrNull(),
          bestMove: p0('best').asStringOrNull(),
          variation: p0('variation').asStringOrNull(),
          judgment: p0('judgment').letOrNull(
            (j) => (
              name: j('name').asStringOrThrow(),
              comment: j('comment').asStringOrThrow(),
            ),
          ),
        ),
      )
      ?.lock;
}

ArchivedGameData _makeArchivedGameDataFromJson(Map<String, dynamic> json) =>
    _archivedGameDataFromPick(pick(json).required());

ArchivedGameData _archivedGameDataFromPick(RequiredPick pick) {
  return ArchivedGameData(
    id: pick('id').asGameIdOrThrow(),
    fullId: pick('fullId').asGameFullIdOrNull(),
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
    user: pick('user').asLightUserOrNull(),
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
