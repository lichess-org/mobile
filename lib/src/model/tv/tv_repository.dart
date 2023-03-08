import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/common/models.dart';
import 'package:logging/logging.dart';

import 'package:lichess_mobile/src/common/api_client.dart';
import 'package:lichess_mobile/src/constants.dart';
import './tv_event.dart';
import 'package:lichess_mobile/src/model/tv/tv_game_repository.dart';

import 'package:async/async.dart';

class TvRepository {
  const TvRepository(
    Logger log, {
    required this.apiClient,
  }) : _log = log;

  final ApiClient apiClient;
  final Logger _log;

  Stream<TvEvent> tvFeed() async* {
    final resp = await apiClient.stream(Uri.parse('$kLichessHost/api/tv/feed'));
    _log.fine('Start streaming TV.');
    yield* resp.stream
        .toStringStream()
        .where((event) => event.isNotEmpty && event != '\n')
        .map((event) => jsonDecode(event) as Map<String, dynamic>)
        .where((json) => json['t'] == 'featured' || json['t'] == 'fen')
        .map((json) => TvEvent.fromJson(json))
        .handleError((Object error) => _log.warning(error));
  }

  void dispose() {
    apiClient.close();
  }
}

final tvRepositoryProvider = Provider<TvRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final repo = TvRepository(Logger('TvRepository'), apiClient: apiClient);
  ref.onDispose(() => repo.dispose());
  return repo;
});

class TvStreamRepository {
  const TvStreamRepository(
    Logger log, {
    required this.apiClient,
  }) : _log = log;

  final ApiClient apiClient;
  final Logger _log;

  Stream<TvEvent> tvFeed(GameId gameId) async* {
    final resp = await apiClient
        .stream(Uri.parse('$kLichessHost/api/stream/game/$gameId'));
    _log.fine('Start streaming TV.');
    yield* resp.stream
        .toStringStream()
        .where((event) => event.isNotEmpty && event != '\n')
        .map((event) => jsonDecode(event) as Map<String, dynamic>)
        .where((json) => json['t'] == 'featured' || json['t'] == 'fen')
        .map((json) => TvEvent.fromJson(json))
        .handleError((Object error) => _log.warning(error));
  }

  void dispose() {
    apiClient.close();
  }
}

/*
final tvStreamProvider = Provider<TvStreamRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final repo =
      TvStreamRepository(Logger('TvStreamRepository'), apiClient: apiClient);
  ref.onDispose(() => repo.dispose());
  return repo;
});
*/
final tvGamesProvider = Provider<TvGameRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final repo = TvGameRepository(
    apiClient: apiClient,
    logger: Logger('TvGameRepository'),
  );
  ref.onDispose(() => repo.dispose());
  return repo;
});

final testProvider = FutureProvider.autoDispose((ref) {
  final leaderRepo = ref.watch(tvGamesProvider);
  return Result.release(leaderRepo.getTvGames());
});
