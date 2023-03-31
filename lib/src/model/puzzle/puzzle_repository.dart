import 'dart:convert';
import 'package:async/async.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/common/api_client.dart';
import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'puzzle.dart';
import 'puzzle_streak.dart';
import 'puzzle_theme.dart';
import 'puzzle_difficulty.dart';

part 'puzzle_repository.freezed.dart';
part 'puzzle_repository.g.dart';

@Riverpod(keepAlive: true)
PuzzleRepository puzzleRepository(PuzzleRepositoryRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  return PuzzleRepository(Logger('PuzzleRepository'), apiClient: apiClient);
}

/// Repository that interacts with lichess.org puzzle API
class PuzzleRepository {
  const PuzzleRepository(
    Logger log, {
    required this.apiClient,
  }) : _log = log;

  final ApiClient apiClient;
  final Logger _log;

  FutureResult<PuzzleBatchResponse> selectBatch({
    required int nb,
    PuzzleTheme angle = PuzzleTheme.mix,
    PuzzleDifficulty difficulty = PuzzleDifficulty.normal,
  }) {
    return apiClient
        .get(
          Uri.parse(
            '$kLichessHost/api/puzzle/batch/${angle.name}?nb=$nb&difficulty=${difficulty.name}',
          ),
        )
        .flatMap(_decodeBatchResponse);
  }

  FutureResult<PuzzleBatchResponse> solveBatch({
    required int nb,
    required IList<PuzzleSolution> solved,
    PuzzleTheme angle = PuzzleTheme.mix,
    PuzzleDifficulty difficulty = PuzzleDifficulty.normal,
  }) {
    return apiClient
        .post(
          Uri.parse(
            '$kLichessHost/api/puzzle/batch/${angle.name}?nb=$nb&difficulty=${difficulty.name}',
          ),
          headers: {'Content-type': 'application/json'},
          body: jsonEncode({
            'solutions': solved
                .map(
                  (e) => {
                    'id': e.id.value,
                    'win': e.win,
                    'rated': e.rated,
                  },
                )
                .toList(),
          }),
        )
        .flatMap(_decodeBatchResponse);
  }

  FutureResult<Puzzle> fetch(PuzzleId id) {
    return apiClient.get(Uri.parse('$kLichessHost/api/puzzle/$id')).flatMap(
          (response) => readJsonObject(
            response.body,
            mapper: _puzzleFromJson,
            logger: _log,
          ),
        );
  }

  FutureResult<PuzzleStreakResponse> streak() {
    return apiClient
        .get(Uri.parse('$kLichessHost/api/streak'))
        .flatMap((response) {
      return readJsonObject(
        response.body,
        mapper: (Map<String, dynamic> json) {
          return PuzzleStreakResponse(
            puzzle: _puzzleFromPick(pick(json).required()),
            streak: IList(
              pick(json['streak']).asStringOrThrow().split(' ').map(
                    (e) => PuzzleId(e),
                  ),
            ),
          );
        },
        logger: _log,
      );
    });
  }

  FutureResult<void> postStreakRun(int run) {
    return apiClient.post(
      Uri.parse('$kLichessHost/api/streak/$run'),
    );
  }

  FutureResult<Puzzle> daily() {
    return apiClient.get(Uri.parse('$kLichessHost/api/puzzle/daily')).flatMap(
          (response) => readJsonObject(
            response.body,
            mapper: _puzzleFromJson,
            logger: _log,
          ).map(
            (puzzle) => puzzle.copyWith(
              isDailyPuzzle: true,
            ),
          ),
        );
  }

  FutureResult<PuzzleDashboard> puzzleDashboard(int days) {
    return apiClient
        .get(Uri.parse('$kLichessHost/api/puzzle/dashboard/$days'))
        .flatMap((response) {
      return readJsonObject(
        response.body,
        mapper: _puzzleDashboardFromJson,
        logger: _log,
      );
    });
  }

  Result<PuzzleBatchResponse> _decodeBatchResponse(http.Response response) {
    return readJsonObject(
      response.body,
      mapper: (Map<String, dynamic> json) {
        final puzzles = json['puzzles'];
        if (puzzles is! List<dynamic>) {
          throw const FormatException('puzzles: expected a list');
        }
        return PuzzleBatchResponse(
          puzzles: IList(
            puzzles.map((e) {
              if (e is! Map<String, dynamic>) {
                throw const FormatException('Expected an object');
              }
              return _puzzleFromJson(e);
            }),
          ),
          glicko: pick(json['glicko']).letOrNull(_puzzleGlickoFromPick),
          rounds: pick(json['rounds']).letOrNull(
            (p0) => IList(
              p0.asListOrNull(
                (p1) => _puzzleRoundFromPick(p1),
              ),
            ),
          ),
        );
      },
      logger: _log,
    );
  }
}

@freezed
class PuzzleBatchResponse with _$PuzzleBatchResponse {
  const factory PuzzleBatchResponse({
    required IList<Puzzle> puzzles,
    PuzzleGlicko? glicko,
    IList<PuzzleRound>? rounds,
  }) = _PuzzleBatchResponse;
}

@freezed
class PuzzleStreakResponse with _$PuzzleStreakResponse {
  const factory PuzzleStreakResponse({
    required Puzzle puzzle,
    required PuzzleStreak streak,
  }) = _PuzzleStreakResponse;
}

// --

Puzzle _puzzleFromJson(Map<String, dynamic> json) =>
    _puzzleFromPick(pick(json).required());

PuzzleDashboard _puzzleDashboardFromJson(Map<String, dynamic> json) =>
    _puzzleDashboardFromPick(pick(json).required());

Puzzle _puzzleFromPick(RequiredPick pick) {
  return Puzzle(
    puzzle: pick('puzzle').letOrThrow(_puzzleDatafromPick),
    game: pick('game').letOrThrow(_puzzleGameFromPick),
  );
}

PuzzleData _puzzleDatafromPick(RequiredPick pick) {
  return PuzzleData(
    id: pick('id').asPuzzleIdOrThrow(),
    rating: pick('rating').asIntOrThrow(),
    plays: pick('plays').asIntOrThrow(),
    initialPly: pick('initialPly').asIntOrThrow(),
    solution: pick('solution').asListOrThrow((p0) => p0.asStringOrThrow()).lock,
    themes:
        pick('themes').asListOrThrow((p0) => p0.asStringOrThrow()).toSet().lock,
  );
}

PuzzleGlicko _puzzleGlickoFromPick(RequiredPick pick) {
  return PuzzleGlicko(
    rating: pick('rating').asDoubleOrThrow(),
    deviation: pick('deviation').asDoubleOrThrow(),
    provisional: pick('provisional').asBoolOrNull(),
  );
}

PuzzleRound _puzzleRoundFromPick(RequiredPick pick) {
  return PuzzleRound(
    id: pick('id').asPuzzleIdOrThrow(),
    ratingDiff: pick('ratingDiff').asIntOrThrow(),
    win: pick('win').asBoolOrThrow(),
  );
}

PuzzleGame _puzzleGameFromPick(RequiredPick pick) {
  return PuzzleGame(
    id: pick('id').asGameIdOrThrow(),
    perf: pick('perf', 'key').asPerfOrThrow(),
    rated: pick('rated').asBoolOrThrow(),
    white: pick('players').letOrThrow(
      (it) => it
          .asListOrThrow(_puzzlePlayerFromPick)
          .firstWhere((p) => p.side == Side.white),
    ),
    black: pick('players').letOrThrow(
      (it) => it
          .asListOrThrow(_puzzlePlayerFromPick)
          .firstWhere((p) => p.side == Side.black),
    ),
    pgn: pick('pgn').asStringOrThrow(),
    clock: pick('clock').letOrNull(
      (p) =>
          TimeIncrement.fromString(p.asStringOrThrow()) ??
          const TimeIncrement(0, 0),
    ),
  );
}

PuzzleGamePlayer _puzzlePlayerFromPick(RequiredPick pick) {
  return PuzzleGamePlayer(
    name: pick('name').asStringOrThrow(),
    userId: pick('userId').asUserIdOrThrow(),
    side: pick('color').asSideOrThrow(),
    title: pick('title').asStringOrNull(),
  );
}

PuzzleDashboard _puzzleDashboardFromPick(RequiredPick pick) => PuzzleDashboard(
      global: PuzzleDashboardData(
        nb: pick('global')('nb').asIntOrThrow(),
        firstWins: pick('global')('firstWins').asIntOrThrow(),
        replayWins: pick('global')('replayWins').asIntOrThrow(),
        performance: pick('global')('performance').asIntOrThrow(),
        theme: PuzzleTheme.mix,
      ),
      themes: pick('themes')
          .asMapOrThrow<String, Map<String, dynamic>>()
          .keys
          .map(
            (key) => _puzzleDashboardDataFromPick(
              pick('themes')(key)('results').required(),
              key,
            ),
          )
          .toIList(),
    );

PuzzleDashboardData _puzzleDashboardDataFromPick(
  RequiredPick results,
  String themeKey,
) =>
    PuzzleDashboardData(
      nb: results('nb').asIntOrThrow(),
      firstWins: results('firstWins').asIntOrThrow(),
      replayWins: results('replayWins').asIntOrThrow(),
      performance: results('performance').asIntOrThrow(),
      theme: puzzleThemeNameMap.get(themeKey) ?? PuzzleTheme.mix,
    );
