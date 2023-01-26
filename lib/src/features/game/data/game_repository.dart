import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/common/errors.dart';
import 'package:lichess_mobile/src/common/http.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import './api_event.dart';
import './game_event.dart';
import '../model/game.dart';

final gameRepositoryProvider = Provider<GameRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final repo = GameRepository(Logger('GameRepository'), apiClient: apiClient);
  ref.onDispose(() => repo.dispose());
  return repo;
});

class GameRepository {
  const GameRepository(
    Logger log, {
    required this.apiClient,
  }) : _log = log;

  final ApiClient apiClient;
  final Logger _log;

  TaskEither<IOError, ArchivedGame> getGameTask(GameId id) {
    return apiClient
        .get(Uri.parse('$kLichessHost/game/export/$id'))
        .flatMap((response) {
      return TaskEither.fromEither(readJsonObject(response.body,
          mapper: _makeArchivedGamefromJson, logger: _log));
    });
  }

  // TODO parameters
  TaskEither<IOError, List<ArchivedGame>> getUserGamesTask(String username) {
    return apiClient.get(
      Uri.parse('$kLichessHost/api/games/user/$username?max=10'),
      headers: {'Accept': 'application/x-ndjson'},
    ).flatMap((r) => TaskEither.fromEither(Either.tryCatch(() {
          final lines = r.body.split('\n');
          return lines.where((e) => e.isNotEmpty && e != '\n').map((e) {
            final json = jsonDecode(e) as Map<String, dynamic>;
            return _makeArchivedGamefromJson(json);
          }).toList(growable: false);
        }, (error, stackTrace) {
          _log.severe('Could not read json object as ArchivedGame: $error');
          return DataFormatError(stackTrace);
        })));
  }

  /// Stream the events reaching a lichess user in real time as ndjson.
  Stream<ApiEvent> events() async* {
    final resp =
        await apiClient.stream(Uri.parse('$kLichessHost/api/stream/event'));
    _log.fine('Start streaming events.');
    yield* resp.stream
        .toStringStream()
        .where((event) => event.isNotEmpty && event != '\n')
        .map((event) => jsonDecode(event) as Map<String, dynamic>)
        .where((json) =>
            json['type'] == 'gameStart' || json['type'] == 'gameFinish')
        .map((json) => ApiEvent.fromJson(json))
        .handleError((Object error) => _log.warning(error));
  }

  /// Stream the state of a game being played with the Board API, as ndjson.
  Stream<GameEvent> gameStateEvents(GameId id) async* {
    final resp = await apiClient
        .stream(Uri.parse('$kLichessHost/api/board/game/stream/$id'));
    yield* resp.stream
        .toStringStream()
        .where((event) => event.isNotEmpty && event != '\n')
        .map((event) => jsonDecode(event) as Map<String, dynamic>)
        .where((event) =>
            event['type'] == 'gameFull' || event['type'] == 'gameState')
        .map((json) => GameEvent.fromJson(json))
        .handleError((Object error) => _log.warning(error));
  }

  TaskEither<IOError, void> playMoveTask(GameId gameId, Move move) {
    return apiClient.post(
        Uri.parse('$kLichessHost/api/board/game/$gameId/move/${move.uci}'),
        retry: true);
  }

  TaskEither<IOError, void> abortTask(GameId gameId) {
    return apiClient.post(
        Uri.parse('$kLichessHost/api/board/game/$gameId/abort'),
        retry: true);
  }

  TaskEither<IOError, void> resignTask(GameId gameId) {
    return apiClient.post(
        Uri.parse('$kLichessHost/api/board/game/$gameId/resign'),
        retry: true);
  }

  void dispose() {
    apiClient.close();
  }
}

// --

ArchivedGame _makeArchivedGamefromJson(Map<String, dynamic> json) =>
    _archivedGamefromPick(pick(json).required());

ArchivedGame _archivedGamefromPick(RequiredPick pick) {
  return ArchivedGame(
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
  );
}

Player _playerFromUserGamePick(RequiredPick pick) {
  return Player(
    id: pick('user', 'id').asStringOrNull(),
    name: pick('user', 'name').asStringOrNull() ?? 'Stockfish',
    patron: pick('user', 'patron').asBoolOrNull(),
    title: pick('user', 'title').asStringOrNull(),
    rating: pick('rating').asIntOrNull(),
    ratingDiff: pick('ratingDiff').asIntOrNull(),
    aiLevel: pick('aiLevel').asIntOrNull(),
  );
}
