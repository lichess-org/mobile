import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/common/errors.dart';
import 'package:lichess_mobile/src/common/http.dart';
import 'package:lichess_mobile/src/constants.dart';

class GameRepository {
  const GameRepository(
    Logger log, {
    required this.apiClient,
  }) : _log = log;

  final ApiClient apiClient;
  final Logger _log;

  /// Stream the events reaching a lichess user in real time as ndjson.
  Stream<Map<String, dynamic>> events() async* {
    final resp = await apiClient
        .send(http.Request('GET', Uri.parse('$kLichessHost/api/stream/event')));
    _log.fine('Start streaming events.');
    yield* resp.stream
        .toStringStream()
        .where((event) => event.isNotEmpty && event != '\n')
        .map((event) => jsonDecode(event) as Map<String, dynamic>);
  }

  /// Stream the state of a game being played with the Board API, as ndjson.
  Stream<Map<String, dynamic>> gameStateEvents(GameId id) async* {
    final resp = await apiClient.send(http.Request(
        'GET', Uri.parse('$kLichessHost/api/board/game/stream/$id')));
    yield* resp.stream
        .toStringStream()
        .where((event) => event.isNotEmpty && event != '\n')
        .map((event) => jsonDecode(event) as Map<String, dynamic>);
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

final gameRepositoryProvider = Provider<GameRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final repo = GameRepository(Logger('GameRepository'), apiClient: apiClient);
  ref.onDispose(() => repo.dispose());
  return repo;
});
