import 'dart:convert';
import 'package:async/async.dart';
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
import 'puzzle_theme.dart';

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

  FutureResult<IList<Puzzle>> selectBatch({
    PuzzleTheme angle = PuzzleTheme.mix,
    required int nb,
  }) {
    return apiClient
        .get(Uri.parse('$kLichessHost/api/puzzle/batch/${angle.name}?nb=$nb'))
        .flatMap(_decodeJsonList);
  }

  FutureResult<IList<Puzzle>> solveBatch({
    required int nb,
    required IList<PuzzleSolution> solved,
    PuzzleTheme angle = PuzzleTheme.mix,
  }) {
    return apiClient
        .post(
          Uri.parse('$kLichessHost/api/puzzle/batch/${angle.name}?nb=$nb'),
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
        .flatMap(_decodeJsonList);
  }

  FutureResult<Puzzle> daily() {
    return apiClient.get(Uri.parse('$kLichessHost/api/puzzle/daily')).flatMap(
          (response) => readJsonObject(
            response.body,
            mapper: _puzzleFromJson,
            logger: _log,
          ),
        );
  }

  Result<IList<Puzzle>> _decodeJsonList(http.Response response) {
    return readJsonObject(
      response.body,
      mapper: (Map<String, dynamic> json) {
        final puzzles = json['puzzles'];
        if (puzzles is! List<dynamic>) {
          throw const FormatException('puzzles: expected a list');
        }
        return IList(
          puzzles.map((e) {
            if (e is! Map<String, dynamic>) {
              throw const FormatException('Expected an object');
            }
            return _puzzleFromJson(e);
          }),
        );
      },
      logger: _log,
    );
  }
}

// --

Puzzle _puzzleFromJson(Map<String, dynamic> json) =>
    _puzzleFromPick(pick(json).required());

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
    userId: pick('userId').asStringOrThrow(),
    side: pick('color').asSideOrThrow(),
    title: pick('title').asStringOrNull(),
  );
}
