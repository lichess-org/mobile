import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_difficulty.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_opening.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_streak.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_theme.dart';
import 'package:lichess_mobile/src/model/puzzle/storm.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/json.dart';

part 'puzzle_repository.freezed.dart';

class PuzzleRepository {
  PuzzleRepository(this.client);

  final LichessClient client;

  Future<PuzzleBatchResponse> selectBatch({
    required int nb,
    PuzzleAngle angle = const PuzzleTheme(PuzzleThemeKey.mix),
    PuzzleDifficulty difficulty = PuzzleDifficulty.normal,
  }) {
    return client.readJson(
      Uri(
        path: '/api/puzzle/batch/${angle.key}',
        queryParameters: {'nb': nb.toString(), 'difficulty': difficulty.name},
      ),
      mapper: _decodeBatchResponse,
    );
  }

  Future<PuzzleBatchResponse> solveBatch({
    required int nb,
    required IList<PuzzleSolution> solved,
    PuzzleAngle angle = const PuzzleTheme(PuzzleThemeKey.mix),
    PuzzleDifficulty difficulty = PuzzleDifficulty.normal,
  }) {
    return client.postReadJson(
      Uri(
        path: '/api/puzzle/batch/${angle.key}',
        queryParameters: {'nb': nb.toString(), 'difficulty': difficulty.name},
      ),
      headers: {'Content-type': 'application/json'},
      body: jsonEncode({
        'solutions': solved.map((e) => {'id': e.id, 'win': e.win, 'rated': e.rated}).toList(),
      }),
      mapper: _decodeBatchResponse,
    );
  }

  Future<Puzzle> fetch(PuzzleId id) {
    return client.readJson(Uri(path: '/api/puzzle/$id'), mapper: _puzzleFromJson);
  }

  Future<PuzzleStreakResponse> streak() {
    return client.readJson(
      Uri(path: '/api/streak'),
      mapper: (Map<String, dynamic> json) {
        return PuzzleStreakResponse(
          puzzle: _puzzleFromPick(pick(json).required()),
          streak: IList(pick(json['streak']).asStringOrThrow().split(' ').map((e) => PuzzleId(e))),
          timestamp: DateTime.now(),
        );
      },
    );
  }

  Future<void> postStreakRun(int run) async {
    final uri = Uri(path: '/api/streak/$run');
    final response = await client.post(uri);
    if (response.statusCode >= 400) {
      throw http.ClientException('Failed to post streak run: ${response.statusCode}', uri);
    }
  }

  Future<PuzzleStormResponse> storm() {
    return client.readJson(
      Uri(path: '/api/storm'),
      mapper: (Map<String, dynamic> json) {
        return PuzzleStormResponse(
          puzzles: IList(pick(json['puzzles']).asListOrThrow(_litePuzzleFromPick)),
          highscore: pick(json['high']).letOrNull(_stormHighScoreFromPick),
          key: pick(json['key']).asStringOrNull(),
          timestamp: DateTime.now(),
        );
      },
    );
  }

  Future<StormNewHigh?> postStormRun(StormRunStats stats) {
    final Map<String, String> body = {
      'puzzles': stats.history.length.toString(),
      'score': stats.score.toString(),
      'moves': stats.moves.toString(),
      'errors': stats.errors.toString(),
      'combo': stats.comboBest.toString(),
      'time': stats.time.inSeconds.toString(),
      'highest': stats.highest.toString(),
      'notAnExploit':
          "Yes, we know that you can send whatever score you like. That's why there's no leaderboards and no competition.",
    };

    return client.postReadJson(
      Uri(path: '/storm'),
      body: body,
      mapper: (Map<String, dynamic> json) {
        return pick(json['newHigh']).letOrNull(
          (p) => StormNewHigh(
            key: p('key').asStormNewHighTypeOrThrow(),
            prev: p('prev').asIntOrThrow(),
          ),
        );
      },
    );
  }

  Future<Puzzle> daily() {
    return client
        .readJson(Uri(path: '/api/puzzle/daily'), mapper: _puzzleFromJson)
        .then((puzzle) => puzzle.copyWith(isDailyPuzzle: true));
  }

  Future<PuzzleDashboard> puzzleDashboard(int days) {
    return client.readJson(
      Uri(path: '/api/puzzle/dashboard/$days'),
      mapper: _puzzleDashboardFromJson,
    );
  }

  Future<IList<PuzzleHistoryEntry>> puzzleActivity(int max, {DateTime? before}) {
    return client.readNdJsonList(
      Uri(
        path: '/api/puzzle/activity',
        queryParameters: {
          'max': max.toString(),
          if (before != null) 'before': before.millisecondsSinceEpoch.toString(),
        },
      ),
      mapper: _puzzleActivityFromJson,
    );
  }

  Future<StormDashboard> stormDashboard(UserId userId) {
    return client.readJson(
      Uri(path: '/api/storm/dashboard/$userId'),
      mapper: _stormDashboardFromJson,
    );
  }

  Future<IMap<PuzzleThemeKey, PuzzleThemeData>> puzzleThemes() {
    return client.readJson(
      Uri(path: '/training/themes'),
      headers: {'Accept': 'application/json'},
      mapper: _puzzleThemeFromJson,
    );
  }

  Future<IList<PuzzleOpeningFamily>> puzzleOpenings() {
    return client.readJson(
      Uri(path: '/training/openings'),
      headers: {'Accept': 'application/json'},
      mapper: _puzzleOpeningFromJson,
    );
  }

  PuzzleBatchResponse _decodeBatchResponse(Map<String, dynamic> json) {
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
      rounds: pick(
        json['rounds'],
      ).letOrNull((p0) => IList(p0.asListOrNull((p1) => _puzzleRoundFromPick(p1)))),
    );
  }
}

@freezed
sealed class PuzzleBatchResponse with _$PuzzleBatchResponse {
  const factory PuzzleBatchResponse({
    required IList<Puzzle> puzzles,
    PuzzleGlicko? glicko,
    IList<PuzzleRound>? rounds,
  }) = _PuzzleBatchResponse;
}

@freezed
sealed class PuzzleStreakResponse with _$PuzzleStreakResponse {
  const factory PuzzleStreakResponse({
    required Puzzle puzzle,
    required Streak streak,

    /// Timestamp of the response, used as streak unique identifier.
    ///
    /// This field is not returned by the API but it is used to force the
    /// [puzzleControllerProvider] to recompute when the streak provider is invalidated
    /// and the server sends again the exact same streak data.
    required DateTime timestamp,
  }) = _PuzzleStreakResponse;
}

@freezed
sealed class PuzzleStormResponse with _$PuzzleStormResponse {
  const factory PuzzleStormResponse({
    required IList<LitePuzzle> puzzles,
    required String? key,
    required PuzzleStormHighScore? highscore,

    /// Timestamp of the response, used as storm unique identifier.
    ///
    /// This field is not returned by the API but it is used to force the
    /// stormControllerProvider to recompute when the storm provider is invalidated
    /// and the server sends again the exact same storm data.
    required DateTime timestamp,
  }) = _PuzzleStormResponse;
}

// --

PuzzleHistoryEntry _puzzleActivityFromJson(Map<String, dynamic> json) =>
    _historyPuzzleFromPick(pick(json).required());

Puzzle _puzzleFromJson(Map<String, dynamic> json) => _puzzleFromPick(pick(json).required());

PuzzleDashboard _puzzleDashboardFromJson(Map<String, dynamic> json) =>
    _puzzleDashboardFromPick(pick(json).required());

IMap<PuzzleThemeKey, PuzzleThemeData> _puzzleThemeFromJson(Map<String, dynamic> json) =>
    _puzzleThemeFromPick(pick(json).required());

IList<PuzzleOpeningFamily> _puzzleOpeningFromJson(Map<String, dynamic> json) =>
    _puzzleOpeningFromPick(pick(json).required());

Puzzle _puzzleFromPick(RequiredPick pick) {
  return Puzzle(
    puzzle: pick('puzzle').letOrThrow(_puzzleDatafromPick),
    game: pick('game').letOrThrow(_puzzleGameFromPick),
  );
}

StormDashboard _stormDashboardFromJson(Map<String, dynamic> json) =>
    _stormDashboardFromPick(pick(json).required());

StormDashboard _stormDashboardFromPick(RequiredPick pick) {
  final dateFormat = DateFormat('yyyy/M/d');
  return StormDashboard(
    highScore: PuzzleStormHighScore(
      day: pick('high', 'day').asIntOrThrow(),
      allTime: pick('high', 'allTime').asIntOrThrow(),
      month: pick('high', 'month').asIntOrThrow(),
      week: pick('high', 'week').asIntOrThrow(),
    ),
    dayHighscores: pick('days').asListOrThrow((p0) => _stormDayFromPick(p0, dateFormat)).toIList(),
  );
}

StormDayScore _stormDayFromPick(RequiredPick pick, DateFormat format) => StormDayScore(
  runs: pick('runs').asIntOrThrow(),
  score: pick('score').asIntOrThrow(),
  time: pick('time').asIntOrThrow(),
  highest: pick('highest').asIntOrThrow(),
  day: format.parse(pick('_id').asStringOrThrow()),
);

LitePuzzle _litePuzzleFromPick(RequiredPick pick) {
  return LitePuzzle(
    id: pick('id').asPuzzleIdOrThrow(),
    fen: pick('fen').asStringOrThrow(),
    solution: pick('line').asStringOrThrow().split(' ').toIList(),
    rating: pick('rating').asIntOrThrow(),
  );
}

PuzzleStormHighScore _stormHighScoreFromPick(RequiredPick pick) {
  return PuzzleStormHighScore(
    allTime: pick('allTime').asIntOrThrow(),
    day: pick('day').asIntOrThrow(),
    month: pick('month').asIntOrThrow(),
    week: pick('week').asIntOrThrow(),
  );
}

PuzzleData _puzzleDatafromPick(RequiredPick pick) {
  return PuzzleData(
    id: pick('id').asPuzzleIdOrThrow(),
    rating: pick('rating').asIntOrThrow(),
    plays: pick('plays').asIntOrThrow(),
    initialPly: pick('initialPly').asIntOrThrow(),
    solution: pick('solution').asListOrThrow((p0) => p0.asStringOrThrow()).lock,
    themes: pick('themes').asListOrThrow((p0) => p0.asStringOrThrow()).toSet().lock,
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
      (it) => it.asListOrThrow(_puzzlePlayerFromPick).firstWhere((p) => p.side == Side.white),
    ),
    black: pick('players').letOrThrow(
      (it) => it.asListOrThrow(_puzzlePlayerFromPick).firstWhere((p) => p.side == Side.black),
    ),
    pgn: pick('pgn').asStringOrThrow(),
  );
}

PuzzleGamePlayer _puzzlePlayerFromPick(RequiredPick pick) {
  return PuzzleGamePlayer(
    name: pick('name').asStringOrThrow(),
    side: pick('color').asSideOrThrow(),
    title: pick('title').asStringOrNull(),
  );
}

PuzzleHistoryEntry _historyPuzzleFromPick(RequiredPick pick) {
  return PuzzleHistoryEntry(
    win: pick('win').asBoolOrThrow(),
    date: pick('date').asDateTimeFromMillisecondsOrThrow(),
    rating: pick('puzzle', 'rating').asIntOrThrow(),
    id: pick('puzzle', 'id').asPuzzleIdOrThrow(),
    fen: pick('puzzle', 'fen').asStringOrThrow(),
    lastMove: pick('puzzle', 'lastMove').asUciMoveOrThrow(),
  );
}

PuzzleDashboard _puzzleDashboardFromPick(RequiredPick pick) => PuzzleDashboard(
  global: PuzzleDashboardData(
    nb: pick('global')('nb').asIntOrThrow(),
    firstWins: pick('global')('firstWins').asIntOrThrow(),
    replayWins: pick('global')('replayWins').asIntOrThrow(),
    performance: pick('global')('performance').asIntOrThrow(),
    theme: PuzzleThemeKey.mix,
  ),
  themes:
      pick('themes')
          .asMapOrThrow<String, Map<String, dynamic>>()
          .keys
          .map(
            (key) => _puzzleDashboardDataFromPick(pick('themes')(key)('results').required(), key),
          )
          .toIList(),
);

PuzzleDashboardData _puzzleDashboardDataFromPick(RequiredPick results, String themeKey) =>
    PuzzleDashboardData(
      nb: results('nb').asIntOrThrow(),
      firstWins: results('firstWins').asIntOrThrow(),
      replayWins: results('replayWins').asIntOrThrow(),
      performance: results('performance').asIntOrThrow(),
      theme: puzzleThemeNameMap.get(themeKey) ?? PuzzleThemeKey.mix,
    );

IMap<PuzzleThemeKey, PuzzleThemeData> _puzzleThemeFromPick(RequiredPick pick) {
  final themeMap = puzzleThemeNameMap;
  final Map<PuzzleThemeKey, PuzzleThemeData> result = {};
  pick('themes').asMapOrThrow<String, dynamic>().keys.forEach((name) {
    pick('themes', name)
        .asListOrThrow((listPick) {
          return PuzzleThemeData(
            count: listPick('count').asIntOrThrow(),
            desc: listPick('desc').asStringOrThrow(),
            key: themeMap[listPick('key').asStringOrThrow()] ?? PuzzleThemeKey.unsupported,
            name: listPick('name').asStringOrThrow(),
          );
        })
        .whereNot((e) => e.key == PuzzleThemeKey.unsupported)
        .forEach((e) {
          result[e.key] = e;
        });
  });

  return result.lock;
}

IList<PuzzleOpeningFamily> _puzzleOpeningFromPick(RequiredPick pick) {
  return pick('openings').asListOrThrow((openingPick) {
    final familyPick = openingPick('family');
    final openings = openingPick('openings').asListOrNull(
      (openPick) => (
        key: openPick('key').asStringOrThrow(),
        name: openPick('name').asStringOrThrow(),
        count: openPick('count').asIntOrThrow(),
      ),
    );

    return (
      key: familyPick('key').asStringOrThrow(),
      name: familyPick('name').asStringOrThrow(),
      count: familyPick('count').asIntOrThrow(),
      openings: openings != null ? openings.toIList() : IList<PuzzleOpeningData>(const []),
    );
  }).toIList();
}
