import 'package:logging/logging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import 'package:lichess_mobile/src/common/http.dart';
import 'package:lichess_mobile/src/features/leaderboard/model/leaderboard.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/common/errors.dart';

class LeaderboardRepository {
  const LeaderboardRepository({required this.apiClient, required Logger logger})
      : _log = logger;

  final ApiClient apiClient;
  final Logger _log;

  TaskEither<IOError, Leaderboard> getLeaderboard() {
    return apiClient
        .get(Uri.parse('$kLichessHost/api/player'))
        .flatMap((response) {
      return TaskEither.fromEither(readJsonObject(response.body,
          mapper: Leaderboard.fromJson, logger: _log));
    });
  }

  void dispose() => apiClient.close();
}

final leaderboardRepositoryProvider = Provider<LeaderboardRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final repo = LeaderboardRepository(
      apiClient: apiClient, logger: Logger('LeaderboardRepository'));
  ref.onDispose(() => repo.dispose());
  return repo;
});
